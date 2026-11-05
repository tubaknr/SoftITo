// ============================================================
// DOSYA 4: Model + Interface + Servis (HTTP / JSON katmanı)
// ============================================================
// [MİMARİ ÖZET] Katmanlı yapının "veri" tarafı:
//  1) Model (UrunModel)   : Ham JSON'u tipli, değiştirilemez
//                           (immutable) Dart nesnesine çevirir.
//  2) Interface           : IUrunServisi sözleşmesi. UI/ViewModel
//                           somut sınıfı değil bunu bilir.
//  3) Concrete Service    : CanliApiUrunServisi gerçek HTTP işini
//                           yapar. Yarın "SahteUrunServisi" (test)
//                           veya "YerelDbUrunServisi" yazılabilir.
//  => Repository / Dependency Inversion yaklaşımı. Katmanlar:
//     UI -> (interface) -> Servis -> HTTP -> JSON -> Model
//
// [pubspec.yaml] Gerekli paket:  http: ^1.2.0
// ============================================================

import 'dart:convert';

// [DÜZELTME] Orijinalde "as http" yoktu ama kodda "http.get"
// kullanılmıştı (derlenmezdi). Takma ad (prefix) eklendi.
import 'package:http/http.dart' as http;

// Veri model sınıfı: API'den gelen bir ürünü temsil eder.
class UrunModel {
  // Ürünün benzersiz kimlik numarası. final: sonradan değişmez.
  final int id;
  // Ürünün başlığı.
  final String baslik;
  // Ürünün fiyatı. Ondalıklı olduğu için double.
  final double fiyat;
  // Ürün görselinin bağlantı adresi.
  final String resimUrl;
  // Ürünün kategorisi.
  final String kategori;

  // [KİLİT] const constructor: tüm alanlar final olmalı.
  // Not: Performans kazancı, değerler DERLEME ZAMANINDA bilinen
  // const kullanımlarda olur. JSON'dan gelen veri çalışma
  // zamanında oluştuğu için burada asıl kazanç "değişmezlik
  // (immutability)" garantisidir.
  const UrunModel({
    // required: nesne oluşturulurken verilmesi ZORUNLU alanlar.
    required this.id,
    required this.baslik,
    required this.fiyat,
    required this.resimUrl,
    required this.kategori,
  });

  // [KİLİT - MÜLAKAT] fromJson factory deseni:
  // Dışarıdan gelen JSON (Map) -> UrunModel dönüşümü modelin
  // kendi içinde yapılır. Böylece "parse" mantığı tek yerdedir.
  // json tipi Map<String, dynamic>'tir (anahtar: String, değer: her şey).
  factory UrunModel.fromJson(Map<String, dynamic> json) {
    // Dönüştürülen verilerle yeni bir UrunModel döner.
    return UrunModel(
      // "as int?" : değeri int veya null olarak kabul eder.
      // "?? 0"    : null ise 0 atar. (null-safe / güvenli parse)
      id: json['id'] as int? ?? 0,
      // title alanını String alır, null ise varsayılan metin.
      baslik: json['title'] as String? ?? 'İsimsiz Ürün',
      // [KİLİT] JSON'da 10 (int) da gelebilir 10.5 (double) da.
      // Bu yüzden önce "num" olarak alınır, sonra toDouble().
      // Doğrudan "as double" yazarsak int gelince çöker!
      fiyat: (json['price'] as num?)?.toDouble() ?? 0.0,
      // image alanı yoksa yedek görsel adresi kullanılır.
      // [DİKKAT] via.placeholder.com güvenilir olmayabilir;
      // projede yerel bir asset görseli daha sağlamdır.
      resimUrl: json['image'] as String? ?? 'https://via.placeholder.com/150',
      // category yoksa 'Genel' atanır.
      kategori: json['category'] as String? ?? 'Genel',
    );
    // [DİKKAT - TASARIM KARARI] Varsayılan değerler uygulamanın
    // çökmesini önler ama eksik/bozuk veriyi SESSİZCE gizler.
    // Kritik alanlarda (örn. id) hata fırlatmak daha doğru olabilir.
  }
}

// [MİMARİ] Servislerin uyması gereken sözleşme (interface).
// Dart'ta ayrı "interface" anahtar kelimesi yok; abstract class
// + implements ile aynı iş yapılır.
abstract class IUrunServisi {
  // Asenkron: Future döner. İçinde ürün listesi olacak.
  // Çağıran taraf sadece "ürünleri getir" der, nereden geldiğini bilmez.
  Future<List<UrunModel>> urunleriGetir();
}

// Gerçek API'den veri çeken servis.
// "implements": IUrunServisi sözleşmesini uygulamak ZORUNLU.
class CanliApiUrunServisi implements IUrunServisi {
  // İstek atılacak API adresi. static const: derleme zamanı sabiti,
  // tüm nesneler arasında paylaşılır. "_" : kütüphane içine özel.
  static const String _baseUrl = "https://fakestoreapi.com/products";

  // Interface'teki metodu override ettiğimizi belirtir.
  @override
  // async: içinde await kullanılacak. Sonuç Future olarak sarılır.
  Future<List<UrunModel>> urunleriGetir() async {
    // Ağ işlemi her an patlayabilir, o yüzden try-catch şart.
    try {
      // URL'e HTTP GET isteği atar ve cevabı BEKLER (await).
      // Uri.parse: String adresi Uri nesnesine çevirir.
      final yanit = await http.get(Uri.parse(_baseUrl)).timeout(
        // Zaman aşımı süresi: 10 saniye. Sonsuza kadar bekleme olmaz.
        const Duration(seconds: 10),
        // 10 sn içinde yanıt gelmezse bu fonksiyon çalışır.
        onTimeout: () {
          // Özel bir hata fırlatır; aşağıdaki catch yakalar.
          throw Exception('Ağ zaman aşımına uğradı.');
        },
      );

      // 200 = HTTP "OK" (başarılı) durum kodu.
      if (yanit.statusCode == 200) {
        // yanit.body ham metindir. jsonDecode onu Dart nesnesine çevirir.
        // API bir dizi döndürdüğü için List<dynamic> olarak cast edilir.
        final List<dynamic> hamListe =
            jsonDecode(yanit.body) as List<dynamic>;

        // Listedeki her ham elemanı UrunModel'e çevirir (map),
        // sonucu yeni bir listeye toplar (toList).
        return hamListe
            .map((eleman) => UrunModel.fromJson(eleman as Map<String, dynamic>))
            .toList();
      } else {
        // 200 dışındaki durumlar (404, 500 vb.) hata sayılır.
        throw Exception('Sunucu Hatası ${yanit.statusCode}');
      }
    } catch (e) {
      // try içinde oluşan HER hata (timeout, internet yok, parse...)
      // buraya düşer. Önce kayıt için yazdırılır.
      // [DİKKAT] Gerçek projede print yerine logger kullanılır.
      print("Ağ hatası: $e");

      // [KİLİT - MİMARİ] rethrow: hatayı YUTMAZ, orijinal stack
      // trace ile üst katmana (ViewModel/BLoC/UI) tekrar fırlatır.
      // Servis hatayı raporlar, "ekranda ne gösterilecek" kararını
      // üst katman verir (sorumlulukların ayrılması - SRP).
      rethrow;
    }
  }
}