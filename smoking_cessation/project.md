# project.md — Sigara Bırakma Uygulaması

> Bu dosya projenin **NE** olduğunu anlatır. **NASIL** kodlanacağının kuralları [skill.md](skill.md) dosyasındadır.
> Kodlamaya başlamadan önce ikisini de baştan sona oku. Her işlemi [DONE.md](DONE.md) dosyasına kaydet.

---

## 1. Proje Özeti

Sigara bırakmaya çalışan kişiye motivasyon veren, **basit ve gerçekten çalışan** bir Flutter mobil uygulaması.

- **Platform:** Sadece Flutter / Dart (mobil, Android öncelikli).
- **Veri:** Backend YOKTUR. Tüm veri cihazda **JSON** olarak yerel saklanır.
- **İnternet:** Gerekmez. Uygulama tamamen çevrimdışı çalışır.
- **Dil kuralı:** Kod ve değişken adları İngilizce, yorum satırları Türkçe, uygulama içi metinler Türkçe.
- **Hedef:** Küçük, anlaşılır, en fazla **25 Dart dosyası** (`lib/` altında).

### Kapsam dışı (YAPMA)

Firebase, Supabase, Node.js, REST API, kullanıcı hesabı/giriş, bulut yedek, harici state paketleri (Provider, Riverpod, BLoC, GetX vb.). Bunlar bu projede yoktur.

---

## 2. Çekirdek Özellikler (MVP)

### 2.1 Bırakma tarihi ve sayaç
- Kullanıcı "sigarayı bıraktığım tarih ve saat"i girer.
- Ana ekranda **gün, saat, dakika (ve saniye)** canlı olarak akar.
- Tarih gelecekte olamaz. Gelecek seçilirse hata mesajı göster.

### 2.2 Tasarruf hesabı
Başlangıçta 3 bilgi alınır: günde kaç sigara, paket fiyatı (TL), pakette kaç sigara.

```
geçen gün       = (şimdi - bırakma zamanı) / 24 saat   (ondalıklı, negatifse 0)
içilmeyen sigara = geçen gün * günlük sigara           (ekranda aşağı yuvarlanır)
sigara başı fiyat = paket fiyatı / paketteki sigara
biriken para    = içilmeyen sigara * sigara başı fiyat  (ekranda 2 ondalık, "₺")
```

### 2.3 Sağlık kazanımları
Zaman çizelgesi (timeline). Her kilometre taşı geçen süreye göre **tamamlandı / devam ediyor** görünür.

| Süre | Kazanım |
|---|---|
| 20 dakika | Nabız ve tansiyon normale yaklaşır |
| 12 saat | Kandaki karbonmonoksit seviyesi düşer |
| 2 hafta – 3 ay | Dolaşım ve akciğer fonksiyonu iyileşir |
| 1 – 9 ay | Öksürük ve nefes darlığı azalır |
| 1 yıl | Koroner kalp hastalığı riski yarıya iner |

Ekranın altında kısa not: "Genel bilgilendirmedir, tıbbi tavsiye değildir."
Aralıklı kazanımlarda (ör. 2 hafta – 3 ay) **başlangıç süresi** tamamlanma ölçütüdür; ilerleme çubuğu bitiş süresine göre dolar.

### 2.4 "Canım çekti" butonu
- Ana ekranda büyük bir buton. Basınca `craving_screen` açılır.
- **5 dakikalık geri sayım** (300 sn) başlar.
- **Nefes egzersizi animasyonu:** 4 sn nefes al → 4 sn tut → 4 sn ver, döngü halinde. Daire büyür/küçülür, üstünde faz yazısı görünür.
- Rastgele bir **motivasyon cümlesi** gösterilir (en az 10 cümle, her açılışta ve "yeni cümle" butonuyla değişir).
- Süre bitince "Başardın!" mesajı gösterilir.

### 2.5 Günlük kayıt
- Her gün tek dokunuşla **"Bugün içmedim"** işaretlenir (yeşil gün). **"Bugün içtim"** seçeneği kırmızı gün olur.
- İsteğe bağlı: çekim seviyesi (1–5) ve kısa not (en fazla 200 karakter).
- Takvim (ay görünümü): yeşil = içilmedi, kırmızı = içildi, boş = kayıt yok, bugün = çerçeveli.
- Bir güne dokununca o günün kaydı **ayrı bir form sayfasında** düzenlenir. Gelecek günler seçilemez.
- Bir gün "içtim" işaretlenirse sayaç **otomatik sıfırlanmaz**. Kullanıcı isterse Ayarlar'dan bırakma tarihini değiştirir.

### 2.6 Yerel bildirimler
- **Günlük motivasyon bildirimi:** her gün seçilen saatte (varsayılan 09:00).
- **Kutlama bildirimleri:** bırakma tarihinden itibaren 1 gün, 1 hafta, 1 ay, 3 ay, 6 ay, 1 yıl tamamlanınca ("1 haftayı tamamladın!").
- Sadece gelecekteki kutlamalar planlanır.
- Bırakma tarihi, saat veya bildirim ayarı değişince tüm bildirimler **iptal edilip yeniden planlanır**.
- Android 13+ için bildirim izni istenir. Tam zamanlı alarm izni **istenmez** (yaklaşık zamanlı planlama yeterlidir).

---

## 3. Kullanılacak Paketler

Dart/Flutter çekirdek API'leri esastır. Aşağıdaki liste **kapalıdır**. Listede olmayan paket için kullanıcıdan onay al.

| Paket | Ne için |
|---|---|
| `shared_preferences` | JSON metnini cihazda saklamak |
| `flutter_local_notifications` | Yerel bildirimler |
| `timezone` | Bildirim zamanlaması için saat dilimi |
| `flutter_timezone` | Cihazın saat dilimini öğrenmek |

Takvim, grafik, tarih formatlama için paket **yok**. Takvim elle yazılır, tarih basit yardımcı fonksiyonla biçimlenir.

**Android kurulum notu (bildirim paketi için):** `android/app/build.gradle` içinde `coreLibraryDesugaringEnabled true` ve `desugar_jdk_libs` bağımlılığı eklenir. `AndroidManifest.xml` içine `POST_NOTIFICATIONS` izni eklenir. Paketin güncel dokümanını kontrol et.

---

## 4. Klasör ve Dosya Yapısı (toplam 25 Dart dosyası)

```
lib/
├── main.dart                          (1)  Başlatma, controller kurulumu, MaterialApp
├── theme/
│   └── app_theme.dart                 (2)  Renkler + metin stilleri + ThemeData
├── models/
│   ├── user_profile.dart              (3)  UserProfile + AppSettings
│   ├── daily_log.dart                 (4)  DailyLog + tarih anahtarı yardımcısı
│   └── health_milestone.dart          (5)  HealthMilestone + kilometre taşı listesi
├── services/
│   ├── storage_service.dart           (6)  Soyut arayüz + SharedPreferences gerçeklemesi
│   ├── quit_calculator.dart           (7)  Süre, tasarruf, sağlık ilerlemesi hesapları
│   └── notification_service.dart      (8)  Soyut arayüz + yerel bildirim gerçeklemesi
├── features/
│   ├── quit/quit_controller.dart      (9)  Profil, ayarlar, canlı saat (ChangeNotifier)
│   ├── diary/diary_controller.dart    (10) Günlük kayıtlar (ChangeNotifier)
│   └── craving/craving_controller.dart(11) Geri sayım, nefes fazı, motivasyon cümleleri
├── screens/
│   ├── onboarding_date_screen.dart    (12) Form 1: bırakma tarihi ve saati
│   ├── onboarding_cost_screen.dart    (13) Form 2: sigara sayısı, fiyat, paket adedi
│   ├── home_shell_screen.dart         (14) Alt gezinme çubuğu (4 sekme)
│   ├── home_screen.dart               (15) Sayaç, tasarruf, "Canım çekti"
│   ├── health_screen.dart             (16) Sağlık zaman çizelgesi
│   ├── diary_screen.dart              (17) Takvim + "Bugün içmedim"
│   ├── diary_entry_screen.dart        (18) Form: gün durumu, çekim seviyesi, not
│   ├── craving_screen.dart            (19) 5 dk geri sayım + nefes + cümle
│   └── settings_screen.dart           (20) Bilgi düzenleme, bildirim, sıfırlama
└── widgets/
    ├── timer_display.dart             (21) Gün/saat/dakika/saniye gösterimi
    ├── stat_card.dart                 (22) Başlık + değer kartı
    ├── health_timeline_tile.dart      (23) Zaman çizelgesi satırı
    ├── breathing_circle.dart          (24) Animasyonlu nefes dairesi
    └── diary_calendar.dart            (25) Ay takvimi (yeşil/kırmızı günler)

test/                                  (25 sınırına dahil DEĞİL)
├── quit_calculator_test.dart
├── models_json_test.dart
└── widget_smoke_test.dart
```

Kurallar:
- 25 dosya sınırı **aşılmaz**. Yeni dosya gerekiyorsa önce mevcut dosyaya sığdırmayı dene, olmuyorsa kullanıcıdan onay iste.
- Küçük yardımcı sınıflar (ör. `AppSettings`, `DateKey`) mantıksal olarak ait oldukları dosyanın içinde durur.
- Ekran dosyaları 200 satırı geçmez. Form akışları bağımsız sayfalardır.

---

## 5. Veri Modelleri ve JSON Yapısı

Üç anahtar `shared_preferences` içinde JSON **metni** olarak saklanır: `profile`, `settings`, `logs`.

**profile**
```json
{
  "quitDateTime": "2026-11-08T09:30:00.000",
  "cigarettesPerDay": 15,
  "packPrice": 100.0,
  "cigarettesPerPack": 20
}
```

**settings**
```json
{ "notificationsEnabled": true, "reminderHour": 9, "reminderMinute": 0 }
```

**logs** (liste, tarihe göre tekil)
```json
[
  { "date": "2026-11-08", "smokeFree": true, "cravingLevel": 3, "note": "Kahveden sonra zorlandım" },
  { "date": "2026-11-09", "smokeFree": false, "cravingLevel": null, "note": null }
]
```

Doğrulama aralıkları:

| Alan | Kural |
|---|---|
| `cigarettesPerDay` | 1 – 100 tam sayı |
| `packPrice` | 0'dan büyük, en fazla 10000 |
| `cigarettesPerPack` | 1 – 50 tam sayı |
| `cravingLevel` | 1 – 5 veya boş |
| `note` | En fazla 200 karakter |
| `date` | `yyyy-MM-dd`, gelecek olamaz |

Bozuk/okunamayan JSON uygulamayı çökertmemeli. Varsayılan boş duruma dönülür (profil yoksa onboarding açılır).

---

## 6. Ekran Akışı

```
Uygulama açılır
   └─ profil yok mu? ── evet ─► OnboardingDate ─► OnboardingCost ─► HomeShell
   └─ profil var ───────────────────────────────────────────────► HomeShell

HomeShell (alt çubuk)
   ├─ Ana Sayfa ─► [Canım çekti] ─► CravingScreen
   ├─ Sağlık
   ├─ Günlük   ─► gün seç ─► DiaryEntryScreen
   └─ Ayarlar  ─► bilgileri düzenle ─► OnboardingDate/Cost (düzenleme modu)
```

Onboarding ekranları düzenleme modunda mevcut değerlerle açılır, kaydedince geri döner.

---

## 7. Adım Adım Geliştirme Planı

Her adımı **sırayla** yap. Bir adım bitmeden diğerine geçme. Her adım sonunda `flutter analyze` (0 uyarı, 0 hata) ve `flutter test` çalıştır, sonucu [DONE.md](DONE.md) dosyasına yaz.

**Adım 0 — Kurulum**
- [ ] `flutter create` ile proje oluştur, klasörleri aç, paketleri ekle (bölüm 3).
- [ ] Android bildirim ayarlarını yap, `analysis_options.yaml` içinde `flutter_lints` aç.
- [ ] Varsayılan sayaç uygulamasını ve eski `widget_test.dart` dosyasını temizle.
- [ ] `DONE.md` dosyasını oluştur.

**Adım 1 — Tema ve modeller**
- [ ] `app_theme.dart`, `user_profile.dart`, `daily_log.dart`, `health_milestone.dart`
- [ ] JSON gidiş-dönüş testi (`models_json_test.dart`)

**Adım 2 — Saklama ve hesaplama**
- [ ] `storage_service.dart` (soyut arayüz + gerçekleme)
- [ ] `quit_calculator.dart` + `quit_calculator_test.dart`

**Adım 3 — Controller'lar**
- [ ] `quit_controller.dart`, `diary_controller.dart`, `craving_controller.dart`

**Adım 4 — Onboarding ve açılış**
- [ ] `onboarding_date_screen.dart`, `onboarding_cost_screen.dart`, `main.dart`, `home_shell_screen.dart`

**Adım 5 — Ana sayfa**
- [ ] `home_screen.dart`, `timer_display.dart`, `stat_card.dart`

**Adım 6 — Sağlık**
- [ ] `health_screen.dart`, `health_timeline_tile.dart`

**Adım 7 — Canım çekti**
- [ ] `craving_screen.dart`, `breathing_circle.dart`

**Adım 8 — Günlük**
- [ ] `diary_screen.dart`, `diary_calendar.dart`, `diary_entry_screen.dart`

**Adım 9 — Ayarlar**
- [ ] `settings_screen.dart` (bilgi düzenle, bildirim aç/kapa ve saat, tüm veriyi sil)

**Adım 10 — Bildirimler**
- [ ] `notification_service.dart`, controller bağlantısı, izin isteği
- [ ] `widget_smoke_test.dart`

**Adım 11 — Son kontrol**
- [ ] Kabul kriterlerini (bölüm 8) tek tek doğrula, sonuçları `DONE.md` dosyasına yaz.
- [ ] Release derlemesi (`flutter build appbundle`) **sadece kullanıcı isterse** yapılır.

---

## 8. Kabul Kriterleri

- [ ] İlk açılışta onboarding, sonraki açılışlarda doğrudan ana sayfa gelir.
- [ ] Uygulama kapatılıp açılınca tüm veri korunur.
- [ ] Sayaç her saniye akar ve doğru süreyi gösterir.
- [ ] Tasarruf ve içilmeyen sigara değerleri bölüm 2.2 formülüne uyar.
- [ ] Sağlık kazanımları geçen süreye göre doğru işaretlenir.
- [ ] "Canım çekti" ekranında 5 dk geri sayım, 4-4-4 nefes animasyonu ve cümle çalışır.
- [ ] Takvimde yeşil/kırmızı günler doğru görünür, tek dokunuşla "Bugün içmedim" kaydedilir.
- [ ] Günlük ve kutlama bildirimleri planlanır, ayardan kapatılınca iptal olur.
- [ ] İnternet kapalıyken her şey çalışır.
- [ ] Hiçbir ekran 200 satırı, hiçbir `build` metodu 40 satırı geçmez.
- [ ] `lib/` altında en fazla 25 Dart dosyası var.
- [ ] `flutter analyze` → 0 uyarı, 0 hata. `flutter test` → hepsi geçiyor.
- [ ] `DONE.md` her işlemi içeriyor.
