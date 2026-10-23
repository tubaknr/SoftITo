# Alışkanlık Takip Uygulaması

Bu doküman Flutter projesinde geliştirme yapacak olan Ajan (AntiGravity) yapay zeka ve yazılım geliştiriciler için bağlayıcı bir kılavuzdur. Projede üretilen her kod satırı buradaki kurallara UYMAK ZORUNDADIR.

> **Kapsam notu:** Bu doküman yalnızca mimari, teknoloji ve kod kalitesi kurallarını içerir. Renk, gradyan, font, logo ve maskot çizimi, animasyon detayı gibi **tüm görsel tasarım kararları ayrı bir `style.md` dosyasındadır**. `style.md` verilmeden hiçbir renk, gradyan, font veya maskot görseli üretilmez; yer tutucu (placeholder) kullanılır. Ekranların işlevi ve iş kuralları için `SKILL.md` dosyasına bak.

> **Çalışma takibi:** Güncel görev durumu `progress.md` dosyasındadır; biten işler `done.md`'ye taşınır. Ajan her oturuma `project.md` ve `progress.md` okuyarak başlar (bkz. Bölüm 7).

---

## 1. Projenin Kimliği

- **Proje Adı:** Small Tick & Big Grow (iki satırlı yerleşim; tipografi ve logo ayrıntıları `style.md`'dedir).
- **Uygulama Türü:** Alışkanlık takip uygulaması (günlük alışkanlık, seri, rozet, duygu notu, analiz).
- **Ne yapar:** Kullanıcı kayıt olur, alışkanlıklarını tanımlar, her gün tamamlar; seriler ve rozetlerle motive olur; tamamlama sonrası isteğe bağlı duygu ve not girer; takvim, grafik ve analizlerle ilerlemesini izler; bildirimlerle desteklenir.
- **Marka Mottosu:** "Küçük adımlar, büyük hedeflerin ruhudur." (TR/EN karşılığı l10n dosyalarında tutulur.)
- **Hedef Platformlar:** iOS ve Android öncelikli; ardından web ve masaüstü.
- **Flutter SDK:** 3.27.x
- **Dart SDK:** 3.6.0
- **Dil Desteği:** Türkçe (varsayılan) ve İngilizce. Arayüzde sabit metin yazılmaz, tüm metinler yerelleştirme dosyalarından gelir. Her yeni metin TR ve EN olarak birlikte eklenir.
- **Tema Modu:** Aydınlık / Karanlık mod desteği zorunludur. Tema modu `ValueNotifier<ThemeMode>` ile yönetilir; sayfa düzeyinde `setState` olmadan anlık geçiş yapar. Seçim yerel olarak saklanır.
- **Dil Durumu:** Seçili dil `ValueNotifier<Locale>` ile yönetilir; anlık değişir ve yerel olarak saklanır.
- **Ayarlar Kontrolleri:** Dil seçimi, tema modu, verileri yedekleme ve çıkış yapma kontrolleri YALNIZCA Ayarlar sayfasındadır (Bölüm 8). Üst çubukta ve profil sayfasında bulunmaz.

---

## 2. Mimari Yapı: Özellik Bazlı (feature-first)

Kodlar kesinlikle tek bir yerde toplanmayacaktır. Her modül kendi feature klasöründe kodlanacaktır. Her feature içinde katmanlı ayrım uygulanır: `controller` / `models` / `view` / `widget` (veri gerektiren feature'larda ek olarak `data`).

```text
lib/
    main.dart                  # Sadece uygulama başlatma, tema ve dil bağlama
    core/
        constants/
        theme/                 # Tema tanımları (içerik style.md'den gelir)
        extensions/
        l10n/                  # TR/EN metinler
        widgets/               # Ortak, özelliğe bağlı olmayan widget'lar
        services/              # Depolama, bildirim vb. soyut arayüzler
    features/
        shell/                 # Bottom navigation iskeleti ve ortak üst çubuk (dil/tema butonu içermez)
            controller/
            view/
            widget/
        onboarding/            # Karşılama, kayıt, kayıt sonrası ekran
        auth/                  # Giriş, şifremi unuttum, Google OAuth
        home/                  # Bugünün alışkanlıkları
        habits/                # Tüm alışkanlıklar, ekle/düzenle/sil
        calendar/
        analytics/
        profile/               # Kullanıcı bilgileri; ayarlar çark butonu burada, ayar butonları burada DEĞİL
        reflection/            # Duygu seçimi ve farkındalık notları
        badges/                # Seri ve rozet mantığı
        notifications/
        settings/              # Ayarlar sayfası: dil, tema, verileri yedekle, çıkış yap
            controller/
            view/
            widget/
test/                          # Birim ve widget testleri (feature yapısını yansıtır)
```

Her feature'ın `controller`, `models`, `view`, `widget` klasörleri vardır; gerektiğinde `data/` klasöründe `mock_<feature>_data.dart` veya repository uygulaması tutulur.

**Yeni özellik klasörü kuralı:** Yeni bir özellik mevcut bir feature'ın doğal parçası değilse kendi `features/<ad>/` klasörünü alır ve yukarıdaki katman yapısını birebir uygular. Mevcut bir feature'ın parçasıysa o feature'ın içine eklenir. Her iki durumda da klasör düzeni değişikliği ve yeni sekme için onay gerekir (Bölüm 3, madde 6).

---

## 3. Kırmızı Çizgiler (Kod Kalite Standartları)

1 - **State Yönetim Standartları:**
Sayfa düzeyinde ağır `setState` kullanımından kesinlikle kaçın. Sadece yerel arayüz durumunu yöneten (örneğin buton animasyonu, tek bir kutlama animasyonu vb.) `StatefulWidget` kabul edilir. State için `ValueNotifier` + `ValueListenableBuilder` kullanılır. Controller'lar `dispose()` ile temizlenir.

2 - **UI ve Performans Kuralları:**
- Statik tüm widget'larda `const` zorunludur.
- Renk ve metin stilleri kesinlikle tema dosyalarına yazılacaktır; widget içinde `Color(0xFF...)` veya sabit `TextStyle(fontSize: ...)` yazılmaz. `Theme.of(context)` ve tema uzantıları kullanılır.
- Kullanıcıya görünen sabit metin widget içine yazılmaz; l10n üzerinden alınır.
- Büyük build metotları yasaktır. 40 satırı geçen `build` metotları özel widget sınıflarına ayrılacaktır.
- Uzun listelerde `ListView.builder` / `SliverList` kullanılır; `Column` içinde sınırsız liste yasaktır.

3 - **Asenkron ve BuildContext Güvenliği:**
`await` sonrasında `BuildContext` kullanılmadan önce `if (!context.mounted) return;` kontrolü zorunludur.

4 - **Mimari Disiplin:**
- Tek dosyada tüm kodu (UI + mantık + model) toplamak yasaktır.
- Controller katmanı Flutter UI'dan bağımsız (saf Dart + `foundation`) kalır ve birim test edilebilir olur.
- Modeller `immutable` olur (`const` constructor, `copyWith`, `fromJson`, `toJson`).
- Dış dünyaya açılan işler (kimlik doğrulama, depolama, bildirim) soyut bir arayüz (repository/service) arkasında tutulur; controller somut uygulamayı değil arayüzü bilir.

5 - **Veri ve Zaman Güvenliği:**
Seri, rozet ve tamamlama hesapları saf Dart fonksiyonlarıdır; `DateTime.now()` doğrudan çağrılmaz, enjekte edilebilir bir saat/tarih sağlayıcıdan okunur (test edilebilirlik için). Gün karşılaştırmaları yalnızca tarih (saat bileşeni atılmış) üzerinden yapılır.

6 - **Onay Almadan Yapılmayacaklar:**
Projeye onay almadan harici paketler, yeni klasör düzeni değişikliği veya yeni sekme EKLENMEYECEKTİR. Dart'ın ve Flutter'ın yerel çekirdek API'lerini kullanmak esastır.

7 - **Geriye Dönük Uyumluluk:**
Yeni özellik, mevcut çalışan davranışı bozamaz. Mevcut bir modelin alanı değişiyorsa `fromJson` eski kayıtları okumaya devam eder (yeni alanlara varsayılan değer verilir) ve yerel olarak saklanan eski veriler kaybolmaz. Mevcut testler yeni özellik sonrasında da geçmek zorundadır.

---

## 4. İzin Verilen ve Yasaklı Paketler

Proje "sadece Flutter ve Dart" ilkesiyle geliştirilir. Ajan paket eklemeden önce paketin güncelliğini, bakım durumunu ve bilinen güvenlik açıklarını kontrol etmek zorundadır; kontrol edilmeden paket kurulmaz.

**Serbest (onaysız eklenebilir):**
- `flutter` çekirdek kütüphaneleri, `flutter_localizations`, `dart:async`, `dart:math`, `dart:convert`
- `intl` (tarih biçimleri ve yerelleştirme), `shared_preferences` (yerel kayıt), `flutter_test`

**Onay gerektirir (eklemeden önce kullanıcıya sor, gerekçe ve yerel alternatif belirt):**
- `google_sign_in` (Google OAuth)
- `flutter_local_notifications` (bildirimler)
- `image_picker` (profil resmi)
- Diğer tüm paketler

**KESİNLİKLE YASAK:**
- Ağır state yönetim paketleri: `provider`, `riverpod`, `flutter_bloc`, `get`/`getx`, `mobx`, `redux`
- Grafik ve takvim paketleri: grafikler `CustomPainter` ile, takvim yerel widget'larla yazılır
- Bakımı bırakılmış (discontinued) veya son 2 yıldır güncellenmemiş paketler
- Bilinen güvenlik açığı bulunan veya doğrulanmamış yayıncıdan gelen paketler
- Git/path bağımlılığı olarak dışarıdan çekilen kontrolsüz paketler

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

* **Projeyi çalıştırma:**
```bash
flutter run
```

---

## 6. Ajanın Çıktı ve Yanıt Verme Standartları

**Açıklamalar:** Türkçe teknik terimlerin özünü bozmadan net ve doğrudan olacaktır.

**Adım Adım İlerleme:** Büyük işler bölümlere ayrılır; her bölüm bittiğinde analiz ve test çalıştırılır, sonra sonraki bölüme geçilir.

**Değişiklik Sunumları:** Örneğin 500 satırlık bir dosyada 3 satır değiştiyse tüm dosyayı baştan sona basma; hedef satırları ve diff yapısını göster. Yeni oluşturulan dosyalar tam içerikle verilir.

**Dosya Yolları:** Bahsedilen ve üretilen her dosya için projeye göre tıklanabilir yol ver.

**Doğrulama:** Kod yazdıktan sonra kullanıcıya "Şimdi Flutter analiz ile kontrol edebilirsin." şeklinde doğrulama yönergeleri ver.

**Belirsizlik:** `SKILL.md` veya bu dokümanda tanımlı olmayan bir karar gerekiyorsa tahmin yürütme; kısa bir soru sor ya da varsayımı açıkça belirt.

---

## 7. Yeni Özellik Ekleme Protokolü ve Çalışma Takibi

Proje ilk sürümüyle çalışır durumdadır; bundan sonraki her iş mevcut kod tabanı üzerine eklemedir. Ajan şu sırayı izler:

1. **Oturum başlangıcı:** `project.md` ve `progress.md` okunur. `progress.md` içindeki "Şu An Üzerinde Çalışılan" ve "Notlar" bölümleri bir önceki oturumdan devralınır.
2. **Taban çizgisi:** Yeni özelliğe başlamadan önce `flutter analyze` ve `flutter test` çalıştırılır; mevcut durum (hata/uyarı varsa) `progress.md` → "Bilinen Hatalar"a yazılır. Yeni özellik, bu hataları gizleyerek ilerlemez.
3. **Plan:** Özellik; etkilenen feature'lar, yeni/değişen dosyalar, model değişiklikleri, gerekirse yeni paket ihtiyacı ve l10n anahtarlarıyla kısa bir planla kullanıcıya sunulur. Onay gerektiren maddeler (paket, klasör düzeni, yeni sekme) `progress.md` → "Engeller / Bekleyen Kararlar"a yazılır ve onay gelmeden uygulanmaz.
4. **Uygulama:** Özellik, kendi branch'inde (`feature/<ad>`) ve küçük bölümler halinde geliştirilir. Her bölümden sonra `flutter analyze` (0 uyarı, 0 hata) ve `flutter test` çalıştırılır.
5. **Test:** Yeni controller, model ve saf Dart hesapları için birim testi; yeni ekranlar için en az bir widget testi yazılır. Testler `test/` altında feature yapısını yansıtır.
6. **Görsel kararlar:** Yeni özellik görsel bir şey gerektiriyorsa `style.md`'de karşılığı aranır; yoksa yer tutucu kullanılır ve eksik karar `progress.md` → "Engeller / Bekleyen Kararlar"a yazılır.
7. **Dokümantasyon:** Özellik bittiğinde ilgili madde `progress.md`'den `done.md`'ye taşınır. Özellik mimariyi, paket listesini veya kuralları değiştirdiyse bu doküman (`project.md`) onayla birlikte güncellenir; `progress.md` içindeki "Son güncelleme" tarihi her görevde yenilenir.
8. **Oturum sonu:** Yarım kalan iş, bir sonraki oturumun bilmesi gereken kritik bilgi ve sıradaki adım `progress.md` → "Notlar"a yazılır.

---

## 8. Ayarlar Özelliği (`features/settings`)

Bu bölüm, ilk sürümden sonra eklenen Ayarlar özelliğinin bağlayıcı gereksinimleridir. Kullanıcı yeni `settings` feature klasörünü bu özellik için onaylamıştır (2026-10-23); bu onay başka klasör, paket veya sekme için geçerli değildir. Ayarlar yeni bir sekme DEĞİLDİR; profil sayfasından açılan ayrı bir sayfadır, bottom navigation'a öğe eklenmez.

### 8.1 Profil sayfası
- Kullanıcı adının sağına, **sağa dayalı** bir ayarlar çark butonu (`IconButton`, Flutter çekirdek `Icons` seti; harici ikon paketi yok) eklenir. İsim ve buton aynı satırda `Row` içinde durur; isim `Expanded` ile alanı alır, uzun isimde `TextOverflow.ellipsis` ile taşma önlenir, buton her zaman görünür kalır.
- Butonun renk, boyut ve vurgu özellikleri yalnızca tema dosyalarından (`Theme.of(context)` ve tema uzantıları) gelir; widget içine `Color(0xFF...)` yazılmaz. Görünüm, mevcut ekranlardaki ikon butonları ve kartlarla tutarlı olur; yeni renk veya font icat edilmez. `style.md`'de bu butona dair karar varsa o uygulanır, yoksa mevcut tema değerleri kullanılır.
- Buton l10n üzerinden `tooltip` ve erişilebilirlik etiketi (`Semantics`) taşır; dokunma alanı en az 48x48 olur.
- Dokunulunca `SettingsView` sayfası `Navigator.push` ile açılır; geri dönüş mevcut sayfa geçiş davranışıyla aynıdır.
- Profil sayfasından **kaldırılır**: dil seçimi, karanlık tema, verileri yedekle ve çıkış yap butonları. Profilin geri kalan içeriği ve düzeni değişmez.

### 8.2 Üst çubuk (shell)
- Ortak üst çubuktaki **TR/EN dil butonu** ve **aydınlık/karanlık mod butonu kaldırılır**. Üst çubuğun diğer öğeleri ve yerleşimi aynen kalır; boşalan alan düzeni bozmaz.

### 8.3 Ayarlar sayfası
- Sayfada dört işlev bulunur: **Dil**, **Tema modu**, **Verileri yedekle**, **Çıkış yap**.
- Bu işlevler **taşınır, yeniden yazılmaz**: mevcut davranış birebir korunur.
  - Dil ve tema, `main.dart`'ta bağlı olan mevcut `ValueNotifier<Locale>` ve `ValueNotifier<ThemeMode>` örneklerini kullanır; yeni notifier üretilmez. Değişim `setState` olmadan anlık yansır ve mevcut yerel kayıt yolu ile saklanır.
  - Verileri yedekle ve çıkış yap, mevcut soyut servis/repository arayüzü üzerinden çalışır; controller somut uygulamayı bilmez. Çıkış sonrası yönlendirme mevcut akışla aynıdır.
- Mevcut l10n anahtarları yeniden kullanılır (kopyalanmaz); yeni metinler (sayfa başlığı, çark tooltip'i, varsa bölüm başlıkları) TR ve EN birlikte eklenir.
- Düzen, ilgili işlevleri gruplandıran liste/kart yapısıdır (örneğin görünüm: dil ve tema; veri: yedekle; hesap: çıkış yap). Kullanılan tüm kart, satır ve ikon görünümleri tema ve mevcut `core/widgets` bileşenleriyle uyumlu olur; ortak olanlar `core/widgets`'a, yalnızca ayarlara özel olanlar `settings/widget`'a konur.
- Aydınlık ve karanlık modda ve TR/EN dillerinde taşma veya okunabilirlik sorunu olmamalıdır.

### 8.4 Katman ve dosya yapısı
- `features/settings/controller/` — `SettingsController`: saf Dart, UI'dan bağımsız; tema/dil değişimini notifier'lara ve kalıcı depoya iletir, yedekleme ve çıkışı soyut arayüze devreder.
- `features/settings/view/` — `SettingsView`: yalnızca sayfa iskeleti; 40 satırı geçen `build` yasağı geçerlidir.
- `features/settings/widget/` — ayar satırı, bölüm başlığı gibi özel widget sınıfları.
- Yeni paket gerekmez. Gerektiği düşünülürse Bölüm 4 kuralı işler: önce kullanıcıya sorulur.

### 8.5 Testler ve kabul kriterleri
- `test/features/settings/` altında controller birim testleri: tema değişimi, dil değişimi, ilgili notifier'ın güncellenmesi ve kaydedilmesi; yedekleme ve çıkışın soyut arayüzü çağırması.
- Widget testleri: profilde çark butonu vardır ve dokunulunca ayarlar açılır; profilde dil, tema, yedekle ve çıkış yap kontrolleri yoktur; üst çubukta dil ve tema butonu yoktur; ayarlar sayfasında dört işlev vardır.
- Kabul listesi: (1) çark adın sağında ve sağa dayalı, (2) profilde dört buton yok, (3) üst çubukta iki buton yok, (4) dört işlev ayarlarda ve önceki gibi çalışıyor, (5) iki temada ve iki dilde düzgün görünüyor, (6) sabit renk/metin yok, (7) `flutter analyze` 0 uyarı 0 hata, (8) `flutter test` tamamı geçiyor, (9) taşıma sonrası kullanılmayan kod ve l10n anahtarı kalmadı.
