import 'package:firebase_messaging/firebase_messaging.dart';

// KİLİT NOKTA: Dart derleyicisinin, uygulama arka plandayken çalışacak bu arka plan fonksiyonunu (tree-shaking ile) gereksiz görüp silmesini engelleyen vm entry-point işaretçisidir.
@pragma('vm:entry-point')
// KİLİT NOKTA: Uygulama arka plandayken veya tamamen kapalı durumdayken (terminated) sunucudan gelen push bildirimlerini yakalayan global (top-level) işleyici fonksiyonudur.
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Arka planda gelen bildirimin başlık ve içerik verilerini konsola yazdırarak kontrol edilmesini sağlar.
  print(
    'Received Notification Message Background: ${message.notification?.title} ${message.notification?.body}',
  );
}

// KİLİT NOKTA: Firebase Cloud Messaging (FCM) altyapısını kuran, izinleri yöneten ve cihaz token'ını alan servis sınıfıdır.
class NotificationService {
  // KİLİT NOKTA: Firebase Messaging kütüphanesinin tekil örneğini (instance) alarak bildirim işlemlerine erişim sağlar.
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // KİLİT NOKTA: Bildirim izinlerini talep eden ve cihazın benzersiz token'ını konsola yazdıran temel başlatma fonksiyonudur.
  Future<void> init() async {
    // KİLİT NOKTA: iOS ve destekleyen Android sürümleri için kullanıcıdan bildirim izni (görsel, rozet ve ses) ister.
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Kullanıcının bildirim izni verip vermediğini kontrol eden koşul bloğu
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User Granted Notification Permission');
    } else {
      print('User Denied Notification Permission');
    }

    // KİLİT NOKTA: Bu cihaza özel olarak Firebase sunucularından üretilen benzersiz bildirim belirtecini (FCM Token) asenkron olarak çeker.
    final token = await _firebaseMessaging.getToken();
    print('Device FCM Token: $token');
  }
}
