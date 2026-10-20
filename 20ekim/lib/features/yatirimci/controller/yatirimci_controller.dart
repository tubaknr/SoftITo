import 'package:flutter/foundation.dart';
import '../data/mock_yatirimci_data.dart';
import '../models/yatirimci_model.dart';

class YatirimciController {
  YatirimciController({List<YatirimciModel>? initialYatirimcilar}) {
    tumYatirimcilar = ValueNotifier<List<YatirimciModel>>(
      initialYatirimcilar ?? MockYatirimciData.yatirimcilar,
    );
    seciliKategori = ValueNotifier<YatirimciKategorisi>(
      YatirimciKategorisi.sirketler,
    );
    seciliAsama = ValueNotifier<String>('Tümü');
    seciliSektor = ValueNotifier<String>('Tümü');
    aramaMetni = ValueNotifier<String>('');
    filtreliYatirimcilar = ValueNotifier<List<YatirimciModel>>([]);
    _guncelleFiltreli();
  }

  late final ValueNotifier<List<YatirimciModel>> tumYatirimcilar;
  late final ValueNotifier<YatirimciKategorisi> seciliKategori;
  late final ValueNotifier<String> seciliAsama;
  late final ValueNotifier<String> seciliSektor;
  late final ValueNotifier<String> aramaMetni;
  late final ValueNotifier<List<YatirimciModel>> filtreliYatirimcilar;

  void _guncelleFiltreli() {
    final kat = seciliKategori.value;
    final asama = seciliAsama.value;
    final sektor = seciliSektor.value;
    final arama = aramaMetni.value.trim().toLowerCase();

    filtreliYatirimcilar.value = tumYatirimcilar.value.where((y) {
      final katUyumu = y.kategori == kat;
      final asamaUyumu = asama == 'Tümü' || y.asama == asama;
      final sektorUyumu = sektor == 'Tümü' || y.sektorler.contains(sektor);
      final aramaUyumu = arama.isEmpty ||
          y.ad.toLowerCase().contains(arama) ||
          y.portfoy.any((p) => p.toLowerCase().contains(arama)) ||
          y.sektorler.any((s) => s.toLowerCase().contains(arama));
      return katUyumu && asamaUyumu && sektorUyumu && aramaUyumu;
    }).toList();
  }

  void kategoriSec(YatirimciKategorisi kat) {
    seciliKategori.value = kat;
    _guncelleFiltreli();
  }

  void asamaSec(String asama) {
    seciliAsama.value = asama;
    _guncelleFiltreli();
  }

  void sektorSec(String sektor) {
    seciliSektor.value = sektor;
    _guncelleFiltreli();
  }

  void aramaDegisti(String metin) {
    aramaMetni.value = metin;
    _guncelleFiltreli();
  }

  void iletisimKur(String id) {
    tumYatirimcilar.value = tumYatirimcilar.value.map((y) {
      if (y.id == id) {
        return y.copyWith(iletisimKuruldu: true);
      }
      return y;
    }).toList();
    _guncelleFiltreli();
  }

  void dispose() {
    tumYatirimcilar.dispose();
    seciliKategori.dispose();
    seciliAsama.dispose();
    seciliSektor.dispose();
    aramaMetni.dispose();
    filtreliYatirimcilar.dispose();
  }
}
