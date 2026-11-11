import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import 'task_ui_data.dart';
import 'task_ui_widgets.dart';

class TasksDetailPage extends StatelessWidget {
  const TasksDetailPage({super.key, required this.taskId});

  final String taskId;

  @override
  Widget build(BuildContext context) {
    final task = TaskUiData.samples.firstWhere(
      (item) => item.id == taskId,
      orElse: () => TaskUiData.samples.first,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Tugas'),
        actions: [
          IconButton(
            tooltip: 'Hapus',
            onPressed: () => _showDeleteDialog(context),
            icon: const Icon(Icons.delete_outline_rounded,
                color: AppColors.danger),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.assignment_rounded,
                size: 76,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                TaskStatusChip(status: task.status),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Informasi lengkap tugas kuliah',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.lg),
            Card(
              child: Padding(
                padding: AppSpacing.cardPadding,
                child: Column(
                  children: [
                    TaskInfoRow(
                      icon: Icons.menu_book_outlined,
                      label: 'Mata Kuliah',
                      value: task.course,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TaskInfoRow(
                      icon: Icons.calendar_month_outlined,
                      label: 'Deadline',
                      value: formatTaskDate(task.deadline),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TaskInfoRow(
                      icon: Icons.description_outlined,
                      label: 'Deskripsi',
                      value: task.description,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TaskInfoRow(
                      icon: Icons.flag_outlined,
                      label: 'Status Pengerjaan',
                      value: task.status,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => context.push('/tasks/${task.id}/edit'),
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Edit Tugas'),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.danger,
                ),
                onPressed: () => _showDeleteDialog(context),
                icon: const Icon(Icons.delete_outline),
                label: const Text('Hapus Tugas'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDeleteDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus tugas?'),
        content: const Text(
          'Apakah kamu yakin ingin menghapus tugas ini?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.danger,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Simulasi: tugas berhasil dihapus'),
        ),
      );
      context.pop();
    }
  }
}
