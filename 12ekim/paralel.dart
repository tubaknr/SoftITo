/* 
Future<void> fetchDashboardData() async{
  try{
    final result = await Future.wait([
      // HEPSİNİ AYNI ANDA ÇEKER
      fetchUserProfile(),
      fetchAccountBalance(),
      fetchNotification(),
    ], eagerError: true);

    print("Tüm veriler geldi. $result");

  } catch(e){
    print("İsteklerden biri başarısız. $e");
  }
}
*/ 


// FUTURE: TEK BİR KERE VERİ ÇEKECEĞİMİZ ZAMAN KULLANILIR. YA HATA YA DA DEĞER DÖNDÜRÜR.
// tek bir ok. TEK BİR SORGU. 

// STREAM: BİR BORU HATTI GİBİ ÇALIŞIR. PİPE DENİR. ZAMAN İÇİNDE 1 10 100 YADA SONSUZ SAYIDA VERİ AKIŞI SAĞLANABİLİR.
// BORSA FİYAT GÜNCELLEMESİ, GPS KONUM GÜNCELLEME, FIREBASE CANLI DİNLEME... LOGIN OLAN KİŞİ ŞU ANDA ONLINE MI OFFLINE MI ... ARKA PLANDA LOGIN OLAN KİŞİYİ SÜREKLİ KONTROL EDER. 
// bir boru akışı. su akışı gibi. devamlı bir akış. 

// BROADCAST: BİRDEN FAZLA DİNYEİCİ. ÇOKLU DİNLEYİCİ. ALTIN, BİR YANDAN ABD ALTINI, BİR YANDAN KAPALI ÇARŞI ALTINI, BİR YANDAN GRAM ALTINI, BİR YANDAN ÇEYREĞİ .... 



import 'dart:async';

void main(){
  //controller oluşturma
  final controller = StreamController<int>();

  // dinleyici (listener) bağlama
  // takip eden fonksiyon!!! 
  final subscription = controller.stream.listen( // dinle
    // YENİ GELEN DATA SÜRDÜĞÜ SÜRECE YAP BUNLARI:
    (data) => print("yeni veri: $data "), 
    onError: (err) => print("Hata Oluştu: $err"),
    onDone: () => print("Yayın Tamamlandı."), // YENİ GELEN VERİDEN EN BAŞA DÖNER YİNE ONDONE OLARAK BİTİRİR. BELLİ BİR SÜREDE EN BAŞA DÖNER TÜMÜNÜ BASAR ONDONE OLARAK BİTİRİR. 
  );

  controller.sink.add(10);
  controller.sink.add(20);
  controller.sink.add(30);

// HATA
// aynı fonksiyon içinde ya tekil dinleyicii ya çoğul dinleyici kullanılmalıdır. yukarıda subscription tekil dinleyici zaten var. aşağıda tekrar broadcast dinleyici koyunca hata verir!!!!!!!
/*
// BİRDAN FAZKA YERE VERİ GÖNDERİP ONLARIAYNI ANDA DİNLEYİP AYNI ANDA GÖNDEREBİLİRİZ.
// MESELA KULLANININ İSMİ SOYADI VS FARKLI YERLERDEN GELİYORSA BROADCAST DİNLENMELİDİR.
// BİRDEN FAZLA KİŞİ LOGIN OLDUĞUNDA DA BROADCAST KULLANILMALIDIR. 
  final broadcastStream = controller.stream.asBroadcastStream();
  broadcastStream.listen((d) => print("UI Ekranı: $d"));
  broadcastStream.listen((d) => print("Analtiik Serivis Ekranı: $d"));
  */
  
  controller.close();
}



