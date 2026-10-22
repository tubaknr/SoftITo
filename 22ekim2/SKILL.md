# SKILL.md — Alışkanlık Takip Uygulaması Özellik ve İş Kuralları

Bu doküman uygulamanın **ne yapacağını** tanımlar. Mimari ve kod kuralları için `project.md`'ye uy. **Hiçbir görsel stil kararı (renk, gradyan, font, maskot çizimi, animasyon detayı, ikon seçimi) burada yoktur; bunlar `style.md`'dedir.** Stil gerektiren yerlerde yer tutucu widget kullan ve `style.md`'yi bekle.

---

## 1. Ekran Akışı

```text
Karşılama → Kayıt Ol → Kayıt Sonrası → (İlerle) → Ana Sayfa
Karşılama → Giriş Yap → Ana Sayfa
Giriş Yap → Şifremi Unuttum
```

Oturum açık kullanıcı uygulamayı açınca doğrudan Ana Sayfa'ya gider.

### 1.1 Karşılama Ekranı (`features/onboarding`)
- Marka mottosu: "Küçük adımlar, büyük hedeflerin ruhudur."
- Maskot alanı (penguen): yer tutucu widget; görsel `style.md` ile gelir.
- **Kayıt Ol** butonu (birincil) ve **Giriş Yap** (metin bağlantısı, altı çizili) bulunur.
- **Google ile devam et** seçeneği bulunur (bkz. 3.1).
- Ekranda dil (TR/EN) ve tema (aydınlık/karanlık) değiştirme erişimi bulunur.

### 1.2 Kayıt Formu
- Cesaretlendirici bir başlık metni: "Hedeflerine ulaşmak için" ile başlayan kısa, yumuşak bir cümle (l10n'de tutulur).
- Alanlar: **Ad, E-posta, Şifre, Şifre doğrulama**.
- Doğrulama kuralları:
  - Ad boş olamaz.
  - E-posta geçerli biçimde olmalı.
  - Şifre en az 8 karakter olmalı.
  - Şifre ve şifre doğrulama eşleşmeli.
- Hatalar alanın altında, l10n metinleriyle gösterilir. Form geçerli değilse gönderilemez.
- Başarılı kayıt → Kayıt Sonrası ekranı.

### 1.3 Kayıt Sonrası Ekranı
- Metin: "Hedeflerine ulaşmak için alışkanlıkların gücünden yararlanmaya hazır mısın?"
- Maskot (gülümseyen) alanı: yer tutucu.
- Altı çizili **İlerle** butonu → Ana Sayfa.

### 1.4 Giriş Yap Sayfası (`features/auth`)
- Alanlar: E-posta, Şifre. **Giriş Yap** butonu. Butonun yanında **Şifremi unuttum** bağlantısı.
- Hatalı bilgide anlaşılır l10n hata mesajı gösterilir.
- Güneş/arka plan gibi görsel unsurlar `style.md` kapsamındadır.
- Not: "Ekranlarda ilerledikçe görsel ilerleme" gibi görsel davranışlar, gerekiyorsa controller'dan bir ilerleme değeri (`ValueNotifier<double>`) olarak sunulur; nasıl görüneceği `style.md`'de belirlenir.

### 1.5 Şifremi Unuttum Sayfası
- Üstte metin: "Hedeflerine ulaşmak için e-mailini girebilirsin."
- E-posta alanı ve **Kod Gönder** butonu.
- E-posta geçerlilik kontrolü yapılır. Gönderim mock'tur (bkz. 7).

---

## 2. Ortak İskelet (`features/shell`)

### 2.1 Üst Çubuk (Topbar)
- Giriş sonrası **her sayfada** bulunur: "Hoşgeldin <Ad>" (örn. "Hoşgeldin Ayşe"). Ad kullanıcı oturumundan gelir; l10n parametreli metin kullanılır.
- Üst çubuk ortak bir widget olarak `core/widgets` veya `shell/widget` altında bir kez yazılır.

### 2.2 Bottom Navigation
| Sıra | Sekme | Dosya |
| 1 | Anasayfa | `features/home/view/home_page.dart` |
| 2 | Takvim | `features/calendar/view/calendar_page.dart` |
| 3 | Analiz & Grafikler | `features/analytics/view/analytics_page.dart` |
| 4 | Profil | `features/profile/view/profile_page.dart` |

- Sekmeler `IndexedStack` içinde durumunu korur.
- İkon seçimi `style.md`'dedir; yer tutucu kullan.
- "Tüm Alışkanlıklar" sayfası sekme değildir; Anasayfa'dan gidilir (yeni sekme eklenmez).

---

## 3. Özellik Sayfalarının İçerikleri

### 3.1 Kimlik Doğrulama ve Google OAuth
- Kimlik doğrulama soyut bir `AuthRepository` arayüzü arkasındadır: `signUp`, `signIn`, `signInWithGoogle`, `sendResetCode`, `signOut`, `currentUser`.
- Varsayılan uygulama **mock/yerel** olur (kullanıcı yerel kayıtta tutulur). Gerçek Google OAuth için `google_sign_in` paketi gerekir; **paket eklemeden önce kullanıcıdan onay al** (bkz. `project.md` Bölüm 4). Onay çıkana kadar `signInWithGoogle` mock davranır ve arayüz akışı çalışır.
- Şifre düz metin olarak yerel kayıtta tutulmaz; mock bile olsa bu kuralı uygulayan bir yapı (örn. basit bir hash katmanı) soyutlamanın arkasında kalır.

### 3.2 Ana Sayfa — Bugünün Alışkanlıkları (`features/home`)
- **Hiç alışkanlık yoksa:** Maskotlu boş durum: "Hiç alışkanlık eklememişsin!" (tatlı ve cesaretlendirici ton, l10n) + **Alışkanlık Ekle** butonu.
- **Alışkanlık varsa:** Bugün yapılması gereken alışkanlıklar alt alta listelenir (`ListView.builder`).
  - Her alışkanlığın solunda bir tamamlama kutusu (tick) bulunur.
  - Tamamlanınca: tick atılır, başlık üstü çizilir, tamamlanmış durum görseli tema/`style.md`'den gelir, kutlama animasyonu tetiklenir ve başarı bildirimi gönderilir (bildirim kullanıcının ayarına tabidir, bkz. 3.7).
  - Tamamlama geri alınabilir (tekrar dokununca).
  - Tamamlanmış alışkanlığa **dokununca** o güne ait duygu ve notu görüntülenir (bkz. 3.8).
  - Tamamlama sonrası isteğe bağlı duygu formu alttan açılır (bkz. 3.8).
- Üst kısımdan veya alışkanlık listesinden **Tüm Alışkanlıklar** sayfasına gidilir.
- Alt çubuk (bottom navigation) iskeletten gelir.

### 3.3 Tüm Alışkanlıklar (`features/habits`)
- Tüm alışkanlıklar listelenir. Her satırda **Düzenle** ve **Sil** aksiyonu bulunur.
- **Ekle** ve **Düzenle** aynı formu açar (`HabitFormSheet`/sayfa; tek bir form widget'ı iki mod).
- Silme öncesi onay diyaloğu gösterilir.
- Alışkanlık formu alanları:
  - Ad (zorunlu)
  - Açıklama (isteğe bağlı)
  - Tekrar günleri (haftanın günleri; en az 1 gün seçili olmalı)
  - Hatırlatma saati (isteğe bağlı)
  - Takvimde ayırt etmek için renk seçimi (renk paleti `style.md`'den gelen tema listesinden seçilir; kodda sabit renk yazılmaz — renk bir indeks/anahtar olarak saklanır)
- Boş ad ile kayıt edilemez.

### 3.4 Takvim (`features/calendar`)
- Varsayılan görünüm: **Aylık takvim**.
- Filtre ile görünüm değiştirilebilir: **Haftalık / 2 Haftalık / Aylık / 2 Aylık / 3 Aylık**.
- Her günün içinde o güne denk gelen **tüm alışkanlıklar** adlarıyla yazılır, her alışkanlık kendi seçilmiş rengiyle gösterilir.
- Takvim yerel widget'larla yazılır (takvim paketi yasak). Gün hücreleri çok alışkanlıkta taşmaz; sığmayan alışkanlıklar "+N" gösterimiyle özetlenir.
- Bir güne dokununca o günün alışkanlıkları ve tamamlanma durumları görülür.
- Gelecek günler tamamlanamaz.

### 3.5 Analiz & Grafikler (`features/analytics`)
- Üstte tüm alışkanlıkların **genel devamlılık ortalaması** (örn. %52) belirgin ve yumuşak bir sunumla gösterilir.
- Her alışkanlık için:
  - Tamamlama yüzdesi
  - Zaman çizelgesi (zaman içindeki tamamlama durumu)
  - Zaman aralığı filtresi (örn. 7 gün / 30 gün / 90 gün / tümü)
  - Duygu grafiği ve duygu yüzdesi/analizi (o alışkanlık için seçilen duyguların dağılımı)
- Tüm grafikler `CustomPainter` ile çizilir; grafik paketi yasak.
- Veri yoksa anlamlı bir boş durum gösterilir.
- Hesaplamalar controller'da/saf Dart fonksiyonlarında yapılır; widget yalnızca çizer.

### 3.6 Profil (`features/profile`)
- Profil resmi ve ad. (Resim seçimi için `image_picker` onay gerektirir; onay yokken yer tutucu avatar ve baş harf kullanılır.)
- Bölümler: **Alışkanlıklarım, Rozetlerim, Bildirimler, Notlarım**.
- **Duygu ortalaması** ve **duygu grafiği** (zaman içinde) gösterilir.
- **Notlarım:** Alışkanlık tamamlama sırasında yazılan tüm farkındalık notlarına buradan ulaşılır (tarih, alışkanlık, duygu, not).
- **Bildirimleri Kişiselleştirme** (bkz. 3.7) buradadır.
- Dil ve tema değiştirme, çıkış yapma buradadır.

### 3.7 Bildirimler (`features/notifications`)
Her bildirim türü profilden ayrı ayrı **açılıp kapatılabilir ve düzenlenebilir**:
1. **Başarı bildirimi:** Alışkanlık tamamlanınca.
2. **Günlük motivasyon cümlesi:** "Her gün motivasyon cümlesi bildirimi almak istiyorum" onay kutusu ile açılır/kapanır; saat seçilebilir.
3. **Kaçırılan gün uyarısı:** Alışkanlığın yapılmadığı gün motivasyon sözü + uyarı bildirimi.
4. **Gün içi hatırlatmalar:** "Haydi şimdi bir bardak su iç", "Birkaç sayfa kitap oku" tarzı kısa, nazik hatırlatmalar; açılıp kapanabilir, sıklığı seçilebilir.

Kurallar:
- Bildirim metinleri l10n'den gelir (TR/EN); motivasyon cümleleri ve hatırlatma metinleri sabit bir listede tutulur ve dönüşümlü seçilir.
- Bildirim zamanlama mantığı soyut bir `NotificationService` arayüzü arkasındadır. Gerçek yerel bildirim için `flutter_local_notifications` gerekir; **eklemeden önce onay al**. Onay çıkana kadar mock servis kullanılır ve ayarlar kaydedilir.
- Bildirim izni reddedilmişse kullanıcı bilgilendirilir; uygulama bozulmaz.

### 3.8 Duygu ve Farkındalık Notu (`features/reflection`)
- Alışkanlık tamamlanınca **isteğe bağlı** bir form **alttan açılan modal** (bottom sheet) olarak gelir; kullanıcı atlayabilir.
- İçerik:
  - Soru: "Bu alışkanlığı tamamlayınca nasıl hissettim?"
  - **Duygu seçimi:** sevimli emojilerden biri (sabit bir duygu enum'u: örn. çok iyi, iyi, nötr, kötü, çok kötü; her duygunun sayısal puanı vardır, ortalama hesabı bunu kullanır).
  - **"Bana neler düşündürdü"** serbest metin farkındalık notu (isteğe bağlı).
- Kaydedilen duygu/not o günün tamamlama kaydına bağlanır.
- Tamamlanmış alışkanlığa dokununca bu kayıt görüntülenir ve düzenlenebilir.
- Tamamlama geri alınırsa bağlı duygu/not için kullanıcıya onay sorulur.

### 3.9 Seri ve Rozet Sistemi (`features/badges`)
- **Seri:** Bir alışkanlığın ardışık tamamlanan gün/planlanan gün sayısıdır. Planlanan olmayan günler seriyi bozmaz.
- **Seri seviyeleri:** 21 gün → 42 gün → 84 gün ... (her seviye bir öncekinin iki katıdır). Seviye eşikleri sabit bir listede/fonksiyonda tutulur ve kolayca değiştirilebilir.
- **Rozetler:** Her motivasyon serisinde 5 tamamlayışta bir başarı rozeti kazanılır; seri seviyesi yükseldikçe rozetler artar. Rozet kuralı saf Dart sınıfında (`BadgeEngine`) yazılır ve birim testle doğrulanır.
- Kazanılan rozetler Profil > Rozetlerim bölümünde gösterilir; yeni rozet kazanılınca kutlama tetiklenir.
- Rozet görselleri `style.md` kapsamındadır; kodda rozetler bir `id` ve l10n başlığıyla tanımlanır.

---

## 4. Veri Modelleri (immutable)

Her model `const` constructor, `copyWith`, `fromJson`, `toJson` içerir.

- `UserProfile` — id, ad, e-posta, profil resmi yolu (opsiyonel), dil, tema modu
- `Habit` — id, ad, açıklama, tekrar günleri, hatırlatma saati, renk anahtarı, oluşturulma tarihi
- `HabitCompletion` — habitId, tarih (yalnızca gün), tamamlanma zamanı, opsiyonel `MoodEntry`
- `MoodEntry` — duygu (`Mood` enum), not, kayıt zamanı
- `Badge` — id, seviye, kazanılma tarihi, bağlı habitId
- `NotificationSettings` — her bildirim türü için açık/kapalı, saat, sıklık

---

## 5. Depolama ve Mock Veri

- Gerçek ağ isteği yoktur. Veriler `shared_preferences` üzerinden yerel olarak saklanır; erişim soyut bir `LocalStore`/repository arayüzü arkasındadır.
- Her feature, geliştirme ve test için örnek veri üreten bir `data/mock_<feature>_data.dart` dosyası tutabilir (örn. farklı tamamlama geçmişleri olan en az 5 örnek alışkanlık, çeşitli duygu kayıtları).
- Controller'lar veriyi repository arayüzünden okur; UI hiçbir zaman depoya doğrudan erişmez.
- Çıkış yapıldığında oturum verisi temizlenir; kullanıcı verisi saklama politikası açıkça `LocalStore` içinde belirlenir.

---

## 6. Test Beklentileri

Aşağıdakiler için birim test zorunludur:
- Kayıt/giriş form doğrulama kuralları
- Seri hesabı (planlanan olmayan günler, boşluklar, gün sınırı)
- Rozet kazanma kuralı ve seri seviyeleri
- Genel devamlılık ortalaması ve alışkanlık bazlı tamamlama yüzdesi
- Duygu ortalaması hesabı
- Takvim görünüm aralığı hesabı (haftalık, 2 haftalık, aylık, 2 aylık, 3 aylık)

Kritik akışlar için widget testi:
- Boş durum ve alışkanlık ekleme akışı
- Alışkanlık tamamlama ve geri alma
- Duygu modalının açılması ve atlanması

---

## 7. Geliştirme Sırası (Adım Adım İlerleme)

Her adım bittiğinde `flutter analyze` ve `flutter test` çalıştırılır, sonra sonraki adıma geçilir.

1. `core` iskeleti: tema/dil/l10n altyapısı (`ValueNotifier<ThemeMode>`, `ValueNotifier<Locale>`), `main.dart`
2. Modeller ve repository arayüzleri, mock servisler
3. `auth` + `onboarding` (karşılama, kayıt, kayıt sonrası, giriş, şifremi unuttum)
4. `shell` (üst çubuk + bottom navigation)
5. `habits` (form, liste, düzenle/sil) ve `home` (bugünün listesi, tamamlama)
6. `reflection` (duygu modalı ve not görüntüleme)
7. `badges` (seri ve rozet motoru)
8. `calendar`
9. `analytics`
10. `notifications` ve `profile`

---

## 8. Kesin Kurallar (Özet)

- Tüm metinler l10n'den gelir; TR ve EN eksiksiz olur.
- Renk ve metin stili yalnızca tema dosyalarından gelir; stil kararı bu dokümanda yoktur.
- State: `ValueNotifier` + `ValueListenableBuilder`; ağır state paketi yok.
- Grafik ve takvim paketi yok; yerel çizim/widget.
- Google OAuth, yerel bildirim ve profil resmi seçimi için paket eklemeden önce **kullanıcıdan onay alınır**.
- Yeni sekme, klasör düzeni değişikliği veya kapsam dışı özellik onaysız eklenmez.
