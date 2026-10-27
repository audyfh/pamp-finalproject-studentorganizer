import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_spacing.dart';

/// Halaman Detail Kegiatan Mahasiswa — Fitur 4 (PJ: Audy)
class ActivityDetailPage extends StatelessWidget {
  const ActivityDetailPage({super.key, required this.activityId});

  final String activityId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Kegiatan'),
        actions: [
          IconButton(
            tooltip: 'Edit Kegiatan',
            onPressed: () => context.push('/activities/$activityId/edit'),
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: AppSpacing.screenPadding,
        child: Center(
          child: Text('Placeholder Detail Kegiatan (ID: $activityId)'),
        ),
      ),
    );
  }
}
