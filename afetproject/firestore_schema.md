# AfetNet — Cloud Firestore Veri Şeması (Şartname 3.3)

Hazırlayan: Geliştirici 4 (Data Models & DTO Lead)
Sürüm: v2 — 3 rollü giriş modeli (Afetzede / Yetkili / Genel Koordinatör)

## 0. v2 Değişiklik Özeti

| # | Değişiklik | Etkilenen yer |
|---|---|---|
| 1 | Giriş ekranında **rol seçimi** eklendi; 3 rol: `citizen` (Afetzede), `responder` (Yetkili: AFAD/Kızılay/STK/Gönüllü), `coordinator` (Genel Koordinatör) | `UserRole` enum, `users` |
| 2 | Eski `volunteer` ve eski "koordinatör" rolü kalktı. Gönüllü/AFAD/Kızılay/STK artık `responder` rolü + `responderType` alanı | `UserRole`, yeni `ResponderType` |
| 3 | Yetkili hesapları **onay sürecinden** geçer: `verificationStatus` (pending / approved / rejected). Onayı Genel Koordinatör verir | `users`, yeni `VerificationStatus` |
| 4 | `users.isVerified` kaldırıldı → `verificationStatus == approved` (entity'de getter) | `AppUser` |
| 5 | Rol kaynağı artık **`users/{uid}.role` dokümanı** (Auth custom claim opsiyonel) | Tasarım kararı 7, Security Rules |
| 6 | Security Rules 3 role göre yeniden yazıldı; kullanıcı kendi rolünü / onay durumunu değiştiremez | Bölüm 7 |
| 7 | Yeni index: onay bekleyen yetkililer listesi | Bölüm 6 |
| 8 | `users` herkese açık okuma kaldırıldı (e-posta sızıntısı riski): sadece sahibi ve staff okur | Bölüm 7 |

## 1. Rol Modeli & Giriş Akışı

### 1.1 Roller

| Rol (`UserRole`) | Ekranda adı | Kayıt olabilir mi? | Yetki başlangıcı |
|---|---|---|---|
| `citizen` | Afetzede / Vatandaş | Evet (serbest) | Hemen aktif |
| `responder` | Yetkili (AFAD / Kızılay / STK / Gönüllü vb.) | Evet | `pending` başlar, Genel Koordinatör onaylayınca aktif |
| `coordinator` | Genel Koordinatör | **Hayır** (sadece giriş) | Hesap elle oluşturulur (Firebase Console'dan `users/{uid}.role = coordinator`) |

### 1.2 Yetki Matrisi

| Özellik | Afetzede | Yetkili (onaylı) | Genel Koordinatör |
|---|---|---|---|
| GÜVENDEYİM / TEHLİKEDEYİM sinyali, yardım çağrısı açma, düdük/SMS | ✅ | — | — |
| Kendi çağrılarını görme | ✅ | — | — |
| Toplanma alanları / sahra hastaneleri listesi | ✅ | ✅ | ✅ |
| Kayıp / yakın arama panosu (arama) | ✅ | ✅ | ✅ |
| Kayıp kaydı oluşturma | ✅ | ✅ | ✅ |
| Canlı kriz haritası & olay akışı (`incidents`) | — | ✅ | ✅ |
| Gizli bilgiler (telefon, kimlik) | Sadece kendisi | ✅ | ✅ |
| Görev **atama** (`assignments` oluşturma, ekip yönlendirme) | — | — | ✅ |
| Görev durum güncelleme (Yola Çıktı → Olay Yerinde → Kurtarıldı) | — | ✅ | ✅ |
| Ekip (`teams`) oluşturma / düzenleme | — | Okur | ✅ |
| Depo tanımlama (`warehouses`) | — | — | ✅ |
| Stok giriş-çıkış (Transaction) | — | ✅ | ✅ |
| Gönüllü havuzu & vardiya yönetimi (`volunteers`, `shifts`) | — | Kendi vardiyasını görür | ✅ |
| Toplanma alanı ekleme / güncelleme | — | ✅ | ✅ |
| FCM tahliye/artçı yayını **gönderme** | Alır | Alır | ✅ Gönderir |
| Yetkili hesabı **onaylama / reddetme** | — | — | ✅ |

> Karar notu: Yayın gönderme ve görev atama sadece Genel Koordinatör'de. Hocanın "Rol 2" tanımına göre yetkili de gönderebilsin istiyorsanız Rules'ta `broadcasts` ve `assignments` create satırını `isStaff()` yapmak yeterli; şema değişmez.

### 1.3 Giriş Akışı

```
Splash
  └─ RoleSelectionScreen  (3 kart: Afetzede / Yetkili / Genel Koordinatör)
        ├─ Afetzede  → Login + Kayıt  → role=citizen, status=approved  → Afetzede Shell
        ├─ Yetkili   → Login + Kayıt (responderType, organization seçilir)
        │                → role=responder, status=pending
        │                → PendingApprovalScreen  (onaylanana kadar)
        │                → approved ise Yetkili Shell, rejected ise ReddedildiScreen
        └─ Genel Koordinatör → SADECE Login (kayıt yok) → Koordinatör Shell
```

Giriş sonrası kontrol (AuthCubit / redirect):
1. Auth başarılı → `users/{uid}` okunur.
2. `doc.role != seçilenRol` ise `signOut()` + "Bu hesap X rolüyle kayıtlı" hatası.
3. `role == responder` ve `verificationStatus != approved` → bekleme/ret ekranı.
4. GoRouter `redirect` role göre ShellRoute'a yönlendirir (`/citizen/...`, `/responder/...`, `/coordinator/...`). Yetkisiz route'a gidilirse ana ekrana döner.

**Önemli:** Rol seçim ekranı sadece UX içindir, güvenlik değil. Gerçek yetki her zaman Firestore'daki `users.role` ve Security Rules ile belirlenir. Kullanıcı ekranda "Koordinatör"ü seçse bile dokümanında `coordinator` yoksa giremez.

Bir kişi hem afetzede hem yetkili olacaksa ayrı e-posta ile ayrı hesap açar (tek hesap = tek rol).

## 2. Koleksiyon Ağacı

```
KOLEKSİYONLAR---------------------------------------------------------------------------------
users/{uid}                          -> AppUser // Giriş yapan kullanıcının profili + rol + onay durumu. doc id = Firebase Auth uid.
  └─ private/contact                   -> PrivateContact (GİZLİ)  // Kişisel / gizli bilgiler. Sahibi + staff okur.
volunteers/{uid}                     -> Volunteer // Gönüllü havuzu profili (responderType = volunteer olanlar için)
shifts/{shiftId}                     -> VolunteerShift // gönüllü vardiyası
teams/{teamId}                       -> Team // arama kurtarma ekibi
safety_signals/{signalId}            -> SafetySignal // "GÜVENDEYİM / TEHLİKEDEYİM" panik butonu sinyali.
help_requests/{requestId}            -> HelpRequest // Acil yardım / ihtiyaç çağrısı. priority: 1 kritik, 2 acil, 3 normal
  └─ private/contact                   -> PrivateContact (GİZLİ) // Telefon ve ad bilgisi burada
incidents/{incidentId}               -> Incident (mükerrerler burada birleşir) // Olay dosyası
assignments/{assignmentId}           -> Assignment // Çağrı -> ekip görev ataması. Atandı->Yola Çıktı->Olay Yerinde->Kurtarıldı
warehouses/{warehouseId}             -> Warehouse // Sahra deposu.
  ├─ inventory/{itemId}              -> InventoryItem // Depodaki stok kalemi.
  └─ movements/{movementId}          -> StockMovement // Stok giriş/çıkış kaydı
assembly_points/{pointId}            -> AssemblyPoint // Toplanma alanı / sahra hastanesi / barınma alanı.
missing_persons/{personId}           -> MissingPerson // Kayıp / yakın arama panosu kaydı.
broadcasts/{broadcastId}             -> EvacuationBroadcast // Bölgesel tahliye / artçı uyarısı yayını (FCM).

KULLANICILAR: USERS (3 rol), VOLUNTEERS, TEAMS
ÇAĞRILAR: SAFETY_SIGNALS (PANİK BUTONU), HELP_REQUESTS (YARDIM ÇAĞRISI, DÜDÜK, SMS), INCIDENTS (OLAY DOSYASI)
GÖREVLER: ASSIGNMENTS, SHIFTS
LOJİSTİK: WAREHOUSES, INVENTORY, MOVEMENTS
DUYURU: BROADCASTS
```

* GİZLİ BİLGİ AYRI DOKÜMANDA. TEL, KİMLİK PRIVATE ALTINDA.
* ÇEVRİMDIŞI İÇİN HIVE.
* ÇEVRİMİÇİ İÇİN FIRESTORE.

## 3. Tasarım kararları (iş kurallarına karşılık)

1. **Triage (İş Kuralı 1):** `help_requests.priority` ve `incidents.priority` sayı olarak tutulur (1 kritik, 2 acil, 3 normal). Yetkili/Koordinatör listesi `incidents` üzerinde `orderBy('priority').orderBy('createdAt')` ile dinlenir; enkaz/tıbbi çağrılar `HelpType.defaultPriority` ile otomatik kırmızı olur.
2. **Mükerrer filtre (İş Kuralı 2):** Her çağrıya `geohash` (precision 8, yaklaşık 38x19 m) yazılır. Komşu geohash hücreleri sorgulanır, adaylar `GeoLocation.distanceTo <= 50` ile elenir. Eşleşme varsa tek **Transaction** içinde: yeni çağrının `incidentId`'si set edilir ve `status = merged` olur; `incidents/{id}.requestIds` arrayUnion, `requestCount` ve `totalPeople` artar. Eşleşme yoksa yeni `Incident` oluşur. Panel sadece `incidents` dinler.
   - 🆕 **Rol etkisi:** Afetzede `incidents` yazamaz (Rules). Bu yüzden afetzede çağrıyı `status = open`, `incidentId = null` ile sadece `help_requests`'e yazar. Birleştirme Transaction'ını **staff tarafı** çalıştırır: yetkili/koordinatör uygulaması `status == open && incidentId == null` çağrıları dinler ve birleştirir. (Alternatif: Cloud Function; ekipte Blaze planı yoksa staff-side daha pratik.)
3. **Stok (İş Kuralı 3):** `inventory/{item}.quantity` yalnızca Transaction ile değişir: oku -> yeterli mi kontrol et -> `quantity` düş + `isCritical` güncelle + `movements` kaydı ekle. `isCritical` ayrı alandır çünkü Firestore iki alanı birbiriyle kıyaslayamaz. Transaction'ı onaylı yetkili veya koordinatör çalıştırabilir.
4. **Çevrimdışı (İş Kuralı 4):** Çağrı oluşturulurken id istemcide üretilir (`collection.doc().id`). `HelpRequestModel.toLocalJson()` Hive kutusuna (`pending_help_requests`) yazılır, bağlantı gelince `HelpRequestModel.fromJson(...).toJson()` ile `set()` edilir. Id sabit olduğu için tekrar denemede çift kayıt oluşmaz. `createdOffline: true` işaretlenir.
5. **Gizlilik (İş Kuralı 5):** Ad, telefon, kimlik `private/contact` alt dokümanında tutulur; ana doküman herkese açık alanlar içerir. Kural: sadece sahibi veya **staff** (onaylı yetkili + koordinatör) okur.
6. **FCM yayın:** FCM yarıçap bilmez. Kullanıcılar `geo_<geohash5>` topic'ine abone olur, yayın çemberi kaplayan topic'lere gönderilir (`broadcasts.targetTopics`). Yayını sadece Genel Koordinatör oluşturur; 3 rol de alır.
7. 🔄 **Rol:** Tek doğruluk kaynağı `users/{uid}.role` + `verificationStatus`. Route guard ve Security Rules bu dokümana bakar (Rules'ta `get()` ile; her kontrol 1 ek okuma maliyetli ama Cloud Function gerektirmez). Auth custom claim kullanmak isterseniz aynı değerleri claim'e de yazın, ama bunun için Admin SDK/Cloud Function lazım; teslim süresinde zorunlu değil.
8. **Durum akışı:** `CaseStatus`: open -> assigned -> enRoute -> onSite -> resolved. Zaman damgaları `assignments` içinde alan olarak tutulur (alt koleksiyon gerekmez).
9. 🆕 **Rol yükseltme koruması:** Kullanıcı kendi `role`, `verificationStatus`, `approvedBy`, `approvedAt`, `responderType` alanlarını değiştiremez. Kayıtta sadece `citizen` veya `responder` yazabilir; `coordinator` sadece elle atanır.
10. 🆕 **Yetkili onay akışı:** Koordinatör paneli `users` üzerinde `role == responder && verificationStatus == pending` sorgusunu dinler; onay/ret yazar (`approvedBy`, `approvedAt`, reddedilirse `rejectionReason`).

## 4. Koleksiyon / alan tabloları

### `users/{uid}/private/contact  ve  help_requests/{id}/private/contact`  →  `PrivateContact`
Kişisel / gizli bilgiler (İş Kuralı 5). Sadece sahibi ve staff (onaylı yetkili / koordinatör) okuyabilir.

| Alan | Tip | Zorunlu | Not |
|---|---|---|---|
| `id` | doc id | evet | Dokümanın içine yazılmaz |
| `ownerId` | string | evet | Bilgi sahibi uid |
| `fullName` | string | evet |  |
| `phone` | string | evet | Sadece onaylı staff'a görünür |
| `identityNo` | string | hayır | Opsiyonel açık kimlik bilgisi (KVKK: mümkünse isteme) |
| `emergencyContactPhones` | array<string> | hayır | Panik butonunda bilgilendirilecek yakınlar |
| `updatedAt` | timestamp | hayır |  |

### `users/{uid}`  →  `AppUser`  🔄
Giriş yapan kullanıcının profili. doc id = Firebase Auth uid. Rol ve onay durumu burada.

| Alan | Tip | Zorunlu | Not |
|---|---|---|---|
| `id` | doc id | evet | Dokümanın içine yazılmaz |
| `displayName` | string | evet |  |
| `email` | string | evet |  |
| `role` | string (enum: UserRole) | evet | `citizen` / `responder` / `coordinator`. İstemci sadece citizen veya responder yazabilir |
| `verificationStatus` | string (enum: VerificationStatus) | evet | citizen → `approved` başlar; responder → `pending` başlar; koordinatör hesabı `approved` |
| `responderType` | string (enum: ResponderType) | responder için evet | afad / kizilay / ngo / volunteer / other |
| `organization` | string | hayır | AFAD / Kızılay / STK adı |
| `approvedBy` | string | hayır | Onaylayan koordinatör uid |
| `approvedAt` | timestamp | hayır |  |
| `rejectionReason` | string | hayır | Reddedildiyse gerekçe |
| `photoUrl` | string | hayır |  |
| `fcmTokens` | array<string> | hayır | Cihaz token'ları |
| `lastLocation` | geopoint | hayır |  |
| `createdAt` | timestamp | evet |  |
| `updatedAt` | timestamp | hayır |  |

Entity'de türetilmiş alan: `bool get isVerified => verificationStatus == VerificationStatus.approved;` (Firestore'a yazılmaz.)

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
| `createdBy` | string | evet | Afetzede uid |
| `type` | string (enum: HelpType) | evet |  |
| `priority` | number (enum: RequestPriority) | evet | int: 1 kritik, 2 acil, 3 normal (sıralama için) |
| `status` | string (enum: CaseStatus) | hayır |  |
| `peopleCount` | number | hayır |  |
| `addressText` | string | hayır |  |
| `description` | string | hayır |  |
| `location` | geopoint | evet |  |
| `geohash` | string | evet | 50 m mükerrer filtresi için (precision 8) |
| `photoUrls` | array<string> | hayır | Storage URL'leri |
| `incidentId` | string | hayır | Bağlı olay dosyası (birleştirilene kadar null) |
| `assignedTeamId` | string | hayır |  |
| `createdOffline` | boolean | hayır | Hive kuyruğundan geldiyse true |
| `createdAt` | timestamp | evet |  |
| `updatedAt` | timestamp | hayır |  |
| `resolvedAt` | timestamp | hayır |  |

### `incidents/{incidentId}`  →  `Incident`
Olay dosyası: aynı bina / 50 m çemberindeki mükerrer çağrılar tek dosyada birleşir (İş Kuralı 2). Yetkili/Koordinatör paneli bunu dinler.

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
Arama-kurtarma timi / kurye ekibi. Oluşturma/düzenleme: Genel Koordinatör.

| Alan | Tip | Zorunlu | Not |
|---|---|---|---|
| `id` | doc id | evet | Dokümanın içine yazılmaz |
| `name` | string | evet |  |
| `kind` | string (enum: TeamKind) | evet |  |
| `status` | string (enum: TeamStatus) | hayır |  |
| `memberIds` | array<string> | hayır | Onaylı yetkili uid'leri |
| `leaderId` | string | hayır |  |
| `organization` | string | hayır |  |
| `location` | geopoint | hayır |  |
| `updatedAt` | timestamp | hayır |  |

### `assignments/{assignmentId}`  →  `Assignment`
Çağrı -> ekip görev ataması ve durum akışı zaman damgaları. Atamayı koordinatör yapar (`assignedBy`), durumu ekipteki yetkili ilerletir.

| Alan | Tip | Zorunlu | Not |
|---|---|---|---|
| `id` | doc id | evet | Dokümanın içine yazılmaz |
| `requestId` | string | evet |  |
| `incidentId` | string | hayır |  |
| `teamId` | string | evet |  |
| `assignedBy` | string | evet | Koordinatör uid |
| `status` | string (enum: CaseStatus) | hayır |  |
| `note` | string | hayır |  |
| `assignedAt` | timestamp | evet |  |
| `enRouteAt` | timestamp | hayır |  |
| `onSiteAt` | timestamp | hayır |  |
| `resolvedAt` | timestamp | hayır |  |

### `warehouses/{warehouseId}`  →  `Warehouse`
Sahra deposu. Oluşturma: Genel Koordinatör.

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
| `performedBy` | string | evet | İşlemi yapan staff uid |
| `note` | string | hayır |  |
| `createdAt` | timestamp | evet |  |

### `volunteers/{uid}`  →  `Volunteer`
Gönüllü havuzu profili (`users/{uid}` ile aynı id). Sadece `responderType = volunteer` olan yetkiler için oluşturulur; yetenek tasnifi ve vardiya yönetimi için.

| Alan | Tip | Zorunlu | Not |
|---|---|---|---|
| `id` | doc id | evet | Dokümanın içine yazılmaz |
| `displayName` | string | evet |  |
| `skills` | array<string> (enum: VolunteerSkill) | hayır |  |
| `availability` | string (enum: VolunteerAvailability) | hayır |  |
| `isApproved` | boolean | hayır | `users.verificationStatus` ile senkron tutulur (onayda birlikte güncellenir, Batch Write) |
| `teamId` | string | hayır |  |
| `location` | geopoint | hayır |  |
| `createdAt` | timestamp | evet |  |

### `shifts/{shiftId}`  →  `VolunteerShift`
Gönüllü vardiyası. Oluşturma: Genel Koordinatör.

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
Bölgesel tahliye / artçı uyarısı yayını (FCM). Gönderen: Genel Koordinatör.

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

## 5. Enum değerleri

- 🔄 **UserRole**: `citizen` (Afetzede / Vatandaş), `responder` (Yetkili: AFAD / Kızılay / STK / Gönüllü), `coordinator` (Genel Koordinatör)
- 🆕 **VerificationStatus**: `pending` (Onay Bekliyor), `approved` (Onaylandı), `rejected` (Reddedildi)
- 🆕 **ResponderType**: `afad` (AFAD), `kizilay` (Kızılay), `ngo` (STK), `volunteer` (Gönüllü), `other` (Diğer)
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

## 6. Composite index listesi (`firestore.indexes.json`)

| Koleksiyon | Alanlar | Kullanım |
|---|---|---|
| incidents | status ASC, priority ASC, createdAt ASC | Canlı kriz akışı |
| help_requests | createdBy ASC, createdAt DESC | Afetzedenin kendi çağrıları |
| help_requests | status ASC, geohash ASC | Mükerrer çağrı adayı |
| assignments | teamId ASC, status ASC | Ekibin aktif görevleri |
| assignments | requestId ASC, assignedAt DESC | Çağrının atama geçmişi |
| assembly_points | isOpen ASC, geohash ASC | Yakındaki açık alanlar |
| missing_persons | searchTokens ARRAY_CONTAINS, createdAt DESC | İsimle arama |
| warehouses/{id}/inventory | isCritical ASC, name ASC | Kritik stok uyarıları |
| shifts | volunteerId ASC, startAt ASC | Gönüllü vardiya listesi |
| 🆕 users | role ASC, verificationStatus ASC, createdAt ASC | Koordinatörün onay bekleyen yetkililer listesi |

## 7. Security Rules iskeleti 🔄

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // ---------- Yardımcı fonksiyonlar ----------
    function isSignedIn() { return request.auth != null; }
    function me() {
      return get(/databases/$(database)/documents/users/$(request.auth.uid)).data;
    }
    function isCoordinator() {
      return isSignedIn() && me().role == 'coordinator';
    }
    function isVerifiedResponder() {
      return isSignedIn() && me().role == 'responder'
             && me().verificationStatus == 'approved';
    }
    // Gizli bilgiyi görebilen ve sahada çalışan herkes
    function isStaff() { return isCoordinator() || isVerifiedResponder(); }

    // ---------- Kullanıcılar ----------
    match /users/{uid} {
      allow read: if isSignedIn() && (request.auth.uid == uid || isStaff());

      // Kayıt: sadece citizen veya responder; coordinator elle atanır
      allow create: if request.auth.uid == uid
        && request.resource.data.role in ['citizen', 'responder']
        && request.resource.data.verificationStatus ==
           (request.resource.data.role == 'citizen' ? 'approved' : 'pending');

      // Kendi profilini güncelle ama rol/onay alanlarına dokunma;
      // koordinatör sadece onay alanlarını günceller
      allow update: if (request.auth.uid == uid
          && !request.resource.data.diff(resource.data).affectedKeys()
              .hasAny(['role', 'verificationStatus', 'responderType',
                       'approvedBy', 'approvedAt', 'rejectionReason']))
        || (isCoordinator()
          && request.resource.data.diff(resource.data).affectedKeys()
              .hasOnly(['verificationStatus', 'approvedBy', 'approvedAt',
                        'rejectionReason', 'updatedAt']));

      match /private/{doc} {
        allow read: if request.auth.uid == uid || isStaff();
        allow write: if request.auth.uid == uid;
      }
    }

    // ---------- Çağrılar ----------
    match /safety_signals/{id} {
      allow create: if isSignedIn() && request.resource.data.userId == request.auth.uid;
      allow read: if isSignedIn() && (resource.data.userId == request.auth.uid || isStaff());
    }

    match /help_requests/{id} {
      allow create: if isSignedIn() && request.resource.data.createdBy == request.auth.uid;
      allow read: if isSignedIn() && (resource.data.createdBy == request.auth.uid || isStaff());
      allow update: if isStaff();
      match /private/{doc} {
        allow read: if isStaff()
          || get(/databases/$(database)/documents/help_requests/$(id)).data.createdBy == request.auth.uid;
        allow create: if isSignedIn();
      }
    }

    match /incidents/{id} { allow read, write: if isStaff(); }

    // ---------- Görevler / ekipler ----------
    match /assignments/{id} {
      allow read: if isStaff();
      allow create: if isCoordinator();
      allow update: if isStaff();   // durum akışını ekipteki yetkili ilerletir
    }
    match /teams/{id} {
      allow read: if isStaff();
      allow write: if isCoordinator();
    }

    // ---------- Lojistik ----------
    match /warehouses/{id} {
      allow read: if isStaff();
      allow write: if isCoordinator();
      match /{sub=**} {
        allow read, write: if isStaff();   // inventory + movements (Transaction)
      }
    }

    // ---------- Gönüllüler ----------
    match /volunteers/{uid} {
      allow read: if isSignedIn() && (request.auth.uid == uid || isStaff());
      allow create: if request.auth.uid == uid && me().role == 'responder';
      allow update: if isCoordinator()
        || (request.auth.uid == uid
            && !request.resource.data.diff(resource.data).affectedKeys()
                .hasAny(['isApproved', 'teamId']));
    }
    match /shifts/{id} {
      allow read: if isStaff() || resource.data.volunteerId == request.auth.uid;
      allow write: if isCoordinator();
    }

    // ---------- Herkese açık bilgi ----------
    match /assembly_points/{id} {
      allow read: if isSignedIn();
      allow write: if isStaff();
    }
    match /missing_persons/{id} {
      allow read: if isSignedIn();
      allow create: if isSignedIn() && request.resource.data.reportedBy == request.auth.uid;
      allow update: if isStaff();
    }
    match /broadcasts/{id} {
      allow read: if isSignedIn();
      allow write: if isCoordinator();
    }
  }
}
```

Test senaryoları (Rules Playground / emulator): (1) afetzede kendi `role`'ünü `coordinator` yapmaya çalışır → reddedilmeli; (2) `pending` yetkili `incidents` okumaya çalışır → reddedilmeli; (3) afetzede başka birinin `private/contact`'ını okumaya çalışır → reddedilmeli; (4) koordinatör yetkiliyi `approved` yapar → izinli.

## 8. Gerekli paketler

```yaml
dependencies:
  cloud_firestore: ^latest
  equatable: ^latest
  hive_flutter: ^latest   # çevrimdışı kuyruk
  dart_geohash: ^latest   # veya geoflutterfire_plus
```
Dart 3 (switch expressions + super parameters) gerekir.

## 9. Klasör yerleşimi

```
lib/domain/entities/   -> saf Dart: enums.dart (UserRole, VerificationStatus, ResponderType dahil), geo_location.dart, 15 entity
lib/data/models/       -> DTO'lar (*_model.dart) + firestore_converters.dart
```
`XModel extends X` olduğu için repository'ler entity döner, `toEntity()` / `fromEntity()` hazırdır.

## 10. Koda yansıyacak değişiklikler (Dev 4 yapılacaklar)

| Dosya | Değişiklik |
|---|---|
| `enums.dart` | `UserRole` → `citizen, responder, coordinator` (`volunteer` silinir). Yeni: `VerificationStatus`, `ResponderType` (hepsi `fromString` / `value` ile) |
| `app_user.dart` | `isVerified` alanı → `verificationStatus` + getter `isVerified`; yeni alanlar `responderType`, `approvedBy`, `approvedAt`, `rejectionReason`; `copyWith` güncelle |
| `app_user_model.dart` | `fromJson` / `toJson` yeni alanlar; eski dokümanlarda `verificationStatus` yoksa varsayılan `pending` (responder) / `approved` (diğerleri) |
| `volunteer_model.dart` | Değişmez (sadece `isApproved` onayla birlikte güncellenir) |
| Dev 3 (Auth/Firebase) | Kayıtta `role` + `verificationStatus` yazımı; girişte seçilen rol ile doküman rolü karşılaştırma |
| Dev 5 (State) | `AuthState`: `unauthenticated`, `roleMismatch`, `pendingApproval`, `rejected`, `authenticated(role)` |
| Dev 2 (UI) | `RoleSelectionScreen`, `PendingApprovalScreen`, koordinatörde `ResponderApprovalScreen` |
