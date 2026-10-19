# Yörünge — Girişimcilik Platformu

Bu doküman Flutter projesinde geliştirme yapacak olan Ajan (AntiGravity) yapay zeka ve yazılım geliştiriciler için bağlayıcı bir kılavuzdur. Projede üretilen her kod satırı buradaki kurallara UYMAK ZORUNDADIR.

---

## 1. Projenin Kimliği ve Vizyonu

- **Uygulama Adı:** Yörünge (girişimciler için uçtan uca destek platformu)
- **Ne yapar:** Fikir veya iş planı olan girişimcileri; mentorlara, yatırımcılara, destek programlarına ve diğer girişimcilere bağlar. Kullanıcı eğer kendi iş planını da sisteme göndermek isterse bir buton ile forma bağlanır, iş planını detaylı bir analiz formuyla gönderir, eğer istemezse noraml uygulamadan devam eder. Uzman ekip planı inceler, onaylanan fikirler sisteme dahil edilir. Onaylanan girişimciler için hukuki süreç (şirket kuruluşu, tescil, sözleşmeler vb. Türkiye Cumhuriyeti mevzuatına göre) platform tarafından atanan **ücretsiz avukat** ile yürütülür ve platform **gelir destek taahhüdü** sağlar.
- **Kime hitap eder:** Türkiye'deki fikir aşamasından büyüme aşamasına kadar tüm girişimciler.
- **Hedef Platformlar:** iOS ve Android öncelikli; ardından web ve masaüstü.
- **Kapsam notu:** Bu proje bir ödev/demo çalışmasıdır. Tüm veriler **mock (örnek)** veridir; gerçek kişi, kurum veya kurum iletişim bilgisi kullanılmaz. Arayüzde ayrıca hukuki uyarı/feragat metni gösterilmez.
- **Flutter SDK:** 3.27.x
- **Dart SDK:** 3.6.0 (Flutter 3.27 ile uyumlu sürümdür)
- **Dil:** Arayüz metinleri Türkçe.

### Tasarım Dili
Orijinal, estetik, **koyu renklerin hâkim olduğu**; füze, uzay ve yükseliş temalı; yüce ve yüceltici bir aksiyon hissi veren tasarım. Material 3 tabanı, çift tema desteği:

- **Karanlık Tema (Ana/Varsayılan) — "Derin Uzay":**
  - Zemin: derin uzay siyahı (`#05070F`), yüzeyler: gece mavisi (`#0C1224`, `#131B33`)
  - Vurgular: roket ateşi turuncusu (`#FF6B2C`), nebula camgöbeği (`#22D3EE`), yükseliş limonu (`#A3E635`), yıldız moru (`#8B5CF6`)
  - Kartlarda ince parlama (glow) kenarlıkları, gradyan yüzeyler
- **Aydınlık Tema — "Şafak Fırlatışı":**
  - Zemin: `#F4F7FC`, kartlar: `#FFFFFF`, yüksek kontrastlı lacivert metin, aynı vurgu ailesinin doygun tonları
- **Görsel motifler:** yıldız alanı arka planı (`CustomPainter`), yükselen roket/iz çizgileri, yörünge halkaları, ilerleme göstergelerinde "fırlatış" animasyonu (yerel animasyonlar).
- **Tema Durum Yönetimi:** `ValueNotifier<ThemeMode>` ile sayfa düzeyinde ağır `setState` olmaksızın anlık tema geçişi.

---

## 2. Mimari Desen ve Dizin Haritası

Mimari: **Özellik bazlı (feature-first)** + katmanlı ayrım (controller / model / view / widget). Kodlar kesinlikle tek bir yerde toplanmayacaktır. Her modül kendi feature klasöründe kodlanacaktır.

```text
lib/
  main.dart                      # Sadece uygulama başlatma ve tema bağlama
  core/
    constants/
      app_colors.dart            # Ham renk değerleri (yalnızca burada)
      app_spacing.dart
      app_strings.dart
    theme/
      app_theme.dart             # Light/Dark ThemeData + SpaceColors ThemeExtension
      theme_controller.dart      # ValueNotifier<ThemeMode>
    extensions/
      context_extensions.dart    # context.spaceColors, context.textTheme vb.
    widgets/
      starfield_background.dart  # Yıldız alanı CustomPainter
      glow_card.dart             # Ortak parlama kartı
      section_header.dart
  features/
    shell/                       # Alt bar iskeleti ve sekme yönetimi
      controller/
      view/
      widget/
    analiz/                      # İlk giriş iş planı analiz testi (çok sayfalı)
      controller/
      models/
      data/
      view/
      widget/
    fikir_durumu/                # Başvuru durumu, hukuki süreç, gelir destek takibi
      controller/
      models/
      data/
      view/
      widget/
    mentor/
      controller/
      models/
      data/
      view/mentor.dart
      widget/
    yatirimci/
      controller/
      models/
      data/
      view/yatirimci.dart
      widget/
    programlar/
      controller/
      models/
      data/
      view/programlar.dart
      widget/
    topluluk/
      controller/
      models/
      data/
      view/topluluk.dart
      widget/
test/
  features/<feature_adi>/<feature_adi>_controller_test.dart
```

### Alt Bar (Bottom Navigation) — 4 Sekme
| Sıra | Sekme | Dosya | İkon önerisi |
|---|---|---|---|
| 1 | Mentor | `features/mentor/view/mentor.dart` | `Icons.psychology_alt_rounded` |
| 2 | Yatırımcılar | `features/yatirimci/view/yatirimci.dart` | `Icons.rocket_launch_rounded` |
| 3 | Programlar | `features/programlar/view/programlar.dart` | `Icons.workspace_premium_rounded` |
| 4 | Topluluk | `features/topluluk/view/topluluk.dart` | `Icons.hub_rounded` |

- Sekme geçişi `ValueNotifier<int>` ile yönetilir; sekmeler `IndexedStack` içinde durumunu korur.
- "Fikir Durumum" ekranına Mentor sayfası üst çubuğundaki profil/durum rozetinden gidilir (5. sekme açılmaz).

### Özellik Sayfalarının İçerikleri

**Mentor (`mentor.dart`):** Mentor–menti eşleştirme. Mentor kartları (ad, uzmanlık alanları, sektör, deneyim yılı, müsaitlik, puan), uzmanlık/sektör filtreleri, "Eşleşme İste" akışı, eşleşme durumları (Beklemede / Eşleşti / Görüşme Planlandı), "Önerilen Mentorlar" (fikrin sektörüne göre) bölümü.

**Yatırımcılar (`yatirimci.dart`):** Kategori sekmeleri: **Şirketler / Holdingler / Melek Yatırımcılar / Girişim Sermayesi Fonları**. Her kart: ad, yatırım aşaması (tohum, Seri A…), ilgilendiği sektörler, bilet büyüklüğü aralığı, portföyden örnekler, iletişim bilgileri (e-posta, telefon, web — mock), "İletişime Geç" butonu. Filtre: aşama, sektör, bilet aralığı.

**Programlar (`programlar.dart`):** Kategori sekmeleri: **Hibe Programları / Devlet Destekleri / Yurtdışı Destekleri / Özel Sektör Destekleri / Kuluçka ve Hızlandırma Merkezleri**. Her kart: program adı, kurum, destek tutarı/kapsamı, uygunluk şartları, son başvuru tarihi, durum (Açık/Yakında/Kapandı), başvuru adımları, "Takvime Ekle" ve "Başvuru Bilgisi" aksiyonları.

**Topluluk (`topluluk.dart`):** Sade, X benzeri ama **basit** bir akış. Yalnızca **kabul edilmiş girişimciler** paylaşım yapabilir, beğenebilir ve yanıt yazabilir. Onaysız kullanıcılar akışı yalnızca okuyabilir ve alt kısımda "Paylaşım için fikrinin onaylanması gerekir" bilgisi görür. Kapsam: gönderi oluştur (metin, en fazla 280 karakter), beğen/beğenmekten vazgeç, gönderiye **tek seviyeli** yanıt. Kapsam dışı: takip sistemi, DM, hashtag, retweet, medya yükleme, bildirim.

**Analiz (ilk giriş):** Kullanıcıya "İş planın var mı?" sorulur. Evet ise çok sayfalı (stepper) analiz testi açılır. Bölümler:
1. **Fikir Özeti:** ad, sektör, problem, çözüm, hedef kitle
2. **Ekip:** kişi sayısı; her üye için ad, eğitim, uzmanlık, sorumluluk alanı, iletişim bilgisi
3. **Mevcut Durum / Traction:** müşteri kazanıldı mı, kaç ve kimler, hedefe yüzde kaç yakınlık, ciro, kâr durumu
4. **İnovasyon:** Ar-Ge ve teknolojik yenilik niteliği, yeterlilik oranı, mevcut çözümlerden farkı, uygulanabilirlik
5. **Plan Tabloları:** Gantt şeması (görev, başlangıç, bitiş), kilometre taşları, bütçe ve çıktı tutarlılığı
6. **Pazar:** ticarileşme planı, pazar analizi (TAM/SAM/SOM), müşteri analizi, rakipler
7. **Marka:** marka kurulumu, isim, konumlandırma, kanallar
8. **Özet ve Gönderim:** tüm cevapların gözden geçirilmesi, gönderim

Gönderilen başvuru uzman ekip incelemesine girer (mock'ta durum otomatik/sabit senaryolarla ilerler). Ara adımlarda taslak kaydı (`ValueNotifier` + yerel kayıt) tutulur.

**Fikir Durumu:** Başvuru aşamaları (Gönderildi → İnceleniyor → Revize İstendi / Onaylandı), onay sonrası **hukuki süreç zaman çizelgesi** (ücretsiz avukat ataması, şirket tipi seçimi, ticaret sicil kaydı, vergi kaydı, marka tescil başvurusu, ortaklık/sözleşme hazırlığı — Türkiye mevzuatına uygun adım adlandırmasıyla), atanan avukat kartı (mock), **gelir destek taahhüdü** durum kartı (aylık hedef, ilerleme).

### Mock Veri
- Uygulama içinde önceden kabul almış örnek fikirler ve ilerlemeleri bulunur (en az 6 fikir; farklı sektör ve aşamalarda; her birinin ekip, ilerleme yüzdesi, hukuki süreç adımı ve gelir destek durumu bulunur).
- Her feature kendi `data/` klasöründe `mock_<feature>_data.dart` dosyası tutar. Gerçek ağ isteği yoktur; controller'lar veriyi bu dosyalardan okur.
- Minimum mock hacmi: 8 mentor, 4+4+4+4 yatırımcı (şirket/holding/melek/fon), kategori başına 3+ program, 12+ topluluk gönderisi.
- Tüm kişi ve kurum adları uydurmadır; telefon/e-posta alanları `example.com` ve `0 (5xx) xxx xx xx` biçiminde yer tutucudur.

---

## 3. İzin Verilen ve Yasaklı Paketler

Ajan paket eklemeden önce paketin güncelliğini, bakım durumunu ve bilinen güvenlik açıklarını kontrol etmek zorundadır; kontrol edilmeden paket kurulmaz.

**Serbest (onaysız eklenebilir):**
- `flutter` çekirdek kütüphaneleri, `dart:async`, `dart:math`, `dart:convert`
- `intl` (tarih/para biçimleri), `shared_preferences` (taslak ve tema kaydı), `url_launcher` (mock link/telefon aksiyonları), `flutter_test`

**Onay gerektirir (eklemeden önce kullanıcıya sor):**
- `google_fonts`, `flutter_svg`, `cached_network_image`, `lottie`, `go_router`
- Her biri için eklenme gerekçesi ve alternatifi (yerel çözüm) belirtilir.

**KESİNLİKLE YASAK:**
- Ağır state yönetim paketleri: `provider`, `riverpod`, `flutter_bloc`, `get`/`getx`, `mobx`, `redux`
- Bakımı bırakılmış (discontinued) veya son 2 yıldır güncellenmemiş paketler
- Bilinen güvenlik açığı bulunan paketler ve doğrulanmamış yayıncıdan gelen paketler
- Git/path bağımlılığı olarak dışarıdan çekilen kontrolsüz paketler
- Gerçek ödeme, gerçek kimlik doğrulama veya gerçek ağ servisi paketleri (proje demo kapsamındadır)

---

## 4. Kırmızı Çizgiler (Kesinlikle Uyulması Gerekenler)

1 - **State Yönetim Standartları:**
Sayfa düzeyinde ağır `setState` kullanımından kesinlikle kaçın. Sadece yerel arayüz durumunu yöneten (örneğin buton animasyonları, yıldız alanı animasyonu vb.) `StatefulWidget` kabul edilir. State için `ValueNotifier` + `ValueListenableBuilder` kullanılır. Controller'lar `dispose()` ile temizlenir.

2 - **UI ve Performans Kuralları:**
- Statik tüm widget'larda `const` zorunludur.
- Renk ve metin stilleri kesinlikle tema dosyalarına yazılacaktır; widget içinde `Color(0xFF...)` veya sabit `TextStyle(fontSize: ...)` yazılmaz (`context.spaceColors` ve `Theme.of(context).textTheme` kullanılır).
- Büyük build metotları yasaktır. 40 satırı geçen `build` metotları özel widget sınıflarına ayrılacaktır.
- Uzun listelerde `ListView.builder` / `SliverList` kullanılır; `Column` içinde sınırsız liste yasaktır.
- Animasyonlu/ağır bölümler `RepaintBoundary` ile izole edilir.

3 - **Asenkron ve BuildContext Güvenliği:**
`await` sonrasında `BuildContext` kullanılmadan önce `if (!context.mounted) return;` kontrolü zorunludur.

4 - **Mimari Disiplin:**
- Tek dosyada UI + mantık + model toplamak yasaktır.
- Controller katmanı Flutter UI'dan bağımsız (saf Dart + `foundation`) kalır ve birim test edilebilir olur.
- Modeller `immutable` olur (`const` constructor, `copyWith`, `fromJson`, `toJson`).

5 - **Topluluk Yetki Kuralı:**
Paylaşım, beğeni ve yanıt aksiyonları yalnızca kullanıcı durumu **Onaylandı** ise etkinleştirilir. Bu kontrol UI'da değil, controller'da yapılır.

6 - **Onay Almadan Yapılmayacaklar:**
Projeye onay almadan harici state paketleri, yeni klasör düzeni değişikliği veya yeni sekme EKLENMEYECEKTİR. Dart'ın ve Flutter'ın yerel çekirdek API'lerini kullanmak esastır.

---

## 5. Geliştirme, Analiz ve Test Komutları

Ajan yaptığı herhangi bir kod değişikliğinden sonra mutlaka aşağıdaki komutların çalıştığını doğrulamalıdır.

* **Bağımlılıkları getirme:**
```bash
flutter pub get
```

* **Statik kod analizi (0 uyarı ve 0 hata şart):**
```bash
flutter analyze
```

* **Birim ve widget testleri:**
```bash
flutter test
```

* **Kod biçimlendirme kontrolü:**
```bash
dart format --set-exit-if-changed lib test
```

* **Paket güncellik/güvenlik kontrolü (paket eklendiğinde):**
```bash
flutter pub outdated
```

* **Projeyi çalıştırma:**
```bash
flutter run
```

* **Release derleme (teslim öncesi):**
```bash
flutter build apk --release
```

---

## 6. Ajanın Çıktı ve Yanıt Verme Standartları

**Açıklamalar:** Türkçe, teknik terimlerin özünü bozmadan net ve doğrudan olacaktır. Gereksiz giriş ve övgü yazılmaz.

**Değişiklik Sunumları:** Örneğin 500 satırlık bir dosyada 3 satır değiştiyse tüm dosyayı baştan sona basma; hedef satırları ve diff yapısını göster. Yeni oluşturulan dosyalar tam içerikle verilir.

**Dosya Yolları:** Bahsedilen ve üretilen her dosya için mutlaka projeye göre tıklanabilir link ver (örn. `lib/features/mentor/view/mentor.dart`).

**Adım Adım İlerleme:** Büyük işler (analiz formu gibi) bölümlere ayrılır; her bölüm bittiğinde analiz ve test çalıştırılır, sonra sonraki bölüme geçilir.

**Doğrulama:** Kod yazdıktan sonra kullanıcıya "Şimdi Flutter analiz ile kontrol edebilirsin." şeklinde doğrulama yönergeleri ver.

**Belirsizlik:** Kural dışı bir ihtiyaç doğarsa (yeni paket, yeni sekme vb.) kodu yazmadan önce kullanıcıdan onay iste.
