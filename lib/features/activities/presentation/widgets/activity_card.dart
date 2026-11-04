import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/activity_model.dart';

class ActivityCardPalette {
  const ActivityCardPalette({
    required this.background,
    required this.dateBox,
    required this.accent,
    required this.border,
  });

  final Color background;
  final Color dateBox;
  final Color accent;
  final Color border;

  static const List<ActivityCardPalette> palettes = [
    ActivityCardPalette(
      background: Color(0xFFEFF6FF),
      dateBox: Color(0xFFDBEAFE),
      accent: Color(0xFF1D4ED8),
      border: Color(0xFFBFDBFE),
    ),
    ActivityCardPalette(
      background: Color(0xFFF5F3FF),
      dateBox: Color(0xFFEDE9FE),
      accent: Color(0xFF6D28D9),
      border: Color(0xFFDDD6FE),
    ),
    ActivityCardPalette(
      background: Color(0xFFECFDF5),
      dateBox: Color(0xFFD1FAE5),
      accent: Color(0xFF047857),
      border: Color(0xFFA7F3D0),
    ),
    ActivityCardPalette(
      background: Color(0xFFFFFBEB),
      dateBox: Color(0xFFFEF3C7),
      accent: Color(0xFFB45309),
      border: Color(0xFFFDE68A),
    ),
  ];

  static const ActivityCardPalette pastPalette = ActivityCardPalette(
    background: Color(0xFFF1F5F9),
    dateBox: Color(0xFFE2E8F0),
    accent: Color(0xFF64748B),
    border: Color(0xFFE2E8F0),
  );

  static ActivityCardPalette resolve(ActivityModel activity, {int? index}) {
    if (activity.isPast()) return pastPalette;
    final seed = index ?? activity.id.hashCode.abs();
    return palettes[seed % palettes.length];
  }
}

class ActivityCard extends StatelessWidget {
  const ActivityCard({
    super.key,
    required this.activity,
    required this.onTap,
    this.colorIndex,
  });

  final ActivityModel activity;
  final VoidCallback onTap;
  final int? colorIndex;

  static const _shortMonths = [
    'JAN',
    'FEB',
    'MAR',
    'APR',
    'MEI',
    'JUN',
    'JUL',
    'AGU',
    'SEP',
    'OKT',
    'NOV',
    'DES',
  ];

  @override
  Widget build(BuildContext context) {
    final isPast = activity.isPast();
    final palette = ActivityCardPalette.resolve(activity, index: colorIndex);
    final textTheme = Theme.of(context).textTheme;
    final monthLabel = _shortMonths[activity.activityDate.month - 1];
    final dayNumber = activity.activityDate.day.toString().padLeft(2, '0');

    return Material(
      color: palette.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: palette.border, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: palette.dateBox,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      monthLabel,
                      style: textTheme.labelSmall?.copyWith(
                        color: palette.accent,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      dayNumber,
                      style: textTheme.titleLarge?.copyWith(
                        color: palette.accent,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.organizer,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.labelMedium?.copyWith(
                        color: palette.accent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      activity.name,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                        color: isPast
                            ? AppColors.textSecondary
                            : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.schedule_rounded,
                              size: 15,
                              color: isPast
                                  ? AppColors.textSecondary
                                  : palette.accent,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              activity.formattedTimeRange,
                              style: textTheme.bodySmall?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.place_outlined,
                              size: 15,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 170),
                              child: Text(
                                activity.location,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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
