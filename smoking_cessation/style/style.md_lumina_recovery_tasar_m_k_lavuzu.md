# Lumina Recovery — Stil ve Tasarım Kılavuzu (style.md)

Bu doküman, **Lumina Recovery** sigara bırakma mobil uygulamasının tasarım dili, UI/UX mimarisi, renk paletleri, tipografi hiyerarşisi, ikonografi ve tüm 6 ekranın detaylı bileşen spesifikasyonlarını eksiksiz olarak içerir.

---

## 1. Tasarım Felsefesi ve Görsel Yönelim

- **Karanlık, Sakinleştirici ve Odaklı (Ultra-Dark Calming UI):** Kriz anlarında göz yormayan, kullanıcının kalp atış hızını ve anksiyetesini düşürmeye yardımcı derin koyu arka planlar (`#0b0e17`, `#10131c`).
- **Canlılık ve İyileşme Vurgusu (Emerald & Mint Glow):** Başarıyı, arınmayı ve vücut temizliğini simgeleyen parlak zümrüt yeşili (`#10b981`, `#00ffb3`, `#34d399`) aksanlar.
- **Acil Durum Ayrımı (SOS & Alert Crimson):** "Canım Çekti" / SOS alanlarında dikkat toplayan ama panik yaratmayan kontrollü kırmızı/turuncu tonlar (`#ef4444`, `#f87171`).
- **Modern Yüzey Hiyerarşisi (Layered Dark Elevation):** Düz siyah yerine çok katmanlı kart yapıları, cam efekti (backdrop-blur) ve ince sınırlar (1px border: `rgba(255, 255, 255, 0.08)`).

---

## 2. Renk Paleti (Color Tokens)

### 2.1 Arka Plan & Yüzey Renkleri
| Token | Hex Değeri | Tailwind Sınıfı | Kullanım Alanı |
|---|---|---|---|
| `surface-container-lowest` | `#0b0e17` | `bg-[#0b0e17]` | Ana sayfa en derin arka plan, bottom sheet tabanı |
| `surface` | `#10131c` | `bg-[#10131c]` | Uygulama ana zemin rengi, standart ekran arka planı |
| `surface-container-low` | `#181b25` | `bg-[#181b25]` | Kart zeminleri, panel arkaplanları |
| `surface-container` | `#1e222e` | `bg-[#1e222e]` | İkincil kartlar, form girdileri, input kutuları |
| `surface-container-high` | `#262a38` | `bg-[#262a38]` | Hover/aktif durumlar, seçili filtreler, takvim hücreleri |
| `surface-container-highest`| `#303546` | `bg-[#303546]` | İkon yuvaları, buton arka planları |

### 2.2 Marka & Vurgu Renkleri (Primary & Accents)
| Token | Hex Değeri | Tailwind Sınıfı | Anlam ve Kullanım |
|---|---|---|---|
| `primary` | `#10b981` | `text-emerald-500` / `bg-emerald-500` | Ana CTA butonları, başarı durumları, tamamlanan timeline |
| `primary-bright` | `#00ffb3` | `text-[#00ffb3]` | Canlı sayaç halkası, neon parıltılar, aktif rozet ışığı |
| `primary-container` | `rgba(16, 185, 129, 0.15)` | `bg-emerald-500/15` | Rozet zeminleri, başarı çipleri |
| `secondary-cyan` | `#06b6d4` | `text-cyan-400` | Oksijen oranı, nefes egzersiz döngüsü |
| `warning-amber` | `#f59e0b` | `text-amber-500` | Zorlanılan günler, dikkat uyarıları |
| `danger-sos` | `#ef4444` | `bg-rose-600` / `text-rose-500` | Kriz butonu, SOS acil rahatlama |
| `danger-sos-glow` | `rgba(239, 68, 68, 0.25)` | `shadow-[0_0_24px_rgba(239,68,68,0.3)]` | SOS puls efekti |

### 2.3 Tipografi & Çizgi Renkleri
| Token | Hex / RGBA | Tailwind Sınıfı | Kullanım |
|---|---|---|---|
| `on-surface` | `#f1f5f9` | `text-slate-100` | Başlıklar, birincil metinler, ana sayaç rakamları |
| `on-surface-variant` | `#94a3b8` | `text-slate-400` | Açıklama metinleri, ikincil etiketler |
| `on-surface-muted` | `#64748b` | `text-slate-500` | Pasif tarihler, dipnotlar, pasif tab ikonları |
| `outline` | `rgba(255, 255, 255, 0.08)` | `border-white/10` | Kart çerçeveleri, ayırıcı çizgiler |
| `outline-active` | `rgba(16, 185, 129, 0.4)`| `border-emerald-500/40` | Aktif kart ve input sınırları |

---

## 3. Tipografi Sistemi

- **Ana Yazı Tipi:** `Plus Jakarta Sans`, alternatif: `Inter`, `system-ui`.
- **Rakam Göstergeleri:** Tabular figures (`font-variant-numeric: tabular-nums`) sayaçların zıplamasını engeller.

| Düzey | Boyut / Satır Boyu | Ağırlık (Weight) | Letter Spacing | Kullanım Örneği |
|---|---|---|---|---|
| **Display Counter** | 44px – 56px / 1.1 | Bold / ExtraBold (800) | `-0.03em` | 14G 08S (Canlı Sayaç) |
| **Headline Large** | 26px – 28px / 1.25 | Bold (700) | `-0.02em` | Ekran Ana Başlıkları |
| **Headline Medium**| 20px – 22px / 1.3 | SemiBold (600) | `-0.01em` | Bölüm Başlıkları |
| **Title Small** | 16px – 17px / 1.4 | SemiBold (600) | `0` | Kart Başlıkları |
| **Body Large** | 15px – 16px / 1.5 | Regular / Medium | `0` | Açıklama ve motivasyon kartları |
| **Body Small** | 13px – 14px / 1.4 | Regular (400) | `0` | İkincil detaylar, ipuçları |
| **Label / Caption** | 11px – 12px / 1.3 | Medium / SemiBold | `+0.05em` | Büyük harf etiketler (`CANLI REKOR`, `SOS`) |

---

## 4. Ortak Arayüz Bileşenleri (Global UI Components)

### 4.1 Top App Bar (Üst Başlık Çubuğu)
- **Yapı:** Sabit (`sticky top-0 z-40`), yüksekliği 64px (`h-16`).
- **Görsel:** `bg-[#10131c]/80 backdrop-blur-md border-b border-white/5`.
- **Sol Eleman:** Logo ikonu ve "Arınma Takibi" başlığı.
- **Sağ Eleman:** Hızlı acil erişim "🚨 SOS" hap (pill) butonu (`bg-rose-500/15 text-rose-400 border border-rose-500/30`).

### 4.2 Bottom Navigation Bar (Alt Navigasyon)
- **Yapı:** Sabit taban menü (`fixed bottom-0 left-0 w-full z-50 max-w-md mx-auto`).
- **Görsel:** `bg-[#0b0e17]/90 backdrop-blur-xl border-t border-white/10 shadow-[0_-4px_24px_rgba(0,0,0,0.6)]`.
- **5 Ana Sekme:**
  1. **Sayaç (`timer`):** Ana gösterge ve tasarruf paneli.
  2. **Sağlık (`vital_signs`):** Biyolojik kazanım zaman çizelgesi.
  3. **Günlük (`calendar_month`):** Takvim ve streak takibi.
  4. **Nefes (`air`):** Kriz anı rahatlama modu.
  5. **Ayarlar (`settings` / `notifications`):** Rozetler, bildirimler ve ayarlar.
- **Aktif Durum:** `text-[#10b981]` + dairesel parıltı noktası.
- **Pasif Durum:** `text-slate-400 hover:text-slate-200`.

### 4.3 Buton ve Kart Standartları
- **Köşe Yuvarlama (Border Radius):** 
  - Kartlar: `rounded-2xl` (16px) veya `rounded-3xl` (24px)
  - Butonlar & Rozetler: `rounded-full` (pill) veya `rounded-xl` (12px)
- **Gölge & Parıltı (Glow):**
  - Buton Glow: `shadow-[0_8px_24px_rgba(16,185,129,0.35)]`
  - Kart Hover/Focus: `transition-all duration-200 hover:border-emerald-500/30`

---

## 5. Ekran Bazlı Detaylı Spesifikasyonlar

### Ekran 1: Başlangıç ve Parametre Ayarları (`SCREEN_8`)
- **Amaç:** Hesap/şifre gerekmeden cihaz içi ilk veri kurulumu ve motive edici karşılama.
- **Öne Çıkan Elemanlar:**
  - *Üst Güven Rozeti:* "GİRİŞ / KAYIT GEREKMEZ • Cihazında Saklanır" hap etiketi.
  - *Dönüşüm Görseli:* Soluk/hastalıklı bedenden berrak canlı bedene geçiş simülasyonu kartı (`Duman ➔ Yenilenen Beden`).
  - *Tarih/Saat Seçici:* Varsayılan "An İtibarıyla" butonu ve detaylı takvim/saat giriş inputu (`#1e222e` zemin, takvim ikonu).
  - *Tüketim Slider'ı:* Günlük sigara adedi için 5 - 40+ aralığında interaktif slider göstergesi (Büyük `20 adet` göstergesi).
  - *Maliyet Girişleri:* Paket fiyatı (TL) ve paketteki adet kartları.
  - *Anlık Tahmin Kartı:* Yıllık cebinde kalacak miktar (`23.725 ₺`) ve aylık projeksiyon.
  - *Ana CTA:* "Sayacı Başlat ve İyileş" geniş zümrüt buton (`rounded-full`).

---

### Ekran 2: Ana Ekran - Sayaç ve Tasarruf Paneli (`SCREEN_7`)
- **Amaç:** Uygulamanın merkezi; kullanıcının anlık kazançlarını ve temiz kaldığı süreyi kutlar.
- **Öne Çıkan Elemanlar:**
  - *Çift Halkalı Canlı Kronometre:*
    - Dış Halka: Neon yeşil ve camgöbeği gradient dairesel ilerleme SVG'si.
    - İçerik: `14 GÜN 08 SAAT 32 DK 49 SN` büyük tabular sayaç.
    - Alt Etiket: Karbonmonoksit: `%0 Normalize • Stabil`.
  - *Biyolojik Yenilenme Özeti:*
    - Akciğer Siliya Aktivitesi (%74 ilerleme barı).
    - Kan Oksijen Doygunluğu (%99 ilerleme barı).
    - Vücut onarım hızı katsayısı (`2.4x`).
  - *Finansal & Yaşam Kazanımı Kartları:*
    - Cepte Kalan Birikim: `910 ₺` (Aylık tahmin: `1.950 ₺`).
    - İçilmeyen Sigara: `286 Adet` (`14.3 Paket Kurtarıldı`).
    - Yaşama Eklenen Süre: `1G 9S` (Her dal ≈ 11 dk ömür hesabı).
  - *Acil Durum Tetikleyici (SOS CTA):*
    - "Canım Çekti (Kriz Butonu)" kırmızı gradient kartı; 4-7-8 nefes başlatma çağrısı.
  - *Zihinsel Hatırlatıcı:* "Sigara yakmak stresi bitirmez..." nörolojik farkındalık kartı.

---

### Ekran 3: Sağlık Kazanımları — Zaman Çizelgesi (`SCREEN_5`)
- **Amaç:** DSÖ ve tıp verilerine dayalı iyileşme basamaklarının interaktif takibi.
- **Öne Çıkan Elemanlar:**
  - *Üst Metrikler:* Akciğer Kapasitesi (`+%30`), Hücresel Toksin (`0 ppm`).
  - *İnteraktif Dikey Çizelge (Timeline):*
    - Sol çizgi: Tamamlananlarda kesintisiz parlak zümrüt dikey hat; sürenlerde kesikli çizgi.
    - **20. Dakika:** Nabız ve kan basıncı normale döndü (%100 tamamlandı ikonu).
    - **8. Saat:** Kandaki oksijen seviyesi arttı (%100).
    - **24. Saat:** Karbonmonoksit temizlendi (%100).
    - **48. Saat:** Tat ve koku duyuları keskinleşti (%100).
    - **72. Saat:** Bronşlar gevşedi, nefes almak kolaylaştı (%100).
    - **2 Hafta – 3 Ay (Aktif Faz):** Dolaşım ve akciğer fonksiyonu (%74 animasyonlu bar, "Hedefe 18 Gün Kaldı").
    - **1 Yıl – 5 Yıl (Kilitli/Gelecek Hedefler):** Kalp krizi riski yarıya iner (%18), Felç riski sıfırlanır (Kilit simgesi).

---

### Ekran 4: “Canım Çekti” — Kriz Anı ve Nefes Modu (`SCREEN_6`)
- **Amaç:** 3-5 dakikalık nikotin çekilme atağını ilaçsız, sakinleştirici nefesle atlatmak.
- **Öne Çıkan Elemanlar:**
  - *5 Dakikalık Geri Sayım Saati:* `04:36` büyük sakin yeşil/camgöbeği sayaç.
  - *Pulsing Nefes Çemberi:* 
    - Eşmerkezli katmanlı dalga halkaları.
    - Faz metni: "Nefes Al" ➔ "Tut" ➔ "Ver" (4-4-4 veya 4-7-8 ritmi).
  - *Ses ve Titreşim Kontrolleri:* Doğa Sesi (Açık/Kapalı), Haptik Titreşim butonları.
  - *Biyolojik Gerçek Kartı:* "Sigara içme isteği ortalama 3-5 dakika sürer. Bu dalga birazdan geçecek."
  - *Hızlı Dikkat Dağıtıcı Aksiyonlar:*
    - 💧 "Soğuk Su İçtim"
    - 🧩 "Dikkatimi Dağıt"
  - *Kutlama Butonu:* "Krizi Yendim!" geniş yeşil zafer butonu.

---

### Ekran 5: Günlük Kayıt ve Takvim (Streak) (`SCREEN_4`)
- **Amaç:** Davranışsal zincir (habit streak) oluşturma ve tetikleyici analizi.
- **Öne Çıkan Elemanlar:**
  - *Hızlı Check-in Kartı:* "Bugün sigara içtin mi?" sorusu altında tek dokunuşla seçilen büyük "Bugün İçmedim! (Temizim)" yeşil durum butonu.
  - *Kriz Yoğunluk Skalası:* 1'den 5'e alev ikonlu yoğunluk seçimi (1: Rahat Seviye ... 5: Şiddetli Çekim).
  - *Kısa Günlük Not Alanı:* Kullanıcının zorlandığı anı yazabileceği textarea alanı.
  - *Aylık Zincir Takvimi (Mayıs 2024):*
    - Temiz/Başarılı günler: Yeşil dolgulu noktalar.
    - Zorlanılan günler: Kehribar (amber) noktalar.
    - Boş günler: Nötr koyu zemin.
  - *Analiz Kartları:*
    - Mevcut Seri: `14 Gün Kesintisiz Temiz`.
    - En Çok Tetikleyen Zaman Dilimi: `Akşam Saatleri (20:00 - 22:30)`.

---

### Ekran 6: Bildirimler ve Kutlamalar (`SCREEN_2`)
- **Amaç:** Pozitif pekiştirme, başarı rozetleri ve akıllı kriz önleme uyarıları.
- **Öne Çıkan Elemanlar:**
  - *Altın Dönüm Noktası Hero Kartı:*
    - Konfeti partikülleri ve "1. Hafta Tamamlandı!" kupa rozeti.
    - Tebrik metni: "Tat alma duyuların yeniden doğdu..."
    - Tasarruf: `455,00 TL`.
    - Paylaşım butonu: "Başarıyı Kutla & Paylaş" (Sosyal medya hikaye formatında çıktı).
  - *İyileşme Rozet Vitrini (Badges):*
    - Açılanlar: 24 Saat, 3 Gün, 1 Hafta (Yeşil parıltılı neon çerçeve).
    - Sırada / Kilitli olanlar: 1 Ay (%23 ilerleme barı), 3 Ay, 1 Yıl Efsane.
  - *Akıllı Bildirim Ayarları Paneli:*
    - Günlük Motivasyon Bildirimi (09:00, "Sabah 09:00 - Cebinde fazladan 65 TL var").
    - Kriz Önleme Hatırlatıcısı (Kullanıcının kritik saati olan 16:45'te tetiklenen akıllı analiz uyarısı).
    - Dönüm Noktası Uyarısı (Ses & Titreşim seçenekli).
    - Gece Sessiz Modu (23:00 - 08:00 arası sessize alma toggle anahtarı).

---

## 6. Mikro Etkileşimler & Haptik Standartlar

1. **Sayaç Animasyonu:** Her saniye geçişinde yumuşak fade (`opacity` geçişi).
2. **Nefes Halkası:** 4 saniye boyunca `scale(1.25)` ile büyüme, 4 saniye sabit kalma, 4 saniye `scale(1.0)` ile küçülme (`ease-in-out`).
3. **Kriz Butonu Titreşimi:** SOS butonuna basıldığında çift haptik darbe (heavy feedback), nefes ritminde hafif haptik rehberlik.
4. **Rozet Kilidi Açılma:** Kupa kartında parıltı (shimmer) ve hafif partikül dağılımı.
