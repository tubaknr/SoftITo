import 'package:flutter/foundation.dart';
import '../data/mock_mentor_data.dart';
import '../models/mentor_model.dart';

class MentorController {
  MentorController({List<MentorModel>? initialMentorlar}) {
    tumMentorlar = ValueNotifier<List<MentorModel>>(
      initialMentorlar ?? MockMentorData.mentorlar,
    );
    seciliSektor = ValueNotifier<String>('Tümü');
    aramaMetni = ValueNotifier<String>('');
    filtreliMentorlar = ValueNotifier<List<MentorModel>>(tumMentorlar.value);
  }

  late final ValueNotifier<List<MentorModel>> tumMentorlar;
  late final ValueNotifier<String> seciliSektor;
  late final ValueNotifier<String> aramaMetni;
  late final ValueNotifier<List<MentorModel>> filtreliMentorlar;

  void _guncelleFiltreli() {
    final sektor = seciliSektor.value;
    final arama = aramaMetni.value.trim().toLowerCase();

    filtreliMentorlar.value = tumMentorlar.value.where((m) {
      final sektorUyumu = sektor == 'Tümü' || m.sektor == sektor;
      final aramaUyumu = arama.isEmpty ||
          m.ad.toLowerCase().contains(arama) ||
          m.unvan.toLowerCase().contains(arama) ||
          m.uzmanliklar.any((u) => u.toLowerCase().contains(arama));
      return sektorUyumu && aramaUyumu;
    }).toList();
  }

  void sektorSec(String sektor) {
    seciliSektor.value = sektor;
    _guncelleFiltreli();
  }

  void aramaDegisti(String metin) {
    aramaMetni.value = metin;
    _guncelleFiltreli();
  }

  void eslesmeIste(String mentorId) {
    tumMentorlar.value = tumMentorlar.value.map((m) {
      if (m.id == mentorId) {
        return m.copyWith(eslesmeDurumu: EslesmeDurumu.beklemede);
      }
      return m;
    }).toList();
    _guncelleFiltreli();
  }

  void dispose() {
    tumMentorlar.dispose();
    seciliSektor.dispose();
    aramaMetni.dispose();
    filtreliMentorlar.dispose();
  }
}
