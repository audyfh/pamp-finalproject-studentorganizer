import '../entities/activity_entity.dart';
import '../repositories/activity_repository.dart';

class GetActivityByIdUseCase {
  const GetActivityByIdUseCase(this._repository);

  final ActivityRepository _repository;

  Future<ActivityEntity?> call(String id) => _repository.fetchById(id);
}
