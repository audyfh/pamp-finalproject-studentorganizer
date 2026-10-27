import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';

/// Halaman Form Tambah/Edit Catatan — Fitur 3 (PJ: Mifzal)
class NoteFormPage extends StatelessWidget {
  const NoteFormPage({super.key, this.noteId});

  final String? noteId;

  bool get isEdit => noteId != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Catatan' : 'Tambah Catatan'),
      ),
      body: Padding(
        padding: AppSpacing.screenPadding,
        child: Center(
          child: Text(
            isEdit
                ? 'Placeholder Form Edit Catatan (ID: $noteId)'
                : 'Placeholder Form Tambah Catatan Baru',
          ),
        ),
      ),
    );
  }
}
