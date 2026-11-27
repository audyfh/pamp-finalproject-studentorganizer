import '../../domain/entities/activity_entity.dart';
import '../../domain/repositories/activity_repository.dart';
import '../datasources/activity_remote_datasource.dart';
import '../models/activity_model.dart';

class ActivityRepositoryImpl implements ActivityRepository {
  ActivityRepositoryImpl({ActivityRemoteDataSource? remoteDataSource})
      : _remoteDataSource =
            remoteDataSource ?? ActivityRemoteDataSourceImpl();

  final ActivityRemoteDataSource _remoteDataSource;

  @override
  Future<List<ActivityEntity>> fetchAll() => _remoteDataSource.fetchAll();

  @override
  Future<ActivityEntity?> fetchById(String id) =>
      _remoteDataSource.fetchById(id);

  @override
  Future<ActivityEntity> insert(ActivityEntity activity) =>
      _remoteDataSource.insert(ActivityModel.fromEntity(activity));

  @override
  Future<ActivityEntity> update(ActivityEntity activity) =>
      _remoteDataSource.update(ActivityModel.fromEntity(activity));

  @override
  Future<void> delete(String id) => _remoteDataSource.delete(id);
}
