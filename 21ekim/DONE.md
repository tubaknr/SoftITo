# Focus & Grow (F&G) — Geliştirme ve Tamamlama Takip Raporu (DONE.md)

Bu doküman, `project.md`, `SKILL.md` ve `style.md_focus_grow_t_m_uygulama_k_lavuzu.txt` yönergeleri doğrultusunda yürütülen tüm geliştirme, mimari yapılandırma, tasarım ve test adımlarını kronolojik ve ayrıntılı olarak kayıt altına alır.

---

## 📋 Proje Özeti
- **Uygulama Adı:** Focus & Grow (kısa imza: **F&G**)
- **Motto:** *"Odaklanarak yaşamı daha derinden hissetmek ister misin?"*
- **Kapsam:** Odaklanma ve canlı çiçek büyütme, Deep Work / Pomodoro hassas zaman farkı sayacı, 7 gün solma & 30 gün ölüm kuralları, günlük/haftalık/aylık istatistikler, yerel CustomPainter grafikleri, Topluluk ülke (İlk 10) ve dünya (İlk 50) sıralaması, kişi profili ve kullanıcı profil & ayar yönetimi.
- **Tasarım Konsepti:** Pastel, organik, meditatif ve zarif (Soft Sunlight Sarı `#FFF7D6`, Sprout Sage `#D5E8D4`, Blush Petal `#FAD2E1`, Dusty Rose `#E8A598`). Gece/Gündüz çift tema gradyanları, Cormorant Garamond italik tipografisi, Glassmorphic yüzen alt bar, her sayfada sağ alt köşe `F&G` filigranı.
- **Mimari:** Feature-first + Katmanlı Ayrım (`controller`, `models`, `data`, `view`, `widget`).
- **Durum Yönetimi:** Harici paket olmaksızın saf reaktif `ValueNotifier` + `ValueListenableBuilder` (Provider, Riverpod, Bloc, GetX KESİNLİKLE kullanılmamıştır).
- **Geliştirme & Test Standartları:** `flutter analyze` 0 hata/0 uyarı, `flutter test` %100 başarı (25 test), Dart 3.x ve Flutter modern API standartları.

---

## 🚀 Görev İlerleme Çizelgesi

| # | Görev / Aşama | Durum | Açıklama |
|---|---|---|---|
| 1 | Proje İskeleti & Bağımlılıklar | [x] Tamamlandı | Flutter projesi başlatıldı; izinli paketler (`shared_preferences`, `intl`, `google_fonts`, `flutter_localizations`) yapılandırıldı. |
| 2 | Core: Renkler, Sabitler, Tipografi & Tema | [x] Tamamlandı | `app_colors.dart`, `app_constants.dart`, `app_typography.dart`, `app_theme.dart`, `theme_controller.dart`. |
| 3 | Core: Yerelleştirme (L10n TR/EN) & Dil Kontrolü | [x] Tamamlandı | Türkçe ve İngilizce çift dil desteği, anlık reaktif dil değişimi (`locale_controller.dart`, `app_localizations.dart`). |
| 4 | Core: CustomPainter Çiçek & Ortak Bileşenler | [x] Tamamlandı | 5 evreli + solma/ölüm durumlu CustomPainter canlı çiçek (`flower_painter.dart`), `GradientScaffold`, `FGTopBar`, `FGBottomBar`, butonlar, inputlar. |
| 5 | Feature: Auth & Karşılama Akışı | [x] Tamamlandı | Landing (`welcome_page`), Register (şifre ve form validasyonları), Transition (`welcome_transition_page`), Login, Forgot Password. |
| 6 | Feature: Shell & Navigasyon | [x] Tamamlandı | 4 sekmeli yüzen cam efektli Bottom Bar (`IndexedStack`), Home, Stats, Community, Profile yönlendirmesi. |
| 7 | Feature: Home & Çiçek Evrimi Mantığı | [x] Tamamlandı | Çiçek büyüme seviyesi rozeti, 7 gün solma / 30 gün ölüm kontrolü, nefes alan pulsasyon odaklanma butonu. |
| 8 | Feature: Odaklanma Oturumu (Focus Session) | [x] Tamamlandı | Tam ekran kilitli mod (`PopScope(canPop: false)`), `DateTime` farkı ile hassas sayaç, dev çiçek, durdurma ve süre kaydı. |
| 9 | Feature: İstatistikler (Stats) | [x] Tamamlandı | Bugünkü süre, 7 günlük haftalık CustomPainter çubuk grafik ve döküm tablosu, aylık trend çizgi grafik ve toplamlar. |
| 10 | Feature: Topluluk (Community) | [x] Tamamlandı | İlk 10 Ülke sıralaması, İlk 50 Dünya liderlik tablosu (`ListView.builder`), ülke filtre modalı, gizlilik filtresi, salt okunur kişi profili. |
| 11 | Feature: Profil & Ayarlar | [x] Tamamlandı | Avatar, isim/yaş düzenleme, çiçek durumu, istatistikleri sıfırlama, hesabı silme dialogu, toplulukta gösterme gizlilik toggle'ı. |
| 12 | Birim & Widget Testleri, Analiz & Doğrulama | [x] Tamamlandı | Form kuralları, çiçek yaşam döngüsü, istatistik türetme, sıralama & filtreleme ve widget testleri (25 test %100 başarılı). `flutter analyze` 0 hata/0 uyarı. |

---

## 📝 Detaylı İşlem Günlüğü

### 1. Proje İskeleti & Bağımlılıklar
- [pubspec.yaml](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/pubspec.yaml): Flutter 3.x ve Dart 3.x ortamında `com.focusandgrow.focus_and_grow` paket adıyla oluşturuldu.
- İzin verilen temel paketler eklendi:
  - `shared_preferences: ^2.2.2` (tema, dil, oturum ve yerel kayıtlar)
  - `intl: ^0.20.2` (tarih ve süre biçimleri)
  - `google_fonts: ^6.1.0` (Cormorant Garamond italik fontu)
  - `flutter_localizations` (Türkçe ve İngilizce yerelleştirme desteği)
- Harici ağır state paketleri (`provider`, `riverpod`, `bloc`, `getx`, `mobx`) KESİNLİKLE kullanılmamış, mimari saf Dart ve reaktif `ValueNotifier` ile kurulmuştur.

### 2. Core Katmanı (Sabitler, Renkler, Tipografi, Tema & Durum)
- [lib/core/constants/app_colors.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/core/constants/app_colors.dart): Pastel renk paleti (`sunlightYellow: #FFF7D6`, `sproutSage: #D5E8D4`, `blushPetal: #FAD2E1`, `dustyRoseAccent: #E8A598`, `coralRedError: #E57373`, `stopButtonRed: #DF828A`, `darkBackground: #1E2522`, `darkCardSurface: #2B332F`, `lightAppGradient`, `darkAppGradient`, `primaryButtonGradient`).
- [lib/core/constants/app_constants.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/core/constants/app_constants.dart): Çiçek aşama eşikleri (Tohum: 0, Filiz: 15 dk, Fidan: 1 sa, Gövde: 3 sa, Tomurcuk: 8 sa, Açmış çiçek: 20 sa, Olgun çiçek: 50 sa), 7 gün solma ve 30 gün ölüm sınırları.
- [lib/core/theme/app_typography.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/core/theme/app_typography.dart): Cormorant Garamond italik tipografi hiyerarşisi (`heroDisplay`, `timerDisplay`, `heading1Light`, `heading1Bold`, `heading2`, `mottoText`, `inputLabel`, `watermark`, `buttonText`, `underlineLink`).
- [lib/core/theme/app_theme.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/core/theme/app_theme.dart): Aydınlık ve karanlık tema tanımları, `CardThemeData`, `DialogThemeData`, 20px radiuslu cam efektli `InputDecorationTheme`.
- [lib/core/theme/theme_controller.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/core/theme/theme_controller.dart): `ValueNotifier<ThemeMode>` ve SharedPreferences ile kalıcı anlık tema değiştirici.
- [lib/core/l10n/app_localizations.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/core/l10n/app_localizations.dart): Türkçe ve İngilizce tüm ekran metinlerini sağlayan yerelleştirme delegesi.
- [lib/core/l10n/locale_controller.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/core/l10n/locale_controller.dart): `ValueNotifier<Locale>` ve SharedPreferences tabanlı TR/EN dil kontrolörü.
- [lib/core/extensions/context_extensions.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/core/extensions/context_extensions.dart): `context.loc`, `context.isDark`, `context.textTheme` pratik bağlam erişimleri.

### 3. Core Widget'lar & Canlı Çiçek İllüstrasyonu
- [lib/core/widgets/flower_painter.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/core/widgets/flower_painter.dart): Harici resim dosyası gerektirmeyen `CustomPainter` canlı çiçek illüstrasyonu. Tohum, filiz, uzayan fidan, yapraklı gövde, renklenen tomurcuk, açmış pastel taç yapraklar, olgun çiçek, 7 gün solgun bükük baş ve 30 gün ölüm döküntüsü evrelerini pürüzsüz rüzgar salınımı animasyonuyla çizer.
- [lib/core/widgets/gradient_scaffold.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/core/widgets/gradient_scaffold.dart): Tüm ekranları saran pastel gradyan zemin ve sağ alt köşede %60 opaklıkta `F&G` filigranı.
- [lib/core/widgets/fg_top_bar.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/core/widgets/fg_top_bar.dart): Auth akışında sadece tema/dil ikonu; uygulama içinde mini çiçek logosu, "Hoşgeldin," + kullanıcı adı, dönen Güneş/Ay animasyonu ve TR|EN pill seçicisi.
- [lib/core/widgets/fg_bottom_bar.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/core/widgets/fg_bottom_bar.dart): Ekran altından 12px yukarıda yüzen (Floating Dock) `BackdropFilter` (Blur 15) cam efektli 4 sekmeli menü.
- [lib/core/widgets/fg_buttons.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/core/widgets/fg_buttons.dart): `PrimaryPillButton` (54px pastel gül gradyanı), `PulsingFocusButton` (3 saniyelik nefes alan nabız pulsasyon animasyonu), `StopButton` (pastel kırmızı durdurma butonu), `GoogleOAuthButton` (özel çizilmiş Google G ikonu).
- [lib/core/widgets/fg_text_field.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/core/widgets/fg_text_field.dart): 20px radiuslu cam dolgulu, kural ihlalinde anında kırmızı çerçeveye ve alt uyarı metnine dönüşen input alanı.

### 4. Feature: Auth & Karşılama Akışı
- [lib/features/auth/models/user_model.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/features/auth/models/user_model.dart): Değişmez (immutable) kullanıcı modeli.
- [lib/features/auth/data/auth_repository.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/features/auth/data/auth_repository.dart): Soyut repository arayüzü.
- [lib/features/auth/data/mock_auth_data.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/features/auth/data/mock_auth_data.dart): SharedPreferences tabanlı yerel kullanıcı oturumu ve mock Google OAuth desteği.
- [lib/features/auth/controller/auth_controller.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/features/auth/controller/auth_controller.dart): Saf Dart doğrulama motoru (8 karakter, 1 büyük, 1 küçük, 1 sembol, eşleşme denetimi, email regex, yaş denetimi).
- [lib/features/auth/view/welcome_page.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/features/auth/view/welcome_page.dart): Giriş sayfası (büyük açmış çiçek, başlık, motto, Register, Giriş Yap, Google OAuth).
- [lib/features/auth/view/register_page.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/features/auth/view/register_page.dart): "Sana nasıl hitap edelim?", isim, e-posta, şifre, şifre onay, yaş, modal ülke seçici ve hata doğrulama arayüzü.
- [lib/features/auth/view/welcome_transition_page.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/features/auth/view/welcome_transition_page.dart): "Merhaba {isim}" ve altı çizili tıklanabilir "<u>ilerle</u>" geçiş ekranı.
- [lib/features/auth/view/login_page.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/features/auth/view/login_page.dart): "Doğanın tadını çıkarmaya Hoşgeldin", e-posta, şifre, "Şifremi unuttum" bağlantısı ve giriş aksiyonu.
- [lib/features/auth/view/forgot_password_page.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/features/auth/view/forgot_password_page.dart): "Çiçeğini kurtarmamız için emailini girebilirsin.", kod gönder aksiyonu ve "Sıfırlama kodu gönderildi" bildirimi.

### 5. Feature: Odaklanma (Focus) & Çiçek Evrim Algoritması
- [lib/features/focus/models/focus_session_model.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/features/focus/models/focus_session_model.dart): Değişmez oturum modeli.
- [lib/features/focus/data/focus_repository.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/features/focus/data/focus_repository.dart): Soyut repository arayüzü.
- [lib/features/focus/data/mock_focus_data.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/features/focus/data/mock_focus_data.dart): SharedPreferences tabanlı oturum kaydı ve ilk açılış örnek verileri.
- [lib/features/focus/controller/focus_controller.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/features/focus/controller/focus_controller.dart): `DateTime.difference` ile kare atlamasız kesin sayaç mekanizması, 7 gün solma ve 30 gün ölüm kural hesaplayıcısı, doğal süre biçimlendiricisi.
- [lib/features/focus/view/focus_session_page.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/features/focus/view/focus_session_page.dart): Tam ekran kilitli mod (`PopScope(canPop: false)`), üst ve alt barlar tamamen gizli, dev canlı çiçek, zarif `00:45:56` sayacı ve tek aksiyon olarak pastel kırmızı "Durdur" butonu.

### 6. Feature: Ana Sayfa (Home)
- [lib/features/home/view/home_page.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/features/home/view/home_page.dart): Çiçeğin son hali, seviye/evre rozeti ("Tomurcuk Evresi"), toplam odaklanma kartı, merkezde nefes alan nabız animasyonlu "Odaklanmaya başla" butonu.

### 7. Feature: İstatistikler (Stats)
- [lib/features/stats/controller/stats_controller.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/features/stats/controller/stats_controller.dart): Son 7 günün gün gün dökümünü ve 4 haftalık trendini hesaplayan saf Dart sınıfı.
- [lib/features/stats/widget/weekly_chart_painter.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/features/stats/widget/weekly_chart_painter.dart): Son 7 günün dakikalarını çizen pastel gradyanlı çubuk grafik `CustomPainter`.
- [lib/features/stats/widget/monthly_chart_painter.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/features/stats/widget/monthly_chart_painter.dart): 4 haftalık trend eğrisi ve yumuşak dolgulu çizgi grafik `CustomPainter`.
- [lib/features/stats/view/stats_page.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/features/stats/view/stats_page.dart): Bugünkü süre vitrin kartı (`45:56`), haftalık grafik ve döküm tablosu, aylık grafik ve döküm tablosu, tüm zamanlar toplam odaklanma kartı.

### 8. Feature: Topluluk (Community) & Profil
- [lib/features/community/models/community_user_model.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/features/community/models/community_user_model.dart): Topluluk kullanıcısı ve ülke sıralama modelleri.
- [lib/features/community/data/community_repository.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/features/community/data/community_repository.dart): Soyut repository.
- [lib/features/community/data/mock_community_data.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/features/community/data/mock_community_data.dart): 16 farklı ülkeden 60 sahte kullanıcı (İlk 10 ülke ve İlk 50 dünyayı besleyen, gizli profil içeren gerçekçi veri seti).
- [lib/features/community/controller/community_controller.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/features/community/controller/community_controller.dart): Gizli kullanıcıları (`isPrivate == true`) sıralama ve listelerden eleyen, ülke sürelerini toplayıp İlk 10'u ve dünya genelinde İlk 50'yi üreten saf Dart motoru.
- [lib/features/community/view/community_page.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/features/community/view/community_page.dart): Ülkeler Sıralaması (İlk 10) yatay kartları, sola dayalı filtre butonu, modal bottom sheet ülke seçici, Dünyada İlk 50 `ListView.builder` listesi.
- [lib/features/profile/widget/profile_stats_card.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/features/profile/widget/profile_stats_card.dart): Kişi profilinde ve kullanıcının kendi profilinde ortak kullanılan yeniden kullanılabilir Günlük/Haftalık/Yıllık istatistik kartı.
- [lib/features/community/view/public_profile_page.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/features/community/view/public_profile_page.dart): Toplulukta bir kişiye dokunulduğunda açılan salt okunur vitrin profili (çiçek, isim, yaş, ülke, seri ve istatistik kartı).
- [lib/features/profile/view/profile_page.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/features/profile/view/profile_page.dart): Kullanıcının kendi profili (avatar, isim/yaş, çiçeğin anlık durumu, kişisel istatistikler, "Hesabını toplulukta gösterme" toggle'ı, "İstatistikleri Sil" onay dialogu ve "Hesabı Sil" iki adımlı güvenlik dialogu).

### 9. Feature: Shell & Kök Giriş Kapısı
- [lib/features/shell/controller/shell_controller.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/features/shell/controller/shell_controller.dart): `IndexedStack` sekme yöneticisi.
- [lib/features/shell/view/shell_view.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/features/shell/view/shell_view.dart): Üst bar, 4 sekmeli alt bar ve `IndexedStack` kabuğu.
- [lib/main.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/main.dart): Anlık reaktif tema ve dil desteği ile `AppRootGate` yönlendirmesi.

### 10. Testler ve Doğrulama
- [test/auth_validation_test.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/test/auth_validation_test.dart): 8 birim testi (8 karakter, büyük/küçük harf, sembol, parola eşleşmesi, email regex, yaş kontrolü).
- [test/flower_evolution_test.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/test/flower_evolution_test.dart): 9 birim testi (Tohum, filiz, fidan, yapraklı gövde, tomurcuk, açmış çiçek, olgun çiçek, 7 gün solgunluk, 30 gün ölüm/sıfırlanma).
- [test/stats_calculation_test.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/test/stats_calculation_test.dart): 2 birim testi (Son 7 gün ve aylık 4 haftalık hesaplama).
- [test/community_ranking_test.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/test/community_ranking_test.dart): 4 birim testi (İlk 10 ülke sıralaması, İlk 50 dünya listesi, ülke filtresi, gizli profillerin elenmesi, kullanıcının dünya ve ülke sıralama derecesi).
- [test/widget_test.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/test/widget_test.dart): 4 widget testi (Uygulama açılışı, kayıt formu hata gösterimi, odaklanma oturumu `PopScope.canPop == false` kilit denetimi ve Karşılama ekranında 'İlerle' butonuna tıklandığında ShellView/Ana Sayfaya geçiş denetimi).
- **Toplam: 27 testin tamamı (%100) başarıyla geçti.**
- `flutter analyze`: **0 hata, 0 uyarı (No issues found).**

### 11. Karşılama Ekranı "İlerle" Navigasyon İyileştirmesi
- **Sorun Tespiti:** Kayıt sonrası açılan `WelcomeTransitionPage` ekranında "ilerle" linki yalnızca `ShellController` durumunu sıfırlıyor, ancak `Navigator` rotası `pushAndRemoveUntil` ile ana kabuğa yönlendirilmediği için rota yığında kalarak geçiş gerçekleşmiyordu. Ayrıca salt metin içi jest algılayıcısının dokunma alanı (hitbox) bazı platformlarda dar kalabiliyordu.
- **Uygulanan Çözüm:**
  - [lib/features/auth/view/welcome_transition_page.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/features/auth/view/welcome_transition_page.dart): `TapGestureRecognizer` bellek sızıntısını önlemek için `StatefulWidget` yaşam döngüsüne bağlandı.
  - Tıklama tetiklendiğinde `Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => ShellView(...)), (route) => false)` çağrılarak yığındaki tüm ara auth rotaları temizlendi ve doğrudan ana kabuk (`ShellView`) açıldı.
  - Tasarım kılavuzundaki hitbox standartları (asgari 48x48px) gereğince altı çizili metne ek olarak ekranın altına zarif bir `PrimaryPillButton` ("İlerle") yerleştirildi; her iki dokunma noktasında da anında ana sayfaya geçiş sağlandı.
  - Diğer ekranlardaki (`login_page.dart`, `welcome_page.dart`, `profile_page.dart`) rota temizleme akışları da aynı tutarlı mimariyle güvence altına alındı.

### 12. F&G Filigranının (Watermark) Kaldırılması
- [lib/core/widgets/gradient_scaffold.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/core/widgets/gradient_scaffold.dart): Kullanıcı talebi doğrultusunda tüm ekranların sağ alt köşesinde yer alan `F&G` filigranı ve onu saran Stack katmanı tamamen kaldırıldı. Sayfa içerikleri ve scaffold yapısı bozulmadan doğrudan arındırıldı.

### 13. Topluluk Kişi Profili: Sıralama, Toplam Süre & Özel Grafikler
- [lib/features/community/controller/community_controller.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/features/community/controller/community_controller.dart): Kullanıcının dünya genelindeki sırasını (`computeUserWorldRank`) ve kendi ülkesindeki sırasını (`computeUserCountryRank`) hesaplayan saf Dart fonksiyonları eklendi.
- [lib/features/stats/controller/stats_controller.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/features/stats/controller/stats_controller.dart): Kişinin haftalık ve aylık sürelerine dayalı 7 günlük çubuk ve 4 haftalık trend analizi veri üretim motoru eklendi.
- [lib/features/community/view/public_profile_page.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/features/community/view/public_profile_page.dart): Kişi profil sayfası baştan aşağı zenginleştirildi:
  - **Dünya Sıralaması Rozeti:** `🌍 Dünyada X.`
  - **Ülke Sıralaması Rozeti:** `🇹🇷 Ülkesinde Y.`
  - **Toplam Odaklanma Süresi:** Büyük pastel gül gradyanlı vurgu kartı.
  - **Canlı Çiçek İllüstrasyonu:** Büyüme evresi ve animasyonu.
  - **Haftalık Analiz:** `WeeklyChartPainter` ile çizilen pastel çubuk grafik ve 7 günlük döküm tablosu.
  - **Aylık Trend:** `MonthlyChartPainter` ile çizilen eğri grafik ve 4 haftalık döküm tablosu.
  - **Özet Tablo:** Günlük, haftalık ve yıllık süre özeti kartı.

### 14. Profil ve Ayarlar Sayfasına "Çıkış Yap" Butonu Eklenmesi
- [lib/core/l10n/app_localizations.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/core/l10n/app_localizations.dart): `logoutButton`, `logoutDialogTitle` ve `logoutDialogMessage` çoklu dil dizgeleri eklendi.
- [lib/features/profile/view/profile_page.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/features/profile/view/profile_page.dart):
  - "Hesabı Sil" butonunun hemen altına, onunla birebir aynı tasarım parametrelerine (`foregroundColor: AppColors.coralRedError`, 50px yükseklik, 1.2px kenarlık kalınlığı, 25px yuvarlatılmış köşe, `Icons.logout_rounded` simgesi, italik kalın yazı) sahip **"Çıkış Yap"** butonu yerleştirildi.
  - Tıklandığında onay iletişim kutusu (`_showLogoutDialog`) açılır.
  - Onaylandığında `AuthController.instance.logout()` çağrılarak mevcut oturum sonlandırılır, `onLogoutOrDelete()` tetiklenir ve `Navigator.pushAndRemoveUntil` ile rota yığını tamamen temizlenerek en baştaki `WelcomePage` ekranına güvenli ve temiz bir şekilde dönülür.
- [lib/core/widgets/gradient_scaffold.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/core/widgets/gradient_scaffold.dart): Sayfaların altındaki `F&G` filigranı tamamen kaldırılmış olup hiçbir layout ve içerik bozulmamıştır.
- **Doğrulama:** `flutter analyze` 0 hata ile tamamlandı, 27 birim ve widget testinin tamamı başarıyla geçti.

### 15. Tipografi ve Google Fonts Entegrasyonu (EB Garamond & Plus Jakarta Sans)
- **Kullanıcı Talebi Doğrultusunda:**
  - **Headline ve Body (Başlıklar ve Gövde Metinleri):** `GoogleFonts.ebGaramond()` ve `GoogleFonts.ebGaramondTextTheme()`.
  - **Label (Giriş Etiketleri, Butonlar ve Küçük Etiketler):** `GoogleFonts.plusJakartaSans()` ve `GoogleFonts.plusJakartaSansTextTheme()`.
- [lib/core/theme/app_theme.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/core/theme/app_theme.dart):
  - `_buildTextTheme(Brightness brightness)` fonksiyonu oluşturuldu. `GoogleFonts.ebGaramondTextTheme(baseTheme)` ile tüm başlıklar ve gövde metinleri EB Garamond'a bağlandı; `labelLarge`, `labelMedium` ve `labelSmall` stilleri `GoogleFonts.plusJakartaSansTextTheme(baseTheme)` ile ezilerek etiketler için Plus Jakarta Sans sağlandı.
  - Hem `lightTheme` hem de `darkTheme` içerisine bu `textTheme` entegre edildi.
- [lib/core/theme/app_typography.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/core/theme/app_typography.dart):
  - `heroDisplay`, `timerDisplay`, `heading1Light`, `heading1Bold`, `heading2`, `mottoText`, `body`, `underlineLink`, `watermark`: `GoogleFonts.ebGaramond` kullanacak şekilde güncellendi.
  - `inputLabel`, `labelLarge`, `labelMedium`, `labelSmall`, `errorCaption`, `buttonText`: `GoogleFonts.plusJakartaSans` kullanacak şekilde güncellendi.
- [lib/core/widgets/fg_bottom_bar.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/core/widgets/fg_bottom_bar.dart) & [lib/core/widgets/fg_text_field.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/core/widgets/fg_text_field.dart) & [lib/core/widgets/fg_top_bar.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/core/widgets/fg_top_bar.dart):
  - Tüm sekme ve giriş etiketleri, yer tutucuları ve buton etiketleri `GoogleFonts.plusJakartaSans` ile uyumlu hale getirildi.
- **Doğrulama:** `flutter analyze` 0 hata ile tamamlandı, 27/27 test başarıyla geçti.

### 16. Tam Ekran Odaklanma Modu, Ekran Küçültüldüğünde Otomatik Kaydetme & macOS Ağ İzinleri
- [macos/Runner/DebugProfile.entitlements](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/macos/Runner/DebugProfile.entitlements) & [macos/Runner/Release.entitlements](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/macos/Runner/Release.entitlements):
  - macOS Sandbox ortamında `fonts.gstatic.com` üzerinden Google Fonts indirilmesini engelleyen soket kısıtlaması `com.apple.security.network.client: true` izni eklenerek kalıcı olarak çözüldü.
- [macos/Runner/MainFlutterWindow.swift](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/macos/Runner/MainFlutterWindow.swift):
  - `focus_and_grow/window` adında yerel `FlutterMethodChannel` eklendi.
  - `enterFullScreen`, `exitFullScreen` ve `isFullScreen` fonksiyonları macOS `NSWindow.toggleFullScreen` mekanizmasına bağlandı.
  - `NSWindow.willExitFullScreenNotification` ve `NSWindow.didMiniaturizeNotification` olayları dinlenerek pencere küçültüldüğünde veya tam ekrandan çıkıldığında Flutter tarafına `onWindowShrink` sinyali gönderecek yapı kuruldu.
- [lib/features/focus/view/focus_session_page.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/features/focus/view/focus_session_page.dart):
  - **Tam Ekran Kapsama:** "Odaklanmaya Başla" butonuna basıldığında mobilde `SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky)` ile tüm sistem çubukları kilitlenerek tam ekran açılır; macOS'ta pencere tam ekran moduna geçer.
  - **Arka Plandaki Uygulamalara Erişimi Engelleme:** Mobilde `PopScope(canPop: false)` ile geri tuşu ve sistem hareketleri engellenir; kullanıcı uygulamadan çıkmaya çalışıp arka plana attığında (`WidgetsBindingObserver.didChangeAppLifecycleState`: `paused`, `inactive`, `hidden`), sayaç derhal durdurulur ve süre anında kaydedilir ("Durdur" butonuna basılmış gibi davranır).
  - **Ekran Küçültme Algılama:** Hem macOS bildirimleri (`onWindowShrink`) hem de pencere boyut değişimleri (`didChangeMetrics`) ile pencere küçültüldüğünde sayaç otomatik durdurulup süre kaydedilir ve ekran kapatılır.
  - **Durdur Butonu:** "Durdur" butonuna basıldığında süre kaydedilir, tam ekrandan çıkılır (`SystemUiMode.edgeToEdge` / `exitFullScreen`) ve ana sayfaya dönülür.
- **Doğrulama:** `flutter analyze` 0 hata verdi, 28/28 birim ve widget testi başarıyla geçti.

### 17. "Odaklanmaya Başla" Dairesel Butonu Tipografi & Düzen İyileştirmesi
- [lib/core/widgets/fg_buttons.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/core/widgets/fg_buttons.dart):
  - Dairesel odak butonundaki metnin ("Odaklanmaya") kelime ortasından hece bölünmesine ("Odaklanmay / a başla") uğramaması için:
    - Buton çapı 120px'ten 124px'e çıkarıldı.
    - Yatay iç dolgu (padding) 12px'ten 10px'e çekilerek metin genişliği rahatlatıldı.
    - Metin boyutu (`fontSize`) 14'ten 12'ye ayarlandı ve satır yüksekliği (`height: 1.15`) optimize edildi.
    - `maxLines: 2` ile metin artık hiçbir kelime bölünmeden zarifçe "Odaklanmaya" (1. satır) ve "Başla" (2. satır) olarak konumlandırıldı.
- **Doğrulama:** `flutter analyze` 0 hata ile tamamlandı, 28/28 birim ve widget testinin tamamı başarıyla geçti.

### 18. SKILL.md Kılavuzu ile Tam Senkronizasyon (Bölüm 2.5 & 2.6)
- [SKILL.md](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/SKILL.md):
  - Bölüm 1.4'teki F&G filigranı yönergesi kaldırıldı.
  - Bölüm 2.5'e *"Uygulama ekranı büyür tüm ekranı kaplar. Ekran eğer küçültülürse sayaç durur, süre kaydedilir. Durdur butonuna basılınca da sayaç durur, süre kaydedilir."* şartnamesi eklendi.
- [lib/features/focus/view/focus_session_page.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/features/focus/view/focus_session_page.dart) & [macos/Runner/MainFlutterWindow.swift](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/macos/Runner/MainFlutterWindow.swift):
  - Kılavuzdaki bu davranış kod tabanında tam olarak hayata geçirildi:
    1. **"Odaklanmaya Başla" Tıklandığında:** Uygulama ekranı tam ekran moduna büyüyerek tüm ekranı kaplar (`SystemUiMode.immersiveSticky` / `enterFullScreen`).
    2. **Ekran Küçültüldüğünde:** Pencere küçültüldüğünde (`onWindowShrink`), boyut küçültüldüğünde (`didChangeMetrics`) veya uygulama arka plana atıldığında (`didChangeAppLifecycleState`), sayaç anında durur ve süre kaydedilir ("Durdur" butonuna basılmış gibi davranır).
    3. **"Durdur" Butonuna Basıldığında:** Sayaç durur, süre kaydedilir, tam ekrandan çıkılarak ekran normale küçülür (`exitFullScreen` / `SystemUiMode.edgeToEdge`) ve ana sayfaya dönülür.
- **Doğrulama:** `flutter analyze` 0 hata/uyarı; 28/28 birim ve widget testinin tamamı başarıyla geçti.

### 19. macOS Swift Derleme Hatasının Düzeltilmesi (MainFlutterWindow.swift)
- [macos/Runner/MainFlutterWindow.swift](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/macos/Runner/MainFlutterWindow.swift):
  - Swift derleyicisinin `missing argument label 'arguments:' in call` hatası giderildi: `invokeMethod("onWindowShrink", arguments: nil)` olarak güncellendi.
- **Doğrulama:**
  - `flutter build macos --debug` komutu başarıyla derlendi (`✓ Built build/macos/Build/Products/Debug/focus_and_grow.app`).
  - `flutter analyze`: **0 hata, 0 uyarı** (`No issues found!`).
  - `flutter test`: 28 birim ve widget testinin tamamı başarıyla geçti (`28/28 passed`).

### 20. Tam Ekrana Geçişte Sayfadan Erken Çıkma Sorununun Giderilmesi
- **Sorun:** "Odaklanmaya Başla" butonuna tıklandığında ekran tam ekrana büyürken, macOS pencere geçişi esnasında `didChangeMetrics` ve `AppLifecycleState` olaylarının anlık dalgalanması sebebiyle sayfa henüz oturmadan `_handleStop()` tetikleniyor ve kullanıcıyı yeniden ana sayfaya atıyordu (kullanıcının tam ekran olduktan sonra butona tekrar basması gerekiyordu).
- **Uygulanan Çözüm:**
  - [lib/features/focus/view/focus_session_page.dart](file:///Users/d1-20/Documents/GitHub/SoftITo/21ekim/lib/features/focus/view/focus_session_page.dart):
    - `_isReady` durum kilidi eklendi.
    - Tam ekrana geçiş animasyonu tamamlanana kadar (1200ms) boyut ve yaşam döngüsü küçülme dinleyicileri bekletildi.
    - Tam ekran boyutu (`_initialSize`) animasyon tamamlandıktan sonra doğru şekilde kaydedildi.
    - Artık "Odaklanmaya Başla" butonuna tek tıkla basıldığında doğrudan tam ekranda odaklanma sayfası açılır, sayaç başlar ve kullanıcı sayfada kalır; tekrar basmaya gerek kalmaz.
- **Doğrulama:** `flutter analyze` 0 hata; 28/28 test başarıyla geçti.








