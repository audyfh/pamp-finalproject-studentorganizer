import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_spacing.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Organizer'),
        actions: [
          IconButton(
            tooltip: 'Profil',
            onPressed: () => context.push('/profile'),
            icon: const Icon(Icons.account_circle_outlined),
          ),
        ],
      ),
      body: const Padding(
        padding: AppSpacing.screenPadding,
        child: Center(
          child: Text(
            'Placeholder Beranda (Dashboard)\n'
            'Ringkasan Tugas, Jadwal Hari Ini, Catatan, & Kegiatan.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
