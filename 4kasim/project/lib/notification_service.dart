import 'package:firebase_messaging/firebase_messaging.dart';

@pragma('vm:entry-point') // Flutter mÜLAKATLARINDA ÇOK ÇIAKR!!!!
// burası en üste yazılınca rka planda çalıştırlabilir. async olsa bile sıralamaya aldınğında en altta kalır, uygulamayı açamzsa bildirim gitmez.
// en üste bunu yaıznca uyg açmasa bile arka planda bildirim gönderebilri.
// ARKA PLANDA YAKALAMA FONKSİYONU
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Arka planda bildirim geldi. ${message.notification?.title}");
}

class BildirimServisi {
  // fcm, arka planda çalışan bir servistir. tüm mobillerde olur.
  // Bildirim Servisi.
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> baslat() async {
    // İZİNLER
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus == authorizationStatus) {
      print(
        "Kullanıcı Bildirim iznini verdi.",
      ); // burası normalde loglanır. buraya yazılmaz.
    }
    // TOKEN ALMA
    final token = await _fcm.getToken(); // token ve kullanıcı eşleştirir
    print("Cihazın FCM tokeni: $token");
  }
}
