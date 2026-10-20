import 'package:flutter/material.dart';
import '../constants/app_radius.dart';
import '../constants/app_spacing.dart';
import 'app_text_theme.dart';
import 'space_colors.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData createTheme({required bool isDark}) {
    final colors = isDark ? SpaceColors.night : SpaceColors.day;
    final brightness = isDark ? Brightness.dark : Brightness.light;
    final textTheme = AppTextTheme.buildTextTheme(
      colors.textPrimary,
      colors.textMuted,
    );

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: colors.dawn,
      onPrimary: colors.onDawn,
      secondary: colors.orbit,
      onSecondary: colors.onOrbit,
      error: colors.danger,
      onError: colors.onDawn,
      surface: colors.surface,
      onSurface: colors.textPrimary,
      outline: colors.outline,
      surfaceContainerHighest: colors.surfaceHigh,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: colors.bg,
      colorScheme: colorScheme,
      textTheme: textTheme,
      extensions: [colors],
      dividerColor: colors.outline,
      dividerTheme: DividerThemeData(
        color: colors.outline,
        thickness: 1,
        space: AppSpacing.lg,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.headlineSmall,
        iconTheme: IconThemeData(color: colors.textPrimary),
      ),
      cardTheme: CardThemeData(
        color: colors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.md,
          side: BorderSide(color: colors.outline, width: 1),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colors.surface,
        elevation: 0,
        height: 72,
        indicatorColor: colors.surfaceHigh,
        indicatorShape: const RoundedRectangleBorder(
          borderRadius: AppRadius.pill,
        ),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return textTheme.labelMedium?.copyWith(
              color: colors.dawn,
              fontWeight: FontWeight.w700,
            );
          }
          return textTheme.labelMedium?.copyWith(
            color: colors.textMuted,
            fontWeight: FontWeight.w500,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: colors.dawn, size: 24);
          }
          return IconThemeData(color: colors.textMuted, size: 24);
        }),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colors.dawn,
          foregroundColor: colors.onDawn,
          minimumSize: const Size(double.infinity, 52),
          elevation: 0,
          textStyle: textTheme.labelLarge,
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.pill,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.textPrimary,
          minimumSize: const Size(double.infinity, 48),
          elevation: 0,
          textStyle: textTheme.titleMedium,
          side: BorderSide(color: colors.outline, width: 1),
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.pill,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(color: colors.textMuted),
        labelStyle: textTheme.bodyMedium?.copyWith(color: colors.textMuted),
        helperStyle: textTheme.bodySmall?.copyWith(color: colors.textMuted),
        errorStyle: textTheme.bodySmall?.copyWith(color: colors.danger),
        border: OutlineInputBorder(
          borderRadius: AppRadius.sm,
          borderSide: BorderSide(color: colors.outline, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.sm,
          borderSide: BorderSide(color: colors.outline, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.sm,
          borderSide: BorderSide(color: colors.orbit, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.sm,
          borderSide: BorderSide(color: colors.danger, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.sm,
          borderSide: BorderSide(color: colors.danger, width: 2),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colors.surfaceHigh,
        selectedColor: colors.surfaceHigh,
        disabledColor: colors.surface,
        side: BorderSide(color: colors.outline, width: 1),
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.pill,
        ),
        labelStyle: textTheme.labelMedium?.copyWith(color: colors.textPrimary),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.surface,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.sheet,
        ),
        dragHandleColor: colors.outline,
        showDragHandle: true,
      ),
    );
  }

  static ThemeData get night => createTheme(isDark: true);
  static ThemeData get day => createTheme(isDark: false);
}
