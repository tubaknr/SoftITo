import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// KİLİT NOKTA: Dart'ın tree-shaking (kullanılmayan kodları silme) mekanizmasının,
// uygulama arkaplandayken tetiklenecek bu fonksiyonu silmemesi için gereken işaretçidir.
@pragma('vm:entry-point')
// KİLİT NOKTA: Uygulama tamamen kapalıyken veya arkaplandayken gelen FCM bildirimlerini
// yakalayıp işleyen zorunlu global (top-level) arkaplan dinleyici fonksiyonudur.
Future<void> fcmBackgroundHandler(RemoteMessage message) async {}

// Firebase Cloud Messaging (FCM) ve Yerel Bildirim yönetimini tek bir çatı altında toplayan servis sınıfı.
class FcmBildirimServisi {
  // KİLİT NOKTA: Firebase Messaging kütüphanesinin tekil örneğini (instance) alarak sunucu iletişimi kurar.
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  // KİLİT NOKTA: Cihaz ekranında açılır (heads-up) bildirim gösterebilmek için yerel eklentiyi tanımlar.
  final FlutterLocalNotificationsPlugin _localPlugin =
      FlutterLocalNotificationsPlugin();

  // Servisi ve bildirim dinleyicilerini başlatan ana asenkron fonksiyon
  Future<void> baslat({
    required Function(RemoteMessage message) onMesajGeldi,
  }) async {
    // KİLİT NOKTA: iOS ve destekleyen Android sürümleri için kullanıcıdan bildirim izni (ses, rozet, uyarı) ister.
    await _fcm.requestPermission(alert: true, badge: true, sound: true);

    // Android tarafında bildirimde görünecek uygulama ikonunu belirleyen ayar nesnesi
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    // iOS tarafı için varsayılan bildirim başlatma ayar nesnesi
    const iosSettings = DarwinInitializationSettings();
    // Her iki platformun bildirim ayarlarını tek bir nesnede birleştirir
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // KİLİT NOKTA: Yerel bildirim eklentisini, yukarıda hazırlanan platform ayarlarıyla sisteme kaydeder.
    await _localPlugin.initialize(initSettings);

    // KİLİT NOKTA: Uygulama önplandayken (açık ve aktifken) gelen FCM mesajlarını anlık olarak dinler.
    FirebaseMessaging.onMessage.listen((message) {
      // Mesaj geldiğinde telefonda görsel yerel bildirim kutusunu tetikler
      _yerelBildirimGoster(message);
      // Dışarıdan gelen callback fonksiyonunu çalıştırarak uygulamanın haberdar olmasını sağlar
      onMesajGeldi(message);
    });
    // KİLİT NOKTA: Uygulama arkaplandayken kullanıcı bildirime tıkladığında çalışacak yöneticiyi kayırır.
    FirebaseMessaging.onBackgroundMessage(fcmBackgroundHandler);
  }

  // Belirtilen bir FCM konu başlığına (topic) cihazı abone yapan fonksiyon
  Future<void> konuyaAboneOl(String konu) async {
    // KİLİT NOKTA: Firebase sunucusuna istek atarak cihazı ilgili konunun yayın grubuna dâhil eder.
    await _fcm.subscribeToTopic(konu);
  }

  // Cihazı mevcut FCM konu aboneliğinden çıkaran fonksiyon
  Future<void> konudanAyril(String konu) async {
    // KİLİT NOKTA: Cihazın artık o konudan bildirim almaması için aboneliği sunucu tarafında iptal eder.
    await _fcm.unsubscribeFromTopic(konu);
  }

  // Gelen FCM mesajını cihazın bildirim çubuğunda görsel olarak gösteren özel yardımcı metot
  Future<void> _yerelBildirimGoster(RemoteMessage message) async {
    // KİLİT NOKTA: Android için kanal kimliği, adı, öncelik ve önem (Importance.max) seviyelerini belirler.
    const androidDetails = AndroidNotificationDetails(
      'softit_fcm_channel_id',
      'Softito bildirimleri',
      channelDescription: 'Fcm Push Bildirimleri',
      importance: Importance.max,
      priority: Priority.high,
    );

    // Android ve iOS platform detaylarını tek bir çatı altında toplar
    const details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    // KİLİT NOKTA: Belirtilen kimlik, başlık ve içerikle yerel bildirimi ekranda (tepe bildirim olarak) fırlatır.
    await _localPlugin.show(
      message.hashCode, // Bildirimi benzersiz kılmak için mesajın hash kodunu ID olarak kullanır
      message.notification?.title ??
          "Yeni Bildirim", // Bildirim başlığı yoksa varsayılan metin yazar
      message.notification?.body ?? '', // Bildirim gövde metni
      details,
    );
  }
}
