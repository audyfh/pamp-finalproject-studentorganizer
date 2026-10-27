import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_spacing.dart';

/// Halaman Detail Jadwal Kuliah — Fitur 2 (PJ: Alifah)
class ScheduleDetailPage extends StatelessWidget {
  const ScheduleDetailPage({super.key, required this.scheduleId});

  final String scheduleId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Jadwal'),
        actions: [
          IconButton(
            tooltip: 'Edit Jadwal',
            onPressed: () => context.push('/schedules/$scheduleId/edit'),
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: AppSpacing.screenPadding,
        child: Center(
          child: Text('Placeholder Detail Jadwal Kuliah (ID: $scheduleId)'),
        ),
      ),
    );
  }
}
