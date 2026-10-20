# KiralaGo — Ekranlar, Modeller ve Özellik Kılavuzu (SKILL)

Bu doküman `project.md` ile birlikte okunur. Hangi ekranın ne içereceğini, modellerin alanlarını ve akışları tanımlar. Çelişki halinde `project.md` kuralları (mimari, paketler, kırmızı çizgiler) önceliklidir.

---

## 1. Gezinme Yapısı

### Giriş Öncesi
1. **Karşılama / Rol Seçimi (`features/auth/view/welcome_page.dart`):** Uygulama adı, kısa slogan ve iki büyük buton:
   - **"Araç kiralamak istiyorum"** → Kiracı giriş sayfası
   - **"Araç kiralamaya vermek istiyorum"** → Araç sahibi giriş sayfası
2. **Kiracı Girişi (`renter_login_page.dart`)** ve **Araç Sahibi Girişi (`owner_login_page.dart`):** İki ayrı sayfa; aynı form bileşenini (`LoginForm`) farklı rol ve başlıkla kullanır. Giriş sayfasında "Hesabım yok, kayıt ol" akışı da bulunur (kayıt formu).
3. Sayfaların sağ üstünde tema ve dil değiştirme kısayolu bulunur.

### Giriş Sonrası — Alt Gezinme (`NavigationBar`, Material 3)

Sekmeler `IndexedStack` içinde durumunu korur.

**Kiracı için (3 sekme):**
| Sıra | Sekme | Dosya | İkon önerisi |
|---|---|---|---|
| 1 | Araçlar | `features/vehicle_list/view/vehicle_list_page.dart` | `Icons.directions_car_rounded` |
| 2 | Rezervasyon | `features/reservation/view/reservations_page.dart` | `Icons.event_note_rounded` |
| 3 | Profil | `features/renter_profile/view/renter_profile_page.dart` | `Icons.person_rounded` |

**Araç sahibi için (4 sekme):** Yukarıdaki 3 sekmeye ek olarak **Araçlarım** sekmesi eklenir.
| Sıra | Sekme | Dosya | İkon önerisi |
|---|---|---|---|
| 1 | Araçlar | `vehicle_list_page.dart` | `Icons.directions_car_rounded` |
| 2 | Araçlarım | `features/my_vehicles/view/my_vehicles_page.dart` | `Icons.garage_rounded` |
| 3 | Rezervasyon | `reservations_page.dart` | `Icons.event_note_rounded` |
| 4 | Profil | `features/owner_profile/view/owner_profile_page.dart` | `Icons.person_rounded` |

- Araç sahibi sekmesinin görünüp görünmemesi controller'daki rol bilgisine göre belirlenir.
- Ayarlar (tema, dil, çıkış) Profil sekmesinin üst çubuğundaki ikondan açılan `settings_page.dart` ekranındadır.
- Detay sayfaları (araç detayı, kiralayan profili, araç sahibi profili, kiralama formu) alt çubuk üzerine `Navigator.push` ile açılır.

---

## 2. Modeller

Tüm modeller immutable (`const` constructor, `copyWith`, `fromJson`, `toJson`).

### `Vehicle` (Araç Modeli)
- `id`, `ownerId`
- `type` (enum: otomobil, SUV, minibüs, motosiklet, scooter, ticari)
- `brand`, `model`, `year`
- `plate` (Türk plaka formatı, örn. `34 ABC 123`), `chassisOrIdNo` (araç ID/şase no, mock)
- `transmission` (enum: manuel, otomatik)
- `fuelType` (enum: benzin, dizel, elektrik, hibrit)
- `seatCount`
- `mileageKm`
- `accidentHistory` (enum: kazasız, hafif hasar kaydı, ağır hasar kaydı) ve açıklama
- `expertiseReportImage` (ekspertiz raporu görseli — yerel asset veya placeholder)
- `images` (liste; yerel asset/placeholder)
- `hourlyPrice`, `dailyPrice`, `weeklyPrice`, `monthlyPrice`
- `rating` (ortalama), `ratingCount`, `rentCount` (kaç kez kiralandı)
- `hasInteriorCamera` (bool)
- `insurancePolicyName` (poliçe dosya adı, mock)
- `bookedRanges` (dolu tarih aralıkları listesi)
- `reviews` (liste, `Review`)

### `OwnerUser` (Araç Sahibi Kullanıcı Modeli)
- `id`, `firstName`, `lastNameInitial`, `ageRange` (örn. "35–44"), `city`, `district`
- `avatar`, `about` (kısa tanıtım), `memberSince`
- `ownerRating`, `ownerReviewCount`, `totalRentCount`
- `responseTime` (mock: "genelde 1 saat içinde")
- `vehicleIds` (araçları)
- `reviews` (kiracıların araç sahibine yorumları)

### `RenterUser` (Kiracı Kullanıcı Modeli)
- `id`, `firstName`, `lastNameInitial` (örn. "Ahmet Y."), `age` (örn. 45), `occupation`, `city`
- `avatar`, `memberSince`
- `trustScore` (ortalama puan), `reviewCount`, `totalRentCount`
- `reviews` (araç sahiplerinin kiracı hakkındaki yorumları)

### `Review` (Yorum Modeli)
- `id`, `authorId`, `authorName`, `targetType` (araç / araç sahibi / kiracı), `targetId`
- `rating` (1–5), `date`, `text`
- `returnTags` (yalnızca kiracı yorumlarında; enum listesi): temiz teslim, kirli teslim, yakıt dolu, yakıt boş, zamanında, geç teslim, hasarsız, hasar var, kurallara uydu
- `vehicleId` (hangi araç kiralandığında yazıldı)

### `Reservation` (Rezervasyon Modeli)
- `id`, `vehicleId`, `ownerId`, `renterId`
- `pickupDateTime`, `pickupLocation`, `returnDateTime`, `returnLocation`
- `totalPrice`, `paymentStatus` (bekliyor / ödendi — mock)
- `status` (enum: bekliyor, onaylandı, devam ediyor, tamamlandı, iptal)
- `rentalForm` (`RentalForm?`)

### `RentalForm` (Kiralama Formu Modeli)
- Araç: `brand`, `model`, `year`, `plate`, `chassisOrIdNo`
- Sahip: `ownerName`, `ownerAgeRange`
- Kiracı: `renterName`, `renterAge`, `renterOccupation`
- `pickupPlace`, `pickupTime`, `returnPlace`, `returnTime`
- `price`, `paymentMethod` (mock: kart / nakit), `paymentSummary`
- `preRentalPhotos` (dış fotoğraflar: ön, arka, sağ, sol — mock)
- `fuelLevelBefore` (yüzde veya çeyrek: 1/4, 1/2, 3/4, dolu)
- `hasInteriorCamera` (bool; ekranda onay kutusu olarak gösterilir)
- `insurancePolicyName`
- `ownerSigned`, `renterSigned` (bool) ve `ownerSignatureStrokes`, `renterSignatureStrokes` (imza çizgileri)

### `VehicleFilter` (Filtre Modeli)
- `sortBy` (varsayılan: **en yüksek puan**), `type`, `yearRange`, `brand`, `model`, `transmission`, `fuelType`, `minSeats`

---

## 3. Ekran İçerikleri

### 3.1 Giriş ve Kayıt (Kullanıcı Girişi + Form + Validasyon)
- Alanlar: e-posta, şifre (göster/gizle), "Beni hatırla" (`Checkbox`/`Switch`).
- Kayıt: ad, soyad, e-posta, telefon, şifre, şifre tekrar, yaş (18+ zorunlu), meslek, kullanım şartları onayı (`Checkbox`).
- Araç sahibi kaydında ek olarak: şehir/ilçe.
- Validasyonlar:
  - E-posta biçimi; şifre en az 8 karakter, en az 1 harf ve 1 rakam; şifre tekrar eşleşmesi.
  - Telefon: Türkiye biçimi (`05XX XXX XX XX`).
  - Yaş: en az 18; ad/soyad boş olamaz, sadece harf.
  - Kullanım şartları işaretlenmeden kayıt yapılamaz.
- Giriş mock'tur: `mock_auth_data.dart` içindeki en az 2 kiracı ve 2 araç sahibi hesabıyla doğrulanır. Yanlış bilgide `AlertDialog` veya hata `SnackBar` gösterilir. Başarılı girişte rol `SessionController`'a yazılır ve kabuk açılır.
- Yükleme durumunda butonda `CircularProgressIndicator` gösterilir (kısa gecikme simülasyonu).

### 3.2 Ana Sayfa — Araç Listesi (`vehicle_list_page.dart`)
- Üstte arama çubuğu ve **Filtre** butonu (`showModalBottomSheet`); seçili filtreler `Chip` olarak listenin üstünde görünür, her chip silinebilir.
- **Filtreler:**
  - Sıralama: varsayılan **en yüksek puan** (ayrıca fiyat artan/azalan, yıl yeni/eski)
  - Araç tipi (`ChoiceChip`)
  - Yıl (`RangeSlider`)
  - Marka, model (marka seçilince modeller daralır; `DropdownMenu`)
  - Vites: manuel / otomatik (`SegmentedButton`)
  - Yakıt: benzinli / elektrikli (dizel ve hibrit isteğe bağlı eklenebilir)
  - Koltuk sayısı (`ChoiceChip` veya `Slider`)
  - "Temizle" ve "Uygula" butonları
- **Liste:** Dikey kaydırmalı `ListView.builder`. Araç kartı: görsel, marka-model-yıl, tip, vites, yakıt, koltuk, puan (yıldız + sayı), günlük fiyat, sahip adı. Karta tıklayınca **Araç Detay** sayfası açılır.
- Boş sonuçta `EmptyState` widget'ı ("Filtrelere uygun araç bulunamadı" + filtreleri temizle butonu).
- Filtre mantığı `VehicleListController` içinde, saf Dart olarak yazılır ve birim test edilir.
- Mock veri: en az **12 araç**; otomobil, SUV, motosiklet ve scooter karışık; farklı marka, yıl, yakıt ve puanlarla.

### 3.3 Araç Detay Sayfası (`vehicle_detail_page.dart`)
Sırasıyla:
1. Görsel galerisi (`PageView` + gösterge noktaları).
2. Başlık: marka, model, yıl; puan; kaç kez kiralandı.
3. Teknik bilgiler: km, vites, yakıt, koltuk, kaza durumu (renkli etiket), plaka (kısmi maskeli gösterilebilir).
4. **Ekspertiz raporu:** "Ekspertiz Raporunu Gör" butonu → tıklayınca rapor görseli tam ekran/diyalog içinde açılır (`InteractiveViewer` ile yakınlaştırılabilir).
5. **Fiyatlar:** Saatlik / günlük / haftalık / aylık (`SegmentedButton` veya sekmeli kartlar; seçilen periyot toplam fiyatı hesaplar).
6. **Takvim:** Aylık takvim. **Dolu tarihler işaretlidir** (tema renginde, seçilemez, açıklama göstergesi ile: "Dolu", "Müsait", "Seçili"). Kullanıcı başlangıç–bitiş aralığı seçer; seçilen aralık dolu bir günü içeriyorsa uyarı gösterilir ve seçim engellenir.
7. **[Kirala] butonu:** Güzel ve dikkat çekici. Ekranın altında sabit, geniş, `FilledButton` tabanlı gradient/yüksek vurgulu CTA (bkz. `style.md`). Tarih seçilmeden basılırsa uyarı `SnackBar`'ı gösterilir; seçilmişse **Kiralama Formu** açılır. Giriş yapılmamışsa giriş sayfasına yönlendirilir.
8. **Satıcı Hakkında:** Sahip avatarı, adı (örn. "Mehmet K."), yaş aralığı, şehir/ilçe, üyelik tarihi, sahip puanı, yanıt süresi. Karta tıklayınca **Araç Sahibi Profili** açılır.
9. **Yorumlar:** Önceki kiracıların yorumları ve puanları. **İlk 3 yorum** gösterilir; 3'ten fazla varsa **"Daha fazla göster"** butonu görünür ve tıklanınca tüm yorumlar listelenir (genişleyen liste veya tam sayfa). Yorum yazarına tıklayınca **Kiralayan Profili** açılır.

### 3.4 Kiralayan (Kiracı) Profil Sayfası (`renter_profile_page.dart`)
Hem kendi profilini (Profil sekmesi) hem de başka bir kiracının profilini görüntülemek için kullanılır (parametreyle).
- Üst bölüm: profil resmi (`CircleAvatar`), yanında "Ahmet Y. (45)" gibi ad ve yaş; meslek, şehir, üyelik tarihi, toplam kiralama sayısı, güven puanı.
- Aşağıda: **Bu kiracıya aracını kiralatanların yorumları** — kiracı ne kadar güvenilir, nasıl deneyimler yaşatmış:
  - Aracın nasıl geri alındığı (iade etiketleri: temiz / kirli, yakıt dolu / boş, zamanında / geç, hasar var / yok)
  - Puan ve metin yorum
- **İlk 3 yorum** + **"Daha fazla göster"** butonu.
- İade etiketleri `Chip` olarak gösterilir; olumlu etiketler ve olumsuz etiketler farklı renk rolü kullanır.
- Mock veri: en az 4 kiracı, her birinde en az 5 yorum.

### 3.5 Araç Sahibi Profil Sayfası (`owner_profile_page.dart`)
- Üst bölüm: profil resmi, ad, yaş aralığı, şehir/ilçe, üyelik tarihi, hakkında metni, sahip puanı, toplam kiralatma sayısı, yanıt süresi.
- **Araçları:** Sahibin tüm araçları (örn. 1 motosiklet, 1 otomobil, 1 scooter) yatay veya dikey kart listesi olarak; her kartta tip, marka-model, puan, kaç kez kiralandı, fiyat. Karta tıklayınca araç detayına gidilir.
- **Yorumlar:** Sahibin araçlarını kiralayanların yorumları; **ilk 3 + "Daha fazla göster"** butonu.
- Kendi profili görüntülendiğinde "Profili düzenle" butonu (form: ad, hakkında, şehir; validasyonlu).
- Mock veri: en az 3 araç sahibi; her birinin en az 2 farklı tipte aracı.

### 3.6 Araçlarım (`my_vehicles_page.dart`) — yalnızca Araç Sahibi
- Sahibin tüm araçları: görsel, marka-model, plaka, durum (müsait / kirada), puan, kaç kez kiralandı, gelir özeti (mock).
- Karta tıklayınca aracın **tüm detayları**: teknik bilgiler, ekspertiz, fiyatlar, takvim (dolu günler), yorumlar ve puanlar (ilk 3 + daha fazla), aktif/geçmiş rezervasyonlar.
- **Araç Ekle / Düzenle** formu (FAB ile): tip, marka, model, yıl, plaka (Türk plaka regex), vites, yakıt, koltuk, km, fiyatlar (sayısal ve > 0), iç kamera var mı (`Checkbox`/`Switch`), sigorta poliçesi adı. Tüm alanlar validasyonludur.
- Araç silme/pasife alma işlemi **onay diyaloğu** ile yapılır.

### 3.7 Kiralama Formu (`rental_form_page.dart`) — iki tarafın e-imzası
Araç detayındaki [Kirala] butonuna basınca açılır. Çok bölümlü, `Stepper` veya tek sayfada bölümlü form.

Bölümler:
1. **Araç Bilgileri:** marka, model, yıl, plaka, ID No (salt okunur, araçtan gelir).
2. **Araç Sahibi Bilgileri:** ad, yaş aralığı (salt okunur).
3. **Kiracı Bilgileri:** ad, yaş, meslek (profilden gelir, düzenlenebilir).
4. **Teslim Alma:** yer (metin), tarih ve saat (`showDatePicker` + `showTimePicker`).
5. **Teslim Etme:** yer (metin), tarih ve saat.
6. **Ücret ve Ödeme:** seçilen periyoda göre toplam ücret, ödeme yöntemi (`RadioListTile`/`SegmentedButton`), ödeme özeti (mock).
7. **Kiralamadan Önceki Dış Fotoğraflar:** ön, arka, sağ, sol (mock görsel/placeholder; "fotoğraf ekle" butonu simülasyonu).
8. **Kiralamadan Önceki Yakıt Miktarı:** `Slider` veya seçim (1/4, 1/2, 3/4, dolu).
9. **İç Kamera:** "Araçta iç kamera var" — onay kutusu (tick) ve bilgilendirme metni.
10. **Sigorta Poliçesi:** poliçe adı ve **"İndir"** butonu (mock; tıklayınca indirme simülasyonu + `SnackBar`: "Poliçe indirildi").
11. **E-İmza:** İki taraf da imzalar.

Doğrulama kuralları:
- Teslim etme tarihi/saati, teslim almadan **sonra** olmalıdır.
- Teslim alma geçmiş tarihte olamaz; seçilen aralık araç takviminde dolu bir güne denk gelemez.
- Yer alanları boş olamaz (en az 3 karakter); yakıt seviyesi seçilmelidir; dış fotoğraflar 4 yönün hepsi için eklenmelidir (mock).
- İç kamera bilgilendirmesi okunup onaylanmalıdır.
- İki imza da tamamlanmadan "Kiralamayı Onayla" butonu pasiftir.

**E-imza bileşeni (`signature_pad.dart`):** `CustomPaint` + `GestureDetector` ile yerel olarak yazılır (paket yok). "Temizle" ve "Kaydet" butonları bulunur; imza boşsa kaydedilemez. Kiracı ve araç sahibi için ayrı imza alanları vardır. Mock akışta araç sahibi imzası ikinci bir diyalogla ("Araç sahibi imzası") simüle edilir.

Onay: "Kiralamayı Onayla" → onay `AlertDialog` → başarıda rezervasyon oluşturulur ve **Rezervasyon Bilgisi** sayfası açılır.

### 3.8 Rezervasyon (`reservations_page.dart` ve `reservation_detail_page.dart`)
- Liste: kullanıcının rezervasyonları (durum etiketli `ListView.builder`; "Yaklaşan / Geçmiş" `TabBar`).
- Detay: **rezervasyon bilgisi** — araç, tarih/saat aralığı, teslim yerleri, ücret ve ödeme durumu, imza durumları, sigorta poliçesi indir butonu, karşı tarafın profiline kısayol, "İptal Et" (onay diyaloğuyla).

### 3.9 Gecikme Bildirimi (Simülasyon)
- Kiracı veya araç sahibi, söz verilen saatte buluşma yerine **varamayacaksa** karşı tarafa bildirim gider.
- Gerçek trafik/konum servisi **kullanılmaz**. `MockTrafficService` anlık saati ve sahte trafik yoğunluğunu kullanarak tahmini varış süresini hesaplar (örn. `Timer`/`Stream` ile periyodik tick).
- Tahmini varış, teslim saatinden sonraysa: karşı tarafa **uygulama içi bildirim** gösterilir (`MaterialBanner`/`SnackBar` + detaylı `AlertDialog`: "Ahmet Y. yaklaşık 15 dk geç kalacak"). Rezervasyon detayında bir "Gecikme simüle et" butonu bu akışı demoda tetikler.
- Gerçek push bildirimi YOKTUR; bildirimler `NotificationController` (`ValueNotifier<List<AppNotification>>`) üzerinden yönetilir.

### 3.10 Ayarlar (`settings_page.dart`)
- **Tema:** Sistem / Aydınlık / Karanlık (`SegmentedButton`), anında geçiş, `shared_preferences` ile kalıcı.
- **Dil:** Türkçe / English, anında geçiş, kalıcı.
- **Çıkış Yap:** Onay diyaloğu → oturum temizlenir → karşılama sayfası.

---

## 4. Diyalog ve Etkileşim Envanteri

Aşağıdaki diyaloglar uygulamada mutlaka bulunur:
- Çıkış onayı (`AlertDialog`)
- Rezervasyon/kiralama onayı (`AlertDialog`)
- Rezervasyon iptal onayı (`AlertDialog`)
- Araç silme/pasife alma onayı (`AlertDialog`)
- Filtre paneli (`showModalBottomSheet`)
- Tarih ve saat seçici (`showDatePicker`, `showTimePicker`)
- Ekspertiz raporu görüntüleme diyaloğu
- İmza diyaloğu
- Gecikme bildirimi diyaloğu
- Hata/başarı geri bildirimleri (`SnackBar`)
- Ortak `ConfirmDialog` widget'ı `core/widgets/` altında yazılır ve tekrar kullanılır.

---

## 5. Validasyon Envanteri (`core/validators/app_validators.dart`)

Her biri birim testlidir ve yerelleştirilmiş hata mesajı döner:
- `email`, `password`, `confirmPassword`, `phone`, `requiredField`, `minLength`, `onlyLetters`, `age` (18+)
- `turkishPlate` (örn. `^(0[1-9]|[1-7][0-9]|8[01])\s?[A-ZÇĞİÖŞÜ]{1,3}\s?\d{2,4}$`)
- `positivePrice`, `yearRange`, `seatCount`, `mileage`
- `returnAfterPickup` (tarih/saat karşılaştırması)
- `rangeNotBooked` (seçilen aralık dolu günleri içeriyor mu)

---

## 6. Yerelleştirme (TR / EN)

- `lib/l10n/app_tr.arb` (şablon) ve `app_en.arb`; `l10n.yaml` ile `flutter gen-l10n` kullanılır.
- Varsayılan dil Türkçe. Tarih, para ve sayı biçimleri `intl` ile yerele göre gösterilir (para birimi: ₺).
- Enum etiketleri (vites, yakıt, araç tipi, durumlar, iade etiketleri) için ARB anahtarları tanımlanır; enum içinde sabit metin yazılmaz.
- Dil değişince tüm ekranlar anında güncellenir (`ValueListenableBuilder<Locale>`).

---

## 7. Mock Veri Gereksinimleri

- Her feature kendi `data/mock_<feature>_data.dart` dosyasını tutar. Gerçek ağ isteği yoktur.
- En az: **12 araç**, **3 araç sahibi** (her biri en az 2 farklı tipte araç), **4 kiracı**, her araç/kişi için **en az 5 yorum** (3'ten fazla olmalı ki "Daha fazla göster" demoda çalışsın), araçlarda dolu tarih aralıkları, en az **4 rezervasyon** (farklı durumlarda).
- Görseller yerel `assets/` veya `Icon`/gradient placeholder ile gösterilir; internet görseli kullanılmaz.
- Kişi adları "Ahmet Y." biçiminde (ad + soyadın baş harfi) gösterilir.

---

## 8. Kabul Kriterleri (Bitti Sayılması İçin)

- [ ] `flutter analyze` → 0 uyarı, 0 hata; `flutter test` → hepsi geçiyor
- [ ] Rol seçimli iki ayrı giriş sayfası çalışıyor; araç sahibine 4. sekme (Araçlarım) görünüyor
- [ ] Filtreler çalışıyor, varsayılan sıralama en yüksek puan
- [ ] Araç detayında takvimde dolu günler işaretli ve seçilemiyor
- [ ] Tüm yorum listelerinde ilk 3 + "Daha fazla göster" çalışıyor (araç, kiracı profili, araç sahibi profili)
- [ ] Kiralama formu tüm alanları içeriyor; validasyonlar çalışıyor; iki taraf da imzalıyor; poliçe "indir" simülasyonu var
- [ ] Gecikme bildirimi simülasyonu çalışıyor
- [ ] Aydınlık/karanlık tema ve TR/EN dil anında değişiyor ve kalıcı
- [ ] Zorunlu 4 konu (UI elemanları ve etkileşimler, form ve validasyon, kullanıcı girişi, Material 3 + tema, diyaloglar) eksiksiz
- [ ] Hiçbir widget içinde sabit renk/metin stili/sabit kullanıcı metni yok
