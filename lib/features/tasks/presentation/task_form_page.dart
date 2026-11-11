import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_spacing.dart';
import 'task_ui_data.dart';

class TasksFormPage extends StatefulWidget {
  const TasksFormPage({super.key, this.taskId});

  final String? taskId;

  @override
  State<TasksFormPage> createState() => _TasksFormPageState();
}

class _TasksFormPageState extends State<TasksFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _courseController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime? _deadline;
  String _status = 'Belum';

  bool get isEdit => widget.taskId != null;

  @override
  void initState() {
    super.initState();
    if (isEdit) {
      final task = TaskUiData.samples.firstWhere(
        (item) => item.id == widget.taskId,
        orElse: () => TaskUiData.samples.first,
      );
      _titleController.text = task.title;
      _courseController.text = task.course;
      _descriptionController.text = task.description;
      _deadline = task.deadline;
      _status = task.status;
    }
  }

  Future<void> _selectDeadline() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _deadline ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (selected != null) setState(() => _deadline = selected);
  }

  void _saveForm() {
    if (!_formKey.currentState!.validate()) return;
    if (_deadline == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih deadline tugas.')),
      );
      return;
    }

    // UI tahap awal: data belum dikirim ke Supabase.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isEdit
              ? 'Simulasi: perubahan tugas disimpan'
              : 'Simulasi: tugas berhasil ditambahkan',
        ),
      ),
    );
    context.pop();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _courseController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Tugas' : 'Tambah Tugas'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: AppSpacing.screenPadding,
          children: [
            Text(
              isEdit ? 'Perbarui Tugas' : 'Tugas Baru',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Lengkapi informasi tugas kuliahmu.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Nama Tugas *',
                hintText: 'Contoh: Laporan praktikum',
                prefixIcon: Icon(Icons.assignment_outlined),
              ),
              validator: (value) =>
                  value == null || value.trim().isEmpty
                      ? 'Nama tugas wajib diisi'
                      : null,
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _courseController,
              decoration: const InputDecoration(
                labelText: 'Mata Kuliah *',
                hintText: 'Masukkan nama mata kuliah',
                prefixIcon: Icon(Icons.menu_book_outlined),
              ),
              validator: (value) =>
                  value == null || value.trim().isEmpty
                      ? 'Mata kuliah wajib diisi'
                      : null,
            ),
            const SizedBox(height: AppSpacing.md),
            InkWell(
              onTap: _selectDeadline,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Deadline *',
                  prefixIcon: Icon(Icons.calendar_today_outlined),
                  suffixIcon: Icon(Icons.arrow_drop_down_rounded),
                ),
                child: Text(
                  _deadline == null
                      ? 'Pilih tanggal deadline'
                      : formatTaskDate(_deadline!),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Deskripsi',
                hintText: 'Tuliskan detail atau instruksi tugas...',
                prefixIcon: Icon(Icons.notes_rounded),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<String>(
              value: _status,
              decoration: const InputDecoration(
                labelText: 'Status Pengerjaan',
                prefixIcon: Icon(Icons.flag_outlined),
              ),
              items: const [
                DropdownMenuItem(value: 'Belum', child: Text('Belum')),
                DropdownMenuItem(value: 'Sedang', child: Text('Sedang')),
                DropdownMenuItem(value: 'Selesai', child: Text('Selesai')),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _status = value);
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saveForm,
                icon: const Icon(Icons.save_outlined),
                label: Text(isEdit ? 'Simpan Perubahan' : 'Simpan Tugas'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
