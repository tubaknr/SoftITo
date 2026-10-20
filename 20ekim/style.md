# Yörünge — Tasarım ve Stil Kılavuzu

Bu doküman `project.md` ile birlikte okunur ve onunla aynı güçte bağlayıcıdır. Çelişki olursa `project.md` kazanır. Ajan (AntiGravity) ve geliştiriciler, arayüzle ilgili her kodu burada yazılan token'lara ve kurallara göre üretmek ZORUNDADIR.

---

## 1. Tasarım Fikri: "Şafak Yörüngesi"

Uzaydan bakıldığında yeryüzünün üstünde güneş doğar: önce koyu bir gece, sonra ufukta ince bir altın çizgi, sonra bütün sahne ısınır. Yörünge'nin hissi budur. Girişimci fikir aşamasının karanlığından başlar, platform onu adım adım yukarı taşır.

Bu yüzden:

- Zemin **derin gece mavisidir**, ama kasvetli değildir; yüzeyler mor-mavi tonlarla katman katman yükselir.
- Sıcak **şafak rengi** (amber → mercan) ekranda yalnızca ilerlemeyi, onayı ve ana eylemi işaretler. Her yerde değil, **seçili yerlerde** kullanılır. Ekranın akılda kalan tek unsuru bu olmalıdır.
- Soğuk **yörünge turkuazı** ikincil vurgudur; bağlantı, topluluk ve bilgi içindir.
- Hareket yukarı doğrudur: ilerleme çubukları, rozetler ve geçişler "yükselme" yönünde çalışır.
- Ton cesaretlendiricidir: "Eksik var" yerine "Şu 3 alan seni gönderime yaklaştırır".

Tek cümlelik ilke: **Sakin bir gece, tek bir doğan güneş.**

---

## 2. Altın Kurallar (project.md ile uyum)

1. Hiçbir widget içinde `Color(0xFF...)`, `Colors.white`, `Colors.black`, sabit `TextStyle(fontSize: ...)` yazılmaz. Renkler `context.spaceColors`, metin stilleri `Theme.of(context).textTheme` üzerinden gelir. (`Colors.transparent` serbesttir.)
2. Tüm hex değerleri yalnızca `core/theme/` altındaki dosyalarda bulunur.
3. Boşluk, köşe yarıçapı ve süre değerleri `core/constants/` altındaki sabitlerden gelir; widget içinde "sihirli sayı" (`EdgeInsets.all(13)` gibi) yazılmaz.
4. Flutter 3.27 kullanıldığı için `withOpacity` yerine `withValues(alpha: ...)`, `surfaceVariant` yerine `surfaceContainerHighest`, `background` yerine `surface` kullanılır. Eski, kullanımdan kalkmış API'ler yazılmaz.
5. Tema (açık/koyu) `shared_preferences` ile kaydedilir ve `ValueNotifier<ThemeMode>` ile yönetilir. Varsayılan tema **koyu**dur ("Gece").
6. Yeni paket, yeni klasör, yeni sekme eklemek onay gerektirir (bkz. Bölüm 12).

---

## 3. Renk Sistemi

İki tema vardır: **Gece** (koyu, varsayılan) ve **Gündüz** (açık). Her ikisi de `SpaceColors` adlı bir `ThemeExtension` ile sunulur.

### 3.1 Gece (koyu)

| Token | Hex | Kullanım |
|---|---|---|
| `bg` | `#0F1535` | Sayfa zemini |
| `surface` | `#19214D` | Kartlar, alt çubuk |
| `surfaceHigh` | `#232C63` | Yükseltilmiş kart, bottom sheet, seçili chip |
| `outline` | `#34407F` | İnce çerçeve, ayırıcı |
| `textPrimary` | `#F3F5FF` | Ana metin |
| `textMuted` | `#A9B2E0` | İkincil metin |
| `dawn` | `#FFB547` | Ana eylem, ilerleme, onay vurgusu |
| `onDawn` | `#0F1535` | `dawn` üstündeki metin ve ikon |
| `dawnEnd` | `#FF7A6B` | Gradient'in mercan ucu |
| `orbit` | `#4ADEDE` | İkincil vurgu: topluluk, bağlantı, bilgi |
| `onOrbit` | `#0F1535` | `orbit` üstündeki metin |
| `success` | `#3DDC97` | Onaylandı, Açık, Eşleşti |
| `info` | `#6EA8FF` | İnceleniyor, Beklemede |
| `warning` | `#FF9F5A` | Revize İstendi, Yakında |
| `danger` | `#FF6B7A` | Hata, Kapandı |

### 3.2 Gündüz (açık)

| Token | Hex | Kullanım |
|---|---|---|
| `bg` | `#F4F6FF` | Sayfa zemini (soğuk beyaz; krem değil) |
| `surface` | `#FFFFFF` | Kartlar |
| `surfaceHigh` | `#E9EDFF` | Yükseltilmiş alan, seçili chip |
| `outline` | `#CDD4F5` | Çerçeve, ayırıcı |
| `textPrimary` | `#131A44` | Ana metin |
| `textMuted` | `#4F5894` | İkincil metin |
| `dawn` | `#3341D6` | Ana eylem (açık temada okunurluk için indigo) |
| `onDawn` | `#FFFFFF` | `dawn` üstündeki metin |
| `dawnEnd` | `#E8710A` | Gradient'in sıcak ucu (yalnızca dolgu/ikon, metin değil) |
| `orbit` | `#0E8F9A` | İkincil vurgu |
| `onOrbit` | `#FFFFFF` | `orbit` üstündeki metin |
| `success` | `#12805C` | Onaylandı, Açık, Eşleşti |
| `info` | `#2F5FD0` | İnceleniyor, Beklemede |
| `warning` | `#B85600` | Revize İstendi, Yakında |
| `danger` | `#C62F42` | Hata, Kapandı |

Gündüz temasında `dawn` indigodur çünkü amber, beyaz zeminde okunmaz. Şafak hissi gradient'in sıcak ucuyla ve rozet halkasıyla korunur.

### 3.3 Gradient'ler (`SpaceColors` içinde tanımlanır)

- `dawnGradient`: `dawn` → `dawnEnd`, soldan sağa veya aşağıdan yukarı. Yalnızca **ekran başına en fazla bir** büyük öğede kullanılır (örn. "Fikir Durumum" rozeti, analiz tamamlanma kartı).
- `nightGradient`: `bg` → `surface`, dikey, çok hafif. Yalnızca karşılama ve analiz giriş ekranlarının arka planında.
- Dekoratif gradient yıkamaları, her karta gradient eklemek yasaktır.

### 3.4 Kontrast zorunluluğu

- Metin/zemin oranı en az **4.5:1**, büyük metin ve ikonlar için **3:1** olmalıdır.
- Durum yalnızca renkle anlatılmaz: her durum **ikon + metin + renk** üçlüsüyle gösterilir.

### 3.5 `SpaceColors` iskeleti (`core/theme/space_colors.dart`)

```dart
@immutable
class SpaceColors extends ThemeExtension<SpaceColors> {
  const SpaceColors({
    required this.bg,
    required this.surface,
    required this.surfaceHigh,
    required this.outline,
    required this.textPrimary,
    required this.textMuted,
    required this.dawn,
    required this.onDawn,
    required this.dawnEnd,
    required this.orbit,
    required this.onOrbit,
    required this.success,
    required this.info,
    required this.warning,
    required this.danger,
  });

  final Color bg;
  final Color surface;
  // ... diğer alanlar yukarıdaki tablolarla birebir aynı adlarda

  LinearGradient get dawnGradient => LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        colors: [dawn, dawnEnd],
      );

  static const SpaceColors night = SpaceColors(/* Bölüm 3.1 değerleri */);
  static const SpaceColors day = SpaceColors(/* Bölüm 3.2 değerleri */);

  @override
  SpaceColors copyWith({/* tüm alanlar */}) => /* ... */;

  @override
  SpaceColors lerp(ThemeExtension<SpaceColors>? other, double t) => /* Color.lerp ile tüm alanlar */;
}
```

`core/extensions/context_extensions.dart` içinde:

```dart
extension SpaceContext on BuildContext {
  SpaceColors get spaceColors => Theme.of(this).extension<SpaceColors>()!;
}
```

`ColorScheme` de aynı değerlerden üretilir (`primary = dawn`, `surface = surface`, `onSurface = textPrimary`, `error = danger` vb.) ki Material bileşenleri otomatik uyum sağlasın.

---

## 4. Tipografi

Tipografi iki aileyle kurulur ve ikisi birbirinden açıkça farklıdır:

- **Başlıklar: Sora**: geometrik, yukarı doğru açılan karakterli.
- **Gövde ve arayüz: Manrope**: sıcak, çok okunaklı, küçük boyda net.

Her iki aile de Türkçe karakterleri (ğ, ş, ı, İ, ö, ü, ç) tam destekler.

**Yükleme yöntemi (onay gerekir):** Fontlar iki yoldan biriyle eklenebilir: (a) `google_fonts` paketi, (b) `assets/fonts/` klasörü ve `pubspec.yaml` içinde `fonts:` tanımı. İkisi de `project.md` kuralları gereği **kullanıcıdan onay almadan eklenmez**. Ajan, gerekçe ve alternatifle birlikte önce kullanıcıya sorar. Onay gelene kadar sistem fontu kullanılır; tüm stiller `textTheme` üzerinden tanımlandığı için font sonradan tek yerden değişir.

### 4.1 Tip ölçeği (`core/theme/app_text_theme.dart`)

Ölçek oranı yaklaşık 1.2'dir. Tüm boyutlar yalnızca bu dosyada yazılır.

| `textTheme` slotu | Aile | Boyut / Satır | Ağırlık | Nerede |
|---|---|---|---|---|
| `displaySmall` | Sora | 32 / 40 | 700 | Karşılama, analiz tamamlanma |
| `headlineMedium` | Sora | 26 / 34 | 700 | Ekran başlığı |
| `headlineSmall` | Sora | 22 / 30 | 600 | Bölüm başlığı |
| `titleLarge` | Sora | 18 / 26 | 600 | Kart başlığı (mentor adı, program adı) |
| `titleMedium` | Manrope | 16 / 24 | 700 | Liste öğesi başlığı, buton |
| `bodyLarge` | Manrope | 16 / 26 | 400 | Ana okuma metni |
| `bodyMedium` | Manrope | 14 / 22 | 400 | Kart içi metin |
| `labelLarge` | Manrope | 14 / 20 | 700 | Buton, sekme |
| `labelMedium` | Manrope | 12 / 16 | 600 | Chip, rozet, sayaç |
| `bodySmall` | Manrope | 12 / 18 | 400 | Yardımcı not, tarih |

Kurallar:

- Metin okuma satırı en fazla ~70 karakter olmalıdır (geniş ekranlarda içerik `maxWidth: 640` ile sınırlanır).
- **Büyük harf (ALL CAPS) etiket kullanılmaz.** Cümle düzeni (sentence case) kullanılır.
- Başlıkta tek bir kelimeyi farklı renk/italik yapma, kartların üstüne "küçük üst etiket" ekleme gibi süslemeler yapılmaz.
- Sayılar (tutar, yüzde, puan) `FontFeature.tabularFigures()` ile hizalı gösterilir; tutarlar `intl` ile `₺` ve Türkçe biçimle yazılır.
- Sistem yazı boyutu büyütmesi (`textScaler`) en az 1.3 katına kadar taşma olmadan çalışmalıdır.

---

## 5. Boşluk, Köşe ve Yükselti

### 5.1 Boşluk (4'lük ızgara): `core/constants/app_spacing.dart`

`xs 4` · `sm 8` · `md 12` · `lg 16` · `xl 20` · `xxl 24` · `huge 32` · `giant 48`

- Ekran yatay kenar boşluğu: **20** (`xl`).
- Bölümler arası dikey boşluk: **24** (`xxl`).
- Kart iç boşluğu: **16** (`lg`); büyük/öne çıkan kartta **20**.
- Dokunma hedefleri en az **48×48**.

### 5.2 Köşe yarıçapı: `core/constants/app_radius.dart`

Her şeye aynı yarıçap verilmez; hiyerarşiyi yarıçap anlatır.

| Token | Değer | Nerede |
|---|---|---|
| `sm` | 10 | Giriş alanları, küçük düğmeler |
| `md` | 16 | Standart kartlar |
| `lg` | 24 | Öne çıkan kartlar (durum, gelir destek) |
| `sheet` | 28 (yalnızca üst köşeler) | Bottom sheet, `add_expense_sheet` benzeri formlar |
| `pill` | 999 | Chip, rozet, sekme göstergesi |

### 5.3 Yükselti

- Gri, yaygın `BoxShadow` (`rgba(0,0,0,.1)` tipi) **yasaktır.**
- Derinlik **tonal yüzeylerle** verilir: `bg` → `surface` → `surfaceHigh`. Kartlar `outline` renginde **1 px** çerçeve taşır.
- Yalnızca `dawn` rengindeki ana eylem öğeleri, kendi renginde yumuşak bir parlama (`dawn.withValues(alpha: 0.35)`, blur 24, yayılma 0) alabilir.

---

## 6. Ekran İskeleti ve Gezinme

```text
┌─────────────────────────────┐
│ Üst çubuk (şeffaf)          │  ← Mentor sayfasında: sağda "Fikir Durumum" rozeti
├─────────────────────────────┤
│                             │
│  İçerik (IndexedStack)      │  ← kenar boşluğu 20, bölümler arası 24
│                             │
├─────────────────────────────┤
│ Mentor Yatırım Program Topl.│  ← 4 sekme, 72 yükseklik
└─────────────────────────────┘
```

- **Alt gezinme:** `NavigationBar` (Material 3). Seçili sekmede `surfaceHigh` renkli hap göstergesi, ikon `dawn` rengi ve dolu; seçili olmayanlar `textMuted`. Etiketler **her zaman görünür**. Üstte 1 px `outline` çizgisi vardır, gölge yoktur.
- Sekme ikonları `project.md`/`SKILL.md` içindeki önerilerle aynıdır (`*_rounded`).
- Yalnızca `Icons.*_rounded` ailesi kullanılır; arayüzde emoji kullanılmaz.
- **Üst çubuk:** Şeffaf, başlık `headlineSmall`. Kaydırınca zemin `bg`'ye geçer, çerçeve çizgisi belirir.
- **"Fikir Durumum" rozeti** (Mentor üst çubuğu): Bu uygulamanın akılda kalan öğesidir.
  - Hap biçiminde, `dawnGradient` halkalı (2 px) bir çerçeve; içi `surface`.
  - Solda küçük bir **yörünge ilerleme halkası** (başvuru aşamasına göre dolar), yanında durum metni: "Onaylandı", "İnceleniyor" vb.
  - Durum değiştiğinde halka bir kez yukarı doğru nabız atar. Başka zaman sabittir.
  - Dokunma alanı en az 48 yüksekliğinde; `Semantics` etiketi "Fikir durumum, <durum>" olur.
- Sayfa geçişleri Material varsayılanıdır; özel geçiş animasyonu yazılmaz.

---

## 7. Bileşen Kuralları

### 7.1 Düğmeler

| Tür | Görünüm | Kullanım |
|---|---|---|
| Birincil | Dolu `dawn`, metin `onDawn`, yükseklik 52, `AppRadius.pill` | Ekranın tek ana eylemi: "Eşleşme İste", "Başvuruyu Gönder" |
| İkincil | `outline` çerçeveli, metin `textPrimary` | "Takvime Ekle", "Başvuru Bilgisi" |
| Metin | Çerçevesiz, `orbit` renkli | Üçüncül eylemler |

- Ekranda aynı anda **en fazla bir** birincil düğme bulunur.
- Düğmeler basıldığında 120 ms'de %97'ye küçülür (yerel animasyon); devre dışı hâlde `textMuted` %40 opaklık.
- Etiketler eylemin adını söyler, "Gönder/Tamam" gibi genel kelimeler kullanılmaz. Okların (`→`) etikete eklenmesi yasaktır.

### 7.2 Giriş alanları

- Dolgulu (`filled`) alan: zemin `surface`, `AppRadius.sm`, 1 px `outline`; odakta 2 px `orbit` çerçeve.
- Etiket alanın üstünde değil, **kayan etiket** olarak içindedir. Yardım metni altında `bodySmall`.
- Hata: `danger` çerçeve + ikon + düzeltmeyi anlatan cümle. Özür dilenmez ("Hata oluştu, üzgünüz" yazılmaz).

### 7.3 Chip ve durum etiketleri

Durum chip'i her zaman **ikon + metin + renk** içerir:

| Durum | Renk | İkon |
|---|---|---|
| Beklemede, İnceleniyor | `info` | `schedule_rounded` |
| Eşleşti, Onaylandı, Açık | `success` | `check_circle_rounded` |
| Görüşme Planlandı | `orbit` | `event_available_rounded` |
| Revize İstendi, Yakında | `warning` | `edit_note_rounded` / `hourglass_top_rounded` |
| Kapandı, Hata | `danger` | `block_rounded` |

Zemin: ilgili rengin `%14` opaklığı, metin: rengin kendisi (kontrast 4.5:1'i sağlamıyorsa `textPrimary`).

### 7.4 Kartlar: aynı kalıba basılmaz

Her kart türü içeriğinin yapısını yansıtır. Hepsini aynı "başlık + üç satır + buton" şablonuna döküp çoğaltmak yasaktır.

- **Mentor kartı:** Solda ad baş harfli avatar ve çevresinde **müsaitlik halkası** (`success` = müsait, `outline` = dolu). Uzmanlık alanları chip'lerle; puan `dawn` renkli yıldızla. Eylem: "Eşleşme İste".
- **Yatırımcı kartı:** Bilet büyüklüğü, bir **aralık çubuğu** olarak gösterilir (tüm yatırımcıların min–max ekseninde bu yatırımcının aralığı `dawn` dolgulu). Aşama chip'i üstte. Eylem: "İletişime Geç".
- **Program kartı:** Sol kenarda 4 px'lik **durum şeridi** (Açık = `success`, Yakında = `warning`, Kapandı = `danger`). Son başvuru tarihi belirgin; kalan gün sayısı ayrıca yazılır ("12 gün kaldı"). Eylemler: "Takvime Ekle", "Başvuru Bilgisi".
- **Topluluk gönderisi:** Kartsız, sade akış. Gönderiler `outline` ayırıcıyla ayrılır; avatar, ad, zaman, metin, beğeni sayısı ve yanıt sayısı.

Kart zemini `surface`, çerçeve `outline` 1 px, yarıçap `AppRadius.md` (öne çıkanlarda `lg`).

### 7.5 Bottom sheet ve formlar

- Üst köşeler `AppRadius.sheet`, üstte 36×4 tutma çubuğu (`outline`).
- Klavye açıldığında içerik `viewInsets` ile yükselir; birincil düğme klavyenin üstünde sabit kalır.

### 7.6 Listeler

- Uzun listeler `ListView.builder` / `SliverList` ile (project.md). Öğeler arası boşluk 12.
- Sayfa sonunda alt gezinmenin altında kalmamak için `bottom` boşluğu `giant` (48).

---

## 8. Ekran Bazlı Tasarım Notları

### 8.1 Mentor

- Üst çubukta "Fikir Durumum" rozeti (Bölüm 6).
- "Önerilen Mentorlar" yatay kaydırmalı kısa şerittir; fikrin sektörü başlıkta yazılır ("Teknoloji sektörü için önerilenler").
- Filtreler yatay kayan chip satırıdır; seçili filtre `surfaceHigh` + `dawn` çerçeve.
- Eşleşme durumu kartın alt satırında durum chip'i olarak gösterilir.

### 8.2 Yatırımcılar

- Kategori sekmeleri (Şirketler / Holdingler / Melek Yatırımcılar / Girişim Sermayesi Fonları) kaydırılabilir `TabBar`; seçili sekme altında `dawn` renkli 3 px gösterge.
- Filtreler (aşama, sektör, bilet aralığı) tek bir "Filtrele" bottom sheet'inde toplanır; aktif filtre sayısı düğmede yazar.

### 8.3 Programlar

- Kategori sekmeleri yatırımcılarla aynı biçimdedir.
- Kartlar son başvuru tarihine göre sıralanabilir; kapanmış programlar `%60` opaklıkla ve en altta durur.
- "Başvuru adımları" kartın içinde genişleyen (expand) bir bölümdür; açılırken yükseklik 240 ms animasyonla değişir.

### 8.4 Topluluk

- Basit, X benzeri akış. Süsleme yok.
- **Gönderi oluşturma:** Alt kısımda sabit giriş çubuğu. Karakter sayacı halka olarak gösterilir: 0–259 `outline`, 260–279 `warning`, 280 `danger`. Limit aşılamaz.
- **Beğeni:** Kalp ikonu; basınca 160 ms'de %120'ye büyüyüp döner (yerel animasyon). Beğenilmişse `danger` tonlu dolu kalp; renk dışında dolu/boş şekil farkı da vardır.
- **Onaysız kullanıcı:** Alt çubuk yerine `surfaceHigh` zeminli, kilit ikonlu bilgi alanı: "Paylaşım için fikrinin onaylanması gerekir". Beğeni ve yanıt düğmeleri devre dışı görünür. (Yetki kontrolü controller'dadır; UI yalnızca sonucu gösterir.)
- Yanıtlar tek seviyedir; yanıtlar gönderinin altında 16 px içeriden, solda ince `outline` çizgisiyle gösterilir.

### 8.5 Analiz formu (ilk giriş ve stepper)

- **İlk soru:** "İş planın var mı?" Tam ekran, `nightGradient` zemin üzerinde yıldız alanı animasyonu (Bölüm 9). İki seçenek: birincil "Evet, planımı göndereceğim", metin düğme "Hayır, uygulamayla devam et".
- **İlerleme göstergesi:** 8 bölümü temsil eden 8 **yörünge parçası** (kısa yatay segment). Dolu bölüm `dawn`, aktif bölüm `dawn` ve altı çizili, boş bölüm `outline`. Bir bölüm atlanıp eksik bırakılmışsa segmentin üstünde küçük `warning` noktası görünür. (Bölümler gerçekten sıralı bir süreç olduğu için numaralı gösterim burada uygundur.)
- Bölümler arasında serbest geçiş vardır; eksik bölümler görsel olarak işaretlenir ama engellenmez.
- **Plan tabloları (Gantt, kilometre taşı, bütçe):** Tablo satırları 48 yükseklik, başlık satırı `surfaceHigh`, yatay taşmada tablo kendi içinde kaydırılır. Gantt çubukları `orbit` renklidir.
- **Özet ve Gönderim:** Eksik alan varsa üstte `warning` bilgi kartı: "3 alan eksik. Dokunarak ilgili bölüme geç." Her eksik alan, doğrudan ilgili alana götüren bir satırdır. Tüm alanlar doluysa kart `success`'e döner ve birincil düğme "Başvuruyu Gönder" aktif olur. Eksik varken düğme pasiftir ve nedeni yanında yazılıdır.
- **Taslak kaydı:** Her adım geçişinde sessizce kaydedilir; ekranın üstünde kısa süreli "Taslak kaydedildi" ipucu çıkar (1.5 sn, `bodySmall`).
- **Gönderim sonrası:** Tek seferlik "yükselme" anı: halka `dawnGradient` ile dolar ve "Başvurun uzman ekibe ulaştı" metni görünür (Bölüm 9).

### 8.6 Fikir Durumum

- Üstte durum kartı (`AppRadius.lg`, `dawnGradient` ince çerçeve): fikir adı, ilerleme yüzdesi, aktif aşama.
- **Başvuru aşamaları:** Gönderildi → İnceleniyor → Revize İstendi / Onaylandı. Yatay yörünge çizgisi üzerinde noktalar; tamamlananlar dolu `dawn`, aktif olan nabızlı halka, bekleyenler `outline`.
- **Hukuki süreç zaman çizelgesi:** Dikey zaman çizelgesi; solda sürekli bir çizgi, adımlar düğümdür. Tamamlanan adım `success` + onay ikonu, aktif adım `dawn` halkası, bekleyen adım `outline`. Burada numaralandırma uygundur çünkü içerik gerçek bir sıradır.
- **Avukat kartı:** Avatar, ad, baro bilgisi (mock), "Mesaj Gönder" ikincil düğmesi.
- **Gelir destek taahhüdü kartı:** Aylık hedef ve ilerleme bir **yay göstergesiyle** (yarım daire) gösterilir; yay `dawnGradient` ile dolar. Hedef tutar `headlineSmall`, kalan tutar `bodySmall`.
- Örnek fikirler (en az 6) yatay seçici ile değiştirilir; her fikir sektör rengi taşımaz, tüm renk sistemi tutarlı kalır.

---

## 9. Hareket

İlke: **Hareket, bir şeyin değiştiğini göstermek için vardır, süslemek için değil.** Her bölümün kaydırılırken belirmesi, her kartta hover efekti, her listede kademeli giriş animasyonu gibi genel kalıplar **yasaktır.**

**Tek "orkestre" an: yıldız alanı ve şafak.**

- Yıldız alanı (`StarFieldBackground`, `features/shell/widget/` altında, `StatefulWidget` + `AnimationController`) yalnızca **karşılama / "İş planın var mı?" ekranında** ve gönderim sonrası kutlama anında çalışır. Uygulamanın diğer ekranlarında yoktur.
- Yıldızlar yavaşça (4–8 sn) parlayıp söner, en fazla 60 yıldız. Alt kısımda ufuk çizgisinde `dawn` ışıması bir kez yükselir (1.2 sn, `Curves.easeOutCubic`).
- Gönderim sonrasında aynı ışıma bir kez daha çalar.

**Kullanıcı eylemine yanıt veren hareketler (serbest):** düğme basış ölçeği, beğeni, expand/collapse, sekme göstergesi kayması, bottom sheet açılışı, ilerleme halkası dolumu.

| Süre token (`app_durations.dart`) | Değer | Kullanım |
|---|---|---|
| `quick` | 120 ms | Basış geri bildirimi |
| `base` | 240 ms | Genişleme, sekme, chip |
| `slow` | 500 ms | İlerleme dolumu |
| `hero` | 1200 ms | Şafak ışıması (yalnızca yukarıdaki 2 an) |

Eğriler: giriş `Curves.easeOutCubic`, çıkış `Curves.easeInCubic`. Zıplayan (elastic/bounce) eğriler kullanılmaz.

**Hareketi azalt:** `MediaQuery.disableAnimationsOf(context)` true ise yıldız alanı statik çizilir, tüm süreler 0'a iner, ışıma gösterilmez.

Animasyon `AnimationController`'ları `dispose()` ile temizlenir. Sayfa düzeyinde `setState` ile animasyon sürülmez; yalnızca yerel, küçük `StatefulWidget` içinde kalır (project.md Kırmızı Çizgi 1).

---

## 10. Yazı Tonu (Mikro Metin)

Dil Türkçedir, "sen" hitabıyla sıcak ve net konuşulur. Tonu cesaretlendiricidir ama abartılı değildir.

- **Cümle düzeni** kullanılır, her kelimenin ilk harfi büyük yazılmaz (özel adlar ve sabit ekran adları hariç).
- **Eylem adı tüm akışta aynı kalır:** Düğme "Eşleşme İste" ise bildirim "Eşleşme isteği gönderildi" der.
- **Sade yaz:** Sistemin iç adlarını değil, kullanıcının anladığı kelimeleri kullan. "Controller hatası" değil, "Mentorlar yüklenemedi".
- **Hata mesajı:** Ne olduğunu ve ne yapılacağını söyler, özür dilemez. Örnek: "Başvuru gönderilemedi. 3 alan boş: Ekip, Pazar, Marka."
- **Boş ekran bir davettir:** "Henüz eşleşmen yok. Önerilen mentorlara göz at." ve yanında eylem düğmesi.
- **Başarı:** Kısa ve somut: "Taslak kaydedildi.", "Başvurun uzman ekibe ulaştı."
- Hukuki süreç adları Türkiye mevzuatındaki gerçek karşılıklarıyla yazılır (Ticaret Sicil Kaydı, Vergi Kaydı, Marka Tescil Başvurusu vb.).
- Mock veriler gerçekçi, Türkiye bağlamında ve çeşitli olmalıdır; "Lorem ipsum", "Test 1", "Kullanıcı A" yasaktır.

---

## 11. Erişilebilirlik ve Kalite Tabanı

- Kontrast ve dokunma hedefi kuralları (3.4, 5.1) her ekranda geçerlidir.
- Tüm ikon düğmelerinde `tooltip`/`Semantics` etiketi bulunur.
- Klavye/odak: odaklanabilir her öğede görünür odak halkası (`orbit`, 2 px).
- Metin ölçeği 1.3'te taşma yok; metinler `Flexible`/`Expanded` ve `maxLines + overflow` ile korunur.
- Yatay yönde ve küçük ekranda (320 px genişlik) düzen bozulmaz; geniş ekranlarda içerik `maxWidth: 640` ile ortalanır.
- Karanlık/aydınlık geçişte hiçbir ekranda sabit renk kalmaz (tüm renkler `SpaceColors`'tan gelir).
- Her iki temada da her ekran gözle kontrol edilir.

---

## 12. Dosya Yerleşimi (mevcut klasör düzenine uygun)

Yeni klasör açılmaz. Tasarım dosyaları mevcut klasörlere girer:

```text
lib/core/
    constants/
        app_spacing.dart
        app_radius.dart
        app_durations.dart
    theme/
        space_colors.dart        // ThemeExtension (Gece + Gündüz)
        app_text_theme.dart      // Bölüm 4.1 ölçeği
        app_theme.dart           // ThemeData (light/dark), bileşen temaları
        theme_controller.dart    // ValueNotifier<ThemeMode> + shared_preferences
    extensions/
        context_extensions.dart  // context.spaceColors
lib/features/shell/widget/
    star_field_background.dart   // yalnızca karşılama ve kutlama anında
    idea_status_badge.dart       // "Fikir Durumum" rozeti
```

Paylaşılan küçük bileşenler (durum chip'i vb.) ilk kullanıldıkları feature'ın `widget/` klasöründe yazılır; birden fazla feature kullanıyorsa ajan, `core/` altında yeni klasör açmadan önce kullanıcıya sorar.

`app_theme.dart` içinde şu bileşen temaları tanımlanır: `NavigationBarTheme`, `AppBarTheme`, `FilledButtonTheme`, `OutlinedButtonTheme`, `InputDecorationTheme`, `ChipTheme`, `BottomSheetTheme`, `DividerTheme`, `CardTheme`. Widget'lar bu temaları kullanır; stil, widget içinde yeniden yazılmaz.

### Onay gerektirenler (tasarım açısından)

- `google_fonts` ya da font asset klasörü (Bölüm 4)
- `flutter_svg`, `lottie` (illüstrasyon/animasyon için; önce yerel `CustomPainter` alternatifi sunulur)
- `core/` altında yeni klasör

---

## 13. Uygulama Sırası (Ajan için)

Büyük işler bölümlere ayrılır; her bölüm sonunda `flutter analyze` (0 uyarı) ve `flutter test` çalıştırılır.

1. **Token'lar:** `app_spacing`, `app_radius`, `app_durations`, `space_colors`, `app_text_theme`, `app_theme`, `context_extensions`.
2. **Tema kontrolü:** `theme_controller` (ValueNotifier + kayıt), varsayılan Gece.
3. **Shell:** `NavigationBar`, `IndexedStack`, üst çubuk, "Fikir Durumum" rozeti.
4. **Sayfalar:** Mentor → Yatırımcılar → Programlar → Topluluk (her biri ayrı bölüm).
5. **Analiz formu:** önce iskelet ve ilerleme göstergesi, sonra bölümler.
6. **Fikir Durumum:** durum kartı, hukuki zaman çizelgesi, gelir destek kartı.
7. **Cila:** yıldız alanı, şafak ışıması, hareketi azalt desteği, iki temada görsel kontrol.

---

## 14. Teslimden Önce Kontrol Listesi

- [ ] Widget'larda `Color(0xFF...)`, `Colors.white/black`, sabit `fontSize` yok.
- [ ] Hiçbir `withOpacity` / `surfaceVariant` / `background` (kullanımdan kalkmış API) yok.
- [ ] Boşluk ve yarıçaplar token'lardan geliyor.
- [ ] Ekranda en fazla bir birincil düğme, en fazla bir `dawnGradient` öğesi var.
- [ ] Durumlar ikon + metin + renkle gösteriliyor.
- [ ] Kartlar içeriğine göre farklılaşıyor; hepsi aynı şablon değil.
- [ ] Her ekran Gece ve Gündüz temasında, 1.3 metin ölçeğinde kontrol edildi.
- [ ] Hareketi azalt ayarı çalışıyor.
- [ ] Mikro metinler cümle düzeninde, eylem adları akış boyunca tutarlı.
- [ ] `flutter analyze` → 0 uyarı, 0 hata; `flutter test` → geçti.
