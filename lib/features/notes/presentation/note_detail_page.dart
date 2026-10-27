import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_spacing.dart';

/// Halaman Detail Catatan — Fitur 3 (PJ: Mifzal)
class NoteDetailPage extends StatelessWidget {
  const NoteDetailPage({super.key, required this.noteId});

  final String noteId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Catatan'),
        actions: [
          IconButton(
            tooltip: 'Edit Catatan',
            onPressed: () => context.push('/notes/$noteId/edit'),
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: AppSpacing.screenPadding,
        child: Center(
          child: Text('Placeholder Detail Catatan (ID: $noteId)'),
        ),
      ),
    );
  }
}
