import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:studentorganizer/core/theme/app_theme.dart';
import 'package:studentorganizer/features/activities/data/models/activity_model.dart';
import 'package:studentorganizer/features/activities/domain/entities/activity_entity.dart';
import 'package:studentorganizer/features/activities/domain/repositories/activity_repository.dart';
import 'package:studentorganizer/features/activities/presentation/providers/activity_provider.dart';
import 'package:studentorganizer/features/auth/domain/entities/auth_user_entity.dart';
import 'package:studentorganizer/features/auth/domain/repositories/auth_repository.dart';
import 'package:studentorganizer/features/auth/presentation/login_page.dart';
import 'package:studentorganizer/features/auth/presentation/providers/auth_provider.dart';
import 'package:studentorganizer/features/auth/presentation/register_page.dart';
import 'package:studentorganizer/features/dashboard/domain/entities/dashboard_summary_entity.dart';
import 'package:studentorganizer/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:studentorganizer/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:studentorganizer/main.dart';

class FakeActivityRepository implements ActivityRepository {
  FakeActivityRepository([List<ActivityEntity>? initialItems])
      : _items = List<ActivityEntity>.from(initialItems ?? []);

  final List<ActivityEntity> _items;

  @override
  Future<List<ActivityEntity>> fetchAll() async {
    return List<ActivityEntity>.from(_items);
  }

  @override
  Future<ActivityEntity?> fetchById(String id) async {
    return _items.where((e) => e.id == id).firstOrNull;
  }

  @override
  Future<ActivityEntity> insert(ActivityEntity activity) async {
    final created = activity.copyWith(
      id: 'act-${_items.length + 1}',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _items.add(created);
    return created;
  }

  @override
  Future<ActivityEntity> update(ActivityEntity activity) async {
    final index = _items.indexWhere((e) => e.id == activity.id);
    if (index == -1) {
      throw StateError('Activity ${activity.id} not found');
    }
    final updated = activity.copyWith(updatedAt: DateTime.now());
    _items[index] = updated;
    return updated;
  }

  @override
  Future<void> delete(String id) async {
    _items.removeWhere((e) => e.id == id);
  }
}

class FakeAuthRepository implements AuthRepository {
  AuthUserEntity? _user;

  @override
  AuthUserEntity? getCurrentUser() => _user;

  @override
  Future<AuthUserEntity> login({
    required String email,
    required String password,
  }) async {
    _user = AuthUserEntity(
      id: 'user-1',
      email: email,
      fullName: 'Mahasiswa Uji',
    );
    return _user!;
  }

  @override
  Future<AuthResultEntity> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    _user = AuthUserEntity(
      id: 'user-1',
      email: email,
      fullName: fullName,
    );
    return AuthResultEntity(user: _user, hasActiveSession: true);
  }

  @override
  Future<void> logout() async {
    _user = null;
  }
}

class FakeDashboardRepository implements DashboardRepository {
  @override
  Future<DashboardSummaryEntity> fetchSummary() async {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return DashboardSummaryEntity(
      userName: 'Mahasiswa Uji',
      upcomingTasks: [
        DashboardTaskItem(
          id: '1',
          title: 'Laporan Praktikum Mobile',
          courseName: 'Pemrograman Mobile',
          deadline: tomorrow,
          status: 'Sedang',
        ),
      ],
      todaySchedules: const [
        DashboardScheduleItem(
          id: 'schedule-001',
          courseName: 'Basis Data',
          timeRange: '08.00 – 09.40',
          room: 'G1.1',
          lecturer: 'Bapak Andi',
        ),
      ],
      recentNotes: [
        DashboardNoteItem(
          id: 'note-1',
          title: 'Ringkasan Normalisasi',
          courseName: 'Basis Data',
          snippet: '1NF, 2NF, 3NF untuk desain tabel relasional.',
          updatedAt: DateTime.now(),
        ),
      ],
      upcomingActivities: const [
        DashboardActivityItem(
          id: 'act-1',
          name: 'Rapat Pleno BEM',
          formattedDate: 'Besok',
          formattedTimeRange: '15.30 – 17.30 WIB',
          location: 'Ruang F2.4',
          organizer: 'BEM FILKOM',
        ),
      ],
      activeTaskCount: 1,
      todayScheduleCount: 1,
      upcomingActivityCount: 1,
    );
  }
}

void main() {
  test('ActivityModel serializes and deserializes Supabase JSON format', () {
    final json = {
      'id': 'uuid-123',
      'user_id': 'user-1',
      'name': 'Seminar Flutter',
      'activity_date': '2026-11-10',
      'start_time': '09:00:00',
      'end_time': '11:30:00',
      'location': 'Aula Gedung A',
      'organizer': 'BEM',
      'description': 'Bawa laptop',
      'created_at': '2026-10-27T10:00:00.000Z',
      'updated_at': '2026-10-27T10:00:00.000Z',
    };

    final model = ActivityModel.fromJson(json);
    expect(model, isA<ActivityEntity>());
    expect(model.id, 'uuid-123');
    expect(model.name, 'Seminar Flutter');
    expect(model.activityDate, DateTime(2026, 11, 10));
    expect(model.startTime, const TimeOfDay(hour: 9, minute: 0));
    expect(model.endTime, const TimeOfDay(hour: 11, minute: 30));

    final insertPayload = model.toInsertJson();
    expect(insertPayload['activity_date'], '2026-11-10');
    expect(insertPayload['start_time'], '09:00:00');
    expect(insertPayload['end_time'], '11:30:00');
    expect(insertPayload.containsKey('id'), isFalse);
  });

  test('ActivityProvider manages CRUD state via use cases and repository',
      () async {
    final provider = ActivityProvider(repository: FakeActivityRepository());
    await provider.loadActivities();
    expect(provider.activities, isEmpty);

    final created = await provider.addActivity(
      ActivityEntity(
        id: '',
        name: 'Rapat Panitia',
        activityDate: DateTime(2026, 11, 15),
        startTime: const TimeOfDay(hour: 13, minute: 0),
        endTime: const TimeOfDay(hour: 15, minute: 0),
        location: 'Ruang 101',
        organizer: 'Himpunan',
      ),
    );

    expect(created.id, isNotEmpty);
    expect(provider.activities.length, 1);

    final updated = await provider.updateActivity(
      created.copyWith(location: 'Ruang 202'),
    );
    expect(updated.location, 'Ruang 202');
    expect(provider.findById(created.id)?.location, 'Ruang 202');

    await provider.deleteActivity(created.id);
    expect(provider.activities, isEmpty);
  });

  test('AuthProvider handles register, login, and logout via use cases',
      () async {
    final provider = AuthProvider(repository: FakeAuthRepository());
    expect(provider.currentUser, isNull);

    final regResult = await provider.register(
      fullName: 'Budi Santoso',
      email: 'budi@student.ac.id',
      password: 'password123',
    );
    expect(regResult?.hasActiveSession, isTrue);
    expect(provider.currentUser?.fullName, 'Budi Santoso');

    await provider.logout();
    expect(provider.currentUser, isNull);

    final loggedIn = await provider.login(
      email: 'budi@student.ac.id',
      password: 'password123',
    );
    expect(loggedIn, isTrue);
    expect(provider.currentUser?.email, 'budi@student.ac.id');
  });

  testWidgets('LoginPage and RegisterPage render polished auth forms',
      (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<AuthProvider>(
        create: (_) => AuthProvider(repository: FakeAuthRepository()),
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const LoginPage(),
        ),
      ),
    );

    expect(find.text('Selamat Datang Kembali'), findsOneWidget);
    expect(find.text('Masuk'), findsOneWidget);

    await tester.pumpWidget(
      ChangeNotifierProvider<AuthProvider>(
        create: (_) => AuthProvider(repository: FakeAuthRepository()),
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const RegisterPage(),
        ),
      ),
    );

    expect(find.text('Buat Akun Baru'), findsOneWidget);
    expect(find.text('Daftar Sekarang'), findsOneWidget);
  });

  test('DashboardProvider loads summary via use case and repository', () async {
    final provider = DashboardProvider(repository: FakeDashboardRepository());
    await provider.loadDashboard();

    expect(provider.errorMessage, isNull);
    expect(provider.summary?.userName, 'Mahasiswa Uji');
    expect(provider.summary?.upcomingTasks.length, 1);
    expect(provider.summary?.todaySchedules.length, 1);
    expect(provider.summary?.upcomingActivities.length, 1);
    expect(provider.summary?.recentNotes.length, 1);
  });

  testWidgets('Bottom navbar renders 5 tabs and Activities tab shows list', (
    tester,
  ) async {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final fakeRepo = FakeActivityRepository([
      ActivityEntity(
        id: 'act-1',
        name: 'Rapat Pleno BEM Fakultas Ilmu Komputer',
        activityDate: tomorrow,
        startTime: const TimeOfDay(hour: 15, minute: 30),
        endTime: const TimeOfDay(hour: 17, minute: 30),
        location: 'Gedung F Lantai 2 (Ruang F2.4)',
        organizer: 'BEM FILKOM',
      ),
    ]);

    await tester.pumpWidget(
      StudentOrganizerApp(
        activityRepository: fakeRepo,
        authRepository: FakeAuthRepository(),
        dashboardRepository: FakeDashboardRepository(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Mahasiswa Uji'), findsOneWidget);
    expect(find.text('Tugas Terdekat'), findsOneWidget);

    final navBar = find.byType(NavigationBar);
    expect(find.descendant(of: navBar, matching: find.text('Beranda')), findsOneWidget);
    expect(find.descendant(of: navBar, matching: find.text('Tugas')), findsOneWidget);
    expect(find.descendant(of: navBar, matching: find.text('Jadwal')), findsOneWidget);
    expect(find.descendant(of: navBar, matching: find.text('Catatan')), findsOneWidget);
    expect(find.descendant(of: navBar, matching: find.text('Kegiatan')), findsOneWidget);

    await tester.tap(
      find.descendant(of: navBar, matching: find.text('Kegiatan')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Kegiatan Mahasiswa'), findsOneWidget);
    expect(find.text('Semua'), findsOneWidget);
    expect(find.text('Akan Datang'), findsOneWidget);
    expect(
      find.text('Rapat Pleno BEM Fakultas Ilmu Komputer'),
      findsOneWidget,
    );

    await tester.tap(find.text('Kegiatan Baru'));
    await tester.pumpAndSettle();

    expect(find.text('Nama Kegiatan'), findsOneWidget);
  });
}
