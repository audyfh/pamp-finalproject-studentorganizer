import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../data/models/note_model.dart';
import '../../data/note_formatters.dart';

/// Card catatan yang dipakai oleh tampilan grid maupun list.
///
/// Pada grid (tinggi sel tetap) gunakan [fillHeight] agar cuplikan isi
/// mengisi sisa ruang; pada list biarkan `false` agar tinggi mengikuti isi.
class NoteCard extends StatelessWidget {
  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    this.fillHeight = false,
  });

  final Note note;
  final VoidCallback onTap;
  final bool fillHeight;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final snippet = Text(
      note.content,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: textTheme.bodyMedium,
    );

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        onTap: onTap,
        child: Padding(
          padding: AppSpacing.cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: fillHeight ? MainAxisSize.max : MainAxisSize.min,
            children: [
              Text(
                note.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (note.courseName != null) ...[
                const SizedBox(height: AppSpacing.sm),
                CourseChip(label: note.courseName!),
              ],
              const SizedBox(height: AppSpacing.sm),
              if (fillHeight) Expanded(child: snippet) else snippet,
              const SizedBox(height: AppSpacing.sm),
              Text(
                NoteFormatters.relativeDay(note.updatedAt),
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Label kecil nama mata kuliah.
class CourseChip extends StatelessWidget {
  const CourseChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.onPrimaryContainer,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
