import 'package:flutter/foundation.dart';

enum BasvuruAsamasi {
  taslak,
  gonderildi,
  inceleniyor,
  revizeIstendi,
  onaylandi,
}

@immutable
class HukukiAdim {
  const HukukiAdim({
    required this.sira,
    required this.baslik,
    required this.aciklama,
    required this.tamamlandi,
    required this.aktif,
    this.tamamlanmaTarihi,
  });

  final int sira;
  final String baslik;
  final String aciklama;
  final bool tamamlandi;
  final bool aktif;
  final String? tamamlanmaTarihi;

  HukukiAdim copyWith({
    int? sira,
    String? baslik,
    String? aciklama,
    bool? tamamlandi,
    bool? aktif,
    String? tamamlanmaTarihi,
  }) {
    return HukukiAdim(
      sira: sira ?? this.sira,
      baslik: baslik ?? this.baslik,
      aciklama: aciklama ?? this.aciklama,
      tamamlandi: tamamlandi ?? this.tamamlandi,
      aktif: aktif ?? this.aktif,
      tamamlanmaTarihi: tamamlanmaTarihi ?? this.tamamlanmaTarihi,
    );
  }
}

@immutable
class AtananAvukat {
  const AtananAvukat({
    required this.adSoyad,
    required this.baro,
    required this.sicilNo,
    required this.uzmanlik,
    required this.telefon,
    required this.eposta,
  });

  final String adSoyad;
  final String baro;
  final String sicilNo;
  final String uzmanlik;
  final String telefon;
  final String eposta;
}

@immutable
class GelirDestekDurumu {
  const GelirDestekDurumu({
    required this.aylikTaahhutTutari,
    required this.odenenAySayisi,
    required this.toplamAySayisi,
    required this.kalanGun,
    required this.aktif,
    required this.sonOdemeTarihi,
  });

  final double aylikTaahhutTutari;
  final int odenenAySayisi;
  final int toplamAySayisi;
  final int kalanGun;
  final bool aktif;
  final String sonOdemeTarihi;

  double get ilerlemeYuzdesi =>
      toplamAySayisi == 0 ? 0.0 : odenenAySayisi / toplamAySayisi;
}

@immutable
class GirisimFikri {
  const GirisimFikri({
    required this.id,
    required this.ad,
    required this.sektor,
    required this.ozet,
    required this.asama,
    required this.ekipSayisi,
    required this.ilerlemeYuzdesi,
    required this.hukukiAdimIndex,
    required this.hukukiAdimlar,
    this.avukat,
    this.gelirDestek,
  });

  final String id;
  final String ad;
  final String sektor;
  final String ozet;
  final BasvuruAsamasi asama;
  final int ekipSayisi;
  final double ilerlemeYuzdesi;
  final int hukukiAdimIndex;
  final List<HukukiAdim> hukukiAdimlar;
  final AtananAvukat? avukat;
  final GelirDestekDurumu? gelirDestek;

  GirisimFikri copyWith({
    String? id,
    String? ad,
    String? sektor,
    String? ozet,
    BasvuruAsamasi? asama,
    int? ekipSayisi,
    double? ilerlemeYuzdesi,
    int? hukukiAdimIndex,
    List<HukukiAdim>? hukukiAdimlar,
    AtananAvukat? avukat,
    GelirDestekDurumu? gelirDestek,
  }) {
    return GirisimFikri(
      id: id ?? this.id,
      ad: ad ?? this.ad,
      sektor: sektor ?? this.sektor,
      ozet: ozet ?? this.ozet,
      asama: asama ?? this.asama,
      ekipSayisi: ekipSayisi ?? this.ekipSayisi,
      ilerlemeYuzdesi: ilerlemeYuzdesi ?? this.ilerlemeYuzdesi,
      hukukiAdimIndex: hukukiAdimIndex ?? this.hukukiAdimIndex,
      hukukiAdimlar: hukukiAdimlar ?? this.hukukiAdimlar,
      avukat: avukat ?? this.avukat,
      gelirDestek: gelirDestek ?? this.gelirDestek,
    );
  }
}
