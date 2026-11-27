import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class DashboardQuickStats extends StatelessWidget {
  const DashboardQuickStats({
    super.key,
    required this.activeTaskCount,
    required this.todayScheduleCount,
    required this.upcomingActivityCount,
    required this.onTasksTap,
    required this.onSchedulesTap,
    required this.onActivitiesTap,
  });

  final int activeTaskCount;
  final int todayScheduleCount;
  final int upcomingActivityCount;
  final VoidCallback onTasksTap;
  final VoidCallback onSchedulesTap;
  final VoidCallback onActivitiesTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatTile(
            label: 'Tugas Aktif',
            count: activeTaskCount,
            icon: Icons.task_alt_rounded,
            color: AppColors.featureTask,
            onTap: onTasksTap,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _StatTile(
            label: 'Jadwal',
            count: todayScheduleCount,
            icon: Icons.calendar_today_rounded,
            color: AppColors.featureSchedule,
            onTap: onSchedulesTap,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _StatTile(
            label: 'Kegiatan',
            count: upcomingActivityCount,
            icon: Icons.event_available_rounded,
            color: AppColors.featureActivity,
            onTap: onActivitiesTap,
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.count,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final int count;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 18, color: color),
              ),
              const SizedBox(height: 10),
              Text(
                '$count',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.labelMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
