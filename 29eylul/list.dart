void main(){
  final List<String> aktifMikroservisler = [
    "auth-service:v2.1",
    "gateway-service:v1.9",
    "payment-processor:v3.0"
  ];
  aktifMikroservisler.add("telemetry-collector:v1.0");
  print(
    "Aktif servisler: (${aktifMikroservisler.length} adet): $aktifMikroservisler");

  // Sabit uzunluktaki liste FIXED LENGTH --------------------------------------
  // 4 tane eleman olacak. 
  // tüm değerler default olarak "port-kapalı" olacak.
  // growable: false -> fixed length. arttırılamaz, azaltılamaz. 
  // ekleme çıkarm yapılamaz! 
  // içerideki değerler değiştirlebilir. 
  // mesela portaldaki admin sayısı max 3 oalbilir.
  // mesela lisansı kullanacka kişi sayısı max 10 olaiblir. gibi....
  final List<String> cekirdekYukDengeleyiciler = List.filled(4, "Port-Kapalı", growable: false);
  cekirdekYukDengeleyiciler[0]="LB-NODE-01; 192.168.1.11 (Online)";
  cekirdekYukDengeleyiciler[1]="LB-NODE-02; 192.168.1.11 (Online)";

  /*
  cekirdekYukDengeleyiciler[0] "LB-NODE-01; 192.168.1.11 (Online)"
  cekirdekYukDengeleyiciler[1] "LB-NODE-02; 192.168.1.11 (Online)"
  cekirdekYukDengeleyiciler[2] "Port-Kapalı" (değiştirilmedi)
  cekirdekYukDengeleyiciler[3] "Port-Kapalı" (değiştirilmedi)
  */

// HATA! FIXED-LENGTH LİSTEYE ELEMAN EKLENEMEZ!!!
// cekirdekYukDengeleyiciler[0]="LB-NODE-01; 192.168.1.11 (Online)";
 // cekirdekYukDengeleyiciler.add("LB_NODE-05"); 

  print("çekirdek yük dengeleyici portları: $cekirdekYukDengeleyiciler");

  // Programatik List Üretici
  // kaç tane eleman istersem üretir. 
  /*
  index = 0 için: "pod-node-eu-west-1 [Ram:16GB, CPU:4 Cores]"
  index = 1 için: "pod-node-eu-west-2 [Ram:16GB, CPU:4 Cores]"
  index = 2 için: "pod-node-eu-west-3 [Ram:16GB, CPU:4 Cores]"
   */
  final List<String>kubernetsPodlari = List.generate(3, 
      (index) => "pod-node-eu-west-${index+1} [Ram:16GB, CPU:4 Cores]"
  );
  print("Oluşturulan K8s Podları: $kubernetsPodlari");

  // Değiştirilemez List
  final List<String> guvenlikDuvariPortlari = List.unmodifiable([
    "22/TCP (SSH)",
    "443/TCP (HTTPS)",
    "6443/TCP (K8s-API)",
  ]);
  // HATA! içerideki veriler değiştirilemez!
  // Unsupported operation: Cannot modify an unmodifiable list
  guvenlikDuvariPortlari[0] = "80/TCP";
}