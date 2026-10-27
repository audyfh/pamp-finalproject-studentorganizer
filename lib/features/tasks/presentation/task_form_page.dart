import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';

/// Halaman Form Tambah/Edit Tugas — Fitur 1 (PJ: Novita)
/// Jika [taskId] bernilai null -> mode Tambah; jika terisi -> mode Edit.
class TaskFormPage extends StatelessWidget {
  const TaskFormPage({super.key, this.taskId});

  final String? taskId;

  bool get isEdit => taskId != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Tugas' : 'Tambah Tugas'),
      ),
      body: Padding(
        padding: AppSpacing.screenPadding,
        child: Center(
          child: Text(
            isEdit
                ? 'Placeholder Form Edit Tugas (ID: $taskId)'
                : 'Placeholder Form Tambah Tugas Baru',
          ),
        ),
      ),
    );
  }
}
