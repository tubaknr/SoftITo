import 'package:flutter/material.dart';

/// Abstract notification service interface
abstract class NotificationService {
  Future<void> showCompletionCelebration({
    required String title,
    required String message,
  });

  Future<void> scheduleDailyMotivation({
    required String quote,
    required TimeOfDay time,
  });

  Future<void> scheduleDaytimeReminder({
    required String message,
    required int intervalHours,
  });

  Future<void> cancelAll();
}

/// In-app mock notification service logging and triggering callbacks
class MockNotificationService implements NotificationService {
  final List<String> dispatchedAlerts = [];

  @override
  Future<void> showCompletionCelebration({
    required String title,
    required String message,
  }) async {
    dispatchedAlerts.add('Celebration: $title - $message');
  }

  @override
  Future<void> scheduleDailyMotivation({
    required String quote,
    required TimeOfDay time,
  }) async {
    dispatchedAlerts.add('DailyMotivation at ${time.hour}:${time.minute} - $quote');
  }

  @override
  Future<void> scheduleDaytimeReminder({
    required String message,
    required int intervalHours,
  }) async {
    dispatchedAlerts.add('Reminder every $intervalHours h - $message');
  }

  @override
  Future<void> cancelAll() async {
    dispatchedAlerts.clear();
  }
}
