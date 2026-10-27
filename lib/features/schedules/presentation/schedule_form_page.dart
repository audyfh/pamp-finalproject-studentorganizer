import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';

/// Halaman Form Tambah/Edit Jadwal Kuliah — Fitur 2 (PJ: Alifah)
class ScheduleFormPage extends StatelessWidget {
  const ScheduleFormPage({super.key, this.scheduleId});

  final String? scheduleId;

  bool get isEdit => scheduleId != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Jadwal Kuliah' : 'Tambah Jadwal Kuliah'),
      ),
      body: Padding(
        padding: AppSpacing.screenPadding,
        child: Center(
          child: Text(
            isEdit
                ? 'Placeholder Form Edit Jadwal (ID: $scheduleId)'
                : 'Placeholder Form Tambah Jadwal Baru',
          ),
        ),
      ),
    );
  }
}
