import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../data/models/note_model.dart';
import '../data/note_formatters.dart';
import '../data/note_repository.dart';
import 'widgets/note_card.dart';

/// Halaman Detail Catatan — Fitur 3 (PJ: Mifzal)
///
/// Memakai `PageView` agar pengguna bisa swipe ke catatan sebelum/sesudahnya
/// (FR-NOTE-05). Urutan catatan diambil sekali saat halaman dibuka, sehingga
/// urutan tidak melompat ketika sebuah catatan diedit.
class NoteDetailPage extends StatefulWidget {
  const NoteDetailPage({super.key, required this.noteId});

  final String noteId;

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  final _repo = NoteRepository.instance;

  late final List<String> _ids;
  late final PageController _controller;
  late int _index;

  @override
  void initState() {
    super.initState();
    _ids = [for (final n in _repo.notes) n.id];
    final initial = _ids.indexOf(widget.noteId);
    _index = initial < 0 ? 0 : initial;
    _controller = PageController(initialPage: _index);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _currentId => _ids[_index];

  Future<void> _confirmDelete(BuildContext context) async {
    final id = _currentId;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Catatan?'),
        content: const Text('Data yang dihapus tidak dapat dikembalikan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    await _repo.delete(id);
    if (!context.mounted) return;
    messenger.showSnackBar(
      const SnackBar(content: Text('Catatan berhasil dihapus')),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    if (_ids.isEmpty || !_ids.contains(widget.noteId)) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Catatan')),
        body: Center(
          child: Text(
            'Catatan tidak ditemukan.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Catatan'),
        actions: [
          IconButton(
            tooltip: 'Edit Catatan',
            onPressed: () => context.push('/notes/$_currentId/edit'),
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            tooltip: 'Hapus Catatan',
            onPressed: () => _confirmDelete(context),
            icon: const Icon(Icons.delete_outline, color: AppColors.danger),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListenableBuilder(
              listenable: _repo,
              builder: (context, _) => PageView.builder(
                controller: _controller,
                itemCount: _ids.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (context, i) {
                  final note = _repo.getById(_ids[i]);
                  if (note == null) return const SizedBox.shrink();
                  return _NoteDetailView(note: note);
                },
              ),
            ),
          ),
          if (_ids.length > 1)
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.swipe,
                      size: 16,
                      color: AppColors.textHint,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      '${_index + 1} / ${_ids.length} · Geser untuk catatan lain',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _NoteDetailView extends StatelessWidget {
  const _NoteDetailView({required this.note});

  final Note note;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final small = textTheme.bodySmall?.copyWith(color: AppColors.textSecondary);

    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Card(
        child: Padding(
          padding: AppSpacing.cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.title,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (note.courseName != null)
                    CourseChip(label: note.courseName!),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(NoteFormatters.fullDate(note.noteDate), style: small),
                    ],
                  ),
                ],
              ),
              const Divider(height: AppSpacing.lg * 2),
              Text(
                note.content,
                style: textTheme.bodyMedium?.copyWith(height: 1.6),
              ),
              const SizedBox(height: AppSpacing.lg),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.sm + AppSpacing.xs),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dibuat: ${NoteFormatters.dateTime(note.createdAt)}',
                      style: small,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Diperbarui: ${NoteFormatters.dateTime(note.updatedAt)}',
                      style: small,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
