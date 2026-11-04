// ============================================================
// DOSYA 1: Sealed Class + Record + Mixin + Interface (Dart 3)
// ============================================================
// [MİMARİ ÖZET]
// Bu dosya bir "ödeme" akışını katmanlı modelliyor:
//  1) Sealed class : Sonuçları KAPALI bir kümeyle modeller
//     (Başarılı / Başarısız). Hata için exception fırlatmak
//     yerine "sonucu değer olarak döndürme" (Result pattern).
//  2) Interface    : IBankaServisi sayesinde çağıran kod somut
//     bankaya bağımlı kalmaz (SOLID "D": Dependency Inversion).
//  3) Mixin        : Güvenlik ve log yetenekleri, kalıtım zinciri
//     kurmadan sınıfa eklenir (composition over inheritance).
//  4) Record       : Küçük veri paketi, ayrı class yazmadan taşınır.
// ============================================================

// [KİLİT - MÜLAKAT] sealed class kuralları:
// - Soyuttur, doğrudan new ile üretilemez.
// - Alt sınıfları SADECE aynı kütüphanede (aynı dosyada)
//   tanımlanabilir. Dışarıdan extends / implements edilemez.
// - Bu yüzden switch içinde derleyici tüm alt tipleri bilir.
//   Birini yazmazsan DERLEME HATASI alırsın (exhaustive check).
sealed class OdemeDurumu {}

// Ödeme başarılı durumu. OdemeDurumu'nun alt tipidir.
class OdemeBasarili extends OdemeDurumu {
  // [KİLİT] Record tipi: isimli iki alanlı hafif veri paketi.
  // Ayrı bir model class'ı yazmadan referans kodu + tutar taşır.
  // Record'lar değer eşitliğine sahiptir (içerik aynıysa eşit).
  final ({String referansKodu, double tutar}) veri;

  // Başarılı sonuç, veriyle birlikte oluşturulur.
  OdemeBasarili(this.veri);
}

// Ödeme başarısız durumu. OdemeDurumu'nun alt tipidir.
class OdemeBasarisiz extends OdemeDurumu {
  // Hatanın kullanıcıya gösterilecek açıklaması.
  final String hataNedeni;

  // Başarısız sonuç, sebep metniyle oluşturulur.
  OdemeBasarisiz(this.hataNedeni);
}

// -----------------------------------------------------------
// BANKA SERVİSİ
// -----------------------------------------------------------

// [MİMARİ] Interface (Dart'ta abstract class ile yapılır).
// Sözleşme: "Her banka servisi odemeYap metoduna sahip olmalı."
// UI / iş mantığı sadece bu soyutlamayı bilir. Test sırasında
// sahte (mock) banka servisi kolayca takılabilir.
abstract class IBankaServisi {
  // async iş: Future döner. Dönüş tipi sealed olduğu için
  // çağıran taraf switch ile her durumu zorunlu işler.
  // required: miktar isimli parametre olarak verilmek zorunda.
  Future<OdemeDurumu> odemeYap({required double miktar});
}

// GÜVENLİK MİXİN
// [KİLİT] Mixin: Sınıfa "yetenek" ekler, kendi constructor'ı
// yoktur ve "with" ile kullanılır. Çoklu kalıtım yerine geçer.
mixin GuvenlikDenetimiMixin {
  // Token boş değilse ve en az 32 karakterse geçerli sayar.
  bool tokenGecerliMi(String token) {
    return token.isNotEmpty && token.length >= 32;
  }
}

// LOG MİXİN
mixin AuditLogMixin {
  // Her işlemi zaman damgasıyla konsola yazar.
  void islemKaydet(String mesaj) {
    // ISO 8601 formatında şu anki zaman (loglamada standarttır).
    final zaman = DateTime.now().toIso8601String();
    // [DİKKAT] Gerçek projede print yerine logger paketi kullan.
    // print, release build'de de çalışır ve yönetilemez.
    print('Log - $zaman: $mesaj');
  }
}

// [KİLİT - SIRALAMA] Dart'ta sıra şöyledir:
//   extends  ->  with  ->  implements
// "with" mixin ekler (kodu hazır gelir).
// "implements" sözleşmeyi uygulatır (kod gelmez, yazmak şart).
class GarantiBankasiServisi
    with GuvenlikDenetimiMixin, AuditLogMixin
    implements IBankaServisi {
  // Bankanın API anahtarı. final: sonradan değiştirilemez.
  final String apiAnahtari;

  // required isimli parametre: anahtarsız servis üretilemez.
  GarantiBankasiServisi({required this.apiAnahtari});

  // Interface'teki metodu uygular.
  @override
  Future<OdemeDurumu> odemeYap({required double miktar}) async {
    // Önce güvenlik kontrolü yapılır (mixin'den gelen metot).
    if (!tokenGecerliMi(apiAnahtari)) {
      // [DÜZELTME - GÜVENLİK] Orijinalde API anahtarı loga
      // yazılıyordu. Gizli anahtarlar ASLA loga yazılmaz.
      islemKaydet("Ödeme reddedildi. Geçersiz API anahtarı.");
      // İstisna fırlatmak yerine başarısız sonucu DEĞER olarak döner.
      return OdemeBasarisiz("Yetkilendirme hatası: Geçersiz token.");
    }

    // Banka ağ gecikmesini simüle eder (1 saniye bekler).
    // await: bu satırda bekler ama UI donmaz (event loop serbest).
    await Future.delayed(const Duration(milliseconds: 1000));

    // Onay logu. (Orijinal yazım hatası düzeltildi: ödeme)
    islemKaydet('$miktar tutarındaki ödeme Garanti Bankası tarafından ONAYLANDI.');

    // Başarılı sonucu, record verisiyle döner.
    // [DÜZELTME] miktar zaten double, .toDouble() gereksizdi.
    return OdemeBasarili((
      referansKodu: 'GRNT-${DateTime.now().millisecondsSinceEpoch}',
      tutar: miktar,
    ));
  }
}

// 4- SONUCU YAZDIRAN FONKSİYON
void odemeSonucunuEkranaBas(OdemeDurumu durum) {
  // [KİLİT] Switch EXPRESSION (Dart 3): değer döndüren switch.
  // sealed olduğu için default yazmaya gerek yok; yeni bir alt
  // sınıf eklenirse burada DERLEME HATASI çıkar (güvenli genişleme).
  final mesaj = switch (durum) {
    // Tip kontrolü + değişkene atama (type pattern) tek satırda.
    OdemeBasarili b =>
      'Ödeme Başarılı. Ref: ${b.veri.referansKodu}, Tutar: ${b.veri.tutar} TL.',
    OdemeBasarisiz h => 'Ödeme Başarısız. Gerekçe: ${h.hataNedeni}',
  };
  // Hazırlanan mesajı yazdırır.
  print(mesaj);
}

// Uygulamanın giriş noktası. async: içinde await kullanıldığı için.
void main() async {
  // [DİKKAT] Anahtar koda gömülmemeli (git'e sızar).
  // Gerçekte: --dart-define, .env veya secure storage kullan.
  final apiAnahtari =
      "fdsfdgfdgfdgfdfdsfdgfdgfdgfdfdsfdgfdgfdgfdfdsfdgfdgfdgfdfdsfdgfdgfdgfd";

  // [MİMARİ] Değişken tipi interface olsun: bağımlılık soyuta.
  // Yarın başka banka gelirse sadece bu satır değişir.
  final IBankaServisi garanti = GarantiBankasiServisi(apiAnahtari: apiAnahtari);

  // 100 (int literal) otomatik double'a çevrilir. 1 sn bekler.
  final sonuc = await garanti.odemeYap(miktar: 100);

  // Sonucu işleyip ekrana basar.
  odemeSonucunuEkranaBas(sonuc);
}