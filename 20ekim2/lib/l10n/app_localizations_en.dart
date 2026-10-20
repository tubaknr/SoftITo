// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'KiralaGo';

  @override
  String get appSlogan => 'Rent Safely, Drive Freely';

  @override
  String get welcomeTitle => 'Welcome to KiralaGo';

  @override
  String get welcomeSubtitle =>
      'Rent out your vehicle to earn income, or drive any vehicle with confidence.';

  @override
  String get roleRenterButton => 'I want to rent a vehicle';

  @override
  String get roleRenterDescription =>
      'Choose and rent the ideal vehicle from our wide fleet';

  @override
  String get roleOwnerButton => 'I want to list my vehicle';

  @override
  String get roleOwnerDescription =>
      'Rent your vehicle to trusted drivers and start earning';

  @override
  String get renterLoginTitle => 'Renter Login';

  @override
  String get ownerLoginTitle => 'Vehicle Owner Login';

  @override
  String get emailLabel => 'Email Address';

  @override
  String get emailHint => 'example@email.com';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordHint => 'At least 8 characters';

  @override
  String get rememberMe => 'Remember Me';

  @override
  String get loginButton => 'Sign In';

  @override
  String get noAccount => 'Don\'t have an account?';

  @override
  String get registerHere => 'Sign Up';

  @override
  String get hasAccount => 'Already have an account?';

  @override
  String get loginHere => 'Sign In';

  @override
  String get registerTitleRenter => 'Renter Registration';

  @override
  String get registerTitleOwner => 'Owner Registration';

  @override
  String get firstNameLabel => 'First Name';

  @override
  String get lastNameLabel => 'Last Name';

  @override
  String get phoneLabel => 'Phone Number';

  @override
  String get phoneHint => '05XX XXX XX XX';

  @override
  String get confirmPasswordLabel => 'Confirm Password';

  @override
  String get ageLabel => 'Age';

  @override
  String get occupationLabel => 'Occupation';

  @override
  String get cityLabel => 'City';

  @override
  String get districtLabel => 'District';

  @override
  String get termsAgreement =>
      'I have read and agree to the terms of service and privacy policy.';

  @override
  String get registerButton => 'Register';

  @override
  String get navVehicles => 'Vehicles';

  @override
  String get navMyVehicles => 'My Vehicles';

  @override
  String get navReservations => 'Reservations';

  @override
  String get navProfile => 'Profile';

  @override
  String get searchVehicleHint => 'Search brand, model or city...';

  @override
  String get filterButton => 'Filter';

  @override
  String get filterTitle => 'Filters';

  @override
  String get clearFilters => 'Clear';

  @override
  String get applyFilters => 'Apply';

  @override
  String get sortByTitle => 'Sort By';

  @override
  String get sortHighestRating => 'Highest Rating';

  @override
  String get sortPriceAsc => 'Price (Lowest First)';

  @override
  String get sortPriceDesc => 'Price (Highest First)';

  @override
  String get sortYearDesc => 'Year (Newest)';

  @override
  String get sortYearAsc => 'Year (Oldest)';

  @override
  String get vehicleTypeTitle => 'Vehicle Type';

  @override
  String get yearRangeTitle => 'Model Year';

  @override
  String get brandTitle => 'Brand';

  @override
  String get modelTitle => 'Model';

  @override
  String get allBrands => 'All Brands';

  @override
  String get allModels => 'All Models';

  @override
  String get transmissionTitle => 'Transmission';

  @override
  String get fuelTypeTitle => 'Fuel Type';

  @override
  String get seatCountTitle => 'Minimum Seats';

  @override
  String get perDay => '/ day';

  @override
  String get perHour => '/ hour';

  @override
  String get perWeek => '/ week';

  @override
  String get perMonth => '/ month';

  @override
  String get hourlyPrice => 'Hourly';

  @override
  String get dailyPrice => 'Daily';

  @override
  String get weeklyPrice => 'Weekly';

  @override
  String get monthlyPrice => 'Monthly';

  @override
  String get emptyVehicleList => 'No vehicles found matching your filters.';

  @override
  String get emptyVehicleListAction => 'Clear Filters';

  @override
  String get vehicleDetailTitle => 'Vehicle Details';

  @override
  String get technicalSpecs => 'Technical Specifications';

  @override
  String mileageKm(int km) {
    return '$km km';
  }

  @override
  String get plateLabel => 'License Plate';

  @override
  String get chassisLabel => 'Chassis / Vehicle ID';

  @override
  String get accidentStatusLabel => 'Accident History';

  @override
  String get viewExpertiseReport => 'View Inspection Report';

  @override
  String get expertiseReportDialogTitle => 'Vehicle Inspection & Status Report';

  @override
  String get pricingOptions => 'Pricing Options';

  @override
  String get availabilityCalendar => 'Availability Calendar';

  @override
  String get calendarLegendBooked => 'Booked';

  @override
  String get calendarLegendAvailable => 'Available';

  @override
  String get calendarLegendSelected => 'Selected';

  @override
  String get aboutOwner => 'About the Vehicle Owner';

  @override
  String responseTime(String time) {
    return 'Response Time: $time';
  }

  @override
  String get reviewsTitle => 'Reviews & Ratings';

  @override
  String reviewsCount(int count) {
    return '($count reviews)';
  }

  @override
  String get showMoreReviews => 'Show more reviews';

  @override
  String get showLessReviews => 'Show less reviews';

  @override
  String get rentCtaButton => 'Rent Now';

  @override
  String get selectDatesWarning =>
      'Please select a date range on the calendar first.';

  @override
  String get bookedDateWarning =>
      'The vehicle is booked on selected dates, please choose other dates.';

  @override
  String get loginRequiredWarning => 'Please sign in to proceed with booking.';

  @override
  String get rentalFormTitle => 'Rental & Delivery Agreement';

  @override
  String get vehicleInfoSection => '1. Vehicle Details';

  @override
  String get ownerInfoSection => '2. Owner Details';

  @override
  String get renterInfoSection => '3. Renter Details';

  @override
  String get pickupSection => '4. Pick-up Information';

  @override
  String get pickupLocationLabel => 'Pick-up Location';

  @override
  String get pickupLocationHint => 'E.g., Central Station Square';

  @override
  String get pickupDateLabel => 'Pick-up Date';

  @override
  String get pickupTimeLabel => 'Pick-up Time';

  @override
  String get returnSection => '5. Drop-off Information';

  @override
  String get returnLocationLabel => 'Drop-off Location';

  @override
  String get returnLocationHint => 'E.g., Central Station Square';

  @override
  String get returnDateLabel => 'Drop-off Date';

  @override
  String get returnTimeLabel => 'Drop-off Time';

  @override
  String get pricingAndPaymentSection => '6. Price & Payment Summary';

  @override
  String get paymentMethodLabel => 'Payment Method';

  @override
  String get paymentMethodCard => 'Credit / Debit Card (Pre-authorization)';

  @override
  String get paymentMethodCash => 'Cash on Delivery / Wire Transfer';

  @override
  String get totalPriceLabel => 'Total Amount:';

  @override
  String get photosSection => '7. Pre-rental Exterior Photos';

  @override
  String get photosSectionDesc =>
      'Vehicle 4-angle exterior photo inspection (Front, Rear, Right, Left):';

  @override
  String get photoFront => 'Front Side';

  @override
  String get photoRear => 'Rear Side';

  @override
  String get photoRight => 'Right Side';

  @override
  String get photoLeft => 'Left Side';

  @override
  String get photoAdded => 'Image Ready';

  @override
  String get fuelSection => '8. Pre-rental Fuel Level';

  @override
  String get fuelQuarter => '25% (Quarter)';

  @override
  String get fuelHalf => '50% (Half)';

  @override
  String get fuelThreeQuarters => '75% (3/4)';

  @override
  String get fuelFull => '100% (Full)';

  @override
  String get cameraSection => '9. Interior Security Camera';

  @override
  String get cameraCheckboxLabel =>
      'I acknowledge and agree that this vehicle has an interior security camera for safety purposes.';

  @override
  String get insuranceSection => '10. Comprehensive Insurance Policy';

  @override
  String get downloadPolicyButton => 'Download Policy';

  @override
  String get policyDownloadedMessage =>
      'Insurance policy has been downloaded successfully.';

  @override
  String get signaturesSection => '11. Electronic Signatures';

  @override
  String get renterSignatureLabel => 'Renter E-Signature';

  @override
  String get ownerSignatureLabel => 'Vehicle Owner E-Signature';

  @override
  String get signaturePadHint => 'Please sign inside the box with your finger';

  @override
  String get clearSignature => 'Clear';

  @override
  String get saveSignature => 'Save Signature';

  @override
  String get signatureSaved => 'Signature saved';

  @override
  String get confirmRentalButton => 'Confirm & Complete Booking';

  @override
  String get rentalSuccessDialogTitle => 'Booking Confirmed!';

  @override
  String get rentalSuccessDialogContent =>
      'Your reservation has been created successfully. You can track it in Reservations.';

  @override
  String get reservationsTitle => 'My Reservations';

  @override
  String get tabUpcoming => 'Upcoming & Active';

  @override
  String get tabPast => 'Past';

  @override
  String get emptyReservations =>
      'You do not have any reservations in this category.';

  @override
  String get reservationDetailTitle => 'Reservation Details';

  @override
  String get reservationStatusLabel => 'Reservation Status';

  @override
  String get paymentStatusLabel => 'Payment Status';

  @override
  String get paymentStatusPending => 'Payment Pending';

  @override
  String get paymentStatusPaid => 'Paid';

  @override
  String get cancelReservationButton => 'Cancel Reservation';

  @override
  String get simulateDelayButton => 'Simulate Delay';

  @override
  String get simulateDelayDialogTitle => 'Estimated Arrival & Delay Simulator';

  @override
  String get simulateDelayDialogContent =>
      'MockTrafficService calculated real-time delay: A notification of ~15 minutes delay has been sent to the other party.';

  @override
  String get myVehiclesTitle => 'My Vehicles';

  @override
  String get addVehicleButton => 'Add Vehicle';

  @override
  String get editVehicleTitle => 'Edit Vehicle';

  @override
  String get addNewVehicleTitle => 'Add New Vehicle';

  @override
  String get deleteVehicleConfirmation =>
      'Are you sure you want to remove this vehicle?';

  @override
  String get vehicleStatusAvailable => 'Available';

  @override
  String get vehicleStatusRented => 'Rented';

  @override
  String get vehicleTotalEarnings => 'Total Earnings:';

  @override
  String get renterProfileTitle => 'Renter Profile';

  @override
  String get ownerProfileTitle => 'Owner Profile';

  @override
  String get trustScoreLabel => 'Trust Score';

  @override
  String get ownerRatingLabel => 'Owner Rating';

  @override
  String get totalRentCountLabel => 'Total Rentals';

  @override
  String get memberSinceLabel => 'Member Since';

  @override
  String get vehiclesOfOwner => 'Other Vehicles of Owner';

  @override
  String get aboutMe => 'About';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get saveProfile => 'Save';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get themeTitle => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get languageTitle => 'App Language';

  @override
  String get languageTr => 'Türkçe';

  @override
  String get languageEn => 'English';

  @override
  String get logoutButton => 'Log Out';

  @override
  String get logoutConfirmTitle => 'Log Out?';

  @override
  String get logoutConfirmMessage =>
      'Your current session will be terminated. Do you want to proceed?';

  @override
  String get dialogConfirm => 'Confirm';

  @override
  String get dialogCancel => 'Cancel';

  @override
  String get dialogClose => 'Close';

  @override
  String get dialogDelete => 'Delete';

  @override
  String get valRequired => 'This field is required.';

  @override
  String get valEmail => 'Please enter a valid email address.';

  @override
  String get valPasswordLength => 'Password must be at least 8 characters.';

  @override
  String get valPasswordRule =>
      'Password must contain at least one letter and one number.';

  @override
  String get valPasswordMatch => 'Passwords do not match.';

  @override
  String get valPhone => 'Please enter a valid phone number (05XX XXX XX XX).';

  @override
  String get valAge => 'You must be at least 18 years old.';

  @override
  String get valLettersOnly => 'Only letters are allowed.';

  @override
  String valMinLength(int min) {
    return 'Must enter at least $min characters.';
  }

  @override
  String get valTurkishPlate =>
      'Please enter a valid license plate (E.g. 34 ABC 123).';

  @override
  String get valPositivePrice => 'Please enter a valid price greater than 0.';

  @override
  String get valReturnAfterPickup =>
      'Drop-off time must be after pick-up time.';

  @override
  String get valTermsRequired => 'Please accept terms to continue.';

  @override
  String get valSignaturesRequired =>
      'Both renter and owner signatures are required.';

  @override
  String get typeCar => 'Car';

  @override
  String get typeSuv => 'SUV';

  @override
  String get typeVan => 'Van';

  @override
  String get typeMotorcycle => 'Motorcycle';

  @override
  String get typeScooter => 'Scooter';

  @override
  String get typeCommercial => 'Commercial';

  @override
  String get transManual => 'Manual';

  @override
  String get transAutomatic => 'Automatic';

  @override
  String get fuelGasoline => 'Gasoline';

  @override
  String get fuelDiesel => 'Diesel';

  @override
  String get fuelElectric => 'Electric';

  @override
  String get fuelHybrid => 'Hybrid';

  @override
  String get accClean => 'Clean / No Accidents';

  @override
  String get accMinor => 'Minor Damage Record';

  @override
  String get accMajor => 'Major Damage Record';

  @override
  String get tagCleanReturn => 'Clean Return';

  @override
  String get tagDirtyReturn => 'Dirty Return';

  @override
  String get tagFuelFull => 'Full Tank';

  @override
  String get tagFuelEmpty => 'Empty Tank';

  @override
  String get tagOnTime => 'On-time Return';

  @override
  String get tagLateReturn => 'Late Return';

  @override
  String get tagUndamaged => 'Undamaged';

  @override
  String get tagDamaged => 'Damage Reported';

  @override
  String get tagRulesFollowed => 'Followed Rules';

  @override
  String get statusPending => 'Pending';

  @override
  String get statusConfirmed => 'Confirmed';

  @override
  String get statusActive => 'Active';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusCancelled => 'Cancelled';
}
