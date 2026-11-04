import 'package:firebase_messaging/firebase_messaging.dart';

// KİLİT NOKTA: Dart derleyicisinin (tree-shaking), kullanılmıyor zannedip bu fonksiyonu silmesini engelleyen vm entry-point işaretçisi.
@pragma('vm:entry-point')
// KİLİT NOKTA: Uygulama arka plandayken veya tamamen kapatılmışken (terminated) gelen push bildirimlerini yakalayan global arkaplan işleyicisidir.
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Arka planda gelen bildirimin başlık ve gövde verilerini konsola yazdırır.
  print(
    'Received Notification Message Background: ${message.notification?.title} ${message.notification?.body}',
  );
}

// KİLİT NOKTA: Firebase Cloud Messaging (FCM) izin ve token işlemlerini yöneten ana servis sınıfı.
class NotificationService {
  // KİLİT NOKTA: Firebase Messaging kütüphanesinin tekil örneğini (instance) alarak bildirim motorunu hazırlar.
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // KİLİT NOKTA: Bildirim izinlerini isteyen ve cihazın FCM token'ını alan temel başlatma (init) asenkron metodu.
  Future<void> init() async {
    // KİLİT NOKTA: Kullanıcıdan iOS ve destekleyen Android sürümleri için görsel, rozet ve sesli bildirim izni talep eder.
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Kullanıcının izin verip vermediğini kontrol eden koşul bloğu
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User Granted Notification Permission');
    } else {
      print('User Denied Notification Permission');
    }

    // KİLİT NOKTA: Firebase sunucularından bu cihaza özel benzersiz bildirim token'ını (FCM Token) asenkron olarak çeker.
    final token = await _firebaseMessaging.getToken();
    print('Device FCM Token: $token');
  }
}
