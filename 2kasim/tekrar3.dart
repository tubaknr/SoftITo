// ============================================================
// DOSYA 3: go_router ShellRoute + Singleton + ValueNotifier
// ============================================================
// [KİLİT - setState HAKKINDA DOĞRU BİLGİ]
// setState(), SADECE çağrıldığı State nesnesinin build()
// metodunu yeniden çalıştırır ve o widget'ın ALT AĞACINI
// yeniden "build" eder. Bu "yeniden ÇİZİM" demek değildir:
// Flutter eski/yeni widget'ları karşılaştırır, sadece
// değişen render nesnelerini günceller. const widget'lar atlanır.
// Yine de büyük ekranda setState = gereksiz rebuild riskidir.
//
// [MİMARİ ÖZET]
//  1) Reaktif durum    : ValueNotifier + ValueListenableBuilder.
//                        (Observer pattern). Sadece dinleyen
//                        küçük widget güncellenir.
//  2) Singleton        : Sepet durumu tek yerde, global erişimli.
//  3) ShellRoute       : Alt menü sabit kalır, sadece içerik
//                        sayfası değişir (kalıcı iskelet).
//  4) Ekranlar Stateless: Durum widget'ın İÇİNDE değil DIŞINDA
//                        tutulur (state ile UI ayrımı).
// ============================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// [MİMARİ] Singleton: sınıftan uygulama boyunca TEK nesne vardır.
// Sepet durumu ve işlemleri burada toplanır.
// [DİKKAT - ARTILARI/EKSİLERİ]
//  + Basit, her yerden erişilir, ek paket gerekmez.
//  - Global durum: test etmek ve izlemek zordur, bağımlılık gizlidir.
//  Büyük projede Provider / Riverpod / BLoC + DI tercih edilir.
class SepetKontrolu {
  // Tek örnek. static final: sınıf yüklenince bir kez oluşur.
  static final SepetKontrolu ornek = SepetKontrolu._dahili();

  // Private named constructor: dışarıdan SepetKontrolu() yazılamaz.
  // Tek nesne kuralını bu satır garanti eder.
  SepetKontrolu._dahili();

  // Sepetteki ürün sayısı. Varsayılan 0.
  // [KİLİT] ValueNotifier<T>: değeri tutar, değer DEĞİŞİNCE
  // dinleyicilerini (listener) haberdar eder.
  // Not: Aynı değer tekrar atanırsa (0 -> 0) bildirim GİTMEZ.
  final ValueNotifier<int> urunSayisi = ValueNotifier<int>(0);

  // Ürün sayısını 1 arttırır.
  void sepeteEkle() {
    // .value değişince dinleyen widget'lar otomatik güncellenir.
    urunSayisi.value++;
  }

  // Ürün sayısını sıfırlar.
  void sepetSifirla() {
    // Değer 0 olunca rozet (Badge) gizlenir (aşağıya bak).
    urunSayisi.value = 0;
  }
}

// Uygulamanın sayfa yönlendirme (routing) yapılandırması.
// [MİMARİ] Deklaratif routing: rotalar tek merkezde tanımlanır,
// URL tabanlıdır (web / deep link uyumlu).
final GoRouter uygulamaRotalari = GoRouter(
  // [DÜZELTME] Orijinalde '/anasayfa' idi ama böyle bir rota
  // tanımlı değildi (hata verirdi). İlk sayfa '/vitrin' yapıldı.
  initialLocation: '/vitrin',
  // Rota listesi.
  routes: [
    // [DÜZELTME] "ShellRouter" yoktur, doğrusu "ShellRoute".
    // [KİLİT] ShellRoute: alt rotaları ORTAK bir iskelet
    // (burada alt menülü Scaffold) içinde gösterir.
    // Sayfa değişir, iskelet yeniden kurulmaz.
    ShellRoute(
      // [DÜZELTME] Orijinalde "builder(...){" şeklindeydi.
      // Doğrusu: builder: (context, state, child) { ... }
      // child = o an seçili alt sayfa (vitrin veya profil).
      builder: (BuildContext context, GoRouterState state, Widget child) {
        // İskelet ekranı, seçili sayfayı gövde olarak alır.
        return AnaKasaEkrani(ekranGovdesi: child);
      },
      // İskelet içinde gösterilecek alt rotalar.
      routes: [
        // Vitrin sayfası rotası.
        GoRoute(
          // Tarayıcı / deep link yolu.
          path: '/vitrin',
          // Bu yola gelince oluşturulacak ekran.
          builder: (context, state) => const VitrinEkrani(),
        ),
        // Profil sayfası rotası.
        GoRoute(
          path: '/profil',
          builder: (context, state) => const ProfilEkrani(),
        ),
      ],
    ),
  ],
);

// [EKLENDİ] Orijinalde yoktu. Uygulamayı çalıştırmak için gerekir.
void main() {
  // Uygulamayı başlatır.
  runApp(const SepetUygulamasi());
}

// [EKLENDİ] Kök widget. Router'ı MaterialApp'e bağlar.
class SepetUygulamasi extends StatelessWidget {
  const SepetUygulamasi({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp.router: yönlendirmeyi go_router'a devreder.
    return MaterialApp.router(
      // Yukarıda tanımlanan rota yapılandırmasını verir.
      routerConfig: uygulamaRotalari,
    );
  }
}

// Ortak iskelet: gövde + alt menü. Kendi state'i yoktur.
// [KİLİT - DÜZELTİLMİŞ BİLGİ] Stateless widget'ın kendi durumu
// yoktur, ama ekran donuk değildir. Güncelleme, dışarıdaki
// ValueNotifier'ı dinleyen ValueListenableBuilder (veya BLoC'ta
// BlocBuilder) ile yapılır. Sadece o builder'ın alt ağacı yenilenir,
// tüm ekran yenilenmez. Stateful'da ise setState o State'in
// tüm build() çıktısını yeniden kurar.
class AnaKasaEkrani extends StatelessWidget {
  // ShellRoute'un verdiği o anki alt sayfa.
  final Widget ekranGovdesi;

  // required: gövde verilmeden iskelet kurulamaz.
  const AnaKasaEkrani({super.key, required this.ekranGovdesi});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gövde: go_router'ın seçtiği sayfa.
      body: ekranGovdesi,
      // [DÜZELTME] Orijinalde "bottomNavigation:.navigationBar("
      // yazılmıştı. Doğrusu: bottomNavigationBar: NavigationBar(
      // NavigationBar = Material 3 alt menü widget'ı.
      bottomNavigationBar: NavigationBar(
        // Hangi sekmenin seçili olduğunu URL'den bulur.
        selectedIndex: _aktifIndexiBul(context),
        // Sekmeye tıklanınca çalışır.
        onDestinationSelected: (yeniIndex) {
          if (yeniIndex == 0) {
            // [KİLİT] context.go: yığını (stack) DEĞİŞTİREREK gider.
            // Alt menü geçişlerinde doğru olan budur.
            // context.push ise üste yeni sayfa EKLER (geri tuşu döner).
            context.go('/vitrin');
          } else if (yeniIndex == 1) {
            context.go('/profil');
          }
        },
        // Sekme tanımları. Sıra, index ile eşleşir (0: Vitrin, 1: Profil).
        destinations: [
          // Değişmeyen sekme, const olabilir.
          const NavigationDestination(
            icon: Icon(Icons.store),
            label: 'Vitrin',
          ),
          NavigationDestination(
            // [KİLİT - PERFORMANS] ValueListenableBuilder: sadece bu
            // ikon, urunSayisi değişince yeniden build edilir.
            // Scaffold, AppBar, diğer sekmeler HİÇ etkilenmez.
            icon: ValueListenableBuilder<int>(
              // Dinlenecek reaktif değer.
              valueListenable: SepetKontrolu.ornek.urunSayisi,
              // Değer her değişince çalışır. sayi = güncel değer.
              builder: (context, sayi, child) {
                // Badge: ikonun köşesinde sayı rozeti gösterir.
                return Badge(
                  // Rozet metni. (Lint: '${sayi}' yerine '$sayi')
                  label: Text('$sayi'),
                  // 0 iken rozet gizlenir.
                  isLabelVisible: sayi > 0,
                  // Rozetin üzerinde durduğu ikon.
                  child: const Icon(Icons.person),
                );
              },
            ),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  // URL'ye bakarak aktif sekme index'ini hesaplar.
  // [MİMARİ] Seçili sekmenin kaynağı URL'dir (tek doğru kaynak).
  // Ayrı bir "seciliIndex" değişkeni tutmaya gerek kalmaz.
  int _aktifIndexiBul(BuildContext context) {
    // Şu anki adres, örn: "/profil".
    final String konum = GoRouterState.of(context).uri.toString();
    // [DÜZELTME] "startWith" yoktur, doğrusu "startsWith".
    if (konum.startsWith('/profil')) return 1;
    // Varsayılan: Vitrin sekmesi.
    return 0;
  }
}

// [DÜZELTME] Orijinalde VitrinEkrani ve ProfilEkrani, AnaKasaEkrani
// sınıfının İÇİNE yazılmıştı. Dart'ta iç içe sınıf tanımlanamaz.
// İkisi de dosya seviyesine (top-level) taşındı.

// Vitrin ekranı. Stateless: durumu kendi tutmaz.
class VitrinEkrani extends StatelessWidget {
  const VitrinEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    // [DİKKAT] Iç içe Scaffold sorun değildir, ama her sayfanın
    // kendi AppBar'ı olabilsin diye bilerek kullanılır.
    return Scaffold(
      appBar: AppBar(title: const Text('Canlı Vitrin (ValueNotifier)')),
      body: Center(
        // İkonlu yükseltilmiş buton.
        child: ElevatedButton.icon(
          // Tıklanınca singleton üzerinden ürün sayısını arttırır.
          // [KİLİT] setState YOK: ekran yenilenmez, sadece alt
          // menüdeki rozet ValueNotifier sayesinde güncellenir.
          onPressed: () {
            SepetKontrolu.ornek.sepeteEkle();
          },
          icon: const Icon(Icons.add_shopping_cart),
          label: const Text('Sepete ürün ekle (+1)'),
        ),
      ),
    );
  }
}

// Profil ekranı. Stateless.
class ProfilEkrani extends StatelessWidget {
  const ProfilEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kullanıcı Profili')),
      body: Center(
        child: TextButton(
          // Ürün sayısını sıfırlar. Stateless içinden bile
          // diğer ekrandaki rozeti günceller (ortak durum sayesinde).
          onPressed: () => SepetKontrolu.ornek.sepetSifirla(),
          child: const Text('Sepeti Sıfırla (Stateless İçinden)'),
        ),
      ),
    );
  }
}