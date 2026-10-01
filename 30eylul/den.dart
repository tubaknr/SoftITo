class SunucuMetrigi{
  final String hostAdi;
  final String bolge;
  final double cpuYuzdesi;
  final double ramGb;
  final int aktifBaglantiSayisi;
  final bool kritikMi;

  SunucuMetrigi({
    required this.hostAdi,
    required this.bolge,
    required this.cpuYuzdesi,
    required this.ramGb,
    required this.aktifBaglantiSayisi,
    this.kritikMi = false,
  });

  @override
  String toString() => "[$hostAdi] | cpu: $cpuYuzdesi | ram: $ramGb | conn: $aktifBaglantiSayisi";
}

void main(){
  final List<SunucuMetrigi> sunucuKumesi = [
    SunucuMetrigi(
      hostAdi: "srv-eu-01", bolge: "eu-west", cpuYuzdesi: 45.2, ramGb: 16.0, aktifBaglantiSayisi: 1200, kritikMi: true),
    SunucuMetrigi(
      hostAdi: "srv-eu-02", bolge: "eu-west", cpuYuzdesi: 88.2, ramGb: 32.0, aktifBaglantiSayisi: 4500, kritikMi: true),
    SunucuMetrigi(
      hostAdi: "srv-us-01", bolge: "us-east", cpuYuzdesi: 22.0, ramGb: 8.0, aktifBaglantiSayisi: 450, kritikMi: false),
    SunucuMetrigi(
      hostAdi: "srv-us-02", bolge: "eu-east", cpuYuzdesi: 94.6, ramGb: 64.0, aktifBaglantiSayisi: 8900, kritikMi: true),
    SunucuMetrigi(
      hostAdi: "srv-ap-01", bolge: "ap-south", cpuYuzdesi: 62.4, ramGb: 16.0, aktifBaglantiSayisi: 2000, kritikMi: false),
  ];

  final asiriYukluler = sunucuKumesi.where((s) => s.cpuYuzdesi > 30 && s.ramGb > 20).toList();
  print("${asiriYukluler.length}");
  asiriYukluler.forEach((a) => print(" * $a"));

  final List<String> alarmEtiketleri = sunucuKumesi.map((s) => "${s.hostAdi} -> Aktif Trafik: ${s.aktifBaglantiSayisi}").toList();

  print("$alarmEtiketleri");
  alarmEtiketleri.take(3).forEach((e) => print(" * $e"));

  final int toplamBaglantiSayisi = sunucuKumesi.map((s) => s.aktifBaglantiSayisi).fold(0, (acc, s) => acc + s);
  print("$toplamBaglantiSayisi");

  final bool tumSunucularCalisiyorMu = sunucuKumesi.every((s) => s.ramGb >= 8.0);
  print("$tumSunucularCalisiyorMu");

  final bool tehlikeliSunucuVarMi = sunucuKumesi.any((s) => s.cpuYuzdesi > 90);
  print("$tehlikeliSunucuVarMi");

  final euWestSunuculari = sunucuKumesi.where((s) => s.bolge == "eu-west" && s.kritikMi).toList();
  print("$euWestSunuculari");
  final double euWestOrtalamaCpu = euWestSunuculari.map((s) => s.cpuYuzdesi).fold(0.0, (top, cpu) => top+cpu)/(euWestSunuculari.length);

  print("$euWestOrtalamaCpu");

}