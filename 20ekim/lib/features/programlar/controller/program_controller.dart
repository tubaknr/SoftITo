import 'package:flutter/foundation.dart';
import '../data/mock_program_data.dart';
import '../models/program_model.dart';

class ProgramController {
  ProgramController({List<ProgramModel>? initialProgramlar}) {
    tumProgramlar = ValueNotifier<List<ProgramModel>>(
      initialProgramlar ?? MockProgramData.programlar,
    );
    seciliKategori = ValueNotifier<ProgramKategorisi>(
      ProgramKategorisi.hibeProgramlari,
    );
    aramaMetni = ValueNotifier<String>('');
    filtreliProgramlar = ValueNotifier<List<ProgramModel>>([]);
    _guncelleFiltreli();
  }

  late final ValueNotifier<List<ProgramModel>> tumProgramlar;
  late final ValueNotifier<ProgramKategorisi> seciliKategori;
  late final ValueNotifier<String> aramaMetni;
  late final ValueNotifier<List<ProgramModel>> filtreliProgramlar;

  void _guncelleFiltreli() {
    final kat = seciliKategori.value;
    final arama = aramaMetni.value.trim().toLowerCase();

    filtreliProgramlar.value = tumProgramlar.value.where((p) {
      final katUyumu = p.kategori == kat;
      final aramaUyumu = arama.isEmpty ||
          p.ad.toLowerCase().contains(arama) ||
          p.kurum.toLowerCase().contains(arama) ||
          p.uygunlukSartlari.toLowerCase().contains(arama);
      return katUyumu && aramaUyumu;
    }).toList();
  }

  void kategoriSec(ProgramKategorisi kat) {
    seciliKategori.value = kat;
    _guncelleFiltreli();
  }

  void aramaDegisti(String metin) {
    aramaMetni.value = metin;
    _guncelleFiltreli();
  }

  void takvimeEkle(String id) {
    tumProgramlar.value = tumProgramlar.value.map((p) {
      if (p.id == id) {
        return p.copyWith(takvimeEklendi: !p.takvimeEklendi);
      }
      return p;
    }).toList();
    _guncelleFiltreli();
  }

  void dispose() {
    tumProgramlar.dispose();
    seciliKategori.dispose();
    aramaMetni.dispose();
    filtreliProgramlar.dispose();
  }
}
