import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studentorganizer/features/activities/data/models/activity_model.dart';
import 'package:studentorganizer/features/activities/data/repositories/activity_repository_impl.dart';
import 'package:studentorganizer/main.dart';

void main() {
  test('ActivityModel serializes and deserializes Supabase JSON format', () {
    final json = {
      'id': 'uuid-123',
      'user_id': 'user-1',
      'name': 'Seminar Flutter',
      'activity_date': '2026-11-10',
      'start_time': '09:00:00',
      'end_time': '11:30:00',
      'location': 'Aula Gedung A',
      'organizer': 'BEM',
      'description': 'Bawa laptop',
      'created_at': '2026-10-27T10:00:00.000Z',
      'updated_at': '2026-10-27T10:00:00.000Z',
    };

    final model = ActivityModel.fromJson(json);
    expect(model.id, 'uuid-123');
    expect(model.name, 'Seminar Flutter');
    expect(model.activityDate, DateTime(2026, 11, 10));
    expect(model.startTime, const TimeOfDay(hour: 9, minute: 0));
    expect(model.endTime, const TimeOfDay(hour: 11, minute: 30));

    final insertPayload = model.toInsertJson();
    expect(insertPayload['activity_date'], '2026-11-10');
    expect(insertPayload['start_time'], '09:00:00');
    expect(insertPayload['end_time'], '11:30:00');
    expect(insertPayload.containsKey('id'), isFalse);
  });

  test('ActivityRepositoryImpl supports CRUD operations', () async {
    final repo = ActivityRepositoryImpl(initialRows: []);
    final created = await repo.insert(
      ActivityModel(
        id: '',
        name: 'Rapat Panitia',
        activityDate: DateTime(2026, 11, 15),
        startTime: const TimeOfDay(hour: 13, minute: 0),
        endTime: const TimeOfDay(hour: 15, minute: 0),
        location: 'Ruang 101',
        organizer: 'Himpunan',
      ),
    );

    expect(created.id, isNotEmpty);
    expect((await repo.fetchAll()).length, 1);

    final updated = await repo.update(created.copyWith(location: 'Ruang 202'));
    expect(updated.location, 'Ruang 202');

    await repo.delete(created.id);
    expect(await repo.fetchAll(), isEmpty);
  });

  testWidgets('Bottom navbar renders 5 tabs and Activities tab shows list', (
    tester,
  ) async {
    await tester.pumpWidget(const StudentOrganizerApp());
    await tester.pumpAndSettle();

    expect(find.text('Beranda'), findsOneWidget);
    expect(find.text('Tugas'), findsOneWidget);
    expect(find.text('Jadwal'), findsOneWidget);
    expect(find.text('Catatan'), findsOneWidget);
    expect(find.text('Kegiatan'), findsOneWidget);

    // Pindah ke tab Kegiatan (Audy)
    await tester.tap(find.text('Kegiatan'));
    await tester.pumpAndSettle();

    expect(find.text('Kegiatan Mahasiswa'), findsOneWidget);
    expect(find.text('Semua'), findsOneWidget);
    expect(find.text('Akan Datang'), findsOneWidget);
    expect(
      find.text('Rapat Pleno BEM Fakultas Ilmu Komputer'),
      findsOneWidget,
    );
  });
}
