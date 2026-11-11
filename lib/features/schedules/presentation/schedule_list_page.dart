
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/schedule_repository.dart';
import '../data/models/schedule_model.dart';

class ScheduleListPage extends StatefulWidget {
  const ScheduleListPage({super.key});

  @override
  State<ScheduleListPage> createState() => _ScheduleListPageState();
}

class _ScheduleListPageState extends State<ScheduleListPage> {
  final ScheduleRepository _repository = ScheduleRepository.instance;

  String _selectedDay = 'Semua';

  final List<String> _days = [
    'Semua',
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jadwal Kuliah'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter berdasarkan hari
          SizedBox(
            height: 60,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              scrollDirection: Axis.horizontal,
              itemCount: _days.length,
              separatorBuilder: (context, index) =>
              const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final day = _days[index];
                final isSelected = _selectedDay == day;

                return ChoiceChip(
                  label: Text(day),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedDay = day;
                    });
                  },
                );
              },
            ),
          ),

          // Daftar jadwal
          Expanded(
            child: ListenableBuilder(
              listenable: _repository,
              builder: (context, child) {
                final List<Schedule> schedules =
                _selectedDay == 'Semua'
                    ? _repository.schedules
                    : _repository.getByDay(_selectedDay);

                if (schedules.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 56,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Belum ada jadwal untuk hari $_selectedDay',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: schedules.length,
                  separatorBuilder: (context, index) =>
                  const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final schedule = schedules[index];

                    return Card(
                      elevation: 1,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        title: Text(
                          schedule.courseName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${schedule.day}, '
                                    '${schedule.startTime} - ${schedule.endTime}',
                              ),
                              const SizedBox(height: 4),
                              Text('Ruangan: ${schedule.room}'),
                              Text('Dosen: ${schedule.lecturer}'),
                            ],
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          context.push('/schedules/${schedule.id}');
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      // Tombol tambah jadwal
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/schedules/new');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}