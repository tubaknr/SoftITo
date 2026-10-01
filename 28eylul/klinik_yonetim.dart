// 1. Enumları (derleme zamanı güvenliği; yazım hatalarını engellemek için)
// enum kullanmanın amacı, typo hatasını daha kod çalışmadan yakalamaktır. 
// bu şekilde sabit bir seçenek listesi tanımlanır. 
enum HizmetKategorisi{
  ciltYenileme,
  medikalEstetik,
  lazerEpilasyon,
  Lipo
}

// bir seansın içinde bulunabileceği durumları tanımlayan bir enum burası. 
enum SeansDurumu{
  bekliyor,
  odadaIslemde,
  tamamlandi,
  iptalEdildi
}

// ödeme yöntemlerini kapsayan enum'dur. 
enum OdemeYontemi{
  krediKarti,
  havaleEft,
  nakit,
  klinikPaketKredisi
}

// Danışan (müşteri) Modeli
// Model = gerçek hayattaki bir şeyin koddaki karşılığı.
// class ile bu Danışan modeli başlatılır. 
class Danisan{
  // Danışanın benzersiz kimlik kodudur. STring olarak kaydedilir, 
  //hem sayılardan hem harflerden oluşabilir çünkü.
  final String id;
  final String adSoyad;
  final String telefon;
  // bool değer, vip üye ise true. 
  final bool vipUyeMi;
  // STringlerden oluşan sırali liistedir. ? olmadığı için boş liste olabilir ama null olamaz. 
  final List<String> alerjiler; // boş olabilir ama null olamaz!
  // null olabilir öel cilt notu. Stringden oluşur. 
  final String? ozleCiltNotu; // opsiyonel null olabilir

// constructor method. yapıcı emthod yani. bir danışan nesnesi olutururken kullanılır.
// başında const var -> oluşturduktan sonra asla değişemeyecek. 
  const Danisan({
    // required -> bu bilgi zzorunlu, verilmezse program derlenmeyecek. 
    // this.id -> gelen parametreyi otomatik yuarıdaki id alanına tanımlar.  
    required this.id,
    required this.adSoyad,
    required this.telefon,
    // required -> zorunlu değil. 
    this.vipUyeMi = false,
    // required yok-> zorunlu değil. verilmezse: varsayılan boş liste. alerji yok. 
    this.alerjiler = const [],
    // verilemzse null. required yok-> zorunlu değil. 
    this.ozleCiltNotu,
    // constructor kapanır. 
  });

// get -> getter -> parantezsiz çağrılır. hesaplama yapıp sonuç döndürür. 
// danisan.hassasCiltMi şeklinde parantezsiz çağrılır. 
// en az 1 alerjisi varsa hassas cilt kabul edilecek. 
  bool get hassasCiltMi => alerjiler.isNotEmpty; // boş değilse true olacak, boşsa false olacak.

  // Bilgi Özet Kartı
  // getter. 
  String get bilgiOzeti {
    // koşul ? "..." : "..." => koşul doğruysa soldakini değilse sağdakini seç demektir.  eğer sağ seçilirse 
    //alerjiler virgül le birleştirilecek basılacak. 
    final String alerjiBilgisi = alerjiler.isEmpty ? "Kayıtlı alerji yok" : "Alerjiler: ${alerjiler.join(", ")}";
    // deger ?? "..." => deger null ise sağdakini kullan demektir. 
    final String notBilgisi = ozleCiltNotu ?? "Özel Medikal Not girilmemiş";
    // vip üye değilse standart yazacak üye is VIP yazacak. 
    final String vipRozeti = vipUyeMi ? "VIP" : "Standart";
    // string interpolation ile değerler yazdırılıyor
    // burada tüm parçalar tek bir emtin olarak döndürülür.
    return "$vipRozeti $adSoyad ($telefon) | $alerjiBilgisi | Not: $notBilgisi";
  }
}

// Seans (Randevu) Modeli
class SeansKaydi {
  final String seansKodu;
  // Danışan, Danışan classından gelecek. Composition => bir sınıfın 
  //başka bi rsınıf içinde kullanılmasıdır. 
  final Danisan danisan;
  // kategori bilgisi HizmetModeli enum dan gelecek. 
  final HizmetKategorisi kategori;
  final String islemAdi;
  final double birimFiyat;
  final int seansSayisi;
  final double indirimOrani; // örn 10.0
  // ? var -> null olabilir.
  final String? sorumluUzman;
  // final değil -> çünkü seans ilerledikçe seansın durumu değişecek !!! 
  SeansDurumu durum;
  // ? varsa null olabilir demek, ? yoksa asla null olamaz! 
  // final değil -> seans tamamlanana kadar ödeme yok. null yani 
  //bu süreç boyunca. tamamlanınca doldurulur. 
  OdemeYontemi? odemeTipi;

// const yok -> durum ve ödemeTipi sonradan değişebilr bu yüzden const yok. 
// Constructor. 
  SeansKaydi({
    // required -> zorunlu 
    required this.seansKodu,
    required this.danisan,
    required this.kategori,
    required this.islemAdi, 
    required this.birimFiyat,
    // verilmezse 1 seans kabul edilir. 
    this.seansSayisi=1,
    // verilmezse indirim yok. 0.0
    this.indirimOrani=0.0,
    // veilmezse uzman atanmamış olarak kabul edilir. 
    // null olabilir çünkü yukarıda ? var.
    this.sorumluUzman,
    // verilmezse başlangıç durumu "bekliyor"
    this.durum=SeansDurumu.bekliyor,
    // verilemzse ödeme tipi henüz yok. null olabilr çünkü 
    //yukarıda ? ile tanımlandı.
    this.odemeTipi,
  });

// indirm uygulanmadan önceki tutar. sonuçta double tipinde veri dönecek. 
//o yüzden double ile başlar. return tipiyle başlar.
// arrow fcn -> birimfiyat ile seans sayısı çarpılır. brüt tutaı hesaplayan 
//bir getter fonksiyondur bu.
  double get brutTutar => birimFiyat*seansSayisi;

// double tipinde değer dönecek.
// getter. 
// indirim tutarını hesaplayacak.
  double get indirimTutari{
    // indirim orwanı, Seans Kaydı constructor içinde default 
    //0 olarak tanımlandı. yani vip değilse 0 indirim alır. 
    double toplamOran = indirimOrani;
    if (danisan.vipUyeMi){
      // eğer vip üye ise, her gelişine %10 indirim uygulanacak. 
      toplamOran += 10.0;
    }
    // değilse standart toplam oran ne ise onunla işlem görecek. 
    // burada nee kadar indrim yapılacağını döner.
    // double tipinde. yani ne kadar eksiltilecek. 
    return brutTutar * (toplamOran / 100.0);
  }

// burada double tipinde, net tutarı hesaplar. yukarıda çıkartılması 
//gereken değer brut tutardan çıkartılır. net tutr hesaplanır ve dönülür.
  double get netTutar => brutTutar - indirimTutari;

}

// Yönetim Servisi

// bu tüm danışan ve seansları yöneten beyin class. 
class KlinikYoneticisi{
  final String subeAdi;
  // _ -> private değer. sınıf dışından erilşilmemesi gerekir. 
  // ayrıca _ olduğu için dışarıdan bu listeye ekleme silme yapılamaz. 
  //sadece bu sınıfın kendi metotlarıyla yapılabilir. bu encapsulation dır. 
  // _seanslar = tüm seansların tutulduğu listedir.
  // boş liste ile başlar.
  // aşağıya requred olarak ayzmicaksan burada default bir değer ver.
  final List<SeansKaydi> _seanslar = [];
  // anahtar değer çifti sözlüğüdür.
  // anahter: danışan idsi. key: danışan objesi. 
  //id ile danışan hızlıca bulunabilir bu sayede.
  // _ var -> private. 
  // boş {} olarak başlatılıyor. 
  final Map<String,Danisan> _danisanRehberi = {};

// constructor. 
// yönetici oluşşturulurken sube adı zorunlu.
  KlinikYoneticisi({ required this.subeAdi });

  // Danışan kaydetme
  // void -> bu fonk, bir sonunç döndürmez sadec işini yapar anlmıana gelir. 
  void danisanKaydet(Danisan danisan){
    // yukarıda tanımlanan mapin içine kaydedilir. 
    // aynı id ile tekrar kaydedilirse, eski kaydın üzerine yazılacak. 
    _danisanRehberi[danisan.id] = danisan;
    // ${} -> içeride bir hesaplama aypılıyor demektir.
    // ekrana bilgi emsajı yazdırılır. vip üye ise VIP değilse standart ayzılır.  
    print("Rehbere Eklendi: ${danisan.adSoyad} (${danisan.vipUyeMi ? "VIP" : "Standart"})");
  }

// yeni randevu ssitmee ekleir. return değeri yok->void. sadece işlem yapar.
// pm olarak içine SeansKaydı tipinde bir seans alır.
  void randevuOlustur(SeansKaydi seans){
    // seanslar array inin içine bu seans eklenir. 
    _seanslar.add(seans);
    // kayıt tamamlandıktan sonra ekrana basılacak emtin. 
    // ${} ile değişkenler ve hesaplamalar da basılabilir. 
    print("Randevu kaydedildi [${seans.seansKodu}]: ${seans.danisan.adSoyad} -> ${seans.islemAdi}");
  }

  // bir seansı tamamlayıp ödemesini alan metottur. 
  // seanskodu ve odemeyönemi alıyor. 
  void seansiTamamla({
    // required -> zorunlu.
    required String seansKodu,
    required OdemeYontemi odeme,
  }){
    // tüm seanslar içinde geziniyor for loop ile. 
    for(var seans in _seanslar){
      // eğğer seansın kodu, seansiTamamla'ya verilen kod ile aynı ise buraya gir:
      if (seans.seansKodu == seansKodu){
        // o seansın durumunu tamamlandı'ya çek.
        seans.durum = SeansDurumu.tamamlandi;
        // o seansın odeme tipini verilen odeme tipi olarak kaydet. 
        seans.odemeTipi = odeme;
        // ekrana seans tamamlandı bilgi mesajı bastır. 
        // seansın en ttuarı sadec noktadan sonra 2 haneyi göserecek şekilde yazılacak. 
        print(
          "Seans Tamamlandı: [${seans.seansKodu}]: ${seans.netTutar.toStringAsFixed(2)} tahsil edildi ${odeme.name}");
          // seans bulunursa aşağıdaki seans bulunamadı yazısını yazmasın. 
          return;
      }
    }
    // eğer seanslar içinde yoksa, seans bulunamadı yaz. 
    print("Hata [$seansKodu] kodlu seans bulunamadı.");
    return;
  }

// seans kodu alacak. iptal endeni null olabilir. {} içinde ve ? var. 
  void seansiIptalEt(String seansKodu, {String? iptalNedeni}){
    // tüm seansları gez for loop ile:
    for(var seans in _seanslar){
      // senas kodu verilne kod ile eşleşen bulursan
      if (seans.seansKodu == seansKodu){
        // onun durumunu iptalEdildi'ye çek.
        seans.durum = SeansDurumu.iptalEdildi;
        // ekrana bilgilendirme mesajı yaz. eğer iptal
        // nedeni varsa onu yaz, yoksa gerekçe belirtilemddi yaz. ?? var çünkü. 
        print("Seans iptal edildi [${seans.seansKodu}]: ${iptalNedeni ?? "Gerekçe Belirtilmedi"}");
        // çıkış yap.
        return;
      }
    }
  }

  // Finansal Rapor Metotları (Fonksiyonel Dart)
  // fonksiyonel -> döngü yazmak yerine where/fold gibi hazır fonksiyonlarla
  // zincirleme işlem yapmak.

  // toplam seansların en ttuarını double tipinde döner.
  // getter.
  double get toplamTahsilEdilenCiro => 
  // tüm seansları gezer, her brinde durumu tamamlandı lan her seansı alır, 
    _seanslar.where((s) => 
      s.durum == SeansDurumu.tamamlandi)
      // fold -> tüm listeyi tek değere indirger. 
      // kümülatif toplama başlar. 0 ile başlar. 
        .fold(0.0, (toplam,s) => 
        // toplamın üzerine her seansın net tutarı eklenir. 
          toplam + s.netTutar);

// bekleyen potansiyel geliri double tipinde döner.
// getter.
  double get bekleyenPotansiyelCiro => 
  // tüm senasları tek tek gezer.
    _seanslar.where((s) => 
    // seans durumu bekliyor yada işlemde olan her seansı alır
      s.durum==SeansDurumu.bekliyor || s.durum==SeansDurumu.odadaIslemde)
      // net tutarlarını kümülatif bir şekilde toplar.
        .fold(0.0,(toplam, s) =>
           toplam + s.netTutar);

  // Kategori bazlı seans sayıları
  // her kategoride kaç seans odluğunu dönen metot. Map dönecek. 
  Map<HizmetKategorisi,int> kategoriBazliSeansDagilimi(){
    // pm almaz. 
    // map tipinde dagilim objesi tanımlanır. sonucu tutacak. 
    final Map<HizmetKategorisi,int> dagilim = {};
    // for döngüsü içinde gezilir. 
    //values->enum içindeki tüm değerleri tek tek gezdirir. her kategoriyi. 
    for (var kat in HizmetKategorisi.values){
      // o kategorinin değerini 0 a ayarlar. 
      //hiç seansı olmaya kategori de raporda görünecek.
      dagilim[kat] = 0;
    }
    // tüm seanslar tek tek gezilir.
    for(var s in _seanslar){
      // dagilim içeriisinde en başta hepsi 0 a ayarlanmıştı.
      // burada seansın kategorisinin sayacını 1 arttırır.
      // sol tarf null ise 0 yapar. 
      dagilim[s.kategori] = (dagilim[s.kategori] ?? 0) + 1;
    }
    // hazırlanan dagilim map ini döndürür. 
    return dagilim;
  }


// Set, tekrar eden elemanı kabul etmeyen listedir.
// görevli uzmanalrın isimlerini döndürür. 
  Set<String> gorevliUzmanKadrosu(){
    // tüm seansları gezer. map ile tüm senasları tek tek alır.
    // o senasın sorumlu uzmanının ismini alır. null olanları eler.
    // sadece string leri alır. hepsini set e indirir. yani tekrar 
    //eden eleman hiç olmayacak.  
    return _seanslar.map((s) => s.sorumluUzman).whereType<String>().toSet();
  }

  // Uzmansız kalan seanslar
  // liste döner. uzmanı olamayn seansları döner. 
  List<SeansKaydi> uzmansizSeanslariGetir(){
    // tüm seansları tek tek gezer. her birinde sorumlu uman değeri 
    //null olanları alır. hepsini bir listeye çevirir.
    return _seanslar.where((s) => s.sorumluUzman == null).toList();
  }

  // güns onunda tüm duurmu tablo halinde ekrana bastırır. 
  void gunSonuRaporuYazdir(){
    print("Günlük Seans ve İşlem Çizelgesi");
    print("--------------------------------------------------");
    print(
      // kod üstunu 10 karakter genişliğinde
      "${'Kod'.padRight((10))} | "
      // Danışan üstunu 16 karakter genişliğinde
      "${'Danışan'.padRight(16)} | "
      // İşlem üstunu 20 karakter genişliğinde
      "${'İşlem'.padRight(20)} | "
      "${'Uzman'.padRight(18)} | "
      "${'Tutar'.padRight(10)} | "
      "${'Durum'} | "
      );
    print("--------------------------------------------------");

// tüm seansları tek tek gez.
    for(var s in _seanslar){
      // her birinin uzmanını al eğer uzmanı yoksa "nobtçi bekliyor" yaz.
      final String uzman=s.sorumluUzman ?? "Nöbetçi Bekliyor";
      // durumrozeti oluştur. switch case ile. seansın durumuna göre.
      final String durumRozeti = switch (s.durum){
        // durum tammalandı ile tamamlandı durum rozeti.
        SeansDurumu.tamamlandi => "Tamamlandı",
        SeansDurumu.odadaIslemde => "İşlemde",
        SeansDurumu.bekliyor => "Bekliyor",
        SeansDurumu.iptalEdildi => "İptal",
      };

  // tğm değerleri ekrana bastır. boşlukları ile. 
      print(
        "${s.seansKodu.padRight(10)} | "
        "${s.danisan.adSoyad.padRight(10)} | "
        "${s.islemAdi.padRight(10)} | "
        "${uzman.padRight(10)} | "
        // noktadans orna 2 değer göster sadece ve 10 boşluk. 
        "${s.netTutar.toStringAsFixed(2).padRight(10)} | "
        "$durumRozeti"
        );
    }

    print("--------------------------------------------------");
    print("Finansal Özet");
    //  noktadans orna 2 değer göster sadece
    print(" * Gerçekleşen (kasadaki net ciro) : ${toplamTahsilEdilenCiro.toStringAsFixed(2)}");
    // noktadans orna 2 değer göster sadece
    print(" * Bekleyen Potansiyel Alacak : ${bekleyenPotansiyelCiro.toStringAsFixed(2)}");
    // toplam seans saysıını basar. 
    print(" * Toplam Seans: ${_seanslar.length} Randevu");
    print("--------------------------------------------------");
    print("Aktif Uzmanlar");
    // tüm var lan uzmanalrı getirir.
    final uzmanlar = gorevliUzmanKadrosu();
    // eğer hiç uzman yoksa 
    if (uzmanlar.isEmpty){
      // ekrana abs.
      print("Kayıtlı Uzman Bulunamadı");
    } else {
      // eğer uzman varsa ekrana virgülle birleştirerek bas. 
      print(" ${uzmanlar.join(", ")}");
    }
    // uzmansız seansları getir
    final uzmansizlar = uzmansizSeanslariGetir();
    // uzmansiz seanslar 0 değilse gir:
    if (uzmansizlar.isNotEmpty){
      // ekrana bas. 
      print("Dikkat: ${uzmansizlar.length} adet seansa henüz uzman atanmamıştır.");
      // tüm uzmansızları gez:
      for(var u in uzmansizlar){
        // ekrana bas. -Z madde imidir. 
        print("-Z [${u.seansKodu}] ${u.danisan.adSoyad} (${u.islemAdi})");
      }
    }
    print("--------------------------------------------------");
  }
}

// Dart buradan abşlar program çalıştırılınca ilk bu program çalıştırılır. 
void main(){
  print("Klinik yönetim sistemi başlatılıyor...");
  // yönetici objesi üretilir ve şube ismi verilir.
  final yonetici = KlinikYoneticisi(subeAdi: "SoftITo Bağcılar Şubesi");

  //Danışanları luşturalım
  // danışan objeleri oluşturulur.. yukarıdak Danışan objesi ile. 
  final d1 = Danisan(
    id: "DAN-101", 
    adSoyad: "Ahmet Yılmaz", 
    telefon: "0555 555 55 55", 
    vipUyeMi: true, 
    alerjiler: ["Retinol, Aspirin"], 
    ozleCiltNotu: "Cilt bariyeri hassas"
  );

  final d2 = Danisan(
    id: "DAN-102", 
    adSoyad: "Ahmet Yılan", 
    telefon: "0555 555 55 55", 
    vipUyeMi: false, 
    alerjiler: []
  );

  final d3 = Danisan(
    id: "DAN-103", 
    adSoyad: "Mehmet Yılmaz", 
    telefon: "0555 555 55 55", 
    vipUyeMi: true, 
    alerjiler: ["Retinol, Aspirin"]
  );

  final d4 = Danisan(
    id: "DAN-104", 
    adSoyad: "Ahmet Mehmet Yılmaz", 
    telefon: "0555 555 55 55", 
    vipUyeMi: true, 
    alerjiler: [], 
    ozleCiltNotu: "Cilt bariyeri hassas"
  );

  // kliniğin rehberine kaydedilir. her biri ekrana mesaj yazar. 
  yonetici.danisanKaydet(d1);
  yonetici.danisanKaydet(d2);
  yonetici.danisanKaydet(d3);
  yonetici.danisanKaydet(d4);

  print("Danışan Güvenlik Kontrolü");
  // getter olduğu için parantez yok !!! 
  print(d1.bilgiOzeti);
  // getter olduğu için parantez yok !!! 
  print(d2.bilgiOzeti);
  print("--------------------------------------------------");

  // Randevular oluşturuluyor
  // seanslar oluşturulru burada. yukarıdaki class kullanılarak. 
  final seans1 = SeansKaydi(
    seansKodu: "SNS-2026-1", 
    danisan: d1, 
    kategori: HizmetKategorisi.Lipo, 
    islemAdi: "Lipo gerisini bilmiyorum", 
    birimFiyat: 6500.0, 
    seansSayisi: 2, 
    indirimOrani: 5.0, 
    sorumluUzman: "Sümeyye Arab"
  );

  final seans2 = SeansKaydi(
    seansKodu: "SNS-2026-2", 
    danisan: d2, 
    kategori: HizmetKategorisi.ciltYenileme, 
    islemAdi: "Siverex ile yüz temizleme", 
    birimFiyat: 2500.0, 
    seansSayisi: 5, 
    indirimOrani: 15.0, 
    sorumluUzman: null
  );

  final seans3 = SeansKaydi(
    seansKodu: "SNS-2026-3", 
    danisan: d3, 
    kategori: HizmetKategorisi.lazerEpilasyon, 
    islemAdi: "Tüm vücut", 
    birimFiyat: 25000.0, 
    seansSayisi: 15, 
    indirimOrani: 0.0, 
    sorumluUzman: "Tuba Aydın"
  );

  final seans4 = SeansKaydi(
    seansKodu: "SNS-2026-4", 
    danisan: d4, 
    kategori: HizmetKategorisi.medikalEstetik, 
    islemAdi: "Burun Estetiği", 
    birimFiyat: 1500.0, 
    seansSayisi: 3,
    sorumluUzman: "Alaaddin Odabaşı"
  );

// randevular sisteme kaydedilir. her biri ekrana mesaj basar. 
  yonetici.randevuOlustur(seans1);
  yonetici.randevuOlustur(seans2);
  yonetici.randevuOlustur(seans3);
  yonetici.randevuOlustur(seans4);
  print("Seanslar Gönderiliyor");

  // Seanns 1 Başarıyla Tamamlanıyor (Kredi KArtı Ödeme)
// seansı tamalmla metodu ile bazı senasnalr tamamlanır. 
  yonetici.seansiTamamla(seansKodu: "SNS-2026-1", odeme: OdemeYontemi.krediKarti);
  yonetici.seansiTamamla(seansKodu: "SNS-2026-2", odeme: OdemeYontemi.nakit);
  // senasııpta et metodu ile bir seans iptal edilir. opsiyonel olan iptalnedeni de veirlir.
  yonetici.seansiIptalEt("SNS-2026-4", iptalNedeni: "Danışanın şehir dışından tanıdığı geldiği için gelemedi");

// gün sonu raporunu yazduran fonk çağrılır. ekrana 
//yuakrıda gün sonu fonksiyonu içindeki tüm printleri absar. 
  yonetici.gunSonuRaporuYazdir();
}

