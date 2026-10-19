import 'package:flutter/material.dart';

/// Gece spor salonu paleti: Dark Obsidian ve Neon Vurgular
abstract final class AppColors {
  // Arka Plan ve Yüzeyler (Dark Obsidian)
  static const Color background = Color(0xFF0B0E14);
  static const Color surface = Color(0xFF141923);
  static const Color surfaceVariant = Color(0xFF1E2433);
  static const Color card = Color(0xFF181E2B);
  static const Color border = Color(0xFF283042);

  // Neon Vurgular
  static const Color neonCyan = Color(0xFF00F0FF);
  static const Color neonLime = Color(0xFF10E778);
  static const Color neonCoral = Color(0xFFFF5252);
  static const Color neonAmber = Color(0xFFFFB300);

  // Su & Hidrasyon Tonları
  static const Color waterPrimary = Color(0xFF00B4D8);
  static const Color waterGlow = Color(0xFF90E0EF);

  // Metin Renkleri
  static const Color textPrimary = Color(0xFFF3F6FA);
  static const Color textSecondary = Color(0xFF8F9CAE);
  static const Color textMuted = Color(0xFF556070);
}
