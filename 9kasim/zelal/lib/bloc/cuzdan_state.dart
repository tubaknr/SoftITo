import 'package:flutter/foundation.dart';

import '../models/islem.dart';

// ==== BU DOSYA: STATE ====
// State = ekranın O ANKİ durumu.
// Bloc bir state yayınlar (emit eder),
// ekran da ona bakıp kendini çizer.
//
// Mantık: ekran "ne çizeceğim?" diye
// sormaz, sadece gelen state'i çizer.
// Yükleniyorsa spinner, yüklendiyse liste,
// hata varsa mesaj gösterir.
//
// Neden her durum için ayrı sınıf?
// Her durumun taşıdığı veri farklıdır.
// Yükleniyor: veri yok
// Yüklendi : bakiye + işlemler
// Hata     : hata mesajı

// State de değişmez (immutable) olmalı.
// Değişiklik = yeni state üretmek demek.
// Bloc eski ile yeniyi kıyaslayıp
// ekranı ancak değişince yeniler.
@immutable
abstract class CuzdanState {
  const CuzdanState();
}

// 1) Veri geliyor, bekle.
// Ekranda yükleniyor çarkı gösterilir.
class CuzdanYukleniyorState extends CuzdanState {
  const CuzdanYukleniyorState();
}

// 2) Veri hazır.
// Ekran bakiyeyi ve listeyi çizer.
class CuzdanYuklendiState extends CuzdanState {
  final double bakiye;
  final List<Islem> islemler;

  const CuzdanYuklendiState({required this.bakiye, required this.islemler});
}

// 3) Bir şey ters gitti.
// Ekran mesajı gösterir (SnackBar vb).
// Örn: "Yetersiz bakiye"
class CuzdanHataState extends CuzdanState {
  final String mesaj;

  const CuzdanHataState(this.mesaj);
}
