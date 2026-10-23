import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';
import 'app_theme_extension.dart';

/// AppTheme configuration for PenguHabit
class AppTheme {
  const AppTheme._();

  static const AppThemeExtension lightTokens = AppThemeExtension(
    primary: AppColors.lightPrimary,
    primaryLight: AppColors.lightPrimaryLight,
    primaryDark: AppColors.lightPrimaryDark,
    accentSun: AppColors.lightAccentSun,
    accentOrange: AppColors.lightAccentOrange,
    accentCoral: AppColors.lightAccentCoral,
    success: AppColors.lightSuccess,
    successLight: AppColors.lightSuccessLight,
    warning: AppColors.lightWarning,
    info: AppColors.lightInfo,
    bgApp: AppColors.lightBgApp,
    bgCard: AppColors.lightBgCard,
    bgCardSubtle: AppColors.lightBgCardSubtle,
    textMain: AppColors.lightTextMain,
    textMuted: AppColors.lightTextMuted,
    textDisabled: AppColors.lightTextDisabled,
    textOnPrimary: AppColors.lightTextOnPrimary,
    textLink: AppColors.lightTextLink,
    borderLight: AppColors.lightBorder,
    borderFocus: AppColors.lightBorderFocus,
    heroGradient: AppColors.lightHeroGradient,
    dawnGradient: AppColors.lightDawnGradient,
    btnPrimaryGradient: AppColors.primaryButtonGradient,
    badgeGoldGradient: AppColors.goldBadgeGradient,
  );

  static const AppThemeExtension darkTokens = AppThemeExtension(
    primary: AppColors.darkPrimary,
    primaryLight: AppColors.darkPrimaryLight,
    primaryDark: AppColors.darkPrimaryDark,
    accentSun: AppColors.darkAccentSun,
    accentOrange: AppColors.darkAccentOrange,
    accentCoral: AppColors.darkAccentCoral,
    success: AppColors.darkSuccess,
    successLight: AppColors.darkSuccessLight,
    warning: AppColors.darkWarning,
    info: AppColors.darkInfo,
    bgApp: AppColors.darkBgApp,
    bgCard: AppColors.darkBgCard,
    bgCardSubtle: AppColors.darkBgCardSubtle,
    textMain: AppColors.darkTextMain,
    textMuted: AppColors.darkTextMuted,
    textDisabled: AppColors.darkTextDisabled,
    textOnPrimary: AppColors.darkTextOnPrimary,
    textLink: AppColors.darkTextLink,
    borderLight: AppColors.darkBorder,
    borderFocus: AppColors.darkBorderFocus,
    heroGradient: AppColors.darkHeroGradient,
    dawnGradient: AppColors.darkDawnGradient,
    btnPrimaryGradient: AppColors.darkButtonGradient,
    badgeGoldGradient: AppColors.goldBadgeGradient,
  );

  static ThemeData get lightTheme {
    final textTheme = TextTheme(
      displayLarge: AppTypography.heroTitle.copyWith(color: AppColors.lightTextMain),
      headlineLarge: AppTypography.headingLg.copyWith(color: AppColors.lightTextMain),
      headlineMedium: AppTypography.headingMd.copyWith(color: AppColors.lightTextMain),
      titleMedium: AppTypography.itemTitle.copyWith(color: AppColors.lightTextMain),
      bodyLarge: AppTypography.body.copyWith(color: AppColors.lightTextMain),
      bodyMedium: AppTypography.bodyMedium.copyWith(color: AppColors.lightTextMain),
      bodySmall: AppTypography.caption.copyWith(color: AppColors.lightTextMuted),
      labelLarge: AppTypography.link.copyWith(color: AppColors.lightTextLink),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.lightPrimary,
      scaffoldBackgroundColor: AppColors.lightBgApp,
      cardColor: AppColors.lightBgCard,
      fontFamily: AppTypography.fontFamily,
      textTheme: textTheme,
      colorScheme: const ColorScheme.light(
        primary: AppColors.lightPrimary,
        onPrimary: AppColors.lightTextOnPrimary,
        secondary: AppColors.lightAccentOrange,
        surface: AppColors.lightBgCard,
        error: Colors.redAccent,
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightBgCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.lightBorder, width: 1),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: const TextStyle(decoration: TextDecoration.none),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: const TextStyle(decoration: TextDecoration.none),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          textStyle: const TextStyle(decoration: TextDecoration.none),
        ),
      ),
      chipTheme: const ChipThemeData(
        labelStyle: TextStyle(decoration: TextDecoration.none),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.lightBgCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.lightBgCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightBgCardSubtle,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.lightBorderFocus, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
      ),
      extensions: const [lightTokens],
    );
  }

  static ThemeData get darkTheme {
    final textTheme = TextTheme(
      displayLarge: AppTypography.heroTitle.copyWith(color: AppColors.darkTextMain),
      headlineLarge: AppTypography.headingLg.copyWith(color: AppColors.darkTextMain),
      headlineMedium: AppTypography.headingMd.copyWith(color: AppColors.darkTextMain),
      titleMedium: AppTypography.itemTitle.copyWith(color: AppColors.darkTextMain),
      bodyLarge: AppTypography.body.copyWith(color: AppColors.darkTextMain),
      bodyMedium: AppTypography.bodyMedium.copyWith(color: AppColors.darkTextMain),
      bodySmall: AppTypography.caption.copyWith(color: AppColors.darkTextMuted),
      labelLarge: AppTypography.link.copyWith(color: AppColors.darkTextLink),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.darkPrimary,
      scaffoldBackgroundColor: AppColors.darkBgApp,
      cardColor: AppColors.darkBgCard,
      fontFamily: AppTypography.fontFamily,
      textTheme: textTheme,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkPrimary,
        onPrimary: AppColors.darkTextOnPrimary,
        secondary: AppColors.darkAccentOrange,
        surface: AppColors.darkBgCard,
        error: Colors.redAccent,
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkBgCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.darkBorder, width: 1),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: const TextStyle(decoration: TextDecoration.none),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: const TextStyle(decoration: TextDecoration.none),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          textStyle: const TextStyle(decoration: TextDecoration.none),
        ),
      ),
      chipTheme: const ChipThemeData(
        labelStyle: TextStyle(decoration: TextDecoration.none),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.darkBgCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.darkBgCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkBgCardSubtle,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.darkBorderFocus, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
      ),
      extensions: const [darkTokens],
    );
  }
}
