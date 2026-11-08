// ========================================
// DOSYA: notification_service.dart
// NE İŞE YARAR: Yerel bildirim ve kutlama
// planlamasını yönetir.
// NASIL ÇALIŞIR: flutter_local_notifications
// ve timezone ile yerel bildirim kurar.
// SOLID: ISP & DIP - Soyut bildirim arayüzü,
// somut bildirim motorundan bağımsızdır.
// ========================================

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// ISP & DIP: Soyut bildirim servisi arayüzü.
abstract class NotificationService {
  Future<void> init();
  Future<bool> requestPermissions();
  Future<void> scheduleDailyMotivation({
    required int hour,
    required int minute,
  });
  Future<void> scheduleMilestoneCelebrations({
    required DateTime quitDateTime,
  });
  Future<void> cancelAll();
}

// LSP: flutter_local_notifications gerçeklemesi.
class LocalNotificationService implements NotificationService {
  final FlutterLocalNotificationsPlugin _plugin;

  LocalNotificationService([FlutterLocalNotificationsPlugin? plugin])
      : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  @override
  Future<void> init() async {
    if (kIsWeb) return;
    try {
      tz.initializeTimeZones();
      final info = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(info.identifier));
    } catch (_) {
      // Saat dilimi alınamazsa UTC kullanılır
    }

    try {
      const androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const initSettings =
          InitializationSettings(android: androidSettings);
      await _plugin.initialize(settings: initSettings);
    } catch (_) {
      // Başlatma hatasını güvenle yakalar
    }
  }

  @override
  Future<bool> requestPermissions() async {
    if (kIsWeb) return false;
    try {
      final android = _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      if (android != null) {
        final granted =
            await android.requestNotificationsPermission();
        return granted ?? false;
      }
    } catch (_) {}
    return true;
  }

  @override
  Future<void> scheduleDailyMotivation({
    required int hour,
    required int minute,
  }) async {
    if (kIsWeb) return;
    try {
      await _plugin.cancel(id: 100);

      final now = tz.TZDateTime.now(tz.local);
      var scheduledDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      const details = NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_motivation',
          'Günlük Motivasyon',
          channelDescription: 'Günlük motivasyon ve hatırlatıcı',
          importance: Importance.high,
          priority: Priority.high,
        ),
      );

      await _plugin.zonedSchedule(
        id: 100,
        title: 'Güne Özgür Başla!',
        body: 'Bugün de sigarasız, temiz bir gün seni bekliyor.',
        scheduledDate: scheduledDate,
        notificationDetails: details,
        androidScheduleMode: AndroidScheduleMode.inexact,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (_) {}
  }

  @override
  Future<void> scheduleMilestoneCelebrations({
    required DateTime quitDateTime,
  }) async {
    if (kIsWeb) return;
    try {
      final milestones = [
        MapEntry(1, const Duration(days: 1)),
        MapEntry(2, const Duration(days: 7)),
        MapEntry(3, const Duration(days: 30)),
        MapEntry(4, const Duration(days: 90)),
        MapEntry(5, const Duration(days: 180)),
        MapEntry(6, const Duration(days: 365)),
      ];

      final now = DateTime.now();

      for (final entry in milestones) {
        final celebrationDate = quitDateTime.add(entry.value);
        if (celebrationDate.isAfter(now)) {
          final tzDate =
              tz.TZDateTime.from(celebrationDate, tz.local);
          final id = 200 + entry.key;

          const details = NotificationDetails(
            android: AndroidNotificationDetails(
              'milestone_celebration',
              'Kilometre Taşı Kutlaması',
              channelDescription: 'Kazanılan dönüm noktası uyarıları',
              importance: Importance.high,
              priority: Priority.high,
            ),
          );

          await _plugin.zonedSchedule(
            id: id,
            title: 'Tebrikler! Yeni Bir Zafer!',
            body: 'Sigarasız büyük bir kilometre taşını tamamladın!',
            scheduledDate: tzDate,
            notificationDetails: details,
            androidScheduleMode: AndroidScheduleMode.inexact,
          );
        }
      }
    } catch (_) {}
  }

  @override
  Future<void> cancelAll() async {
    if (kIsWeb) return;
    try {
      await _plugin.cancelAll();
    } catch (_) {}
  }
}

// LSP: Testler ve sahte bildirim gerçeklemesi.
class FakeNotificationService implements NotificationService {
  bool permissionsGranted = true;
  bool isDailyScheduled = false;
  int celebrationCount = 0;
  bool isCancelled = false;

  @override
  Future<void> init() async {}

  @override
  Future<bool> requestPermissions() async => permissionsGranted;

  @override
  Future<void> scheduleDailyMotivation({
    required int hour,
    required int minute,
  }) async {
    isDailyScheduled = true;
    isCancelled = false;
  }

  @override
  Future<void> scheduleMilestoneCelebrations({
    required DateTime quitDateTime,
  }) async {
    celebrationCount++;
    isCancelled = false;
  }

  @override
  Future<void> cancelAll() async {
    isCancelled = true;
    isDailyScheduled = false;
    celebrationCount = 0;
  }
}
