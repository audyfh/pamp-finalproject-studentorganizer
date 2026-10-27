import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_spacing.dart';

/// Area Kerja Fitur 2 — Jadwal Kuliah (PJ: Alifah)
/// Silakan edit file di dalam folder `lib/features/schedules/` saja.
class ScheduleListPage extends StatelessWidget {
  const ScheduleListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jadwal Kuliah')),
      body: Padding(
        padding: AppSpacing.screenPadding,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Fitur 2: Daftar Jadwal Kuliah (PJ: Alifah)\n'
                'Edit file: lib/features/schedules/presentation/schedule_list_page.dart',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              OutlinedButton(
                onPressed: () => context.push('/schedules/contoh-id'),
                child: const Text('Coba Buka Detail Jadwal'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/schedules/new'),
        tooltip: 'Tambah Jadwal',
        child: const Icon(Icons.add),
      ),
    );
  }
}
