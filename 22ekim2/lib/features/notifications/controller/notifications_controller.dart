import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/local_store.dart';
import '../../../core/services/notification_service.dart';
import '../models/notification_settings.dart';

/// Controller for customizable notifications
class NotificationsController {
  NotificationsController({
    required this.localStore,
    required this.notificationService,
  });

  final LocalStore localStore;
  final NotificationService notificationService;

  final ValueNotifier<NotificationSettings> settings =
      ValueNotifier<NotificationSettings>(const NotificationSettings());

  Future<void> init() async {
    final raw = await localStore.getString(AppConstants.keyNotificationSettings);
    if (raw != null && raw.isNotEmpty) {
      try {
        final map = jsonDecode(raw) as Map<String, dynamic>;
        settings.value = NotificationSettings.fromJson(map);
      } catch (_) {}
    }
  }

  Future<void> updateSettings(NotificationSettings newSettings) async {
    settings.value = newSettings;
    await localStore.setString(
      AppConstants.keyNotificationSettings,
      jsonEncode(newSettings.toJson()),
    );

    // Apply notification schedules via service
    if (newSettings.dailyMotivationEnabled) {
      await notificationService.scheduleDailyMotivation(
        quote: 'Kritik adımlar, büyük hedeflerin ruhudur.',
        time: TimeOfDay(
          hour: newSettings.motivationHour,
          minute: newSettings.motivationMinute,
        ),
      );
    }
    if (newSettings.daytimeRemindersEnabled) {
      await notificationService.scheduleDaytimeReminder(
        message: 'Haydi şimdi bir bardak su iç 💧 / birkaç sayfa kitap oku 📖',
        intervalHours: newSettings.daytimeReminderIntervalHours,
      );
    }
  }

  void dispose() {
    settings.dispose();
  }
}
