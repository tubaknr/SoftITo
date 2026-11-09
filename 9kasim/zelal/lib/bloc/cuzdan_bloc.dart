import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/islem.dart';
import 'cuzdan_event.dart';
import 'cuzdan_state.dart';

// ==== BU DOSYA: BLOC (BEYİN) ====
// Bloc = Event alır, State üretir.
// Tüm iş mantığı (hesap, kontrol) burada.
//
// Bloc<Event tipi, State tipi> yazılır:
// "Ben CuzdanEvent dinlerim,
//  CuzdanState yayınlarım."
class CuzdanBloc extends Bloc<CuzdanEvent, CuzdanState> {
  // super(...) = BAŞLANGIÇ state'i.
  // Uygulama açılınca ilk bu görünür.
  CuzdanBloc() : super(const CuzdanYukleniyorState()) {
    // on<Event>(fonksiyon) = kayıt defteri:
    // "Bu event gelirse bu fonksiyonu çalıştır"
    on<CuzdanYukleEvent>(_onCuzdanYukle);
    on<ParaYukleEvent>(_onParaYukle);
    on<ParaHarcaEvent>(_onParaHarca);
  }

  // ---- 1) CÜZDANI YÜKLE ----
  // async: bekleme (sahte internet) var.
  // emit = ekrana yeni state gönderme aracı.
  Future<void> _onCuzdanYukle(
    CuzdanYukleEvent event,
    Emitter<CuzdanState> emit, // gelen veriyi dağıtır
  ) async {
    // Gerçek uygulamada burada API/veritabanı
    // olur. 600 ms bekleyip taklit ediyoruz.
    await Future.delayed(const Duration(milliseconds: 600));

    // Örnek başlangıç verisi
    final baslangicIslemleri = [
      Islem(
        id: "1",
        baslik: "Açılış bonusu",
        miktar: 1000.0,
        tip: IslemTipi.gelir,
        tarih: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Islem(
        id: "2",
        baslik: "Öğlen yemeği",
        miktar: 650.0,
        tip: IslemTipi.gider,
        tarih: DateTime.now().subtract(const Duration(hours: 4)),
      ),
    ];

    // Yeni state yayınla: ekran artık
    // spinner'ı kaldırıp listeyi çizer.
    // (1000 - 650 = 350)
    emit(CuzdanYuklendiState(bakiye: 350.0, islemler: baslangicIslemleri));
  }

  // ---- 2) PARA YÜKLE ----
  // async değil, çünkü beklemeye gerek yok.
  void _onParaYukle(ParaYukleEvent event, Emitter<CuzdanState> emit) {
    // "state" = şu anki durum.
    // Sadece veri yüklüyse işlem yap.
    if (state is CuzdanYuklendiState) {
      // "as" = tipini netleştir, böylece
      // bakiye ve islemler'e erişebiliriz.
      final mevcutState = state as CuzdanYuklendiState;

      // Event'ten gelen bilgiyle işlem oluştur
      final yeniIslem = Islem(
        // Saniyenin milyonda biri = benzersiz id
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        baslik: event.baslik,
        miktar: event.miktar,
        tip: IslemTipi.gelir,
        tarih: DateTime.now(),
      );

      // Eski listeyi KOPYALA, başa ekle.
      // Neden kopya? Eski listeyi değiştirirsek
      // Flutter "değişti" diye anlamaz.
      // Yeni liste = yeni state = ekran yenilenir.
      final yeniListe = List<Islem>.from(mevcutState.islemler)
        ..insert(0, yeniIslem);

      final yeniBakiye = mevcutState.bakiye + event.miktar;

      // Güncel durumu ekrana yayınla
      emit(CuzdanYuklendiState(bakiye: yeniBakiye, islemler: yeniListe));
    }
  }

  // ---- 3) PARA HARCA ----
  void _onParaHarca(ParaHarcaEvent event, Emitter<CuzdanState> emit) {
    if (state is CuzdanYuklendiState) {
      final mevcutState = state as CuzdanYuklendiState;

      // KONTROL: bakiye yetmiyorsa harcama yok.
      if (mevcutState.bakiye < event.miktar) {
        // 1. Hata state'i gönder: ekran
        //    "Yetersiz bakiye" mesajı gösterir.
        emit(const CuzdanHataState('Yetersiz bakiye'));
        // 2. Hemen eski state'e dön: yoksa
        //    ekran hata ekranında kalır.
        emit(mevcutState);
        return; // devamı çalışmasın.
      }

      // Bakiye yeterli: gider işlemi oluştur
      final yeniIslem = Islem(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        baslik: event.baslik,
        miktar: event.miktar,
        tip: IslemTipi.gider,
        tarih: DateTime.now(),
      );

      final yeniListe = List<Islem>.from(mevcutState.islemler)
        ..insert(0, yeniIslem);

      // Yüklemeden farkı: burada ÇIKARIYORUZ
      final yeniBakiye = mevcutState.bakiye - event.miktar;

      emit(CuzdanYuklendiState(bakiye: yeniBakiye, islemler: yeniListe));
    }
  }
}

// ==== ÖZET: BİR PARA HARCAMA ====
// 1. Kullanıcı butona basar
// 2. Ekran: bloc.add(ParaHarcaEvent(...))
// 3. Bloc: _onParaHarca çalışır, hesaplar
// 4. Bloc: emit(yeni state)
// 5. Ekran: yeni state'i görür, yenilenir
// Ekran hiç hesap yapmadı, sadece çizdi.
