import 'dart:async';
import 'package:flutter/foundation.dart';

@immutable
class AppNotification {
  const AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    this.isRead = false,
  });

  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final bool isRead;

  AppNotification copyWith({bool? isRead}) {
    return AppNotification(
      id: id,
      title: title,
      message: message,
      timestamp: timestamp,
      isRead: isRead ?? this.isRead,
    );
  }
}

class NotificationController extends ValueNotifier<List<AppNotification>> {
  NotificationController() : super(<AppNotification>[]);

  void addNotification({
    required String title,
    required String message,
  }) {
    final AppNotification notification = AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      message: message,
      timestamp: DateTime.now(),
    );
    value = <AppNotification>[notification, ...value];
  }

  void markAsRead(String id) {
    value = value.map((AppNotification n) {
      if (n.id == id) return n.copyWith(isRead: true);
      return n;
    }).toList();
  }

  void clearAll() {
    value = <AppNotification>[];
  }
}

class MockTrafficService {
  MockTrafficService({required this.notificationController});

  final NotificationController notificationController;

  /// Simüle edilmiş trafik yoğunluğuna göre gecikme süresi hesaplar ve bildirim üretir
  Future<int> simulateDelay({
    required String partyName,
    required String destination,
  }) async {
    // 500 ms simüle hesaplama süresi
    await Future<void>.delayed(const Duration(milliseconds: 500));

    // Sabit / dinamik gecikme (15 dakika)
    const int delayMinutes = 15;

    notificationController.addNotification(
      title: 'Gecikme Uyarısı (Trafik Simülasyonu)',
      message: '$partyName buluşma noktasına ($destination) yoğun trafik nedeniyle yaklaşık $delayMinutes dakika geç varacağını bildirdi.',
    );

    return delayMinutes;
  }
}
