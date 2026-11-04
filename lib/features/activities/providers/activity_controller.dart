import 'package:flutter/foundation.dart';
import '../data/models/activity_model.dart';
import '../data/repositories/activity_repository_impl.dart';
import '../domain/repositories/activity_repository.dart';

class ActivityController extends ChangeNotifier {
  ActivityController({ActivityRepository? repository})
      : _repository = repository ?? ActivityRepositoryImpl();

  static final ActivityController instance = ActivityController();

  final ActivityRepository _repository;

  List<ActivityModel> _activities = const [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _hasLoaded = false;

  List<ActivityModel> get activities => _activities;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<ActivityModel> get upcomingActivities {
    final now = DateTime.now();
    return _activities.where((a) => !a.isPast(now)).toList();
  }

  List<ActivityModel> get pastActivities {
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
      _activities = await _repository.fetchAll();
      _hasLoaded = true;
    } catch (e) {
      _errorMessage = 'Gagal memuat data kegiatan. Silakan coba lagi.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  ActivityModel? findById(String id) {
    return _activities.where((a) => a.id == id).firstOrNull;
  }

  Future<ActivityModel> addActivity(ActivityModel activity) async {
    final created = await _repository.insert(activity);
    await loadActivities();
    return created;
  }

  Future<ActivityModel> updateActivity(ActivityModel activity) async {
    final updated = await _repository.update(activity);
    await loadActivities();
    return updated;
  }

  Future<void> deleteActivity(String id) async {
    await _repository.delete(id);
    _activities = _activities.where((a) => a.id != id).toList();
    notifyListeners();
  }
}
