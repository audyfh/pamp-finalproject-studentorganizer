import '../entities/activity_entity.dart';
import '../repositories/activity_repository.dart';

class GetActivitiesUseCase {
  const GetActivitiesUseCase(this._repository);

  final ActivityRepository _repository;

  Future<List<ActivityEntity>> call() => _repository.fetchAll();
}
