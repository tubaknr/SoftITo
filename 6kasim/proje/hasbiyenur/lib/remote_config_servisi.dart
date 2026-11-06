// Firebase Remote Config paketi: uygulamayı yeniden yayınlamadan (mağazaya güncelleme atmadan)
// Firebase konsolundan değer değiştirmeyi sağlar (kampanya açma/kapama, zorunlu sürüm vb.)
import 'package:firebase_remote_config/firebase_remote_config.dart';

// ---------------------------------------------------------------
// RemoteConfigServisi: Remote Config işlemlerini tek yerde toplayan servis sınıfı.
// Uygulamanın geri kalanı Firebase'e doğrudan bağlanmaz; değerleri
// aşağıdaki getter'lar (kampanyaAktifMi vb.) üzerinden okur.
// ---------------------------------------------------------------
class RemoteConfigServisi {
  // Remote Config'in tekil (singleton) örneği. Tüm ayar okuma/çekme işlemleri bununla yapılır.
  final FirebaseRemoteConfig _rc = FirebaseRemoteConfig.instance;

  // Servisi hazırlayan metot. Uygulama açılırken (örn. main içinde,
  // Firebase.initializeApp()'den SONRA) bir kez çağrılmalıdır.
  Future<void> baslat() async {
    // 1) Çekme (fetch) ayarları
    await _rc.setConfigSettings(
      RemoteConfigSettings(
        // Sunucudan veri çekilirken en fazla 10 saniye beklenir; süre dolarsa istek hata verir.
        fetchTimeout: const Duration(seconds: 10),
        // İki çekme arasındaki minimum süre. Duration.zero -> her seferinde sunucuya gider.
        // Test/geliştirme için pratiktir. Canlıda genelde 1 saat gibi bir değer verilir,
        // yoksa Firebase çekme limitine takılıp isteklerin kısıtlanabilir (throttle).
        minimumFetchInterval: Duration.zero,
      ),
    );

    // 2) Varsayılan değerler (default values)
    // İnternet yokken veya sunucudan değer henüz gelmemişken uygulamanın kullanacağı yedek değerlerdir.
    // Buradaki anahtarlar (key) Firebase konsolundaki parametre adlarıyla aynı olmalıdır.
    await _rc.setDefaults(const {
      'kampanya_aktif':
          false, // Kampanya bannerı gösterilsin mi? (false = gösterme)
      'kampanya_metni': 'Bugün beratta kmapnaya var 3 kere ders anlatacakmış', // Kampanya yazısı
      'zorunlu_surum':
          '1.0.1', // Uygulamanın çalışması için gereken minimum sürüm
    });

    // 3) Değerleri sunucudan çek ve etkinleştir
    // fetch: Firebase'den en güncel değerleri indirir.
    // activate: İndirilen değerleri uygulamada geçerli hale getirir.
    // fetchAndActivate ikisini birlikte yapar. Başarısız olursa varsayılan değerler kullanılmaya devam eder.
    await _rc.fetchAndActivate();
  }

  // ---------------------------------------------------------------
  // Getter'lar: Uygulamanın geri kalanı değerlere buradan ulaşır.
  // Değer önce sunucudan gelene bakar, yoksa yukarıdaki varsayılanı döndürür.
  // ---------------------------------------------------------------

  // Kampanya açık mı? (bool) -> UI'da banner göstermek için kullanılır.
  bool get kampanyaAktifMi => _rc.getBool('kampanya_aktif');

  // Kampanya metni (String) -> banner içinde gösterilecek yazı.
  String get kampanyaMetni => _rc.getString('kampanya_metni');

  // Zorunlu minimum sürüm (String) -> uygulamanın kendi sürümüyle karşılaştırılıp,
  // eski sürümdeyse kullanıcıya "Güncelle" ekranı göstermek için kullanılır.
  String get zorunluSurum => _rc.getString('zorunlu_surum');
}
