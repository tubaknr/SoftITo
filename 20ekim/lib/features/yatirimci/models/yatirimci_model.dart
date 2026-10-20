import 'package:flutter/foundation.dart';

enum YatirimciKategorisi {
  sirketler,
  holdingler,
  melekYatirimcilar,
  girisimSermayesiFonlari,
}

@immutable
class YatirimciModel {
  const YatirimciModel({
    required this.id,
    required this.ad,
    required this.kategori,
    required this.asama,
    required this.sektorler,
    required this.minBilet,
    required this.maxBilet,
    required this.portfoy,
    required this.eposta,
    required this.telefon,
    required this.web,
    this.iletisimKuruldu = false,
  });

  final String id;
  final String ad;
  final YatirimciKategorisi kategori;
  final String asama;
  final List<String> sektorler;
  final double minBilet; // ₺ bazında
  final double maxBilet; // ₺ bazında
  final List<String> portfoy;
  final String eposta;
  final String telefon;
  final String web;
  final bool iletisimKuruldu;

  YatirimciModel copyWith({
    String? id,
    String? ad,
    YatirimciKategorisi? kategori,
    String? asama,
    List<String>? sektorler,
    double? minBilet,
    double? maxBilet,
    List<String>? portfoy,
    String? eposta,
    String? telefon,
    String? web,
    bool? iletisimKuruldu,
  }) {
    return YatirimciModel(
      id: id ?? this.id,
      ad: ad ?? this.ad,
      kategori: kategori ?? this.kategori,
      asama: asama ?? this.asama,
      sektorler: sektorler ?? this.sektorler,
      minBilet: minBilet ?? this.minBilet,
      maxBilet: maxBilet ?? this.maxBilet,
      portfoy: portfoy ?? this.portfoy,
      eposta: eposta ?? this.eposta,
      telefon: telefon ?? this.telefon,
      web: web ?? this.web,
      iletisimKuruldu: iletisimKuruldu ?? this.iletisimKuruldu,
    );
  }
}
