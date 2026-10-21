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
- **Frontend:** *(Öğrenci belirleyecek - örn: HTML5, CSS3/Tailwind, JavaScript)*
- **Backend / Veri Depolama:** *(Öğrenci belirleyecek - örn: LocalStorage, Supabase, Firebase, Node.js)*
- **Ek Kütüphaneler / API'ler:** *(Öğrenci belirleyecek)*

### 6.2. Sayfa Hiyerarşisi ve Akış Planı
- [ ] Sayfa 1: 
- [ ] Sayfa 2: 
- [ ] Sayfa 3: 
- [ ] Sayfa 4: 

### 6.3. Veri Modeli ve Bileşen Tasarımı
*(Kullanılacak veri yapıları, nesneler veya veritabanı tabloları buraya yazılacaktır)*

### 6.4. Proje Takvimi ve Teslim Aşamaları
- **Aşama 1 (Tasarım & Wireframe):** 
- **Aşama 2 (Temel Fonksiyonlar & Arayüz):** 
- **Aşama 3 (Test & İyileştirme):** 
- **Aşama 4 (Final Teslim):** 

### 6.5. Notlar & Karşılaşılan Zorluklar
*(Geliştirme esnasında eklenen notlar ve çözüm yolları)*
