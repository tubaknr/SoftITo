import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController {
  ThemeController._();
  static final ThemeController instance = ThemeController._();

  static const String _prefKey = 'yorunge_theme_mode';

  final ValueNotifier<ThemeMode> themeMode = ValueNotifier<ThemeMode>(
    ThemeMode.dark,
  );

  bool get isDarkMode => themeMode.value == ThemeMode.dark;

  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDark = prefs.getBool(_prefKey);
      if (isDark != null) {
        themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
      }
    } catch (_) {
      // Fallback to default dark
      themeMode.value = ThemeMode.dark;
    }
  }

  Future<void> toggleTheme() async {
    final newMode =
        themeMode.value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    themeMode.value = newMode;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefKey, newMode == ThemeMode.dark);
    } catch (_) {}
  }

  Future<void> setTheme(ThemeMode mode) async {
    themeMode.value = mode;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefKey, mode == ThemeMode.dark);
    } catch (_) {}
  }
}
