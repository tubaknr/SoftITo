import 'package:flutter/foundation.dart';

import '../data/mock_mentor_data.dart';
import '../models/mentor_model.dart';

class MentorController {
  final ValueNotifier<List<MentorModel>> tumMentorlar =
      ValueNotifier<List<MentorModel>>(mockMentorlar);
  final ValueNotifier<List<MentorModel>> gorunenMentorlar =
      ValueNotifier<List<MentorModel>>(mockMentorlar);
  final ValueNotifier<String?> seciliSektor = ValueNotifier<String?>(null);
  final ValueNotifier<String> aramaMetni = ValueNotifier<String>('');

  List<String> get sektorler =>
      tumMentorlar.value.map((m) => m.sektor).toSet().toList();

  List<MentorModel> get onerilenMentorlar =>
      tumMentorlar.value.where((m) => m.puan >= 4.9).take(3).toList();

  void sektorSec(String? sektor) {
    seciliSektor.value = sektor;
    _filtrele();
  }

  void aramaYap(String metin) {
    aramaMetni.value = metin;
    _filtrele();
  }

  void eslesmeIste(String mentorId) {
    tumMentorlar.value = [
      for (final m in tumMentorlar.value)
        if (m.id == mentorId && m.durum == EslesmeDurumu.yok)
          m.copyWith(durum: EslesmeDurumu.beklemede)
        else
          m,
    ];
    _filtrele();
  }

  void _filtrele() {
    final sektor = seciliSektor.value;
    final arama = aramaMetni.value.trim().toLowerCase();

    gorunenMentorlar.value = tumMentorlar.value.where((m) {
      final sektorUygun = sektor == null || m.sektor == sektor;
      final aramaUygun = arama.isEmpty ||
          m.ad.toLowerCase().contains(arama) ||
          m.unvan.toLowerCase().contains(arama) ||
          m.sektor.toLowerCase().contains(arama) ||
          m.uzmanliklar.any((u) => u.toLowerCase().contains(arama));
      return sektorUygun && aramaUygun;
    }).toList();
  }

  void dispose() {
    tumMentorlar.dispose();
    gorunenMentorlar.dispose();
    seciliSektor.dispose();
    aramaMetni.dispose();
  }
}
