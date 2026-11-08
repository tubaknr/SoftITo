# skill.md — Kodlama Kuralları (Sigara Bırakma Uygulaması)

> Bu dosya yapay zeka ajanının **NASIL** çalışacağını anlatır. Projenin **NE** olduğu [project.md](project.md) dosyasındadır.
> Önce project.md ve skill.md dosyalarını baştan sona oku. Sonra project.md bölüm 7'deki adımları **sırayla** uygula.

---

## 1. Çalışma Şekli

1. Bir seferde **tek adım** yap. Adım bitmeden sonrakine geçme.
2. Basit tut. Karmaşıklaştırma. İstenmeyen özellik, ekstra ekran, ekstra paket ekleme.
3. Her dosya işlemini (oluşturma, değiştirme, silme) ve her komutu **hemen** [DONE.md](DONE.md) dosyasına kaydet (bölüm 9).
4. Emin olmadığın bir karar varsa tahmin etme, kullanıcıya kısa bir soru sor.

---

## 2. Platform ve Kapsam Dışı

- **Platform:** Sadece Flutter (mobil). Dil: Dart.
- **Veri:** Backend yoktur. Tüm veri cihazda **JSON** olarak yerel saklanır.
- **Kullanma:** Firebase, Supabase, Node.js, REST API, kullanıcı girişi, bulut yedek. Bu projede böyle bir kurgu yoktur.
- **Kullanma:** Gereksiz mikro-paketler ve aşırı parçalanmış dosya yapıları. 25 dosya sınırı bunun için vardır.

---

## 3. Dosya ve Klasör Kuralları

| Ne | Nerede |
|---|---|
| Tüm modeller | `lib/models/` |
| Tüm servisler | `lib/services/` |
| Tüm ekranlar | `lib/screens/` |
| Tüm widget'lar | `lib/widgets/` |
| Tüm özellik mantıkları (controller) | `lib/features/<özellik>/` |
| Renk ve metin stilleri | `lib/theme/app_theme.dart` |

- `lib/` altında **en fazla 25 Dart dosyası** olur. Planlanan liste project.md bölüm 4'tedir, ona uy.
- Yeni dosya gerekirse önce mevcut dosyaya sığdırmayı dene. Sığmıyorsa kullanıcıdan onay iste.
- Küçük yardımcı sınıflar ve ilişkili alt modeller, mantıksal olarak ait oldukları dosyanın içinde toplanır (ör. `AppSettings` → `user_profile.dart`).

---

## 4. Kural 1: Ekranlar 200 Satırın Altında, Formlar Bağımsız Sayfalarda

- **Hiçbir ekran dosyası 200 satırı aşamaz.**
- SOLID Tek Sorumluluk Prensibi (SRP) gereği 600+ satırlık şişkin form yapıları yazılmaz.
- Form akışları bağımsız sayfalarda tutulur (`onboarding_date_screen`, `onboarding_cost_screen`, `diary_entry_screen`).
- Ekran büyüyorsa parçaları `widgets/` altındaki widget'lara taşı.
- Her ekran dosyasını bitirince satır sayısını kontrol et ve [DONE.md](DONE.md) dosyasına yaz.

---

## 5. Dil ve Yorum Kuralları

- **Kod İngilizce:** sınıf, fonksiyon, değişken, dosya adları İngilizce. Uygulama içi kullanıcı metinleri Türkçe.
- **Tüm yorum satırları Türkçe.**
- **Her yorum satırı en fazla 50 karakter** olur (`// ` dahil, girinti hariç). Uzun açıklamayı birkaç satıra böl.
- **Her scriptin en üstünde** şu bilgileri anlatan Türkçe başlık bloğu olur: dosya ne iş yapar, ne işe yarar, nasıl çalışır, hangi SOLID prensibini uygular.

Başlık bloğu şablonu:

```dart
// ========================================
// DOSYA: storage_service.dart
// NE İŞE YARAR: Veriyi cihazda JSON olarak
// saklar ve geri okur.
// NASIL ÇALIŞIR: Nesneyi JSON metnine çevirip
// SharedPreferences içine yazar.
// SOLID: SRP - bu dosya sadece saklama yapar.
// ========================================
```

- Önemli sınıfların ve fonksiyonların üstüne de kısa Türkçe açıklama yaz (ne yapar, neden var, nasıl çalışır).
- Bariz satırlara (`i++` gibi) yorum yazma. Yorum, **neden** ve **nasıl** sorularını cevaplasın.

---

## 6. SOLID Uygulama Rehberi

SOLID'e tam uy. Bir prensip uygulanan her yerde, **nasıl uygulandığını** anlatan Türkçe yorum satırı bırak.

| Prensip | Bu projede nasıl uygulanır |
|---|---|
| **S** (Tek Sorumluluk) | Model sadece veri tutar. Service sadece saklar/bildirim planlar/hesaplar. Controller sadece durumu yönetir. Ekran sadece arayüz çizer. |
| **O** (Açık/Kapalı) | Sağlık kilometre taşları bir listedir. Yeni madde sadece listeye eklenir, hesap ve ekran kodu değişmez. |
| **L** (Liskov) | `StorageService` ve `NotificationService` soyut sınıflardır. Testlerdeki sahte (fake) gerçeklemeler gerçeğinin yerine sorunsuz geçer. |
| **I** (Arayüz Ayrımı) | Soyut sınıflar küçük tutulur (ör. depo: `readJson`, `writeJson`, `remove`). Kullanılmayan metot zorlanmaz. |
| **D** (Bağımlılığı Tersine Çevirme) | Controller'lar somut sınıfa değil soyut arayüze bağlıdır. Bağımlılıklar **constructor ile** verilir (`main.dart` içinde birleştirilir). |

Yorum örnekleri (en fazla 50 karakter):

```dart
// SRP: Sadece JSON okuma/yazma yapar.
// OCP: Yeni kilometre taşı sadece listeye girer.
// LSP: Sahte depo gerçeğinin yerine geçebilir.
// ISP: Arayüz küçük, sadece 3 metot içerir.
// DIP: Sınıf soyut arayüze bağımlıdır.
```

---

## 7. Kod Kalite Standartları (Kırmızı Çizgiler)

**1 — State yönetimi**
- Sayfa düzeyinde ağır `setState` kullanımından **kesinlikle kaçın**.
- Sadece yerel arayüz durumunu yöneten `StatefulWidget` kabul edilir (buton animasyonu, `AnimationController`, form `TextEditingController` gibi).
- Paylaşılan durum `ChangeNotifier` controller'larıyla tutulur. Arayüz `ListenableBuilder` / `ValueListenableBuilder` ile dinler.
- Provider, Riverpod, BLoC, GetX gibi paketler **kullanılmaz**.

**2 — UI ve performans**
- Statik tüm widget'larda `const` **zorunludur**.
- Renk ve metin stilleri **kesinlikle** tema dosyasına (`app_theme.dart`) yazılır. Ekranlarda sabit renk kodu (`Color(0xFF...)`) veya `TextStyle(...)` tanımı yazılmaz.
- Büyük `build` metodları **yasaktır**. **40 satırı geçen** `build` metodu özel widget'lara bölünür.

**3 — Paketler**
- Projeye onay almadan harici ağır state paketleri **eklenmeyecektir**.
- Dart'ın ve Flutter'ın yerel çekirdek API'lerini kullanmak esastır.
- Kullanılabilecek paketler (kapalı liste): `shared_preferences`, `flutter_local_notifications`, `timezone`, `flutter_timezone`. Başka paket için kullanıcıdan onay al.

**4 — Güvenlik ve dayanıklılık**
- Kullanıcı girdisi (sayılar, tarih, not) kaydetmeden önce doğrulanır (aralıklar project.md bölüm 5).
- Bozuk JSON uygulamayı çökertmez, varsayılan duruma dönülür.
- `async` işlemlerden sonra `BuildContext` kullanmadan önce `mounted` kontrolü yapılır.

---

## 8. Geliştirme Analiz ve Test Komutları

Ajan yaptığı **herhangi bir kod değişikliğinden sonra** aşağıdaki komutların çalıştığını **mutlaka** doğrulamalıdır.

**Statik kod analizi (0 uyarı ve 0 hata şart):**
```bash
flutter analyze
```

**Birim ve widget testleri:**
```bash
flutter test
```

**Projeyi çalıştırma:**
```bash
flutter run
```

- Komut hata veya uyarı verirse düzelt, tekrar çalıştır. Temiz sonuç almadan adımı **tamamlandı sayma**.
- Komut çıktısının özetini [DONE.md](DONE.md) dosyasına yaz.
- Hata nedeni ortam kaynaklıysa (cihaz/emülatör yok gibi) bunu açıkça yaz, tahmin yürütme.

---

## 9. DONE.md Kayıt Kuralları

Projenin kök dizininde `DONE.md` dosyası olur. Yoksa Adım 0'da oluştur. Ajan **her işlemi adım adım, nerede ne yaptığını** bu dosyaya kaydeder.

- Dosya **sona eklenerek** büyür. Eski kayıtlar silinmez, değiştirilmez.
- Her dosya oluşturma/değiştirme/silme ve her komut kaydedilir. Hatalar ve çözümleri de yazılır.
- Dosya yolları tıklanabilir bağlantı olur.
- Kayıtlar Türkçe yazılır.

Kayıt şablonu:

```markdown
## [Adım 2.1] Kısa başlık — 2026-11-08 14:30
- **Ne yapıldı:** Yerel JSON saklama servisi yazıldı.
- **Dosyalar:**
  - [lib/services/storage_service.dart](lib/services/storage_service.dart) (yeni)
  - [test/models_json_test.dart](test/models_json_test.dart) (değişti)
- **SOLID / kural notu:** DIP için soyut arayüz kullanıldı. Dosya 74 satır.
- **Komutlar:** `flutter analyze` → 0 sorun | `flutter test` → 6 test geçti
- **Durum:** ✅ Tamam
```

Sorun olursa durum satırı `⚠️ Sorun: ...` olur ve çözüm ayrı bir kayıtla eklenir.

---

## 10. Ajanın Çıktı ve Yanıt Verme Standartları

- **Açıklamalar:** Türkçe, teknik terimlerin özünü bozmadan net ve doğrudan olacaktır. Gereksiz uzatma yapma.
- **Dosya yolları:** Bahsedilen ve üretilen her dosya için mutlaka projeye göre **tıklanabilir link** ver. Örnek: [lib/screens/home_screen.dart](lib/screens/home_screen.dart)
- Her adım sonunda kısa özet ver: ne yapıldı, hangi dosyalar, analiz/test sonucu, sıradaki adım.

---

## 11. Adım Bitirme Kontrol Listesi

Bir adımı "tamamlandı" demeden önce hepsini işaretle:

- [ ] Yalnızca o adımın dosyaları yazıldı, kapsam dışına çıkılmadı.
- [ ] Tüm kod İngilizce, tüm yorumlar Türkçe ve her satır 50 karakteri aşmıyor.
- [ ] Her dosyanın üstünde başlık bloğu var, SOLID uygulanan yerde açıklama var.
- [ ] Klasör kuralına uyuldu (`models`, `services`, `screens`, `widgets`, `features`).
- [ ] Ekranlar 200 satır altında, `build` metotları 40 satır altında.
- [ ] Statik widget'larda `const` var, renk/stil sadece tema dosyasında.
- [ ] `lib/` altındaki Dart dosyası sayısı 25'i geçmiyor.
- [ ] `flutter analyze` → 0 uyarı, 0 hata.
- [ ] `flutter test` → hepsi geçiyor.
- [ ] [DONE.md](DONE.md) güncellendi.
