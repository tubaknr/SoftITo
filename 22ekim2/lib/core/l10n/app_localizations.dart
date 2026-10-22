import 'package:flutter/material.dart';

/// AppLocalizations provides all string translations for TR and EN
class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('tr'));
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('tr'),
    Locale('en'),
  ];

  bool get isTr => locale.languageCode == 'tr';

  // --- Common & App Identity ---
  String get appName => 'Small Tick & Big Grow';
  String get brandSub => 'Small Tick';
  String get brandMain => 'Big Grow';
  String get brandMotto => isTr
      ? 'Küçük adımlar, büyük hedeflerin ruhudur.'
      : 'Critical steps are the soul of great goals.';
  String get mottoQuestion => isTr
      ? 'Hedeflerine ulaşmak için alışkanlıkların gücünden yararlanmaya hazır mısın?'
      : 'Ready to harness the power of habits to reach your goals?';

  // --- Auth & Onboarding ---
  String get welcomeTitle => isTr ? 'Small Tick & Big Grow’a Hoş Geldin!' : 'Welcome to Small Tick & Big Grow!';
  String get registerAction => isTr ? 'Kayıt Ol' : 'Sign Up';
  String get loginAction => isTr ? 'Giriş Yap' : 'Log In';
  String get googleContinue => isTr ? 'Google ile Devam Et' : 'Continue with Google';
  String get proceedAction => isTr ? 'İlerle' : 'Proceed';
  String get registerEncouragement => isTr
      ? 'Hedeflerine ulaşmak için ilk adımını at'
      : 'Take your first step to reach your goals';
  String get nameLabel => isTr ? 'Ad Soyad' : 'Full Name';
  String get emailLabel => isTr ? 'E-posta' : 'Email';
  String get passwordLabel => isTr ? 'Şifre' : 'Password';
  String get confirmPasswordLabel => isTr ? 'Şifre Doğrulama' : 'Confirm Password';
  String get forgotPasswordLink => isTr ? 'Şifremi unuttum' : 'Forgot password';
  String get sendCodeAction => isTr ? 'Kod Gönder' : 'Send Code';
  String get forgotPasswordInfo => isTr
      ? 'Hedeflerine ulaşmak için e-mailini girebilirsin.'
      : 'You can enter your email to reach your goals.';
  String get resetCodeSent => isTr
      ? 'Şifre sıfırlama kodu e-posta adresinize gönderildi.'
      : 'Password reset code has been sent to your email.';
  String get alreadyHaveAccount => isTr ? 'Zaten hesabın var mı?' : 'Already have an account?';
  String get dontHaveAccount => isTr ? 'Hesabın yok mu?' : "Don't have an account?";

  // --- Validation Errors ---
  String get errorNameRequired => isTr ? 'Ad boş olamaz.' : 'Name cannot be empty.';
  String get errorEmailInvalid => isTr ? 'Geçerli bir e-posta girin.' : 'Enter a valid email.';
  String get errorPasswordLength => isTr
      ? 'Şifre en az 8 karakter olmalıdır.'
      : 'Password must be at least 8 characters.';
  String get errorPasswordMismatch => isTr ? 'Şifreler eşleşmiyor.' : 'Passwords do not match.';
  String get errorInvalidCredentials => isTr
      ? 'E-posta veya şifre hatalı.'
      : 'Invalid email or password.';

  // --- TopBar & Navigation ---
  String get smallSteps => isTr ? 'Minik Adımlar' : 'Tiny Steps';
  String get newAction => isTr ? 'Yeni' : 'New';
  String welcomeUser(String name) => isTr ? 'Hoşgeldin $name' : 'Welcome $name';
  String get tabHome => isTr ? 'Anasayfa' : 'Home';
  String get tabCalendar => isTr ? 'Takvim' : 'Calendar';
  String get tabAnalytics => isTr ? 'Analiz & Grafikler' : 'Analytics';
  String get tabProfile => isTr ? 'Profil' : 'Profile';

  // --- Home Screen ---
  String get todayHabits => isTr ? 'Bugünkü Alışkanlıklar' : "Today's Habits";
  String get todayGreatDay => isTr ? 'Bugün harika bir gün! ✨' : 'Today is a great day! ✨';
  String get todaySubQuote => isTr
      ? 'Küçük bir tik at, büyük büyümeni keyifle izle.'
      : 'Tick a small step, watch your big growth.';
  String get dailyMotivation => isTr ? 'Günün Motivasyonu' : "Daily Motivation";
  String get dailyProgress => isTr ? 'Günlük İlerleme' : 'Daily Progress';
  String habitsRemaining(int count) => isTr ? '$count alışkanlık kaldı' : '$count habits remaining';
  String get allStepsCompletedToday => isTr ? 'Bugünkü tüm adımlar tamamlandı! 🎉' : 'All steps completed today! 🎉';
  String activeStreakDays(int days) => isTr ? '🔥 $days gün serisi aktif' : '🔥 $days day streak active';
  String get addAwarenessNote => isTr ? 'Farkındalık Notu Ekle' : 'Add Mindfulness Note';
  String get awarenessNoteSub => isTr
      ? 'Tamamladığın adımların hissini kaydet'
      : 'Record how your completed steps felt';
  String get emptyHabitsTitle => isTr ? 'Hiç alışkanlık eklememişsin!' : "You haven't added any habits yet!";
  String get emptyHabitsSubtitle => isTr
      ? 'Büyük hedefler, küçük bir tik ile başlar.'
      : 'Big goals start with a small tick.';
  String get addFirstHabit => isTr ? 'Hemen İlk Alışkanlığını Ekle' : 'Add Your First Habit Now';
  String get addHabit => isTr ? 'Alışkanlık Ekle' : 'Add Habit';
  String get allHabits => isTr ? 'Tüm Alışkanlıklar' : 'All Habits';
  String get completedHabitToast => isTr ? 'Tebrikler! Alışkanlığını tamamladın 🎉' : 'Congrats! Habit completed 🎉';
  String streakDays(int days) => isTr ? '🔥 $days Günlük Seri' : '🔥 $days Days Streak';
  String get frequencyDaily => isTr ? 'Her gün' : 'Daily';
  String get frequencyCustom => isTr ? 'Haftalık Plan' : 'Weekly Plan';

  // --- Reflection Modal ---
  String get reflectionQuestion => isTr
      ? 'Bu alışkanlığı tamamlayınca nasıl hissettim?'
      : 'How did I feel after completing this habit?';
  String get awarenessNoteLabel => isTr
      ? 'Bana neler hissettirdi, ne fark ettim?'
      : 'What did it make me feel, what did I notice?';
  String get saveNoteAction => isTr ? 'Notu Alışkanlığa Ekle' : 'Add Note to Habit';
  String get skipAction => isTr ? 'Atla' : 'Skip';
  String get moodAwesome => isTr ? 'Harika' : 'Awesome';
  String get moodHappy => isTr ? 'Mutlu' : 'Happy';
  String get moodCalm => isTr ? 'Dingin' : 'Calm';
  String get moodTired => isTr ? 'Yorgun' : 'Tired';
  String get moodChallenging => isTr ? 'Zorlayıcı' : 'Challenging';
  String get viewReflectionNote => isTr ? 'Günün Notu' : "Today's Note";
  String get confirmUndoWithNote => isTr
      ? 'Bu alışkanlığa ait duygu notu silinecek. Geri almak istediğine emin misin?'
      : 'The mood note for this habit will be removed. Are you sure you want to undo?';

  // --- Habits Management ---
  String get editHabit => isTr ? 'Alışkanlığı Düzenle' : 'Edit Habit';
  String get habitTitleLabel => isTr ? 'Alışkanlık Adı' : 'Habit Name';
  String get habitTitleHint => isTr ? 'Örn: Kitap Oku, Su İç' : 'e.g. Read Book, Drink Water';
  String get habitDescLabel => isTr ? 'Açıklama (İsteğe bağlı)' : 'Description (Optional)';
  String get habitDescHint => isTr ? 'Açıklama...' : 'Description...';
  String get repeatDaysLabel => isTr ? 'Tekrar Günleri' : 'Repeat Days';
  String get reminderTimeLabel => isTr ? 'Hatırlatma Saati' : 'Reminder Time';
  String get pickTimeAction => isTr ? 'Saat Seç' : 'Pick Time';
  String get selectColorLabel => isTr ? 'Takvim Rengi' : 'Calendar Color';
  String get saveAction => isTr ? 'Kaydet' : 'Save';
  String get cancelAction => isTr ? 'İptal' : 'Cancel';
  String get deleteAction => isTr ? 'Sil' : 'Delete';
  String get changeAction => isTr ? 'Değiştir' : 'Change';
  String get confirmDeleteHabit => isTr
      ? 'Bu alışkanlığı silmek istediğinize emin misiniz? Tüm geçmiş silinecektir.'
      : 'Are you sure you want to delete this habit? All history will be lost.';
  String get errorRepeatDaysRequired => isTr
      ? 'En az 1 tekrar günü seçmelisiniz.'
      : 'You must select at least 1 repeat day.';

  // Day names short
  String get dayMon => isTr ? 'Pzt' : 'Mon';
  String get dayTue => isTr ? 'Sal' : 'Tue';
  String get dayWed => isTr ? 'Çar' : 'Wed';
  String get dayThu => isTr ? 'Per' : 'Thu';
  String get dayFri => isTr ? 'Cum' : 'Fri';
  String get daySat => isTr ? 'Cmt' : 'Sat';
  String get daySun => isTr ? 'Paz' : 'Sun';

  // --- Calendar Screen ---
  String get calendarTitle => isTr ? 'Alışkanlık Takvimi' : 'Habit Calendar';
  String get filterWeekly => isTr ? 'Haftalık' : 'Weekly';
  String get filterTwoWeeks => isTr ? '2 Haftalık' : '2 Weeks';
  String get filterMonthly => isTr ? 'Aylık' : 'Monthly';
  String get filterTwoMonths => isTr ? '2 Aylık' : '2 Months';
  String get filterThreeMonths => isTr ? '3 Aylık' : '3 Months';
  String get cannotCompleteFuture => isTr ? 'Gelecek günler tamamlanamaz.' : 'Future days cannot be completed.';
  String get noHabitsOnThisDay => isTr ? 'Bu güne planlanmış alışkanlık yok.' : 'No habits scheduled on this day.';
  String get dayDetails => isTr ? 'Gün Detayı' : 'Day Details';
  String get monthlyTracking => isTr ? 'Bu ay alışkanlık takibi' : 'Monthly habit tracking';

  // --- Analytics Screen ---
  String get analyticsTitle => isTr ? 'Analiz ve İlerleme' : 'Analytics & Progress';
  String get overallContinuity => isTr ? 'Genel Devamlılık Başarısı' : 'Overall Continuity Rate';
  String get habitPerformance => isTr ? 'Alışkanlık Bazlı Başarı' : 'Habit Performance';
  String get moodDistributionTitle => isTr ? 'Duygu Dağılım Çizelgesi' : 'Mood Distribution';
  String get continuityChartTitle => isTr ? 'Devamlılık Grafiği' : 'Continuity Chart';
  String get greatConsistency => isTr ? 'Müthiş bir istikrar! ' : 'Great consistency! ';
  String get consistencySub => isTr
      ? 'Küçük adımların büyük büyümeni inşa ediyor.'
      : 'Your small steps are building your big growth.';
  String get range7Days => isTr ? 'Son 7 Gün' : 'Last 7 Days';
  String get range30Days => isTr ? 'Son 30 Gün' : 'Last 30 Days';
  String get range90Days => isTr ? 'Son 90 Gün' : 'Last 90 Days';
  String get rangeAll => isTr ? 'Tümü' : 'All';
  String get noAnalyticsData => isTr ? 'Analiz edilecek yeterli veri bulunamadı.' : 'Not enough data to analyze yet.';
  String get completionRate => isTr ? 'Tamamlama Oranı' : 'Completion Rate';

  // --- Profile Screen ---
  String get profileTitle => isTr ? 'Profil & Ayarlar' : 'Profile & Settings';
  String get proMember => isTr ? 'Pro Üye' : 'Pro Member';
  String get growingTogether => isTr ? 'Birlikte büyüyoruz 🌱' : 'Growing together 🌱';
  String get activeStreakTracking => isTr ? 'Aktif Seri Takibi' : 'Active Streak Tracking';
  String get completedLabel => isTr ? 'Tamamlanan' : 'Completed';
  String smallTicksCount(int count) => isTr ? '$count Küçük Tik' : '$count Small Ticks';
  String get growthLabel => isTr ? 'Büyüme' : 'Growth';
  String bigGrowScore(int score) => '$score Big Grow';
  String daysCount(int count) => isTr ? '$count Gün' : '$count Days';
  String get noNotesYet => isTr ? 'Henüz farkındalık notu eklenmedi.' : 'No mindfulness notes added yet.';
  String get sectionHabits => isTr ? 'Alışkanlıklarım' : 'My Habits';
  String get sectionBadges => isTr ? 'Rozetlerim' : 'My Badges';
  String get sectionNotifications => isTr ? 'Bildirimler' : 'Notifications';
  String get sectionNotes => isTr ? 'Notlarım' : 'My Notes';
  String get averageMood => isTr ? 'Duygu Ortalaması' : 'Average Mood';
  String get logoutAction => isTr ? 'Çıkış Yap' : 'Log Out';
  String get confirmLogout => isTr ? 'Oturumu kapatmak istediğine emin misin?' : 'Are you sure you want to log out?';
  String get themeModeToggle => isTr ? 'Karanlık Tema' : 'Dark Mode';
  String get languageToggle => isTr ? 'Dil / Language' : 'Language / Dil';

  // --- Badges ---
  String get badgeSilverPenguin => isTr ? 'Gümüş Penguen' : 'Silver Penguin';
  String get badgeGoldPenguin => isTr ? 'Altın Penguen' : 'Gold Penguin';
  String get badgeDiamondPenguin => isTr ? 'Elmas Penguen' : 'Diamond Penguin';
  String get badgeMasterPenguin => isTr ? 'Usta Penguen' : 'Master Penguin';
  String badgeStepTitle(int step) => isTr ? '$step Tamamlama Rozeti' : '$step Completion Badge';
  String get badgeEarnedToast => isTr ? 'Yeni bir rozet kazandın! 🏆' : 'You earned a new badge! 🏆';
  String get noBadgesYet => isTr ? 'Henüz kazanılmış bir rozet yok. Alışkanlıklarını tamamla!' : 'No badges earned yet. Complete your habits!';

  // --- Notifications Settings ---
  String get notificationSettingsTitle => isTr ? 'Bildirimleri Kişiselleştir' : 'Customize Notifications';
  String get notifSuccessTitle => isTr ? 'Başarı Bildirimi' : 'Success Notification';
  String get notifSuccessDesc => isTr ? 'Alışkanlık tamamlandığında tebrik bildirimi' : 'Celebration alert on completion';
  String get notifMotivationTitle => isTr ? 'Günlük Motivasyon Cümlesi' : 'Daily Motivation Quote';
  String get notifMotivationDesc => isTr ? 'Her gün ilham verici söz bildirimi' : 'Inspiring quote every day';
  String get notifMissedTitle => isTr ? 'Kaçırılan Gün Uyarısı' : 'Missed Day Warning';
  String get notifMissedDesc => isTr ? 'Alışkanlık yapılmadığında nazik teşvik' : 'Gentle nudge on missed days';
  String get notifRemindersTitle => isTr ? 'Gün İçi Hatırlatmalar' : 'Daytime Reminders';
  String get notifRemindersDesc => isTr ? 'Su içme, kitap okuma vb. mini anımsatıcılar' : 'Hydration, reading mini reminders';
  String get notifFrequency => isTr ? 'Sıklık (Saat aralığı)' : 'Frequency (Hours interval)';
  String get hourUnit => isTr ? 'saatte bir' : 'hours';
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['tr', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return Future.value(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
