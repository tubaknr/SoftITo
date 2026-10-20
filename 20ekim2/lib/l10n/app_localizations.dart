import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  /// No description provided for @appName.
  ///
  /// In tr, this message translates to:
  /// **'KiralaGo'**
  String get appName;

  /// No description provided for @appSlogan.
  ///
  /// In tr, this message translates to:
  /// **'Güvenle Kirala, Keyifle Sür'**
  String get appSlogan;

  /// No description provided for @welcomeTitle.
  ///
  /// In tr, this message translates to:
  /// **'KiralaGo\'ya Hoş Geldiniz'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'İster aracını kirala gelir elde et, ister dilediğin aracı güvenle sür.'**
  String get welcomeSubtitle;

  /// No description provided for @roleRenterButton.
  ///
  /// In tr, this message translates to:
  /// **'Araç kiralamak istiyorum'**
  String get roleRenterButton;

  /// No description provided for @roleRenterDescription.
  ///
  /// In tr, this message translates to:
  /// **'Geniş araç filosundan sana en uygununu hemen kirala'**
  String get roleRenterDescription;

  /// No description provided for @roleOwnerButton.
  ///
  /// In tr, this message translates to:
  /// **'Araç kiralamaya vermek istiyorum'**
  String get roleOwnerButton;

  /// No description provided for @roleOwnerDescription.
  ///
  /// In tr, this message translates to:
  /// **'Aracını güvenilir kullanıcılara kirala, kazanç sağla'**
  String get roleOwnerDescription;

  /// No description provided for @renterLoginTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kiracı Girişi'**
  String get renterLoginTitle;

  /// No description provided for @ownerLoginTitle.
  ///
  /// In tr, this message translates to:
  /// **'Araç Sahibi Girişi'**
  String get ownerLoginTitle;

  /// No description provided for @emailLabel.
  ///
  /// In tr, this message translates to:
  /// **'E-posta Adresi'**
  String get emailLabel;

  /// No description provided for @emailHint.
  ///
  /// In tr, this message translates to:
  /// **'ornek@email.com'**
  String get emailHint;

  /// No description provided for @passwordLabel.
  ///
  /// In tr, this message translates to:
  /// **'Şifre'**
  String get passwordLabel;

  /// No description provided for @passwordHint.
  ///
  /// In tr, this message translates to:
  /// **'En az 8 karakter'**
  String get passwordHint;

  /// No description provided for @rememberMe.
  ///
  /// In tr, this message translates to:
  /// **'Beni Hatırla'**
  String get rememberMe;

  /// No description provided for @loginButton.
  ///
  /// In tr, this message translates to:
  /// **'Giriş Yap'**
  String get loginButton;

  /// No description provided for @noAccount.
  ///
  /// In tr, this message translates to:
  /// **'Hesabınız yok mu?'**
  String get noAccount;

  /// No description provided for @registerHere.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt Olun'**
  String get registerHere;

  /// No description provided for @hasAccount.
  ///
  /// In tr, this message translates to:
  /// **'Zaten hesabınız var mı?'**
  String get hasAccount;

  /// No description provided for @loginHere.
  ///
  /// In tr, this message translates to:
  /// **'Giriş Yapın'**
  String get loginHere;

  /// No description provided for @registerTitleRenter.
  ///
  /// In tr, this message translates to:
  /// **'Kiracı Kaydı'**
  String get registerTitleRenter;

  /// No description provided for @registerTitleOwner.
  ///
  /// In tr, this message translates to:
  /// **'Araç Sahibi Kaydı'**
  String get registerTitleOwner;

  /// No description provided for @firstNameLabel.
  ///
  /// In tr, this message translates to:
  /// **'Ad'**
  String get firstNameLabel;

  /// No description provided for @lastNameLabel.
  ///
  /// In tr, this message translates to:
  /// **'Soyad'**
  String get lastNameLabel;

  /// No description provided for @phoneLabel.
  ///
  /// In tr, this message translates to:
  /// **'Telefon Numarası'**
  String get phoneLabel;

  /// No description provided for @phoneHint.
  ///
  /// In tr, this message translates to:
  /// **'05XX XXX XX XX'**
  String get phoneHint;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In tr, this message translates to:
  /// **'Şifre Tekrar'**
  String get confirmPasswordLabel;

  /// No description provided for @ageLabel.
  ///
  /// In tr, this message translates to:
  /// **'Yaş'**
  String get ageLabel;

  /// No description provided for @occupationLabel.
  ///
  /// In tr, this message translates to:
  /// **'Meslek'**
  String get occupationLabel;

  /// No description provided for @cityLabel.
  ///
  /// In tr, this message translates to:
  /// **'Şehir'**
  String get cityLabel;

  /// No description provided for @districtLabel.
  ///
  /// In tr, this message translates to:
  /// **'İlçe'**
  String get districtLabel;

  /// No description provided for @termsAgreement.
  ///
  /// In tr, this message translates to:
  /// **'Kullanım şartlarını ve gizlilik politikasını okudum, kabul ediyorum.'**
  String get termsAgreement;

  /// No description provided for @registerButton.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt Ol'**
  String get registerButton;

  /// No description provided for @navVehicles.
  ///
  /// In tr, this message translates to:
  /// **'Araçlar'**
  String get navVehicles;

  /// No description provided for @navMyVehicles.
  ///
  /// In tr, this message translates to:
  /// **'Araçlarım'**
  String get navMyVehicles;

  /// No description provided for @navReservations.
  ///
  /// In tr, this message translates to:
  /// **'Rezervasyon'**
  String get navReservations;

  /// No description provided for @navProfile.
  ///
  /// In tr, this message translates to:
  /// **'Profil'**
  String get navProfile;

  /// No description provided for @searchVehicleHint.
  ///
  /// In tr, this message translates to:
  /// **'Marka, model veya şehir ara...'**
  String get searchVehicleHint;

  /// No description provided for @filterButton.
  ///
  /// In tr, this message translates to:
  /// **'Filtrele'**
  String get filterButton;

  /// No description provided for @filterTitle.
  ///
  /// In tr, this message translates to:
  /// **'Filtreler'**
  String get filterTitle;

  /// No description provided for @clearFilters.
  ///
  /// In tr, this message translates to:
  /// **'Temizle'**
  String get clearFilters;

  /// No description provided for @applyFilters.
  ///
  /// In tr, this message translates to:
  /// **'Uygula'**
  String get applyFilters;

  /// No description provided for @sortByTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sıralama'**
  String get sortByTitle;

  /// No description provided for @sortHighestRating.
  ///
  /// In tr, this message translates to:
  /// **'En Yüksek Puan'**
  String get sortHighestRating;

  /// No description provided for @sortPriceAsc.
  ///
  /// In tr, this message translates to:
  /// **'Fiyat (Önce En Düşük)'**
  String get sortPriceAsc;

  /// No description provided for @sortPriceDesc.
  ///
  /// In tr, this message translates to:
  /// **'Fiyat (Önce En Yüksek)'**
  String get sortPriceDesc;

  /// No description provided for @sortYearDesc.
  ///
  /// In tr, this message translates to:
  /// **'Yıl (En Yeni)'**
  String get sortYearDesc;

  /// No description provided for @sortYearAsc.
  ///
  /// In tr, this message translates to:
  /// **'Yıl (En Eski)'**
  String get sortYearAsc;

  /// No description provided for @vehicleTypeTitle.
  ///
  /// In tr, this message translates to:
  /// **'Araç Tipi'**
  String get vehicleTypeTitle;

  /// No description provided for @yearRangeTitle.
  ///
  /// In tr, this message translates to:
  /// **'Model Yılı'**
  String get yearRangeTitle;

  /// No description provided for @brandTitle.
  ///
  /// In tr, this message translates to:
  /// **'Marka'**
  String get brandTitle;

  /// No description provided for @modelTitle.
  ///
  /// In tr, this message translates to:
  /// **'Model'**
  String get modelTitle;

  /// No description provided for @allBrands.
  ///
  /// In tr, this message translates to:
  /// **'Tüm Markalar'**
  String get allBrands;

  /// No description provided for @allModels.
  ///
  /// In tr, this message translates to:
  /// **'Tüm Modeller'**
  String get allModels;

  /// No description provided for @transmissionTitle.
  ///
  /// In tr, this message translates to:
  /// **'Vites Türü'**
  String get transmissionTitle;

  /// No description provided for @fuelTypeTitle.
  ///
  /// In tr, this message translates to:
  /// **'Yakıt Türü'**
  String get fuelTypeTitle;

  /// No description provided for @seatCountTitle.
  ///
  /// In tr, this message translates to:
  /// **'Minimum Koltuk Sayısı'**
  String get seatCountTitle;

  /// No description provided for @perDay.
  ///
  /// In tr, this message translates to:
  /// **'/ gün'**
  String get perDay;

  /// No description provided for @perHour.
  ///
  /// In tr, this message translates to:
  /// **'/ saat'**
  String get perHour;

  /// No description provided for @perWeek.
  ///
  /// In tr, this message translates to:
  /// **'/ hafta'**
  String get perWeek;

  /// No description provided for @perMonth.
  ///
  /// In tr, this message translates to:
  /// **'/ ay'**
  String get perMonth;

  /// No description provided for @hourlyPrice.
  ///
  /// In tr, this message translates to:
  /// **'Saatlik'**
  String get hourlyPrice;

  /// No description provided for @dailyPrice.
  ///
  /// In tr, this message translates to:
  /// **'Günlük'**
  String get dailyPrice;

  /// No description provided for @weeklyPrice.
  ///
  /// In tr, this message translates to:
  /// **'Haftalık'**
  String get weeklyPrice;

  /// No description provided for @monthlyPrice.
  ///
  /// In tr, this message translates to:
  /// **'Aylık'**
  String get monthlyPrice;

  /// No description provided for @emptyVehicleList.
  ///
  /// In tr, this message translates to:
  /// **'Filtrelere uygun araç bulunamadı.'**
  String get emptyVehicleList;

  /// No description provided for @emptyVehicleListAction.
  ///
  /// In tr, this message translates to:
  /// **'Filtreleri Temizle'**
  String get emptyVehicleListAction;

  /// No description provided for @vehicleDetailTitle.
  ///
  /// In tr, this message translates to:
  /// **'Araç Detayı'**
  String get vehicleDetailTitle;

  /// No description provided for @technicalSpecs.
  ///
  /// In tr, this message translates to:
  /// **'Teknik Özellikler'**
  String get technicalSpecs;

  /// No description provided for @mileageKm.
  ///
  /// In tr, this message translates to:
  /// **'{km} km'**
  String mileageKm(int km);

  /// No description provided for @plateLabel.
  ///
  /// In tr, this message translates to:
  /// **'Plaka'**
  String get plateLabel;

  /// No description provided for @chassisLabel.
  ///
  /// In tr, this message translates to:
  /// **'Şase / Araç No'**
  String get chassisLabel;

  /// No description provided for @accidentStatusLabel.
  ///
  /// In tr, this message translates to:
  /// **'Kaza Durumu'**
  String get accidentStatusLabel;

  /// No description provided for @viewExpertiseReport.
  ///
  /// In tr, this message translates to:
  /// **'Ekspertiz Raporunu Gör'**
  String get viewExpertiseReport;

  /// No description provided for @expertiseReportDialogTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ekspertiz ve Durum Raporu'**
  String get expertiseReportDialogTitle;

  /// No description provided for @pricingOptions.
  ///
  /// In tr, this message translates to:
  /// **'Fiyat Seçenekleri'**
  String get pricingOptions;

  /// No description provided for @availabilityCalendar.
  ///
  /// In tr, this message translates to:
  /// **'Müsaitlik Takvimi'**
  String get availabilityCalendar;

  /// No description provided for @calendarLegendBooked.
  ///
  /// In tr, this message translates to:
  /// **'Dolu'**
  String get calendarLegendBooked;

  /// No description provided for @calendarLegendAvailable.
  ///
  /// In tr, this message translates to:
  /// **'Müsait'**
  String get calendarLegendAvailable;

  /// No description provided for @calendarLegendSelected.
  ///
  /// In tr, this message translates to:
  /// **'Seçili'**
  String get calendarLegendSelected;

  /// No description provided for @aboutOwner.
  ///
  /// In tr, this message translates to:
  /// **'Araç Sahibi Hakkında'**
  String get aboutOwner;

  /// No description provided for @responseTime.
  ///
  /// In tr, this message translates to:
  /// **'Yanıt Süresi: {time}'**
  String responseTime(String time);

  /// No description provided for @reviewsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Yorumlar ve Değerlendirmeler'**
  String get reviewsTitle;

  /// No description provided for @reviewsCount.
  ///
  /// In tr, this message translates to:
  /// **'({count} yorum)'**
  String reviewsCount(int count);

  /// No description provided for @showMoreReviews.
  ///
  /// In tr, this message translates to:
  /// **'Daha fazla göster'**
  String get showMoreReviews;

  /// No description provided for @showLessReviews.
  ///
  /// In tr, this message translates to:
  /// **'Daha az göster'**
  String get showLessReviews;

  /// No description provided for @rentCtaButton.
  ///
  /// In tr, this message translates to:
  /// **'Hemen Kirala'**
  String get rentCtaButton;

  /// No description provided for @selectDatesWarning.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen önce takvimden kiralama tarih aralığını seçiniz.'**
  String get selectDatesWarning;

  /// No description provided for @bookedDateWarning.
  ///
  /// In tr, this message translates to:
  /// **'Seçilen tarih aralığında araç doludur, lütfen başka tarihler seçiniz.'**
  String get bookedDateWarning;

  /// No description provided for @loginRequiredWarning.
  ///
  /// In tr, this message translates to:
  /// **'Kiralama yapabilmek için lütfen giriş yapınız.'**
  String get loginRequiredWarning;

  /// No description provided for @rentalFormTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kiralama ve Teslim Sözleşmesi'**
  String get rentalFormTitle;

  /// No description provided for @vehicleInfoSection.
  ///
  /// In tr, this message translates to:
  /// **'1. Araç Bilgileri'**
  String get vehicleInfoSection;

  /// No description provided for @ownerInfoSection.
  ///
  /// In tr, this message translates to:
  /// **'2. Araç Sahibi Bilgileri'**
  String get ownerInfoSection;

  /// No description provided for @renterInfoSection.
  ///
  /// In tr, this message translates to:
  /// **'3. Kiracı Bilgileri'**
  String get renterInfoSection;

  /// No description provided for @pickupSection.
  ///
  /// In tr, this message translates to:
  /// **'4. Teslim Alma Bilgileri'**
  String get pickupSection;

  /// No description provided for @pickupLocationLabel.
  ///
  /// In tr, this message translates to:
  /// **'Teslim Alma Yeri'**
  String get pickupLocationLabel;

  /// No description provided for @pickupLocationHint.
  ///
  /// In tr, this message translates to:
  /// **'Örn. Kadıköy İskele Meydanı'**
  String get pickupLocationHint;

  /// No description provided for @pickupDateLabel.
  ///
  /// In tr, this message translates to:
  /// **'Teslim Alma Tarihi'**
  String get pickupDateLabel;

  /// No description provided for @pickupTimeLabel.
  ///
  /// In tr, this message translates to:
  /// **'Teslim Alma Saati'**
  String get pickupTimeLabel;

  /// No description provided for @returnSection.
  ///
  /// In tr, this message translates to:
  /// **'5. Teslim Etme Bilgileri'**
  String get returnSection;

  /// No description provided for @returnLocationLabel.
  ///
  /// In tr, this message translates to:
  /// **'Teslim Etme Yeri'**
  String get returnLocationLabel;

  /// No description provided for @returnLocationHint.
  ///
  /// In tr, this message translates to:
  /// **'Örn. Kadıköy İskele Meydanı'**
  String get returnLocationHint;

  /// No description provided for @returnDateLabel.
  ///
  /// In tr, this message translates to:
  /// **'Teslim Etme Tarihi'**
  String get returnDateLabel;

  /// No description provided for @returnTimeLabel.
  ///
  /// In tr, this message translates to:
  /// **'Teslim Etme Saati'**
  String get returnTimeLabel;

  /// No description provided for @pricingAndPaymentSection.
  ///
  /// In tr, this message translates to:
  /// **'6. Ücret ve Ödeme Özeti'**
  String get pricingAndPaymentSection;

  /// No description provided for @paymentMethodLabel.
  ///
  /// In tr, this message translates to:
  /// **'Ödeme Yöntemi'**
  String get paymentMethodLabel;

  /// No description provided for @paymentMethodCard.
  ///
  /// In tr, this message translates to:
  /// **'Kredi / Banka Kartı (Güvenli Provizyon)'**
  String get paymentMethodCard;

  /// No description provided for @paymentMethodCash.
  ///
  /// In tr, this message translates to:
  /// **'Teslimatta Elden / Havale'**
  String get paymentMethodCash;

  /// No description provided for @totalPriceLabel.
  ///
  /// In tr, this message translates to:
  /// **'Toplam Tutar:'**
  String get totalPriceLabel;

  /// No description provided for @photosSection.
  ///
  /// In tr, this message translates to:
  /// **'7. Kiralama Öncesi Dış Fotoğraflar'**
  String get photosSection;

  /// No description provided for @photosSectionDesc.
  ///
  /// In tr, this message translates to:
  /// **'Araç tesliminde 4 cepheden (Ön, Arka, Sağ, Sol) fotoğraf kontrolü:'**
  String get photosSectionDesc;

  /// No description provided for @photoFront.
  ///
  /// In tr, this message translates to:
  /// **'Ön Cephe'**
  String get photoFront;

  /// No description provided for @photoRear.
  ///
  /// In tr, this message translates to:
  /// **'Arka Cephe'**
  String get photoRear;

  /// No description provided for @photoRight.
  ///
  /// In tr, this message translates to:
  /// **'Sağ Yan'**
  String get photoRight;

  /// No description provided for @photoLeft.
  ///
  /// In tr, this message translates to:
  /// **'Sol Yan'**
  String get photoLeft;

  /// No description provided for @photoAdded.
  ///
  /// In tr, this message translates to:
  /// **'Görsel Hazır'**
  String get photoAdded;

  /// No description provided for @fuelSection.
  ///
  /// In tr, this message translates to:
  /// **'8. Kiralama Öncesi Yakıt Seviyesi'**
  String get fuelSection;

  /// No description provided for @fuelQuarter.
  ///
  /// In tr, this message translates to:
  /// **'%25 (Çeyrek)'**
  String get fuelQuarter;

  /// No description provided for @fuelHalf.
  ///
  /// In tr, this message translates to:
  /// **'%50 (Yarım)'**
  String get fuelHalf;

  /// No description provided for @fuelThreeQuarters.
  ///
  /// In tr, this message translates to:
  /// **'%75 (3/4)'**
  String get fuelThreeQuarters;

  /// No description provided for @fuelFull.
  ///
  /// In tr, this message translates to:
  /// **'%100 (Dolu)'**
  String get fuelFull;

  /// No description provided for @cameraSection.
  ///
  /// In tr, this message translates to:
  /// **'9. Araç İçi Güvenlik Kamerası'**
  String get cameraSection;

  /// No description provided for @cameraCheckboxLabel.
  ///
  /// In tr, this message translates to:
  /// **'Bu araçta güvenlik amaçlı iç kabin kamerası bulunduğunu okudum ve onaylıyorum.'**
  String get cameraCheckboxLabel;

  /// No description provided for @insuranceSection.
  ///
  /// In tr, this message translates to:
  /// **'10. Kasko & Sigorta Poliçesi'**
  String get insuranceSection;

  /// No description provided for @downloadPolicyButton.
  ///
  /// In tr, this message translates to:
  /// **'Poliçeyi İndir'**
  String get downloadPolicyButton;

  /// No description provided for @policyDownloadedMessage.
  ///
  /// In tr, this message translates to:
  /// **'Kasko ve Sigorta poliçesi başarıyla cihazınıza indirildi.'**
  String get policyDownloadedMessage;

  /// No description provided for @signaturesSection.
  ///
  /// In tr, this message translates to:
  /// **'11. Tarafların E-İmzası'**
  String get signaturesSection;

  /// No description provided for @renterSignatureLabel.
  ///
  /// In tr, this message translates to:
  /// **'Kiracı E-İmzası'**
  String get renterSignatureLabel;

  /// No description provided for @ownerSignatureLabel.
  ///
  /// In tr, this message translates to:
  /// **'Araç Sahibi E-İmzası'**
  String get ownerSignatureLabel;

  /// No description provided for @signaturePadHint.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen aşağıdaki kutuya parmağınızla imzanızı atınız'**
  String get signaturePadHint;

  /// No description provided for @clearSignature.
  ///
  /// In tr, this message translates to:
  /// **'Temizle'**
  String get clearSignature;

  /// No description provided for @saveSignature.
  ///
  /// In tr, this message translates to:
  /// **'İmzayı Kaydet'**
  String get saveSignature;

  /// No description provided for @signatureSaved.
  ///
  /// In tr, this message translates to:
  /// **'İmza kaydedildi'**
  String get signatureSaved;

  /// No description provided for @confirmRentalButton.
  ///
  /// In tr, this message translates to:
  /// **'Kiralamayı Onayla ve Tamamla'**
  String get confirmRentalButton;

  /// No description provided for @rentalSuccessDialogTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kiralama Başarılı!'**
  String get rentalSuccessDialogTitle;

  /// No description provided for @rentalSuccessDialogContent.
  ///
  /// In tr, this message translates to:
  /// **'Rezervasyonunuz başarıyla oluşturuldu. Rezervasyonlarım sayfasından takip edebilirsiniz.'**
  String get rentalSuccessDialogContent;

  /// No description provided for @reservationsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Rezervasyonlarım'**
  String get reservationsTitle;

  /// No description provided for @tabUpcoming.
  ///
  /// In tr, this message translates to:
  /// **'Yaklaşan & Aktif'**
  String get tabUpcoming;

  /// No description provided for @tabPast.
  ///
  /// In tr, this message translates to:
  /// **'Geçmiş'**
  String get tabPast;

  /// No description provided for @emptyReservations.
  ///
  /// In tr, this message translates to:
  /// **'Bu kategoride henüz bir rezervasyonunuz bulunmuyor.'**
  String get emptyReservations;

  /// No description provided for @reservationDetailTitle.
  ///
  /// In tr, this message translates to:
  /// **'Rezervasyon Bilgisi'**
  String get reservationDetailTitle;

  /// No description provided for @reservationStatusLabel.
  ///
  /// In tr, this message translates to:
  /// **'Rezervasyon Durumu'**
  String get reservationStatusLabel;

  /// No description provided for @paymentStatusLabel.
  ///
  /// In tr, this message translates to:
  /// **'Ödeme Durumu'**
  String get paymentStatusLabel;

  /// No description provided for @paymentStatusPending.
  ///
  /// In tr, this message translates to:
  /// **'Ödeme Bekliyor'**
  String get paymentStatusPending;

  /// No description provided for @paymentStatusPaid.
  ///
  /// In tr, this message translates to:
  /// **'Ödendi'**
  String get paymentStatusPaid;

  /// No description provided for @cancelReservationButton.
  ///
  /// In tr, this message translates to:
  /// **'Rezervasyonu İptal Et'**
  String get cancelReservationButton;

  /// No description provided for @simulateDelayButton.
  ///
  /// In tr, this message translates to:
  /// **'Gecikme Simülasyonu Yap'**
  String get simulateDelayButton;

  /// No description provided for @simulateDelayDialogTitle.
  ///
  /// In tr, this message translates to:
  /// **'Tahmini Varış & Gecikme Simülatörü'**
  String get simulateDelayDialogTitle;

  /// No description provided for @simulateDelayDialogContent.
  ///
  /// In tr, this message translates to:
  /// **'MockTrafficService anlık yoğunluğa göre hesapladı: Karşı tarafa yaklaşık 15 dakika gecikme bildirimi iletildi.'**
  String get simulateDelayDialogContent;

  /// No description provided for @myVehiclesTitle.
  ///
  /// In tr, this message translates to:
  /// **'Araçlarım'**
  String get myVehiclesTitle;

  /// No description provided for @addVehicleButton.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Araç Ekle'**
  String get addVehicleButton;

  /// No description provided for @editVehicleTitle.
  ///
  /// In tr, this message translates to:
  /// **'Aracı Düzenle'**
  String get editVehicleTitle;

  /// No description provided for @addNewVehicleTitle.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Araç Kaydı'**
  String get addNewVehicleTitle;

  /// No description provided for @deleteVehicleConfirmation.
  ///
  /// In tr, this message translates to:
  /// **'Bu aracı sistemden kaldırmak istediğinize emin misiniz?'**
  String get deleteVehicleConfirmation;

  /// No description provided for @vehicleStatusAvailable.
  ///
  /// In tr, this message translates to:
  /// **'Müsait'**
  String get vehicleStatusAvailable;

  /// No description provided for @vehicleStatusRented.
  ///
  /// In tr, this message translates to:
  /// **'Kirada'**
  String get vehicleStatusRented;

  /// No description provided for @vehicleTotalEarnings.
  ///
  /// In tr, this message translates to:
  /// **'Toplam Gelir:'**
  String get vehicleTotalEarnings;

  /// No description provided for @renterProfileTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kiracı Profili'**
  String get renterProfileTitle;

  /// No description provided for @ownerProfileTitle.
  ///
  /// In tr, this message translates to:
  /// **'Araç Sahibi Profili'**
  String get ownerProfileTitle;

  /// No description provided for @trustScoreLabel.
  ///
  /// In tr, this message translates to:
  /// **'Güven Puanı'**
  String get trustScoreLabel;

  /// No description provided for @ownerRatingLabel.
  ///
  /// In tr, this message translates to:
  /// **'Araç Sahibi Puanı'**
  String get ownerRatingLabel;

  /// No description provided for @totalRentCountLabel.
  ///
  /// In tr, this message translates to:
  /// **'Toplam Kiralama'**
  String get totalRentCountLabel;

  /// No description provided for @memberSinceLabel.
  ///
  /// In tr, this message translates to:
  /// **'Üyelik Tarihi'**
  String get memberSinceLabel;

  /// No description provided for @vehiclesOfOwner.
  ///
  /// In tr, this message translates to:
  /// **'Araç Sahibinin Diğer Araçları'**
  String get vehiclesOfOwner;

  /// No description provided for @aboutMe.
  ///
  /// In tr, this message translates to:
  /// **'Hakkında'**
  String get aboutMe;

  /// No description provided for @editProfile.
  ///
  /// In tr, this message translates to:
  /// **'Profili Düzenle'**
  String get editProfile;

  /// No description provided for @saveProfile.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get saveProfile;

  /// No description provided for @settingsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar'**
  String get settingsTitle;

  /// No description provided for @themeTitle.
  ///
  /// In tr, this message translates to:
  /// **'Tema'**
  String get themeTitle;

  /// No description provided for @themeSystem.
  ///
  /// In tr, this message translates to:
  /// **'Sistem'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In tr, this message translates to:
  /// **'Aydınlık'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In tr, this message translates to:
  /// **'Karanlık'**
  String get themeDark;

  /// No description provided for @languageTitle.
  ///
  /// In tr, this message translates to:
  /// **'Uygulama Dili'**
  String get languageTitle;

  /// No description provided for @languageTr.
  ///
  /// In tr, this message translates to:
  /// **'Türkçe'**
  String get languageTr;

  /// No description provided for @languageEn.
  ///
  /// In tr, this message translates to:
  /// **'English'**
  String get languageEn;

  /// No description provided for @logoutButton.
  ///
  /// In tr, this message translates to:
  /// **'Çıkış Yap'**
  String get logoutButton;

  /// No description provided for @logoutConfirmTitle.
  ///
  /// In tr, this message translates to:
  /// **'Çıkış Yapılsın mı?'**
  String get logoutConfirmTitle;

  /// No description provided for @logoutConfirmMessage.
  ///
  /// In tr, this message translates to:
  /// **'Mevcut oturumunuz sonlandırılacaktır. Devam etmek istiyor musunuz?'**
  String get logoutConfirmMessage;

  /// No description provided for @dialogConfirm.
  ///
  /// In tr, this message translates to:
  /// **'Onayla'**
  String get dialogConfirm;

  /// No description provided for @dialogCancel.
  ///
  /// In tr, this message translates to:
  /// **'Vazgeç'**
  String get dialogCancel;

  /// No description provided for @dialogClose.
  ///
  /// In tr, this message translates to:
  /// **'Kapat'**
  String get dialogClose;

  /// No description provided for @dialogDelete.
  ///
  /// In tr, this message translates to:
  /// **'Sil'**
  String get dialogDelete;

  /// No description provided for @valRequired.
  ///
  /// In tr, this message translates to:
  /// **'Bu alan zorunludur.'**
  String get valRequired;

  /// No description provided for @valEmail.
  ///
  /// In tr, this message translates to:
  /// **'Geçerli bir e-posta adresi giriniz.'**
  String get valEmail;

  /// No description provided for @valPasswordLength.
  ///
  /// In tr, this message translates to:
  /// **'Şifre en az 8 karakter olmalıdır.'**
  String get valPasswordLength;

  /// No description provided for @valPasswordRule.
  ///
  /// In tr, this message translates to:
  /// **'Şifre en az bir harf ve bir rakam içermelidir.'**
  String get valPasswordRule;

  /// No description provided for @valPasswordMatch.
  ///
  /// In tr, this message translates to:
  /// **'Şifreler birbiriyle eşleşmiyor.'**
  String get valPasswordMatch;

  /// No description provided for @valPhone.
  ///
  /// In tr, this message translates to:
  /// **'Geçerli bir Türkiye telefon numarası giriniz (05XX XXX XX XX).'**
  String get valPhone;

  /// No description provided for @valAge.
  ///
  /// In tr, this message translates to:
  /// **'Kiralama yapabilmek için en az 18 yaşında olmalısınız.'**
  String get valAge;

  /// No description provided for @valLettersOnly.
  ///
  /// In tr, this message translates to:
  /// **'Bu alana sadece harf girilebilir.'**
  String get valLettersOnly;

  /// No description provided for @valMinLength.
  ///
  /// In tr, this message translates to:
  /// **'En az {min} karakter girmelisiniz.'**
  String valMinLength(int min);

  /// No description provided for @valTurkishPlate.
  ///
  /// In tr, this message translates to:
  /// **'Geçerli bir Türk plakası giriniz (Örn. 34 ABC 123).'**
  String get valTurkishPlate;

  /// No description provided for @valPositivePrice.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen 0\'dan büyük geçerli bir fiyat giriniz.'**
  String get valPositivePrice;

  /// No description provided for @valReturnAfterPickup.
  ///
  /// In tr, this message translates to:
  /// **'Teslim etme zamanı, teslim alma zamanından sonra olmalıdır.'**
  String get valReturnAfterPickup;

  /// No description provided for @valTermsRequired.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen devam etmek için şartları onaylayınız.'**
  String get valTermsRequired;

  /// No description provided for @valSignaturesRequired.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen hem kiracı hem araç sahibi imzasını tamamlayınız.'**
  String get valSignaturesRequired;

  /// No description provided for @typeCar.
  ///
  /// In tr, this message translates to:
  /// **'Otomobil'**
  String get typeCar;

  /// No description provided for @typeSuv.
  ///
  /// In tr, this message translates to:
  /// **'SUV'**
  String get typeSuv;

  /// No description provided for @typeVan.
  ///
  /// In tr, this message translates to:
  /// **'Minibüs'**
  String get typeVan;

  /// No description provided for @typeMotorcycle.
  ///
  /// In tr, this message translates to:
  /// **'Motosiklet'**
  String get typeMotorcycle;

  /// No description provided for @typeScooter.
  ///
  /// In tr, this message translates to:
  /// **'Scooter'**
  String get typeScooter;

  /// No description provided for @typeCommercial.
  ///
  /// In tr, this message translates to:
  /// **'Ticari'**
  String get typeCommercial;

  /// No description provided for @transManual.
  ///
  /// In tr, this message translates to:
  /// **'Manuel'**
  String get transManual;

  /// No description provided for @transAutomatic.
  ///
  /// In tr, this message translates to:
  /// **'Otomatik'**
  String get transAutomatic;

  /// No description provided for @fuelGasoline.
  ///
  /// In tr, this message translates to:
  /// **'Benzin'**
  String get fuelGasoline;

  /// No description provided for @fuelDiesel.
  ///
  /// In tr, this message translates to:
  /// **'Dizel'**
  String get fuelDiesel;

  /// No description provided for @fuelElectric.
  ///
  /// In tr, this message translates to:
  /// **'Elektrik'**
  String get fuelElectric;

  /// No description provided for @fuelHybrid.
  ///
  /// In tr, this message translates to:
  /// **'Hibrit'**
  String get fuelHybrid;

  /// No description provided for @accClean.
  ///
  /// In tr, this message translates to:
  /// **'Kazasız / Tramersiz'**
  String get accClean;

  /// No description provided for @accMinor.
  ///
  /// In tr, this message translates to:
  /// **'Hafif Hasar Kaydı'**
  String get accMinor;

  /// No description provided for @accMajor.
  ///
  /// In tr, this message translates to:
  /// **'Ağır Hasar Kaydı'**
  String get accMajor;

  /// No description provided for @tagCleanReturn.
  ///
  /// In tr, this message translates to:
  /// **'Temiz Teslim'**
  String get tagCleanReturn;

  /// No description provided for @tagDirtyReturn.
  ///
  /// In tr, this message translates to:
  /// **'Kirli Teslim'**
  String get tagDirtyReturn;

  /// No description provided for @tagFuelFull.
  ///
  /// In tr, this message translates to:
  /// **'Yakıt Dolu'**
  String get tagFuelFull;

  /// No description provided for @tagFuelEmpty.
  ///
  /// In tr, this message translates to:
  /// **'Yakıt Boş'**
  String get tagFuelEmpty;

  /// No description provided for @tagOnTime.
  ///
  /// In tr, this message translates to:
  /// **'Zamanında Teslim'**
  String get tagOnTime;

  /// No description provided for @tagLateReturn.
  ///
  /// In tr, this message translates to:
  /// **'Geç Teslim'**
  String get tagLateReturn;

  /// No description provided for @tagUndamaged.
  ///
  /// In tr, this message translates to:
  /// **'Hasarsız'**
  String get tagUndamaged;

  /// No description provided for @tagDamaged.
  ///
  /// In tr, this message translates to:
  /// **'Hasar Var'**
  String get tagDamaged;

  /// No description provided for @tagRulesFollowed.
  ///
  /// In tr, this message translates to:
  /// **'Kurallara Uydu'**
  String get tagRulesFollowed;

  /// No description provided for @statusPending.
  ///
  /// In tr, this message translates to:
  /// **'Bekliyor'**
  String get statusPending;

  /// No description provided for @statusConfirmed.
  ///
  /// In tr, this message translates to:
  /// **'Onaylandı'**
  String get statusConfirmed;

  /// No description provided for @statusActive.
  ///
  /// In tr, this message translates to:
  /// **'Devam Ediyor'**
  String get statusActive;

  /// No description provided for @statusCompleted.
  ///
  /// In tr, this message translates to:
  /// **'Tamamlandı'**
  String get statusCompleted;

  /// No description provided for @statusCancelled.
  ///
  /// In tr, this message translates to:
  /// **'İptal Edildi'**
  String get statusCancelled;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
