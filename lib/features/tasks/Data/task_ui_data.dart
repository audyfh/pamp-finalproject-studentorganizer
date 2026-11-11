class TaskUiData {
  const TaskUiData({
    required this.id,
    required this.title,
    required this.course,
    required this.deadline,
    required this.description,
    required this.status,
  });

  final String id;
  final String title;
  final String course;
  final DateTime deadline;
  final String description;
  final String status;

  static final List<TaskUiData> samples = [
    TaskUiData(
      id: '1',
      title: 'Membuat Laporan Praktikum',
      course: 'Pemrograman Mobile',
      deadline: DateTime(2026, 11, 8),
      description: 'Membuat laporan praktikum Flutter dan mengumpulkannya dalam format PDF.',
      status: 'Sedang',
    ),
    TaskUiData(
      id: '2',
      title: 'Tugas Normalisasi Database',
      course: 'Basis Data',
      deadline: DateTime(2026, 11, 10),
      description: 'Mengerjakan normalisasi database hingga bentuk normal ketiga (3NF).',
      status: 'Belum',
    ),
    TaskUiData(
      id: '3',
      title: 'Presentasi UI/UX',
      course: 'Interaksi Manusia dan Komputer',
      deadline: DateTime(2026, 11, 12),
      description: 'Menyiapkan materi dan slide presentasi rancangan aplikasi.',
      status: 'Selesai',
    ),
  ];
}

String formatTaskDate(DateTime date) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
    'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
  ];
  return '${date.day} ${months[date.month - 1]} ${date.year}';
}
