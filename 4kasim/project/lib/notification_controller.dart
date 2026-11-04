// Flutter yerel bildirimlerini (local notifications) yönetmek için gerekli paketi projeye dahil eder.
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Firebase üzerinden gelen push bildirimlerini yönetmek için gerekli paketi projeye dahil eder.
import 'package:firebase_messaging/firebase_messaging.dart';

// Bildirim işlemlerini merkezi olarak yönetmek için static yapıda bir sınıf tanımlar.
class YerelBildirimYoneticisi {
  // Yerel bildirim eklentisinin (plugin) bir örneğini (instance) oluşturur ve dışarıdan erişilememesi için private yapar.
  static final FlutterLocalNotificationsPlugin _yerelBildirim =
      FlutterLocalNotificationsPlugin();

  // Bildirim yöneticisinin başlangıç ayarlarını yapan asenkron (asynchronous) bir fonksiyon tanımlar.
  static Future<void> kurulum() async {
    // Android cihazlarda bildirimlerin hangi uygulama simgesini kullanacağını belirler.
    const androidAyarlar = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS cihazlar için bildirim başlatma ayarlarını tanımlar (varsayılan değerler kullanılır).
    const iosAyarlar = DarwinInitializationSettings();

    // Android ve iOS platformuna ait bildirim ayarlarını tek bir nesnede birleştirir.
    const ayarlar = InitializationSettings(
      android: androidAyarlar,
      iOS: iosAyarlar,
    );

    // Tanımlanan ayarları kullanarak yerel bildirim eklentisini başlatır/hazır hale getirir.
    await _yerelBildirim.initialize(settings: ayarlar);
  }

  // Firebase'den gelen RemoteMessage türündeki mesajı ekranda göstermek için asenkron bir metot tanımlar.
  static Future<void> bildirimGoster(RemoteMessage message) async {
    // Android platformunda bildirimin kanal detaylarını (ID, isim, önem derecesi vb.) yapılandırır.
    const androidDetay = AndroidNotificationDetails(
      'softito_kanal_id', // Android sistemlerinin bildirimleri gruplamak ve yönetmek için kullandığı benzersiz kanal ID'si.
      'Softito Bildirimleri', // Kullanıcının telefon ayarlarında göreceği bildirim kanalının adı.
      importance: Importance.max, // Bildirimin en yüksek önem derecesine sahip olmasını sağlar (ekranda banner olarak belirir).
      priority: Priority.high, // Bildirimin öncelik seviyesini yüksek yapar.
      playSound: true, // Bildirim geldiğinde ses çalıp çalmayacağını belirler.
    );

    // Android bildirim detaylarını genel bildirim detay paketine sarar.
    const detaylar = NotificationDetails(android: androidDetay);

    // Hazırlanan detayları ve Firebase mesajından gelen başlık/açerik bilgilerini kullanarak bildirimi ekranda gösterir.
    await _yerelBildirim.show(
      id: message.messageId.hashCode, // Gelen mesajın ID'sinin hash değerini benzersiz bir bildirim ID'si olarak kullanır.
      title: message.notification?.title ?? 'Yeni Bildirim', // Mesajda başlık varsa onu kullanır, yoksa varsayılan metni yazar.
      body:
          message.notification?.body ??
          '', // Mesajda gövde metni varsa onu kullanır, yoksa boş bırakır.
      notificationDetails:
          detaylar, // Tanımlanan görsel ve sessel detayları bildirime uygular.
    );
  }
}
