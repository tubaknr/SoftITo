// Mülakat için önemli: 
// Sealed sınıflar dışardan extends edilmez 
//switch içinde tüm alt sınıflar tüketilmek zorundadır.

sealed class OdemeDurumu{}

// Ödeme başarılı durumu 
class OdemeBasarili extends OdemeDurumu{
  final ({String referansKodu, double tutar}) veri;
  OdemeBasarili(this.veri);
}

// Ödeme başarısız durumu
class OdemeBasarisiz extends OdemeDurumu{
  final String hataNedeni;
  OdemeBasarisiz(this.hataNedeni);
}

// ----------------------------------------------------- 
//BANKA SERVİSİ

abstract class IBankaServisi{
  Future<OdemeDurumu> odemeYap({required double miktar});
}

// GÜVENLİK MİXİN
mixin GuvenlikDenetimiMixin{
  bool tokenGecerliMi(String token){
    return token.isNotEmpty && token.length >=32;
  }
}

// LOG MİXİN
mixin AuditLogMixin{
  void islemKaydet(String mesaj){
    final zaman = DateTime.now().toIso8601String();
    print('Log - $zaman: $mesaj');
  }
}

class GarantiBankasiServisi with GuvenlikDenetimiMixin, AuditLogMixin implements IBankaServisi{
  final String apiAnahtari;

  GarantiBankasiServisi({required this.apiAnahtari});

  @override
  Future<OdemeDurumu> odemeYap({required double miktar}) async {
    if (!tokenGecerliMi(apiAnahtari)){
        islemKaydet("Ödeme Reddedildi. GEçersiz API Anahtarı: $apiAnahtari");
        return OdemeBasarisiz("Yetkilendirme hatası: Geçersiz token.");   
    }
    await Future.delayed(const Duration(milliseconds: 1000));

    islemKaydet('$miktar tutarındaki ödem Garanti Bankası tarafından ONAYLANDI.');

    return OdemeBasarili((referansKodu: 'GRNT-${DateTime.now().millisecondsSinceEpoch}', tutar: miktar.toDouble()));
  }
}

// 4- SONUCU YAZDIRAN FONK
void odemeSonucunuEkranaBas(OdemeDurumu durum){
  final mesaj = switch(durum){
    OdemeBasarili b => 'Ödeme Başarılı.Ref: ${b.veri.referansKodu}, Tutar: ${b.veri.tutar} TL.',
    OdemeBasarisiz h => 'Ödeme Başarısız. Gerekçe: ${h.hataNedeni}',
  };
  print(mesaj);
}

void main() async{
  final apiAnahtari = "fdsfdgfdgfdgfdfdsfdgfdgfdgfdfdsfdgfdgfdgfdfdsfdgfdgfdgfdfdsfdgfdgfdgfdfdsfdgfdgfdgfd";

  final garanti = GarantiBankasiServisi(apiAnahtari: apiAnahtari);
  final sonuc = await garanti.odemeYap(miktar: 100);
  odemeSonucunuEkranaBas(sonuc);
}


