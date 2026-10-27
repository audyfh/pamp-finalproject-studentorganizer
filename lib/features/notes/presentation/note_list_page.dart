import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../data/models/note_model.dart';
import '../data/note_repository.dart';
import 'widgets/note_card.dart';

/// Halaman Daftar Catatan — Fitur 3 (PJ: Mifzal)
class NoteListPage extends StatefulWidget {
  const NoteListPage({super.key});

  @override
  State<NoteListPage> createState() => _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage> {
  final _repo = NoteRepository.instance;
  final _searchController = TextEditingController();

  bool _loading = true;
  String? _error;
  bool _gridView = true;
  String _query = '';
  String? _course;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load({bool refresh = false}) async {
    if (!refresh) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }
    try {
      await _repo.fetchAll();
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = null;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Gagal memuat catatan. Periksa koneksi internet Anda.';
      });
    }
  }

  List<Note> _filter(List<Note> all, String? course) {
    final q = _query.trim().toLowerCase();
    return all.where((n) {
      if (course != null && n.courseName != course) return false;
      if (q.isEmpty) return true;
      return n.title.toLowerCase().contains(q) ||
          n.content.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Materi'),
        actions: [
          IconButton(
            tooltip: _gridView ? 'Tampilan Daftar' : 'Tampilan Grid',
            onPressed: () => setState(() => _gridView = !_gridView),
            icon: Icon(
              _gridView ? Icons.view_agenda_outlined : Icons.grid_view_outlined,
            ),
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/notes/new'),
        tooltip: 'Tambah Catatan',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return _MessageView(
        icon: Icons.cloud_off_outlined,
        title: _error!,
        action: FilledButton(
          onPressed: _load,
          child: const Text('Coba lagi'),
        ),
      );
    }

    return ListenableBuilder(
      listenable: _repo,
      builder: (context, _) {
        final all = _repo.notes;
        final courses = <String>{
          for (final n in all)
            if (n.courseName != null) n.courseName!,
        }.toList()
          ..sort();
        // Filter dibatalkan otomatis bila mata kuliahnya sudah tidak punya catatan.
        final activeCourse = courses.contains(_course) ? _course : null;
        final filtered = _filter(all, activeCourse);

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.sm,
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _query = value),
                decoration: InputDecoration(
                  hintText: 'Cari judul atau isi catatan...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'Hapus pencarian',
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _query = '');
                          },
                        ),
                ),
              ),
            ),
            if (courses.isNotEmpty)
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  itemCount: courses.length + 1,
                  separatorBuilder: (_, _) =>
                      const SizedBox(width: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final label = index == 0 ? 'Semua' : courses[index - 1];
                    final value = index == 0 ? null : courses[index - 1];
                    return ChoiceChip(
                      label: Text(label),
                      selected: activeCourse == value,
                      onSelected: (_) => setState(() => _course = value),
                    );
                  },
                ),
              ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => _load(refresh: true),
                child: _buildResults(all, filtered),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildResults(List<Note> all, List<Note> filtered) {
    if (all.isEmpty) {
      return const _MessageView(
        icon: Icons.sticky_note_2_outlined,
        title: 'Belum ada catatan.\nTekan + untuk menambah.',
      );
    }
    if (filtered.isEmpty) {
      return const _MessageView(
        icon: Icons.search_off_outlined,
        title: 'Tidak ada catatan yang cocok.',
      );
    }

    void open(Note note) => context.push('/notes/${note.id}');

    if (!_gridView) {
      return ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: AppSpacing.screenPadding,
        itemCount: filtered.length,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
        itemBuilder: (context, index) => NoteCard(
          note: filtered[index],
          onTap: () => open(filtered[index]),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width >= 900 ? 4 : (width >= 600 ? 3 : 2);
        return GridView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: AppSpacing.screenPadding,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: AppSpacing.sm,
            mainAxisSpacing: AppSpacing.sm,
            mainAxisExtent: 200,
          ),
          itemCount: filtered.length,
          itemBuilder: (context, index) => NoteCard(
            note: filtered[index],
            fillHeight: true,
            onTap: () => open(filtered[index]),
          ),
        );
      },
    );
  }
}

/// Empty / error / no-result state. Berupa `ListView` agar tetap bisa
/// di-pull-to-refresh.
class _MessageView extends StatelessWidget {
  const _MessageView({required this.icon, required this.title, this.action});

  final IconData icon;
  final String title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: constraints.maxHeight,
              child: Center(
                child: Padding(
                  padding: AppSpacing.screenPadding,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, size: 56, color: AppColors.featureNote),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                      if (action != null) ...[
                        const SizedBox(height: AppSpacing.md),
                        action!,
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
