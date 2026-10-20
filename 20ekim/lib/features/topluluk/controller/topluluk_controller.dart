import 'package:flutter/foundation.dart';
import '../data/mock_topluluk_data.dart';
import '../models/topluluk_model.dart';

class ToplulukController {
  ToplulukController({
    List<GonderiModel>? initialGonderiler,
    bool initialOnayli = true,
  }) {
    gonderiler = ValueNotifier<List<GonderiModel>>(
      initialGonderiler ?? MockToplulukData.gonderiler,
    );
    kullaniciOnayliMi = ValueNotifier<bool>(initialOnayli);
    hataMesaji = ValueNotifier<String?>(null);
  }

  late final ValueNotifier<List<GonderiModel>> gonderiler;
  late final ValueNotifier<bool> kullaniciOnayliMi;
  late final ValueNotifier<String?> hataMesaji;

  void kullaniciOnayDurumunuAyarla(bool onayli) {
    kullaniciOnayliMi.value = onayli;
  }

  bool begen(String gonderiId) {
    if (!kullaniciOnayliMi.value) {
      hataMesaji.value = 'Beğeni yapabilmek için fikrinizin onaylanmış olması gerekir.';
      return false;
    }

    gonderiler.value = gonderiler.value.map((g) {
      if (g.id == gonderiId) {
        final yeniBegenildi = !g.begenildiMi;
        final yeniSayi = yeniBegenildi ? g.begeniSayisi + 1 : g.begeniSayisi - 1;
        return g.copyWith(
          begenildiMi: yeniBegenildi,
          begeniSayisi: yeniSayi.clamp(0, 999999),
        );
      }
      return g;
    }).toList();
    return true;
  }

  bool yanitEkle(String gonderiId, String metin) {
    final temizMetin = metin.trim();
    if (!kullaniciOnayliMi.value) {
      hataMesaji.value = 'Yanıt yazabilmek için fikrinizin onaylanmış olması gerekir.';
      return false;
    }
    if (temizMetin.isEmpty || temizMetin.length > 280) {
      hataMesaji.value = 'Yanıt 1 ile 280 karakter arasında olmalıdır.';
      return false;
    }

    final yeniYanit = YanitModel(
      id: 'y_${DateTime.now().millisecondsSinceEpoch}',
      yazarAd: 'Siz (Girişimci)',
      girisimAd: 'Girişiminiz',
      metin: temizMetin,
      zaman: 'Az önce',
    );

    gonderiler.value = gonderiler.value.map((g) {
      if (g.id == gonderiId) {
        return g.copyWith(
          yanitlar: [...g.yanitlar, yeniYanit],
        );
      }
      return g;
    }).toList();
    return true;
  }

  bool gonderiPaylas(String metin) {
    final temizMetin = metin.trim();
    if (!kullaniciOnayliMi.value) {
      hataMesaji.value = 'Paylaşım yapabilmek için fikrinizin onaylanmış olması gerekir.';
      return false;
    }
    if (temizMetin.isEmpty || temizMetin.length > 280) {
      hataMesaji.value = 'Gönderi metni 1 ile 280 karakter arasında olmalıdır.';
      return false;
    }

    final yeniGonderi = GonderiModel(
      id: 'g_${DateTime.now().millisecondsSinceEpoch}',
      yazarAd: 'Siz (Girişimci)',
      girisimAd: 'Onaylı Girişiminiz',
      metin: temizMetin,
      zaman: 'Şimdi',
      begeniSayisi: 0,
      begenildiMi: false,
      yanitlar: const [],
    );

    gonderiler.value = [yeniGonderi, ...gonderiler.value];
    return true;
  }

  void hataTemizle() {
    hataMesaji.value = null;
  }

  void dispose() {
    gonderiler.dispose();
    kullaniciOnayliMi.dispose();
    hataMesaji.dispose();
  }
}
