# Style Guide & Design Tokens v2 (style2.md)
**Proje İsmi**: Small Tick & Big Grow  
**Hedef Platform**: Mobil (iOS / Android / PWA - React Native, Flutter, Swift/Kotlin veya Modern Web)  
**Tasarım Dili**: Yumuşak, pastel tonlar, sevimli (cute/friendly), modern, motive edici, dingin ve mikro-başarı odaklı.

---

## 1. Marka Kimliği & Logo Standartları

### 1.1. Proje İsmi & Tipografik Yerleşim
Proje adı **"Small Tick & Big Grow"** iki satır halinde hiyerarşik olarak konumlandırılır:
- **Üst Satır**: `Small Tick`
  - **Font Ağırlığı**: Light / Regular (`font-weight: 300` veya `400`)
  - **Font Boyutu**: Nispeten küçük, zarif ve ince (`font-size: 13px - 15px`)
  - **Harf Boşluğu (Tracking)**: Genişletilmiş ferah aralık (`letter-spacing: 0.08em` veya `0.1em`)
  - **Renk**: `var(--text-muted)` veya `var(--color-primary-light)`
- **Alt Satır**: `Big Grow`
  - **Font Ağırlığı**: Extra Bold / Black (`font-weight: 800` veya `900`)
  - **Font Boyutu**: İri, güçlü ve vurucu (`font-size: 22px - 26px`)
  - **Harf Boşluğu (Tracking)**: Sıkı ve tok (`letter-spacing: -0.02em`)
  - **Renk**: `var(--color-primary-dark)` (Light Mode) / `#FFFFFF` (Dark Mode) veya hafif `var(--grad-brand-text)` gradyanlı dolgu.

```html
<!-- Standart Marka Başlığı Bileşeni -->
<div class="brand-title-group flex flex-col items-start leading-none">
  <span class="brand-sub font-light text-xs tracking-wider text-blue-400 uppercase">Small Tick</span>
  <span class="brand-main font-extrabold text-2xl tracking-tight text-slate-900 dark:text-white">Big Grow</span>
</div>
```

---

### 1.2. Logo & Maskot Kuralları
- **Karakter**: Tombul, yuvarlak hatlı, yumuşak kavisli gövdesi olan sevimli minik penguen.
- **Yüz İfadesi**: Gözleri mutlu yay şeklinde hafif kısık, yanaklarında tatlı pastel allık (`#FDA4AF`), sıcacık, içten ve motive edici bir gülümseme.
- **Detay / Aksesuar**: 
  - Göğsünde veya kanadında minik pastel yeşil onay tiki (`Small Tick` metaforu).
  - Yanında veya adımladığı basamakta hafifçe yeşeren minik bir filiz/yaprak (`Big Grow` metaforu).
  - Gagası ve minik ayakları sıcak pastel turuncu (`#FB923C`).
- **Logo Sürümleri**:
  1. **Tam Logo (Kombinasyon)**: Solda gülen penguen ikonu, sağda iki satırlı `Small Tick / Big Grow` tipografisi.
  2. **Yalnızca İkon (App Icon)**: Yumuşak köşeli kareden (`squircle / rounded-3xl`) pastel gök mavisi zemin üzerinde gülen penguen başı.
  3. **Yalnızca Wordmark**: Başlık çubukları (navbar) veya kompakt alanlar için.

---

## 2. Tasarım Felsefesi & Temel İlkeler

1. **"Küçük Bir Tik, Büyük Bir Gelişim" (Atomic Habits Felsefesi)**:
   - Kullanıcıyı devasa hedeflerle korkutmak yerine her gün atılan o minik sevimli tikin (`Small Tick`) zamanla dev bir büyüme dalgasına (`Big Grow`) dönüşmesini görselleştirir.
2. **Karakter & Maskot Odaklı Duygusal Tasarım**:
   - Gülen tatlı penguen her başarı anında konfetilerle zıplar, serilerde madalya takar, boş durumlarda (empty state) "Hadi ilk tikini atalım!" diye gülümser.
3. **Akışkan Doğan Güneş & Kutup Gökyüzü**:
   - Gece lacivertinden gün ağarmasına, pastel bebek mavisinden doğan güneş sarısına yumuşak geçişler.
4. **Hafif, Yumuşak ve Dokunsal Arayüz**:
   - Keskin kenarlar yasaktır. Tamamen `rounded-2xl`, `rounded-3xl` kavisler, yumuşak gölgeler (`soft ambient shadow`), basma hissi veren mikro animasyonlar (`scale: 0.98`).

---

## 3. Renk Paleti (Color Tokens)

### 3.1. Light Mode (Aydınlık Tema)

```css
:root {
  /* Marka Ana Renkleri */
  --color-primary: #3B82F6;            /* Canlı pastel gök mavisi */
  --color-primary-light: #93C5FD;      /* Bulut mavisi / Small Tick ikincil metin */
  --color-primary-dark: #1E3A8A;       /* Derin lacivert / Big Grow vurgu metni */
  
  /* Maskot & Vurgu Renkleri */
  --color-accent-sun: #FDE047;         /* Doğan güneş sarısı */
  --color-accent-orange: #FB923C;      /* Penguen gagası & ayakları */
  --color-accent-blush: #FDA4AF;       /* Penguen yanak allığı & sakin pembe */
  --color-accent-sprout: #34D399;      /* "Big Grow" taze filiz yeşili */
  
  /* Durum & Başarı Renkleri */
  --color-success: #10B981;           /* Onay tiki & tamamlandı nane yeşili */
  --color-success-light: #D1FAE5;     /* Tamamlandı kart arka planı */
  --color-warning: #F59E0B;           /* Seri ateşi / alev turuncusu */
  --color-info: #06B6D4;              /* Su içme & hatırlatıcı mavisi */
  
  /* Zeminler (Backgrounds) */
  --bg-app: #F0F7FF;                  /* Yumuşak pastel buz/gök mavisi ana zemin */
  --bg-card: #FFFFFF;                 /* Beyaz kart zemini */
  --bg-card-subtle: #F8FAFC;          /* Form inputları ve ikincil zemin */
  
  /* Akışkan Gradyanlar */
  --grad-hero: linear-gradient(180deg, #1E3A8A 0%, #3B82F6 45%, #93C5FD 85%, #E0F2FE 100%);
  --grad-dawn: linear-gradient(135deg, #38BDF8 0%, #FDE047 100%);
  --grad-btn-primary: linear-gradient(135deg, #1E40AF 0%, #3B82F6 50%, #60A5FA 100%);
  --grad-tick-success: linear-gradient(135deg, #10B981 0%, #34D399 100%);
  --grad-badge-gold: linear-gradient(135deg, #F59E0B 0%, #FDE047 100%);
  --grad-badge-silver: linear-gradient(135deg, #94A3B8 0%, #E2E8F0 100%);
  
  /* Tipografi Renkleri */
  --text-main: #0F172A;               /* Koyu lacivert-gri ana gövde metni */
  --text-muted: #64748B;              /* Açıklamalar ve ikincil başlıklar */
  --text-disabled: #94A3B8;           /* Üstü çizilen tamamlanmış alışkanlık metni */
  --text-on-primary: #FFFFFF;         /* Buton üzerindeki beyaz metin */
  --text-link: #2563EB;               /* Altı çizili link rengi */
  
  /* Çerçeve & Gölgeler */
  --border-light: #E2E8F0;
  --border-focus: #3B82F6;
  --shadow-card: 0 10px 25px -5px rgba(30, 58, 138, 0.08), 0 8px 10px -6px rgba(30, 58, 138, 0.04);
  --shadow-button: 0 8px 20px rgba(59, 130, 246, 0.35);
  --shadow-modal: 0 20px 40px -15px rgba(15, 23, 42, 0.2);
}
```

### 3.2. Dark Mode (Karanlık Tema - Derin Kutup Gecesi)

```css
[data-theme="dark"] {
  --color-primary: #60A5FA;
  --color-primary-light: #BFDBFE;
  --color-primary-dark: #0F172A;
  
  --color-accent-sun: #FACC15;
  --color-accent-orange: #FB923C;
  --color-accent-blush: #FB7185;
  --color-accent-sprout: #4ADE80;
  
  --color-success: #34D399;
  --color-success-light: #064E3B;
  --color-warning: #FBBF24;
  --color-info: #38BDF8;
  
  --bg-app: #0B1120;                  /* Gece kutup laciverti */
  --bg-card: #1E293B;                 /* Koyu slate kart zemini */
  --bg-card-subtle: #141E33;          /* Input zemini */
  
  --grad-hero: linear-gradient(180deg, #090D1A 0%, #172554 60%, #1E3A8A 100%);
  --grad-dawn: linear-gradient(135deg, #1E40AF 0%, #EAB308 100%);
  --grad-btn-primary: linear-gradient(135deg, #2563EB 0%, #3B82F6 100%);
  
  --text-main: #F8FAFC;
  --text-muted: #94A3B8;
  --text-disabled: #475569;
  --text-on-primary: #FFFFFF;
  --text-link: #93C5FD;
  
  --border-light: #334155;
  --border-focus: #60A5FA;
  
  --shadow-card: 0 10px 25px -5px rgba(0, 0, 0, 0.4);
  --shadow-button: 0 8px 20px rgba(96, 165, 250, 0.25);
}
```

---

## 4. Tipografi Sistemi & Hiyerarşi

- **Font Ailesi**: `'Plus Jakarta Sans', system-ui, -apple-system, sans-serif`  
  (Yumuşak kavisler, modern geometri ve harika okunabilirlik).

```css
/* Logo Tipografisi */
.brand-small-tick {
  font-family: var(--font-family-primary);
  font-size: 14px;
  font-weight: 300;
  letter-spacing: 0.08em;
  text-transform: uppercase;
}

.brand-big-grow {
  font-family: var(--font-family-primary);
  font-size: 24px;
  font-weight: 800;
  letter-spacing: -0.02em;
  line-height: 1.1;
}

/* Sayfa Başlığı (Topbar - "Hoşgeldin Ayşe") */
.font-topbar-title {
  font-size: 20px;
  font-weight: 700;
  letter-spacing: -0.01em;
}

/* Mottolar & Karşılama */
.font-hero-motto {
  font-size: 26px;
  line-height: 34px;
  font-weight: 800;
}

/* Bölüm Başlıkları ("Bugünkü Alışkanlıklar", "Rozetlerin") */
.font-heading {
  font-size: 18px;
  line-height: 24px;
  font-weight: 700;
}

/* Alışkanlık Maddesi Başlığı */
.font-habit-title {
  font-size: 16px;
  font-weight: 600;
}

/* Altı Çizili Bağlantılar & Aksiyonlar ("Giriş yap", "İlerle", "Şifremi unuttum") */
.font-link-btn {
  font-size: 14px;
  font-weight: 600;
  text-decoration: underline;
  text-underline-offset: 4px;
  color: var(--text-link);
  cursor: pointer;
}
```

---

## 5. UI Bileşenleri & Ekran Davranışları

### 5.1. Alışkanlık Kartı (Habit Card - "Small Tick")
- **Sol**: Kategoriye özel pastel dairesel ikon yuvası (`💧 Su`, `📖 Kitap`, `🏃 Yürüyüş`).
- **Orta**: 
  - Alışkanlık adı (`font-habit-title`)
  - Altında seri bilgisi: `🔥 7 Günlük Seri • Her gün`
- **Sağ (Tick Butonu)**:
  - **Bekleyen**: Yumuşak kenarlı daire veya yuvarlatılmış kare (`border-2 border-primary-light hover:border-primary`).
  - **Tıklandığında (Small Tick)**:
    - İçi nane yeşili gradyan (`var(--grad-tick-success)`) ile dolar.
    - İçinde beyaz tatlı onay işareti (`✓`).
    - Alışkanlık ismi grileşir (`var(--text-disabled)`) ve üzeri çizilir (`line-through`).
    - Arka plan hafif mint pastel parıltı alır.
    - Anlık mikro konfeti / yıldız patlaması efekti.

### 5.2. Alttan Açılır Modal (Duygu & Farkındalık Notu)
- Alışkanlık tamamlandığında nazikçe açılan opsiyonel bottom sheet (`rounded-t-3xl`).
- **Başlık**: *"Bu adımı tamamlamak sana nasıl hissettirdi?"*
- **Duygu Butonları**: 5 sevimli büyük emoji hapı (🤩 Harika, 😊 Mutlu, 😌 Dingin, 🥱 Yorgun, 🤯 Zorlayıcı).
- **Farkındalık Notu Girişi**: Yumuşak textarea (*"Bana neler düşündürdü / ne fark ettim?"*).
- **Aksiyon**: *"Notu Kaydet & Büyümeye Devam Et"*.

### 5.3. Seri & Rozet Sistemi ("Big Grow" Eşikleri)
- **Her 5 Tamamlama**: Mini motivasyon rozeti.
- **21 Gün Serisi**: 🥈 "Gümüş Penguen" Rozeti (Alışkanlık oluşum eşiği).
- **42 Gün Serisi**: 🥇 "Altın Penguen" Rozeti (Kalıcı büyüme ustası).
- **66+ Gün Serisi**: 💎 "Elmas Penguen" Rozeti (Büyük Dönüşüm).

### 5.4. Topbar & Bottombar Standartları
- **Topbar**: Solda `Hoşgeldin Ayşe` (veya penguen mini avatarı), sağda bildirim zili (`🔔`) ve dil seçici (`TR / EN`).
- **Yüzen Bottombar**: Yuvarlatılmış hap formunda 4 ana sekme:
  1. 🏠 Anasayfa
  2. 📅 Takvim (Haftalık, 2 Haftalık, Aylık, 2 Aylık, 3 Aylık filtreli)
  3. 📊 Analiz & Grafikler (Yumuşak `%52` devamlılık halkası, duygu dağılımı)
  4. 👤 Profil (Kişiselleştirme, bildirim ayarları, motivasyon sözü bildirimleri, duygu günlüğü)

### 5.5. Boş Durum (Empty State)
- Elinde minik bir ajanda tutan gülümseyen sevimli penguen illüstrasyonu.
- Metin: *"Hiç alışkanlık eklememişsin!"*
- Alt Metin: *"Büyük hedefler, küçük bir tik ile başlar."*
- Buton: `+ İlk Alışkanlığını Ekle` (Gradyanlı buton).

---

## 6. Çoklu Dil Metin Standartları (TR / EN)

| Anahtar | Türkçe (TR) | İngilizce (EN) |
|---|---|---|
| `brand_sub` | Small Tick | Small Tick |
| `brand_main` | Big Grow | Big Grow |
| `motto_welcome` | "Küçük adımlar, büyük hedeflerin ruhudur." | "Small steps are the soul of great goals." |
| `motto_ready` | "Hedeflerine ulaşmak için alışkanlıkların gücünden yararlanmaya hazır mısın?" | "Ready to harness the power of habits to reach your goals?" |
| `empty_state_title` | "Hiç alışkanlık eklememişsin!" | "You haven't added any habits yet!" |
| `empty_state_desc` | "Büyük hedefler, küçük bir tik ile başlar." | "Big goals start with a small tick." |
| `notification_sample` | "Haydi şimdi bir bardak su iç 💧 / birkaç sayfa kitap oku 📖" | "Time for a glass of water 💧 / read a few pages 📖" |
| `btn_signin` | Giriş Yap | Sign In |
| `btn_signup` | Kayıt Ol | Sign Up |
| `btn_forgot_password` | Şifremi Unuttum | Forgot Password |
| `btn_next` | İlerle | Continue |
