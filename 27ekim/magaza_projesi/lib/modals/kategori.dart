// enum: Sabit, Sınırlı Sayıda Seçenekten Oluşan Bir Küme.
// Kategoriyi String Yerine Enum Yapmak, Yazım Hatalarını Derleme Anında Engeller.
// Bu Yapıya "Enhanced Enum" Denir: Her Değer Kendi Alanlarını Taşıyabilir.
enum Kategori {
  // Her Değer İki Bilgi Taşır: (Ekranda Görünecek Başlık, Çipte Gösterilecek Kısa İkon Metni).
  // "hepsi" Gerçek Bir Kategori Değil; Filtrede "Ayrım Yapma" Anlamında Kullanılır.
  hepsi('Tümü', 'H'),
  elektronik('elektronik', 'E'),
  ayakkabi('Ayakkabı', 'A'),
  aksesuar('aksesuar', 'AK'),
  // Son Değerden Sonra ";" Gelir, Çünkü Aşağıda Alanlar ve Kurucu Tanımlanıyor.
  taki('taki', "T"),
  giyim('giyim', "G");
  
  // Her Enum Değerinin Taşıdığı Başlık (Örn: Kategori.giyim.baslik → "Giyim").
  final String baslik;
  // Her Enum Değerinin Taşıdığı Kısa İkon Metni.
  final String ikon;

  // Yukarıdaki Parantez İçindeki Değerleri Bu Alanlara Atayan Sabit (const) Kurucu.
  const Kategori(this.baslik, this.ikon);
}

extension KategoriExtension on Kategori{
  String get gorunenAd{
    switch(this){
      case Kategori.hepsi:
        return "Tümü";
      case Kategori.elektronik:
        return "Elektronik";
      case Kategori.ayakkabi:
        return 'Ayakkabı';
      case Kategori.taki:
        return 'Takı & Mücevher';
      case Kategori.giyim:
        return 'Giyim';
      case Kategori.aksesuar:
        return 'Aksesuar';
    }
  }

  static Kategori apiMetindenUret(String apiMetni){
    switch(apiMetni.toLowerCase().trim()){
      case 'electronics':
        return Kategori.elektronik;
      case 'jewelery':
        return Kategori.taki;
      case "men's clothing":
        return Kategori.giyim;
      case "women's clothing":
        return Kategori.giyim;
      default:
        return Kategori.elektronik;
    }
  }
}