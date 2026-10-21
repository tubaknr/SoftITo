import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

/// Tema modunu reaktif olarak yöneten Controller (ValueNotifier tabanlı).
class ThemeController extends ValueNotifier<ThemeMode> {
  ThemeController() : super(ThemeMode.light);

  static final ThemeController instance = ThemeController();

  Future<void> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMode = prefs.getString(AppConstants.prefKeyThemeMode);
    if (savedMode == 'dark') {
      value = ThemeMode.dark;
    } else if (savedMode == 'light') {
      value = ThemeMode.light;
    } else {
      value = ThemeMode.light;
    }
  }

  Future<void> toggleTheme() async {
    final nextMode = value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(nextMode);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    value = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      AppConstants.prefKeyThemeMode,
      mode == ThemeMode.dark ? 'dark' : 'light',
    );
  }

  bool get isDark => value == ThemeMode.dark;
}
