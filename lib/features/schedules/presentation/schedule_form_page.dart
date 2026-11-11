
import 'package:flutter/material.dart';

import '../data/models/schedule_model.dart';
import '../data/schedule_repository.dart';

class ScheduleFormPage extends StatefulWidget {
  final String? scheduleId;

  const ScheduleFormPage({
    super.key,
    this.scheduleId,
  });

  @override
  State<ScheduleFormPage> createState() => _ScheduleFormPageState();
}

class _ScheduleFormPageState extends State<ScheduleFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _courseController = TextEditingController();
  final _roomController = TextEditingController();
  final _lecturerController = TextEditingController();

  final ScheduleRepository _repository = ScheduleRepository.instance;

  final List<String> _days = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];

  String? _selectedDay;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  bool get _isEditing => widget.scheduleId != null;

  @override
  void initState() {
    super.initState();

    if (_isEditing) {
      final schedule = _repository.getById(widget.scheduleId!);

      if (schedule != null) {
        _courseController.text = schedule.courseName;
        _roomController.text = schedule.room;
        _lecturerController.text = schedule.lecturer;
        _selectedDay = schedule.day;

        _startTime = _parseTime(schedule.startTime);
        _endTime = _parseTime(schedule.endTime);
      }
    }
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');

    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return '--:--';

    return '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _selectTime(bool isStartTime) async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: isStartTime
          ? (_startTime ?? const TimeOfDay(hour: 8, minute: 0))
          : (_endTime ?? const TimeOfDay(hour: 9, minute: 40)),
    );

    if (selectedTime == null) return;

    setState(() {
      if (isStartTime) {
        _startTime = selectedTime;
      } else {
        _endTime = selectedTime;
      }
    });
  }

  void _saveSchedule() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDay == null ||
        _startTime == null ||
        _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hari, jam mulai, dan jam selesai wajib diisi'),
        ),
      );
      return;
    }

    final startMinutes =
        _startTime!.hour * 60 + _startTime!.minute;

    final endMinutes =
        _endTime!.hour * 60 + _endTime!.minute;

    if (endMinutes <= startMinutes) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Jam selesai harus setelah jam mulai'),
        ),
      );
      return;
    }

    if (_isEditing) {
      final existingSchedule =
      _repository.getById(widget.scheduleId!);

      if (existingSchedule == null) return;

      _repository.updateSchedule(
        existingSchedule.copyWith(
          courseName: _courseController.text.trim(),
          day: _selectedDay!,
          startTime: _formatTime(_startTime),
          endTime: _formatTime(_endTime),
          room: _roomController.text.trim(),
          lecturer: _lecturerController.text.trim(),
        ),
      );
    } else {
      final newSchedule = Schedule(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        courseName: _courseController.text.trim(),
        day: _selectedDay!,
        startTime: _formatTime(_startTime),
        endTime: _formatTime(_endTime),
        room: _roomController.text.trim(),
        lecturer: _lecturerController.text.trim(),
      );

      _repository.addSchedule(newSchedule);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isEditing
              ? 'Jadwal berhasil diperbarui'
              : 'Jadwal berhasil ditambahkan',
        ),
      ),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _courseController.dispose();
    _roomController.dispose();
    _lecturerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? 'Edit Jadwal' : 'Tambah Jadwal',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nama Mata Kuliah',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _courseController,
                decoration: const InputDecoration(
                  hintText: 'Masukkan nama mata kuliah',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama mata kuliah wajib diisi';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              const Text(
                'Hari',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _selectedDay,
                decoration: const InputDecoration(
                  hintText: 'Pilih hari',
                  border: OutlineInputBorder(),
                ),
                items: _days.map((day) {
                  return DropdownMenuItem(
                    value: day,
                    child: Text(day),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDay = value;
                  });
                },
                validator: (value) {
                  if (value == null) return 'Hari wajib dipilih';
                  return null;
                },
              ),

              const SizedBox(height: 20),

              const Text(
                'Jam Kuliah',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _selectTime(true),
                      child: Text('Mulai: ${_formatTime(_startTime)}'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _selectTime(false),
                      child: Text('Selesai: ${_formatTime(_endTime)}'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              const Text(
                'Ruangan',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _roomController,
                decoration: const InputDecoration(
                  hintText: 'Masukkan ruangan',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ruangan wajib diisi';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              const Text(
                'Nama Dosen',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _lecturerController,
                decoration: const InputDecoration(
                  hintText: 'Masukkan nama dosen',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama dosen wajib diisi';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveSchedule,
                  child: Text(
                    _isEditing ? 'Simpan Perubahan' : 'Simpan Jadwal',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}