// 
abstract class LoncaUyesi{
  final String rumuz;

  LoncaUyesi({
    required this.rumuz
  });

  // soyut metot abstract metot
  void ozelYetenekKullan();

  void loncaSelamVer(){
    print("$rumuz Lonca Bayrağını Selamladı: 'Onur ve Zafer için'");
  }
}


class Sovalye extends LoncaUyesi{
  Sovalye({ 
    required super.rumuz
 });

  // ana class daki soyut metot burada kullanılmalı!!!
  @override
  void ozelYetenekKullan(){
    print("$rumuz Demir kalkanını kaldırdı ve savunma duvarı ördü.");
  }
}


class Sifaci extends LoncaUyesi{
  
  Sifaci({
    required super.rumuz
  });

  @override 
  void ozelYetenekKullan(){
    print("Kutsal ışık büyüsüyle tüm takımın canını tazeledi.");
  }
}


void savasAlanindaKomutVer(List<LoncaUyesi> takim){
  print("Liderin emriyle takım yetenekleri devreye girsin!");

  for(var t in takim){
    t.loncaSelamVer();
    t.ozelYetenekKullan();
  } 
}


void main(){
  print("Lonca Takımı");
  final List<LoncaUyesi> loncaBirligi = [
    Sovalye(rumuz: "Kızıl Şövalye Adil"),
    Sifaci(rumuz: "Orman Perisi Shahd"),
    Sovalye(rumuz: "Gümüş Muhafız Eren"),
  ];

  // hpsini tek bir emir ile çalıştırıyoruz.
  savasAlanindaKomutVer(loncaBirligi);


}
















