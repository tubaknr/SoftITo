# Progress

> Ajan her görevde günceller. Biten maddeler `done.md`'ye taşınır.
> Kurallar için `project.md` (özellikle Bölüm 7: Yeni Özellik Ekleme Protokolü ve Bölüm 8: Ayarlar Özelliği), ekran işlevleri için `SKILL.md`, görsel kararlar için `style.md`.
> Son güncelleme: 2026-10-23

## Şu An Üzerinde Çalışılan
| Görev | Branch | Durum | Not |
|---|---|---|---|
| Ayarlar Sayfası Özelliği Tamamlandı | `feature/settings` | Tamamlandı | Tüm Bölümler (A-F) uygulandı, 28/28 test başarılı, flutter analyze 0 hata/0 uyarı, DONE.md güncellendi |

## Sıradaki Görevler (öncelik sırasıyla)
Özellik: **Ayarlar sayfası** (`project.md` Bölüm 8). Branch: `feature/settings`. Her bölümden sonra `flutter analyze` (0 uyarı, 0 hata) ve `flutter test` çalıştırılır.

1. [x] Taban çizgisi denetimini bitir; sonuçları "Bilinen Hatalar"a yaz
2. [x] Mevcut kodu incele: profil sayfasındaki dil, tema, verileri yedekle, çıkış yap kodunun ve üst çubuktaki TR/EN ile aydınlık/karanlık butonlarının dosya yollarını, kullandıkları notifier/servisleri ve l10n anahtarlarını "Notlar"a yaz
3. [x] **Bölüm A — İskelet:** `features/settings/` (`controller`, `view`, `widget`), `SettingsController` (saf Dart), boş `SettingsView`, sayfa başlığı için TR/EN l10n anahtarı
4. [x] **Bölüm B — Dil ve tema taşıma:** mevcut `ValueNotifier<Locale>` ve `ValueNotifier<ThemeMode>` ile Ayarlar'a dil ve tema kontrollerini ekle; davranış, anlık geçiş ve yerel kayıt aynen korunur
5. [x] **Bölüm C — Yedekle ve çıkış taşıma:** mevcut servis arayüzleri üzerinden verileri yedekle ve çıkış yap işlevlerini Ayarlar'a taşı; çıkış sonrası yönlendirme aynen korunur
6. [x] **Bölüm D — Profil sayfası:** kullanıcı adının sağına sağa dayalı çark butonu ekle (tooltip + erişilebilirlik etiketi l10n'den, tema renkleri), dokunulunca `SettingsView` açılsın; profilden dil, tema, yedekle, çıkış yap butonlarını kaldır
7. [x] **Bölüm E — Üst çubuk:** shell üst çubuğundan TR/EN ve aydınlık/karanlık butonlarını kaldır; yerleşimin bozulmadığını doğrula
8. [x] **Bölüm F — Test ve temizlik:** `test/features/settings/` controller ve widget testleri (`project.md` Bölüm 8.5), kullanılmayan kod ve l10n anahtarlarını temizle, iki tema ve iki dilde kontrol et
9. [x] Biten maddeleri `done.md`'ye taşı

## Engeller / Bekleyen Kararlar
| Konu | Kim karar verecek | Not |
|---|---|---|
| Yeni `features/settings` klasörü | Kullanıcı | ONAYLANDI (2026-10-23). Sadece bu klasör için; ayarlar sekme değildir, bottom navigation'a öğe eklenmez |
| Ayarlar sayfasına ek özellik fikirleri | Kullanıcı | Öneriler kullanıcıya sunuldu; onaylananlar bu dosyaya görev olarak, `project.md` Bölüm 8'e kural olarak eklenir. Onay gelmeden uygulanmaz |
| Çark butonu ve Ayarlar sayfasının görsel kararları | Kullanıcı (`style.md`) | `style.md`'de karşılığı yoksa mevcut tema değerleri ve ortak widget'lar kullanılır; yeni renk/font icat edilmez |
| Harici paket ihtiyacı | Kullanıcı | Bu özellik için paket gerekmez. Gerekirse ajan paketi, gerekçeyi ve yerel alternatifi bildirir; onay gelmeden kurmaz |

## Bilinen Hatalar
- Taban çizgisi denetimi tamamlandı (2026-10-23): `flutter analyze` 0 hata / 0 uyarı; `flutter test` 19/19 test başarılı. Bilinen hata bulunmuyor.

## Notlar
- Proje ilk sürümüyle çalışır durumdadır; bu özellik mevcut kod tabanına ekleme ve taşımadır. Mevcut davranış ve yerel olarak saklanan veriler bozulmamalıdır (`project.md` Bölüm 3, madde 7).
- Taşınan işlevler yeniden yazılmaz; mevcut notifier, servis ve l10n anahtarları yeniden kullanılır.
- Her yeni metin TR ve EN olarak birlikte eklenir; renk ve metin stilleri yalnızca tema dosyalarına yazılır.
- Taşınacak kodun dosya yolları:
  - Profil sayfası: `lib/features/profile/view/profile_page.dart` (satır 570-663 `_buildSettingsCard`, satır 699-741 `_handleBackupData`, satır 743-776 `_confirmLogout`).
  - Üst çubuk: `lib/features/shell/widget/app_top_bar.dart` (satır 146 `_buildLanguagePill`, satır 150 `_buildThemeToggle`).
  - Kullanılan Notifier/Servisler: `LocaleController.instance` (`ValueNotifier<Locale>`), `ThemeController.instance` (`ValueNotifier<ThemeMode>`), `AuthController` (`AuthRepository`), `HabitsController` (`LocalHabitsRepository`).
  - Mevcut l10n anahtarları: `languageToggle`, `themeModeToggle`, `backupData`, `backupSuccess`, `logoutAction`, `confirmLogout`, `cancelAction`.
- Sonraki oturum: önce bu dosyayı ve `project.md`'yi oku, sonra "Şu An Üzerinde Çalışılan" tablosundan devam et.
