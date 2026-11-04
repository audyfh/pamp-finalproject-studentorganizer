import '../../domain/repositories/activity_repository.dart';
import '../models/activity_model.dart';

class ActivityRepositoryImpl implements ActivityRepository {
  ActivityRepositoryImpl({List<Map<String, dynamic>>? initialRows})
      : _rows = List<Map<String, dynamic>>.from(initialRows ?? _seedRows());

  final List<Map<String, dynamic>> _rows;

  static List<Map<String, dynamic>> _seedRows() {
    final today = DateTime.now();
    final tomorrow = today.add(const Duration(days: 1));
    final nextWeek = today.add(const Duration(days: 5));
    final lastWeek = today.subtract(const Duration(days: 4));

    return [
      {
        'id': 'act-1',
        'name': 'Rapat Pleno BEM Fakultas Ilmu Komputer',
        'activity_date': ActivityModel.formatDateForDb(tomorrow),
        'start_time': '15:30:00',
        'end_time': '17:30:00',
        'location': 'Gedung F Lantai 2 (Ruang F2.4)',
        'organizer': 'BEM FILKOM',
        'description':
            'Pembahasan evaluasi program kerja tengah semester dan persiapan acara tahunan.',
        'created_at': today.toIso8601String(),
        'updated_at': today.toIso8601String(),
      },
      {
        'id': 'act-2',
        'name': 'Seminar Nasional AI & Multiplatform Development',
        'activity_date': ActivityModel.formatDateForDb(nextWeek),
        'start_time': '08:30:00',
        'end_time': '12:00:00',
        'location': 'Auditorium Algoritma Gedung G',
        'organizer': 'Himpunan Mahasiswa Informatika',
        'description':
            'Wajib membawa KTM. Sertifikat peserta akan dibagikan setelah sesi tanya jawab.',
        'created_at': today.toIso8601String(),
        'updated_at': today.toIso8601String(),
      },
      {
        'id': 'act-3',
        'name': 'Koordinasi Panitia PKKMB Jurusan',
        'activity_date': ActivityModel.formatDateForDb(lastWeek),
        'start_time': '13:00:00',
        'end_time': '15:00:00',
        'location': 'Gazebo Perpustakaan Pusat',
        'organizer': 'Panitia Divisi Acara',
        'description': 'Gladi kotor susunan acara hari pertama.',
        'created_at': lastWeek.toIso8601String(),
        'updated_at': lastWeek.toIso8601String(),
      },
    ];
  }

  @override
  Future<List<ActivityModel>> fetchAll() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final list = _rows.map(ActivityModel.fromJson).toList();
    list.sort(_compareActivities);
    return list;
  }

  @override
  Future<ActivityModel?> fetchById(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    final match = _rows.where((r) => r['id'] == id).firstOrNull;
    return match != null ? ActivityModel.fromJson(match) : null;
  }

  @override
  Future<ActivityModel> insert(ActivityModel activity) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final nowIso = DateTime.now().toIso8601String();
    final row = <String, dynamic>{
      'id': 'act-${DateTime.now().microsecondsSinceEpoch}',
      ...activity.toInsertJson(),
      'created_at': nowIso,
      'updated_at': nowIso,
    };
    _rows.add(row);
    return ActivityModel.fromJson(row);
  }

  @override
  Future<ActivityModel> update(ActivityModel activity) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final index = _rows.indexWhere((r) => r['id'] == activity.id);
    if (index == -1) {
      throw StateError('Kegiatan dengan ID ${activity.id} tidak ditemukan.');
    }
    final updatedRow = <String, dynamic>{
      ..._rows[index],
      ...activity.toUpdateJson(),
      'updated_at': DateTime.now().toIso8601String(),
    };
    _rows[index] = updatedRow;
    return ActivityModel.fromJson(updatedRow);
  }

  @override
  Future<void> delete(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    _rows.removeWhere((r) => r['id'] == id);
  }

  static int _compareActivities(ActivityModel a, ActivityModel b) {
    final dateCompare = a.activityDate.compareTo(b.activityDate);
    if (dateCompare != 0) return dateCompare;
    return ActivityModel.compareTime(a.startTime, b.startTime);
  }
}
