import '../entities/activity_entity.dart';

abstract class ActivityRepository {
  Future<List<ActivityEntity>> fetchAll();

  Future<ActivityEntity?> fetchById(String id);

  Future<ActivityEntity> insert(ActivityEntity activity);

  Future<ActivityEntity> update(ActivityEntity activity);

  Future<void> delete(String id);
}
