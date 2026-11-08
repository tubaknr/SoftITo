// ========================================
// DOSYA: app_theme.dart
// NE İŞE YARAR: Renk ve tipografi stillerini
// tek bir merkezde toplar.
// NASIL ÇALIŞIR: Sabit renk ve metin stilleri
// ile dark ThemeData üretir.
// SOLID: SRP - Sadece tema yapılandırması
// sorumluluğuna sahiptir.
// ========================================

import 'package:flutter/material.dart';

// SRP: Tüm görsel sabitler tek noktada toplanır.
class AppTheme {
  AppTheme._();

  // Arka plan ve yüzey renkleri
  static const Color surfaceLowest = Color(0xFF0B0E17);
  static const Color surface = Color(0xFF10131C);
  static const Color surfaceLow = Color(0xFF181B25);
  static const Color surfaceContainer = Color(0xFF1E222E);
  static const Color surfaceHigh = Color(0xFF262A38);
  static const Color surfaceHighest = Color(0xFF303546);

  // Vurgu ve aksan renkleri
  static const Color primary = Color(0xFF10B981);
  static const Color primaryBright = Color(0xFF00FFB3);
  static const Color primaryContainer = Color(0x2610B981);
  static const Color secondaryCyan = Color(0xFF06B6D4);
  static const Color warningAmber = Color(0xFFF59E0B);
  static const Color dangerSos = Color(0xFFEF4444);
  static const Color dangerSosGlow = Color(0x40EF4444);

  // Metin ve çizgi renkleri
  static const Color onSurface = Color(0xFFF1F5F9);
  static const Color onSurfaceVariant = Color(0xFF94A3B8);
  static const Color onSurfaceMuted = Color(0xFF64748B);
  static const Color outline = Color(0x1FFFFFFF);
  static const Color outlineActive = Color(0x6610B981);

  // Yazı tipleri ve stiller
  static const TextStyle displayCounter = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w800,
    color: onSurface,
    letterSpacing: -0.03,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const TextStyle headlineLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: onSurface,
    letterSpacing: -0.02,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: onSurface,
    letterSpacing: -0.01,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: onSurface,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: onSurface,
    height: 1.4,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: onSurfaceVariant,
    height: 1.4,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: onSurfaceMuted,
  );

  static const TextStyle labelMetric = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: onSurface,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const TextStyle labelCaps = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: onSurfaceVariant,
    letterSpacing: 0.06,
  );

  // Koyu tema yapılandırması
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: surfaceLowest,
      primaryColor: primary,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: secondaryCyan,
        surface: surface,
        error: dangerSos,
        onPrimary: surfaceLowest,
        onSecondary: surfaceLowest,
        onSurface: onSurface,
        onError: onSurface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: headlineMedium,
        iconTheme: IconThemeData(color: onSurface),
      ),
      cardTheme: CardThemeData(
        color: surfaceLow,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: outline),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: outline,
        thickness: 1,
      ),
    );
  }
}
