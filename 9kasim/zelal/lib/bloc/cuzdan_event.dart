import 'package:flutter/foundation.dart';

// ==== BLoC'un 3 PARÇASI ====
// 1) Event : "Kullanıcı şunu yaptı" mesajı
// 2) Bloc  : Mesajı alır, işi yapar
// 3) State : Ekranın o anki durumu
//
// Akış:
// Ekran --Event--> Bloc --State--> Ekran
//
// NEDEN BLoC KULLANILIR?
// - Ekran sadece çizim yapar, hesap yapmaz
// - Mantık tek yerde toplanır, test kolay
// - Hata bulmak kolay: her şey event'le olur
//
// ==== BU DOSYA: EVENT ====
// Event = ekranın Bloc'a gönderdiği istek.
// Örn: "para yükle", "para harca".
// Event sadece VERİ taşır, iş yapmaz.
// İşi cuzdan_bloc.dart yapar.

// abstract = doğrudan nesnesi üretilmez.
// Sadece diğer event'ler buradan türer.
// Böylece Bloc "her event CuzdanEvent'tir"
// diyerek hepsini tek tipte kabul eder.
//
// @immutable = oluştuktan sonra değişmez.
// Event bir mektup gibidir, yazılınca
// içi değiştirilmez. Hata riskini azaltır.
@immutable
abstract class CuzdanEvent {
  const CuzdanEvent();
}

// -------------
// "Cüzdanı yükle" isteği.
// Uygulama açılınca gönderilir.
// Taşıyacak veri yok, o yüzden boş.
class CuzdanYukleEvent extends CuzdanEvent {
  const CuzdanYukleEvent();
}

// -------------
// "Para ekle" isteği.
// Ne için (baslik) ve ne kadar (miktar)
// bilgisini taşır.
// Örn: ParaYukleEvent(baslik: "Maaş",
//                     miktar: 500)
class ParaYukleEvent extends CuzdanEvent {
  final String baslik;
  final double miktar;

  // required = bu bilgiler zorunlu
  const ParaYukleEvent({required this.baslik, required this.miktar});
}

// --------------
// "Para harca" isteği.
// Yapısı aynı, ama Bloc bunu görünce
// bakiyeden DÜŞER. Ayrı sınıf olmasının
// sebebi: Bloc hangisi geldiğini ayırt eder.
class ParaHarcaEvent extends CuzdanEvent {
  final String baslik;
  final double miktar;

  const ParaHarcaEvent({required this.baslik, required this.miktar});
}
