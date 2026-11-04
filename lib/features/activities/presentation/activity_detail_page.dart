import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/activity_controller.dart';
import 'widgets/activity_card.dart';

class ActivityDetailPage extends StatelessWidget {
  const ActivityDetailPage({
    super.key,
    required this.activityId,
    this.controller,
  });

  final String activityId;
  final ActivityController? controller;

  ActivityController get _controller =>
      controller ?? ActivityController.instance;

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: const Text('Hapus Kegiatan?'),
        content: const Text(
          'Kegiatan yang dihapus tidak dapat dikembalikan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.danger,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await _controller.deleteActivity(activityId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kegiatan berhasil dihapus')),
        );
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final activity = _controller.findById(activityId);

        if (activity == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Detail Kegiatan')),
            body: const Center(
              child: Text('Data kegiatan tidak ditemukan.'),
            ),
          );
        }

        final palette = ActivityCardPalette.resolve(activity);
        final textTheme = Theme.of(context).textTheme;
        final hasDescription = activity.description != null &&
            activity.description!.trim().isNotEmpty;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            title: const Text('Detail Kegiatan'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: palette.background,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: palette.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity.organizer,
                        style: textTheme.labelLarge?.copyWith(
                          color: palette.accent,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        activity.name,
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _InfoTileCard(
                        icon: Icons.calendar_today_rounded,
                        accentColor: palette.accent,
                        iconBgColor: palette.dateBox,
                        label: 'Tanggal',
                        value: activity.formattedDate,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _InfoTileCard(
                        icon: Icons.schedule_rounded,
                        accentColor: palette.accent,
                        iconBgColor: palette.dateBox,
                        label: 'Waktu',
                        value: activity.formattedTimeRange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _InfoTileCard(
                  icon: Icons.place_rounded,
                  accentColor: palette.accent,
                  iconBgColor: palette.dateBox,
                  label: 'Lokasi Pelaksanaan',
                  value: activity.location,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Catatan & Deskripsi',
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        hasDescription
                            ? activity.description!
                            : 'Tidak ada deskripsi tambahan untuk kegiatan ini.',
                        style: textTheme.bodyMedium?.copyWith(
                          color: hasDescription
                              ? AppColors.textSecondary
                              : AppColors.textHint,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Row(
                children: [
                  SizedBox(
                    height: 54,
                    width: 54,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        foregroundColor: AppColors.danger,
                        side: const BorderSide(color: AppColors.dangerBg),
                        backgroundColor: AppColors.dangerBg,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: () => _confirmDelete(context),
                      child: const Icon(Icons.delete_outline_rounded),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 54,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        onPressed: () =>
                            context.push('/activities/${activity.id}/edit'),
                        icon: const Icon(Icons.edit_outlined, size: 20),
                        label: const Text('Edit Kegiatan'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _InfoTileCard extends StatelessWidget {
  const _InfoTileCard({
    required this.icon,
    required this.accentColor,
    required this.iconBgColor,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color accentColor;
  final Color iconBgColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, size: 20, color: accentColor),
          ),
          const SizedBox(height: 14),
          Text(
            label,
            style: textTheme.labelMedium?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
