import 'package:flutter/material.dart';

/// Palet warna resmi aplikasi Student Organizer (Light Mode).
/// Gunakan konstanta dari class ini agar seluruh layar seragam.
abstract final class AppColors {
  // ===== Brand / Primary =====
  static const Color primary = Color(0xFF2563EB); // Academic Blue
  static const Color primaryContainer = Color(0xFFDBEAFE);
  static const Color onPrimaryContainer = Color(0xFF1E3A8A);

  static const Color secondary = Color(0xFF4F46E5); // Indigo
  static const Color secondaryContainer = Color(0xFFE0E7FF);
  static const Color onSecondaryContainer = Color(0xFF312E81);

  // ===== Neutral / Surface =====
  static const Color background = Color(0xFFF8FAFC); // Slate 50
  static const Color surface = Color(0xFFFFFFFF); // Putih bersih untuk Card
  static const Color surfaceVariant = Color(0xFFF1F5F9); // Slate 100
  static const Color border = Color(0xFFE2E8F0); // Slate 200

  // ===== Text =====
  static const Color textPrimary = Color(0xFF0F172A); // Slate 900
  static const Color textSecondary = Color(0xFF475569); // Slate 600
  static const Color textHint = Color(0xFF94A3B8); // Slate 400

  // ===== Status Tugas & Semantik (Sesuai SRS §6.1) =====
  /// Status Tugas: Belum Dikerjakan (Abu-abu)
  static const Color statusTodo = Color(0xFF64748B);
  static const Color statusTodoBg = Color(0xFFF1F5F9);

  /// Status Tugas: Sedang Dikerjakan / Peringatan (Kuning / Amber)
  static const Color statusInProgress = Color(0xFFD97706);
  static const Color statusInProgressBg = Color(0xFFFEF3C7);

  /// Status Tugas: Selesai / Berhasil (Hijau)
  static const Color statusDone = Color(0xFF16A34A);
  static const Color statusDoneBg = Color(0xFFDCFCE7);

  /// Status: Terlambat / Error / Hapus (Merah)
  static const Color danger = Color(0xFFDC2626);
  static const Color dangerBg = Color(0xFFFEE2E2);

  // ===== Aksen Ikon/Kategori Fitur (Opsional untuk mempercantik Card) =====
  static const Color featureTask = Color(0xFF2563EB); // Biru
  static const Color featureSchedule = Color(0xFF7C3AED); // Ungu
  static const Color featureNote = Color(0xFFD97706); // Amber
  static const Color featureActivity = Color(0xFF0D9488); // Teal
}
