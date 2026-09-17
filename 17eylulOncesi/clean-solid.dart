
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

abstract class IndirimStrateisi{
    double uygula(double toplam);
}

class Indirim10 implements IndirimStrateisi{
    @override
    double uygula(double toplam) => toplam * 0.90;
}       

class Yaz20 implements IndirimStrateisi{
    @override
    double uygula(double toplam) => toplam * 0.80;
}   

class Sepette50 implements IndirimStrateisi{
    @override
    double uygula(double toplam) => toplam - 50;
}   

class IndirimYok implements IndirimStrateisi{
    @override
    double uygula(double toplam) => toplam;
}   

class IndirimFactory{
    static IndirimStrateisi getIndirimStrateisi(String kuponKodu){
        switch(kuponKodu){
            case "INDIRIM10":
                return Indirim10();
            case "YAZ20":
                return Yaz20();
            case "SEPETTE50":
                return Sepette50();
            default:
                return IndirimYok();
        }
    }

// -----------------------------------------------

class SiparisSiralayici {
    final ISiparisKaydedici siparisKaydedici;
    final IKargoServisi kargoServisi;
    final IBildirimServisi bildirimServisi;
    final IFaturaServisi faturaServisi;

    SiparisSiralayici({
        required this.siparisKaydedici, 
        required this.kargoServisi, 
        required this.bildirimServisi, 
        required this.faturaServisi
    });
}

  void siparisTamamla(
      String orderId,
      List<Urun> sepet,
      String odemeTipi,
      String musteriAdi,
      String email,
      String tel,
      String adres,
      String? kuponKodu) {
    
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

   final indirimliToplam = indirimFactory.getIndirimStratejisi(kuponKodu ?? "").uygula(toplam);
    double kdv = indirimliToplam * 0.20;
    double sonTutar = indirimliToplam + kdv;

    final odemeStratejisi = OdemeStratejisiFactory.getOdemeStratejisi(odemeTipi);
    final tahsilEdilen = odemeStratejisi.odemeYap(sonTutar);

    kaydedici.kaydet(orderId, tahsilEdilen);
    faturaServisi.yazdir(orderId);
    bildirimServisi.mailGonder(email, "Sayin $musteriAdi, siparisiniz alindi. Tutar: $tahsilEdilen TL");
    bildirimServisi.smsGonder(tel, "Siparisiniz onaylandi: $orderId");  
    kargoServisi.gonder(orderId, adres);
  }
}

void main() {
  var siparisci = SiparisSiralayici(
    siparisKaydedici: SiparisKaydedici(),
    kargoServisi: KargoServisi(),
    bildirimServisi: BildirimServisi(),
    faturaServisi: FaturaServisi()
  );

  var urun1 = FizikselUrun("1", "Kablosuz Mouse", 450.0, 5, "FIZIKSEL");
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