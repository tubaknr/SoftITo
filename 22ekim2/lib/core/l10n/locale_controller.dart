import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

/// Manages application Locale with ValueNotifier and local persistence
class LocaleController extends ValueNotifier<Locale> {
  LocaleController._() : super(const Locale('tr'));

  static final LocaleController instance = LocaleController._();

  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedCode = prefs.getString(AppConstants.keyLocale);
      if (savedCode == 'en') {
        value = const Locale('en');
      } else {
        value = const Locale('tr');
      }
    } catch (_) {
      value = const Locale('tr');
    }
  }

  Future<void> toggleLocale() async {
    if (value.languageCode == 'tr') {
      await setLocale(const Locale('en'));
    } else {
      await setLocale(const Locale('tr'));
    }
  }

  Future<void> setLocale(Locale newLocale) async {
    if (value == newLocale) return;
    value = newLocale;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.keyLocale, newLocale.languageCode);
    } catch (_) {}
  }

  bool get isTr => value.languageCode == 'tr';
}
