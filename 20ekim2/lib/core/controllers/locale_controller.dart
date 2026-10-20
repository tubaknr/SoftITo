import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleController extends ValueNotifier<Locale> {
  LocaleController() : super(const Locale('tr')) {
    _loadFromPrefs();
  }

  static const String _prefKey = 'kiralago_locale';

  Future<void> _loadFromPrefs() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? savedLang = prefs.getString(_prefKey);
      if (savedLang == 'en') {
        value = const Locale('en');
      } else {
        value = const Locale('tr');
      }
    } catch (_) {
      // Hata durumunda varsayılan Türkçe korunur
    }
  }

  Future<void> setLocale(Locale newLocale) async {
    if (value.languageCode == newLocale.languageCode) return;
    value = newLocale;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefKey, newLocale.languageCode);
    } catch (_) {
      // Bellek içi durum geçerli kalır
    }
  }

  void toggleLocale() {
    if (value.languageCode == 'tr') {
      setLocale(const Locale('en'));
    } else {
      setLocale(const Locale('tr'));
    }
  }
}
