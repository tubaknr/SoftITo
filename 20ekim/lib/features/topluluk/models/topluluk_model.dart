import 'package:flutter/foundation.dart';

@immutable
class YanitModel {
  const YanitModel({
    required this.id,
    required this.yazarAd,
    required this.girisimAd,
    required this.metin,
    required this.zaman,
  });

  final String id;
  final String yazarAd;
  final String girisimAd;
  final String metin;
  final String zaman;
}

@immutable
class GonderiModel {
  const GonderiModel({
    required this.id,
    required this.yazarAd,
    required this.girisimAd,
    required this.metin,
    required this.zaman,
    required this.begeniSayisi,
    required this.begenildiMi,
    required this.yanitlar,
  });

  final String id;
  final String yazarAd;
  final String girisimAd;
  final String metin;
  final String zaman;
  final int begeniSayisi;
  final bool begenildiMi;
  final List<YanitModel> yanitlar;

  GonderiModel copyWith({
    String? id,
    String? yazarAd,
    String? girisimAd,
    String? metin,
    String? zaman,
    int? begeniSayisi,
    bool? begenildiMi,
    List<YanitModel>? yanitlar,
  }) {
    return GonderiModel(
      id: id ?? this.id,
      yazarAd: yazarAd ?? this.yazarAd,
      girisimAd: girisimAd ?? this.girisimAd,
      metin: metin ?? this.metin,
      zaman: zaman ?? this.zaman,
      begeniSayisi: begeniSayisi ?? this.begeniSayisi,
      begenildiMi: begenildiMi ?? this.begenildiMi,
      yanitlar: yanitlar ?? this.yanitlar,
    );
  }
}
