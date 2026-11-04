// KİLİT NOKTA: Uygulama içerisinde taşınacak bildirim verisinin şemasını (modelini) belirleyen sınıf.
class BildirimModeli {
  // Bildirimin benzersiz kimlik numarasını (ID) tutan sabit değişken
  final String id;

  // Bildirimin başlık metnini tutan sabit değişken
  final String baslik;

  // Bildirimin ana açıklama/gövde metnini tutan sabit değişken
  final String icerik;

  // Bildirimin oluşturulduğu veya alındığı tarih/saat bilgisini tutan değişken
  final DateTime tarih;

  // Bildirimin okundu mu okunmadı mı olduğunu belirten boolean değer
  final bool okunduMu;

  // KİLİT NOKTA: Sınıfın zorunlu alanlarını dışarıdan alan, okunduMu değerine ise varsayılan olarak 'false' atayan kurucu (constructor) metot.
  const BildirimModeli({
    required this.id,
    required this.baslik,
    required this.icerik,
    required this.tarih,
    this.okunduMu = false,
  });

  // KİLİT NOKTA: Nesnenin immutability (değiştirilemezlik) kuralını bozmadan, sadece istenen alanlarını güncelleyerek yeni bir kopya oluşturmasını sağlayan metot (State yönetimi için çok önemlidir).
  BildirimModeli copyWith({
    String? id,
    String? baslik,
    String? icerik,
    DateTime? tarih,
    bool? okunduMu,
  }) {
    // Yeni nesne dönerken parametre gelmişse yenisini, gelmemişse mevcut (this) değeri korur (?? operatörü ile).
    return BildirimModeli(
      id: id ?? this.id,
      baslik: baslik ?? this.baslik,
      icerik: icerik ?? this.icerik,
      tarih: tarih ?? this.tarih,
      okunduMu: okunduMu ?? this.okunduMu,
    );
  }
}
