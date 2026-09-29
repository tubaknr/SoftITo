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

  const IotCihaz({
    required this.seriNo,
    required this.cihazAdi,
    required this.tip,
    required this.cpuYukYuzdesi,
    required this.bellekMb,
    required this.acikPortlar,
    required this.sslSertifikasiGecerliMi
  });

  bool get guvenlikAcigiVarMi => !sslSertifikasiGecerliMi || acikPortlar.contains("23/TELNET");

  String get izolasyonBolgesiBul => switch (tip){
    CihazTipi.sensor => "ZONE-1-SENSOR",
    CihazTipi.gateway => "ZONE-2-GATEWAY",
    CihazTipi.edgeServer => "ZONE-3-SERVER",
    CihazTipi.router => "ZONE-4-ROUTER",
  }
}



void main(){

  final List<IotCihaz> iotCihazlar = [
    IotCihaz(seriNo: "S101", cihazAdi: "cihaz1", tip: CihazTipi.sensor, cpuYukYuzdesi: 15, bellekMb: 65, acikPortlar: {"23/TELNET"}, sslSertifikasiGecerliMi: true),
    IotCihaz(seriNo: "S102", cihazAdi: "cihaz2", tip: CihazTipi.edgeServer, cpuYukYuzdesi: 86, bellekMb: 45, acikPortlar: {"80/HTTP","443/HTTPS"}, sslSertifikasiGecerliMi: true),
    IotCihaz(seriNo: "S103", cihazAdi: "cihaz3", tip: CihazTipi.router, cpuYukYuzdesi: 95, bellekMb: 25, acikPortlar: {"80/HTTP","443/HTTPS","22/SSH"}, sslSertifikasiGecerliMi: false),
    IotCihaz(seriNo: "S104", cihazAdi: "cihaz4", tip: CihazTipi.edgeServer, cpuYukYuzdesi: 35, bellekMb: 5, acikPortlar: {"443/HTTPS","22/SSH"}, sslSertifikasiGecerliMi: true),
    IotCihaz(seriNo: "S105", cihazAdi: "cihaz5", tip: CihazTipi.gateway, cpuYukYuzdesi: 13, bellekMb: 15, acikPortlar: {"80/HTTP"}, sslSertifikasiGecerliMi: true),
    IotCihaz(seriNo: "S106", cihazAdi: "cihaz6", tip: CihazTipi.router, cpuYukYuzdesi: 59, bellekMb: 95, acikPortlar: {"80/HTTP"}, sslSertifikasiGecerliMi: true)
  ];

  final riskliCihazlar = iotCihazlar
      .where((c) => c.acikPortlar.contains("23/TELNET") || !c.sslSertifikasiGecerliMi || c.cpuYukYuzdesi > 85.0)
      .map((c) => c.cihazAdi)
      .toList();
  print("$riskliCihazlar");

  final toplamBellek = iotCihazlar
      .map((c) => c.bellekMb)
      .fold(0.0, (toplam, bellek) => toplam + bellek);
  print("$toplamBellek");

  ({
  String cihazAdi,
  CihazTipi cihazTipi,
  bool alarmDurumu
}) cihazBul ({
  required String cihazSeriNo
}) {
  try{
    final cihaz = iotCihazlar.firstWhere((c) => c.seriNo == cihazSeriNo);

    return(
      alarmDurumu: riskliCihazlar.contains(cihaz.cihazAdi),
      cihazAdi: cihaz.cihazAdi,
      cihazTipi:cihaz.tip,
    );

  } catch(e){
    throw Exception("$cihazSeriNo seri numaralı cihaz bulunamadı.");
  }
}

  final sonuc1 = cihazBul(cihazSeriNo: "S101");
  //final sonuc2 = cihazBul(cihazSeriNo: "S109");
  print("Cihaz Adı: ${sonuc1.cihazAdi}");
  //
}