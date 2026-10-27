import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../data/models/note_model.dart';
import '../data/note_formatters.dart';
import '../data/note_repository.dart';

/// Halaman Form Tambah/Edit Catatan — Fitur 3 (PJ: Mifzal)
class NoteFormPage extends StatefulWidget {
  const NoteFormPage({super.key, this.noteId});

  final String? noteId;

  bool get isEdit => noteId != null;

  @override
  State<NoteFormPage> createState() => _NoteFormPageState();
}

class _NoteFormPageState extends State<NoteFormPage> {
  /// Nilai khusus dropdown untuk opsi "+ Tambah mata kuliah baru".
  static const _addCourseValue = '__add_course__';

  final _repo = NoteRepository.instance;
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _dateController = TextEditingController();

  Note? _existing;
  String? _course;
  DateTime? _date;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      _existing = _repo.getById(widget.noteId!);
    }
    final note = _existing;
    if (note != null) {
      _titleController.text = note.title;
      _contentController.text = note.content;
      _course = note.courseName;
      _setDate(note.noteDate);
    } else if (!widget.isEdit) {
      _setDate(DateTime.now());
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _setDate(DateTime value) {
    _date = DateTime(value.year, value.month, value.day);
    _dateController.text = NoteFormatters.fullDate(_date!);
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() => _setDate(picked));
    }
  }

  Future<void> _addCourse() async {
    final name = await showDialog<String>(
      context: context,
      builder: (_) => const _AddCourseDialog(),
    );
    if (name == null || name.trim().isEmpty) return;
    _repo.addCourse(name);
    setState(() => _course = name.trim());
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      if (widget.isEdit) {
        await _repo.update(
          widget.noteId!,
          title: _titleController.text,
          content: _contentController.text,
          courseName: _course!,
          noteDate: _date!,
        );
      } else {
        await _repo.insert(
          title: _titleController.text,
          content: _contentController.text,
          courseName: _course!,
          noteDate: _date!,
        );
      }
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            widget.isEdit
                ? 'Catatan berhasil diperbarui'
                : 'Catatan berhasil ditambahkan',
          ),
        ),
      );
      context.pop();
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      messenger.showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan catatan. Coba lagi.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isEdit && _existing == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit Catatan')),
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
        title: Text(widget.isEdit ? 'Edit Catatan' : 'Tambah Catatan'),
      ),
      body: ListenableBuilder(
        listenable: _repo,
        builder: (context, _) {
          final courses = _repo.courses;
          return Form(
            key: _formKey,
            child: ListView(
              padding: AppSpacing.screenPadding,
              children: [
                TextFormField(
                  controller: _titleController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Judul Catatan *',
                    hintText: 'Masukkan judul catatan...',
                  ),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Judul catatan wajib diisi'
                      : null,
                ),
                const SizedBox(height: AppSpacing.md),
                DropdownButtonFormField<String>(
                  // Key mengikuti pilihan agar nilai awal ikut berubah saat
                  // mata kuliah baru ditambahkan lewat dialog.
                  key: ValueKey(_course),
                  initialValue: _course,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Mata Kuliah *',
                  ),
                  items: [
                    for (final c in courses)
                      DropdownMenuItem(value: c, child: Text(c)),
                    const DropdownMenuItem(
                      value: _addCourseValue,
                      child: Row(
                        children: [
                          Icon(Icons.add, size: 18, color: AppColors.primary),
                          SizedBox(width: AppSpacing.sm),
                          Text(
                            'Tambah mata kuliah baru',
                            style: TextStyle(color: AppColors.primary),
                          ),
                        ],
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    if (value == _addCourseValue) {
                      _addCourse();
                    } else {
                      setState(() => _course = value);
                    }
                  },
                  validator: (value) =>
                      value == null ? 'Mata kuliah wajib dipilih' : null,
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _dateController,
                  readOnly: true,
                  onTap: _pickDate,
                  decoration: const InputDecoration(
                    labelText: 'Tanggal Catatan *',
                    suffixIcon: Icon(Icons.calendar_today_outlined),
                  ),
                  validator: (_) =>
                      _date == null ? 'Tanggal catatan wajib diisi' : null,
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _contentController,
                  minLines: 8,
                  maxLines: 14,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Isi Catatan *',
                    hintText: 'Tulis materi di sini...',
                    alignLabelWithHint: true,
                  ),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Isi catatan wajib diisi'
                      : null,
                ),
                const SizedBox(height: AppSpacing.lg),
                ElevatedButton(
                  onPressed: _isSaving ? null : _onSubmit,
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(widget.isEdit ? 'Simpan Perubahan' : 'Simpan'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Dialog input nama mata kuliah baru (FR-CRS-03).
class _AddCourseDialog extends StatefulWidget {
  const _AddCourseDialog();

  @override
  State<_AddCourseDialog> createState() => _AddCourseDialogState();
}

class _AddCourseDialogState extends State<_AddCourseDialog> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, _controller.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Mata Kuliah Baru'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Nama Mata Kuliah *',
          ),
          validator: (value) => (value == null || value.trim().isEmpty)
              ? 'Nama mata kuliah wajib diisi'
              : null,
          onFieldSubmitted: (_) => _submit(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Tambah')),
      ],
    );
  }
}
