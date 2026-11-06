// Firebase Crashlytics paketi: uygulama çöktüğünde veya hata oluştuğunda
// bilgiyi Firebase konsoluna raporlayan servis.
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

// ---------------------------------------------------------------
// CrashlyticsServisi
// ---------------------------------------------------------------
// Crashlytics ile ilgili işleri tek sınıfta toplar.
// Uygulamanın geri kalanı Firebase'i doğrudan bilmez, bu servisi çağırır.
// Bu sınıf iki iş yapar:
//   1) Kullanıcıyı çökme raporlarına tanıtır (kim yaşadı?)
//   2) Çökmeden önceki adımları rapora not düşer (ne yaparken oldu?)
class CrashlyticsServisi {
  // Crashlytics'in tekil (singleton) örneği: Firebase'e rapor gönderen nesne.
  // Singleton: uygulamada bir tane vardır, her yerden aynı nesneye erişilir.
  // Kullanıcı bilgisi ekleme ve log yazma işlemleri bununla yapılır.
  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  // ---------------------------------------------------------------
  // 1) KULLANICIYI TANITMA
  // ---------------------------------------------------------------
  // Çökme raporlarına "bu hata kime ait?" bilgisini ekler.
  // Genelde kullanıcı giriş yaptıktan hemen sonra bir kez çağrılır.
  // Parametreler (uid, rol) giriş yapan kullanıcının verisinden gelir
  // (örn. Firebase Auth'tan uid, veritabanından rol).
  Future<void> kullaniciTanit({
    required String uid, // Kullanıcının benzersiz kimliği
    required String rol, // Kullanıcının rolü (örn. admin, öğrenci)
  }) async {
    // Raporlara kullanıcı kimliğini ekler.
    // Konsolda bu uid ile arama yapıp o kullanıcının yaşadığı çökmeleri bulabilirsin.
    await _crashlytics.setUserIdentifier(uid);

    // Özel anahtar-değer çiftleri (custom key): rapora etiket gibi eklenir.
    // Konsolda filtreleme için kullanılır (örn. "sadece admin rolündeki çökmeleri göster").
    await _crashlytics.setCustomKey('rol', rol);
    // Sabit bir etiket: hata hangi platformdan geldi (burada her zaman 'flutter').
    await _crashlytics.setCustomKey('platform', 'flutter');
  }

  // ---------------------------------------------------------------
  // 2) LOG EKLEME (ayak izi / breadcrumb)
  // ---------------------------------------------------------------
  // Rapora bir not satırı ekler. Uygulama çökerse bu notlar da rapora dahil olur,
  // böylece çökmeden önce kullanıcının hangi adımları yaptığını görürsün.
  // 'mesaj' parametresi çağıran yerden gelir (örn. "ödeme ekranı açıldı").
  // Not: Log tek başına bir şey göndermez; sadece bir çökme/hata olduğunda rapora eklenir.
  void logEkle(String mesaj) {
    _crashlytics.log(mesaj);
  }

  Future<void> sessizHataKaydet(dynamic hata, StackTrace stack) async {
    // fatal: false
    await _crashlytics.recordError(hata, stack, fatal: false);
  }

  void kastenCokertme() {
    _crashlytics.crash();
  }
}
