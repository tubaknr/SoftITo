# KiralaGo — Araç Kiralama Uygulaması

Bu doküman Flutter projesinde geliştirme yapacak olan Ajan (AntiGravity) yapay zeka ve yazılım geliştiriciler için bağlayıcı bir kılavuzdur. Projede üretilen her kod satırı buradaki kurallara UYMAK ZORUNDADIR. Ekran içerikleri için `SKILL.md`, görsel kurallar için `style.md` dosyaları da aynı şekilde bağlayıcıdır.

---

## 1. Projenin Kimliği ve Vizyonu

- **Uygulama Adı:** KiralaGo (araç kiralamayı kolaylaştıran, güvenilir araç sahibi ve kiracı eşleştiren platform) — ad değiştirilebilir.
- **Amaç:**
  - Araç bulmayı kolaylaştırmak.
  - Güvenilir araç sahiplerini ve güvenilir kiracıları görünür kılmak (puan + yorum).
  - Kiracı ile araç sahibi arasında hukuki ve finansal kolaylık sağlamak (e-imzalı kiralama formu, sigorta poliçesi, ödeme özeti).
- **Kullanıcı rolleri:** Kiracı ("Araç kiralamak istiyorum") ve Araç Sahibi ("Araç kiralamaya vermek istiyorum"). İki rol farklı giriş sayfalarına yönlendirilir.
- **Kapsam:** Bu proje bir **ödev projesidir**. Gerçek sunum, gerçek ödeme, gerçek kimlik doğrulama, gerçek harita/trafik servisi YOKTUR. Tüm veri mock'tur.
- **Hedef Platformlar:** Android ve iOS öncelikli; ardından web ve masaüstü.
- **Flutter SDK:** 3.27.x
- **Dart SDK:** 3.6.0
- **Teknoloji:** Yalnızca Flutter ve Dart.
- **Tasarım Dili:** Material Design 3 (`useMaterial3: true`).
- **Diller:** Türkçe (varsayılan) ve İngilizce. Kullanıcıya görünen hiçbir metin kodun içine sabit yazılmaz.
- **Temalar:** Aydınlık ve karanlık mod (kullanıcı değiştirebilir, seçim kalıcıdır).

### Ödevde KESİNLİKLE bulunması gereken 4 konu

Aşağıdaki konuların her biri uygulamada açıkça ve eksiksiz bulunmak zorundadır. Ajan her bölüm sonunda bu tablonun karşılandığını kontrol eder.

| Konu | Uygulamada nerede karşılanır |
|---|---|
| Temel UI elemanları, butonlar ve etkileşimler | Araç kartları, filtre chip'leri, `SegmentedButton`, `FilledButton`, `OutlinedButton`, `IconButton`, `FloatingActionButton`, `Switch`, `Checkbox`, `Slider`/`RangeSlider`, `TabBar`, `NavigationBar`, `ListView.builder`, takvim, "Daha fazla göster" butonu, "Kirala" CTA butonu |
| Form yönetimi ve validasyonlar | Giriş formu, kayıt formu, kiralama formu, araç ekleme formu (araç sahibi) — `Form` + `GlobalKey<FormState>` + `TextFormField` + `validator` |
| Kullanıcı girişi | Rol seçimli giriş (mock kimlik doğrulama), oturum durumu, çıkış |
| Material Design 3 ve tema yönetimi (dark/light) | `ColorScheme.fromSeed`, `ThemeData`, `ThemeExtension`, `ValueNotifier<ThemeMode>`, ayarlardan geçiş, kalıcı kayıt |
| Diyaloglar | `AlertDialog` (onay, çıkış, hata), `showModalBottomSheet` (filtreler), `showDatePicker`/`showTimePicker`, imza diyaloğu, gecikme bildirim diyaloğu, `SnackBar` |

---

## 2. Mimari Desen ve Dizin Haritası

Mimari: **Özellik bazlı (feature-first)** + katmanlı ayrım (controller / models / view / widget / data). Kodlar kesinlikle tek bir yerde toplanmayacaktır. Her modül kendi feature klasöründe kodlanacaktır.

```text
lib/
    main.dart
    l10n/
        app_tr.arb
        app_en.arb
    core/
        constants/
            app_spacing.dart
            app_durations.dart
        theme/
            app_theme.dart
            app_colors.dart          # ThemeExtension (context.appColors)
        extensions/
            context_extensions.dart
        validators/
            app_validators.dart
        controllers/
            theme_controller.dart    # ValueNotifier<ThemeMode>
            locale_controller.dart   # ValueNotifier<Locale>
            session_controller.dart  # ValueNotifier<SessionState>
        widgets/
            rating_stars.dart
            empty_state.dart
            section_header.dart
            confirm_dialog.dart
    features/
        auth/
            controller/
            models/
            view/
            widget/
        shell/
            controller/
            view/
            widget/
        vehicle_list/            # ana sayfa: filtreler + araç listesi
            controller/
            models/
            view/
            widget/
            data/
        vehicle_detail/
            controller/
            models/
            view/
            widget/
        renter_profile/
            controller/
            models/
            view/
            widget/
            data/
        owner_profile/
            controller/
            models/
            view/
            widget/
            data/
        my_vehicles/
            controller/
            models/
            view/
            widget/
        reservation/             # kiralama formu, e-imza, rezervasyon bilgisi
            controller/
            models/
            view/
            widget/
            data/
        settings/                # tema, dil, çıkış
            view/
            widget/
test/
```

Kurallar:
- Her feature kendi `data/` klasöründe `mock_<feature>_data.dart` dosyası tutar. Gerçek ağ isteği YOKTUR; controller'lar veriyi bu dosyalardan okur.
- Birden fazla feature'ın kullandığı model/widget `core/` altına alınır; feature'lar birbirinin `view/` klasörüne doğrudan bağımlı olmaz.
- Modeller `lib/features/<feature>/models/` altında tutulur; ortak modeller (örn. `Vehicle`, `Review`, `AppUser`) `vehicle_list/models/` altında tanımlanır ve diğer feature'lar buradan import eder.

---

## 3. Veri Modelleri (özet — ayrıntı `SKILL.md` içinde)

Tüm modeller `immutable` olur: `const` constructor, `copyWith`, `fromJson`, `toJson`, `==`/`hashCode`.

- `Vehicle` — araç modeli
- `OwnerUser` — araç sahibi kullanıcı modeli
- `RenterUser` — kiracı kullanıcı modeli
- `Review` — yorum modeli (yazar, puan, tarih, metin, iade durumu etiketleri)
- `Reservation` — rezervasyon modeli
- `RentalForm` — kiralama formu modeli (imza durumları dahil)
- `VehicleFilter` — filtre durumu modeli
- `SessionState` — oturum modeli (rol, kullanıcı id, giriş yapıldı mı)

---

## 4. İzin Verilen ve Yasaklı Paketler

Ajan paket eklemeden önce paketin güncelliğini, bakım durumunu ve bilinen güvenlik açıklarını kontrol etmek zorundadır; kontrol edilmeden paket kurulmaz.

**Serbest (onaysız eklenebilir):**
- `flutter` çekirdek kütüphaneleri, `dart:async`, `dart:math`, `dart:convert`
- `flutter_localizations` (SDK ile gelir) ve `intl` (tarih/para biçimleri, ARB çevirileri)
- `shared_preferences` (tema, dil ve oturum kaydı)
- `flutter_test`

**Onay gerektirir (eklemeden önce kullanıcıya sor):**
- `google_fonts`, `flutter_svg`, `cached_network_image`, `table_calendar`, `go_router`, `url_launcher`
- Her biri için eklenme gerekçesi ve yerel alternatifi belirtilir. (Örnek: takvim için yerel alternatif `CalendarDatePicker` veya `GridView` ile özel takvim; imza için yerel alternatif `CustomPaint` + `GestureDetector`.)

**KESİNLİKLE YASAK:**
- Ağır state yönetim paketleri: `provider`, `riverpod`, `flutter_bloc`, `get`/`getx`, `mobx`, `redux`
- Bakımı bırakılmış (discontinued) veya son 2 yıldır güncellenmemiş paketler
- Bilinen güvenlik açığı bulunan paketler ve doğrulanmamış yayıncıdan gelen paketler
- Git/path bağımlılığı olarak dışarıdan çekilen kontrolsüz paketler
- Gerçek ödeme, gerçek kimlik doğrulama, gerçek harita/trafik veya gerçek bildirim (push) servisi paketleri (proje ödev kapsamındadır)

---

## 5. Kırmızı Çizgiler (Kesinlikle Uyulması Gerekenler)

1 - **State Yönetim Standartları:**
Sayfa düzeyinde ağır `setState` kullanımından kesinlikle kaçın. Sadece yerel arayüz durumunu yöneten (örneğin buton animasyonları, imza çizimi, takvimde geçici seçim vb.) `StatefulWidget` kabul edilir. State için `ValueNotifier` + `ValueListenableBuilder` kullanılır. Controller'lar `dispose()` ile temizlenir. Tema, dil ve oturum durumu `ValueNotifier` ile yönetilir.

2 - **UI ve Performans Kuralları:**
- Statik tüm widget'larda `const` zorunludur.
- Renk ve metin stilleri kesinlikle tema dosyalarına yazılacaktır; widget içinde `Color(0xFF...)` veya sabit `TextStyle(fontSize: ...)` yazılmaz (`context.appColors`, `Theme.of(context).colorScheme` ve `Theme.of(context).textTheme` kullanılır).
- Boşluk ve yuvarlak köşe değerleri `AppSpacing` sabitlerinden gelir; sihirli sayı yazılmaz.
- Büyük build metotları yasaktır. 40 satırı geçen `build` metotları özel widget sınıflarına ayrılacaktır.
- Uzun listelerde `ListView.builder` / `SliverList` kullanılır; `Column` içinde sınırsız liste yasaktır.
- Kullanıcıya görünen her metin `AppLocalizations` üzerinden gelir; widget içinde sabit Türkçe/İngilizce metin yazılmaz.

3 - **Asenkron ve BuildContext Güvenliği:**
`await` sonrasında `BuildContext` kullanılmadan önce `if (!context.mounted) return;` kontrolü zorunludur.

4 - **Mimari Disiplin:**
- Tek dosyada tüm kodu, UI + mantık + model toplamak yasaktır.
- Controller katmanı Flutter UI'dan bağımsız (saf Dart + `foundation`) kalır ve birim test edilebilir olur.
- Modeller `immutable` olur (`const` constructor, `copyWith`, `fromJson`, `toJson`).

5 - **Form ve Validasyon Kuralı:**
- Her form `Form` + `GlobalKey<FormState>` ile kurulur; alanlar `TextFormField`/`DropdownButtonFormField` kullanır.
- Tüm doğrulama fonksiyonları `core/validators/app_validators.dart` içinde toplanır ve widget içinde satır içi (inline) doğrulama yazılmaz.
- Hata mesajları yerelleştirilmiştir (TR/EN).
- Geçersiz formda gönderim engellenir ve ilk hatalı alana odaklanılır.
- Kullanıcı girişi bir `AutofillGroup` ve şifre göster/gizle düğmesi ile yapılır.

6 - **Yetki Kuralı:**
- Araç sahibine özel ekranlar (Araçlarım, araç ekleme) yalnızca oturum rolü **Araç Sahibi** ise açılır.
- Bu kontrol UI'da değil, controller'da yapılır; UI yalnızca sonucu gösterir.
- Giriş yapılmamışsa kiralama formu açılmaz, kullanıcı giriş sayfasına yönlendirilir.

7 - **Onay Almadan Yapılmayacaklar:**
Projeye onay almadan harici state paketleri, yeni klasör düzeni değişikliği veya yeni sekme EKLENMEYECEKTİR. Dart'ın ve Flutter'ın yerel çekirdek API'lerini kullanmak esastır.

8 - **Gerçek Veri/Servis Yasağı:**
Ödeme, imza doğrulama, trafik tahmini, bildirim ve sigorta poliçesi indirme akışları **simüle edilir** (mock). Gerçek servise bağlanılmaz; simülasyon olduğu kod yorumlarında ve controller adlarında açıkça belirtilir (örn. `MockTrafficService`).

---

## 6. Geliştirme, Analiz ve Test Komutları

Ajan yaptığı herhangi bir kod değişikliğinden sonra mutlaka aşağıdaki komutların çalıştığını doğrulamalıdır.

* **Bağımlılıkları getirme:**
```bash
flutter pub get
```

* **Yerelleştirme dosyalarını üretme (ARB değiştiğinde):**
```bash
flutter gen-l10n
```

* **Statik kod analizi (0 uyarı ve 0 hata şart):**
```bash
flutter analyze
```

* **Birim ve widget testleri:**
```bash
flutter test
```

* **Projeyi çalıştırma:**
```bash
flutter run
```

**Adım Adım İlerleme:** Büyük işler bölümlere ayrılır; her bölüm bittiğinde analiz ve test çalıştırılır, sonra sonraki bölüme geçilir. Önerilen sıra:
1. Çekirdek: tema, renkler, l10n, controller'lar (tema/dil/oturum), validators
2. Giriş (auth) ve kabuk (shell, alt gezinme)
3. Araç listesi + filtreler
4. Araç detayı + takvim
5. Kiralama formu + e-imza + rezervasyon bilgisi
6. Kiracı profili ve araç sahibi profili
7. Araçlarım (araç sahibi)
8. Gecikme bildirimi simülasyonu, ayarlar, son kontroller

**Testler:** Her controller ve her validator için en az bir birim testi; giriş formu ve kiralama formu için en az bir widget testi yazılır.

**Doğrulama:** Kod yazdıktan sonra kullanıcıya "Şimdi Flutter analiz ile kontrol edebilirsin." şeklinde doğrulama yönergeleri ver.

**Değişiklik Sunumları:** Örneğin 500 satırlık bir dosyada 3 satır değiştiyse tüm dosyayı baştan sona basma; hedef satırları ve diff yapısını göster. Yeni oluşturulan dosyalar tam içerikle verilir.

**Dosya Yolları:** Bahsedilen ve üretilen her dosya için projeye göre yol (örn. `lib/features/auth/view/login_page.dart`) açıkça yazılır.

**Açıklamalar:** Türkçe teknik terimlerin özünü bozmadan net ve doğrudan olacaktır.
