import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// KİLİT NOKTA: Yerel bildirim işlemlerini statik (global) metotlarla yöneten yardımcı kontrolcü sınıfı.
class LocalNotificationController {
  // KİLİT NOKTA: Flutter Local Notifications eklentisinin tekil (singleton) örneğini statik olarak tanımlar.
  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // KİLİT NOKTA: Uygulama ilk açıldığında (genellikle main içinde) yerel bildirim altyapısını kuran ve başlatan asenkron metot.
  static Future<void> init() async {
    // Android cihazlarda bildirimin hangi uygulama ikonuyla görüneceğini belirleyen ayar nesnesi
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    // iOS cihazlar için varsayılan bildirim başlatma ayar nesnesi
    const iosSettings = DarwinInitializationSettings();
    // Android ve iOS platform ayarlarını tek bir çatı altında toplar
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // KİLİT NOKTA: Eklentiyi, hazırlanan platform ayarlarıyla sisteme kaydeder (initialize parametresi adlandırılmış argument 'settings:' alır).
    await _flutterLocalNotificationsPlugin.initialize(settings: settings);
  }

  // KİLİT NOKTA: Firebase'den gelen RemoteMessage verisini alıp telefonda anlık (heads-up) bildirim gösteren statik metot.
  static Future<void> showNotification(RemoteMessage message) async {
    // KİLİT NOKTA: Android için bildirim kanalı kimliği, adı, en yüksek önem (Importance.max) ve sesli uyarı ayarlarını tanımlar.
    const androidNotificationDetails = AndroidNotificationDetails(
      'softito_channel_id',
      'softito_notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    // Platform detaylarını (şu an sadece Android) NotificationDetails içinde sarmalar
    const details = NotificationDetails(android: androidNotificationDetails);

    // KİLİT NOKTA: Belirtilen id, başlık, gövde ve detaylarla yerel bildirimi ekranda fırlatır (id, title, body, notificationDetails adlandırılmış parametreler kullanır).
    await _flutterLocalNotificationsPlugin.show(
      id: message.messageId.hashCode, // Mesajın ID'sinin hash kodunu kullanarak her bildirime benzersiz bir sayısal kimlik verir
      title: message.notification?.title ?? 'New Notification', // Gelen mesajın başlığı yoksa varsayılan metin gösterir
      body: message.notification?.body ?? '', // Gelen mesajın gövde metni
      notificationDetails: details, // Bildirimin görünüm ve davranış detayları
    );
  }
}
