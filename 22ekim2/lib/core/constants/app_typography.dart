import 'package:flutter/material.dart';

/// Typography definitions compliant with `style.md`
class AppTypography {
  const AppTypography._();

  static const String fontFamily = 'Plus Jakarta Sans';

  static const TextStyle heroTitle = TextStyle(
    fontSize: 28,
    height: 36 / 28,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.56,
  );

  static const TextStyle headingLg = TextStyle(
    fontSize: 22,
    height: 28 / 22,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.22,
  );

  static const TextStyle headingMd = TextStyle(
    fontSize: 18,
    height: 24 / 18,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle itemTitle = TextStyle(
    fontSize: 16,
    height: 22 / 16,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle link = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    decoration: TextDecoration.none,
  );
}
