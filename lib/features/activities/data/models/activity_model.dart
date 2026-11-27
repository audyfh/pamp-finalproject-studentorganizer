import 'package:flutter/material.dart';
import '../../domain/entities/activity_entity.dart';

class ActivityModel extends ActivityEntity {
  const ActivityModel({
    required super.id,
    super.userId,
    required super.name,
    required super.activityDate,
    required super.startTime,
    required super.endTime,
    required super.location,
    required super.organizer,
    super.description,
    super.createdAt,
    super.updatedAt,
  });

  factory ActivityModel.fromEntity(ActivityEntity entity) {
    return ActivityModel(
      id: entity.id,
      userId: entity.userId,
      name: entity.name,
      activityDate: entity.activityDate,
      startTime: entity.startTime,
      endTime: entity.endTime,
      location: entity.location,
      organizer: entity.organizer,
      description: entity.description,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

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
}
