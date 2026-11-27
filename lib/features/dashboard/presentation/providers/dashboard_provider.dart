import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/entities/dashboard_summary_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../domain/usecases/get_dashboard_summary_usecase.dart';

class DashboardProvider extends ChangeNotifier {
  DashboardProvider({
    DashboardRepository? repository,
    GetDashboardSummaryUseCase? getDashboardSummaryUseCase,
  }) : _getDashboardSummary = getDashboardSummaryUseCase ??
            GetDashboardSummaryUseCase(
              repository ?? DashboardRepositoryImpl(),
            );

  final GetDashboardSummaryUseCase _getDashboardSummary;

  DashboardSummaryEntity? _summary;
  bool _isLoading = false;
  String? _errorMessage;
  bool _hasLoaded = false;

  DashboardSummaryEntity? get summary => _summary;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> ensureLoaded() async {
    if (_hasLoaded) return;
    await loadDashboard();
  }

  Future<void> loadDashboard() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _summary = await _getDashboardSummary();
      _hasLoaded = true;
    } on PostgrestException catch (e) {
      _errorMessage = e.message.isNotEmpty
          ? 'Gagal memuat beranda: ${e.message}'
          : 'Gagal memuat ringkasan beranda. Silakan coba lagi.';
    } catch (_) {
      _errorMessage = 'Gagal memuat ringkasan beranda. Silakan coba lagi.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
