// ========================================
// DOSYA: diary_controller.dart
// NE İŞE YARAR: Günlük kayıtları ve takvim
// durumlarını yöneten denetleyicidir.
// NASIL ÇALIŞIR: Tarih bazlı kayıt haritası
// tutar ve JSON olarak kaydeder.
// SOLID: SRP - Sadece günlük kayıt yönetimi.
// DIP - StorageService soyutuna bağımlıdır.
// ========================================

import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../models/daily_log.dart';
import '../../services/storage_service.dart';

// DIP: StorageService bağımlılığını enjekte alır.
class DiaryController extends ChangeNotifier {
  final StorageService _storage;
  final Map<String, DailyLog> _logs = {};

  DiaryController(this._storage);

  Map<String, DailyLog> get logs => Map.unmodifiable(_logs);
  List<DailyLog> get allLogs => _logs.values.toList();

  // Depodan kayıt listesini yükler.
  Future<void> init() async {
    try {
      final jsonStr = await _storage.readString('logs');
      if (jsonStr != null && jsonStr.isNotEmpty) {
        final list = jsonDecode(jsonStr) as List<dynamic>;
        _logs.clear();
        for (final item in list) {
          if (item is Map<String, dynamic>) {
            final log = DailyLog.fromJson(item);
            if (log.date.isNotEmpty) {
              _logs[log.date] = log;
            }
          }
        }
      }
    } catch (_) {
      _logs.clear();
    }
    notifyListeners();
  }

  // Tarihe göre günlük kaydı döner.
  DailyLog? getLog(String dateKey) => _logs[dateKey];

  // Günün temiz geçip geçmediğini döner.
  bool isSmokeFreeDay(String dateKey) {
    final log = _logs[dateKey];
    return log != null && log.smokeFree;
  }

  // Bugün için hızlı temiz/içildi kaydı atar.
  Future<void> setSmokeFreeToday(bool smokeFree) async {
    final todayKey = DateKey.format(DateTime.now());
    final existing = _logs[todayKey];
    final updated = existing != null
        ? existing.copyWith(smokeFree: smokeFree)
        : DailyLog(date: todayKey, smokeFree: smokeFree);
    await saveLog(updated);
  }

  // Kayıt ekler veya mevcut olanı günceller.
  Future<void> saveLog(DailyLog log) async {
    _logs[log.date] = log;
    await _persist();
    notifyListeners();
  }

  // Belirli bir tarihin kaydını siler.
  Future<void> deleteLog(String dateKey) async {
    _logs.remove(dateKey);
    await _persist();
    notifyListeners();
  }

  // Tüm kayıtları temizler.
  Future<void> clearAll() async {
    _logs.clear();
    await _storage.remove('logs');
    notifyListeners();
  }

  // Kesintisiz temiz gün serisini hesaplar.
  int get currentStreak {
    int streak = 0;
    var checkDate = DateTime.now();

    while (true) {
      final key = DateKey.format(checkDate);
      final log = _logs[key];
      if (log != null && log.smokeFree) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else {
        // Bugün henüz kayıt girilmemiş olabilir.
        if (streak == 0 && DateKey.isToday(key)) {
          checkDate =
              checkDate.subtract(const Duration(days: 1));
          continue;
        }
        break;
      }
    }
    return streak;
  }

  // Kayıtları JSON listesi olarak saklar.
  Future<void> _persist() async {
    final list = _logs.values.map((l) => l.toJson()).toList();
    final jsonStr = jsonEncode(list);
    await _storage.writeString('logs', jsonStr);
  }
}
