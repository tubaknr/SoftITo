import 'package:flutter/foundation.dart';

import '../data/mock_program_data.dart';
import '../models/program_model.dart';

class ProgramlarController {
  final ValueNotifier<List<ProgramModel>> tumProgramlar =
      ValueNotifier<List<ProgramModel>>(mockProgramlar);
  final ValueNotifier<ProgramKategori> seciliKategori =
      ValueNotifier<ProgramKategori>(ProgramKategori.hibe);
  final ValueNotifier<ProgramDurum?> seciliDurum = ValueNotifier<ProgramDurum?>(
    null,
  );
  final ValueNotifier<String> aramaMetni = ValueNotifier<String>('');
  final ValueNotifier<List<ProgramModel>> gorunenProgramlar =
      ValueNotifier<List<ProgramModel>>([]);

  ProgramlarController() {
    _filtrele();
  }

  void kategoriSec(ProgramKategori kat) {
    seciliKategori.value = kat;
    _filtrele();
  }

  void durumSec(ProgramDurum? durum) {
    seciliDurum.value = durum;
    _filtrele();
  }

  void aramaYap(String metin) {
    aramaMetni.value = metin;
    _filtrele();
  }

  void takvimeEkle(String id) {
    tumProgramlar.value = [
      for (final p in tumProgramlar.value)
        if (p.id == id) p.copyWith(takvimeEklendi: !p.takvimeEklendi) else p,
    ];
    _filtrele();
  }

  void _filtrele() {
    final kat = seciliKategori.value;
    final durum = seciliDurum.value;
    final arama = aramaMetni.value.trim().toLowerCase();

    gorunenProgramlar.value = tumProgramlar.value.where((p) {
      final katUygun = p.kategori == kat;
      final durumUygun = durum == null || p.durum == durum;
      final aramaUygun = arama.isEmpty ||
          p.ad.toLowerCase().contains(arama) ||
          p.kurum.toLowerCase().contains(arama) ||
          p.aciklama.toLowerCase().contains(arama);
      return katUygun && durumUygun && aramaUygun;
    }).toList();
  }

  void dispose() {
    tumProgramlar.dispose();
    seciliKategori.dispose();
    seciliDurum.dispose();
    aramaMetni.dispose();
    gorunenProgramlar.dispose();
  }
}
