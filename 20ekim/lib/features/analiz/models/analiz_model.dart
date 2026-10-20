import 'package:flutter/foundation.dart';

@immutable
class EkipUyesi {
  const EkipUyesi({
    required this.adSoyad,
    required this.egitim,
    required this.uzmanlik,
    required this.sorumluluk,
    required this.iletisim,
  });

  final String adSoyad;
  final String egitim;
  final String uzmanlik;
  final String sorumluluk;
  final String iletisim;

  bool get isFilled =>
      adSoyad.trim().isNotEmpty &&
      egitim.trim().isNotEmpty &&
      uzmanlik.trim().isNotEmpty &&
      sorumluluk.trim().isNotEmpty &&
      iletisim.trim().isNotEmpty;

  Map<String, dynamic> toJson() => {
        'adSoyad': adSoyad,
        'egitim': egitim,
        'uzmanlik': uzmanlik,
        'sorumluluk': sorumluluk,
        'iletisim': iletisim,
      };

  factory EkipUyesi.fromJson(Map<String, dynamic> json) => EkipUyesi(
        adSoyad: json['adSoyad'] as String? ?? '',
        egitim: json['egitim'] as String? ?? '',
        uzmanlik: json['uzmanlik'] as String? ?? '',
        sorumluluk: json['sorumluluk'] as String? ?? '',
        iletisim: json['iletisim'] as String? ?? '',
      );
}

@immutable
class GanttGorevi {
  const GanttGorevi({
    required this.gorevAdi,
    required this.baslangicAy,
    required this.bitisAy,
    required this.butce,
  });

  final String gorevAdi;
  final int baslangicAy;
  final int bitisAy;
  final double butce;

  bool get isFilled => gorevAdi.trim().isNotEmpty && bitisAy >= baslangicAy;

  Map<String, dynamic> toJson() => {
        'gorevAdi': gorevAdi,
        'baslangicAy': baslangicAy,
        'bitisAy': bitisAy,
        'butce': butce,
      };

  factory GanttGorevi.fromJson(Map<String, dynamic> json) => GanttGorevi(
        gorevAdi: json['gorevAdi'] as String? ?? '',
        baslangicAy: json['baslangicAy'] as int? ?? 1,
        bitisAy: json['bitisAy'] as int? ?? 3,
        butce: (json['butce'] as num?)?.toDouble() ?? 50000,
      );
}

@immutable
class AnalizFormModel {
  const AnalizFormModel({
    // 1. Fikir Özeti
    this.fikirAdi = '',
    this.sektor = '',
    this.problem = '',
    this.cozum = '',
    this.hedefKitle = '',
    // 2. Ekip
    this.ekipUyeleri = const [],
    // 3. Traction
    this.musteriKazanildiMi = false,
    this.musteriDetayi = '',
    this.hedefeYakinlikYuzdesi = 25,
    this.aylikCiro = '',
    this.karDurumu = '',
    // 4. İnovasyon
    this.argeYenilikNiteligi = '',
    this.yeterlilikOrani = 70,
    this.mevcutCozumlerdenFarki = '',
    this.uygulanabilirlikNotu = '',
    // 5. Plan Tabloları
    this.gorevler = const [],
    this.kilometreTaslari = '',
    this.toplamButce = '',
    // 6. Pazar
    this.ticarilesmePlani = '',
    this.tamSamSomAnalizi = '',
    this.musteriAnalizi = '',
    this.rakipler = '',
    // 7. Marka
    this.markaAdi = '',
    this.konumlandirma = '',
    this.pazarlamaKanallari = '',
  });

  final String fikirAdi;
  final String sektor;
  final String problem;
  final String cozum;
  final String hedefKitle;

  final List<EkipUyesi> ekipUyeleri;

  final bool musteriKazanildiMi;
  final String musteriDetayi;
  final int hedefeYakinlikYuzdesi;
  final String aylikCiro;
  final String karDurumu;

  final String argeYenilikNiteligi;
  final int yeterlilikOrani;
  final String mevcutCozumlerdenFarki;
  final String uygulanabilirlikNotu;

  final List<GanttGorevi> gorevler;
  final String kilometreTaslari;
  final String toplamButce;

  final String ticarilesmePlani;
  final String tamSamSomAnalizi;
  final String musteriAnalizi;
  final String rakipler;

  final String markaAdi;
  final String konumlandirma;
  final String pazarlamaKanallari;

  bool get isFikirOzetiValid =>
      fikirAdi.trim().isNotEmpty &&
      sektor.trim().isNotEmpty &&
      problem.trim().isNotEmpty &&
      cozum.trim().isNotEmpty &&
      hedefKitle.trim().isNotEmpty;

  bool get isEkipValid =>
      ekipUyeleri.isNotEmpty && ekipUyeleri.every((e) => e.isFilled);

  bool get isTractionValid =>
      musteriDetayi.trim().isNotEmpty &&
      aylikCiro.trim().isNotEmpty &&
      karDurumu.trim().isNotEmpty;

  bool get isInovasyonValid =>
      argeYenilikNiteligi.trim().isNotEmpty &&
      mevcutCozumlerdenFarki.trim().isNotEmpty &&
      uygulanabilirlikNotu.trim().isNotEmpty;

  bool get isPlanValid =>
      gorevler.isNotEmpty &&
      gorevler.every((g) => g.isFilled) &&
      kilometreTaslari.trim().isNotEmpty &&
      toplamButce.trim().isNotEmpty;

  bool get isPazarValid =>
      ticarilesmePlani.trim().isNotEmpty &&
      tamSamSomAnalizi.trim().isNotEmpty &&
      musteriAnalizi.trim().isNotEmpty &&
      rakipler.trim().isNotEmpty;

  bool get isMarkaValid =>
      markaAdi.trim().isNotEmpty &&
      konumlandirma.trim().isNotEmpty &&
      pazarlamaKanallari.trim().isNotEmpty;

  bool get isAllValid =>
      isFikirOzetiValid &&
      isEkipValid &&
      isTractionValid &&
      isInovasyonValid &&
      isPlanValid &&
      isPazarValid &&
      isMarkaValid;

  AnalizFormModel copyWith({
    String? fikirAdi,
    String? sektor,
    String? problem,
    String? cozum,
    String? hedefKitle,
    List<EkipUyesi>? ekipUyeleri,
    bool? musteriKazanildiMi,
    String? musteriDetayi,
    int? hedefeYakinlikYuzdesi,
    String? aylikCiro,
    String? karDurumu,
    String? argeYenilikNiteligi,
    int? yeterlilikOrani,
    String? mevcutCozumlerdenFarki,
    String? uygulanabilirlikNotu,
    List<GanttGorevi>? gorevler,
    String? kilometreTaslari,
    String? toplamButce,
    String? ticarilesmePlani,
    String? tamSamSomAnalizi,
    String? musteriAnalizi,
    String? rakipler,
    String? markaAdi,
    String? konumlandirma,
    String? pazarlamaKanallari,
  }) {
    return AnalizFormModel(
      fikirAdi: fikirAdi ?? this.fikirAdi,
      sektor: sektor ?? this.sektor,
      problem: problem ?? this.problem,
      cozum: cozum ?? this.cozum,
      hedefKitle: hedefKitle ?? this.hedefKitle,
      ekipUyeleri: ekipUyeleri ?? this.ekipUyeleri,
      musteriKazanildiMi: musteriKazanildiMi ?? this.musteriKazanildiMi,
      musteriDetayi: musteriDetayi ?? this.musteriDetayi,
      hedefeYakinlikYuzdesi: hedefeYakinlikYuzdesi ?? this.hedefeYakinlikYuzdesi,
      aylikCiro: aylikCiro ?? this.aylikCiro,
      karDurumu: karDurumu ?? this.karDurumu,
      argeYenilikNiteligi: argeYenilikNiteligi ?? this.argeYenilikNiteligi,
      yeterlilikOrani: yeterlilikOrani ?? this.yeterlilikOrani,
      mevcutCozumlerdenFarki: mevcutCozumlerdenFarki ?? this.mevcutCozumlerdenFarki,
      uygulanabilirlikNotu: uygulanabilirlikNotu ?? this.uygulanabilirlikNotu,
      gorevler: gorevler ?? this.gorevler,
      kilometreTaslari: kilometreTaslari ?? this.kilometreTaslari,
      toplamButce: toplamButce ?? this.toplamButce,
      ticarilesmePlani: ticarilesmePlani ?? this.ticarilesmePlani,
      tamSamSomAnalizi: tamSamSomAnalizi ?? this.tamSamSomAnalizi,
      musteriAnalizi: musteriAnalizi ?? this.musteriAnalizi,
      rakipler: rakipler ?? this.rakipler,
      markaAdi: markaAdi ?? this.markaAdi,
      konumlandirma: konumlandirma ?? this.konumlandirma,
      pazarlamaKanallari: pazarlamaKanallari ?? this.pazarlamaKanallari,
    );
  }
}
