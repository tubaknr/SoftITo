// FCM (Firebase Cloud Messaging): sunucudan telefona push bildirimi almayı sağlar.
import 'package:firebase_messaging/firebase_messaging.dart';
// Uygulama AÇIKKEN FCM bildirimi otomatik görünmez; bu paket onu ekranda göstermek için kullanılır.
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// ---------------------------------------------------------------
// ARKAPLAN MESAJ İŞLEYİCİSİ
// ---------------------------------------------------------------
// Uygulama arkaplandayken veya tamamen kapalıyken gelen FCM mesajlarını yakalar.
// İki kural vardır:
//   1) Sınıfın dışında, "top-level" (global) bir fonksiyon olmak zorundadır.
//      Çünkü arkaplanda uygulamanın arayüzü ve sınıfları yokken çalışır.
//   2) @pragma('vm:entry-point') eklenmelidir. Dart derlenirken "hiçbir yerden çağrılmıyor"
//      diye bu fonksiyonu silebilir; bu satır silinmesini engeller.
// Gelen veri "RemoteMessage" tipindedir (başlık, gövde, data alanı içerir).
// Şu an gövdesi boş; ileride burada veri kaydetme, log atma gibi işler yapılabilir.
@pragma('vm:entry-point')
Future<void> fcmBackgroundHandler(RemoteMessage message) async {}

// ---------------------------------------------------------------
// FcmBildirimServisi
// ---------------------------------------------------------------
// Bildirimle ilgili her şeyi (izin, dinleme, konu aboneliği, ekranda gösterme)
// tek sınıfta toplar. Uygulamanın geri kalanı sadece bu sınıfı kullanır.
class FcmBildirimServisi {
  // Firebase Messaging'in tekil (singleton) örneği: Firebase sunucusuyla konuşan nesne.
  // Singleton: uygulamada bu sınıfın yalnızca BİR örneği olur, her yerden aynı nesneye erişilir.
  // İzin isteme, token alma, konuya abone olma ve mesaj dinleme işlemleri bununla yapılır.
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  // Yerel bildirim eklentisi: telefonun bildirim çubuğunda/ekranın üstünde bildirim gösterir.
  // Uygulama ön plandayken FCM bildirimi kendiliğinden görünmediği için buna ihtiyaç var.
  final FlutterLocalNotificationsPlugin _localPlugin =
      FlutterLocalNotificationsPlugin();

  // Servisi başlatır. Uygulama açılırken, Firebase.initializeApp()'den SONRA bir kez çağrılır.
  // onMesajGeldi: Dışarıdan (örn. bir ekrandan) verilen fonksiyon.
  // Uygulama ön plandayken mesaj gelince çalışır; arayüz bu sayede haberdar olur
  // (örn. bildirim sayacını artırmak için).
  Future<void> baslat({
    required Function(RemoteMessage message) onMesajGeldi,
  }) async {
    // 1) İZİN: Kullanıcıdan bildirim izni ister (uyarı, rozet, ses).
    //    iOS ve Android 13+ için zorunludur; izin verilmezse bildirim görünmez.
    await _fcm.requestPermission(alert: true, badge: true, sound: true);

    // 2) YEREL BİLDİRİM AYARLARI
    // Android: bildirimde görünecek küçük ikon. Projedeki uygulama ikonunu kullanır.
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    // iOS: varsayılan ayarlar.
    const iosSettings = DarwinInitializationSettings();
    // İki platformun ayarını tek pakette birleştirir.
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // Yerel bildirim eklentisini bu ayarlarla kurar. Bundan sonra .show() kullanılabilir.
    await _localPlugin.initialize(initSettings);

    // 3) ÖN PLAN DİNLEYİCİSİ: Uygulama açık ve ekrandayken gelen FCM mesajlarını yakalar.
    //    Akış: Firebase mesajı gönderir -> onMessage tetiklenir -> iki iş yapılır.
    FirebaseMessaging.onMessage.listen((message) {
      // a) Mesajı telefonda görünür bildirim olarak gösterir.
      _yerelBildirimGoster(message);
      // b) Dışarıdan verilen onMesajGeldi fonksiyonunu çağırıp mesajı uygulamaya iletir.
      onMesajGeldi(message);
    });

    // 4) ARKAPLAN İŞLEYİCİSİNİ KAYDEDER: Uygulama arkaplandayken/kapalıyken gelen
    //    mesajlar yukarıdaki fcmBackgroundHandler fonksiyonuna yönlendirilir.
    FirebaseMessaging.onBackgroundMessage(fcmBackgroundHandler);
  }

  // Cihazın FCM token'ını döndürür.
  // Token: Bu cihazın "adresi" gibidir. Sunucu belirli bir cihaza bildirim
  // göndermek istediğinde bu değeri kullanır.
  // Hata olursa (internet yok vb.) uygulama çökmesin diye null döner.
  Future<String?> tokenAl() async {
    try {
      return await _fcm.getToken();
    } catch (_) {
      return null;
    }
  }

  // Cihazı bir konuya (topic) abone eder. Örn: "kampanyalar" konusuna abone olan
  // tüm cihazlara tek seferde bildirim gönderilebilir.
  // 'konu' parametresi çağıran yerden gelir.
  Future<void> konuyaAboneOl(String konu) async {
    await _fcm.subscribeToTopic(konu);
  }

  // Cihazın konu aboneliğini iptal eder; artık o konudan bildirim gelmez.
  Future<void> konudanAyril(String konu) async {
    await _fcm.unsubscribeFromTopic(konu);
  }

  // FCM'den gelen mesajı telefonda görünür bildirim olarak gösterir.
  // 'message' parametresi onMessage dinleyicisinden gelir (FCM'in ham verisi).
  Future<void> _yerelBildirimGoster(RemoteMessage message) async {
    // Android bildirim kanalı: Android 8+ için zorunludur.
    // Sırayla: kanal kimliği, kullanıcının ayarlarda göreceği ad, açıklama.
    // importance max + priority high: bildirim ekranın üstünde açılır (heads-up).
    const androidDetails = AndroidNotificationDetails(
      'softit_fcm_channel_id',
      'Softito bildirimleri',
      channelDescription: 'Fcm Push Bildirimleri',
      importance: Importance.max,
      priority: Priority.high,
    );

    // Android ve iOS bildirim detaylarını tek pakette birleştirir.
    const details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    // Bildirimi ekranda gösterir. Veriler FCM mesajından alınır:
    await _localPlugin.show(
      message.hashCode, // Bildirim ID'si: her mesaj farklı olsun, birbirinin üstüne yazılmasın.
      message.notification?.title ??
          "Yeni Bildirim", // Başlık: mesajdan gelir, yoksa varsayılan metin.
      message.notification?.body ??
          '', // Gövde metni: mesajdan gelir, yoksa boş.
      details, // Yukarıda hazırlanan Android/iOS görünüm ayarları.
    );
  }
}
