import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_spacing.dart';

/// Halaman Detail Tugas — Fitur 1 (PJ: Novita)
class TaskDetailPage extends StatelessWidget {
  const TaskDetailPage({super.key, required this.taskId});

  final String taskId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Tugas'),
        actions: [
          IconButton(
            tooltip: 'Edit Tugas',
            onPressed: () => context.push('/tasks/$taskId/edit'),
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: AppSpacing.screenPadding,
        child: Center(
          child: Text('Placeholder Detail Tugas (ID: $taskId)'),
        ),
      ),
    );
  }
}
