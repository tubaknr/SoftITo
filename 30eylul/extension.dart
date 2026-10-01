// EXTENSION => dartın yerleşik veri tiplerine dokunamdan 
// yeni metotlar vs eklemeler yapabiliyoruz.

// Extension, halihazırda var olan bir sınıfa (kendi yazdığınız bir sınıf ya da Dart/Flutter SDK'sının standart bir sınıfı, örn: String, int) orijinal kodunu değiştirmeden yeni metodlar, getter'lar veya setter'lar eklemenizi sağlar.


//Amaç: Mevcut tiplere "yardımcı" (helper) fonksiyonlar eklemek, kod okunabilirliğini artırmak ve extension method mantığıyla işlemleri zincirleme (fluent) hale getirmek.


extension oyunSayiUzantisi on int{
  String get toXpFormat{
    if(this <  1000) return "${this} XP";
    return "${(this/1000).toStringAsFixed(1)}K XP";
  }
}


extension MetinSansurUzantisi on String{
  String get temizOyuncuAdi{
    if (this.toLowerCase().contains("hile")){
      return "[YASAKLI_OYUNCU]";
    }
    return "$this";
  }
}


void main(){
  print("Extension metotları (tip genişletmeleri)");

  // int test ediyoruz
  final int kazanilanXp1 = 450;
  final int kazanilanXp2 = 128350;

  print("Görev 1 Ödülü      : ${kazanilanXp1.toXpFormat}");
  print("Boss Savaşı        : ${kazanilanXp2.toXpFormat}");

  final String oyuncu1 = "EjderKatili";
  final String oyuncu2 = "HileciAlaaddin";

  print("Kayıt 1 ${oyuncu1.temizOyuncuAdi}");
  print("Kayıt 2 ${oyuncu2.temizOyuncuAdi}");
  
}



