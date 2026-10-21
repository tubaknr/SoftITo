import 'package:flutter/material.dart';

/// Focus & Grow (F&G) pastel renk paleti ve gradyan tokenları.
class AppColors {
  AppColors._();

  // Pastel Aydınlık Renk Tokenları
  static const Color sunlightYellow = Color(0xFFFFF7D6);
  static const Color sproutSage = Color(0xFFD5E8D4);
  static const Color blushPetal = Color(0xFFFAD2E1);
  static const Color dustyRoseAccent = Color(0xFFE8A598);
  static const Color coralRedError = Color(0xFFE57373);
  static const Color stopButtonRed = Color(0xFFDF828A);
  static const Color softSuccessGreen = Color(0xFF81C784);

  // Tipografi ve Nötr Renkler
  static const Color textCharcoal = Color(0xFF2D312E);
  static const Color textMuted = Color(0xFF767E78);

  // Karanlık Mod Renk Tokenları
  static const Color darkBackground = Color(0xFF1E2522);
  static const Color darkCardSurface = Color(0xFF2B332F);
  static const Color darkTextPrimary = Color(0xFFF3F4F1);
  static const Color darkTextMuted = Color(0xFFA6ABA7);

  // Global Aydınlık Arka Plan Gradyanı
  static const LinearGradient lightAppGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFF7D6), // Pastel Sarı (Soft Sunlight)
      Color(0xFFD5E8D4), // Pastel Yeşil (Sprout Sage)
      Color(0xFFFAD2E1), // Toz Pembe (Blush Petal)
    ],
    stops: [0.0, 0.52, 1.0],
  );

  // Global Karanlık Arka Plan Meditatif Gece Gradyanı
  static const LinearGradient darkAppGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1C221F), // Karartılmış orman yeşili
      Color(0xFF241F25), // Karartılmış mürdüm / soft gül
      Color(0xFF28231C), // Karartılmış kehribar
    ],
    stops: [0.0, 0.50, 1.0],
  );

  // Birincil Buton Soft Gül Gradyanı
  static const LinearGradient primaryButtonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFFF8C8DC), // Açık pembe
      Color(0xFFE8A598), // Gül tonu
    ],
  );

  // Dairesel Odak Butonu Canlı Doğa Gradyanı
  static const LinearGradient pulsingButtonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFF4BF),
      Color(0xFFC7E5C5),
      Color(0xFFF7BFCF),
    ],
  );
}
