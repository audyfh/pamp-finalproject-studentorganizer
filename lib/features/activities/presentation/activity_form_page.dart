import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../data/models/activity_model.dart';
import '../providers/activity_controller.dart';

class ActivityFormPage extends StatefulWidget {
  const ActivityFormPage({
    super.key,
    this.activityId,
    this.controller,
  });

  final String? activityId;
  final ActivityController? controller;

  bool get isEdit => activityId != null;

  @override
  State<ActivityFormPage> createState() => _ActivityFormPageState();
}

class _ActivityFormPageState extends State<ActivityFormPage> {
  final _formKey = GlobalKey<FormState>();

  late final ActivityController _controller =
      widget.controller ?? ActivityController.instance;

  late final TextEditingController _nameController;
  late final TextEditingController _locationController;
  late final TextEditingController _organizerController;
  late final TextEditingController _descriptionController;

  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String? _dateTimeError;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final existing = widget.activityId != null
        ? _controller.findById(widget.activityId!)
        : null;

    _nameController = TextEditingController(text: existing?.name ?? '');
    _locationController = TextEditingController(text: existing?.location ?? '');
    _organizerController =
        TextEditingController(text: existing?.organizer ?? '');
    _descriptionController =
        TextEditingController(text: existing?.description ?? '');

    _selectedDate = existing?.activityDate ?? DateTime.now();
    _startTime = existing?.startTime ?? const TimeOfDay(hour: 9, minute: 0);
    _endTime = existing?.endTime ?? const TimeOfDay(hour: 11, minute: 0);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _organizerController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  InputDecoration _roundedInputDecoration(String hint) {
    final borderRadius = BorderRadius.circular(18);
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 16,
      ),
      border: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: const BorderSide(color: AppColors.danger),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: const BorderSide(color: AppColors.danger, width: 1.5),
      ),
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateTimeError = null;
      });
    }
  }

  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime ?? const TimeOfDay(hour: 9, minute: 0),
    );
    if (picked != null) {
      setState(() {
        _startTime = picked;
        _dateTimeError = null;
      });
    }
  }

  Future<void> _pickEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _endTime ?? const TimeOfDay(hour: 11, minute: 0),
    );
    if (picked != null) {
      setState(() {
        _endTime = picked;
        _dateTimeError = null;
      });
    }
  }

  bool _validateDateTime() {
    if (_selectedDate == null) {
      setState(() => _dateTimeError = 'Tanggal kegiatan wajib dipilih.');
      return false;
    }
    if (_startTime == null || _endTime == null) {
      setState(
        () => _dateTimeError = 'Waktu mulai dan selesai wajib dipilih.',
      );
      return false;
    }
    if (ActivityModel.compareTime(_endTime!, _startTime!) <= 0) {
      setState(
        () => _dateTimeError = 'Waktu selesai harus setelah waktu mulai.',
      );
      return false;
    }
    setState(() => _dateTimeError = null);
    return true;
  }

  Future<void> _onSubmit() async {
    final isFormValid = _formKey.currentState?.validate() ?? false;
    final isTimeValid = _validateDateTime();
    if (!isFormValid || !isTimeValid) return;

    setState(() => _isSaving = true);

    try {
      final model = ActivityModel(
        id: widget.activityId ?? '',
        name: _nameController.text.trim(),
        activityDate: _selectedDate!,
        startTime: _startTime!,
        endTime: _endTime!,
        location: _locationController.text.trim(),
        organizer: _organizerController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
      );

      if (widget.isEdit) {
        await _controller.updateActivity(model);
      } else {
        await _controller.addActivity(model);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.isEdit
                  ? 'Kegiatan berhasil diperbarui'
                  : 'Kegiatan berhasil ditambahkan',
            ),
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal menyimpan kegiatan. Silakan coba lagi.'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(widget.isEdit ? 'Edit Kegiatan' : 'Kegiatan Baru'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          children: [
            const _FieldLabel('Nama Kegiatan'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              textInputAction: TextInputAction.next,
              decoration: _roundedInputDecoration(
                'Contoh: Rapat Pleno BEM / Seminar AI',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nama kegiatan wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            const _FieldLabel('Penyelenggara'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _organizerController,
              textInputAction: TextInputAction.next,
              decoration: _roundedInputDecoration(
                'Contoh: BEM Fakultas / Himpunan Mahasiswa',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Penyelenggara wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            const _FieldLabel('Tanggal Pelaksanaan'),
            const SizedBox(height: 8),
            _RoundedPickerButton(
              value: _selectedDate != null
                  ? ActivityModel.formatDateId(_selectedDate!)
                  : 'Pilih tanggal',
              icon: Icons.calendar_today_rounded,
              onTap: _pickDate,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _FieldLabel('Waktu Mulai'),
                      const SizedBox(height: 8),
                      _RoundedPickerButton(
                        value: _startTime != null
                            ? '${ActivityModel.formatTimeId(_startTime!)} WIB'
                            : 'Pilih jam',
                        icon: Icons.schedule_rounded,
                        onTap: _pickStartTime,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _FieldLabel('Waktu Selesai'),
                      const SizedBox(height: 8),
                      _RoundedPickerButton(
                        value: _endTime != null
                            ? '${ActivityModel.formatTimeId(_endTime!)} WIB'
                            : 'Pilih jam',
                        icon: Icons.schedule_rounded,
                        onTap: _pickEndTime,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (_dateTimeError != null) ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  _dateTimeError!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.danger,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
            const SizedBox(height: 20),
            const _FieldLabel('Lokasi'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _locationController,
              textInputAction: TextInputAction.next,
              decoration: _roundedInputDecoration(
                'Contoh: Gedung F Ruang 2.4 / Zoom Meeting',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Lokasi wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            const _FieldLabel('Deskripsi', isRequired: false),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: _roundedInputDecoration(
                'Tambahkan catatan perlengkapan, agenda, atau tautan...',
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 54,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
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
                    : Text(
                        widget.isEdit
                            ? 'Simpan Perubahan'
                            : 'Simpan Kegiatan',
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text, {this.isRequired = true});

  final String text;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelLarge?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
        );

    return Row(
      children: [
        Text(text, style: style),
        if (!isRequired) ...[
          const SizedBox(width: 6),
          Text(
            '(Opsional)',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textHint,
                ),
          ),
        ],
      ],
    );
  }
}

class _RoundedPickerButton extends StatelessWidget {
  const _RoundedPickerButton({
    required this.value,
    required this.icon,
    required this.onTap,
  });

  final String value;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                ),
              ),
              Icon(icon, size: 18, color: AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }
}
