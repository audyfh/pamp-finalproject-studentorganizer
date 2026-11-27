import '../../../activities/data/models/activity_model.dart';
import '../../../notes/data/models/note_model.dart';
import '../../../schedules/data/models/schedule_model.dart';
import '../../../tasks/Data/task_ui_data.dart';
import '../../domain/entities/dashboard_summary_entity.dart';

class DashboardTaskModel extends DashboardTaskItem {
  const DashboardTaskModel({
    required super.id,
    required super.title,
    required super.courseName,
    required super.deadline,
    required super.status,
  });

  factory DashboardTaskModel.fromSupabaseJson(Map<String, dynamic> json) {
    final courseName =
        (json['courses'] as Map<String, dynamic>?)?['name'] as String? ??
            'Umum';
    final rawStatus = (json['status'] as String? ?? 'belum').toLowerCase();
    final statusLabel = switch (rawStatus) {
      'sedang' => 'Sedang',
      'selesai' => 'Selesai',
      _ => 'Belum',
    };

    return DashboardTaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      courseName: courseName,
      deadline: DateTime.parse(json['deadline'] as String),
      status: statusLabel,
    );
  }

  factory DashboardTaskModel.fromLocalTask(TaskUiData task) {
    return DashboardTaskModel(
      id: task.id,
      title: task.title,
      courseName: task.course,
      deadline: task.deadline,
      status: task.status,
    );
  }
}

class DashboardScheduleModel extends DashboardScheduleItem {
  const DashboardScheduleModel({
    required super.id,
    required super.courseName,
    required super.timeRange,
    required super.room,
    required super.lecturer,
  });

  factory DashboardScheduleModel.fromSupabaseJson(Map<String, dynamic> json) {
    final start = _formatTime(json['start_time'] as String);
    final end = _formatTime(json['end_time'] as String);
    return DashboardScheduleModel(
      id: json['id'] as String,
      courseName: json['course_name'] as String,
      timeRange: '$start – $end',
      room: json['room'] as String,
      lecturer: json['lecturer'] as String,
    );
  }

  factory DashboardScheduleModel.fromLocalSchedule(Schedule schedule) {
    return DashboardScheduleModel(
      id: schedule.id,
      courseName: schedule.courseName,
      timeRange: '${schedule.startTime.replaceAll(':', '.')} – '
          '${schedule.endTime.replaceAll(':', '.')}',
      room: schedule.room,
      lecturer: schedule.lecturer,
    );
  }

  static String _formatTime(String timeStr) {
    final parts = timeStr.split(':');
    if (parts.length < 2) return timeStr;
    return '${parts[0].padLeft(2, '0')}.${parts[1].padLeft(2, '0')}';
  }
}

class DashboardNoteModel extends DashboardNoteItem {
  const DashboardNoteModel({
    required super.id,
    required super.title,
    required super.courseName,
    required super.snippet,
    required super.updatedAt,
  });

  factory DashboardNoteModel.fromSupabaseJson(Map<String, dynamic> json) {
    final courseName =
        (json['courses'] as Map<String, dynamic>?)?['name'] as String? ??
            'Catatan Umum';
    final content = (json['content'] as String? ?? '').trim();
    return DashboardNoteModel(
      id: json['id'] as String,
      title: json['title'] as String,
      courseName: courseName,
      snippet: content.replaceAll(RegExp(r'\s+'), ' '),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  factory DashboardNoteModel.fromLocalNote(Note note) {
    return DashboardNoteModel(
      id: note.id,
      title: note.title,
      courseName: note.courseName ?? 'Catatan Umum',
      snippet: note.content.replaceAll(RegExp(r'\s+'), ' ').trim(),
      updatedAt: note.updatedAt,
    );
  }
}

class DashboardActivityModel extends DashboardActivityItem {
  const DashboardActivityModel({
    required super.id,
    required super.name,
    required super.formattedDate,
    required super.formattedTimeRange,
    required super.location,
    required super.organizer,
  });

  factory DashboardActivityModel.fromSupabaseJson(Map<String, dynamic> json) {
    final model = ActivityModel.fromJson(json);
    return DashboardActivityModel(
      id: model.id,
      name: model.name,
      formattedDate: model.formattedDate,
      formattedTimeRange: model.formattedTimeRange,
      location: model.location,
      organizer: model.organizer,
    );
  }
}

class DashboardSummaryModel extends DashboardSummaryEntity {
  const DashboardSummaryModel({
    required super.userName,
    required super.upcomingTasks,
    required super.todaySchedules,
    required super.recentNotes,
    required super.upcomingActivities,
    required super.activeTaskCount,
    required super.todayScheduleCount,
    required super.upcomingActivityCount,
  });
}
