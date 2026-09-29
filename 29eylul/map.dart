

void main(){
  print("Map Metrikleri");


  final Map<String, Map<String,dynamic>>
    mikroservisRehberi = {
      "auth-api": {
        "port": 8081,
        "saglik":"Healthy",
        "restartSayisi":0,
        "bellekKullanimiMB":384.5,
        "otonomOlcekleme":true,
      },
      "payment-gateway": {
        "port":8082,
        "saglik":"Degraded",
        "restartSayisi":4,
        "bellekKullanimiMB":1280.0,
        "otonomOlcekleme":false,
      },
    };

// YENİ SERVİS EKLEME (PUTIFABSENT İLE ÇAKIŞMASIZ EKLEME!!)
  mikroservisRehberi.putIfAbsent("reporting-worker", 
  () => {
    "port": 9091,
    "saglik":"Healthy",
    "restartSayisi":1,
    "bellekKullanimiMB":512.0,
    "otonomOlcekleme":true,
    },
    
  );


// "payment-gateway isimli mikroservisin restart değerini 1 arttırır.
// Olmayan bir servise erişmeye çalışıp uygulamanın çökmesini (Null/Key Error)
// engellemek için yapılan bir güvenlik kontrolü
  if(mikroservisRehberi.containsKey("payment-gateway")){
    // ! = Dart dilindeki Null Assertion operatörü. 
    // "if kontrolünden geçtik, bu değer kesinlikle null değil, 
    //güvenle erişebilirsin" demektir.
    mikroservisRehberi["payment-gateway"]! 

// ünlem => null gelmeyecek. ama gelirse de null değil de boş olarak algıla.
// boş olarak tanımla. boş null aynı değil. 
// null gelirse dart patlar. 
    ["restartSayisi"] = (mikroservisRehberi["payment-gateway"]!
    // mikroservisRehberi haritası muhtemelen Map<String, dynamic> 
    //şeklinde tanımlandığı için Dart, gelen verinin tipini otomatik kestiremez
    // (Object/dynamic olarak görür). as int diyerek Dart'a "bu değer bir 
    //tam sayıdır, matematiksel işlem yapabilirsin" garantisi verilir 
    //(Type Casting).
    ["restartSayisi"] as int) + 1;
  }

  print("Güncel servis durum raporu");
  print("---------------------------------------------------------");
  for(var entry in mikroservisRehberi.entries){
    final String servis = entry.key;
    final Map<String,dynamic>ozet = entry.value;
    final String saglik = ozet["saglik"];
    final String durumRozet = saglik == "Healthy" ? "OK" : "Alert";

    print(
      "$durumRozet ${servis.padRight(18)} | Port: ${ozet['port']} | Ram: ${ozet['bellekKullanimiMB']} MB | Restart : ${ozet['restartSayisi']}",
    );
  }

}