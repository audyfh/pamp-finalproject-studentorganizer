import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../data/models/activity_model.dart';
import '../providers/activity_controller.dart';
import 'widgets/activity_card.dart';

class ActivityListPage extends StatefulWidget {
  const ActivityListPage({super.key, this.controller});

  final ActivityController? controller;

  @override
  State<ActivityListPage> createState() => _ActivityListPageState();
}

class _ActivityListPageState extends State<ActivityListPage> {
  late final ActivityController _controller =
      widget.controller ?? ActivityController.instance;

  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _controller.ensureLoaded();
  }

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  static bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  List<DateTime> _buildDateStrip(List<ActivityModel> activities) {
    final today = _dateOnly(DateTime.now());
    final set = <DateTime>{
      for (int i = -2; i <= 10; i++) today.add(Duration(days: i)),
      for (final a in activities) _dateOnly(a.activityDate),
    };
    final sorted = set.toList()..sort();
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            if (_controller.isLoading && _controller.activities.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (_controller.errorMessage != null &&
                _controller.activities.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _controller.errorMessage!,
                        textAlign: TextAlign.center,
                        style: textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton(
                        onPressed: _controller.loadActivities,
                        child: const Text('Muat Ulang'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final allActivities = _controller.activities;
            final dateStrip = _buildDateStrip(allActivities);
            final activeDates = {
              for (final a in allActivities) _dateOnly(a.activityDate),
            };

            final filtered = _selectedDate == null
                ? allActivities
                : allActivities
                    .where((a) => _isSameDay(a.activityDate, _selectedDate!))
                    .toList();

            final now = DateTime.now();
            final upcoming =
                filtered.where((a) => !a.isPast(now)).toList();
            final past = filtered.where((a) => a.isPast(now)).toList();

            return RefreshIndicator(
              onRefresh: _controller.loadActivities,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Agenda Kampus',
                                  style: textTheme.labelLarge?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Kegiatan Mahasiswa',
                                  style: textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (_selectedDate != null)
                            TextButton(
                              onPressed: () =>
                                  setState(() => _selectedDate = null),
                              child: const Text('Reset Filter'),
                            ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 92,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        scrollDirection: Axis.horizontal,
                        itemCount: dateStrip.length + 1,
                        separatorBuilder: (_, _) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            final isAllSelected = _selectedDate == null;
                            return _AllDatesPill(
                              isSelected: isAllSelected,
                              onTap: () =>
                                  setState(() => _selectedDate = null),
                            );
                          }

                          final date = dateStrip[index - 1];
                          final isSelected = _selectedDate != null &&
                              _isSameDay(date, _selectedDate!);
                          final hasActivity =
                              activeDates.contains(_dateOnly(date));

                          return _DayFilterPill(
                            date: date,
                            isSelected: isSelected,
                            hasActivity: hasActivity,
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  _selectedDate = null;
                                } else {
                                  _selectedDate = date;
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  if (filtered.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceVariant,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: const Icon(
                                Icons.event_busy_outlined,
                                size: 40,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _selectedDate == null
                                  ? 'Belum ada kegiatan tercatat'
                                  : 'Tidak ada kegiatan di tanggal ini',
                              textAlign: TextAlign.center,
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _selectedDate == null
                                  ? 'Tambahkan jadwal rapat, kepanitiaan, atau seminar melalui tombol + di bawah.'
                                  : 'Pilih tanggal lain di bagian atas atau tekan Reset Filter.',
                              textAlign: TextAlign.center,
                              style: textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
                      sliver: SliverList.list(
                        children: [
                          if (upcoming.isNotEmpty) ...[
                            Text(
                              'Akan Datang',
                              style: textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            for (int i = 0; i < upcoming.length; i++) ...[
                              ActivityCard(
                                activity: upcoming[i],
                                colorIndex: i,
                                onTap: () => context.push(
                                  '/activities/${upcoming[i].id}',
                                ),
                              ),
                              const SizedBox(height: 14),
                            ],
                          ],
                          if (past.isNotEmpty) ...[
                            if (upcoming.isNotEmpty)
                              const SizedBox(height: 10),
                            Text(
                              'Riwayat Selesai',
                              style: textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            for (int i = 0; i < past.length; i++) ...[
                              ActivityCard(
                                activity: past[i],
                                onTap: () => context.push(
                                  '/activities/${past[i].id}',
                                ),
                              ),
                              const SizedBox(height: 14),
                            ],
                          ],
                        ],
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/activities/new'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Kegiatan Baru',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _AllDatesPill extends StatelessWidget {
  const _AllDatesPill({
    required this.isSelected,
    required this.onTap,
  });

  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? AppColors.primary : AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.border,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Center(
            child: Text(
              'Semua',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DayFilterPill extends StatelessWidget {
  const _DayFilterPill({
    required this.date,
    required this.isSelected,
    required this.hasActivity,
    required this.onTap,
  });

  final DateTime date;
  final bool isSelected;
  final bool hasActivity;
  final VoidCallback onTap;

  static const _shortDays = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

  @override
  Widget build(BuildContext context) {
    final dayLabel = _shortDays[date.weekday - 1];
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: isSelected ? AppColors.primary : AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.border,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: SizedBox(
          width: 58,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                dayLabel,
                style: textTheme.labelSmall?.copyWith(
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.85)
                      : AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${date.day}',
                style: textTheme.titleMedium?.copyWith(
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: !hasActivity
                      ? Colors.transparent
                      : (isSelected ? Colors.white : AppColors.primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
