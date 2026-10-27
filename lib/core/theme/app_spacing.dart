import 'package:flutter/material.dart';

/// Standar jarak (padding/margin) dan lengkungan sudut (border radius)
/// agar semua halaman buatan anggota kelompok memiliki tata letak yang konsisten.
abstract final class AppSpacing {
  // ===== Jarak / Ukuran Dasar =====
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;

  // ===== Padding Standar Layar & Card =====
  /// Padding tepi layar standar (kiri, kanan, atas, bawah = 16)
  static const EdgeInsets screenPadding = EdgeInsets.all(md);

  /// Padding di dalam Card standar (16)
  static const EdgeInsets cardPadding = EdgeInsets.all(md);

  // ===== Border Radius =====
  static const double cardRadius = 12.0;
  static const double inputRadius = 10.0;
  static const double chipRadius = 8.0;
}
