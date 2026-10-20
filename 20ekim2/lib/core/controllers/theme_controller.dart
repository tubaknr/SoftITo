import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ValueNotifier<ThemeMode> {
  ThemeController() : super(ThemeMode.system) {
    _loadFromPrefs();
  }

  static const String _prefKey = 'kiralago_theme_mode';

  Future<void> _loadFromPrefs() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? savedMode = prefs.getString(_prefKey);
      if (savedMode == 'light') {
        value = ThemeMode.light;
      } else if (savedMode == 'dark') {
        value = ThemeMode.dark;
      } else {
        value = ThemeMode.system;
      }
    } catch (_) {
      // SharedPreferences hatası durumunda varsayılan sistem teması korunur
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (value == mode) return;
    value = mode;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      if (mode == ThemeMode.light) {
        await prefs.setString(_prefKey, 'light');
      } else if (mode == ThemeMode.dark) {
        await prefs.setString(_prefKey, 'dark');
      } else {
        await prefs.remove(_prefKey);
      }
    } catch (_) {
      // Hata durumunda bellek içi seçim devam eder
    }
  }
}
