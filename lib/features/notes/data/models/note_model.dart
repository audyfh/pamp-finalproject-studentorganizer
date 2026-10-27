/// Model data Catatan (tabel `notes`, SRS §5.2).
class Note {
  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.noteDate,
    required this.createdAt,
    required this.updatedAt,
    this.courseName,
  });

  final String id;
  final String title;
  final String content;

  /// Nama mata kuliah (hasil join `courses(name)`), bisa null.
  final String? courseName;

  /// Tanggal catatan (kolom `date`, tanpa jam).
  final DateTime noteDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  Note copyWith({
    String? title,
    String? content,
    String? courseName,
    DateTime? noteDate,
    DateTime? updatedAt,
  }) {
    return Note(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      courseName: courseName ?? this.courseName,
      noteDate: noteDate ?? this.noteDate,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Membaca baris dari Supabase, mis.
  /// `{"id": "...", "courses": {"name": "Basis Data"}, "note_date": "2026-10-26"}`.
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      courseName: (json['courses'] as Map<String, dynamic>?)?['name'] as String?,
      noteDate: DateTime.parse(json['note_date'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Payload untuk insert/update. `user_id`, `created_at`, dan `updated_at`
  /// diisi oleh database (default / trigger). `course_id` perlu di-resolve
  /// dari `courseName` oleh repository saat backend terpasang.
  Map<String, dynamic> toJson() {
    return {
      'title': title.trim(),
      'content': content.trim(),
      'note_date': noteDate.toIso8601String().split('T').first,
    };
  }
}
