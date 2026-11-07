// Firebase Remote Config paketi: uygulamayı mağazaya yeniden yüklemeden,
// Firebase konsolundan değer değiştirmeyi sağlar (kampanya açma/kapama, indirim oranı, zorunlu güncelleme vb.)
import 'package:firebase_remote_config/firebase_remote_config.dart';

// ---------------------------------------------------------------
// RemoteConfigServisi
// ---------------------------------------------------------------
// Remote Config işlerini tek sınıfta toplar.
// Uygulamanın geri kalanı Firebase'i doğrudan bilmez; değerleri
// aşağıdaki getter'lar (kampanyaAktifMi, indirimOrani vb.) üzerinden okur.
class RemoteConfigServisi {
  // Remote Config'in tekil (singleton) örneği: Firebase'den ayar çeken ve okuyan nesne.
  // Singleton: uygulamada bir tane vardır, her yerden aynı nesneye erişilir.
  final FirebaseRemoteConfig _firebaseRemoteConfig =
      FirebaseRemoteConfig.instance;

  // ---------------------------------------------------------------
  // 1) BAŞLATMA
  // ---------------------------------------------------------------
  // Uygulama açılırken, Firebase.initializeApp()'den SONRA bir kez çağrılır.
  Future<void> baslat() async {
    // a) Çekme (fetch) ayarları
    await _firebaseRemoteConfig.setConfigSettings(
      RemoteConfigSettings(
        // Sunucudan veri çekerken en fazla 10 saniye beklenir; aşılırsa istek hata verir.
        fetchTimeout: const Duration(seconds: 10),
        // İki çekme arasındaki minimum süre. Duration.zero -> her seferinde sunucuya gider.
        // Geliştirme/test için pratiktir; canlıda 1 saat gibi bir değer verilmeli,
        // yoksa Firebase isteklerini kısıtlayabilir (throttle).
        minimumFetchInterval: Duration.zero,
      ),
    );

    // b) Varsayılan değerler
    // İnternet yokken veya sunucudan değer henüz gelmemişken kullanılacak yedek değerler.
    // Anahtarlar (key), Firebase konsolundaki parametre adlarıyla birebir aynı olmalı.
    await _firebaseRemoteConfig.setDefaults(const {
      'kampanya_aktif': true, // Kampanya gösterilsin mi?
      'kampanya_metni': 'Mobil Mezuniyet indirimi', // Kampanya yazısı
      'kampanya_indirim_orani': 30, // İndirim yüzdesi (%30)
      'zorunlu_guncelleme': false, // true ise kullanıcı güncellemeye zorlanır
      'en_dusuk_surum':
          '1.0.0', // Uygulamanın çalışması için gereken minimum sürüm
    });

    // c) Değerleri sunucudan çek ve etkinleştir
    // fetch: Firebase'den güncel değerleri indirir.
    // activate: indirilen değerleri uygulamada geçerli yapar.
    // try/catch: internet yoksa vb. hata olursa uygulama çökmesin, varsayılanlarla devam etsin.
    try {
      await _firebaseRemoteConfig.fetchAndActivate();
    } catch (_) {}
  }

  // ---------------------------------------------------------------
  // 2) GETTER'LAR: Değerleri okuma
  // ---------------------------------------------------------------
  // Uygulamanın geri kalanı değerlere buradan ulaşır.
  // Sunucudan gelen değer varsa onu, yoksa yukarıdaki varsayılanı döndürür.

  // Kampanya açık mı? -> UI'da kampanya bannerını göstermek için.
  bool get kampanyaAktifMi => _firebaseRemoteConfig.getBool('kampanya_aktif');

  // Kampanya metni -> bannerda gösterilecek yazı.
  String get kampanyaMetni => _firebaseRemoteConfig.getString('kampanya_metni');

  // İndirim oranı (tam sayı) -> örn. 30 gelirse "%30 indirim" yazdırılır.
  int get indirimOrani =>
      _firebaseRemoteConfig.getInt("kampanya_indirim_orani");

  // Zorunlu güncelleme var mı? -> true ise "Güncelle" ekranı gösterilip uygulama kilitlenir.
  bool get zorunluGuncellemeMi =>
      _firebaseRemoteConfig.getBool('zorunlu_guncelleme');

  // En düşük desteklenen sürüm -> uygulamanın kendi sürümüyle karşılaştırılır,
  // daha eskiyse kullanıcıya güncelleme istenir.
  String get enDusukSurum => _firebaseRemoteConfig.getString('en_dusuk_surum');
}
