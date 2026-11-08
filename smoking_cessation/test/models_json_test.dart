// ========================================
// DOSYA: models_json_test.dart
// NE İŞE YARAR: Modellerin JSON dönüşümlerini
// ve doğrulama sınırlarını test eder.
// NASIL ÇALIŞIR: flutter_test ile birim
// testleri koşturulur.
// SOLID: Modellerin veri tutarlılığını sınar.
// ========================================

import 'package:flutter_test/flutter_test.dart';
import 'package:smoking_cessation/models/daily_log.dart';
import 'package:smoking_cessation/models/health_milestone.dart';
import 'package:smoking_cessation/models/user_profile.dart';

void main() {
  group('UserProfile Testleri', () {
    test('JSON serileştirme ve geri dönüşüm doğru çalışmalı', () {
      final now = DateTime(2026, 11, 8, 9, 30);
      final profile = UserProfile(
        quitDateTime: now,
        cigarettesPerDay: 15,
        packPrice: 100.0,
        cigarettesPerPack: 20,
      );

      final json = profile.toJson();
      final fromJson = UserProfile.fromJson(json);

      expect(fromJson.quitDateTime, now);
      expect(fromJson.cigarettesPerDay, 15);
      expect(fromJson.packPrice, 100.0);
      expect(fromJson.cigarettesPerPack, 20);
      expect(fromJson.isValid, isTrue);
    });

    test('Geçersiz değerler sınırlara sıkıştırılmalı', () {
      final json = {
        'quitDateTime': '2026-11-08T09:30:00.000',
        'cigarettesPerDay': 500,
        'packPrice': -50.0,
        'cigarettesPerPack': 0,
      };

      final profile = UserProfile.fromJson(json);
      expect(profile.cigarettesPerDay, 100);
      expect(profile.packPrice, 100.0);
      expect(profile.cigarettesPerPack, 1);
    });
  });

  group('AppSettings Testleri', () {
    test('JSON serileştirme ve varsayılanlar çalışmalı', () {
      const settings = AppSettings(
        notificationsEnabled: true,
        reminderHour: 9,
        reminderMinute: 30,
      );

      final json = settings.toJson();
      final fromJson = AppSettings.fromJson(json);

      expect(fromJson.notificationsEnabled, isTrue);
      expect(fromJson.reminderHour, 9);
      expect(fromJson.reminderMinute, 30);
    });

    test('Saat ve dakika sınırları korunmalı', () {
      final json = {
        'notificationsEnabled': false,
        'reminderHour': 30,
        'reminderMinute': -5,
      };

      final settings = AppSettings.fromJson(json);
      expect(settings.notificationsEnabled, isFalse);
      expect(settings.reminderHour, 23);
      expect(settings.reminderMinute, 0);
    });
  });

  group('DailyLog ve DateKey Testleri', () {
    test('DailyLog JSON serileştirme ve not kırpma çalışmalı', () {
      final longNote = 'A' * 250;
      final log = DailyLog(
        date: '2026-11-08',
        smokeFree: true,
        cravingLevel: 3,
        note: longNote,
      );

      final json = log.toJson();
      final fromJson = DailyLog.fromJson(json);

      expect(fromJson.date, '2026-11-08');
      expect(fromJson.smokeFree, isTrue);
      expect(fromJson.cravingLevel, 3);
      expect(fromJson.note?.length, 200);
    });

    test('DateKey format ve parse tutarlı olmalı', () {
      final dt = DateTime(2026, 11, 8);
      final formatted = DateKey.format(dt);
      expect(formatted, '2026-11-08');

      final parsed = DateKey.parse(formatted);
      expect(parsed.year, 2026);
      expect(parsed.month, 11);
      expect(parsed.day, 8);
    });
  });

  group('HealthMilestone Testleri', () {
    test('Varsayılan 5 kilometre taşı bulunmalı', () {
      expect(HealthMilestone.defaultMilestones.length, 5);
      expect(HealthMilestone.defaultMilestones.first.id, '20_min');
      expect(HealthMilestone.defaultMilestones.last.id, '1_year');
    });
  });
}
