import 'package:flutter/foundation.dart';
import '../data/mock_fikir_durumu_data.dart';
import '../models/fikir_model.dart';

class FikirDurumuController {
  FikirDurumuController({
    GirisimFikri? initialFikir,
    List<GirisimFikri>? initialOrnekler,
  }) {
    kullaniciFikri = ValueNotifier<GirisimFikri>(
      initialFikir ?? MockFikirDurumuData.defaultKullaniciFikri,
    );
    ornekFikirler = ValueNotifier<List<GirisimFikri>>(
      initialOrnekler ?? MockFikirDurumuData.kabulEdilenFikirler,
    );
    seciliFikir = ValueNotifier<GirisimFikri>(
      initialFikir ?? MockFikirDurumuData.defaultKullaniciFikri,
    );
  }

  late final ValueNotifier<GirisimFikri> kullaniciFikri;
  late final ValueNotifier<List<GirisimFikri>> ornekFikirler;
  late final ValueNotifier<GirisimFikri> seciliFikir;

  void seciliFikriAyarla(GirisimFikri fikir) {
    seciliFikir.value = fikir;
  }

  void kullaniciFikrineGec() {
    seciliFikir.value = kullaniciFikri.value;
  }

  void sonrakiHukukiAdimaIlerle() {
    final suanki = seciliFikir.value;
    final mevcutIndex = suanki.hukukiAdimIndex;
    if (mevcutIndex >= 6) return;

    final yeniAdimlar = MockFikirDurumuData.createStandardHukukiAdimlar(
      mevcutIndex + 1,
    );
    final guncel = suanki.copyWith(
      hukukiAdimIndex: mevcutIndex + 1,
      hukukiAdimlar: yeniAdimlar,
      ilerlemeYuzdesi: ((mevcutIndex + 1) / 6.0).clamp(0.0, 1.0),
    );

    seciliFikir.value = guncel;
    if (suanki.id == kullaniciFikri.value.id) {
      kullaniciFikri.value = guncel;
    }
  }

  void dispose() {
    kullaniciFikri.dispose();
    ornekFikirler.dispose();
    seciliFikir.dispose();
  }
}
