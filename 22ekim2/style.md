# Style Guide & Design Tokens (style.md)
**Proje**: PenguHabit (Alışkanlık Takip & Kişisel Gelişim Uygulaması)  
**Hedef Platform**: Mobil (iOS / Android / PWA - React Native, Flutter, Swift/Kotlin veya Web)  
**Tasarım Dili**: Yumuşak, pastel tonlar, sevimli (cute/friendly), modern, motive edici ve erişilebilir.

---

## 1. Tasarım Felsefesi & Temel İlkeler

- **Maskot & Karakter Odaklı**: Merdivenden çıkan sevimli penguen maskotu (adım adım gelişim metaforu). Maskot başarı anlarında gülümser, boş durumlarda (empty state) nazikçe teşvik eder.
- **Akışkan Gradyanlar**: Sabahın ilk ışıklarından geceye doğru yumuşak mavi-lacivert ve şafak sarısı geçişleri. Yolculuk hissini pekiştirir.
- **Mikro-Ödüllendirmeler**: Alışkanlık tamamlandığında yumuşak haptik geri bildirim, konfeti/parıltı kutlaması, 21-42 gün seri rozetleri.
- **Yumuşak Köşeler & Derinlik**: `rounded-2xl` ve `rounded-3xl` formlar, sert gölgeler yerine renkli diffüz (soft ambient) gölgeler.

---

## 2. Renk Paleti (Color Tokens)

### 2.1. Light Mode (Aydınlık Tema)

```css
:root {
  /* Marka Ana Renkleri (Primary & Accent) */
  --color-primary: #3B82F6;            /* Canlı pastel gök mavisi */
  --color-primary-light: #93C5FD;      /* Açık bulut mavisi */
  --color-primary-dark: #1E3A8A;       /* Derin lacivert (vurgu, başlıklar) */
  --color-accent-sun: #FDE047;         /* Doğan güneş sarısı (maskot & vurgular) */
  --color-accent-orange: #FB923C;      /* Penguen gagası/ayakları ve enerji vurgusu */
  --color-accent-coral: #FDA4AF;       /* Yumuşak yanak pembesi / duygudurum */
  
  /* Başarı, Kutlama & Rozet Renkleri */
  --color-success: #10B981;           /* Tamamlandı yeşili (tatlı nane yeşili) */
  --color-success-light: #D1FAE5;     /* Başarı arka planı */
  --color-warning: #F59E0B;           /* Seri / Alev turuncusu */
  --color-info: #06B6D4;              /* Bilgilendirme / Su hatırlatıcı */
  
  /* Arka Planlar & Gradyanlar (Backgrounds) */
  --bg-app: #F0F7FF;                  /* Yumuşak pastel buz mavisi ana zemin */
  --bg-card: #FFFFFF;                 /* Kart ve modal zemin */
  --bg-card-subtle: #F8FAFC;          /* İkincil kartlar, input zeminleri */
  
  /* Gradyan Tanımları */
  --grad-hero: linear-gradient(180deg, #1E3A8A 0%, #3B82F6 45%, #93C5FD 85%, #E0F2FE 100%);
  --grad-dawn: linear-gradient(135deg, #38BDF8 0%, #FDE047 100%); /* Doğan güneş */
  --grad-btn-primary: linear-gradient(135deg, #1E40AF 0%, #3B82F6 50%, #60A5FA 100%);
  --grad-card-highlight: linear-gradient(145deg, rgba(255,255,255,0.9) 0%, rgba(238,246,255,0.7) 100%);
  --grad-badge-gold: linear-gradient(135deg, #F59E0B 0%, #FDE047 100%);
  
  /* Tipografi Renkleri */
  --text-main: #0F172A;               /* Koyu lacivert-gri ana metin */
  --text-muted: #64748B;              /* İkincil açıklamalar, ipuçları */
  --text-disabled: #94A3B8;           /* Tamamlanan üstü çizili alışkanlıklar */
  --text-on-primary: #FFFFFF;         /* Buton üzeri beyaz metin */
  --text-link: #2563EB;               /* Altı çizili bağlantı rengi */
  
  /* Çerçeve & Ayırıcılar */
  --border-light: #E2E8F0;
  --border-focus: #3B82F6;
  
  /* Gölgeler (Soft & Diffuse) */
  --shadow-sm: 0 2px 8px rgba(30, 58, 138, 0.04);
  --shadow-card: 0 10px 25px -5px rgba(30, 58, 138, 0.08), 0 8px 10px -6px rgba(30, 58, 138, 0.04);
  --shadow-button: 0 8px 20px rgba(59, 130, 246, 0.35);
  --shadow-modal: 0 20px 40px -15px rgba(15, 23, 42, 0.2);
}
```

### 2.2. Dark Mode (Karanlık Tema - Derin Kutup Gecesi)

```css
[data-theme="dark"] {
  --color-primary: #60A5FA;
  --color-primary-light: #BFDBFE;
  --color-primary-dark: #0F172A;
  --color-accent-sun: #FACC15;
  --color-accent-orange: #FB923C;
  --color-accent-coral: #F43F5E;
  
  --color-success: #34D399;
  --color-success-light: #064E3B;
  --color-warning: #FBBF24;
  --color-info: #38BDF8;
  
  --bg-app: #0B1120;                  /* Derin kutup gecesi laciverti */
  --bg-card: #1E293B;                 /* Slate koyu kart zemini */
  --bg-card-subtle: #141E33;          /* Input ve ikincil zemin */
  
  --grad-hero: linear-gradient(180deg, #090D1A 0%, #172554 60%, #1E3A8A 100%);
  --grad-dawn: linear-gradient(135deg, #1E40AF 0%, #EAB308 100%);
  --grad-btn-primary: linear-gradient(135deg, #2563EB 0%, #3B82F6 100%);
  --grad-card-highlight: linear-gradient(145deg, rgba(30, 41, 59, 0.9) 0%, rgba(15, 23, 42, 0.7) 100%);
  
  --text-main: #F8FAFC;
  --text-muted: #94A3B8;
  --text-disabled: #475569;
  --text-on-primary: #FFFFFF;
  --text-link: #93C5FD;
  
  --border-light: #334155;
  --border-focus: #60A5FA;
  
  --shadow-card: 0 10px 25px -5px rgba(0, 0, 0, 0.4);
  --shadow-button: 0 8px 20px rgba(96, 165, 250, 0.25);
  --shadow-modal: 0 20px 40px -15px rgba(0, 0, 0, 0.7);
}
```

---

## 3. Tipografi Sistemi (Typography)

**Font Family**: `Plus Jakarta Sans` veya `Nunito`, `Quicksand` alternatifleriyle. Hem sevimli kavisleri hem de yüksek okunabilirliği barındırır.

```css
/* Font Boyutları & Hiyerarşi */
--font-family-primary: 'Plus Jakarta Sans', system-ui, -apple-system, sans-serif;

/* Display & Hero (Motto ve Karşılama) */
.font-hero-title {
  font-family: var(--font-family-primary);
  font-size: 28px;
  line-height: 36px;
  font-weight: 800;
  letter-spacing: -0.02em;
}

/* Sayfa Başlıkları (H1 - "Hoşgeldin Ayşe") */
.font-heading-lg {
  font-size: 22px;
  line-height: 28px;
  font-weight: 700;
  letter-spacing: -0.01em;
}

/* Bölüm Başlıkları (H2 - "Bugünkü Alışkanlıklar", "Rozetler") */
.font-heading-md {
  font-size: 18px;
  line-height: 24px;
  font-weight: 700;
}

/* Kart Başlığı / Alışkanlık Adı */
.font-item-title {
  font-size: 16px;
  line-height: 22px;
  font-weight: 600;
}

/* Gövde Metni (Motto, açıklamalar) */
.font-body {
  font-size: 14px;
  line-height: 20px;
  font-weight: 400;
}

/* Küçük Detaylar, Saatler, İpuçları */
.font-caption {
  font-size: 12px;
  line-height: 16px;
  font-weight: 500;
}

/* Altı Çizili Butonlar & Linkler ("Giriş yap", "İlerle", "Şifremi unuttum") */
.font-link {
  font-size: 14px;
  font-weight: 600;
  text-decoration: underline;
  text-underline-offset: 4px;
  cursor: pointer;
}
```

---

## 4. Spacing, Radius & Elevation (Boşluklar ve Biçim)

### 4.1. Köşe Yuvarlaklığı (Border Radius)
- **Ekstra Yumuşak Butonlar**: `rounded-2xl` (`16px`) veya `rounded-full` (`9999px`)
- **İçerik Kartları & Alışkanlık Maddeleri**: `rounded-2xl` (`18px - 20px`)
- **Modallar (Bottom Sheet)**: `rounded-t-3xl` (`28px 28px 0 0`)
- **Rozetler & İkon Yuvaları**: `rounded-2xl` (`14px`) veya `circle` (`50%`)
- **Form Inputları**: `rounded-xl` (`12px - 14px`)

### 4.2. Boşluk Sistemi (Spacing Grid - 4px/8px)
- `xs`: `4px`
- `sm`: `8px`
- `md`: `16px` (Varsayılan ekran padding'i / kart içi dolgusu)
- `lg`: `24px` (Bölümler arası boşluk)
- `xl`: `32px` (Hero ve maskot boşlukları)

---

## 5. Özel Bileşen Şablonları & UI Kuralları

### 5.1. Butonlar (Buttons)
1. **Primary Gradyanlı Buton**:
   - Background: `var(--grad-btn-primary)`
   - Color: `#FFFFFF`
   - Padding: `14px 24px`
   - Radius: `16px`
   - Shadow: `var(--shadow-button)`
   - Hover/Active: Hafif parlama ve `scale(0.98)` mikro tıklama hareketi.

2. **Google OAuth Butonu**:
   - Background: `#FFFFFF` (Dark mode: `#1E293B`)
   - Border: `1.5px solid var(--border-light)`
   - Sol tarafta renkli Google SVG ikonu, ortalı "Google ile Devam Et" yazısı.

3. **Text / Link Buton (Giriş Yap, İlerle, Şifremi Unuttum)**:
   - Şeffaf zemin, altı ince çizgili (`border-b-2 border-primary` veya `text-decoration: underline`).
   - Renk: `var(--text-link)`.

### 5.2. Maskot & Durum Görselleri (Penguin Mascot)
- **Karakter**: Tombul, sevimli, yuvarlak hatlı penguen.
- **Karşılama Ekranı (Sayfa 1)**: Pastel tahta basamaklardan/buz merdivenlerinden yukarı tırmanan penguen maskotu.
- **Kayıt Sonrası (Sayfa 2)**: Zirveye varmış, doğan güneşe karşı gülümseyen ve el sallayan penguen.
- **Boş Durum (Empty State)**: Elinde ajanda/fırça tutan meraklı penguen + *"Hiç alışkanlık eklememişsin!"* başlığı ve *"Hemen İlk Alışkanlığını Ekle"* butonu.

### 5.3. Alışkanlık Kartı (Habit Card)
- **Normal Durum**:
  - Beyaz kart zemin, solunda alışkanlığa özel renkli kategori ikonu (Örn: 💧 Su, 📖 Kitap).
  - Alışkanlık ismi, sıklık (Her gün), seri sayısı (Örn: "🔥 7 Günlük Seri").
  - Sağda yuvarlak checkbox butonu (`border-2 border-primary-light`).
- **Tamamlandı Durumu (Completed)**:
  - Checkbox yeşil dolgulu (`#10B981`) ve içinde beyaz tik (`✓`).
  - Metin rengi grileşir (`var(--text-disabled)`), üzeri çizilir (`line-through`).
  - Arka plan hafif yeşil pastel ton alır veya transparanlaşır.
  - Kutlama: Mikro konfeti veya yıldız patlaması animasyonu.

### 5.4. Alttan Açılır Modal (Duygu & Farkındalık Notu)
- Tamamlanan alışkanlık sonrası açılan opsiyonel bottom sheet.
- **Duygu Emojileri**: 5 sevimli buton (🤩 Harika, 😊 Mutlu, 😌 Dingin, 🥱 Yorgun, 🤯 Zorlayıcı).
- **Farkındalık Notu Girişi**: Yumuşak kenarlı textarea (*"Bana neler hissettirdi, ne fark ettim?"*).
- **Kaydet Butonu**: *"Notu Alışkanlığa Ekle"*.

### 5.5. Seri & Rozet Sistemi (Streak Badges)
- Her 5 tamamlayışta mikro rozet.
- **21 Gün Serisi**: "Gümüş Penguen" Rozeti (Alışkanlığın beyinde yerleşme eşiği).
- **42 Gün Serisi**: "Altın Penguen" Rozeti (Kalıcı alışkanlık ustası).
- **66+ Gün Serisi**: "Elmas Penguen" Rozeti.

### 5.6. Takvim & Filtre Ekranı
- Üstte filtre pill'leri (Haftalık, 2 Haftalık, Aylık, 2 Aylık, 3 Aylık).
- Takvim günleri içinde her alışkanlık kendi tematik pastel rengiyle (Badge/Nokta/Çizgi) listelenir.

### 5.7. Analiz & Grafikler
- Büyük yumuşak başarı oranı: **`%52`** (Dairesel progress bar, pastel mavi-yeşil gradyan).
- Devamlılık yüzdesi grafiği (Bar chart veya smooth spline wave).
- Duygu Analizi Çizelgesi (En çok hangi duyguyla tamamlandı pasta/çubuk grafik).

### 5.8. Topbar & Bottombar
- **Topbar**: `"Hoşgeldin Ayşe"` başlığı, sağda bildirim zili (`🔔`) ve dil seçici (`TR / EN`).
- **Bottombar**: 4 Sekmeli yüzen (floating) menü:
  1. 🏠 Anasayfa
  2. 📅 Takvim
  3. 📊 Analiz & Grafikler
  4. 👤 Profil

---

## 6. Çoklu Dil & Bildirimler (TR / EN & Notifications)

### 6.1. Dil Anahtarları (TR / EN Core Strings)
- `motto_1`: "Küçük adımlar, büyük hedeflerin ruhudur." / "Critical steps are the soul of great goals."
- `motto_2`: "Hedeflerine ulaşmak için alışkanlıkların gücünden yararlanmaya hazır mısın?" / "Ready to harness the power of habits to reach your goals?"
- `empty_state`: "Hiç alışkanlık eklememişsin!" / "You haven't added any habits yet!"
- `notification_prompt`: "Haydi şimdi bir bardak su iç 💧 / birkaç sayfa kitap oku 📖" / "Time for a glass of water 💧 / read a few pages 📖"
