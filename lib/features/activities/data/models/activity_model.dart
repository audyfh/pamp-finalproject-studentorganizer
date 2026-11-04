import 'package:flutter/material.dart';

class ActivityModel {
  const ActivityModel({
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

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json['id'] as String,
      userId: json['user_id'] as String?,
      name: json['name'] as String,
      activityDate: DateTime.parse(json['activity_date'] as String),
      startTime: parseTime(json['start_time'] as String),
      endTime: parseTime(json['end_time'] as String),
      location: json['location'] as String,
      organizer: json['organizer'] as String,
      description: json['description'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toInsertJson() {
    return {
      'name': name.trim(),
      'activity_date': formatDateForDb(activityDate),
      'start_time': formatTimeForDb(startTime),
      'end_time': formatTimeForDb(endTime),
      'location': location.trim(),
      'organizer': organizer.trim(),
      'description': (description == null || description!.trim().isEmpty)
          ? null
          : description!.trim(),
    };
  }

  Map<String, dynamic> toUpdateJson() => toInsertJson();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (userId != null) 'user_id': userId,
      ...toInsertJson(),
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  ActivityModel copyWith({
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
    return ActivityModel(
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

  static TimeOfDay parseTime(String timeStr) {
    final parts = timeStr.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  static String formatTimeForDb(TimeOfDay time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m:00';
  }

  static String formatDateForDb(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

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
