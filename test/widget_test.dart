import 'package:flutter_test/flutter_test.dart';
import 'package:studentorganizer/main.dart';

void main() {
  testWidgets('Bottom navbar renders 5 tabs and switches screens', (tester) async {
    await tester.pumpWidget(const StudentOrganizerApp());
    await tester.pumpAndSettle();

    // Memastikan 5 tab utama tampil di Bottom Navigation Bar
    expect(find.text('Beranda'), findsOneWidget);
    expect(find.text('Tugas'), findsOneWidget);
    expect(find.text('Jadwal'), findsOneWidget);
    expect(find.text('Catatan'), findsOneWidget);
    expect(find.text('Kegiatan'), findsOneWidget);

    // Pindah ke tab Tugas
    await tester.tap(find.text('Tugas'));
    await tester.pumpAndSettle();
    expect(find.text('Tugas Kuliah'), findsOneWidget);

    // Pindah ke tab Jadwal
    await tester.tap(find.text('Jadwal'));
    await tester.pumpAndSettle();
    expect(find.text('Jadwal Kuliah'), findsOneWidget);
  });
}
