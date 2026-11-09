# AfetNet — Cloud Firestore Veri Şeması (Şartname 3.3)

Hazırlayan: Geliştirici 4 (Data Models & DTO Lead)

## 1. Koleksiyon Ağacı

KOLEKSİYONLAR---------------------------------------------------------------------------------
users/{uid}                          -> AppUser (herkese açık profil) // Giriş yapan kullanıcının açık profili. doc id = Firebase Auth uid.
  └─ private/contact                   -> PrivateContact (GİZLİ)  // Kişisel / gizli bilgiler. Sadece doğrulanmış koordinatör okuyabilir.
volunteers/{uid}                     -> Volunteer // Gönüllü havuzu profili
shifts/{shiftId}                     -> VolunteerShift // gönüllü vardiyası
teams/{teamId}                       -> Team // arama kurtarma ekibi
safety_signals/{signalId}            -> SafetySignal // "GÜVENDEYİM / TEHLİKEDEYİM" panik butonu sinyali.
help_requests/{requestId}            -> HelpRequest // Acil yardım / ihtiyaç çağrısı. Telefon ve ad bilgisi alt dokümanda (private/contact).
                                        1 kritik, 2 acil, 3 normal
  └─ private/contact                   -> PrivateContact (GİZLİ)
incidents/{incidentId}               -> Incident (mükerrerler burada birleşir) // Olay dosyası: mükerrer çağrılar tek dosyada birleşir
assignments/{assignmentId}           -> Assignment // Çağrı -> ekip görev ataması. Atandı->Yola Çıktı->Olay Yerinde->Kurtarıldı
warehouses/{warehouseId}             -> Warehouse // Sahra deposu.
  ├─ inventory/{itemId}              -> InventoryItem // Depodaki stok kalemi.
  └─ movements/{movementId}          -> StockMovement // Stok giriş/çıkış kaydı
assembly_points/{pointId}            -> AssemblyPoint // Toplanma alanı / sahra hastanesi / barınma alanı.
missing_persons/{personId}           -> MissingPerson // Kayıp / yakın arama panosu kaydı.
broadcasts/{broadcastId}             -> EvacuationBroadcast // Bölgesel tahliye / artçı uyarısı yayını (FCM).

KULLANICILAR: USERS, VOLUNTEERS, TEAMS
ÇAĞRILAR: SAFETY_SIGNALS (PANİK BUTONU), HELP_REQUESTS (YARDIM ÇAĞRISI, DÜDÜK, SMS), INCIDENTS (OLAY DOSYASI)
GÖREVLER: ASSIGNMENTS, SHIFTS
LOJİSTİK: WAREHOUSES, INVENTORY, MOVEMENTS
DUYURU: BROADCASTS 

* GİZLİ BİLGİ AYRI DOKÜMANDA. TEL, KİMLİK PRIVATE ALTINDA.
* ÇEVRİMDIŞI İÇİN HIVE. 
* ÇEVRİMİÇİ İÇİN FIRESTORE. 

## 2. Tasarım kararları (iş kurallarına karşılık)

1. **Triage (İş Kuralı 1):** `help_requests.priority` ve `incidents.priority` sayı olarak tutulur (1 kritik, 2 acil, 3 normal). Koordinatör listesi `incidents` üzerinde `orderBy('priority').orderBy('createdAt')` ile dinlenir; enkaz/tıbbi çağrılar `HelpType.defaultPriority` ile otomatik kırmızı olur.
2. **Mükerrer filtre (İş Kuralı 2):** Her çağrıya `geohash` (precision 8, yaklaşık 38x19 m) yazılır. Yeni çağrıda komşu geohash hücreleri sorgulanır, adaylar `GeoLocation.distanceTo <= 50` ile elenir. Eşleşme varsa tek **Transaction** içinde: yeni çağrının `incidentId`'si set edilir ve `status = merged` olur; `incidents/{id}.requestIds` arrayUnion, `requestCount` ve `totalPeople` artar. Eşleşme yoksa yeni `Incident` oluşur. Koordinatör paneli sadece `incidents` dinler.
3. **Stok (İş Kuralı 3):** `inventory/{item}.quantity` yalnızca Transaction ile değişir: oku -> yeterli mi kontrol et -> `quantity` düş + `isCritical` güncelle + `movements` kaydı ekle. `isCritical` ayrı alandır çünkü Firestore iki alanı birbiriyle kıyaslayamaz.
4. **Çevrimdışı (İş Kuralı 4):** Çağrı oluşturulurken id istemcide üretilir (`collection.doc().id`). `HelpRequestModel.toLocalJson()` Hive kutusuna (`pending_help_requests`) yazılır, bağlantı gelince `HelpRequestModel.fromJson(...).toJson()` ile `set()` edilir. Id sabit olduğu için tekrar denemede çift kayıt oluşmaz. `createdOffline: true` işaretlenir.
5. **Gizlilik (İş Kuralı 5):** Ad, telefon, kimlik `private/contact` alt dokümanında tutulur; ana doküman herkese açık alanlar içerir. Kural: sadece sahibi veya `verified` koordinatör okur.
6. **FCM yayın:** FCM yarıçap bilmez. Kullanıcılar `geo_<geohash5>` topic'ine abone olur, yayın çemberi kaplayan topic'lere gönderilir (`broadcasts.targetTopics`).
7. **Rol:** `users.role` ile Auth custom claim (`role`, `verified`) aynı değerleri taşır. Route guard claim'e, Security Rules claim'e bakar.
8. **Durum akışı:** `CaseStatus`: open -> assigned -> enRoute -> onSite -> resolved. Zaman damgaları `assignments` içinde alan olarak tutulur (alt koleksiyon gerekmez).

## 3. Koleksiyon / alan tabloları

### `users/{uid}/private/contact  ve  help_requests/{id}/private/contact`  →  `PrivateContact`
Kişisel / gizli bilgiler (İş Kuralı 5). Sadece sahibi ve doğrulanmış koordinatör okuyabilir.

| Alan | Tip | Zorunlu | Not |
|---|---|---|---|
| `id` | doc id | evet | Dokümanın içine yazılmaz |
| `ownerId` | string | evet | Bilgi sahibi uid |
| `fullName` | string | evet |  |
| `phone` | string | evet | Sadece doğrulanmış STK/AFAD hesaplarına görünür |
| `identityNo` | string | hayır | Opsiyonel açık kimlik bilgisi (KVKK: mümkünse isteme) |
| `emergencyContactPhones` | array<string> | hayır | Panik butonunda bilgilendirilecek yakınlar |
| `updatedAt` | timestamp | hayır |  |

### `users/{uid}`  →  `AppUser`
Giriş yapan kullanıcının herkese açık profili. doc id = Firebase Auth uid.

| Alan | Tip | Zorunlu | Not |
|---|---|---|---|
| `id` | doc id | evet | Dokümanın içine yazılmaz |
| `displayName` | string | evet |  |
| `email` | string | evet |  |
| `role` | string (enum: UserRole) | hayır | Auth custom claim ile aynı tutulur |
| `isVerified` | boolean | hayır | Koordinatör hesabı doğrulandı mı (gizlilik kalkanı) |
| `organization` | string | hayır | AFAD / Kızılay / STK adı |
| `photoUrl` | string | hayır |  |
| `fcmTokens` | array<string> | hayır | Cihaz token'ları |
| `lastLocation` | geopoint | hayır |  |
| `createdAt` | timestamp | evet |  |
| `updatedAt` | timestamp | hayır |  |

### `safety_signals/{signalId}`  →  `SafetySignal`
"GÜVENDEYİM / TEHLİKEDEYİM" panik butonu sinyali.

| Alan | Tip | Zorunlu | Not |
|---|---|---|---|
| `id` | doc id | evet | Dokümanın içine yazılmaz |
| `userId` | string | evet |  |
| `status` | string (enum: SafetyStatus) | evet |  |
| `location` | geopoint | hayır |  |
| `geohash` | string | hayır |  |
| `note` | string | hayır |  |
| `createdAt` | timestamp | evet |  |

### `help_requests/{requestId}`  →  `HelpRequest`
Acil yardım / ihtiyaç çağrısı. Telefon ve ad bilgisi alt dokümanda (private/contact).

| Alan | Tip | Zorunlu | Not |
|---|---|---|---|
| `id` | doc id | evet | Dokümanın içine yazılmaz |
| `createdBy` | string | evet |  |
| `type` | string (enum: HelpType) | evet |  |
| `priority` | number (enum: RequestPriority) | evet | int: 1 kritik, 2 acil, 3 normal (sıralama için) |
| `status` | string (enum: CaseStatus) | hayır |  |
| `peopleCount` | number | hayır |  |
| `addressText` | string | hayır |  |
| `description` | string | hayır |  |
| `location` | geopoint | evet |  |
| `geohash` | string | evet | 50 m mükerrer filtresi için (precision 8) |
| `photoUrls` | array<string> | hayır | Storage URL'leri |
| `incidentId` | string | hayır | Bağlı olay dosyası |
| `assignedTeamId` | string | hayır |  |
| `createdOffline` | boolean | hayır | Hive kuyruğundan geldiyse true |
| `createdAt` | timestamp | evet |  |
| `updatedAt` | timestamp | hayır |  |
| `resolvedAt` | timestamp | hayır |  |

### `incidents/{incidentId}`  →  `Incident`
Olay dosyası: aynı bina / 50 m çemberindeki mükerrer çağrılar tek dosyada birleşir (İş Kuralı 2). Koordinatör paneli bunu dinler.

| Alan | Tip | Zorunlu | Not |
|---|---|---|---|
| `id` | doc id | evet | Dokümanın içine yazılmaz |
| `primaryRequestId` | string | evet |  |
| `requestIds` | array<string> | hayır |  |
| `type` | string (enum: HelpType) | evet |  |
| `priority` | number (enum: RequestPriority) | evet | Birleşen çağrıların en yükseği |
| `status` | string (enum: CaseStatus) | hayır |  |
| `location` | geopoint | evet |  |
| `geohash` | string | evet |  |
| `addressText` | string | hayır |  |
| `requestCount` | number | hayır |  |
| `totalPeople` | number | hayır |  |
| `assignedTeamId` | string | hayır |  |
| `createdAt` | timestamp | evet |  |
| `updatedAt` | timestamp | hayır |  |

### `teams/{teamId}`  →  `Team`
Arama-kurtarma timi / kurye ekibi.

| Alan | Tip | Zorunlu | Not |
|---|---|---|---|
| `id` | doc id | evet | Dokümanın içine yazılmaz |
| `name` | string | evet |  |
| `kind` | string (enum: TeamKind) | evet |  |
| `status` | string (enum: TeamStatus) | hayır |  |
| `memberIds` | array<string> | hayır |  |
| `leaderId` | string | hayır |  |
| `organization` | string | hayır |  |
| `location` | geopoint | hayır |  |
| `updatedAt` | timestamp | hayır |  |

### `assignments/{assignmentId}`  →  `Assignment`
Çağrı -> ekip görev ataması ve durum akışı zaman damgaları.

| Alan | Tip | Zorunlu | Not |
|---|---|---|---|
| `id` | doc id | evet | Dokümanın içine yazılmaz |
| `requestId` | string | evet |  |
| `incidentId` | string | hayır |  |
| `teamId` | string | evet |  |
| `assignedBy` | string | evet |  |
| `status` | string (enum: CaseStatus) | hayır |  |
| `note` | string | hayır |  |
| `assignedAt` | timestamp | evet |  |
| `enRouteAt` | timestamp | hayır |  |
| `onSiteAt` | timestamp | hayır |  |
| `resolvedAt` | timestamp | hayır |  |

### `warehouses/{warehouseId}`  →  `Warehouse`
Sahra deposu.

| Alan | Tip | Zorunlu | Not |
|---|---|---|---|
| `id` | doc id | evet | Dokümanın içine yazılmaz |
| `name` | string | evet |  |
| `location` | geopoint | evet |  |
| `address` | string | hayır |  |
| `managerId` | string | hayır |  |
| `isActive` | boolean | hayır |  |

### `warehouses/{warehouseId}/inventory/{itemId}`  →  `InventoryItem`
Depodaki stok kalemi. quantity sadece Transaction ile değişir (İş Kuralı 3).

| Alan | Tip | Zorunlu | Not |
|---|---|---|---|
| `id` | doc id | evet | Dokümanın içine yazılmaz |
| `warehouseId` | string | evet |  |
| `name` | string | evet |  |
| `category` | string (enum: ItemCategory) | hayır |  |
| `quantity` | number | hayır |  |
| `unit` | string | hayır |  |
| `criticalThreshold` | number | hayır |  |
| `isCritical` | boolean | hayır | Transaction içinde quantity <= criticalThreshold ile güncellenir (Firestore iki alanı kıyaslayamaz) |
| `updatedAt` | timestamp | hayır |  |

### `warehouses/{warehouseId}/movements/{movementId}`  →  `StockMovement`
Stok giriş/çıkış kaydı (zimmet geçmişi).

| Alan | Tip | Zorunlu | Not |
|---|---|---|---|
| `id` | doc id | evet | Dokümanın içine yazılmaz |
| `warehouseId` | string | evet |  |
| `itemId` | string | evet |  |
| `type` | string (enum: StockMovementType) | evet |  |
| `quantity` | number | evet |  |
| `teamId` | string | hayır | Zimmetlenen ekip |
| `assignmentId` | string | hayır |  |
| `performedBy` | string | evet |  |
| `note` | string | hayır |  |
| `createdAt` | timestamp | evet |  |

### `volunteers/{uid}`  →  `Volunteer`
Gönüllü havuzu profili (users/{uid} ile aynı id).

| Alan | Tip | Zorunlu | Not |
|---|---|---|---|
| `id` | doc id | evet | Dokümanın içine yazılmaz |
| `displayName` | string | evet |  |
| `skills` | array<string> (enum: VolunteerSkill) | hayır |  |
| `availability` | string (enum: VolunteerAvailability) | hayır |  |
| `isApproved` | boolean | hayır |  |
| `teamId` | string | hayır |  |
| `location` | geopoint | hayır |  |
| `createdAt` | timestamp | evet |  |

### `shifts/{shiftId}`  →  `VolunteerShift`
Gönüllü vardiyası.

| Alan | Tip | Zorunlu | Not |
|---|---|---|---|
| `id` | doc id | evet | Dokümanın içine yazılmaz |
| `volunteerId` | string | evet |  |
| `startAt` | timestamp | evet |  |
| `endAt` | timestamp | evet |  |
| `locationName` | string | hayır |  |
| `teamId` | string | hayır |  |
| `createdBy` | string | evet |  |

### `assembly_points/{pointId}`  →  `AssemblyPoint`
Toplanma alanı / sahra hastanesi / barınma alanı.

| Alan | Tip | Zorunlu | Not |
|---|---|---|---|
| `id` | doc id | evet | Dokümanın içine yazılmaz |
| `name` | string | evet |  |
| `kind` | string (enum: AssemblyKind) | evet |  |
| `location` | geopoint | evet |  |
| `geohash` | string | evet |  |
| `capacity` | number | hayır |  |
| `currentOccupancy` | number | hayır |  |
| `isOpen` | boolean | hayır |  |
| `address` | string | hayır |  |
| `updatedAt` | timestamp | hayır |  |

### `missing_persons/{personId}`  →  `MissingPerson`
Kayıp / yakın arama panosu kaydı.

| Alan | Tip | Zorunlu | Not |
|---|---|---|---|
| `id` | doc id | evet | Dokümanın içine yazılmaz |
| `fullName` | string | evet |  |
| `searchTokens` | array<string> | hayır | küçük harf, aksansız kelimeler -> array-contains araması |
| `status` | string (enum: PersonStatus) | hayır |  |
| `reportedBy` | string | evet |  |
| `age` | number | hayır |  |
| `lastKnownAddress` | string | hayır |  |
| `lastKnownLocation` | geopoint | hayır |  |
| `facilityName` | string | hayır | Bulunduğu hastane / tahliye noktası |
| `photoUrl` | string | hayır |  |
| `description` | string | hayır |  |
| `createdAt` | timestamp | evet |  |
| `updatedAt` | timestamp | hayır |  |

### `broadcasts/{broadcastId}`  →  `EvacuationBroadcast`
Bölgesel tahliye / artçı uyarısı yayını (FCM).

| Alan | Tip | Zorunlu | Not |
|---|---|---|---|
| `id` | doc id | evet | Dokümanın içine yazılmaz |
| `type` | string (enum: BroadcastType) | evet |  |
| `title` | string | evet |  |
| `message` | string | evet |  |
| `center` | geopoint | evet |  |
| `radiusMeters` | number | hayır |  |
| `targetTopics` | array<string> | hayır | Çemberi kaplayan geohash topic'leri (geo_<geohash5>) |
| `sentBy` | string | evet |  |
| `createdAt` | timestamp | evet |  |
| `expiresAt` | timestamp | hayır |  |


## 4. Enum değerleri

- **UserRole**: `citizen` (Vatandaş), `coordinator` (Koordinatör), `volunteer` (Gönüllü)
- **SafetyStatus**: `safe` (Güvendeyim), `danger` (Tehlikedeyim)
- **HelpType**: `trapped` (Enkaz Altında), `medical` (Tıbbi Müdahale), `shelter` (Çadır / Barınma), `water` (Temiz Su), `baby_food` (Bebek Maması), `heating` (Isınma)
- **RequestPriority**: `1` (Kritik), `2` (Acil), `3` (Normal)
- **CaseStatus**: `open` (Açık), `assigned` (Atandı), `en_route` (Yola Çıktı), `on_site` (Olay Yerinde), `resolved` (Kurtarıldı / Çözüldü), `merged` (Birleştirildi)
- **TeamKind**: `search_rescue` (Arama Kurtarma), `medical` (Sağlık), `courier` (Kurye), `logistics` (Lojistik)
- **TeamStatus**: `available` (Müsait), `busy` (Görevde), `offline` (Çevrimdışı)
- **ItemCategory**: `water` (Su), `blanket` (Battaniye), `food` (Gıda), `medical` (Tıbbi Malzeme), `generator` (Jeneratör), `tent` (Çadır), `hygiene` (Hijyen), `other` (Diğer)
- **StockMovementType**: `inbound` (Depoya Giriş), `outbound` (Depodan Çıkış (Zimmet))
- **VolunteerSkill**: `first_aid` (İlk Yardımcı), `driver` (Şoför), `cook` (Aşçı), `psychosocial` (Psikososyal Destek), `crane_operator` (Vinç Operatörü), `other` (Diğer)
- **VolunteerAvailability**: `available` (Müsait), `on_shift` (Vardiyada), `off_duty` (Mesai Dışı)
- **AssemblyKind**: `assembly_area` (Toplanma Alanı), `field_hospital` (Sahra Hastanesi), `shelter` (Barınma Alanı)
- **PersonStatus**: `missing` (Aranıyor), `found` (Bulundu), `hospitalized` (Hastanede), `evacuated` (Tahliye Edildi)
- **BroadcastType**: `evacuation` (Acil Tahliye), `aftershock` (Artçı Sarsıntı Uyarısı), `info` (Bilgilendirme)

## 5. Composite index listesi (`firestore.indexes.json`)

| Koleksiyon | Alanlar | Kullanım |
|---|---|---|
| incidents | status ASC, priority ASC, createdAt ASC | Canlı kriz akışı |
| help_requests | createdBy ASC, createdAt DESC | Vatandaşın kendi çağrıları |
| help_requests | status ASC, geohash ASC | Mükerrer çağrı adayı |
| assignments | teamId ASC, status ASC | Ekibin aktif görevleri |
| assignments | requestId ASC, assignedAt DESC | Çağrının atama geçmişi |
| assembly_points | isOpen ASC, geohash ASC | Yakındaki açık alanlar |
| missing_persons | searchTokens ARRAY_CONTAINS, createdAt DESC | İsimle arama |
| warehouses/{id}/inventory | isCritical ASC, name ASC | Kritik stok uyarıları |
| shifts | volunteerId ASC, startAt ASC | Gönüllü vardiya listesi |

## 6. Security Rules iskeleti

```
function isSignedIn() { return request.auth != null; }
function isVerifiedCoord() {
  return isSignedIn() && request.auth.token.role == 'coordinator'
         && request.auth.token.verified == true;
}
match /users/{uid}/private/{doc} {
  allow read: if request.auth.uid == uid || isVerifiedCoord();
  allow write: if request.auth.uid == uid;
}
match /help_requests/{id} {
  allow create: if isSignedIn() && request.resource.data.createdBy == request.auth.uid;
  allow read: if isSignedIn() && (resource.data.createdBy == request.auth.uid || isVerifiedCoord());
  allow update: if isVerifiedCoord();
  match /private/{doc} {
    allow read: if isVerifiedCoord() || get(/databases/$(database)/documents/help_requests/$(id)).data.createdBy == request.auth.uid;
    allow create: if isSignedIn();
  }
}
match /incidents/{id}  { allow read, write: if isVerifiedCoord(); }
match /warehouses/{w=**} { allow read, write: if isVerifiedCoord(); }
match /assembly_points/{id} { allow read: if isSignedIn(); allow write: if isVerifiedCoord(); }
```

## 7. Gerekli paketler

```yaml
dependencies:
  cloud_firestore: ^latest
  equatable: ^latest
  hive_flutter: ^latest   # çevrimdışı kuyruk
  dart_geohash: ^latest   # veya geoflutterfire_plus
```
Dart 3 (switch expressions + super parameters) gerekir.

## 8. Klasör yerleşimi

```
lib/domain/entities/   -> saf Dart: enums.dart, geo_location.dart, 15 entity
lib/data/models/       -> DTO'lar (*_model.dart) + firestore_converters.dart
```
`XModel extends X` olduğu için repository'ler entity döner, `toEntity()` / `fromEntity()` hazırdır.
