// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appName => 'KiralaGo';

  @override
  String get appSlogan => 'Güvenle Kirala, Keyifle Sür';

  @override
  String get welcomeTitle => 'KiralaGo\'ya Hoş Geldiniz';

  @override
  String get welcomeSubtitle =>
      'İster aracını kirala gelir elde et, ister dilediğin aracı güvenle sür.';

  @override
  String get roleRenterButton => 'Araç kiralamak istiyorum';

  @override
  String get roleRenterDescription =>
      'Geniş araç filosundan sana en uygununu hemen kirala';

  @override
  String get roleOwnerButton => 'Araç kiralamaya vermek istiyorum';

  @override
  String get roleOwnerDescription =>
      'Aracını güvenilir kullanıcılara kirala, kazanç sağla';

  @override
  String get renterLoginTitle => 'Kiracı Girişi';

  @override
  String get ownerLoginTitle => 'Araç Sahibi Girişi';

  @override
  String get emailLabel => 'E-posta Adresi';

  @override
  String get emailHint => 'ornek@email.com';

  @override
  String get passwordLabel => 'Şifre';

  @override
  String get passwordHint => 'En az 8 karakter';

  @override
  String get rememberMe => 'Beni Hatırla';

  @override
  String get loginButton => 'Giriş Yap';

  @override
  String get noAccount => 'Hesabınız yok mu?';

  @override
  String get registerHere => 'Kayıt Olun';

  @override
  String get hasAccount => 'Zaten hesabınız var mı?';

  @override
  String get loginHere => 'Giriş Yapın';

  @override
  String get registerTitleRenter => 'Kiracı Kaydı';

  @override
  String get registerTitleOwner => 'Araç Sahibi Kaydı';

  @override
  String get firstNameLabel => 'Ad';

  @override
  String get lastNameLabel => 'Soyad';

  @override
  String get phoneLabel => 'Telefon Numarası';

  @override
  String get phoneHint => '05XX XXX XX XX';

  @override
  String get confirmPasswordLabel => 'Şifre Tekrar';

  @override
  String get ageLabel => 'Yaş';

  @override
  String get occupationLabel => 'Meslek';

  @override
  String get cityLabel => 'Şehir';

  @override
  String get districtLabel => 'İlçe';

  @override
  String get termsAgreement =>
      'Kullanım şartlarını ve gizlilik politikasını okudum, kabul ediyorum.';

  @override
  String get registerButton => 'Kayıt Ol';

  @override
  String get navVehicles => 'Araçlar';

  @override
  String get navMyVehicles => 'Araçlarım';

  @override
  String get navReservations => 'Rezervasyon';

  @override
  String get navProfile => 'Profil';

  @override
  String get searchVehicleHint => 'Marka, model veya şehir ara...';

  @override
  String get filterButton => 'Filtrele';

  @override
  String get filterTitle => 'Filtreler';

  @override
  String get clearFilters => 'Temizle';

  @override
  String get applyFilters => 'Uygula';

  @override
  String get sortByTitle => 'Sıralama';

  @override
  String get sortHighestRating => 'En Yüksek Puan';

  @override
  String get sortPriceAsc => 'Fiyat (Önce En Düşük)';

  @override
  String get sortPriceDesc => 'Fiyat (Önce En Yüksek)';

  @override
  String get sortYearDesc => 'Yıl (En Yeni)';

  @override
  String get sortYearAsc => 'Yıl (En Eski)';

  @override
  String get vehicleTypeTitle => 'Araç Tipi';

  @override
  String get yearRangeTitle => 'Model Yılı';

  @override
  String get brandTitle => 'Marka';

  @override
  String get modelTitle => 'Model';

  @override
  String get allBrands => 'Tüm Markalar';

  @override
  String get allModels => 'Tüm Modeller';

  @override
  String get transmissionTitle => 'Vites Türü';

  @override
  String get fuelTypeTitle => 'Yakıt Türü';

  @override
  String get seatCountTitle => 'Minimum Koltuk Sayısı';

  @override
  String get perDay => '/ gün';

  @override
  String get perHour => '/ saat';

  @override
  String get perWeek => '/ hafta';

  @override
  String get perMonth => '/ ay';

  @override
  String get hourlyPrice => 'Saatlik';

  @override
  String get dailyPrice => 'Günlük';

  @override
  String get weeklyPrice => 'Haftalık';

  @override
  String get monthlyPrice => 'Aylık';

  @override
  String get emptyVehicleList => 'Filtrelere uygun araç bulunamadı.';

  @override
  String get emptyVehicleListAction => 'Filtreleri Temizle';

  @override
  String get vehicleDetailTitle => 'Araç Detayı';

  @override
  String get technicalSpecs => 'Teknik Özellikler';

  @override
  String mileageKm(int km) {
    return '$km km';
  }

  @override
  String get plateLabel => 'Plaka';

  @override
  String get chassisLabel => 'Şase / Araç No';

  @override
  String get accidentStatusLabel => 'Kaza Durumu';

  @override
  String get viewExpertiseReport => 'Ekspertiz Raporunu Gör';

  @override
  String get expertiseReportDialogTitle => 'Ekspertiz ve Durum Raporu';

  @override
  String get pricingOptions => 'Fiyat Seçenekleri';

  @override
  String get availabilityCalendar => 'Müsaitlik Takvimi';

  @override
  String get calendarLegendBooked => 'Dolu';

  @override
  String get calendarLegendAvailable => 'Müsait';

  @override
  String get calendarLegendSelected => 'Seçili';

  @override
  String get aboutOwner => 'Araç Sahibi Hakkında';

  @override
  String responseTime(String time) {
    return 'Yanıt Süresi: $time';
  }

  @override
  String get reviewsTitle => 'Yorumlar ve Değerlendirmeler';

  @override
  String reviewsCount(int count) {
    return '($count yorum)';
  }

  @override
  String get showMoreReviews => 'Daha fazla göster';

  @override
  String get showLessReviews => 'Daha az göster';

  @override
  String get rentCtaButton => 'Hemen Kirala';

  @override
  String get selectDatesWarning =>
      'Lütfen önce takvimden kiralama tarih aralığını seçiniz.';

  @override
  String get bookedDateWarning =>
      'Seçilen tarih aralığında araç doludur, lütfen başka tarihler seçiniz.';

  @override
  String get loginRequiredWarning =>
      'Kiralama yapabilmek için lütfen giriş yapınız.';

  @override
  String get rentalFormTitle => 'Kiralama ve Teslim Sözleşmesi';

  @override
  String get vehicleInfoSection => '1. Araç Bilgileri';

  @override
  String get ownerInfoSection => '2. Araç Sahibi Bilgileri';

  @override
  String get renterInfoSection => '3. Kiracı Bilgileri';

  @override
  String get pickupSection => '4. Teslim Alma Bilgileri';

  @override
  String get pickupLocationLabel => 'Teslim Alma Yeri';

  @override
  String get pickupLocationHint => 'Örn. Kadıköy İskele Meydanı';

  @override
  String get pickupDateLabel => 'Teslim Alma Tarihi';

  @override
  String get pickupTimeLabel => 'Teslim Alma Saati';

  @override
  String get returnSection => '5. Teslim Etme Bilgileri';

  @override
  String get returnLocationLabel => 'Teslim Etme Yeri';

  @override
  String get returnLocationHint => 'Örn. Kadıköy İskele Meydanı';

  @override
  String get returnDateLabel => 'Teslim Etme Tarihi';

  @override
  String get returnTimeLabel => 'Teslim Etme Saati';

  @override
  String get pricingAndPaymentSection => '6. Ücret ve Ödeme Özeti';

  @override
  String get paymentMethodLabel => 'Ödeme Yöntemi';

  @override
  String get paymentMethodCard => 'Kredi / Banka Kartı (Güvenli Provizyon)';

  @override
  String get paymentMethodCash => 'Teslimatta Elden / Havale';

  @override
  String get totalPriceLabel => 'Toplam Tutar:';

  @override
  String get photosSection => '7. Kiralama Öncesi Dış Fotoğraflar';

  @override
  String get photosSectionDesc =>
      'Araç tesliminde 4 cepheden (Ön, Arka, Sağ, Sol) fotoğraf kontrolü:';

  @override
  String get photoFront => 'Ön Cephe';

  @override
  String get photoRear => 'Arka Cephe';

  @override
  String get photoRight => 'Sağ Yan';

  @override
  String get photoLeft => 'Sol Yan';

  @override
  String get photoAdded => 'Görsel Hazır';

  @override
  String get fuelSection => '8. Kiralama Öncesi Yakıt Seviyesi';

  @override
  String get fuelQuarter => '%25 (Çeyrek)';

  @override
  String get fuelHalf => '%50 (Yarım)';

  @override
  String get fuelThreeQuarters => '%75 (3/4)';

  @override
  String get fuelFull => '%100 (Dolu)';

  @override
  String get cameraSection => '9. Araç İçi Güvenlik Kamerası';

  @override
  String get cameraCheckboxLabel =>
      'Bu araçta güvenlik amaçlı iç kabin kamerası bulunduğunu okudum ve onaylıyorum.';

  @override
  String get insuranceSection => '10. Kasko & Sigorta Poliçesi';

  @override
  String get downloadPolicyButton => 'Poliçeyi İndir';

  @override
  String get policyDownloadedMessage =>
      'Kasko ve Sigorta poliçesi başarıyla cihazınıza indirildi.';

  @override
  String get signaturesSection => '11. Tarafların E-İmzası';

  @override
  String get renterSignatureLabel => 'Kiracı E-İmzası';

  @override
  String get ownerSignatureLabel => 'Araç Sahibi E-İmzası';

  @override
  String get signaturePadHint =>
      'Lütfen aşağıdaki kutuya parmağınızla imzanızı atınız';

  @override
  String get clearSignature => 'Temizle';

  @override
  String get saveSignature => 'İmzayı Kaydet';

  @override
  String get signatureSaved => 'İmza kaydedildi';

  @override
  String get confirmRentalButton => 'Kiralamayı Onayla ve Tamamla';

  @override
  String get rentalSuccessDialogTitle => 'Kiralama Başarılı!';

  @override
  String get rentalSuccessDialogContent =>
      'Rezervasyonunuz başarıyla oluşturuldu. Rezervasyonlarım sayfasından takip edebilirsiniz.';

  @override
  String get reservationsTitle => 'Rezervasyonlarım';

  @override
  String get tabUpcoming => 'Yaklaşan & Aktif';

  @override
  String get tabPast => 'Geçmiş';

  @override
  String get emptyReservations =>
      'Bu kategoride henüz bir rezervasyonunuz bulunmuyor.';

  @override
  String get reservationDetailTitle => 'Rezervasyon Bilgisi';

  @override
  String get reservationStatusLabel => 'Rezervasyon Durumu';

  @override
  String get paymentStatusLabel => 'Ödeme Durumu';

  @override
  String get paymentStatusPending => 'Ödeme Bekliyor';

  @override
  String get paymentStatusPaid => 'Ödendi';

  @override
  String get cancelReservationButton => 'Rezervasyonu İptal Et';

  @override
  String get simulateDelayButton => 'Gecikme Simülasyonu Yap';

  @override
  String get simulateDelayDialogTitle => 'Tahmini Varış & Gecikme Simülatörü';

  @override
  String get simulateDelayDialogContent =>
      'MockTrafficService anlık yoğunluğa göre hesapladı: Karşı tarafa yaklaşık 15 dakika gecikme bildirimi iletildi.';

  @override
  String get myVehiclesTitle => 'Araçlarım';

  @override
  String get addVehicleButton => 'Yeni Araç Ekle';

  @override
  String get editVehicleTitle => 'Aracı Düzenle';

  @override
  String get addNewVehicleTitle => 'Yeni Araç Kaydı';

  @override
  String get deleteVehicleConfirmation =>
      'Bu aracı sistemden kaldırmak istediğinize emin misiniz?';

  @override
  String get vehicleStatusAvailable => 'Müsait';

  @override
  String get vehicleStatusRented => 'Kirada';

  @override
  String get vehicleTotalEarnings => 'Toplam Gelir:';

  @override
  String get renterProfileTitle => 'Kiracı Profili';

  @override
  String get ownerProfileTitle => 'Araç Sahibi Profili';

  @override
  String get trustScoreLabel => 'Güven Puanı';

  @override
  String get ownerRatingLabel => 'Araç Sahibi Puanı';

  @override
  String get totalRentCountLabel => 'Toplam Kiralama';

  @override
  String get memberSinceLabel => 'Üyelik Tarihi';

  @override
  String get vehiclesOfOwner => 'Araç Sahibinin Diğer Araçları';

  @override
  String get aboutMe => 'Hakkında';

  @override
  String get editProfile => 'Profili Düzenle';

  @override
  String get saveProfile => 'Kaydet';

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get themeTitle => 'Tema';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get themeLight => 'Aydınlık';

  @override
  String get themeDark => 'Karanlık';

  @override
  String get languageTitle => 'Uygulama Dili';

  @override
  String get languageTr => 'Türkçe';

  @override
  String get languageEn => 'English';

  @override
  String get logoutButton => 'Çıkış Yap';

  @override
  String get logoutConfirmTitle => 'Çıkış Yapılsın mı?';

  @override
  String get logoutConfirmMessage =>
      'Mevcut oturumunuz sonlandırılacaktır. Devam etmek istiyor musunuz?';

  @override
  String get dialogConfirm => 'Onayla';

  @override
  String get dialogCancel => 'Vazgeç';

  @override
  String get dialogClose => 'Kapat';

  @override
  String get dialogDelete => 'Sil';

  @override
  String get valRequired => 'Bu alan zorunludur.';

  @override
  String get valEmail => 'Geçerli bir e-posta adresi giriniz.';

  @override
  String get valPasswordLength => 'Şifre en az 8 karakter olmalıdır.';

  @override
  String get valPasswordRule =>
      'Şifre en az bir harf ve bir rakam içermelidir.';

  @override
  String get valPasswordMatch => 'Şifreler birbiriyle eşleşmiyor.';

  @override
  String get valPhone =>
      'Geçerli bir Türkiye telefon numarası giriniz (05XX XXX XX XX).';

  @override
  String get valAge => 'Kiralama yapabilmek için en az 18 yaşında olmalısınız.';

  @override
  String get valLettersOnly => 'Bu alana sadece harf girilebilir.';

  @override
  String valMinLength(int min) {
    return 'En az $min karakter girmelisiniz.';
  }

  @override
  String get valTurkishPlate =>
      'Geçerli bir Türk plakası giriniz (Örn. 34 ABC 123).';

  @override
  String get valPositivePrice =>
      'Lütfen 0\'dan büyük geçerli bir fiyat giriniz.';

  @override
  String get valReturnAfterPickup =>
      'Teslim etme zamanı, teslim alma zamanından sonra olmalıdır.';

  @override
  String get valTermsRequired =>
      'Lütfen devam etmek için şartları onaylayınız.';

  @override
  String get valSignaturesRequired =>
      'Lütfen hem kiracı hem araç sahibi imzasını tamamlayınız.';

  @override
  String get typeCar => 'Otomobil';

  @override
  String get typeSuv => 'SUV';

  @override
  String get typeVan => 'Minibüs';

  @override
  String get typeMotorcycle => 'Motosiklet';

  @override
  String get typeScooter => 'Scooter';

  @override
  String get typeCommercial => 'Ticari';

  @override
  String get transManual => 'Manuel';

  @override
  String get transAutomatic => 'Otomatik';

  @override
  String get fuelGasoline => 'Benzin';

  @override
  String get fuelDiesel => 'Dizel';

  @override
  String get fuelElectric => 'Elektrik';

  @override
  String get fuelHybrid => 'Hibrit';

  @override
  String get accClean => 'Kazasız / Tramersiz';

  @override
  String get accMinor => 'Hafif Hasar Kaydı';

  @override
  String get accMajor => 'Ağır Hasar Kaydı';

  @override
  String get tagCleanReturn => 'Temiz Teslim';

  @override
  String get tagDirtyReturn => 'Kirli Teslim';

  @override
  String get tagFuelFull => 'Yakıt Dolu';

  @override
  String get tagFuelEmpty => 'Yakıt Boş';

  @override
  String get tagOnTime => 'Zamanında Teslim';

  @override
  String get tagLateReturn => 'Geç Teslim';

  @override
  String get tagUndamaged => 'Hasarsız';

  @override
  String get tagDamaged => 'Hasar Var';

  @override
  String get tagRulesFollowed => 'Kurallara Uydu';

  @override
  String get statusPending => 'Bekliyor';

  @override
  String get statusConfirmed => 'Onaylandı';

  @override
  String get statusActive => 'Devam Ediyor';

  @override
  String get statusCompleted => 'Tamamlandı';

  @override
  String get statusCancelled => 'İptal Edildi';
}
