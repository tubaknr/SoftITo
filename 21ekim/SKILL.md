# Focus & Grow — Özellik ve Sayfa Kılavuzu (SKILL)

Bu doküman `project.md` ile birlikte okunur ve onunla çelişirse `project.md` geçerlidir. Burada uygulamanın sayfaları, akışları, davranış kuralları ve paket politikası tanımlanır. Görsel stil (renk, font, arka plan, animasyon vb.) burada yer almaz; ayrı bir stil dokümanında tanımlanır.

---

## 1. Navigasyon ve Ortak Bileşenler

### 1.1. Sayfa Akışı

```text
Giriş Sayfası (Landing)
 ├─ Register → Kayıt Ol Sayfası → Karşılama Sayfası → [ilerle] → Ana Uygulama (Shell)
 ├─ Giriş Yap → Giriş Yap Sayfası ─ Şifremi unuttum → Şifremi Unuttum Sayfası
 └─ Google butonu → Google ile giriş → Ana Uygulama (Shell)

Ana Uygulama (Shell, alt bar + IndexedStack)
 ├─ Ana Sayfa ── Odaklanmaya başla → Odaklanma Sayfası (tam ekran, alt/üst bar yok)
 ├─ İstatistikler
 ├─ Topluluk ── bir kişiye tıkla → Kişi Profil Sayfası
 └─ Profil & Ayarlar (kullanıcının kendi profili)
```

### 1.2. Üst Bar (Top Bar)

| Sayfa grubu | İçerik |
|---|---|
| Giriş, Kayıt, Karşılama, Giriş Yap, Şifremi Unuttum | Yalnızca **karanlık/aydınlık mod ikonu** ve **TR/EN dil seçici**. Profil resmi ve isim YOKTUR. |
| Ana Sayfa, İstatistikler, Topluluk, Profil, Kişi Profil Sayfası | Kullanıcının **profil resmi (kişiye özel çiçek logosu)**, yanında "Hoşgeldin" + kullanıcı ismi, ayrıca mod ikonu ve dil seçici. |
| Odaklanma Sayfası | Üst bar **görünmez**. |

- Tema ve dil değişimi anlıktır, sayfa yeniden yüklenmeden uygulanır.

### 1.3. Alt Bar (Bottom Bar)

Sırasıyla dört sekme: 

| Sıra | Sekme | Dosya | İkon önerisi |
|---|---|---|---|
| 1 | Anasayfa | `features/home/view/home_page.dart` | `Icons.local_florist_rounded` |
| 2 | İstatistikler | `features/stats/view/stats_page.dart` | `Icons.insights_rounded` |
| 3 | Topluluk | `features/community/view/community_page.dart` | `Icons.public_rounded` |
| 4 | Profil & Ayarlar | `features/profile/view/profile_page.dart` | `Icons.person_rounded` |

- Alt bar şu sayfalarda **görünür:** Ana Sayfa, İstatistikler, Topluluk, Profil & Ayarlar, Kişi Profil Sayfası.
- Alt bar şu sayfalarda **görünmez:** Giriş, Kayıt, Karşılama, Giriş Yap, Şifremi Unuttum, Odaklanma Sayfası.
- Sekmeler `IndexedStack` içinde durumunu korur.

### 1.4. Her Sayfada Ortak Olanlar

- Sağ alt köşede **F&G** imzası bulunur. Alt bar olan sayfalarda alt barın üstünde, içerikle çakışmayacak şekilde durur.

---

## 2. Sayfa İçerikleri

### 2.1. Giriş Sayfası (Landing)

Yukarıdan aşağı sırayla:
1. Üst bar (yalnızca mod ve dil).
2. **Çiçek logosu:** çiçek illüstrasyonu (`CustomPainter` ile çizilir, harici görsel gerekmez).
3. Uygulama adı: **Focus & Grow**
4. Motto: "Odaklanarak yaşamı daha derinden hissetmek ister misin?"
5. **Register** butonu. Tıklanınca Kayıt Ol sayfasına gider.
6. Tıklanabilir metin: "Kayıtlı hesabın varsa Giriş Yap". Tıklanınca Giriş Yap sayfasına gider.
7. **Google OAuth** butonu: Google ile giriş yaptırır (bkz. Bölüm 3, Google girişi notu).

### 2.2. Kayıt Ol Sayfası

- Üst bar: yalnızca mod ve dil (profil resmi ve isim yok).
- Alanlar (yukarıdan aşağı):
  1. Başlık: **"Sana nasıl hitap edelim?"** + isim girdisi
  2. E-posta (alan üzerinde "E-posta" etiketi)
  3. Şifre (alan üzerinde "Şifre" etiketi)
  4. Şifre doğrulama (alan üzerinde "Şifre doğrulama" etiketi)
  5. Yaş (sayısal girdi)
  6. Ülke seçici
  7. **Kaydol** butonu
- **Şifre kuralları:** en az 8 karakter, en az 1 büyük harf, en az 1 küçük harf, en az 1 sembol. Şifre ve doğrulama eşleşmelidir.
- **Doğrulama davranışı:** Boş bırakılan veya kuralı sağlamayan alanın çerçevesi **kırmızı** olur ve alanın altında kural metni gösterilir. Doğrulama mantığı controller'da (saf Dart) durur, UI yalnızca sonucu gösterir.
- Başarılı kayıttan sonra Karşılama sayfası açılır.

### 2.3. Karşılama Sayfası

- **"Merhaba {kullanıcı ismi}"** (formda girilen isim).
- Altında: "Odaklanarak hayatını daha derinden hissetmeye başlamak için **ilerle**". "ilerle" kelimesi tıklanabilirdir. Tıklanınca Ana Sayfaya girilir.

### 2.4. Giriş Yap Sayfası

- "Doğanın tadını çıkarmaya" ve alt satırda **"Hoşgeldin"**.
- E-posta girdisi.
- Şifre girdisi.
- Sağ tarafta **"Şifremi unuttum"** bağlantısı: Şifremi Unuttum sayfasına gider.
- Giriş başarılıysa Ana Uygulamaya geçilir. Hatalı bilgide ilgili alan kırmızı olur ve kısa hata metni gösterilir.

### 2.5. Şifremi Unuttum Sayfası

- Metin: **"Çiçeğini kurtarmamız için emailini girebilirsin."**
- E-posta girdisi.
- **Kod Gönder** butonu.
- Butona basılınca altta **"Kod gönderildi"** yazısı çıkar (demo kapsamında gerçek e-posta gönderilmez).

### 2.5.1. Ana Sayfa (Sekme 1)

- Üst bar (kişiye özel çiçek logosu, isim, mod, dil) ve alt bar.
- **Çiçeğin Şu Anki Hali:** Çiçek illüstrasyonu büyük gösterilir. Çiçeğin boyu ve olgunluğu tamamen kayıtlı toplam odaklanma süresine bağlıdır.
- **Büyüme Aşamaları** (eşik değerleri yalnızca `core/constants/app_constants.dart` içinde tutulur; aşağıdakiler başlangıç önerisidir):

  | Aşama | Toplam süre eşiği |
  |---|---|
  | Tohum | 0 dk |
  | Filiz | 15 dk |
  | Fidan (ilk yapraklar) | 1 sa |
  | Yapraklı gövde | 3 sa |
  | Tomurcuk | 8 sa |
  | Açmış çiçek | 20 sa |
  | Olgun çiçek | 50 sa |

- **Solma ve Ölüm:** Son odaklanma/uygulama girişi üzerinden hesaplanır.
  - 7 gün giriş yoksa: çiçek **solgun** görünür, başı bükülür.
  - 30 gün giriş yoksa: çiçek **ölür**, kullanıcı **tohum** aşamasından baştan başlar.
  - Bu mantık controller'da saf Dart olarak yazılır ve birim test edilir.
- **"Odaklanmaya başla"** butonu: Tıklanınca Odaklanma Sayfasına geçer.

### 2.6. Odaklanma Sayfası

- Çiçek **ekranın tamamına yakın büyük** yerleşir. Çiçeğin o anki büyüme aşamasını gösterir.
- **Sayaç:** `00:00`'dan başlar, odaklanılan süreyi tutar (saat geçerse `SS:DD:SS`).
- Sayacın altında tek buton: **"Durdur"**. Ekranda başka hiçbir buton yoktur.
- Üst bar ve alt bar görünmez.
- **Kilit:** Bu sayfadayken diğer tüm uygulama butonları geçici olarak kilitlidir. Geri tuşu / geri kaydırma hareketi de engellenir (`PopScope`, `canPop: false`). Sadece "Durdur"a basılırsa Ana Sayfaya dönülür ve kilitler açılır.
- "Durdur"a basılınca süre kaydedilir (günlük kayda eklenir), çiçek ve istatistikler güncellenir.
- Ekranı açık tutmak için yerel çözüm tercih edilir; paket gerekiyorsa Bölüm 3'e göre onay alınır.

### 2.7. İstatistikler Sayfası (Sekme 2)

Yukarıdan aşağı:
1. Üst bar.
2. **Bugünkü Odaklanma Süresi:** örn. `45:56`.
3. **Haftalık Analiz** başlığı:
   - Haftalık grafik (son 7 gün).
   - Son 7 gün tablosu: her günün süresi dakika cinsinden.
4. **Aylık Grafik.**
   - Grafiğin altında, haftalık tabloya benzer **aylık toplam tablosu**.
5. En altta **en nihai toplam süre**.

- Grafikler öncelikle `CustomPainter` ile yerel olarak çizilir. `fl_chart` ancak onayla eklenir (Bölüm 3).

### 2.8. Topluluk Sayfası (Sekme 3)

1. Üst bar.
2. **Ülkeler Sıralaması (İlk 10):** Her ülkedeki tüm kullanıcıların toplam süresine göre sıralanır. Örn: Türkiye 52 gün, Amerika 51 gün, Fransa 50 gün 56 dk.
3. **Dünyada İlk 50:** Dünyadaki en iyi 50 profil; her satırda profil resmi/çiçek, isim, çizgi (streak) ve toplam süre.
4. **Filtrele:** Ülkeye göre filtreler. Alttan açılan bir modal (`showModalBottomSheet`) ile yapılır; buton sola dayalıdır.
5. **Etkileşim:** Bir kişiye tıklanınca o kişinin Kişi Profil Sayfası açılır.
6. "Hesabını toplulukta gösterme" seçeneğini işaretleyen kullanıcılar sıralamada ve listede görünmez.
7. Liste `ListView.builder` ile oluşturulur.

### 2.9. Kişi Profil Sayfası (Toplulukta tıklanıp gidilen)

- Üst bar ve alt bar görünür.
- **Profil bilgileri:** Google profil resmi, isim ve yaş (örn. "Mahmut Yılmaz, 57").
- Kişinin **çiçeğinin son durumu**.
- Kişinin **istatistikleri:** günlük, haftalık ve yıllık.
- Bu sayfa salt okunurdur; silme veya ayar butonu yoktur.

### 2.10. Kullanıcının Kendi Profil Sayfası (Sekme 4: Profil & Ayarlar)

- Üst bar ve alt bar görünür.
- **Profil resmi:** Google ile bağlandıysa Google resmi gelir. Yoksa boş avatar gösterilir ve kullanıcı dosya/galeriden resim seçebilir.
- **İsim ve yaş** (örn. "Ayşe Aydın, 36").
- Kullanıcının çiçeğinin son hali.
- **İstatistikler:** Kişi Profil Sayfasındaki istatistiklerin aynısı (aynı widget yeniden kullanılır).
- **İstatistikleri Sil** butonu: tutulan tüm değerleri sıfırlar. Önce onay penceresi (dialog) gösterilir.
- **Hesabı Sil** butonu: hesabı kalıcı olarak siler. Önce açık bir uyarı ve onay penceresi gösterilir.
- **Hesabını Toplulukta Gösterme** kutucuğu: işaretlenirse kullanıcı toplulukta görünmez.
- Mod ve dil ayarları üst barda zaten bulunur.

---

## 3. İzin Verilen ve Yasaklı Paketler

Ajan paket eklemeden önce paketin güncelliğini, bakım durumunu ve bilinen güvenlik açıklarını kontrol etmek zorundadır; kontrol edilmeden paket kurulmaz.

**Serbest (onaysız eklenebilir):**
- `flutter` çekirdek kütüphaneleri, `flutter_localizations` (TR/EN için `gen-l10n`), `dart:async`, `dart:math`, `dart:convert`
- `intl` (tarih ve süre biçimleri), `shared_preferences` (tema, dil, oturum ve yerel kayıtlar), `flutter_test`

**Proje sahibi onayıyla eklendi:**
- `google_fonts` (font seçimi stil dokümanında belirlenir)

**Onay gerektirir (eklemeden önce kullanıcıya sor):**
- `google_sign_in`, `image_picker`, `fl_chart`, `wakelock_plus`, `flutter_svg`, `lottie`, `go_router`, `country_picker`, ve Bölüm 6.1'de seçilen backend paketleri (örn. Firebase veya Supabase)
- Her biri için eklenme gerekçesi ve alternatifi (yerel çözüm) belirtilir.

**KESİNLİKLE YASAK:**
- Ağır state yönetim paketleri: `provider`, `riverpod`, `flutter_bloc`, `get`/`getx`, `mobx`, `redux`
- Bakımı bırakılmış (discontinued) veya son 2 yıldır güncellenmemiş paketler
- Bilinen güvenlik açığı bulunan paketler ve doğrulanmamış yayıncıdan gelen paketler
- Git/path bağımlılığı olarak dışarıdan çekilen kontrolsüz paketler

**Google ile giriş notu:** Gerçek Google OAuth için hesap/proje yapılandırması gerekir ve bu yapılandırmayı öğrenci yapar. Yapılandırma hazır olana kadar buton, aynı arayüzü kullanan bir **sahte (mock) giriş** servisine bağlanır. Servis soyut bir arayüz arkasında durur; gerçek `google_sign_in` entegrasyonu sonradan yalnızca bu uygulamayı değiştirir.

---

## 4. Veri ve Durum Kuralları

- **Oturum, tema ve dil:** `ValueNotifier` + `shared_preferences` ile saklanır.
- **Odaklanma kayıtları:** Her oturum için `başlangıç`, `süre (saniye)` ve `gün` bilgisi tutulur. Günlük, haftalık, aylık ve toplam değerler bu kayıtlardan **türetilir**; ayrıca saklanan çelişebilir toplamlar yoktur.
- **Topluluk verisi:** Şimdilik her feature kendi `data/` klasöründe `mock_<feature>_data.dart` dosyası tutar. En az 15 farklı ülkeden ve 60 sahte kullanıcı üretilir (İlk 10 ülke ve İlk 50 dünya listelerini doldurmak için). Controller'lar veriyi repository arayüzü üzerinden okur; gerçek backend Bölüm 6.1'de seçilince yalnızca repository uygulaması değişir.
- **Ülkeler:** Kayıt formundaki ülke seçici yerel bir sabit ülke listesinden beslenir (paket onaylanmadıkça).
- **Gizlilik:** "Toplulukta gösterme" kapalı olan kullanıcı hem sıralamalardan hem kişi listelerinden çıkarılır. Bu kontrol UI'da değil, controller'da yapılır.
- **Modeller:** `immutable`, `const` constructor, `copyWith`, `fromJson`, `toJson`.

---

## 5. Test Beklentileri

Aşağıdakiler için birim testleri yazılır (controller katmanı UI'dan bağımsız olduğu için kolayca test edilir):
- Şifre kuralları (8 karakter, büyük harf, küçük harf, sembol, eşleşme).
- Çiçek aşaması hesabı (toplam süre → aşama), 7 gün solma ve 30 gün ölüm kuralları.
- Günlük, haftalık, aylık toplam hesapları.
- Ülke sıralaması (İlk 10) ve dünya sıralaması (İlk 50), ülke filtresi ve "toplulukta gösterme" kapalıyken dışlama.

Widget testleri: Kayıt formunda hata durumunda kırmızı çerçeve ve kural metni görünmesi; Odaklanma sayfasında geri tuşunun engellenmesi.

---

## 6. Geliştirme Komutları ve Doğrulama

Ajan yaptığı her değişiklikten sonra sırasıyla çalıştırıp doğrular:

```bash
flutter pub get
flutter analyze   # 0 uyarı ve 0 hata şart
flutter test
flutter run
```

**Doğrulama:** Kod yazdıktan sonra kullanıcıya "Şimdi Flutter analiz ile kontrol edebilirsin." şeklinde doğrulama yönergeleri ver.

**Değişiklik Sunumları:** Örneğin 500 satırlık bir dosyada 3 satır değiştiyse tüm dosyayı baştan sona basma; hedef satırları ve diff yapısını göster. Yeni oluşturulan dosyalar tam içerikle verilir.
