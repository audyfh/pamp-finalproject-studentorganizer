import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class TaskStatusChip extends StatelessWidget {
  const TaskStatusChip({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    Color foreground;
    Color background;

    switch (status) {
      case 'Selesai':
        foreground = AppColors.statusDone;
        background = AppColors.statusDoneBg;
        break;
      case 'Sedang':
        foreground = AppColors.statusInProgress;
        background = AppColors.statusInProgressBg;
        break;
      default:
        foreground = AppColors.statusTodo;
        background = AppColors.statusTodoBg;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: foreground,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class TaskInfoRow extends StatelessWidget {
  const TaskInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              const SizedBox(height: 4),
              Text(value, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}
