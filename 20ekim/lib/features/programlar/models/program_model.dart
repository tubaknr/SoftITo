import 'package:flutter/foundation.dart';

enum ProgramKategorisi {
  hibeProgramlari,
  devletDestekleri,
  yurtdisiDestekleri,
  ozelSektorDestekleri,
  kuluckaMerkezleri,
}

enum ProgramDurumu {
  acik,
  yakinda,
  kapandi,
}

@immutable
class ProgramModel {
  const ProgramModel({
    required this.id,
    required this.ad,
    required this.kurum,
    required this.kategori,
    required this.destekTutari,
    required this.uygunlukSartlari,
    required this.sonBasvuruTarihi,
    required this.kalanGun,
    required this.durum,
    required this.basvuruAdimlari,
    this.takvimeEklendi = false,
  });

  final String id;
  final String ad;
  final String kurum;
  final ProgramKategorisi kategori;
  final String destekTutari;
  final String uygunlukSartlari;
  final String sonBasvuruTarihi;
  final int kalanGun;
  final ProgramDurumu durum;
  final List<String> basvuruAdimlari;
  final bool takvimeEklendi;

  ProgramModel copyWith({
    String? id,
    String? ad,
    String? kurum,
    ProgramKategorisi? kategori,
    String? destekTutari,
    String? uygunlukSartlari,
    String? sonBasvuruTarihi,
    int? kalanGun,
    ProgramDurumu? durum,
    List<String>? basvuruAdimlari,
    bool? takvimeEklendi,
  }) {
    return ProgramModel(
      id: id ?? this.id,
      ad: ad ?? this.ad,
      kurum: kurum ?? this.kurum,
      kategori: kategori ?? this.kategori,
      destekTutari: destekTutari ?? this.destekTutari,
      uygunlukSartlari: uygunlukSartlari ?? this.uygunlukSartlari,
      sonBasvuruTarihi: sonBasvuruTarihi ?? this.sonBasvuruTarihi,
      kalanGun: kalanGun ?? this.kalanGun,
      durum: durum ?? this.durum,
      basvuruAdimlari: basvuruAdimlari ?? this.basvuruAdimlari,
      takvimeEklendi: takvimeEklendi ?? this.takvimeEklendi,
    );
  }
}
