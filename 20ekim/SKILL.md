### Bottom Navigation
| Sıra | Sekme | Dosya | İkon önerisi |
| 1 | Mentor | `features/mentor/view/mentor.dart` | `Icons.psychology_alt_rounded` |
| 2 | Yatırımcılar | `features/yatirimci/view/yatirimci.dart` | `Icons.rocket_launch_rounded` |
| 3 | Programlar | `features/programlar/view/programlar.dart` | `Icons.workspace_premium_rounded` |
| 4 | Topluluk | `features/topluluk/view/topluluk.dart` | `Icons.hub_rounded` |

- sekmeler `IndexedStack` içinde durumunu korur.
- "Fikir Durumum" ekranına Mentor sayfası üst çubuğundaki güzel ve dikkat çekici bir profil/durum rozetinden gidilir (5. sekme açılmaz).

### Özellik Sayfalarının İçerikleri

**Mentor (`mentor.dart`):** Mentor–menti eşleştirme. Mentor kartları (ad, uzmanlık alanları, sektör, deneyim yılı, müsaitlik, puan), uzmanlık/sektör filtreleri, "Eşleşme İste" akışı, eşleşme durumları (Beklemede / Eşleşti / Görüşme Planlandı), "Önerilen Mentorlar" (fikrin sektörüne göre) bölümü.

**Yatırımcılar (`yatirimci.dart`):** Kategori sekmeleri: **Şirketler / Holdingler / Melek Yatırımcılar / Girişim Sermayesi Fonları**. Her kart: ad, yatırım aşaması (tohum, Seri A…), ilgilendiği sektörler, bilet büyüklüğü aralığı, portföyden örnekler, iletişim bilgileri (e-posta, telefon, web — mock), "İletişime Geç" butonu. Filtre: aşama, sektör, bilet aralığı.

**Programlar (`programlar.dart`):** Kategori sekmeleri: **Hibe Programları / Devlet Destekleri / Yurtdışı Destekleri / Özel Sektör Destekleri / Kuluçka ve Hızlandırma Merkezleri**. Her kart: program adı, kurum, destek tutarı/kapsamı, uygunluk şartları, son başvuru tarihi, durum (Açık/Yakında/Kapandı), başvuru adımları, "Takvime Ekle" ve "Başvuru Bilgisi" aksiyonları.

**Topluluk (`topluluk.dart`):** Sade, X benzeri ama **basit** bir akış. Yalnızca **kabul edilmiş girişimciler** paylaşım yapabilir, beğenebilir ve yanıt yazabilir. Onaysız kullanıcılar akışı yalnızca okuyabilir ve alt kısımda "Paylaşım için fikrinin onaylanması gerekir" bilgisi görür. Kapsam: gönderi oluştur (metin, en fazla 280 karakter), beğen/beğenmekten vazgeç, gönderiye **tek seviyeli** yanıt. Kapsam dışı: takip sistemi, DM, hashtag, retweet, medya yükleme, bildirim.

**Analiz (ilk giriş):** Kullanıcıya "İş planın var mı?" sorulur. Evet ise çok sayfalı (stepper) analiz testi açılır. Bölümler:
1. **Fikir Özeti:** ad, sektör, problem, çözüm, hedef kitle
2. **Ekip:** kişi sayısı; her üye için ad, eğitim, uzmanlık, sorumluluk alanı, iletişim bilgisi
3. **Mevcut Durum / Traction:** müşteri kazanıldı mı, kaç ve kimler, hedefe yüzde kaç yakınlık, ciro, kâr durumu
4. **İnovasyon:** Ar-Ge ve teknolojik yenilik niteliği, yeterlilik oranı, mevcut çözümlerden farkı, uygulanabilirlik
5. **Plan Tabloları:** Gantt şeması (görev, başlangıç, bitiş), kilometre taşları, bütçe ve çıktı tutarlılığı
6. **Pazar:** ticarileşme planı, pazar analizi (TAM/SAM/SOM), müşteri analizi, rakipler
7. **Marka:** marka kurulumu, isim, konumlandırma, kanallar
8. **Özet ve Gönderim:** tüm cevapların gözden geçirilmesi, gönderim

Başvuruda bir yeri doldurmadan diğer yere de geçiş yapılabilir ilerlenebilir ama boş yerleri olan form gönderilemez. Hiç boş yer kalmamalı. Gönderilen başvuru uzman ekip incelemesine girer (mock'ta durum otomatik/sabit senaryolarla ilerler). Ara adımlarda taslak kaydı (`ValueNotifier` + yerel kayıt) tutulur.

**Fikir Durumu:** Başvuru aşamaları (Gönderildi → İnceleniyor → Revize İstendi / Onaylandı), onay sonrası **hukuki süreç zaman çizelgesi** (ücretsiz avukat ataması, şirket tipi seçimi, ticaret sicil kaydı, vergi kaydı, marka tescil başvurusu, ortaklık/sözleşme hazırlığı — Türkiye mevzuatına uygun adım adlandırmasıyla), atanan avukat kartı (mock), **gelir destek taahhüdü** durum kartı (aylık hedef, ilerleme).

- Uygulama içinde önceden kabul almış örnek fikirler ve ilerlemeleri bulunur (en az 6 fikir; farklı sektör ve aşamalarda; her birinin ekip, ilerleme yüzdesi, hukuki süreç adımı ve gelir destek durumu bulunur).
- Her feature kendi `data/` klasöründe `mock_<feature>_data.dart` dosyası tutar. Gerçek ağ isteği yoktur; controller'lar veriyi bu dosyalardan okur.

## 3. İzin Verilen ve Yasaklı Paketler

Ajan paket eklemeden önce paketin güncelliğini, bakım durumunu ve bilinen güvenlik açıklarını kontrol etmek zorundadır; kontrol edilmeden paket kurulmaz.

**Serbest (onaysız eklenebilir):**
- `flutter` çekirdek kütüphaneleri, `dart:async`, `dart:math`, `dart:convert`
- `intl` (tarih/para biçimleri), `shared_preferences` (taslak ve tema kaydı), `url_launcher` (mock link/telefon aksiyonları), `flutter_test`

**Onay gerektirir (eklemeden önce kullanıcıya sor):**
- `google_fonts`, `flutter_svg`, `cached_network_image`, `lottie`, `go_router`
- Her biri için eklenme gerekçesi ve alternatifi (yerel çözüm) belirtilir.

**KESİNLİKLE YASAK:**
- Ağır state yönetim paketleri: `provider`, `riverpod`, `flutter_bloc`, `get`/`getx`, `mobx`, `redux`
- Bakımı bırakılmış (discontinued) veya son 2 yıldır güncellenmemiş paketler
- Bilinen güvenlik açığı bulunan paketler ve doğrulanmamış yayıncıdan gelen paketler
- Git/path bağımlılığı olarak dışarıdan çekilen kontrolsüz paketler
- Gerçek ödeme, gerçek kimlik doğrulama veya gerçek ağ servisi paketleri (proje demo kapsamındadır)

---

## 4. Kırmızı Çizgiler (Kesinlikle Uyulması Gerekenler)

1 - **State Yönetim Standartları:**
Sayfa düzeyinde ağır `setState` kullanımından kesinlikle kaçın. Sadece yerel arayüz durumunu yöneten (örneğin buton animasyonları, yıldız alanı animasyonu vb.) `StatefulWidget` kabul edilir. State için `ValueNotifier` + `ValueListenableBuilder` kullanılır. Controller'lar `dispose()` ile temizlenir.

2 - **UI ve Performans Kuralları:**
- Statik tüm widget'larda `const` zorunludur.
- Renk ve metin stilleri kesinlikle tema dosyalarına yazılacaktır; widget içinde `Color(0xFF...)` veya sabit `TextStyle(fontSize: ...)` yazılmaz (`context.spaceColors` ve `Theme.of(context).textTheme` kullanılır).
- Büyük build metotları yasaktır. 40 satırı geçen `build` metotları özel widget sınıflarına ayrılacaktır.
- Uzun listelerde `ListView.builder` / `SliverList` kullanılır; `Column` içinde sınırsız liste yasaktır.

3 - **Asenkron ve BuildContext Güvenliği:**
`await` sonrasında `BuildContext` kullanılmadan önce `if (!context.mounted) return;` kontrolü zorunludur.

4 - **Mimari Disiplin:**
- Tek dosyada tüm kodu, UI + mantık + model toplamak yasaktır.
- Controller katmanı Flutter UI'dan bağımsız (saf Dart + `foundation`) kalır ve birim test edilebilir olur.
- Modeller `immutable` olur (`const` constructor, `copyWith`, `fromJson`, `toJson`).

5 - **Topluluk Yetki Kuralı:**
Paylaşım, beğeni ve yanıt aksiyonları yalnızca kullanıcı durumu **Onaylandı** ise etkinleştirilir. Bu kontrol UI'da değil, controller'da yapılır.

6 - **Onay Almadan Yapılmayacaklar:**
Projeye onay almadan harici state paketleri, yeni klasör düzeni değişikliği veya yeni sekme EKLENMEYECEKTİR. Dart'ın ve Flutter'ın yerel çekirdek API'lerini kullanmak esastır.

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

**Adım Adım İlerleme:** Büyük işler (analiz formu gibi) bölümlere ayrılır; her bölüm bittiğinde analiz ve test çalıştırılır, sonra sonraki bölüme geçilir.

**Doğrulama:** Kod yazdıktan sonra kullanıcıya "Şimdi Flutter analiz ile kontrol edebilirsin." şeklinde doğrulama yönergeleri ver.

**Değişiklik Sunumları:** Örneğin 500 satırlık bir dosyada 3 satır değiştiyse tüm dosyayı baştan sona basma; hedef satırları ve diff 
yapısını göster. Yeni oluşturulan dosyalar tam içerikle verilir.