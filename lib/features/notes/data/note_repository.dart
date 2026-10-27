import 'package:flutter/foundation.dart';

import 'models/note_model.dart';

/// Repository Catatan dengan data dummy di memori (belum terhubung Supabase).
///
/// Saat backend siap, ganti isi method di bawah dengan query Supabase
/// (SRS §5.4) dan pertahankan signature-nya, sehingga halaman tidak perlu
/// diubah. Class ini `ChangeNotifier` agar UI otomatis ter-update setelah
/// insert / update / delete.
class NoteRepository extends ChangeNotifier {
  NoteRepository._();

  static final NoteRepository instance = NoteRepository._();

  static const _latency = Duration(milliseconds: 500);

  final List<Note> _notes = _seedNotes();
  final List<String> _courses = [
    'Basis Data',
    'Jaringan Komputer',
    'Kecerdasan Buatan',
    'Pemrograman Multiplatform',
    'Rekayasa Perangkat Lunak',
    'Statistika',
  ];

  /// Semua catatan, terakhir diperbarui di atas (FR-NOTE-03).
  List<Note> get notes {
    final sorted = [..._notes]
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return List.unmodifiable(sorted);
  }

  /// Daftar mata kuliah untuk dropdown (FR-CRS-02).
  List<String> get courses => List.unmodifiable(_courses);

  Note? getById(String id) {
    for (final note in _notes) {
      if (note.id == id) return note;
    }
    return null;
  }

  Future<List<Note>> fetchAll() async {
    await Future<void>.delayed(_latency);
    return notes;
  }

  Future<Note> insert({
    required String title,
    required String content,
    required String courseName,
    required DateTime noteDate,
  }) async {
    await Future<void>.delayed(_latency);
    final now = DateTime.now();
    final note = Note(
      id: 'note-${now.microsecondsSinceEpoch}',
      title: title.trim(),
      content: content.trim(),
      courseName: courseName,
      noteDate: noteDate,
      createdAt: now,
      updatedAt: now,
    );
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
    await Future<void>.delayed(_latency);
    final index = _notes.indexWhere((n) => n.id == id);
    if (index == -1) return;
    _notes[index] = _notes[index].copyWith(
      title: title.trim(),
      content: content.trim(),
      courseName: courseName,
      noteDate: noteDate,
      updatedAt: DateTime.now(),
    );
    notifyListeners();
  }

  Future<void> delete(String id) async {
    await Future<void>.delayed(_latency);
    _notes.removeWhere((n) => n.id == id);
    notifyListeners();
  }

  /// Menambah mata kuliah baru secara manual (FR-CRS-03).
  void addCourse(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty || _courses.contains(trimmed)) return;
    _courses.add(trimmed);
    _courses.sort();
    notifyListeners();
  }

  static List<Note> _seedNotes() {
    Note n(
      int i,
      String title,
      String course,
      DateTime date,
      DateTime updated,
      String content,
    ) {
      return Note(
        id: 'note-$i',
        title: title,
        courseName: course,
        noteDate: date,
        createdAt: date,
        updatedAt: updated,
        content: content,
      );
    }

    return [
      n(
        1,
        'Widget Lifecycle di Flutter',
        'Pemrograman Multiplatform',
        DateTime(2026, 10, 26),
        DateTime(2026, 10, 26, 14, 30),
        'StatefulWidget memiliki siklus hidup yang berurutan:\n\n'
            '1. createState() dipanggil sekali saat widget dibuat.\n'
            '2. initState() untuk inisialisasi controller, listener, dan '
            'pemanggilan data awal.\n'
            '3. didChangeDependencies() dipanggil setelah initState dan saat '
            'InheritedWidget berubah.\n'
            '4. build() dipanggil setiap kali state berubah lewat setState().\n'
            '5. dispose() untuk melepas controller dan membatalkan listener.\n\n'
            'Catatan penting: jangan memanggil setState() setelah dispose. '
            'Selalu cek `mounted` sebelum setState() di dalam fungsi async.',
      ),
      n(
        2,
        'Normalisasi 1NF, 2NF, 3NF',
        'Basis Data',
        DateTime(2026, 10, 24),
        DateTime(2026, 10, 25, 19, 10),
        'Normalisasi bertujuan mengurangi redundansi dan anomali data.\n\n'
            '1NF: setiap kolom bernilai atomik, tidak ada grup yang berulang.\n'
            '2NF: sudah 1NF dan tidak ada ketergantungan parsial terhadap '
            'sebagian primary key.\n'
            '3NF: sudah 2NF dan tidak ada ketergantungan transitif antar '
            'atribut non-key.\n\n'
            'Contoh: tabel mahasiswa(nim, nama, kode_prodi, nama_prodi) '
            'melanggar 3NF karena nama_prodi bergantung pada kode_prodi. '
            'Solusinya dipecah menjadi tabel mahasiswa dan prodi.',
      ),
      n(
        3,
        'Model OSI vs TCP/IP',
        'Jaringan Komputer',
        DateTime(2026, 10, 22),
        DateTime(2026, 10, 24, 8, 45),
        'OSI memiliki 7 lapisan: Physical, Data Link, Network, Transport, '
            'Session, Presentation, Application.\n\n'
            'TCP/IP menyederhanakannya menjadi 4 lapisan: Network Access, '
            'Internet, Transport, Application.\n\n'
            'Protokol penting: IP (Internet), TCP/UDP (Transport), '
            'HTTP/DNS/SMTP (Application).',
      ),
      n(
        4,
        'Use Case Diagram',
        'Rekayasa Perangkat Lunak',
        DateTime(2026, 10, 21),
        DateTime(2026, 10, 23, 16, 20),
        'Use case diagram menggambarkan interaksi aktor dengan sistem.\n\n'
            'Elemen utama: aktor, use case, relasi association, include, '
            'dan extend.\n\n'
            'Tips: beri nama use case dengan kata kerja, misalnya '
            '"Mengelola Tugas", bukan "Tugas".',
      ),
      n(
        5,
        'Algoritma A* untuk Pencarian Jalur',
        'Kecerdasan Buatan',
        DateTime(2026, 10, 20),
        DateTime(2026, 10, 22, 10, 5),
        'A* memilih simpul dengan nilai f(n) = g(n) + h(n) terkecil.\n\n'
            'g(n) adalah biaya dari awal ke n, sedangkan h(n) adalah '
            'estimasi biaya dari n ke tujuan. Heuristik harus admissible '
            '(tidak melebihi biaya sebenarnya) agar hasilnya optimal.',
      ),
      n(
        6,
        'Distribusi Normal dan Z-Score',
        'Statistika',
        DateTime(2026, 10, 19),
        DateTime(2026, 10, 21, 13, 40),
        'Z = (x - mean) / standar deviasi.\n\n'
            'Aturan empiris: sekitar 68% data berada dalam 1 SD, 95% dalam '
            '2 SD, dan 99,7% dalam 3 SD dari rata-rata.',
      ),
      n(
        7,
        'State Management: Provider',
        'Pemrograman Multiplatform',
        DateTime(2026, 10, 15),
        DateTime(2026, 10, 19, 20, 0),
        'Provider membungkus InheritedWidget agar lebih mudah dipakai.\n\n'
            'Gunakan ChangeNotifier untuk menyimpan state dan panggil '
            'notifyListeners() setelah data berubah. Di UI, gunakan '
            'context.watch<T>() untuk mendengarkan perubahan dan '
            'context.read<T>() untuk memanggil fungsi.',
      ),
      n(
        8,
        'SQL JOIN dan Subquery',
        'Basis Data',
        DateTime(2026, 10, 12),
        DateTime(2026, 10, 18, 9, 15),
        'INNER JOIN hanya menampilkan baris yang cocok di kedua tabel. '
            'LEFT JOIN mempertahankan semua baris tabel kiri.\n\n'
            'Subquery dapat dipakai di WHERE, FROM, maupun SELECT. Untuk '
            'performa, utamakan JOIN dibanding subquery bertingkat.',
      ),
    ];
  }
}
