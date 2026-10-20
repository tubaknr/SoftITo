import 'package:flutter/foundation.dart';

enum EslesmeDurumu {
  yok,
  beklemede,
  eslesti,
  gorusmePlanlandi,
}

@immutable
class MentorModel {
  const MentorModel({
    required this.id,
    required this.ad,
    required this.unvan,
    required this.sektor,
    required this.uzmanliklar,
    required this.deneyimYili,
    required this.musait,
    required this.puan,
    required this.degerlendirmeSayisi,
    required this.eslesmeDurumu,
    this.onerilenMi = false,
  });

  final String id;
  final String ad;
  final String unvan;
  final String sektor;
  final List<String> uzmanliklar;
  final int deneyimYili;
  final bool musait;
  final double puan;
  final int degerlendirmeSayisi;
  final EslesmeDurumu eslesmeDurumu;
  final bool onerilenMi;

  MentorModel copyWith({
    String? id,
    String? ad,
    String? unvan,
    String? sektor,
    List<String>? uzmanliklar,
    int? deneyimYili,
    bool? musait,
    double? puan,
    int? degerlendirmeSayisi,
    EslesmeDurumu? eslesmeDurumu,
    bool? onerilenMi,
  }) {
    return MentorModel(
      id: id ?? this.id,
      ad: ad ?? this.ad,
      unvan: unvan ?? this.unvan,
      sektor: sektor ?? this.sektor,
      uzmanliklar: uzmanliklar ?? this.uzmanliklar,
      deneyimYili: deneyimYili ?? this.deneyimYili,
      musait: musait ?? this.musait,
      puan: puan ?? this.puan,
      degerlendirmeSayisi: degerlendirmeSayisi ?? this.degerlendirmeSayisi,
      eslesmeDurumu: eslesmeDurumu ?? this.eslesmeDurumu,
      onerilenMi: onerilenMi ?? this.onerilenMi,
    );
  }
}
