class DashboardTaskItem {
  const DashboardTaskItem({
    required this.id,
    required this.title,
    required this.courseName,
    required this.deadline,
    required this.status,
  });

  final String id;
  final String title;
  final String courseName;
  final DateTime deadline;
  final String status;

  bool get isDone => status.toLowerCase() == 'selesai';

  bool isOverdue([DateTime? reference]) {
    final now = reference ?? DateTime.now();
    return !isDone && deadline.isBefore(now);
  }
}

class DashboardScheduleItem {
  const DashboardScheduleItem({
    required this.id,
    required this.courseName,
    required this.timeRange,
    required this.room,
    required this.lecturer,
  });

  final String id;
  final String courseName;
  final String timeRange;
  final String room;
  final String lecturer;
}

class DashboardNoteItem {
  const DashboardNoteItem({
    required this.id,
    required this.title,
    required this.courseName,
    required this.snippet,
    required this.updatedAt,
  });

  final String id;
  final String title;
  final String courseName;
  final String snippet;
  final DateTime updatedAt;
}

class DashboardActivityItem {
  const DashboardActivityItem({
    required this.id,
    required this.name,
    required this.formattedDate,
    required this.formattedTimeRange,
    required this.location,
    required this.organizer,
  });

  final String id;
  final String name;
  final String formattedDate;
  final String formattedTimeRange;
  final String location;
  final String organizer;
}

class DashboardSummaryEntity {
  const DashboardSummaryEntity({
    required this.userName,
    required this.upcomingTasks,
    required this.todaySchedules,
    required this.recentNotes,
    required this.upcomingActivities,
    required this.activeTaskCount,
    required this.todayScheduleCount,
    required this.upcomingActivityCount,
  });

  final String userName;
  final List<DashboardTaskItem> upcomingTasks;
  final List<DashboardScheduleItem> todaySchedules;
  final List<DashboardNoteItem> recentNotes;
  final List<DashboardActivityItem> upcomingActivities;
  final int activeTaskCount;
  final int todayScheduleCount;
  final int upcomingActivityCount;
}
