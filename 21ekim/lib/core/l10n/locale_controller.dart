import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

/// Dil durumunu reaktif olarak yöneten Controller (ValueNotifier tabanlı).
class LocaleController extends ValueNotifier<Locale> {
  LocaleController() : super(const Locale('tr'));

  static final LocaleController instance = LocaleController();

  Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCode = prefs.getString(AppConstants.prefKeyLanguageCode);
    if (savedCode == 'en') {
      value = const Locale('en');
    } else {
      value = const Locale('tr');
    }
  }

  Future<void> toggleLocale() async {
    final nextLocale =
        value.languageCode == 'tr' ? const Locale('en') : const Locale('tr');
    await setLocale(nextLocale);
  }

  Future<void> setLocale(Locale newLocale) async {
    value = newLocale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      AppConstants.prefKeyLanguageCode,
      newLocale.languageCode,
    );
  }

  bool get isTr => value.languageCode == 'tr';
}
