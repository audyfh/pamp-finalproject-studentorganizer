import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../activities/domain/entities/activity_entity.dart';
import '../domain/entities/dashboard_summary_entity.dart';
import 'providers/dashboard_provider.dart';
import 'widgets/dashboard_greeting_banner.dart';
import 'widgets/dashboard_quick_stats.dart';
import 'widgets/dashboard_section_header.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<DashboardProvider>().ensureLoaded();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Consumer<DashboardProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading && provider.summary == null) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.errorMessage != null && provider.summary == null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.cloud_off_rounded,
                        size: 48,
                        color: AppColors.textHint,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        provider.errorMessage!,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      OutlinedButton.icon(
                        onPressed: provider.loadDashboard,
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final summary = provider.summary;
            if (summary == null) {
              return const SizedBox.shrink();
            }

            return RefreshIndicator(
              onRefresh: provider.loadDashboard,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.xl,
                ),
                children: [
                  DashboardGreetingBanner(
                    userName: summary.userName,
                    onProfileTap: () => context.push('/profile'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  DashboardQuickStats(
                    activeTaskCount: summary.activeTaskCount,
                    todayScheduleCount: summary.todayScheduleCount,
                    upcomingActivityCount: summary.upcomingActivityCount,
                    onTasksTap: () => context.go('/tasks'),
                    onSchedulesTap: () => context.go('/schedules'),
                    onActivitiesTap: () => context.go('/activities'),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // 1. Tugas Terdekat (FR-DASH-02)
                  DashboardSectionHeader(
                    title: 'Tugas Terdekat',
                    icon: Icons.task_alt_rounded,
                    accentColor: AppColors.featureTask,
                    onSeeAll: () => context.go('/tasks'),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  if (summary.upcomingTasks.isEmpty)
                    const _EmptySectionCard(
                      message: 'Semua tugas sudah beres! Tidak ada deadline aktif.',
                    )
                  else
                    for (final task in summary.upcomingTasks) ...[
                      _TaskSummaryCard(
                        task: task,
                        onTap: () => context.push('/tasks/${task.id}'),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                    ],

                  const SizedBox(height: AppSpacing.md),

                  // 2. Jadwal Hari Ini (FR-DASH-03)
                  DashboardSectionHeader(
                    title: 'Jadwal Hari Ini',
                    icon: Icons.calendar_today_rounded,
                    accentColor: AppColors.featureSchedule,
                    onSeeAll: () => context.go('/schedules'),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  if (summary.todaySchedules.isEmpty)
                    const _EmptySectionCard(
                      message: 'Tidak ada jadwal kuliah hari ini.',
                    )
                  else
                    for (final schedule in summary.todaySchedules) ...[
                      _ScheduleSummaryCard(
                        schedule: schedule,
                        onTap: () => context.push('/schedules/${schedule.id}'),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                    ],

                  const SizedBox(height: AppSpacing.md),

                  // 3. Kegiatan Mendatang (FR-DASH-05)
                  DashboardSectionHeader(
                    title: 'Kegiatan Mendatang',
                    icon: Icons.event_available_rounded,
                    accentColor: AppColors.featureActivity,
                    onSeeAll: () => context.go('/activities'),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  if (summary.upcomingActivities.isEmpty)
                    const _EmptySectionCard(
                      message: 'Belum ada kegiatan kampus mendatang.',
                    )
                  else
                    for (final activity in summary.upcomingActivities) ...[
                      _ActivitySummaryCard(
                        activity: activity,
                        onTap: () => context.push('/activities/${activity.id}'),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                    ],

                  const SizedBox(height: AppSpacing.md),

                  // 4. Catatan Terbaru (FR-DASH-04)
                  DashboardSectionHeader(
                    title: 'Catatan Terbaru',
                    icon: Icons.note_alt_outlined,
                    accentColor: AppColors.featureNote,
                    onSeeAll: () => context.go('/notes'),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  if (summary.recentNotes.isEmpty)
                    const _EmptySectionCard(
                      message: 'Belum ada catatan tersimpan.',
                    )
                  else
                    for (final note in summary.recentNotes) ...[
                      _NoteSummaryCard(
                        note: note,
                        onTap: () => context.push('/notes/${note.id}'),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                    ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _EmptySectionCard extends StatelessWidget {
  const _EmptySectionCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
      ),
    );
  }
}

class _TaskSummaryCard extends StatelessWidget {
  const _TaskSummaryCard({required this.task, required this.onTap});

  final DashboardTaskItem task;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isOverdue = task.isOverdue();
    final isInProgress = task.status.toLowerCase() == 'sedang';

    final chipColor = isOverdue
        ? AppColors.danger
        : (isInProgress ? AppColors.statusInProgress : AppColors.statusTodo);
    final chipBg = isOverdue
        ? AppColors.dangerBg
        : (isInProgress ? AppColors.statusInProgressBg : AppColors.statusTodoBg);
    final chipLabel = isOverdue ? 'Terlambat' : task.status;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        onTap: onTap,
        child: Padding(
          padding: AppSpacing.cardPadding,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${task.courseName} • ${ActivityEntity.formatDateId(task.deadline)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: chipBg,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  chipLabel,
                  style: textTheme.labelSmall?.copyWith(
                    color: chipColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScheduleSummaryCard extends StatelessWidget {
  const _ScheduleSummaryCard({required this.schedule, required this.onTap});

  final DashboardScheduleItem schedule;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        onTap: onTap,
        child: Padding(
          padding: AppSpacing.cardPadding,
          child: Row(
            children: [
              Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.featureSchedule,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      schedule.courseName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${schedule.timeRange} • Ruang ${schedule.room}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivitySummaryCard extends StatelessWidget {
  const _ActivitySummaryCard({required this.activity, required this.onTap});

  final DashboardActivityItem activity;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        onTap: onTap,
        child: Padding(
          padding: AppSpacing.cardPadding,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.featureActivity.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.event_rounded,
                  size: 20,
                  color: AppColors.featureActivity,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${activity.formattedDate} • ${activity.location}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NoteSummaryCard extends StatelessWidget {
  const _NoteSummaryCard({required this.note, required this.onTap});

  final DashboardNoteItem note;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        onTap: onTap,
        child: Padding(
          padding: AppSpacing.cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      note.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    note.courseName,
                    style: textTheme.labelSmall?.copyWith(
                      color: AppColors.featureNote,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              if (note.snippet.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  note.snippet,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
