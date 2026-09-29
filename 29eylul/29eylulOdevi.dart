enum CihazTipi{
  sensor,
  gateway,
  edgeServer,
  router
}

class CihazErisilemezException implements Exception{
  final String mesaj;
  CihazErisilemezException(this.mesaj);

  @override 
  String toString() => mesaj;
}

class IotCihaz{
  final String seriNo;
  final String cihazAdi;
  final CihazTipi tip;
  final double cpuYukYuzdesi;
  final int bellekMb;
  final Set<String> acikPortlar;
  final bool sslSertifikasiGecerliMi;
  final bool acikMi; // cihaz açık mı kapalı mı tutar 

  const IotCihaz({
    required this.seriNo,
    required this.cihazAdi,
    required this.tip,
    required this.cpuYukYuzdesi,
    required this.bellekMb,
    required this.acikPortlar,
    required this.sslSertifikasiGecerliMi,
    this.acikMi = true,  // default açık.
  });

  bool get guvenlikAcigiVarMi => !sslSertifikasiGecerliMi || acikPortlar.contains("23/TELNET");

  String get izolasyonBolgesiBul => switch (tip){
    CihazTipi.sensor => "ZONE-1-SENSOR",
    CihazTipi.gateway => "ZONE-2-GATEWAY",
    CihazTipi.edgeServer => "ZONE-3-SERVER",
    CihazTipi.router => "ZONE-4-ROUTER",
  };
}



void main(){

  final List<IotCihaz> iotCihazlar = [
    IotCihaz(seriNo: "S101", cihazAdi: "cihaz1", tip: CihazTipi.sensor, cpuYukYuzdesi: 15, bellekMb: 65, acikPortlar: {"23/TELNET"}, sslSertifikasiGecerliMi: true, acikMi: true),
    IotCihaz(seriNo: "S102", cihazAdi: "cihaz2", tip: CihazTipi.edgeServer, cpuYukYuzdesi: 86, bellekMb: 45, acikPortlar: {"80/HTTP","443/HTTPS"}, sslSertifikasiGecerliMi: true, acikMi: true),
    IotCihaz(seriNo: "S103", cihazAdi: "cihaz3", tip: CihazTipi.router, cpuYukYuzdesi: 95, bellekMb: 25, acikPortlar: {"80/HTTP","443/HTTPS","22/SSH"}, sslSertifikasiGecerliMi: false, acikMi: false),
    IotCihaz(seriNo: "S104", cihazAdi: "cihaz4", tip: CihazTipi.edgeServer, cpuYukYuzdesi: 35, bellekMb: 5, acikPortlar: {"443/HTTPS","22/SSH"}, sslSertifikasiGecerliMi: true, acikMi: false),
    IotCihaz(seriNo: "S105", cihazAdi: "cihaz5", tip: CihazTipi.gateway, cpuYukYuzdesi: 13, bellekMb: 15, acikPortlar: {"80/HTTP"}, sslSertifikasiGecerliMi: true, acikMi: true),
    IotCihaz(seriNo: "S106", cihazAdi: "cihaz6", tip: CihazTipi.router, cpuYukYuzdesi: 59, bellekMb: 95, acikPortlar: {"80/HTTP"}, sslSertifikasiGecerliMi: true, acikMi: true),
  ];

  final riskliCihazlar = iotCihazlar
      .where((c) => c.acikPortlar.contains("23/TELNET") || !c.sslSertifikasiGecerliMi || c.cpuYukYuzdesi > 85.0)
      .map((c) => c.cihazAdi)
      .toList();

  final toplamBellek = iotCihazlar
      .map((c) => c.bellekMb)
      .fold(0.0, (toplam, bellek) => toplam + bellek);

  ({
  String cihazAdi,
  CihazTipi cihazTipi,
  bool alarmDurumu
  }) cihazBul ({
    required String cihazSeriNo
}) {
  try{
    print("----------------------------------------------");
    print("Cihaz Arama Motoru Başlatıldı");
    final cihaz = iotCihazlar
      .firstWhere((c) => c.seriNo == cihazSeriNo);

    print("Cihaz Açık Mı Kontrol Ediliyor...");

    if (!cihaz.acikMi){
      print("Cihaz Kapalı. Çıkış Yapılacak...");
      throw CihazErisilemezException("${cihaz.cihazAdi} (Seri No: ${cihaz.seriNo})");
    }

    print("Cihaz Açık ve Güvenli: $cihazSeriNo");
    return(
      alarmDurumu: riskliCihazlar.contains(cihaz.cihazAdi),
      cihazAdi: cihaz.cihazAdi,
      cihazTipi:cihaz.tip,
    );
  } on CihazErisilemezException catch(e) {
    throw Exception("Cihaza Erişilemiyor. Çıkış Yapılıyor... Hata: $e");
  } catch(e){
    throw Exception("$cihazSeriNo seri numaralı cihaz bulunamadı.");
  }
}
  
  print("----------------------------------------------------");

  print("Riskli Cihazlar: $riskliCihazlar");
  print("IoT Toplam Bellek: $toplamBellek");

  try{
    final sonuc1 = cihazBul(cihazSeriNo: "S103");
    print("Arama Motorundan Bulunan Cihaz: ${sonuc1.cihazAdi}");

  } on CihazErisilemezException catch(e){
    print("Cihaz Erişilemez Hatası Alındı: $e");
  } catch(e){
    print("Cihaz Aranırken Genel Hata: $e");
  }
}