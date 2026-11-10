
import 'package:flutter/foundation.dart';

import 'models/schedule_model.dart';

class ScheduleRepository extends ChangeNotifier {
  static final ScheduleRepository instance = ScheduleRepository();
  // Dummy data jadwal kuliah
  final List<Schedule> _schedules = [
    const Schedule(
      id: 'schedule-001',
      courseName: 'Basis Data',
      day: 'Senin',
      startTime: '08:00',
      endTime: '09:40',
      room: 'G1.1',
      lecturer: 'Bapak Andi',
    ),
    const Schedule(
      id: 'schedule-002',
      courseName: 'Pemrograman Web',
      day: 'Senin',
      startTime: '10:00',
      endTime: '11:40',
      room: 'G2.2',
      lecturer: 'Ibu Sinta',
    ),
    const Schedule(
      id: 'schedule-003',
      courseName: 'Rekayasa Sistem Informasi',
      day: 'Selasa',
      startTime: '08:00',
      endTime: '09:40',
      room: 'G1.3',
      lecturer: 'Bapak Budi',
    ),
    const Schedule(
      id: 'schedule-004',
      courseName: 'Analisis Proses Bisnis',
      day: 'Rabu',
      startTime: '13:00',
      endTime: '14:40',
      room: 'G2.1',
      lecturer: 'Ibu Rina',
    ),
    const Schedule(
      id: 'schedule-005',
      courseName: 'Pengembangan Aplikasi Mobile',
      day: 'Kamis',
      startTime: '10:00',
      endTime: '11:40',
      room: 'Lab Komputer',
      lecturer: 'Bapak Dedi',
    ),
  ];

  // Mengambil seluruh jadwal
  List<Schedule> get schedules => List.unmodifiable(_schedules);

  // Mengambil jadwal berdasarkan ID
  Schedule? getById(String id) {
    try {
      return _schedules.firstWhere((schedule) => schedule.id == id);
    } catch (_) {
      return null;
    }
  }

  // Mengambil jadwal berdasarkan hari
  List<Schedule> getByDay(String day) {
    return _schedules
        .where((schedule) => schedule.day == day)
        .toList();
  }

  // Menambahkan jadwal
  void addSchedule(Schedule schedule) {
    _schedules.add(schedule);
    notifyListeners();
  }

  // Mengubah jadwal
  void updateSchedule(Schedule updatedSchedule) {
    final index = _schedules.indexWhere(
          (schedule) => schedule.id == updatedSchedule.id,
    );

    if (index == -1) return;

    _schedules[index] = updatedSchedule;
    notifyListeners();
  }

  // Menghapus jadwal
  void deleteSchedule(String id) {
    _schedules.removeWhere((schedule) => schedule.id == id);
    notifyListeners();
  }
}