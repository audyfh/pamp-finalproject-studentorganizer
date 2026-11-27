import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/repositories/activity_repository_impl.dart';
import '../../domain/entities/activity_entity.dart';
import '../../domain/repositories/activity_repository.dart';
import '../../domain/usecases/create_activity_usecase.dart';
import '../../domain/usecases/delete_activity_usecase.dart';
import '../../domain/usecases/get_activities_usecase.dart';
import '../../domain/usecases/get_activity_by_id_usecase.dart';
import '../../domain/usecases/update_activity_usecase.dart';

class ActivityProvider extends ChangeNotifier {
  ActivityProvider({
    ActivityRepository? repository,
    GetActivitiesUseCase? getActivitiesUseCase,
    GetActivityByIdUseCase? getActivityByIdUseCase,
    CreateActivityUseCase? createActivityUseCase,
    UpdateActivityUseCase? updateActivityUseCase,
    DeleteActivityUseCase? deleteActivityUseCase,
  }) : this._internal(
          repository ?? ActivityRepositoryImpl(),
          getActivitiesUseCase: getActivitiesUseCase,
          getActivityByIdUseCase: getActivityByIdUseCase,
          createActivityUseCase: createActivityUseCase,
          updateActivityUseCase: updateActivityUseCase,
          deleteActivityUseCase: deleteActivityUseCase,
        );

  ActivityProvider._internal(
    ActivityRepository repo, {
    GetActivitiesUseCase? getActivitiesUseCase,
    GetActivityByIdUseCase? getActivityByIdUseCase,
    CreateActivityUseCase? createActivityUseCase,
    UpdateActivityUseCase? updateActivityUseCase,
    DeleteActivityUseCase? deleteActivityUseCase,
  })  : _getActivities = getActivitiesUseCase ?? GetActivitiesUseCase(repo),
        _getActivityById =
            getActivityByIdUseCase ?? GetActivityByIdUseCase(repo),
        _createActivity = createActivityUseCase ?? CreateActivityUseCase(repo),
        _updateActivity = updateActivityUseCase ?? UpdateActivityUseCase(repo),
        _deleteActivity = deleteActivityUseCase ?? DeleteActivityUseCase(repo);

  final GetActivitiesUseCase _getActivities;
  final GetActivityByIdUseCase _getActivityById;
  final CreateActivityUseCase _createActivity;
  final UpdateActivityUseCase _updateActivity;
  final DeleteActivityUseCase _deleteActivity;

  List<ActivityEntity> _activities = const [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _hasLoaded = false;

  List<ActivityEntity> get activities => _activities;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<ActivityEntity> get upcomingActivities {
    final now = DateTime.now();
    return _activities.where((a) => !a.isPast(now)).toList();
  }

  List<ActivityEntity> get pastActivities {
    final now = DateTime.now();
    return _activities.where((a) => a.isPast(now)).toList();
  }

  Future<void> ensureLoaded() async {
    if (_hasLoaded) return;
    await loadActivities();
  }

  Future<void> loadActivities() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _activities = await _getActivities();
      _hasLoaded = true;
    } on PostgrestException catch (e) {
      _errorMessage = e.message.isNotEmpty
          ? 'Gagal memuat kegiatan: ${e.message}'
          : 'Gagal memuat data kegiatan. Silakan coba lagi.';
    } catch (_) {
      _errorMessage = 'Gagal memuat data kegiatan. Silakan coba lagi.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  ActivityEntity? findById(String id) {
    return _activities.where((a) => a.id == id).firstOrNull;
  }

  Future<ActivityEntity?> fetchById(String id) => _getActivityById(id);

  Future<ActivityEntity> addActivity(ActivityEntity activity) async {
    final created = await _createActivity(activity);
    await loadActivities();
    return created;
  }

  Future<ActivityEntity> updateActivity(ActivityEntity activity) async {
    final updated = await _updateActivity(activity);
    await loadActivities();
    return updated;
  }

  Future<void> deleteActivity(String id) async {
    await _deleteActivity(id);
    _activities = _activities.where((a) => a.id != id).toList();
    notifyListeners();
  }
}
