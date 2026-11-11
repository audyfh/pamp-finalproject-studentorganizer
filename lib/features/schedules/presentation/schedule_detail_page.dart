
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/schedule_repository.dart';
import '../data/models/schedule_model.dart';

class ScheduleDetailPage extends StatelessWidget {
  final String scheduleId;

  const ScheduleDetailPage({
    super.key,
    required this.scheduleId,
  });

  void _deleteSchedule(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Jadwal?'),
          content: const Text(
            'Apakah kamu yakin ingin menghapus jadwal ini?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                ScheduleRepository.instance.deleteSchedule(scheduleId);

                Navigator.pop(dialogContext);
                context.pop();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Jadwal berhasil dihapus'),
                  ),
                );
              },
              child: const Text(
                'Hapus',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailItem(
      BuildContext context,
      IconData icon,
      String label,
      String value,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Schedule? schedule =
    ScheduleRepository.instance.getById(scheduleId);

    if (schedule == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Detail Jadwal'),
        ),
        body: const Center(
          child: Text('Jadwal tidak ditemukan'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Jadwal'),
        actions: [
          IconButton(
            tooltip: 'Hapus Jadwal',
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _deleteSchedule(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              schedule.courseName,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Column(
                  children: [
                    _buildDetailItem(
                      context,
                      Icons.calendar_today_outlined,
                      'Hari',
                      schedule.day,
                    ),
                    const Divider(),
                    _buildDetailItem(
                      context,
                      Icons.access_time,
                      'Waktu',
                      '${schedule.startTime} - ${schedule.endTime}',
                    ),
                    const Divider(),
                    _buildDetailItem(
                      context,
                      Icons.room_outlined,
                      'Ruangan',
                      schedule.room,
                    ),
                    const Divider(),
                    _buildDetailItem(
                      context,
                      Icons.person_outline,
                      'Dosen',
                      schedule.lecturer,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.push('/schedules/$scheduleId/edit');
                },
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Edit Jadwal'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}