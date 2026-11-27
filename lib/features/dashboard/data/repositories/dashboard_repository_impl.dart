import '../../domain/entities/dashboard_summary_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_datasource.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  DashboardRepositoryImpl({DashboardRemoteDataSource? remoteDataSource})
      : _remoteDataSource =
            remoteDataSource ?? DashboardRemoteDataSourceImpl();

  final DashboardRemoteDataSource _remoteDataSource;

  @override
  Future<DashboardSummaryEntity> fetchSummary() =>
      _remoteDataSource.fetchSummary();
}
