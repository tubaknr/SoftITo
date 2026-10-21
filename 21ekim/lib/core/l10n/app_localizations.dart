import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Focus & Grow yerelleştirme sınıfı (Türkçe ve İngilizce).
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('tr'));
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  bool get isTr => locale.languageCode == 'tr';

  // Ortak ve Kimlik
  String get appName => 'Focus & Grow';
  String get appShortName => 'F&G';
  String get motto => isTr
      ? 'Odaklanarak yaşamı daha derinden hissetmek ister misin?'
      : 'Would you like to feel life more deeply through focus?';

  // Navigasyon Sekmeleri
  String get navHome => isTr ? 'Anasayfa' : 'Home';
  String get navStats => isTr ? 'İstatistikler' : 'Statistics';
  String get navCommunity => isTr ? 'Topluluk' : 'Community';
  String get navProfile => isTr ? 'Profil & Ayarlar' : 'Profile';

  // Giriş / Karşılama (Landing)
  String get registerCta => isTr ? 'Register' : 'Register';
  String get alreadyHaveAccount =>
      isTr ? 'Kayıtlı hesabın varsa Giriş Yap' : 'Already have an account? Sign In';
  String get signInWithGoogle =>
      isTr ? 'Google ile Giriş Yap' : 'Sign in with Google';

  // Kayıt Ol
  String get registerTitle =>
      isTr ? 'Sana nasıl hitap edelim?' : 'How should we address you?';
  String get nameLabel => isTr ? 'Adın veya sana nasıl hitap edelim?' : 'Name or nickname';
  String get emailLabel => isTr ? 'E-posta' : 'Email';
  String get passwordLabel => isTr ? 'Şifre' : 'Password';
  String get confirmPasswordLabel =>
      isTr ? 'Şifre doğrulama' : 'Confirm password';
  String get ageLabel => isTr ? 'Yaş' : 'Age';
  String get countryLabel => isTr ? 'Ülke' : 'Country';
  String get selectCountry => isTr ? 'Ülke seçiniz' : 'Select country';
  String get signUpButton => isTr ? 'Kaydol' : 'Sign Up';

  // Doğrulama Hataları
  String get errorPasswordRules => isTr
      ? 'En az 8 karakter, 1 büyük, 1 küçük harf ve sembol içermelidir.'
      : 'Must be at least 8 characters, include 1 uppercase, 1 lowercase, and 1 symbol.';
  String get errorPasswordMismatch =>
      isTr ? 'Şifreler eşleşmiyor.' : 'Passwords do not match.';
  String get errorRequiredField =>
      isTr ? 'Bu alan boş bırakılamaz.' : 'This field cannot be empty.';
  String get errorInvalidEmail =>
      isTr ? 'Geçerli bir email adresi giriniz.' : 'Please enter a valid email.';
  String get errorInvalidAge =>
      isTr ? 'Lütfen geçerli bir yaş giriniz.' : 'Please enter a valid age.';

  // Karşılama Geçiş Sayfası
  String welcomeUser(String name) => isTr ? 'Merhaba $name' : 'Hello $name';
  String get welcomeTransitionText => isTr
      ? 'Odaklanarak hayatını daha derinden hissetmeye başlamak için '
      : 'To start feeling life more deeply through focus, ';
  String get proceedLink => isTr ? 'ilerle' : 'proceed';

  // Giriş Yap
  String get loginNatureGreeting =>
      isTr ? 'Doğanın tadını çıkarmaya' : 'To savor the calm of nature,';
  String get welcomeGreeting => isTr ? 'Hoşgeldin' : 'Welcome';
  String get forgotPasswordLink =>
      isTr ? 'Şifremi unuttum' : 'Forgot password';
  String get loginButton => isTr ? 'Giriş Yap' : 'Sign In';
  String get errorInvalidCredentials =>
      isTr ? 'E-posta veya şifre hatalı.' : 'Invalid email or password.';

  // Şifremi Unuttum
  String get forgotPasswordTitle => isTr
      ? 'Çiçeğini kurtarmamız için emailini girebilirsin.'
      : 'Enter your email so we can rescue your flower.';
  String get sendCodeButton => isTr ? 'Kod Gönder' : 'Send Code';
  String get codeSentMessage =>
      isTr ? 'Sıfırlama kodu gönderildi.' : 'Reset code sent.';

  // Ana Sayfa & Çiçek
  String get welcomeHeader => isTr ? 'Hoşgeldin,' : 'Welcome,';
  String get startFocus => isTr ? 'Odaklanmaya başla' : 'Start Focus';
  String get stopFocus => isTr ? 'Durdur' : 'Stop';
  String get totalFocusLabel => isTr ? 'Toplam Odaklanma' : 'Total Focus';

  // Çiçek Evreleri
  String get stageSeed => isTr ? 'Tohum Evresi' : 'Seed Stage';
  String get stageSprout => isTr ? 'Filiz Evresi' : 'Sprout Stage';
  String get stageSapling => isTr ? 'Fidan Evresi' : 'Sapling Stage';
  String get stageLeafyStem => isTr ? 'Gelişen Gövde Evresi' : 'Leafy Stem Stage';
  String get stageBud => isTr ? 'Tomurcuk Evresi' : 'Bud Stage';
  String get stageBlooming => isTr ? 'Açmış Çiçek Evresi' : 'Blooming Stage';
  String get stageMature => isTr ? 'Olgun Çiçek Evresi' : 'Mature Flower Stage';
  String get stageWilted =>
      isTr ? 'Solgun Çiçek (7 gün girilmedi)' : 'Wilted Flower (7 days inactive)';
  String get stageDead =>
      isTr ? 'Çiçek Soldu & Sıfırlandı (30 gün)' : 'Flower Died & Reset (30 days)';

  // İstatistikler
  String get statsTitle => isTr ? 'İstatistikler' : 'Statistics';
  String get todayFocusTime =>
      isTr ? 'Bugünkü Odaklanma Süresi' : "Today's Focus Time";
  String get weeklyAnalysis => isTr ? 'Haftalık Analiz' : 'Weekly Analysis';
  String get monthlyAnalysis => isTr ? 'Aylık Analiz' : 'Monthly Analysis';
  String get allTimeFocus =>
      isTr ? 'Tüm Zamanlar Toplam Odaklanma' : 'All-Time Total Focus';
  String get daysUnit => isTr ? 'gün' : 'days';
  String get hoursUnit => isTr ? 'saat' : 'hours';
  String get minutesUnit => isTr ? 'dakika' : 'minutes';
  String get secondsUnit => isTr ? 'saniye' : 'seconds';

  // Topluluk
  String get communityTitle => isTr ? 'Topluluk' : 'Community';
  String get countryRankingsTop10 =>
      isTr ? 'Ülkeler Sıralaması (İlk 10)' : 'Country Rankings (Top 10)';
  String get worldTop50 => isTr ? 'Dünyada İlk 50' : 'World Top 50';
  String get filterButton => isTr ? 'Filtrele' : 'Filter';
  String get filterByCountry =>
      isTr ? 'Ülkeye Göre Filtrele' : 'Filter by Country';
  String get allCountries => isTr ? 'Tüm Ülkeler' : 'All Countries';
  String get streakLabel => isTr ? 'Seri' : 'Streak';
  String get worldRankTitle => isTr ? 'Dünya Sıralaması' : 'World Rank';
  String get countryRankTitle => isTr ? 'Ülke Sıralaması' : 'Country Rank';
  String worldRankText(int rank) => isTr ? 'Dünyada $rank.' : 'World #$rank';
  String countryRankText(String country, int rank) =>
      isTr ? '$country: $rank.' : '#$rank in $country';

  // Profil
  String get profileTitle => isTr ? 'Profil & Ayarlar' : 'Profile & Settings';
  String get changePhoto => isTr ? 'Fotoğrafı Değiştir' : 'Change Photo';
  String get dailyStats => isTr ? 'Günlük' : 'Daily';
  String get weeklyStats => isTr ? 'Haftalık' : 'Weekly';
  String get yearlyStats => isTr ? 'Yıllık' : 'Yearly';
  String get hideInCommunity =>
      isTr ? 'Hesabımı toplulukta gösterme' : 'Hide account in community';
  String get resetStatsButton =>
      isTr ? 'İstatistikleri Sil' : 'Reset Statistics';
  String get deleteAccountButton =>
      isTr ? 'Hesabı Sil' : 'Delete Account';
  String get logoutButton => isTr ? 'Çıkış Yap' : 'Log Out';

  // Dialog Onayları
  String get resetStatsDialogTitle =>
      isTr ? 'İstatistikleri Sıfırla' : 'Reset Statistics';
  String get resetStatsDialogMessage => isTr
      ? 'Tüm odaklanma süreleriniz ve çiçek büyüme geçmişiniz kalıcı olarak sıfırlanacaktır. Emin misiniz?'
      : 'All your focus sessions and flower growth history will be permanently reset. Are you sure?';
  String get deleteAccountDialogTitle =>
      isTr ? 'Hesabı Kalıcı Olarak Sil' : 'Delete Account Permanently';
  String get deleteAccountDialogMessage => isTr
      ? 'Hesabınız ve tüm verileriniz kalıcı olarak silinecektir. Bu işlem geri alınamaz!'
      : 'Your account and all associated data will be deleted permanently. This cannot be undone!';
  String get logoutDialogTitle =>
      isTr ? 'Çıkış Yap' : 'Log Out';
  String get logoutDialogMessage => isTr
      ? 'Hesabınızdan çıkış yapmak istediğinize emin misiniz?'
      : 'Are you sure you want to log out of your account?';
  String get cancel => isTr ? 'Vazgeç' : 'Cancel';
  String get confirm => isTr ? 'Onayla' : 'Confirm';
  String get deletedSuccess =>
      isTr ? 'Hesabınız başarıyla silindi.' : 'Your account has been deleted.';
  String get resetSuccess =>
      isTr ? 'İstatistikleriniz sıfırlandı.' : 'Statistics have been reset.';
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['tr', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
