# Focus & Grow — Odaklanma ve Çiçek Büyütme Uygulaması

Bu doküman Flutter projesinde geliştirme yapacak olan Ajan (AntiGravity) yapay zeka ve yazılım geliştiriciler için bağlayıcı bir kılavuzdur. Projede üretilen her kod satırı buradaki kurallara UYMAK ZORUNDADIR. Sayfaların ve özelliklerin ayrıntılı içeriği için `SKILL.md` dosyasına bakılır.

---

## 1. Projenin Kimliği ve Vizyonu

- **Uygulama Adı:** Focus & Grow (kısa imza: **F&G**)
- **Motto:** "Odaklanarak yaşamı daha derinden hissetmek ister misin?"
- **Ne yapar:** Kullanıcı odaklandığı süre boyunca kendine özel bir çiçeği büyütür. Biriken toplam süre çiçeğin boyunu ve olgunluğunu belirler. Kullanıcı istatistiklerini görür, ülkesine ve dünyaya göre topluluk sıralamasında yer alır.
- **Çiçek Kuralı:** Çiçek yalnızca toplam odaklanma süresine göre büyür. Kullanıcı 7 gün uygulamaya girmezse çiçek solar ve başını büker. 30 gün girmezse çiçek tamamen ölür ve kullanıcı tohum aşamasından yeniden başlar.
- **Teknoloji:** Proje **SADECE Flutter ve Dart** ile yapılacaktır. Başka dil veya çatı (native Kotlin/Swift, React Native vb.) kullanılmaz.
- **Hedef Platformlar:** iOS ve Android öncelikli; ardından web ve masaüstü.
- **Flutter SDK:** 3.27.x
- **Dart SDK:** 3.6.0
- **Dil:** Çift dil desteği: Türkçe (varsayılan) ve İngilizce. Kullanıcıya görünen tüm metinler yerelleştirme dosyalarından gelir.
- **Tema ve Dil Durumu:** `ValueNotifier<ThemeMode>` ve `ValueNotifier<Locale>` ile sayfa düzeyinde ağır `setState` olmaksızın anlık tema (aydınlık/karanlık) ve dil geçişi. Seçimler `shared_preferences` ile saklanır.
- **Görsel Stil:** Renk, font, arka plan, köşe, animasyon gibi görsel stil kararları bu dokümanın kapsamı dışındadır; ayrı bir stil dokümanında tanımlanır. Stil dokümanı verilmeden görsel stil uydurulmaz, tema dosyalarında nötr varsayılanlar kullanılır.

---

## 2. Mimari Desen ve Dizin Haritası

Mimari: **Özellik bazlı (feature-first)** + katmanlı ayrım (controller / models / view / widget / data). Kodlar kesinlikle tek bir yerde toplanmayacaktır. Her modül kendi feature klasöründe kodlanacaktır.

```text
lib/
    main.dart
    core/
        constants/
            app_colors.dart
            app_constants.dart        # çiçek aşaması eşikleri, solma/ölüm gün sayıları
        theme/
            app_theme.dart
        extensions/
        l10n/                         # app_tr.arb, app_en.arb
        widgets/
            fg_top_bar.dart
            fg_bottom_bar.dart
            flower_painter.dart       # çiçek illüstrasyonu (CustomPainter)
    features/
        shell/                        # alt bar + IndexedStack
            controller/
            view/
            widget/
        auth/
            controller/
            models/
            data/
            view/                     # landing, register, welcome, login, forgot_password
            widget/
        home/
            controller/
            view/
            widget/
        focus/
            controller/
            models/
            data/
            view/
            widget/
        stats/
            controller/
            models/
            view/
            widget/
        community/
            controller/
            models/
            data/
            view/
            widget/
        profile/
            controller/
            models/
            view/
            widget/
test/
```

- Her feature kendi `data/` klasöründe veri kaynağını tutar (`mock_<feature>_data.dart` veya yerel depo sınıfı).
- Veri erişimi soyut bir **repository arayüzü** üzerinden yapılır. Böylece öğrenci ileride gerçek bir backend seçtiğinde (bkz. Bölüm 6.1) UI ve controller değişmez, yalnızca repository uygulaması değişir.
- `test/` klasörü proje kök dizinindedir.

---

## 3. Kırmızı Çizgiler (Kod Kalite Standartları)

1 - **State Yönetim Standartları:**
Sayfa düzeyinde ağır `setState` kullanımından kesinlikle kaçın. Sadece yerel arayüz durumunu yöneten (örneğin buton ve çiçek animasyonları) `StatefulWidget` kabul edilir. State için `ValueNotifier` + `ValueListenableBuilder` kullanılır. Controller'lar ve `AnimationController`'lar `dispose()` ile temizlenir.

2 - **UI ve Performans Kuralları:**
- Statik tüm widget'larda `const` zorunludur.
- Renk ve metin stilleri kesinlikle tema dosyalarına yazılacaktır; widget içinde `Color(0xFF...)` veya sabit `TextStyle(fontSize: ...)` yazılmaz (`Theme.of(context)` ve `textTheme` kullanılır).
- Kullanıcıya görünen hiçbir metin widget içine sabit yazılmaz; yerelleştirme dosyalarından gelir.
- Büyük build metotları yasaktır. 40 satırı geçen `build` metotları özel widget sınıflarına ayrılacaktır.
- Uzun listelerde `ListView.builder` / `SliverList` kullanılır; `Column` içinde sınırsız liste yasaktır (özellikle "Dünyada İlk 50" listesi).

3 - **Asenkron ve BuildContext Güvenliği:**
`await` sonrasında `BuildContext` kullanılmadan önce `if (!context.mounted) return;` kontrolü zorunludur.

4 - **Mimari Disiplin:**
- Tek dosyada tüm kodu, UI + mantık + model toplamak yasaktır.
- Controller katmanı Flutter UI'dan bağımsız (saf Dart + `foundation`) kalır ve birim test edilebilir olur.
- Modeller `immutable` olur (`const` constructor, `copyWith`, `fromJson`, `toJson`).

5 - **Odaklanma Zamanı Doğruluğu:**
Sayaç, her saniye `+1` toplayarak değil, başlangıç zamanı (`DateTime`) ile şimdiki zaman farkından hesaplanır. Böylece uygulama arka plana alınsa veya kare atlansa bile süre doğru kalır.

6 - **Onay Almadan Yapılmayacaklar:**
Projeye onay almadan harici state paketleri, yeni klasör düzeni değişikliği veya yeni sayfa/sekme EKLENMEYECEKTİR. Dart'ın ve Flutter'ın yerel çekirdek API'lerini kullanmak esastır. Paket kuralları için `SKILL.md` Bölüm 3'e bakılır.

---

## 4. Geliştirme, Analiz ve Test Komutları

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

## 5. Ajanın Çıktı ve Yanıt Verme Standartları

**Açıklamalar:** Türkçe, teknik terimlerin özünü bozmadan net ve doğrudan olacaktır.

**Adım Adım İlerleme:** Büyük işler bölümlere ayrılır (önce `core/` ve tema, sonra auth akışı, sonra ana sayfa ve odaklanma, sonra istatistik, topluluk, profil). Her bölüm bittiğinde analiz ve test çalıştırılır, sonra sonraki bölüme geçilir.

**Değişiklik Sunumları:** Örneğin 500 satırlık bir dosyada 3 satır değiştiyse tüm dosyayı baştan sona basma; hedef satırları ve diff yapısını göster. Yeni oluşturulan dosyalar tam içerikle verilir.

**Dosya Yolları:** Bahsedilen ve üretilen her dosya için mutlaka projeye göre tıklanabilir link ver.

**Doğrulama:** Kod yazdıktan sonra kullanıcıya "Şimdi Flutter analiz ile kontrol edebilirsin." şeklinde doğrulama yönergeleri ver.

---


## 6. Öğrenci Çalışma ve Detay Alanı
> **Not:** Bu alandaki detaylar projeyi üstlenen öğrenci tarafından doldurulacaktır.

### 6.1. Kullanılacak Teknolojiler & Kütüphaneler
- **Frontend:** Flutter 3.27.x ve Dart 3.6.0 (yalnızca Flutter/Dart). Material 3, `ValueNotifier` + `ValueListenableBuilder` ile durum yönetimi, çiçek illüstrasyonu ve grafikler için `CustomPainter`, sayfa geçişleri için `PageRouteBuilder`, TR/EN için `flutter_localizations` + `gen-l10n` (ARB dosyaları).
- **Backend / Veri Depolama:** Bu aşamada gerçek backend yoktur. Oturum, tema, dil ve odaklanma kayıtları `shared_preferences` ile cihazda saklanır. Topluluk verisi (ülke sıralaması, dünya ilk 50, kişi profilleri) her feature'ın `data/` klasöründeki `mock_<feature>_data.dart` dosyalarından gelir. Tüm veri erişimi soyut repository arayüzleri üzerinden yapılır; ileride gerçek bir backend (örn. Firebase veya Supabase) seçilirse yalnızca repository uygulaması değişir.
- **Ek Kütüphaneler / API'ler:**
  - Onaysız: `intl` (süre ve tarih biçimleri), `shared_preferences`, `flutter_localizations`, `flutter_test`
  - Stil dokümanına bağlı: `google_fonts` (font seçimi stil dokümanında yapılır)
  - Onayla eklenebilir: `google_sign_in` (Google ile giriş), `image_picker` (profil resmi seçme), `fl_chart` (grafik; yoksa `CustomPainter`), `wakelock_plus` (odaklanırken ekranı açık tutma)
  - Google OAuth yapılandırması hazır olana kadar giriş butonu mock giriş servisine bağlıdır.

### 6.2. Sayfa Hiyerarşisi ve Akış Planı
- [ ] Sayfa 1: **Giriş Akışı** (alt bar yok, üst barda yalnızca mod ve dil)
  - Giriş Sayfası (Landing): çiçek logosu, ad, motto, Register, "Giriş Yap" bağlantısı, Google butonu
  - Kayıt Ol: isim, e-posta, şifre, şifre doğrulama, yaş, ülke, Kaydol (şifre kuralları ve hata durumları)
  - Karşılama: "Merhaba {isim}" + ilerle
  - Giriş Yap ve Şifremi Unuttum (Kod Gönder)
- [ ] Sayfa 2: **Ana Sayfa ve Odaklanma** (alt bar yalnızca Ana Sayfada)
  - Ana Sayfa: çiçeğin şu anki hali, "Odaklanmaya başla" butonu, solma (7 gün) ve ölme (30 gün) durumları
  - Odaklanma Sayfası: tam ekran çiçek, sayaç, tek "Durdur" butonu, diğer her şey kilitli
- [ ] Sayfa 3: **İstatistikler**: bugünkü süre, haftalık grafik ve tablo (son 7 gün), aylık grafik ve tablo, genel toplam
- [ ] Sayfa 4: **Topluluk ve Profil**
  - Topluluk: Ülkeler İlk 10, Dünyada İlk 50, ülkeye göre filtre (alttan modal)
  - Kişi Profil Sayfası: profil bilgileri, çiçek, günlük/haftalık/yıllık istatistik (salt okunur)
  - Profil & Ayarlar (kendi profili): resim, isim, yaş, çiçek, istatistikler, İstatistikleri Sil, Hesabı Sil, toplulukta gösterme kutucuğu
- **Akış:** Giriş Akışı → Ana Uygulama (alt bar: Anasayfa, İstatistikler, Topluluk, Profil & Ayarlar). Ana Sayfa → Odaklanma → Durdur → Ana Sayfa. Topluluk → Kişi Profil Sayfası.

### 6.3. Veri Modeli ve Bileşen Tasarımı
Tüm modeller `immutable`'dır (`const` constructor, `copyWith`, `fromJson`, `toJson`). Günlük, haftalık, aylık ve toplam süreler ayrıca saklanmaz, odaklanma kayıtlarından türetilir.

```text
UserProfile
  id, name, email, age, country, photoPath/photoUrl,
  showInCommunity (bool), createdAt, lastActiveAt

FocusSession
  id, userId, startedAt, durationSeconds, day (yyyy-MM-dd)

FlowerState  (kayıtlardan hesaplanır, saklanmaz)
  stage (seed, sprout, sapling, leafy, bud, bloom, mature),
  status (healthy, wilted, dead),
  totalSeconds, lastActiveAt

DailyStat / PeriodStat
  label (gün veya ay), totalSeconds

CommunityEntry
  userId, name, age, country, photoUrl, streakDays, totalSeconds

CountryRank
  country, totalSeconds
```

**Kural sınıfları (saf Dart, birim testli):**
- `PasswordValidator`: en az 8 karakter, 1 büyük harf, 1 küçük harf, 1 sembol, şifre eşleşmesi
- `FlowerGrowthCalculator`: toplam süreden aşama; son girişten solma (7 gün) ve ölme (30 gün) durumu
- `StatsCalculator`: günlük, haftalık (son 7 gün), aylık ve genel toplam
- `CommunityRanker`: ülke bazlı İlk 10, dünya İlk 50, ülke filtresi, `showInCommunity` kapalı kullanıcıları dışlama

**Başlıca bileşenler:** `FgTopBar`, `FgBottomBar`, `FlowerPainter` (çiçek aşamaları ve solgun hali), `FocusTimerDisplay`, `StatsChart` (haftalık ve aylık), `StatsTable`, `RankListTile`, `CountryFilterSheet`.

**Yerel saklama anahtarları (`shared_preferences`):** `themeMode`, `locale`, `currentUser`, `focusSessions`.

### 6.4. Proje Takvimi ve Teslim Aşamaları
- **Aşama 1 (Tasarım & Wireframe):** Stil dokümanının hazırlanması ve fontun seçilmesi; tüm sayfaların wireframe'i; çiçeğin büyüme aşamaları, solgun ve ölü hallerinin tasarımı; veri modelinin ve klasör yapısının netleştirilmesi.
- **Aşama 2 (Temel Fonksiyonlar & Arayüz):** `core/` (tema, l10n, ortak widget'lar); giriş akışı (kayıt doğrulaması dahil); ana sayfa ve odaklanma sayfası (sayaç, kilit); istatistikler; topluluk ve profil sayfaları (mock veriyle). Her bölüm sonunda `flutter analyze` ve `flutter test` çalıştırılır.
- **Aşama 3 (Test & İyileştirme):** Controller birim testleri ve widget testleri; 0 uyarı / 0 hata analiz; aydınlık/karanlık mod ve TR/EN kontrolü; küçük ve büyük ekran uyumu; performans ve `dispose()` kontrolü; hata düzeltmeleri.
- **Aşama 4 (Final Teslim):** Son kontroller, temiz proje, çalışır demo, teslim dosyaları (`project.md`, `SKILL.md`, stil dokümanı) ve kısa kullanım anlatımı.

### 6.5. Notlar & Karşılaşılan Zorluklar
*(Geliştirme esnasında eklenen notlar ve çözüm yolları aşağıya yazılır.)*

**Başlangıç notları ve karar bekleyen konular:**
- Çiçek ölünce (30 gün) yalnızca çiçeğin mi tohumdan başlayacağı, yoksa toplam istatistiklerin de mi sıfırlanacağı netleştirilecek.
- Odaklanma sırasında uygulama arka plana alınırsa sayacın devam edip etmeyeceği belirlenecek. Süre başlangıç zamanından hesaplandığı için sayaç doğru kalır.
- Odaklanma sayfasında geri tuşunun engellenmesi `PopScope` ile çözülecek; işletim sisteminin kendi çıkış hareketleri tamamen engellenemeyebilir.
- Gerçek Google OAuth yapılandırması öğrenci tarafından yapılacak; o zamana kadar mock giriş kullanılır.
- Gerçek topluluk sıralaması için bir backend gerekir. Şimdilik sahte veriyle çalışılır; backend seçimi sonra yapılacak.

### 6.5. Notlar & Karşılaşılan Zorluklar
/Users/d1-20/Documents/GitHub/SoftITo/21ekim/macos/Runner/MainFlutterWindow.swift:63:32: error: missing argument label 'arguments:' in call

fontları akatarmaktan zorlandı. 

ekran büyüdükten sonra tekrar butona basmak gerkiyordu

profilde profilini kısmını profilimi yaptım. 
