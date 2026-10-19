import 'package:flutter/foundation.dart';

import '../data/mock_fikir_durumu_data.dart';
import '../models/fikir_durumu_model.dart';

class FikirDurumuController {
  final ValueNotifier<List<FikirDurumuModel>> fikirler =
      ValueNotifier<List<FikirDurumuModel>>(mockOrnekFikirler);
  final ValueNotifier<int> seciliFikirIndex = ValueNotifier<int>(0);

  FikirDurumuModel get seciliFikir => fikirler.value[seciliFikirIndex.value];

  void fikirSec(int index) {
    if (index >= 0 && index < fikirler.value.length) {
      seciliFikirIndex.value = index;
    }
  }

  void hukukiAdimIlerle(String fikirId, int adimSira) {
    fikirler.value = [
      for (final f in fikirler.value)
        if (f.id == fikirId)
          f.copyWith(
            hukukiAdimlar: [
              for (final a in f.hukukiAdimlar)
                if (a.sira == adimSira)
                  a.copyWith(durum: HukukiAdimDurumu.tamamlandi)
                else
                  a,
            ],
          )
        else
          f,
    ];
  }

  void dispose() {
    fikirler.dispose();
    seciliFikirIndex.dispose();
  }
}
