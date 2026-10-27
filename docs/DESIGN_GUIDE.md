# Panduan Desain Layar & Aturan Kolaborasi Tim
## Student Organizer

Dokumen ini adalah panduan wajib bagi seluruh anggota kelompok agar tampilan (**UI/UX**) aplikasi **Student Organizer** terlihat seragam seperti dibuat oleh satu orang, sekaligus mencegah bentrok kode (**Git Merge Conflict**).

---

## 1. Aturan Emas: "Edit Per Fitur Saja!"

Agar pekerjaan teman satu kelompok tidak saling menimpa, **setiap anggota HANYA boleh mengedit atau menambah file di dalam folder fiturnya masing-masing**.

| Anggota (PJ) | Fitur | Folder Area Kerja (Hanya Edit di Sini) |
|---|---|---|
| **Novita** | Fitur 1 — Tugas (`tasks`) | `lib/features/tasks/` |
| **Alifah** | Fitur 2 — Jadwal (`schedules`) | `lib/features/schedules/` |
| **Mifzal** | Fitur 3 — Catatan (`notes`) | `lib/features/notes/` |
| **Audy** | Fitur 4 — Kegiatan (`activities`) | `lib/features/activities/` |

### 🚫 File yang DILARANG Diubah Tanpa Koordinasi Ketua:
- `lib/main.dart`
- `lib/core/router/app_router.dart` *(Semua rute halaman Daftar, Detail, dan Form fitur kalian **sudah didaftarkan**, jadi tidak perlu diedit lagi!)*
- `lib/core/theme/*` *(Warna dan tema sudah diatur otomatis)*
- Folder fitur milik anggota lain.

### Struktur di Dalam Folder Fitur Kalian:
Saat kalian mulai mengerjakan fitur, susun file di dalam folder fitur kalian seperti ini:
```text
lib/features/<nama_fitur>/
├── data/
│   ├── models/<fitur>_model.dart         # Class data + fromJson / toJson
│   └── <fitur>_repository.dart           # Fungsi ambil/simpan data ke Supabase
├── providers/
│   └── <fitur>_provider.dart             # State management (jika pakai Provider)
└── presentation/
    ├── <fitur>_list_page.dart            # SUDAH ADA (tinggal diedit isinya)
    ├── <fitur>_detail_page.dart          # SUDAH ADA (tinggal diedit isinya)
    ├── <fitur>_form_page.dart            # SUDAH ADA (tinggal diedit isinya)
    └── widgets/                          # Buat folder ini jika butuh widget kecil (misal Card)
```

---

## 2. Cara Menggunakan Design System (Warna & Jarak)

Aplikasi ini sudah dipasangi **Material 3 Light Theme** (`lib/core/theme/app_theme.dart`). Artinya:
- `AppBar`, `Card`, `TextFormField`, `DropdownButtonFormField`, `ElevatedButton`, dan `FloatingActionButton` **sudah otomatis berwarna Biru Akademik (`#2563EB`) dan memiliki border rapi** tanpa perlu kalian styling manual!

### 2.1 Mengambil Warna (`AppColors`)
Jangan mengarang kode warna sendiri (`Colors.blue`, `Color(0xFF...)`). Import dan gunakan `AppColors`:

```dart
import '../../../core/theme/app_colors.dart';
```

| Kebutuhan | Kode yang Dipakai | Keterangan |
|---|---|---|
| Warna Utama (Biru) | `AppColors.primary` | Ikon aktif, highlight utama |
| Background Card / Box tipis | `AppColors.surfaceVariant` | Kotak info tambahan |
| Teks Judul / Utama | `AppColors.textPrimary` | Hitam tua (`#0F172A`) |
| Teks Subjudul / Keterangan | `AppColors.textSecondary` | Abu-abu tua (`#475569`) |
| Status Tugas: **Belum** | `AppColors.statusTodo` (teks) & `AppColors.statusTodoBg` (bg) | Abu-abu |
| Status Tugas: **Sedang** | `AppColors.statusInProgress` & `AppColors.statusInProgressBg` | Kuning/Amber |
| Status Tugas: **Selesai** | `AppColors.statusDone` & `AppColors.statusDoneBg` | Hijau |
| **Terlambat** / Hapus / Error | `AppColors.danger` & `AppColors.dangerBg` | Merah |

### 2.2 Mengambil Ukuran Jarak (`AppSpacing`)
Jangan menebak-nebak angka padding. Import dan gunakan `AppSpacing`:

```dart
import '../../../core/theme/app_spacing.dart';
```

- **Padding halaman utama**: `padding: AppSpacing.screenPadding` (otomatis `16px` di semua sisi).
- **Padding di dalam Card**: `padding: AppSpacing.cardPadding` (otomatis `16px`).
- **Jarak antar elemen (`SizedBox`)**:
  - Kecil (antar teks judul & subjudul): `const SizedBox(height: AppSpacing.xs)` (`4px`) atau `AppSpacing.sm` (`8px`)
  - Sedang (antar Card / antar input Form): `const SizedBox(height: AppSpacing.md)` (`16px`)
  - Besar (antar bagian/section): `const SizedBox(height: AppSpacing.lg)` (`24px`)

### 2.3 Ukuran Teks (Typography)
Gunakan style teks bawaan tema agar ukuran huruf konsisten di semua layar:
- **Judul Besar (di Detail)**: `Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)`
- **Judul Card**: `Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)`
- **Isi / Deskripsi**: `Theme.of(context).textTheme.bodyMedium`
- **Keterangan Kecil (Jam/Tanggal/Ruangan)**: `Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)`

---

## 3. Cara Pindah Halaman (Navigasi `go_router`)

Semua rute sudah disiapkan. Kalian cukup memanggil `context.push(...)` atau `context.pop()`:

```dart
import 'package:go_router/go_router.dart';
```

| Fitur | Buka Form Tambah (`+`) | Buka Halaman Detail | Buka Form Edit | Kembali ke Halaman Sebelumnya |
|---|---|---|---|---|
| **Tugas** (Novita) | `context.push('/tasks/new')` | `context.push('/tasks/${task.id}')` | `context.push('/tasks/${task.id}/edit')` | `context.pop()` |
| **Jadwal** (Alifah) | `context.push('/schedules/new')` | `context.push('/schedules/${item.id}')` | `context.push('/schedules/${item.id}/edit')` | `context.pop()` |
| **Catatan** (Mifzal) | `context.push('/notes/new')` | `context.push('/notes/${note.id}')` | `context.push('/notes/${note.id}/edit')` | `context.pop()` |
| **Kegiatan** (Audy) | `context.push('/activities/new')` | `context.push('/activities/${act.id}')` | `context.push('/activities/${act.id}/edit')` | `context.pop()` |

---

## 4. Standar Desain 3 Halaman Utama per Fitur

Setiap anggota wajib membuat **3 halaman** di fiturnya: **Daftar**, **Detail**, dan **Form (Tambah/Edit)**. Ikuti pola di bawah ini agar seragam!

### 4.1 Pola Halaman Daftar (`*_list_page.dart`)
**Aturan tampilan:**
1. Gunakan `Scaffold` dengan `AppBar(title: Text('...'))` dan `FloatingActionButton` (`Icons.add`).
2. Bungkus daftar dengan `RefreshIndicator` (tarik untuk refresh).
3. Gunakan `ListView.separated` dengan `padding: AppSpacing.screenPadding` dan pemisah `SizedBox(height: AppSpacing.sm)`. *(Khusus Fitur 3 Catatan: gunakan `GridView.builder` 2 kolom di HP, 3–4 kolom jika lebar layar >= 600px).*
4. Setiap item wajib dibungkus widget `Card` + `InkWell` (agar bisa diklik menuju halaman Detail) + `Padding(padding: AppSpacing.cardPadding, ...)`.
5. Jika data kosong, tampilkan ikon & teks ajakan di tengah layar (*Empty State*).

**Contoh kode Card yang seragam:**
```dart
Card(
  child: InkWell(
    borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
    onTap: () => context.push('/tasks/${task.id}'),
    child: Padding(
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Judul Item',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Mata Kuliah / Lokasi / Keterangan',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
    ),
  ),
)
```

---

### 4.2 Pola Halaman Detail (`*_detail_page.dart`)
**Aturan tampilan:**
1. `AppBar` memiliki tombol **Edit** (`Icons.edit_outlined`) dan **Hapus** (`Icons.delete_outline`, warna `AppColors.danger`) di bagian `actions`.
2. **Wajib ada Dialog Konfirmasi** saat tombol Hapus ditekan (jangan langsung menghapus data!).
3. Isi halaman dibungkus `SingleChildScrollView(padding: AppSpacing.screenPadding, child: Card(...))`.

**Contoh fungsi Dialog Konfirmasi Hapus (bisa langsung dicopy):**
```dart
Future<void> _confirmDelete(BuildContext context) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Hapus Data?'),
      content: const Text('Data yang dihapus tidak dapat dikembalikan.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Batal'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Hapus'),
        ),
      ],
    ),
  );

  if (confirmed == true && context.mounted) {
    // Panggil fungsi hapus ke Supabase di sini, lalu tampilkan SnackBar & kembali:
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data berhasil dihapus')),
    );
    context.pop();
  }
}
```

---

### 4.3 Pola Halaman Form Tambah & Edit (`*_form_page.dart`)
**Aturan tampilan:**
1. Satu halaman dipakai untuk **Tambah** (`id == null`) dan **Edit** (`id != null`).
2. Gunakan `Form(key: _formKey, child: ListView(padding: AppSpacing.screenPadding, children: [...]))`.
3. **Jangan menambahkan `OutlineInputBorder` manual** pada `TextFormField` atau `DropdownButtonFormField` — cukup tulis `decoration: const InputDecoration(labelText: 'Nama Tugas', hintText: '...')`, karena border sudah otomatis diatur oleh `AppTheme`!
4. Beri jarak `const SizedBox(height: AppSpacing.md)` (`16px`) di antara setiap field input.
5. Tombol Simpan di bagian bawah menggunakan `ElevatedButton` (otomatis biru & lebar penuh).

**Contoh template Form yang rapi:**
```dart
Form(
  key: _formKey,
  child: ListView(
    padding: AppSpacing.screenPadding,
    children: [
      TextFormField(
        controller: _titleController,
        decoration: const InputDecoration(
          labelText: 'Judul / Nama *',
          hintText: 'Masukkan judul...',
        ),
        validator: (value) =>
            (value == null || value.trim().isEmpty) ? 'Wajib diisi' : null,
      ),
      const SizedBox(height: AppSpacing.md),
      TextFormField(
        controller: _descController,
        maxLines: 4,
        decoration: const InputDecoration(
          labelText: 'Deskripsi',
          alignLabelWithHint: true,
        ),
      ),
      const SizedBox(height: AppSpacing.lg),
      ElevatedButton(
        onPressed: _isSaving ? null : _onSubmit,
        child: _isSaving
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : Text(isEdit ? 'Simpan Perubahan' : 'Simpan'),
      ),
    ],
  ),
)
```

---

## 5. Checklist Wajib Sebelum Mengumpulkan (Pull Request)

Sebelum menggabungkan kode kalian ke branch utama, pastikan 5 hal ini sudah terpenuhi:
- [ ] Hanya mengubah file di dalam folder `lib/features/<fitur_kalian>/`.
- [ ] Semua input wajib (`*`) sudah divalidasi (`validator:` tidak boleh kosong).
- [ ] Khusus **Jadwal** & **Kegiatan**: jam selesai sudah divalidasi harus lebih besar dari jam mulai.
- [ ] Saat tombol **Hapus** ditekan, muncul dialog konfirmasi "Batal / Hapus".
- [ ] Setelah **Simpan** atau **Hapus**, muncul pesan `SnackBar` di bawah layar.
