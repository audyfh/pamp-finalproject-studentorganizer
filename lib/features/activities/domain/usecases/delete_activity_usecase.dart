import '../repositories/activity_repository.dart';

class DeleteActivityUseCase {
  const DeleteActivityUseCase(this._repository);

  final ActivityRepository _repository;

  Future<void> call(String id) => _repository.delete(id);
}
