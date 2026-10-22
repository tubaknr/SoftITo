# Alışkanlık Takip Uygulaması

Bu doküman Flutter projesinde geliştirme yapacak olan Ajan (AntiGravity) yapay zeka ve yazılım geliştiriciler için bağlayıcı bir kılavuzdur. Projede üretilen her kod satırı buradaki kurallara UYMAK ZORUNDADIR.

> **Kapsam notu:** Bu doküman yalnızca mimari, teknoloji ve kod kalitesi kurallarını içerir. Renk, gradyan, font, maskot çizimi, animasyon detayı gibi **tüm görsel tasarım kararları ayrı bir `style.md` dosyasındadır**. `style.md` verilmeden hiçbir renk, gradyan, font veya maskot görseli üretilmez; yer tutucu (placeholder) kullanılır. Ekranların işlevi ve iş kuralları için `SKILL.md` dosyasına bak.

---

## 1. Projenin Kimliği
proje ismi: Small Tick & Big Grow. Small Tick kısmı küçük ve ince font ile, Big Grow kısmı kalın ve daha iri font ile alt alta yazılır. 
logo: penguenlidir. penguen tatlı ve sıcak bir şekilde gülümser. 

- **Uygulama Türü:** Alışkanlık takip uygulaması (günlük alışkanlık, seri, rozet, duygu notu, analiz).
- **Ne yapar:** Kullanıcı kayıt olur, alışkanlıklarını tanımlar, her gün tamamlar; seriler ve rozetlerle motive olur; tamamlama sonrası isteğe bağlı duygu ve not girer; takvim, grafik ve analizlerle ilerlemesini izler; bildirimlerle desteklenir.
- **Marka Mottosu:** "Kritik adımlar, büyük hedeflerin ruhudur." (TR/EN karşılığı l10n dosyalarında tutulur.)
- **Hedef Platformlar:** iOS ve Android öncelikli; ardından web ve masaüstü.
- **Flutter SDK:** 3.27.x
- **Dart SDK:** 3.6.0
- **Dil Desteği:** Türkçe (varsayılan) ve İngilizce. Arayüzde sabit metin yazılmaz, tüm metinler yerelleştirme dosyalarından gelir.
- **Tema Modu:** Aydınlık / Karanlık mod desteği zorunludur. Tema modu `ValueNotifier<ThemeMode>` ile yönetilir; sayfa düzeyinde `setState` olmadan anlık geçiş yapar. Seçim yerel olarak saklanır.
- **Dil Durumu:** Seçili dil `ValueNotifier<Locale>` ile yönetilir; anlık değişir ve yerel olarak saklanır.

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
        shell/                 # Bottom navigation iskeleti ve ortak üst çubuk
            controller/
            view/
            widget/
        onboarding/            # Karşılama, kayıt, kayıt sonrası ekran
        auth/                  # Giriş, şifremi unuttum, Google OAuth
        home/                  # Bugünün alışkanlıkları
        habits/                # Tüm alışkanlıklar, ekle/düzenle/sil
        calendar/
        analytics/
        profile/
        reflection/            # Duygu seçimi ve farkındalık notları
        badges/                # Seri ve rozet mantığı
        notifications/
test/                          # Birim ve widget testleri (feature yapısını yansıtır)
```

Her feature'ın `controller`, `models`, `view`, `widget` klasörleri vardır; gerektiğinde `data/` klasöründe `mock_<feature>_data.dart` veya repository uygulaması tutulur.

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
