import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'core/config/supabase_config.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/activities/domain/repositories/activity_repository.dart';
import 'features/activities/presentation/providers/activity_provider.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/dashboard/domain/repositories/dashboard_repository.dart';
import 'features/dashboard/presentation/providers/dashboard_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    publishableKey: SupabaseConfig.supabaseAnonKey,
  );
  runApp(const StudentOrganizerApp());
}

class StudentOrganizerApp extends StatelessWidget {
  const StudentOrganizerApp({
    super.key,
    this.activityRepository,
    this.authRepository,
    this.dashboardRepository,
  });

  final ActivityRepository? activityRepository;
  final AuthRepository? authRepository;
  final DashboardRepository? dashboardRepository;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(repository: authRepository),
        ),
        ChangeNotifierProvider<DashboardProvider>(
          create: (_) => DashboardProvider(repository: dashboardRepository),
        ),
        ChangeNotifierProvider<ActivityProvider>(
          create: (_) => ActivityProvider(repository: activityRepository),
        ),
      ],
      child: MaterialApp.router(
        title: 'Student Organizer',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: appRouter,
      ),
    );
  }
}
