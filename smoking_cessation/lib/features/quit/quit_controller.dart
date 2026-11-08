// ========================================
// DOSYA: quit_controller.dart
// NE İŞE YARAR: Profil, ayarlar ve canlı
// sayacı yöneten durum denetleyicisidir.
// NASIL ÇALIŞIR: ChangeNotifier ile verileri
// dinleyicilere duyurur, Timer ile akar.
// SOLID: SRP - Bırakma verisi durumunu yönetir.
// DIP - Depo ve bildirim arayüzüne bağlıdır.
// ========================================

import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../models/user_profile.dart';
import '../../services/notification_service.dart';
import '../../services/quit_calculator.dart';
import '../../services/storage_service.dart';

// DIP: Soyut servisleri constructor ile alır.
class QuitController extends ChangeNotifier {
  final StorageService _storage;
  final NotificationService? _notifications;
  Timer? _ticker;

  UserProfile? _profile;
  AppSettings _settings = const AppSettings();
  DateTime _now = DateTime.now();

  QuitController(this._storage, [this._notifications]);

  UserProfile? get profile => _profile;
  AppSettings get settings => _settings;
  DateTime get now => _now;
  bool get isOnboarded => _profile != null && _profile!.isValid;

  Duration get elapsedDuration {
    if (_profile == null) return Duration.zero;
    return QuitCalculator.elapsedDuration(
      _profile!.quitDateTime,
      _now,
    );
  }

  double get elapsedDays =>
      QuitCalculator.elapsedDaysDecimal(elapsedDuration);

  int get unsmokedCigarettes {
    if (_profile == null) return 0;
    return QuitCalculator.unsmokedCigarettes(
      elapsedDays,
      _profile!.cigarettesPerDay,
    );
  }

  double get singleCigarettePrice {
    if (_profile == null) return 0.0;
    return QuitCalculator.pricePerCigarette(
      _profile!.packPrice,
      _profile!.cigarettesPerPack,
    );
  }

  double get moneySaved => QuitCalculator.moneySaved(
        unsmokedCigarettes,
        singleCigarettePrice,
      );

  Duration get lifeRegained =>
      QuitCalculator.lifeRegained(unsmokedCigarettes);

  Future<void> init() async {
    await _loadProfile();
    await _loadSettings();
    _startTicker();
    await _syncNotifications();
    notifyListeners();
  }

  Future<void> _loadProfile() async {
    try {
      final jsonStr = await _storage.readString('profile');
      if (jsonStr != null && jsonStr.isNotEmpty) {
        final map = jsonDecode(jsonStr) as Map<String, dynamic>;
        _profile = UserProfile.fromJson(map);
      }
    } catch (_) {
      _profile = null;
    }
  }

  Future<void> _loadSettings() async {
    try {
      final jsonStr = await _storage.readString('settings');
      if (jsonStr != null && jsonStr.isNotEmpty) {
        final map = jsonDecode(jsonStr) as Map<String, dynamic>;
        _settings = AppSettings.fromJson(map);
      }
    } catch (_) {
      _settings = const AppSettings();
    }
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      _now = DateTime.now();
      notifyListeners();
    });
  }

  Future<void> saveProfile(UserProfile newProfile) async {
    _profile = newProfile;
    final jsonStr = jsonEncode(newProfile.toJson());
    await _storage.writeString('profile', jsonStr);
    await _syncNotifications();
    notifyListeners();
  }

  Future<void> saveSettings(AppSettings newSettings) async {
    _settings = newSettings;
    final jsonStr = jsonEncode(newSettings.toJson());
    await _storage.writeString('settings', jsonStr);
    await _syncNotifications();
    notifyListeners();
  }

  Future<void> _syncNotifications() async {
    if (_notifications == null) return;
    try {
      await _notifications.cancelAll();

      if (_settings.notificationsEnabled && _profile != null) {
        await _notifications.scheduleDailyMotivation(
          hour: _settings.reminderHour,
          minute: _settings.reminderMinute,
        );
        await _notifications.scheduleMilestoneCelebrations(
          quitDateTime: _profile!.quitDateTime,
        );
      }
    } catch (_) {
      // Bildirim hatası sayaç akışını bozmamalı
    }
  }

  Future<void> clearAll() async {
    _profile = null;
    _settings = const AppSettings();
    await _storage.remove('profile');
    await _storage.remove('settings');
    await _notifications?.cancelAll();
    notifyListeners();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
