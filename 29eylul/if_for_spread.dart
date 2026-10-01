// Spread op.  ... ...? ve collection if ve collection for kullanımı


// ...? null aware spread op. => ğer sağdaki liste null değilse
// elemanlarını döküp ekle; eğer null ise hiçbir şey yapma, 
//pas geç ve çökmeyi engelle.
// ...eklentiler // 💥 HATA! Null olan bir listenin elemanları dökülemez, program çöker.



void main(){

  print("Pipeline Konfigürasyonu");

  final bool productionMu = true;
  final bool debugLoggingAktif = false;
  final List<String>? cloudWatchEklentileri = [
    "datadog-agenct:v7",
    "prometheus-exporter"
  ];
  final List<String>? geciciTestYamalari = null;

  final List<String> aktifPipelineAdimlari = [
    "git-chekout",
    "security-sast-scan",
    if(productionMu) "production-kms-check",
    if(debugLoggingAktif) "verbose-debug-logger" else "minified-json-logger",
    ...["docker-build","helm-chart-package"], // arrayi parçalar ayrı maddeler ahlinde yazar
    ...?cloudWatchEklentileri, // null olabilri, eğer null değlse parçala dök buraya, nullsa da program çökmesin.
    ...?geciciTestYamalari // null olduğu için hiçbir işlem yapmaz. çökmez de. 
  ];

// FOR LOOP 
  for(int i=0; i<aktifPipelineAdimlari.length; i++){
    print("Adım ${i+1}: ${aktifPipelineAdimlari[i]}");
  }

// -------------------------------------------------------------------------------
  final List<int> izinliPortlar = [8080,8443,9090];

  final List<String> firewallGuvenlikKurallari = [
      "INGRESS-DEFAULT-DROP",
      for(var port in izinliPortlar) "ALLOW-TCP_PORT-Sport (VPC_INTERNAL)",
      "EGRESS_ALL_ALLOW"
  ];

  print("Dinamik Güvenlik Kuralları (collection for):---");

  firewallGuvenlikKurallari.forEach((kural) => print(" * $kural"));
}




