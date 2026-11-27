import '../entities/activity_entity.dart';
import '../repositories/activity_repository.dart';

class CreateActivityUseCase {
  const CreateActivityUseCase(this._repository);

  final ActivityRepository _repository;

  Future<ActivityEntity> call(ActivityEntity activity) =>
      _repository.insert(activity);
}
