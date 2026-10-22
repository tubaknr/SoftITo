import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

/// Manages application ThemeMode with ValueNotifier and local persistence
class ThemeController extends ValueNotifier<ThemeMode> {
  ThemeController._() : super(ThemeMode.light);

  static final ThemeController instance = ThemeController._();

  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedMode = prefs.getString(AppConstants.keyThemeMode);
      if (savedMode == 'dark') {
        value = ThemeMode.dark;
      } else {
        value = ThemeMode.light;
      }
    } catch (_) {
      value = ThemeMode.light;
    }
  }

  Future<void> toggleTheme() async {
    if (value == ThemeMode.light) {
      await setTheme(ThemeMode.dark);
    } else {
      await setTheme(ThemeMode.light);
    }
  }

  Future<void> setTheme(ThemeMode mode) async {
    if (value == mode) return;
    value = mode;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        AppConstants.keyThemeMode,
        mode == ThemeMode.dark ? 'dark' : 'light',
      );
    } catch (_) {}
  }

  bool get isDarkMode => value == ThemeMode.dark;
}
