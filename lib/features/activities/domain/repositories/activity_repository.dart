import '../../data/models/activity_model.dart';

abstract class ActivityRepository {
  Future<List<ActivityModel>> fetchAll();

  Future<ActivityModel?> fetchById(String id);

  Future<ActivityModel> insert(ActivityModel activity);

  Future<ActivityModel> update(ActivityModel activity);

  Future<void> delete(String id);
}
