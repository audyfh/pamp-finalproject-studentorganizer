import '../entities/activity_entity.dart';
import '../repositories/activity_repository.dart';

class UpdateActivityUseCase {
  const UpdateActivityUseCase(this._repository);

  final ActivityRepository _repository;

  Future<ActivityEntity> call(ActivityEntity activity) =>
      _repository.update(activity);
}
