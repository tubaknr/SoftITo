/*
void main(){
    // JS'deki gibi let x = "Ahmet"; x=42; yapılırsa hata alırız! Dart bunu kabul etmez!
    // print("İlk dersimiz!");


    int seansSuresiDakika = 45;
    double seansUcretiTL = 2750.50;
    String uzmanAdi = "Dr Tuba Aydın";
    bool aktifMi = true;

    // 2. String interpolation
    // JS'deki `${}` yerine saddece $degisken 
    // Eğer işlem varsa daa ${degisken*2} kullanılır.

    print("Uzman: $uzmanAdi | Süre: $seansSuresiDakika dk | Ücret: $seansUcretiTL TL");
    print("KDV dahil (%20) ${seansUcretiTL*1.2} TL'dir");

    var tedaviAdi = "Kahve ile Peeling"; // String e kitlenir ve bir daha değiştirilemez.
    // tedaviAdi = 99; // number değiştirilemez! 

    // 4. Dynamic veri tipini bağımsız kullanabilirsiniz ancak flutterda önerilmez.
    dynamic serbestKutu = "Lazer Epilasyon";
    serbestKutu = 1000; // İzin verilir ama veri tip güvenliğini yok eder!


    // const: DERLEME ANINDE DEĞERİ BELLİ OLAN VERİLER.
    //BELLEKTE TEK BİR YERDE SAKLANIR.
    const String KLINIK_ADI = "SoftITo Güzellik Merkezi";
    const double KDV_ORANI = 0.2;
    // const DateTime suankiZaman = DateTime.now(); // GİRİLMEZ! DERLEME AINDA BUNU BİLEMEYİZ! SÜREKLİ DEĞİŞEN DEĞER! 

    // final: ÇALIŞMA ANINDA HESAPLANIR. 1 KERE ATANDIKTAN SONRA DEĞİŞMEZ!
    final DateTime randevuZamani = DateTime.now();
    final String takipKodu = "SOFT-" + randevuZamani.microsecondsSinceEpoch.toString();

    print("Klinik adı: $KLINIK_ADI");
    print("Oluşturulma Tarihi: $randevuZamani | Kod: $takipKodu");
    

    // Dartta Bir değişken varsayılan olarak asla null olamaz!
    //  bunu yerine null safety operatörleri kullanırız.
    // (?, ??, !) gibi

    String zorunluDanisanAdi = "Meltem Demir";
    // zorunluDanisanAdi = null; // Hata verir!!1!
    // String danisanAlerjiNotu; //  Hata verir!!1!
    String? danisanAlerjiNotu; // ? konursa null olarak kullanılabilir!! İçi oş!1
    print(danisanAlerjiNotu); // null 


    // ifNull operatörü - null ise varasyılan değer atama
    String goruntulenecekNot = danisanAlerjiNotu ?? "Bilinen bir alerjisi yok";
    print("Rapor: $goruntulenecekNot");


    // null aware
    // print("Alerji metin uzunluğu: {$danisanAlerjiNotu.length}"); // null olan şeye .length gelmez hata verir!!!
    print("Alerji metin uzunluğu: {$danisanAlerjiNotu?.length}");


}   
*/
    // Klasik Sıralı Fonksiyon
    double topla(double a, double b) => a+b;


    // Modern Dart / Flutter standartları: Named Parameters ({})
   void seansKaydiOlustur({
        required String danisan,
        required String tedavi,
        required double birimFiyat,
        int seansSayisi = 1,
        double indirimOrani = 0.0,
        String? uzmanHekim,
    }){
        final double brutTutar = birimFiyat*seansSayisi;
        final double indirimTutari = brutTutar*(indirimOrani/100);
        final double netTutar = brutTutar - indirimTutari;

        print("""
        ==============================================
        SoftITo Seans Sözleşmesi
        ----------------------------------------------
        Danışan         :   $danisan
        Tedavi:         :   $tedavi (x$seansSayisi Seans)
        Uzman Hekim     :   ${uzmanHekim ?? "Nöbetçi Estetisyen"}
        Brüt Tutar      :   $brutTutar TL
        İndirim         :   -$indirimTutari TL ($indirimOrani)
        Ödenecek Tutar  :   $netTutar TL
        ==============================================
        """);
    }

void main(){
    seansKaydiOlustur(
        danisan: "Sümeyye Muhammed", 
        tedavi: "Medikal Cilt Yenileme", 
        birimFiyat: 4500.0, 
        seansSayisi: 3,
        indirimOrani: 15.0,
        uzmanHekim: "Dr. Shahd"
    );
}















