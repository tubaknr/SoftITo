import 'package:flutter/material.dart';

/// Design tokens and semantic colors specified in `style.md`
class AppColors {
  const AppColors._();

  // --- Light Mode Palette ---
  static const Color lightPrimary = Color(0xFF3B82F6);
  static const Color lightPrimaryLight = Color(0xFF93C5FD);
  static const Color lightPrimaryDark = Color(0xFF1E3A8A);
  static const Color lightAccentSun = Color(0xFFFDE047);
  static const Color lightAccentOrange = Color(0xFFFB923C);
  static const Color lightAccentCoral = Color(0xFFFDA4AF);

  static const Color lightSuccess = Color(0xFF10B981);
  static const Color lightSuccessLight = Color(0xFFD1FAE5);
  static const Color lightWarning = Color(0xFFF59E0B);
  static const Color lightInfo = Color(0xFF06B6D4);

  static const Color lightBgApp = Color(0xFFF0F7FF);
  static const Color lightBgCard = Color(0xFFFFFFFF);
  static const Color lightBgCardSubtle = Color(0xFFF8FAFC);

  static const Color lightTextMain = Color(0xFF0F172A);
  static const Color lightTextMuted = Color(0xFF64748B);
  static const Color lightTextDisabled = Color(0xFF94A3B8);
  static const Color lightTextOnPrimary = Color(0xFFFFFFFF);
  static const Color lightTextLink = Color(0xFF2563EB);

  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightBorderFocus = Color(0xFF3B82F6);

  // --- Dark Mode Palette ---
  static const Color darkPrimary = Color(0xFF60A5FA);
  static const Color darkPrimaryLight = Color(0xFFBFDBFE);
  static const Color darkPrimaryDark = Color(0xFF0F172A);
  static const Color darkAccentSun = Color(0xFFFACC15);
  static const Color darkAccentOrange = Color(0xFFFB923C);
  static const Color darkAccentCoral = Color(0xFFF43F5E);

  static const Color darkSuccess = Color(0xFF34D399);
  static const Color darkSuccessLight = Color(0xFF064E3B);
  static const Color darkWarning = Color(0xFFFBBF24);
  static const Color darkInfo = Color(0xFF38BDF8);

  static const Color darkBgApp = Color(0xFF0B1120);
  static const Color darkBgCard = Color(0xFF1E293B);
  static const Color darkBgCardSubtle = Color(0xFF141E33);

  static const Color darkTextMain = Color(0xFFF8FAFC);
  static const Color darkTextMuted = Color(0xFF94A3B8);
  static const Color darkTextDisabled = Color(0xFF475569);
  static const Color darkTextOnPrimary = Color(0xFFFFFFFF);
  static const Color darkTextLink = Color(0xFF93C5FD);

  static const Color darkBorder = Color(0xFF334155);
  static const Color darkBorderFocus = Color(0xFF60A5FA);

  // --- Gradients ---
  static const LinearGradient lightHeroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF1E3A8A),
      Color(0xFF3B82F6),
      Color(0xFF93C5FD),
      Color(0xFFE0F2FE),
    ],
  );

  static const LinearGradient darkHeroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF090D1A),
      Color(0xFF172554),
      Color(0xFF1E3A8A),
    ],
  );

  static const LinearGradient lightDawnGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF38BDF8), Color(0xFFFDE047)],
  );

  static const LinearGradient darkDawnGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E40AF), Color(0xFFEAB308)],
  );

  static const LinearGradient primaryButtonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E40AF), Color(0xFF3B82F6), Color(0xFF60A5FA)],
  );

  static const LinearGradient darkButtonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
  );

  static const LinearGradient goldBadgeGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF59E0B), Color(0xFFFDE047)],
  );

  static const LinearGradient silverBadgeGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF94A3B8), Color(0xFFE2E8F0)],
  );

  static const LinearGradient diamondBadgeGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF06B6D4), Color(0xFF93C5FD)],
  );

  // --- Habit Thematic Colors (6 Palette options) ---
  static const List<Color> habitPalette = [
    Color(0xFF38BDF8), // Water / Sky
    Color(0xFF34D399), // Health / Mint
    Color(0xFFFBBF24), // Energy / Amber
    Color(0xFFF472B6), // Mindfulness / Pink
    Color(0xFFA78BFA), // Reading / Purple
    Color(0xFF818CF8), // Focus / Indigo
  ];

  static Color getHabitColor(int index) {
    if (index < 0 || index >= habitPalette.length) {
      return habitPalette[0];
    }
    return habitPalette[index];
  }
}
