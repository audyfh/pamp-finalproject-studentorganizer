import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'models/note_model.dart';

/// Dilempar bila belum ada sesi login dan `DEV_USER_ID` tidak diisi, sehingga
/// pemilik catatan (`user_id`) tidak diketahui.
class NoteAuthException implements Exception {
  const NoteAuthException();

  @override
  String toString() => 'Anda belum login.';
}

/// Repository Catatan yang terhubung ke Supabase (SRS §5.4).
///
/// Hasil query disimpan di cache memori agar halaman bisa membaca
/// [notes], [courses], dan [getById] secara sinkron. Class ini
/// `ChangeNotifier` agar UI otomatis ter-update setelah insert / update /
/// delete.
class NoteRepository extends ChangeNotifier {
  NoteRepository._();

  static final NoteRepository instance = NoteRepository._();

  static const _select = '*, courses(name)';

  SupabaseClient get _db => Supabase.instance.client;

  List<Note> _notes = [];

  /// Nama mata kuliah → `courses.id`, untuk mengisi `course_id`.
  final Map<String, String> _courseIds = {};

  bool get isSignedIn => _db.auth.currentUser != null;

  /// Semua catatan, terakhir diperbarui di atas (FR-NOTE-03).
  List<Note> get notes {
    final sorted = [..._notes]
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return List.unmodifiable(sorted);
  }

  /// Daftar mata kuliah untuk dropdown (FR-CRS-02).
  List<String> get courses =>
      List.unmodifiable(_courseIds.keys.toList()..sort());

  Note? getById(String id) {
    for (final note in _notes) {
      if (note.id == id) return note;
    }
    return null;
  }

  /// User id dari sesi login. Selama fitur auth belum terhubung Supabase,
  /// dipakai `DEV_USER_ID` dari `.env` sebagai pemilik catatan.
  String _requireUserId() {
    final user = _db.auth.currentUser;
    if (user != null) return user.id;
    final devUserId = dotenv.env['DEV_USER_ID']?.trim() ?? '';
    if (devUserId.isEmpty) throw const NoteAuthException();
    return devUserId;
  }

  Future<List<Note>> fetchAll() async {
    final userId = _requireUserId();
    // Filter `user_id` eksplisit karena secret key melewati RLS.
    final List<Map<String, dynamic>> rows = await _db
        .from('notes')
        .select(_select)
        .eq('user_id', userId)
        .order('updated_at', ascending: false);
    _notes = rows.map(Note.fromJson).toList();
    notifyListeners();
    return notes;
  }

  /// Mengambil mata kuliah milik pengguna dari tabel `courses` (FR-CRS-02).
  Future<List<String>> fetchCourses() async {
    final userId = _requireUserId();
    final List<Map<String, dynamic>> rows = await _db
        .from('courses')
        .select('id, name')
        .eq('user_id', userId)
        .order('name');
    _courseIds
      ..clear()
      ..addEntries(
        rows.map((r) => MapEntry(r['name'] as String, r['id'] as String)),
      );
    notifyListeners();
    return courses;
  }

  Future<Note> insert({
    required String title,
    required String content,
    required String courseName,
    required DateTime noteDate,
  }) async {
    final courseId = await _resolveCourseId(courseName);
    final row = await _db
        .from('notes')
        .insert({
          ..._payload(title, content, courseId, noteDate),
          'user_id': _requireUserId(),
        })
        .select(_select)
        .single();
    final note = Note.fromJson(row);
    _notes.add(note);
    notifyListeners();
    return note;
  }

  Future<void> update(
    String id, {
    required String title,
    required String content,
    required String courseName,
    required DateTime noteDate,
  }) async {
    final courseId = await _resolveCourseId(courseName);
    // `updated_at` diperbarui oleh trigger `trg_notes_updated` (FR-NOTE-08).
    final row = await _db
        .from('notes')
        .update(_payload(title, content, courseId, noteDate))
        .eq('id', id)
        .eq('user_id', _requireUserId())
        .select(_select)
        .single();
    final index = _notes.indexWhere((n) => n.id == id);
    final note = Note.fromJson(row);
    if (index == -1) {
      _notes.add(note);
    } else {
      _notes[index] = note;
    }
    notifyListeners();
  }

  Future<void> delete(String id) async {
    final userId = _requireUserId();
    await _db.from('notes').delete().eq('id', id).eq('user_id', userId);
    _notes.removeWhere((n) => n.id == id);
    notifyListeners();
  }

  /// Menambah mata kuliah baru secara manual (FR-CRS-03).
  Future<void> addCourse(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    await _resolveCourseId(trimmed);
  }

  /// Mengembalikan `courses.id` untuk [name], membuat barisnya bila belum
  /// ada (upsert berdasarkan `user_id + name`, SRS §5.4).
  Future<String> _resolveCourseId(String name) async {
    final userId = _requireUserId();
    final trimmed = name.trim();
    final cached = _courseIds[trimmed];
    if (cached != null) return cached;

    final row = await _db
        .from('courses')
        .upsert({
          'user_id': userId,
          'name': trimmed,
        }, onConflict: 'user_id,name')
        .select('id, name')
        .single();
    final id = row['id'] as String;
    _courseIds[trimmed] = id;
    notifyListeners();
    return id;
  }

  Map<String, dynamic> _payload(
    String title,
    String content,
    String courseId,
    DateTime noteDate,
  ) {
    return {
      'title': title.trim(),
      'content': content.trim(),
      'course_id': courseId,
      'note_date': noteDate.toIso8601String().split('T').first,
    };
  }
}
