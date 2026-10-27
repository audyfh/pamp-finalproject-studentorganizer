import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_spacing.dart';

/// Area Kerja Fitur 4 — Kegiatan Mahasiswa (PJ: Audy)
/// Silakan edit file di dalam folder `lib/features/activities/` saja.
class ActivityListPage extends StatelessWidget {
  const ActivityListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kegiatan Mahasiswa')),
      body: Padding(
        padding: AppSpacing.screenPadding,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Fitur 4: Daftar Kegiatan Mahasiswa (PJ: Audy)\n'
                'Edit file: lib/features/activities/presentation/activity_list_page.dart',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              OutlinedButton(
                onPressed: () => context.push('/activities/contoh-id'),
                child: const Text('Coba Buka Detail Kegiatan'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/activities/new'),
        tooltip: 'Tambah Kegiatan',
        child: const Icon(Icons.add),
      ),
    );
  }
}
