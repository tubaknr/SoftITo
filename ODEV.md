# 15 EYLÜL ÖDEVİ

**Tuba Aydın**

---

## GÖREV 1: Mobil Akış Şeması (Flowchart) ve Sözde Kod

### Akış Şeması

```mermaid
flowchart TD
    A([BAŞLA]) --> B{Login durumu?}
    B -- Evet --> C[Market sayfasına yönlendirilir]
    B -- Hayır --> D[Login sayfası açılır]
    D --> E[Kullanıcının giriş yapması beklenir]
    E --> C
    C --> F[Ürünler seçilir]
    F --> G[Seçilen ürünler sepete eklenir]
    G --> H[Sipariş onaylanır]
    H --> I{cuzdan_bakiyesi >= sepet_toplami?}
    I -- Evet --> J[cuzdan_bakiyesi -= sepet_toplami]
    J --> K[Sipariş database'e kaydedilir]
    K --> L[Müşteriye ve şubeye bildirim gönderilir]
    L --> M[Siparişiniz Alındı sayfası gösterilir]
    M --> N([BİTİR])
    I -- Hayır --> O[Bakiye yükle uyarısı verilir]
    O --> P[Kullanıcı bakiye yükleme ekranına yönlendirilir]
    P --> N
```

### Sözde Kod (Pseudocode)

```
BAŞLA

1. OTURUM KONTROLÜ

EĞER login İSE:
    market sayfasına yönlendirilir
DEĞİLSE:
    login sayfası açılır
    Kullanıcının giriş yapması beklenir
BİTTİ_EĞER

2. ÜRÜN SEÇİMİ

Market sayfasından ürünleri seçer
Seçilen ürünler sepete eklenir
Siparişi onaylar

3. BAKİYE KONTROLÜ VE ONAYLAMA

EĞER cuzdan_bakiyesi >= sepet_toplami İSE
    cuzdan_bakiyesi -= sepet_toplami;
    Sipariş database'e kaydedilir
    Müşteriye, şubeye bildirimler ve gerekli bilgiler gönderilir
    Siparişiniz Alındı sayfası gösterilir
DEĞİLSE:
    bakiye yükle uyarısı verilir
    Kullanıcı bakiye yükleme ekranına yönlendirilir
BİTTİ_EĞER

BİTİR
```

---

## GÖREV 2: REST API Endpoint & JSON Tasarımı

### 1. Sipariş Oluşturma Endpoint'i

**Metot / URL**

```
POST /api/v1/siparisler
```

**Header**

```http
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json
Idempotency-Key: 7f3b1a9e-2c4d-4e8a-9b1f-3d5e6a7b8c9d
```

**Request Body**

```json
{
  "urunler": [
    {
      "urunId": "kahve_americano",
      "boyut": "orta",
      "adet": 2,
      "birimFiyat": 65.0
    },
    {
      "urunId": "kahve_latte",
      "boyut": "buyuk",
      "adet": 1,
      "birimFiyat": 75.0
    }
  ],
  "toplamTutar": 205.0,
  "sube_id": "izmit_merkez_01",
  "teslim_tipi": "gel_al"
}
```

**Başarılı Response — `201 Created`**

```http
HTTP/1.1 201 Created
Location: /api/v1/siparisler/sip_98234
Content-Type: application/json
```

```json
{
  "data": {
    "siparisId": "sip_98234",
    "durum": "hazirlaniyor",
    "urunler": [
      {
        "urunId": "kahve_americano",
        "boyut": "orta",
        "adet": 2,
        "birimFiyat": 65.0
      },
      {
        "urunId": "kahve_latte",
        "boyut": "buyuk",
        "adet": 1,
        "birimFiyat": 75.0
      }
    ],
    "toplamTutar": 205.0,
    "kalanBakiye": 340.5,
    "olusturulmaTarihi": "2026-09-15T14:40:00Z",
    "tahminiHazirlanmaSuresi": "8 dakika"
  }
}
```

**Başarısız Response — `401 Unauthorized`**

```http
HTTP/1.1 401 Unauthorized
WWW-Authenticate: Bearer realm="kahvego-api", error="invalid_token"
Content-Type: application/json
```

```json
{
  "error": {
    "code": "UNAUTHORIZED",
    "message": "Bu işlem için giriş yapmanız gerekiyor"
  }
}
```

**Diğer Hata Durumları**

| Senaryo                   | Status Kodu                 |
| ------------------------- | --------------------------- |
| Bakiye yetersiz           | `409 Conflict`              |
| Sepet boş / geçersiz veri | `400 Bad Request`           |
| Ürün stokta yok           | `409 Conflict`              |
| Şube kapalı               | `409 Conflict`              |
| Sunucu hatası             | `500 Internal Server Error` |

---

### 2. Cüzdan Bakiye Sorgulama Endpoint'i

**Metot / URL**

```
GET /api/v1/kullanici/bakiye
```

> Not: `kullaniciId` URL'de taşınmaz — kimlik `Authorization` token'ından çözülür. Bu hem IDOR saldırılarına karşı güvenlik sağlar hem de REST'in stateless prensibine uygundur.

**Header**

```http
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Accept: application/json
```

**Başarılı Response — `200 OK`**

```json
{
  "data": {
    "bakiye": 185.5,
    "para_birimi": "TRY",
    "son_guncelleme": "2026-09-15T14:32:00Z"
  }
}
```

**Sunucuda Beklenmeyen Hata — `500 Internal Server Error`**

```json
{
  "error": {
    "code": "INTERNAL_ERROR",
    "message": "Bir hata oluştu, lütfen tekrar deneyin"
  }
}
```

---

### Mini Mülakat Sorusu

**Soru:** GET ve POST arasındaki idempotency farkı nedir?

**Cevap:** GET idempotent'tir — yani aynı istek 100 defa yollansa da sunucudaki veri/durum değişmez, her seferinde aynı sonuç döner. POST ise idempotent değildir — aynı istek 100 kere yollanırsa her yollayışta yeni bir kayıt (örneğin yeni bir sipariş) oluşturulur. Bu nedenle sipariş oluşturma gibi kritik POST işlemlerinde, kullanıcının yanlışlıkla aynı isteği tekrar göndermesine karşı `Idempotency-Key` header'ı kullanılır.

---

## GÖREV 3: Clean Code & SOLID

### 1. SRP (Single Responsibility Principle) İhlali

**Tespit:** `KahveSiparisYoneticisi` sınıfı içine business logic'in tüm başlıkları eklenmiş, spagetti bir kod oluşturulmuş. Tek bir sınıf 4 farklı sorumluluk taşıyor:

- `sepetHesaplaVeIndirimUygula()` → fiyatlandırma sorumluluğu
- `krediKartindanTahsilatYap()` → ödeme sorumluluğu
- `siparisiVeritabaninaKaydet()` → veri kalıcılığı sorumluluğu
- `musteriyiSmsIleBilgilendir()` → bildirim sorumluluğu

Bu 4 sorumluluk farklı sebeplerle değişir (kampanya kuralı, ödeme sağlayıcısı, veritabanı teknolojisi, SMS sağlayıcısı) — bu da SRP'nin _"bir sınıfın değişmesi için tek bir sebep olmalı"_ prensibini ihlal eder.

**Çözüm:** Her sorumluluk kendi sınıfına ayrılmalı:

- `FiyatHesaplayici`
- `OdemeIslemcisi`
- `SiparisDeposu`
- `MusteriBildirimServisi`

Bu sınıfların instance'ları, akışı yöneten ayrı ve ince bir **orkestrasyon/servis sınıfı** (`SiparisOnaylamaServisi`) içerisinde oluşturulur; fonksiyonlar oradan çağrılır. Böylece hiçbir sınıf diğerinin iç mantığını bilmez (loose coupling), test edilebilirlik ve bakım kolaylığı artar.

### 2. OCP (Open-Closed Principle) İhlali

**Tespit:** Yeni bir müşteri tipi eklendiğinde mevcut `if/else` bloklarının değiştirilmesi gerekiyor. OCP, _"open for extension, closed for modification"_ der — yani kod genişletilebilir olmalı ama mevcut, çalışan kod değiştirilmemeli. Burada yeni müşteri tipi eklerken değişmemesi gereken kod değiştiriliyor, bu da OCP ihlalidir.

**Çözüm:** Polymorphism ve abstraction kullanmak:

- Her müşteri tipi için ayrı bir sınıf yazılır
- Ortak bir interface/abstract class implemente edilir
- Yeni müşteri tipi eklenmek istendiğinde mevcut kod değiştirilmez, sadece yeni bir sınıf eklenir (extension)

---
