
extension AltinFormatUzantisi on int{
  // sayiyi formatlı altın metnine çevir
  String get toAltinKese => "${this} Altın";
}

extension AgirlikFormatUzantisi on double{
  // Agirligi Kg olarak goster
  String get toAgirlikKg => "${this.toStringAsFixed(1)} kg";
}

enum EsyaNadirligi{
  yaygin,
  nadir,
  destansi,
  efsanevi,
}

class ZindanExeption implements Exception{
  final String hataKodu;
  final String mesaj;
  final DateTime zaman = DateTime.now();

  ZindanExeption({
    required this.hataKodu, 
    required this.mesaj
  });

  @override 
  String toString() => "[$hataKodu] $mesaj ($zaman)";
}

class CantadaYerYokException extends ZindanExeption{
  CantadaYerYokException(double asim): super(
      hataKodu: "ERR_BAG_FULL", 
      mesaj: "Çanta Kapasitesi $asim kg aşıldı. Eşyayı alamazsınız."
    );
}

class YetersizAltinException extends ZindanExeption{
  YetersizAltinException(int eksik): super(
    hataKodu: "ERR_NO_GOLD",
    mesaj: "Bu işlem için $eksik altın daha gerekiyor."
  );
}


// paraçanaıp büyü tpzuna düşebilen eşylar
mixin ParcalanabilirYetisi{
  void tozaDonustur(String esyaAdi){
    print("Demirci $esyaAdi parçalandı ve 5 adet 'Mavi büyü tozu' elde edildi.");
  }
}


// rün basılarak ekstra güç kazandıran eşyalar
mixin RunBasmaYetisi{
  void runKasa(String runeTuru){
    print("Rün Büyüsü: Eşyaya '$runeTuru' rünü mühürlendi. +15 Büyü hasarı.");
  }
}

// Eşya item modeli
class Esya with ParcalanabilirYetisi, RunBasmaYetisi{
  final String id;
  final String ad;
  final double agirlik;
  final EsyaNadirligi nadirlik;
  final String? aciklama;
  bool efsunlumu;

  Esya({
    required this.id,
    required this.ad,
    required this.agirlik,
    required this.nadirlik,
    this.aciklama,
    this.efsunlumu = false
  });

  Esya.kucukCanIksiri()
  : id="POT-001",
    ad="Küçük Şifa İksiri",
    agirlik=0.5,
    nadirlik = EsyaNadirligi.yaygin,
    aciklama="İçildiğinde anında 30can yeniler",
    efsunlumu=false;

  // records 
  ({
    String etiket, 
    double carpan, 
    int satisFiyati
  }) degerlemeYap(){
    final (etiket, carpan, bazFiyat) = switch(nadirlik){
      EsyaNadirligi.yaygin => ("Yaygın", 1.0, 50),
      EsyaNadirligi.nadir => ("Nadir", 1.5, 200),
      EsyaNadirligi.destansi => ("Destansı", 2.5, 750),
      EsyaNadirligi.efsanevi when efsunlumu => ("Kadim Efsanevi", 5.0, 3000),
      EsyaNadirligi.efsanevi => ("Efsanevi", 4.0, 2000)
    };

    return (
      etiket: etiket,
      carpan: carpan,
      satisFiyati: (bazFiyat*carpan).toInt(),
    );
  }
}


class OyuncuCantasi{
  final String sahipAdi;
  final double maxAgirlikKapasitesi;
  final List<Esya> _esyalar = [];
  int _altin = 500;

  OyuncuCantasi({
    required this.sahipAdi,
    this.maxAgirlikKapasitesi = 25.0,
  });

  int get altin => _altin;

  void altinHarca(int miktar){
    if(miktar > altin){
      throw YetersizAltinException(miktar - _altin);
    }
    _altin -= miktar;
    print(
      "[Ticaret]: $miktar altın harcandı. Kalan cüzdan: ${_altin.toAltinKese}",
    );
  }

  // çata ağırlığı hesaplama
  double get mevcutAgirlik => _esyalar.fold(0.0, (acc, e) => acc + e.agirlik);
  
  // çantaya eşya ekleme
  void esyaEkle(Esya yeniEsya){
    if(mevcutAgirlik + yeniEsya.agirlik > maxAgirlikKapasitesi){
      final double asim = (mevcutAgirlik + yeniEsya.agirlik) - maxAgirlikKapasitesi;
      throw CantadaYerYokException(asim);
    } 
    _esyalar.add(yeniEsya);
    print("[Çanta]: '${yeniEsya.ad}' çantaya yerleştirildi. (${yeniEsya.agirlik.toAgirlikKg})",);
  }


  // sadece değerli eşyaları filtrele
  List<Esya> get degerliEsyalar => 
    _esyalar.where((e) 
      => e.nadirlik == EsyaNadirligi.destansi || e.nadirlik == EsyaNadirligi.efsanevi,).toList();


  // Çanta Döküm Raporu
  
  void envanterRaporuBas(){
    print("""
      =========================================================================
      Kahraman Envanter Raporu
      Sahip: $sahipAdi | Altın: ${_altin.toAltinKese} | Yük: ${mevcutAgirlik.toAgirlikKg}/${maxAgirlikKapasitesi.toAgirlikKg};
      =========================================================================
    """);

    for(var esya in _esyalar){

      final deger = esya.degerlemeYap();
 
      final aciklamaMetni = esya.aciklama ?? "Özel Nitelik Belirtilmemiş";
 
      print("${deger.etiket.padRight(20)} | ${esya.ad.padRight(24)} | ${esya.agirlik.toAgirlikKg.padLeft(8)} | Deger: ${deger.satisFiyati.toAltinKese}");

      print(" Not: $aciklamaMetni");
    }

    print("Değerli Eşya Sayısı: ${degerliEsyalar.length} Adet");
    print("===================================================================");
  }
}

void main(){

  print("Zindan + Envanter Motoru Başlatılıyor...");

  final bool vipUyelik = true;


  final canta = OyuncuCantasi(
    sahipAdi: "Elf Okçusu Neşet Aydın",
    maxAgirlikKapasitesi: 20.0
  );

  final List<Esya> zindanGirisPaketi = [
    
    Esya.kucukCanIksiri(),

    Esya(id: "SWD-101", ad: "Gümüş Ejder Kılıcı", agirlik: 4.5, nadirlik: EsyaNadirligi.destansi, aciklama: "Karanlık yaratıklra karşı %25 ek hasar", efsunlumu: true),
    
    if(vipUyelik)
      Esya(id:"RING-999", ad: "Zamanın Sonu Yüzüğü", agirlik: 0.2, nadirlik: EsyaNadirligi.efsanevi, aciklama: "Bekleme sürelerini %20 azaltır", efsunlumu: true),
  ];

  // eşyaları çantaya ekle
  for (var esya in zindanGirisPaketi){
    canta.esyaEkle(esya);
  }

  print("Zanaat ve büyü masası");

  final kilic = zindanGirisPaketi[1];
  kilic.runKasa("Kutsal Işık");
  kilic.tozaDonustur(kilic.ad);

  print("Ticaret ve Altın Harcama");
  try{
    canta.altinHarca(200);
    canta.altinHarca(800);
  } on YetersizAltinException catch(e){
    print("Hata Yakalandı ${e.mesaj}");
  } catch(e){
    print("Genel Hata $e");
  }

  print("Çanta Kapasitesi Aşımı");
  try{
    final devKaya = Esya(id: "BLD-777", ad: "Göktaşı Parçası", agirlik: 28.0, nadirlik: EsyaNadirligi.yaygin);
    canta.esyaEkle(devKaya);
  } on CantadaYerYokException catch (e){
    print("Aşırı yük engellendi: ${e.mesaj}");
  } 
  canta.envanterRaporuBas();

}


