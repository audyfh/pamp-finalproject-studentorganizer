
class Schedule {
  final String id;
  final String courseName;
  final String day;
  final String startTime;
  final String endTime;
  final String room;
  final String lecturer;

  const Schedule({
    required this.id,
    required this.courseName,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.room,
    required this.lecturer,
  });

  Schedule copyWith({
    String? id,
    String? courseName,
    String? day,
    String? startTime,
    String? endTime,
    String? room,
    String? lecturer,
  }) {
    return Schedule(
      id: id ?? this.id,
      courseName: courseName ?? this.courseName,
      day: day ?? this.day,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      room: room ?? this.room,
      lecturer: lecturer ?? this.lecturer,
    );
  }
}
