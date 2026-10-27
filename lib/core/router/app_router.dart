import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/activities/presentation/activity_detail_page.dart';
import '../../features/activities/presentation/activity_form_page.dart';
import '../../features/activities/presentation/activity_list_page.dart';
import '../../features/auth/presentation/login_page.dart';
import '../../features/auth/presentation/profile_page.dart';
import '../../features/auth/presentation/register_page.dart';
import '../../features/dashboard/presentation/dashboard_page.dart';
import '../../features/notes/presentation/note_detail_page.dart';
import '../../features/notes/presentation/note_form_page.dart';
import '../../features/notes/presentation/note_list_page.dart';
import '../../features/schedules/presentation/schedule_detail_page.dart';
import '../../features/schedules/presentation/schedule_form_page.dart';
import '../../features/schedules/presentation/schedule_list_page.dart';
import '../../features/tasks/presentation/task_detail_page.dart';
import '../../features/tasks/presentation/task_form_page.dart';
import '../../features/tasks/presentation/task_list_page.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

/// Konfigurasi rute utama aplikasi menggunakan `go_router`.
/// Catatan untuk anggota kelompok:
/// Rute untuk 4 fitur utama sudah didaftarkan di sini. Anda TIDAK PERLU
/// mengubah file ini untuk mengerjakan halaman Daftar, Detail, maupun Form.
final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  // shortcut: redirect auth belum diaktifkan sampai Supabase diinisialisasi, aktifkan saat mengerjakan FR-AUTH-03
  routes: [
    // ===== Rute Autentikasi & Profil =====
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/profile',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const ProfilePage(),
    ),

    // ===== Shell Utama (5 Tab Bottom Navigation Bar / Navigation Rail) =====
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainShellScaffold(navigationShell: navigationShell);
      },
      branches: [
        // Tab 0: Beranda (Dashboard)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const DashboardPage(),
            ),
          ],
        ),

        // Tab 1: Fitur 1 — Tugas (PJ: Novita)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/tasks',
              builder: (context, state) => const TaskListPage(),
              routes: [
                GoRoute(
                  path: 'new',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (context, state) => const TaskFormPage(),
                ),
                GoRoute(
                  path: ':id',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (context, state) => TaskDetailPage(
                    taskId: state.pathParameters['id']!,
                  ),
                  routes: [
                    GoRoute(
                      path: 'edit',
                      parentNavigatorKey: rootNavigatorKey,
                      builder: (context, state) => TaskFormPage(
                        taskId: state.pathParameters['id'],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),

        // Tab 2: Fitur 2 — Jadwal Kuliah (PJ: Alifah)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/schedules',
              builder: (context, state) => const ScheduleListPage(),
              routes: [
                GoRoute(
                  path: 'new',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (context, state) => const ScheduleFormPage(),
                ),
                GoRoute(
                  path: ':id',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (context, state) => ScheduleDetailPage(
                    scheduleId: state.pathParameters['id']!,
                  ),
                  routes: [
                    GoRoute(
                      path: 'edit',
                      parentNavigatorKey: rootNavigatorKey,
                      builder: (context, state) => ScheduleFormPage(
                        scheduleId: state.pathParameters['id'],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),

        // Tab 3: Fitur 3 — Catatan / Notes (PJ: Mifzal)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/notes',
              builder: (context, state) => const NoteListPage(),
              routes: [
                GoRoute(
                  path: 'new',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (context, state) => const NoteFormPage(),
                ),
                GoRoute(
                  path: ':id',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (context, state) => NoteDetailPage(
                    noteId: state.pathParameters['id']!,
                  ),
                  routes: [
                    GoRoute(
                      path: 'edit',
                      parentNavigatorKey: rootNavigatorKey,
                      builder: (context, state) => NoteFormPage(
                        noteId: state.pathParameters['id'],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),

        // Tab 4: Fitur 4 — Kegiatan Mahasiswa (PJ: Audy)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/activities',
              builder: (context, state) => const ActivityListPage(),
              routes: [
                GoRoute(
                  path: 'new',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (context, state) => const ActivityFormPage(),
                ),
                GoRoute(
                  path: ':id',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (context, state) => ActivityDetailPage(
                    activityId: state.pathParameters['id']!,
                  ),
                  routes: [
                    GoRoute(
                      path: 'edit',
                      parentNavigatorKey: rootNavigatorKey,
                      builder: (context, state) => ActivityFormPage(
                        activityId: state.pathParameters['id'],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);

/// Shell Navigasi Utama yang responsif (SRS §6.1):
/// - Layar HP (< 840px): Bottom `NavigationBar`
/// - Layar Lebar / Web (>= 840px): Samping `NavigationRail`
class MainShellScaffold extends StatelessWidget {
  const MainShellScaffold({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  static const _destinations = [
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: 'Beranda',
    ),
    NavigationDestination(
      icon: Icon(Icons.assignment_outlined),
      selectedIcon: Icon(Icons.assignment),
      label: 'Tugas',
    ),
    NavigationDestination(
      icon: Icon(Icons.calendar_today_outlined),
      selectedIcon: Icon(Icons.calendar_today),
      label: 'Jadwal',
    ),
    NavigationDestination(
      icon: Icon(Icons.sticky_note_2_outlined),
      selectedIcon: Icon(Icons.sticky_note_2),
      label: 'Catatan',
    ),
    NavigationDestination(
      icon: Icon(Icons.event_outlined),
      selectedIcon: Icon(Icons.event),
      label: 'Kegiatan',
    ),
  ];

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.sizeOf(context).width >= 840;

    if (isWideScreen) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: _onTap,
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: Text('Beranda'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.assignment_outlined),
                  selectedIcon: Icon(Icons.assignment),
                  label: Text('Tugas'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.calendar_today_outlined),
                  selectedIcon: Icon(Icons.calendar_today),
                  label: Text('Jadwal'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.sticky_note_2_outlined),
                  selectedIcon: Icon(Icons.sticky_note_2),
                  label: Text('Catatan'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.event_outlined),
                  selectedIcon: Icon(Icons.event),
                  label: Text('Kegiatan'),
                ),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(child: navigationShell),
          ],
        ),
      );
    }

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onTap,
        destinations: _destinations,
      ),
    );
  }
}
