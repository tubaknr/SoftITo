# KiralaGo — Tasarım ve Stil Kılavuzu (style.md)

Bu doküman Ajan (AntiGravity) için bağlayıcı tasarım rehberidir. Renk, tipografi, boşluk, şekil ve bileşen kararlarının **tek kaynağı** burasıdır ve kod tarafında yalnızca tema dosyalarında (`core/theme/`, `core/constants/`) bulunur. Widget içinde `Color(0xFF...)`, sabit `TextStyle(fontSize: ...)`, sihirli boşluk/yarıçap sayıları YAZILMAZ.

---

## 1. Tasarım Prensipleri

- **Material Design 3** (`useMaterial3: true`), `ColorScheme.fromSeed` tabanlı dinamik şema.
- **Güven hissi:** Sakin, temiz ve profesyonel; yüksek okunabilirlik. Kritik anlarda (Kirala, imza, onay) net vurgu.
- **Hızlı tarama:** Araç kartlarında önemli bilgi (puan, fiyat, vites, yakıt) bir bakışta okunur.
- **Aydınlık ve karanlık mod eşit kalitede** tasarlanır; hiçbir ekran yalnızca tek temada test edilip bırakılmaz.
- **Tutarlılık:** Aynı işlev, her ekranda aynı bileşen ve aynı renk rolüyle gösterilir.

---

## 2. Renk Sistemi

### 2.1 Tohum (seed) ve temel şema
- `seedColor`: **Yol Mavisi** `#2457F5`
- `ColorScheme.fromSeed(seedColor: ..., brightness: ...)` ile aydınlık ve karanlık şemalar üretilir. Değerler `app_theme.dart` içinde tanımlanır.
- Gerekirse şemanın bazı rolleri (`primary`, `tertiary`, `surface`) aşağıdaki paletle `copyWith` yapılabilir.

### 2.2 Marka paleti

| Rol | Aydınlık | Karanlık | Kullanım |
|---|---|---|---|
| Birincil (primary) | `#2457F5` | `#9DB4FF` | Ana butonlar, seçili sekme, bağlantılar |
| Üzerindeki (onPrimary) | `#FFFFFF` | `#0A1A4D` | Birincil üstü metin/ikon |
| Üçüncül / vurgu (tertiary) | `#FF8A00` | `#FFB866` | Kirala CTA gradient ucu, öne çıkan etiketler |
| Zemin (surface) | `#F7F8FC` | `#0E1116` | Sayfa zemini |
| Kart yüzeyi (surfaceContainer) | `#FFFFFF` | `#171B22` | Kartlar, bottom sheet |
| Ana metin (onSurface) | `#14171F` | `#E6E9F0` | Başlık ve gövde metni |
| İkincil metin (onSurfaceVariant) | `#5A6275` | `#A3AABB` | Açıklama, ipucu metni |
| Çerçeve (outlineVariant) | `#DCE0EA` | `#2A303B` | Ayırıcılar, kart çerçeveleri |
| Hata (error) | `#BA1A1A` | `#FFB4AB` | Hata mesajları, silme |

### 2.3 Anlamsal renkler — `AppColors` (`ThemeExtension`)

`core/theme/app_colors.dart` içinde `ThemeExtension<AppColors>` olarak tanımlanır ve `context.appColors` ile erişilir. Her alan hem aydınlık hem karanlık için ayrı değer taşır; `copyWith` ve `lerp` uygulanır.

| Alan | Aydınlık | Karanlık | Kullanım |
|---|---|---|---|
| `success` | `#1E8E4E` | `#6FD79A` | Müsait, yakıt dolu, temiz teslim |
| `warning` | `#B26A00` | `#FFC46B` | Uyarı, geç kalma, hafif hasar kaydı |
| `danger` | `#BA1A1A` | `#FFB4AB` | Dolu gün, kirli teslim, ağır hasar kaydı |
| `rating` | `#F5A400` | `#FFC83D` | Puan yıldızları |
| `calendarBooked` | `#FBE1E1` | `#4A2226` | Takvimde dolu gün arka planı |
| `calendarSelected` | birincil | birincil | Seçili tarih aralığı |
| `calendarAvailable` | `#E6F4EA` | `#1D3326` | Müsait gün göstergesi |
| `ctaGradientStart` | `#2457F5` | `#5B7FFF` | Kirala butonu gradient başlangıç |
| `ctaGradientEnd` | `#FF8A00` | `#FF9F2E` | Kirala butonu gradient bitiş |

Kurallar:
- Anlamsal renkler yalnızca anlamına uygun yerde kullanılır (kırmızı = olumsuz/dolu, yeşil = olumlu/müsait).
- **Renk tek başına anlam taşımaz:** Dolu gün hem renk hem çizgi/ikon ile gösterilir; olumlu/olumsuz etiketlerde ikon + metin bulunur.
- Metin/zemin kontrastı en az **4.5:1** olur (büyük metinde 3:1).

---

## 3. Tipografi

- Yazı tipi: Sistem varsayılanı (Roboto / SF). `google_fonts` kullanılacaksa önce **kullanıcıdan onay alınır**.
- Tüm metin stilleri `ThemeData.textTheme` içinde tanımlanır; widget'larda yalnızca `Theme.of(context).textTheme.xxx` kullanılır. Gerekirse `.copyWith(color: ...)` ile yalnızca tema rengi değiştirilir.

| Stil (M3) | Boyut / Ağırlık | Kullanım |
|---|---|---|
| `headlineMedium` | 28 / 600 | Karşılama başlığı, sayfa ana başlığı |
| `titleLarge` | 22 / 600 | Üst çubuk başlıkları, araç adı (detay) |
| `titleMedium` | 16 / 600 | Kart başlığı (marka-model), bölüm başlığı |
| `bodyLarge` | 16 / 400 | Ana gövde metni, yorum metni |
| `bodyMedium` | 14 / 400 | Kart içi bilgiler |
| `labelLarge` | 14 / 600 | Buton metni |
| `labelMedium` | 12 / 500 | Chip, etiket, alt başlık |
| `labelSmall` | 11 / 500 | Yardımcı ipuçları |

- Fiyatlar `titleMedium`/`titleLarge` ve birincil renkle gösterilir; para birimi sembolü (₺) ve periyot ("/gün") `labelMedium` ile ayrılır.
- Metin ölçeklemeye (`textScaler`) saygı gösterilir; sabit yükseklikli kutularda metin taşmaması için `maxLines` + `overflow: TextOverflow.ellipsis` kullanılır.

---

## 4. Boşluk, Şekil ve Yükseklik

`core/constants/app_spacing.dart` içinde sabitler:

| Sabit | Değer | Kullanım |
|---|---|---|
| `AppSpacing.xs` | 4 | İkon-metin arası |
| `AppSpacing.sm` | 8 | Chip arası, küçük boşluk |
| `AppSpacing.md` | 12 | Kart içi boşluk |
| `AppSpacing.lg` | 16 | Sayfa kenar boşluğu, kart padding |
| `AppSpacing.xl` | 24 | Bölümler arası |
| `AppSpacing.xxl` | 32 | Büyük ayırıcı boşluklar |

| Sabit | Değer | Kullanım |
|---|---|---|
| `AppRadius.sm` | 8 | Chip, küçük girdi |
| `AppRadius.md` | 12 | Girdi alanı, küçük kart |
| `AppRadius.lg` | 16 | Araç kartı |
| `AppRadius.xl` | 28 | Bottom sheet, diyalog, CTA buton |

- Sayfa yatay kenar boşluğu: `AppSpacing.lg`.
- Kartlar M3 `Card` (filled/outlined): düşük yükseklik (elevation 0–1); ayrım `outlineVariant` çerçeve veya `surfaceContainer` tonuyla yapılır, ağır gölge kullanılmaz.
- Dokunma hedefleri en az **48×48 dp**.

---

## 5. Bileşen Kuralları

### 5.1 Butonlar
| Tür | Kullanım |
|---|---|
| `FilledButton` | Birincil eylem (Giriş yap, Kiralamayı onayla, Uygula) |
| `FilledButton.tonal` | İkincil vurgulu eylem (Ekspertiz raporunu gör, İndir) |
| `OutlinedButton` | Alternatif eylem (Temizle, İptal) |
| `TextButton` | Düşük vurgu (Daha fazla göster, Vazgeç) |
| `IconButton` | Araç çubuğu eylemleri (filtre, tema, favori) |
| `FloatingActionButton.extended` | Araç Ekle (Araçlarım sayfası) |
| `SegmentedButton` | Tema seçimi, vites seçimi, fiyat periyodu |

**[Kirala] CTA butonu (özel kural):**
- Ekran altında sabit, tam genişlikte, yüksekliği 56 dp, köşe yarıçapı `AppRadius.xl`.
- Arka plan: `ctaGradientStart → ctaGradientEnd` yatay gradient; metin ve ikon beyaz/`onPrimary` rolünde.
- Solunda `Icons.key_rounded` veya `Icons.event_available_rounded` ikonu; metin `labelLarge` (kalın).
- Basılı durumda hafif ölçek animasyonu (0.97) ve ripple; pasifken soluk (`onSurface` %12) gösterilir.
- Yanında seçilen tarih aralığına göre toplam fiyat özeti gösterilir ("3 gün • ₺2.400").
- Bu buton `core/widgets/` altında `PrimaryCtaButton` olarak yazılır ve gradient renkleri yalnızca `AppColors`'tan alır.

### 5.2 Araç Kartı
- `Card` (outlined), `AppRadius.lg`; üstte 16:9 görsel (yerel placeholder), altında bilgiler.
- Satır 1: marka-model-yıl (`titleMedium`); sağda puan (`rating` renginde yıldız + sayı).
- Satır 2: tip, vites, yakıt, koltuk bilgisi küçük ikonlu `labelMedium` metinler (ikon + metin).
- Satır 3: günlük fiyat (birincil, vurgulu) ve sahip adı.
- Tüm kart tıklanabilir (`InkWell`), Hero animasyonu ile detay görseline geçiş yapılabilir.

### 5.3 Girdi Alanları
- `InputDecorationTheme`: `OutlineInputBorder`, `AppRadius.md`; etiket (`labelText`) her zaman görünür; yardımcı/hata metni `labelMedium`.
- Hata durumunda `error` rengi + hata ikonu; mesaj alanın hemen altında.
- Şifre alanında sağ uçta göster/gizle `IconButton`.

### 5.4 Chip'ler
- Filtre: `FilterChip`/`ChoiceChip`. Seçili: `secondaryContainer`. Aktif filtre özeti: silinebilir `InputChip`.
- İade etiketleri (temiz teslim, yakıt boş vb.): ikonlu `Chip`; olumlu → `success`, olumsuz → `danger`, nötr → `outlineVariant`.

### 5.5 Takvim
- Aylık ızgara; hücre yuvarlak köşeli (`AppRadius.sm`).
- **Dolu gün:** `calendarBooked` zemin + üstü çizili sayı + küçük kilit/çarpı ikonu; tıklanamaz.
- **Müsait gün:** normal; göstergede `calendarAvailable`.
- **Seçili aralık:** başlangıç/bitişte dolu daire (`primary`), arası `primaryContainer`.
- Takvim altında açıklama satırı: Dolu / Müsait / Seçili.

### 5.6 Gezinme
- Alt gezinme: M3 `NavigationBar`; seçili öğe `secondaryContainer` göstergesi; etiketler her zaman görünür.
- Üst çubuk: `AppBar` (M3, kaydırmada `surfaceTint` ile yükselme).
- Sayfalar arası geçiş: platform varsayılanı; araç görselinde `Hero`.

### 5.7 Diyaloglar ve Bottom Sheet
- `AlertDialog`: başlık `titleLarge`, içerik `bodyMedium`; eylem butonları sağda, birincil eylem `FilledButton`/`TextButton`.
- Yıkıcı eylemler (sil, iptal, çıkış) onay diyaloğunda `error` renkli birincil eylemle gösterilir.
- Filtre `showModalBottomSheet`: `isScrollControlled`, üst köşeler `AppRadius.xl`, sürükleme tutacağı gösterilir.
- Başarı/hata geri bildirimi: `SnackBar` (floating, `AppRadius.md`), gerekirse "Geri al" eylemiyle.

### 5.8 Yorum Kartı ve Puan
- Üstte avatar + ad (örn. "Ahmet Y.") + tarih; sağda `RatingStars`.
- Altında yorum metni (`bodyLarge`, en fazla 4 satır, "devamı" ile genişleyebilir).
- Kiracı yorumlarında iade etiketi chip'leri metnin altında.
- Liste altındaki **"Daha fazla göster"** → `TextButton` ya da `OutlinedButton`; genişleyince "Daha az göster" olur.

### 5.9 E-İmza Alanı
- Yüksekliği 180 dp, `surfaceContainer` zemin, kesikli `outlineVariant` çerçeve, `AppRadius.md`.
- Çizgi rengi `onSurface`; boşken ipucu metni "Buraya imzanızı atın" (`bodyMedium`, ikincil renk).
- Altında "Temizle" (`TextButton`) ve "Kaydet" (`FilledButton`) butonları; imza tamamlanınca onay ikonu (`success`).

### 5.10 Boş, Yükleniyor ve Hata Durumları
- Her liste için `EmptyState`: büyük ikon + başlık + açıklama + (varsa) eylem butonu.
- Yükleme: `CircularProgressIndicator` (butonda küçük, sayfada ortalı) veya iskelet (shimmer'sız, `surfaceContainerHighest` bloklar).
- Hatalar kullanıcı dostu, çözüm öneren dilde yazılır; teknik hata metni gösterilmez.

---

## 6. İkon Kullanımı

- Yalnızca **Material Icons (rounded)** kullanılır (`Icons.xxx_rounded`).
- Anlam eşlemesi: araç `directions_car_rounded`, motosiklet `two_wheeler_rounded`, scooter `electric_scooter_rounded`, rezervasyon `event_note_rounded`, profil `person_rounded`, filtre `tune_rounded`, puan `star_rounded`, konum `location_on_rounded`, kamera `videocam_rounded`, poliçe `description_rounded`/`download_rounded`, doğrulanmış/güvenilir `verified_rounded`.
- Aynı anlam için ekranlar arasında aynı ikon kullanılır.

---

## 7. Hareket (Animasyon)

- Süreler `core/constants/app_durations.dart` içinde: `short` 150 ms, `medium` 250 ms, `long` 400 ms.
- Kullanılacak yerler: `AnimatedSwitcher` (tema/sekme içerikleri), `AnimatedContainer` (seçili chip/gün), `Hero` (araç görseli), buton basma ölçeği.
- Animasyonlar sade tutulur; yalnızca yerel animasyon durumu için `StatefulWidget` (kırmızı çizgi: sayfa düzeyinde `setState` yok).
- Sistem "hareketi azalt" ayarını dikkate al (`MediaQuery.disableAnimationsOf`).

---

## 8. Tema Yönetimi

- `app_theme.dart` içinde `lightTheme` ve `darkTheme` (`ThemeData`) tanımlanır; ikisi de `useMaterial3: true`, aynı `textTheme`, `InputDecorationTheme`, `CardTheme`, `NavigationBarTheme`, `AppBarTheme`, `FilledButtonTheme`, `DialogTheme`, `ChipTheme`, `SnackBarTheme` ve `AppColors` uzantısını içerir.
- `MaterialApp(theme: ..., darkTheme: ..., themeMode: ...)`; `themeMode` değeri `ThemeController` (`ValueNotifier<ThemeMode>`) ile `ValueListenableBuilder` üzerinden verilir.
- Seçim `shared_preferences` ile kaydedilir; ilk açılışta varsayılan **Sistem**.
- `context_extensions.dart` içinde `extension AppThemeX on BuildContext { AppColors get appColors => ...; }`.

---

## 9. Erişilebilirlik

- Tüm `IconButton`'lara `tooltip`; görsellere `semanticLabel`.
- Dokunma hedefi ≥ 48 dp; metin kontrastı ≥ 4.5:1.
- Renk dışında ikinci bir ipucu (ikon, metin, çizgi) her zaman bulunur.
- Form alanlarında `autofillHints`, doğru `keyboardType` ve `textInputAction` kullanılır.
- Dil değişikliği ve metin ölçeklemesinde taşma olmaz (iki dilde de test edilir).

---

## 10. Yapılacaklar / Yapılmayacaklar

**Yapılacaklar**
- Tüm renk, stil, boşluk ve yarıçap değerlerini tema/sabit dosyalarından al.
- Aydınlık ve karanlık modu her ekranda kontrol et.
- Her yeni bileşende `const` kullan ve 40 satırı geçen `build` metodunu böl.
- Yeni görsel karar gerekiyorsa önce bu dokümana ekle, sonra uygula.

**Yapılmayacaklar**
- Widget içinde `Color(0xFF...)`, `Colors.red` gibi doğrudan renk veya sabit `TextStyle(fontSize: ...)` yazma.
- Ağır gölge, aşırı gradient veya dikkat dağıtan animasyon ekleme ([Kirala] butonu hariç gradient kullanma).
- Renkle tek başına anlam verme.
- Onay almadan `google_fonts`, `flutter_svg`, `lottie` gibi paket ekleme.
