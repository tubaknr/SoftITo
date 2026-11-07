import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class LocalNotificationController{
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin = FlutterLocalNotificationsPlugin();
  
  static Future<void> init() async{
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosSettings = DarwinInitializationSettings();

    const settings = InitializationSettings(android: androidSettings, iOS: iosSettings);

    const _localNotificationsPlugin.initialize(settings: settings);
  }

  static Future<void> showNotification(RemoteMessage message) async {
    const androidNotificationDetails = androidNotificationDetails(
      'softito_channel_id',
      'softito_notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const details = NotificationDetails(android: androidNotificationDetails);

    await _localNotificationsPlugin.show(
      id: message.messageId.hashCode,
      title: message.notification?.title ?? 'New notification',
      body: message.notification?.body ?? '',
      notificationDetails: details
    );
  }
}