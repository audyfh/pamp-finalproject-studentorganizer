import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../activities/data/models/activity_model.dart';
import '../../../notes/data/note_repository.dart';
import '../../../schedules/data/schedule_repository.dart';
import '../../../tasks/Data/task_ui_data.dart';
import '../models/dashboard_summary_model.dart';

abstract class DashboardRemoteDataSource {
  Future<DashboardSummaryModel> fetchSummary();
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  DashboardRemoteDataSourceImpl([this._client]);

  final SupabaseClient? _client;

  SupabaseClient get _db => _client ?? Supabase.instance.client;

  @override
  Future<DashboardSummaryModel> fetchSummary() async {
    final now = DateTime.now();
    final todayStr = ActivityModel.formatDateForDb(now);
    final userName = _resolveUserName();

    final results = await Future.wait<Object>([
      _fetchTasks(),
      _fetchTodaySchedules(now.weekday),
      _fetchRecentNotes(),
      _fetchUpcomingActivities(todayStr),
    ]);

    final allActiveTasks = results[0] as List<DashboardTaskModel>;
    final todaySchedules = results[1] as List<DashboardScheduleModel>;
    final recentNotes = results[2] as List<DashboardNoteModel>;
    final allUpcomingActivities = results[3] as List<DashboardActivityModel>;

    return DashboardSummaryModel(
      userName: userName,
      upcomingTasks: allActiveTasks.take(3).toList(),
      todaySchedules: todaySchedules,
      recentNotes: recentNotes.take(3).toList(),
      upcomingActivities: allUpcomingActivities.take(3).toList(),
      activeTaskCount: allActiveTasks.length,
      todayScheduleCount: todaySchedules.length,
      upcomingActivityCount: allUpcomingActivities.length,
    );
  }

  String _resolveUserName() {
    try {
      final user = _db.auth.currentUser;
      final fullName =
          (user?.userMetadata?['full_name'] as String?)?.trim() ?? '';
      if (fullName.isNotEmpty) return fullName;
      final email = user?.email ?? '';
      if (email.contains('@')) return email.split('@').first;
    } catch (_) {
      // Fallback jika sesi Supabase belum tersedia.
    }
    return 'Mahasiswa';
  }

  Future<List<DashboardTaskModel>> _fetchTasks() async {
    try {
      final rows = await _db
          .from('tasks')
          .select('*, courses(name)')
          .neq('status', 'selesai')
          .order('deadline', ascending: true);
      return rows.map(DashboardTaskModel.fromSupabaseJson).toList();
    } catch (_) {
      final local = TaskUiData.samples
          .where((t) => t.status.toLowerCase() != 'selesai')
          .toList()
        ..sort((a, b) => a.deadline.compareTo(b.deadline));
      return local.map(DashboardTaskModel.fromLocalTask).toList();
    }
  }

  Future<List<DashboardScheduleModel>> _fetchTodaySchedules(int weekday) async {
    try {
      final rows = await _db
          .from('schedules')
          .select()
          .eq('day_of_week', weekday)
          .order('start_time', ascending: true);
      return rows.map(DashboardScheduleModel.fromSupabaseJson).toList();
    } catch (_) {
      const days = [
        'Senin',
        'Selasa',
        'Rabu',
        'Kamis',
        'Jumat',
        'Sabtu',
        'Minggu',
      ];
      final todayName = days[weekday - 1];
      return ScheduleRepository.instance
          .getByDay(todayName)
          .map(DashboardScheduleModel.fromLocalSchedule)
          .toList();
    }
  }

  Future<List<DashboardNoteModel>> _fetchRecentNotes() async {
    try {
      final rows = await _db
          .from('notes')
          .select('*, courses(name)')
          .order('updated_at', ascending: false)
          .limit(3);
      return rows.map(DashboardNoteModel.fromSupabaseJson).toList();
    } catch (_) {
      return NoteRepository.instance.notes
          .take(3)
          .map(DashboardNoteModel.fromLocalNote)
          .toList();
    }
  }

  Future<List<DashboardActivityModel>> _fetchUpcomingActivities(
    String todayStr,
  ) async {
    final rows = await _db
        .from('activities')
        .select()
        .gte('activity_date', todayStr)
        .order('activity_date', ascending: true)
        .order('start_time', ascending: true);
    return rows.map(DashboardActivityModel.fromSupabaseJson).toList();
  }
}
