import 'package:flutter/foundation.dart';

import '../data/mock_yatirimci_data.dart';
import '../models/yatirimci_model.dart';

class YatirimciController {
  final ValueNotifier<List<YatirimciModel>> tumYatirimcilar =
      ValueNotifier<List<YatirimciModel>>(mockYatirimcilar);
  final ValueNotifier<YatirimciKategori> seciliKategori =
      ValueNotifier<YatirimciKategori>(YatirimciKategori.sirketler);
  final ValueNotifier<String?> seciliAsama = ValueNotifier<String?>(null);
  final ValueNotifier<String> aramaMetni = ValueNotifier<String>('');
  final ValueNotifier<List<YatirimciModel>> gorunenYatirimcilar =
      ValueNotifier<List<YatirimciModel>>([]);

  YatirimciController() {
    _filtrele();
  }

  List<String> get asamalar => [
        'Tohum Öncesi (Pre-Seed)',
        'Tohum',
        'Tohum & Seri A',
        'Seri A',
        'Seri A & B',
      ];

  void kategoriSec(YatirimciKategori kat) {
    seciliKategori.value = kat;
    _filtrele();
  }

  void asamaSec(String? asama) {
    seciliAsama.value = asama;
    _filtrele();
  }

  void aramaYap(String metin) {
    aramaMetni.value = metin;
    _filtrele();
  }

  void iletisimTalebiGonder(String id) {
    tumYatirimcilar.value = [
      for (final y in tumYatirimcilar.value)
        if (y.id == id) y.copyWith(iletisimTalebiGonderildi: true) else y,
    ];
    _filtrele();
  }

  void _filtrele() {
    final kat = seciliKategori.value;
    final asama = seciliAsama.value;
    final arama = aramaMetni.value.trim().toLowerCase();

    gorunenYatirimcilar.value = tumYatirimcilar.value.where((y) {
      final katUygun = y.kategori == kat;
      final asamaUygun = asama == null || y.asama.contains(asama);
      final aramaUygun = arama.isEmpty ||
          y.ad.toLowerCase().contains(arama) ||
          y.sektorler.any((s) => s.toLowerCase().contains(arama)) ||
          y.portfoy.any((p) => p.toLowerCase().contains(arama));
      return katUygun && asamaUygun && aramaUygun;
    }).toList();
  }

  void dispose() {
    tumYatirimcilar.dispose();
    seciliKategori.dispose();
    seciliAsama.dispose();
    aramaMetni.dispose();
    gorunenYatirimcilar.dispose();
  }
}
