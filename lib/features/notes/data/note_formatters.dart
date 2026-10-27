/// Format tanggal bahasa Indonesia tanpa paket `intl`.
abstract final class NoteFormatters {
  static const _days = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];

  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];

  /// `Senin, 26 Okt 2026`
  static String fullDate(DateTime d) =>
      '${_days[d.weekday - 1]}, ${shortDate(d)}';

  /// `26 Okt 2026`
  static String shortDate(DateTime d) =>
      '${d.day} ${_months[d.month - 1]} ${d.year}';

  /// `26 Okt 2026, 14.30`
  static String dateTime(DateTime d) {
    final hh = d.hour.toString().padLeft(2, '0');
    final mm = d.minute.toString().padLeft(2, '0');
    return '${shortDate(d)}, $hh.$mm';
  }

  /// `Hari ini`, `Kemarin`, `3 hari lalu`, atau tanggal pendek.
  static String relativeDay(DateTime d, {DateTime? now}) {
    final today = _dateOnly(now ?? DateTime.now());
    final diff = today.difference(_dateOnly(d)).inDays;
    if (diff <= 0) return 'Hari ini';
    if (diff == 1) return 'Kemarin';
    if (diff < 7) return '$diff hari lalu';
    return shortDate(d);
  }

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);
}
