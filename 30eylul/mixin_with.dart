// mixin and with 

//Bir sınıfın kodunu birden fazla sınıfta paylaşmanıza olanak tanır.

//Amaç: Sınıflar arasında ortak davranışları (behavior) ve durumları (state/değişkenler) kod tekrarı yapmadan paylaşmak.

// Farklı hiyerarşilerdeki sınıfların aynı yeteneklere sahip olması gerektiğinde (Örn: Hem bir Bird hem de bir Airplane sınıfı Flyable mixin'ini kullanabilir).

mixin ucmaYetisi {
  int ucusIrtifasiMetre = 100;

  void gogeYuksel(){
    print("Uçuş Yetisi: Kanatlarını açtı ve $ucusIrtifasiMetre metreye yükseldi.");
  }
}


mixin GorunmezlikYetisi{
  void pelerinOrt(){
    print("Görünmezlik: Düşmanların gözünden tamamen kayboldu.");
  }
}

mixin AtesGucuYetisi{
  void alevSaldirisi(){
    print("Ateş gücü: kılıcını alevlendirdi ve alanı yaktı");
  }
}


class TemelKarakter{
  final String ad;
  TemelKarakter({
    required this.ad
  });
}

class EfsaneviEjderBinicisi extends TemelKarakter with ucmaYetisi, AtesGucuYetisi{
  final String ejderhaAdi;

  EfsaneviEjderBinicisi({
    required this.ejderhaAdi,
    required super.ad,
  });

  void hucumEt(){
    print("$ad ve ejderhası $ejderhaAdi savaşa atılıyor");
    gogeYuksel();
    alevSaldirisi();
  }
}

class GolgeSuikastci extends TemelKarakter with GorunmezlikYetisi{
  GolgeSuikastci({
    required super.ad
  });

  void suikastYap(){
    print("$ad hedefe sessizce yaklaşıyor.");
    pelerinOrt();
    print("Kritik Darbe Vurdu.");
  }
}


void main(){
  print("Süper güçler başlatılıyor...");
  final binici = EfsaneviEjderBinicisi(ejderhaAdi: "Aslıhan", ad: "Gencer");
  binici.hucumEt();

  final ikinci = GolgeSuikastci(ad: "Adil Murat");
  ikinci.suikastYap();
}




































