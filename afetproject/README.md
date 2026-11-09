---
proje: egitim
tur: 6sarli_teslim_projesi
grup: "2. Grup"
proje_adi: "AfetNet — Canlı Kriz Yönetimi, Acil Yardım Çağrısı ve Gönüllü Koordinasyon Ağı"
sektor: "Sosyal Sorumluluk, Canlı Afet & Acil Kriz Yönetimi (Emergency & NGO Coordination)"
teslim_tarihi: 2026-11-13
durum: aktif_gelistirme
uye_sayisi: 6
tags:
  - proje/egitim
  - teslim_projesi
  - buyuk_grup
  - flutter
  - softito
  - firebase
---

# 🚀 SoftITO 4. Dönem Mobil — 2. Grup Büyük Teslim Projesi

> **Grup Adı:** **2. Grup (6 Kişilik Büyük Teslim Proje Takımı)**  
> **Ekip Üyeleri:** Hasibe Esra Ergün, Meryem Duymuş, Furkan Çalışkan, Somaya Arab, Tuba Aydın, Mustafa Ersoy  
> **Proje Başlığı:** **AfetNet — Canlı Kriz Yönetimi, Acil Yardım Çağrısı ve Gönüllü Koordinasyon Ağı**  
> **Sektörel Alan:** `Sosyal Sorumluluk, Canlı Afet & Acil Kriz Yönetimi (Emergency & NGO Coordination)`  
> **Mimari Standart:** Flutter SDK & Clean Architecture + Full Firebase Entegrasyonu  
> **Çift Yönlü Rol Modeli:** Zorunlu (Rol 1: Kullanıcı Portalı vs Rol 2: Yönetici/Sağlayıcı Portalı)  
> **Büyük Teslim & Demo Day:** 13 Kasım 2026 Cuma (Canlı Jüri Sunumu)

---

## 🧭 Hızlı Navigasyon & Bağlantılar
- 📋 **Büyük Teslim Grupları Komuta Paneli:** [[02_PROJELER/egitim/ogrenci_projeleri/6sarli_teslim_projeleri/README|🚀 4 Büyük Teslim Grubu Komuta Merkezi]]
- 👥 **Öğrenci Takip Paneli:** [[02_PROJELER/egitim/ogrenciler|👥 SoftITO Öğrenci Listesi]]
- 🎓 **22 Bireysel Bitirme Projeleri:** [[02_PROJELER/egitim/ogrenci_projeleri/bireysel_bitirme_projeleri/README|🎓 Bireysel Bitirme Projeleri]]
- ⚡ **Eğitim Master Context:** [[02_PROJELER/egitim/egitim|⚡ Eğitim Master Context]]

---

## 🎯 1. Proje Açıklaması & Kapsamı

### 🌟 Projenin Amacı ve Vizyonu
Deprem, sel, yangın gibi kriz durumlarında vatandaşlar ile arama-kurtarma ekiplerini ve STK'ları gerçek zamanlı harita ve veri akışıyla buluşturan; afetzedelerin acil durum bildirdiği, ekiplerin enkaz/ihtiyaç lojistiğini ve sahra deposu stoklarını canlı yönettiği reaktif kriz yönetim ekosistemi.

Bu proje; 6 kişilik bir yazılım mühendisliği ekibinin 1 hafta boyunca tam zamanlı çalışarak uçtan uca, store kalitesinde, kurumsal mimariyle ve çift taraflı rol yönetimiyle geliştireceği büyük ölçekli bir bitirme ürünüdür.

---

### 🎭 Çift Yönlü Rol Modeli (Role-Based Dual Mode)

Uygulama iki farklı kullanıcı tipine hizmet verecek şekilde tasarlanacaktır. Giriş yapan kullanıcının rolüne göre arayüz, yetkiler ve dashboard dinamik olarak değişecektir:

#### 👤 1. Modül: Vatandaş / Kazazede / Afetzede Modu (Sivil Kullanıcı)
- **Tek Dokunuşla 'GÜVENDEYİM / TEHLİKEDEYİM' Panik Butonu:** Aile fertlerine ve sisteme anlık durum ve son GPS koordinatı sinyali fırlatma.
- **Acil Yardım & İhtiyaç Çağrısı Açma:** İhtiyaç türü (Enkaz Altında, Tıbbi Müdahale, Çadır/Barınma, Temiz Su, Bebek Maması, Isınma), kişi sayısı, açık adres tarifi ve fotoğraf yükleme.
- **Çevrimdışı Kriz Rehberi & Düdük Modu:** İnternet kesildiğinde ekranın en yüksek sesle acil durum düdüğü çalması, mors kodu ile flaş yakıp söndürme ve SMS köprüsüyle konum paylaşma.
- **Toplanma Alanları & Sahra Hastaneleri Rehberi:** Civardaki güvenli toplanma alanlarının mesafesi, kapasitesi ve açık/kapalı durum listesi.
- **Kayıp / Yakın Arama Panosu:** Afet bölgesindeki yakınlarının adını aratarak hastane veya tahliye listelerindeki durumunu sorgulama.

#### 🏢 2. Modül: AFAD / Kızılay / STK Koordinatör & Gönüllü Modu (Saha Yönetimi)
- **Canlı Kriz Haritası & Çağrı Akışı:** Firestore Stream ile harita/liste üzerinde anlık beliren kırmızı çağrı pinleri, öncelik rozetleri (Kritik, Acil, Normal).
- **Görev Atama & Ekip Yönlendirme:** Gelen yardım talebine en yakın arama-kurtarma timini veya kuryeyi atama (Atandı -> Yola Çıktı -> Olay Yerinde -> Kurtarıldı / Çözüldü durum akışı).
- **Sahra Deposu & Lojistik Envanter Takibi:** Gelen ayni yardımların (Koli koli battaniye, su, jeneratör) depoya giriş-çıkış sayımı ve stok kritik seviye uyarıları.
- **Gönüllü Havuzu & Yetenek Yönetimi:** Bölgeye gelen gönüllülerin uzmanlıklarına göre (İlk Yardımcı, Şoför, Aşçı, Psikososyal Destek, Vinç Operatörü) tasnifi ve vardiya yönetimi.
- **Kriz Bölgesi Acil Durum Tahliye Anonsu (FCM Broadcast):** Belirli bir koordinat çemberindeki tüm kullanıcılara 'Acil Tahliye' veya 'Artçı Sarsıntı Uyarısı' push bildirimi yayını.

---

### ⚙️ Temel İş Kuralları & Kritik Mantık Akışları (Business Rules)
6 kişilik ekibin 1 hafta boyunca kodlayacağı kritik iş mantıkları şunlardır:

1. **Realtime Öncelik Skoru (Triage):** Enkaz altında veya yaralı çağrıları sistemde 1. öncelik (Kırmızı) alır ve listenin en tepesine kilitlenir; malzeme talepleri 2. ve 3. önceliğe ayrılır.
2. **Mükerrer Çağrı Filtresi:** Aynı bina veya 50 metre koordinat çemberinden açılan mükerrer çağrılar sistemde tek bir olay dosyası altında birleştirilir.
3. **Stok Azalma Mantığı:** Sahra deposundan bir yardım ekibine 50 koli su zimmetlendiğinde, ana depo stoğu anlık reaktif Firestore Transaction ile düşer.
4. **Çevrimdışı Dayanıklılık:** İnternet koptuğunda kullanıcının acil çağrısı cihaz yerel belleğine (Hive/SQLite) yazılır; internet geldiği anda kuyruktan otomatik Firestore'a basılır.
5. **Gizlilik & Güvenlik Kalkanı:** Kazazede telefon numaraları ve açık kimlik bilgileri sadece doğrulanmış STK/AFAD koordinatör hesaplarına görünür.

---

## 🛠️ 2. İstediğim Teknolojiler & Mimari Standartlar

Projede derste kapsamlı olarak işlediğimiz kurumsal mobil geliştirme teknolojileri ve standartları eksiksiz kullanılacaktır:

- **Mobil Framework & Dil:** Flutter SDK (En güncel kararlı sürüm) & Dart (Strict Type Safety, Null Safety)
- **Mimari Disiplin:** Kurumsal Clean Architecture (`core`, `data`, `domain`, `presentation`) & Katmanlı Klasör Düzeni
- **Kimlik Doğrulama (Auth):** Firebase Authentication (Email/Şifre, opsiyonel Google Sign-In, Rol tabanlı Custom Claims / Profil eşleme)
- **Veritabanı & Canlı Veri:** Cloud Firestore (NoSQL, Realtime Streams, Subcollections, Composite Queries, Atomik Transactions & Batch Writes)
- **Medya & Belge Saklama:** Firebase Storage (Profil fotoğrafları, makbuz/fiş/rapor/ödev dosyaları, ImagePicker, Yükleme Stream'i & İlerleme Barı)
- **Push Bildirimleri & Uyarılar:** Firebase Cloud Messaging (FCM) & `flutter_local_notifications` (Ön plan, arka plan, topic tabanlı toplu duyurular)
- **Hata Takibi & Analitik:** Firebase Crashlytics & Firebase Analytics (Kritik kullanıcı aksiyonları, özel event logları)
- **State Management:** BLoC / Cubit veya Provider / Riverpod (Tek bir kurumsal standart seçilmeli, spagetti setState yasaktır)
- **Navigasyon Mimarisi:** GoRouter (ShellRoute ile kalıcı BottomNavigationBar, Deep Linking, Rol bazlı Route Guards / Yönlendirme Kalkanı)
- **Yerel Depolama (Offline Cache):** SharedPreferences veya Hive / SQLite (Oturum token'ı, çevrimdışı taslaklar, tema tercihleri)
- **Tasarım Sistemi & UI/UX:** Material 3 (ColorScheme.fromSeed, Açık ve Koyu Tema, Akıcı Mikro Animasyonlar, Hero, CustomPainter grafikler)
- **Form & Validasyon Güvencesi:** `Form` & `GlobalKey<FormState>`, Regex validatörleri, InputFormatters, TextEditingController yaşam döngüsü (`dispose`)
- **Kalite & Güvenilirlik:** Sıfır `RenderFlex overflow` (sarı-siyah taşma) kuralı, asenkron `mounted` kontrolleri, Unit & Widget testleri
- **Versiyon Kontrol & Git-Flow:** `main` (Stabil), `develop` (Entegrasyon) ve `feat/<isim>-<modul>` feature branch'leri, PR (Pull Request) onay mekanizması

---

## 📋 3. Ekip Tarafından Tamamlanacak Çalışma Alanı

> [!NOTE]
> Bu bölüm projenin teknik şartnamesi doğrultusunda **6 kişilik öğrenci ekibi tarafından** doldurulacak, mimari kararlar, ekran tasarımları, DTO modelleri ve GitHub repo ilerlemeleri burada belgelenecektir.

### 👥 3.1. Takım İçi 6 Kişilik Görev Dağılımı ve Sorumluluk Matrisi
*(Ekip üyeleri mimari katmanlara ve ekranlara göre görev dağılımını buraya işleyecektir)*

- [ ] **Geliştirici 1 (Team Lead & Core Architecture):** Core katmanı, Base sınıflar, Git branch kuralları, Theme & Dependency Injection.
- [ ] **Geliştirici 2 (UI / UX & Design System Lead):** Material 3 teması, Renk paleti, Custom Widgets, Splash Screen, App Icon.
- [ ] **Geliştirici 3 (Network, API & Firebase Lead):** Firebase Auth, Firestore servisleri, Storage bağlantısı, FCM altyapısı.
- [ ] **Geliştirici 4 (Data Models & DTO Lead):** Entity ve DTO modelleri (`fromJson`, `toJson`, `copyWith`), Firestore veri şeması.
- [ ] **Geliştirici 5 (State Management & Logic Lead):** BLoC / Cubit / Riverpod akışları, Event/State sınıfları, Reaktif dinleyiciler.
- [ ] **Geliştirici 6 (Feature Screens & QA / Test Lead):** Form validasyonları, 4 durum yönetimi (Loading, Error, Empty, Success), Unit/Widget testleri.

### 📱 3.2. Ekran Listesi ve Kullanıcı Akış Şeması
*(Ekip geliştireceği en az 8-10 kurumsal ekranın listesini ve akış haritasını buraya çıkaracaktır)*

### 🗄️ 3.3. Cloud Firestore Veri Şeması (Koleksiyon & Döküman Tasarımı)
*(Koleksiyonlar, alt koleksiyonlar ve belge alanları burada şematize edilecektir)*

### 🔗 3.4. GitHub Repository & Sprint Takip Bilgileri
- **GitHub Repo Linki:** *[Repo URL buraya eklenecek]*
- **Sprint 1 (09 - 10 Kasım):** Mimari kurulum, modeller, auth ve temel ekran iskeletleri.
- **Sprint 2 (11 - 12 Kasım):** Çift yönlü rollerin canlı bağlanması, Storage, FCM, 4 durum kalkanı ve testler.
- **Demo Day (13 Kasım):** Canlı emülatör/cihaz sunumu ve jüri değerlendirmesi.

---
*Belge Oluşturuldu: 2026-11-09 — Antigravity E-Mektep & SoftITO Mobil Büyük Teslim Projeleri Sistemi*
