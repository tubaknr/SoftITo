// set ve Ağ Güvenlik Kümeleri


void main(){
  print("Beyaz Liste ve Küme Analizi");

  final Set<String> istanbulVeriMerkeziIpleri = {
    "10.0.1.10",
    "10.0.1.11",
    "10.0.1.12",
    "10.0.1.13",
    "10.0.1.10" // çift Kayıt! Set bunu anında teke indirir!
  };

  print("Istanbul IPleri: $istanbulVeriMerkeziIpleri");


  final Set<String> frankfurtVeriMerkeziIpleri = {
    "10.0.1.13",
    "10.0.1.30",
    "10.0.1.45"
  };

  print("Frankfurt IPleri: $frankfurtVeriMerkeziIpleri");

// intersection
  final ortakKopruIpleri = istanbulVeriMerkeziIpleri.intersection(frankfurtVeriMerkeziIpleri);
  print("Ortak Ağ Ipleri(kesişim): $ortakKopruIpleri");

// union
  final tumGlobalIpler = istanbulVeriMerkeziIpleri.union(frankfurtVeriMerkeziIpleri);
  print("Toplam Glbal Ipler(birleşim): $tumGlobalIpler");

// difference
  final sadeceIstanbul = istanbulVeriMerkeziIpleri.difference(frankfurtVeriMerkeziIpleri);
  print("Sadece Istanbul: $sadeceIstanbul"); // istanbulda olup frankfurtta olmayanalrı getirir


// CHALLENGE ------------------------------
  final bool isProduction = true;
  final Set<String> bulutServisler = {
    "servis1",
    "servis2",
  };

  final List<String> nihaiDagitimKumesi = [
    ...bulutServisler,
    if(isProduction) "vault-secret-manager" ,
  ];

  print("---------------------------------------------------------");
  
  print("$nihaiDagitimKumesi");

}

