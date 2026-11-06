// dart:ui -> PlatformDispatcher sınıfı buradan geliyor (Flutter dışı, platform seviyesindeki hataları yakalamak için)
import 'dart:ui';
// Flutter'ın temel arayüz bileşenleri (ElevatedButton, Text vb.)
import 'package:flutter/material.dart';
// Firebase'i başlatmak için gereken çekirdek paket (Firebase.initializeApp buradan gelir)
import 'package:firebase_core/firebase_core.dart';
// Çökme ve hata raporlarını Firebase konsoluna gönderen paket
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

/*
// ---------------------------------------------------------------
// UYGULAMA BAŞLANGIÇ NOKTASI (şu an yorum satırında)
// ---------------------------------------------------------------
void main() async{
  // Flutter motorunun hazır olduğundan emin olur.
  // async işlem (Firebase başlatma) runApp'ten önce yapılacağı için şart.
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase'i başlatır. Crashlytics'in çalışması için bu adım ZORUNLU.
  await Firebase.initializeApp();
1882
  // 1) Flutter çerçevesi içindeki hatalar (widget build hatası, render hatası vb.)
  //    Bu hatalar "fatal" (ölümcül) olarak Crashlytics'e gönderilir.
  FlutterError.onError=(errordetails){
    FirebaseCrashlytics.instance.recordFlutterFatalError(errordetails);
  };

  // 2) Flutter'ın dışında kalan hatalar (async hatalar, platform katmanı hataları).
  //    fatal:false -> uygulama çökmediği için "ölümcül olmayan" hata olarak kaydedilir.
  PlatformDispatcher.instance.onError=(error, stack){
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: false);
    // Not: true döndürülmezse hata "işlenmemiş" sayılır. Burada return yok.
  };

  // Uygulamayı başlatır; hata yakalayıcılar artık hazır.
  runApp(const SoftitoCrashApp());
}*/

// ---------------------------------------------------------------
// HataServisi: Crashlytics işlemlerini tek yerde toplayan servis sınıfı.
// Uygulamanın her yerinden Crashlytics'e doğrudan erişmek yerine
// bu sınıf üzerinden erişilir (düzenli ve test edilebilir yapı).
// ---------------------------------------------------------------
class HataServisi{
  // Crashlytics'in tekil (singleton) örneği. Bütün raporlar bu nesne ile gönderilir.
  final FirebaseCrashlytics _crashlytics= FirebaseCrashlytics.instance;

  // Kullanıcıyı raporlara bağlar: "Bu çökme kime ait?" sorusunu cevaplar.
  // Parametreler (uid, rol, paket) dışarıdan, genelde giriş yapıldıktan sonra
  // kullanıcı verisinden (Firebase Auth / veritabanı) alınıp buraya verilir.
  Future<void> kullaniciTanit(
  {
    required String uid,   // Kullanıcının benzersiz kimliği
    required String rol,   // Kullanıcının rolü (örn. admin, öğrenci)
    required String paket, // Üyelik tipi (örn. free, premium)
}
      ) async {
    // Çökme raporlarına kullanıcı kimliğini ekler (konsolda bu uid ile arama yapılabilir).
    await _crashlytics.setUserIdentifier(uid);
    // Özel anahtar-değer çiftleri: raporlarda filtreleme/gruplama için kullanılır.
    await _crashlytics.setCustomKey('kullanici_rolu', rol);
    await _crashlytics.setCustomKey('uyelik_tipi', paket);
  }

  // "Breadcrumb" (ekmek kırıntısı / ayak izi) bırakır.
  // Çökmeden önce kullanıcının hangi adımları yaptığını rapora log olarak ekler,
  // böylece hatanın hangi akışta oluştuğunu anlamak kolaylaşır.
  // 'adim' parametresi çağıran yerden gelir (örn. "sepete ekle butonuna basıldı").
  void ayakIziBirak(String adim){
    _crashlytics.log('kullanıcı işlemi:$adim');
  }

  // try/catch ile yakalanan hataları Crashlytics'e bildirir.
  // 'hata' ve 'stack' genelde catch bloğundan gelir: catch (e, s) { ... }
  // fatal:true -> raporu "ölümcül çökme" olarak işaretler.
  // (Dikkat: metodun adı "sessiz" ama fatal:true; sessiz/yakalanmış hatalar için
  //  genelde fatal:false kullanılır.)
  Future<void> sessizHataKaydet(dynamic hata, StackTrace stack) async{
    await _crashlytics.recordError(hata, stack, fatal:true);
  }

  // Test butonu: Crashlytics'in doğru kurulduğunu denemek için.
  // crash() uygulamayı bilerek çökertir; rapor bir sonraki açılışta konsola düşer.
  ElevatedButton(
      onPressed:(){
        FirebaseCrashlytics.instance.crash();
    },
    child: const Text('çökme testi gönder');
    )
}