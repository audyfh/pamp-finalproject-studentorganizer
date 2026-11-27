import 'package:flutter/material.dart';

class ActivityEntity {
  const ActivityEntity({
    required this.id,
    this.userId,
    required this.name,
    required this.activityDate,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.organizer,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String? userId;
  final String name;
  final DateTime activityDate;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String location;
  final String organizer;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ActivityEntity copyWith({
    String? id,
    String? userId,
    String? name,
    DateTime? activityDate,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    String? location,
    String? organizer,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ActivityEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      activityDate: activityDate ?? this.activityDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      organizer: organizer ?? this.organizer,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool isPast([DateTime? reference]) {
    final now = reference ?? DateTime.now();
    final endDateTime = DateTime(
      activityDate.year,
      activityDate.month,
      activityDate.day,
      endTime.hour,
      endTime.minute,
    );
    return endDateTime.isBefore(now);
  }

  String get formattedDate => formatDateId(activityDate);

  String get formattedTimeRange =>
      '${formatTimeId(startTime)} – ${formatTimeId(endTime)} WIB';

  static int compareTime(TimeOfDay a, TimeOfDay b) {
    final aMinutes = a.hour * 60 + a.minute;
    final bMinutes = b.hour * 60 + b.minute;
    return aMinutes.compareTo(bMinutes);
  }

  static String formatTimeId(TimeOfDay time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h.$m';
  }

  static String formatDateId(DateTime date) {
    const days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    const months = [
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
    final dayName = days[date.weekday - 1];
    final monthName = months[date.month - 1];
    return '$dayName, ${date.day} $monthName ${date.year}';
  }
}
