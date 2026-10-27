import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';

/// Halaman Form Tambah/Edit Kegiatan Mahasiswa — Fitur 4 (PJ: Audy)
class ActivityFormPage extends StatelessWidget {
  const ActivityFormPage({super.key, this.activityId});

  final String? activityId;

  bool get isEdit => activityId != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Kegiatan' : 'Tambah Kegiatan'),
      ),
      body: Padding(
        padding: AppSpacing.screenPadding,
        child: Center(
          child: Text(
            isEdit
                ? 'Placeholder Form Edit Kegiatan (ID: $activityId)'
                : 'Placeholder Form Tambah Kegiatan Baru',
          ),
        ),
      ),
    );
  }
}
