
abstract class KargoHesaplayici{
    double hesapla();
}

class FizikselKargoHesaplayici implements KargoHesaplayici{
  @override
  double hesapla() => 29.90;
}

class DijitalKargoHesaplayici implements KargoHesaplayici{
  @override
  double hesapla() => 0.0;
}

class Urun {
  String id;
  String ad;
  double fiyat;
  int stok;
  String tip;
  final KargoHesaplayici kargoHesaplayici;

  Urun(this.id, this.ad, this.fiyat, this.stok, this.tip);

  double kargoUcreti() => kargoHesaplayici.hesapla();
}

class FizikselUrun extends Urun{
    FizikselUrun(String id, String ad, double fiyat, int stok)
      : super(id, ad, fiyat, stok, "FIZIKSEL", FizikselKargoHesaplayici());
}
class DijitalUrun extends Urun {
  DijitalUrun(String id, String ad, double fiyat, int stok)
      : super(id, ad, fiyat, stok, "DIJITAL");

}

// -----------------------------------------------  
// Fixed Interface Segregation Principle:
abstract class ISiparisKaydedici {
    void kaydet(String orderId,  double tutar);
}

abstract class IKargoServisi{
    void gonder(String orderId, String adres);
}

abstract class IBildirimServisi{
    void mailGonder(String email, String mesaj);
    void smsGonder(String tel, String mesaj);
}

abstract class IFaturaServisi{
    void yazdir(String orderId);
}

class SqliteSiparisKaydedici implements ISiparisKaydedici{
    @override
    void kaydet(String orderId, double tutar) {
        print("DB calistirildi: INSERT INTO siparisler VALUES ('$orderId', $tutar)");
    }
}

class MngKargoServisi implements IKargoServisi{
    @override
    void gonder(String orderId, String adres) {
        print("MNG Kargo takip fis basildi: $adres");
    }
}

class SmtpNetgsmBildirimServisi implements IBildirimServisi{
    @override
    void mailGonder(String email, String mesaj) {
        print("SMTP Mail gonderildi: " + email);
    }

    @override
    void smsGonder(String tel, String mesaj) {
        print("SMS iletildi: " + tel);
    }
}

class PdfFaturaServisi implements IFaturaServisi{
    @override
    void yazdir(String orderId) {
        print("Fatura PDF cikarildi: $orderId");
    }
}

// -----------------------------------------------
// Fixed Open Closed Principle: 
abstract class OdemeStratejisi {
    double odemeYap(double tutar);
}

class KrediKartiOdeme implements OdemeStratejisi{
    @override
    double odemeYap(double tutar){
    print("$tutar TL Kredi kartindan POS ile cekildi.");
    return tutar;
} 
}

class HavaleOdeme implements OdemeStratejisi{
    @override
    double odemeYap(double tutar) {
    print("$tutar TL Havale kontrol edildi.");
    return tutar;   
}
}

class KapidaOdeme implements OdemeStratejisi{
    @override
    double odemeYap(double tutar) {
    print("$tutar TL Kapida odeme tahsil edilecek (Komisyon +15 TL).");
    return tutar + 15;
}   
}

class CryptoOdeme implements OdemeStratejisi{
    @override
    double odemeYap(double tutar) {
    print("$tutar TL USDT transferi onaylandi.");
    return tutar;
}   
}

class OdemeStratejisiFactory {
    static OdemeStratejisi getOdemeStratejisi(String tip) {
        switch (tip) {
            case "KREDI_KARTI":
                return KrediKartiOdeme();
            case "HAVALE":
                return HavaleOdeme();
            case "KAPIDA_ODEME":
                return KapidaOdeme();
            case "CRYPTO":
                return CryptoOdeme();
            default:
                throw Exception("Gecersiz odeme yontemi: $tip");
        }
    }
 // -----------------------------------------------
  @override
  void kargoGonder(String orderId, String adres) {
    print("MNG Kargo takip fis basildi: $adres");
  }

  @override
  void mailGonder(String email, String mesaj) {
    mailci.mailAt(email, mesaj);
  }

  @override
  void smsGonder(String tel, String mesaj) {
    smsci.smsYolla(tel, mesaj);
  }

  @override
  void faturaYazdir(String orderId) {
    print("Fatura PDF cikarildi: $orderId");
  }

  void siparisTamamla(
      String orderId,
      List<Urun> sepet,
      String odemeTipi,
      String musteriAdi,
      String email,
      String tel,
      String adres,
      String kuponKodu) {
    
    double toplam = 0;

    for (var i = 0; i < sepet.length; i++) {
      if (sepet[i].stok <= 0) {
        print("Hata: " + sepet[i].ad + " tukenmis!");
        return;
      }
      toplam += sepet[i].fiyat;
      toplam += sepet[i].kargoUcretiHesapla();
      sepet[i].stok--;
    }

    if (kuponKodu == "INDIRIM10") { 
      toplam = toplam * 0.90;
    } else if (kuponKodu == "YAZ20") {
      toplam = toplam * 0.80;
    } else if (kuponKodu == "SEPETTE50") {
      toplam = toplam - 50;
    }

    double kdv = toplam * 0.20;
    double sonTutar = toplam + kdv;

    odemeYap(odemeTipi, sonTutar);
    siparisKaydet(orderId, sonTutar);
    faturaYazdir(orderId);
    mailGonder(email, "Sayin $musteriAdi, siparisiniz alindi. Tutar: $sonTutar TL");
    smsGonder(tel, "Siparisiniz onaylandi: $orderId");
    kargoGonder(orderId, adres);
  }
}

void main() {
  var siparisci = SiparisYoneticisi();

  var urun1 = Urun("1", "Kablosuz Mouse", 450.0, 5, "FIZIKSEL");
  var urun2 = DijitalUrun("2", "Flutter Kursu E-Kitap", 150.0, 100);

  var sepet = <Urun>[urun1, urun2];

  siparisci.siparisTamamla(
    "SP-9921",
    sepet,
    "KREDI_KARTI",
    "Selahaddin",
    "selahaddin@kodvance.com",
    "05551112233",
    "Kadikoy / Istanbul",
    "INDIRIM10",
  );
}