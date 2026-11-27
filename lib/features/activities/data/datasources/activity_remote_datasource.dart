import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/activity_model.dart';

abstract class ActivityRemoteDataSource {
  Future<List<ActivityModel>> fetchAll();

  Future<ActivityModel?> fetchById(String id);

  Future<ActivityModel> insert(ActivityModel activity);

  Future<ActivityModel> update(ActivityModel activity);

  Future<void> delete(String id);
}

class ActivityRemoteDataSourceImpl implements ActivityRemoteDataSource {
  ActivityRemoteDataSourceImpl([this._client]);

  final SupabaseClient? _client;

  SupabaseClient get _db => _client ?? Supabase.instance.client;

  static const String _table = 'activities';

  @override
  Future<List<ActivityModel>> fetchAll() async {
    final rows = await _db
        .from(_table)
        .select()
        .order('activity_date', ascending: true)
        .order('start_time', ascending: true);
    return rows.map(ActivityModel.fromJson).toList();
  }

  @override
  Future<ActivityModel?> fetchById(String id) async {
    final row = await _db.from(_table).select().eq('id', id).maybeSingle();
    return row != null ? ActivityModel.fromJson(row) : null;
  }

  @override
  Future<ActivityModel> insert(ActivityModel activity) async {
    final row = await _db
        .from(_table)
        .insert(activity.toInsertJson())
        .select()
        .single();
    return ActivityModel.fromJson(row);
  }

  @override
  Future<ActivityModel> update(ActivityModel activity) async {
    final row = await _db
        .from(_table)
        .update(activity.toUpdateJson())
        .eq('id', activity.id)
        .select()
        .single();
    return ActivityModel.fromJson(row);
  }

  @override
  Future<void> delete(String id) async {
    await _db.from(_table).delete().eq('id', id);
  }
}
