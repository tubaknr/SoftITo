/// Global application constants and configuration limits
class AppConstants {
  const AppConstants._();

  static const String appName = 'Small Tick & Big Grow';
  static const String brandSub = 'Small Tick';
  static const String brandMain = 'Big Grow';
  static const String appTagline = 'Küçük adımlar, büyük hedeflerin ruhudur.';

  // Storage Keys
  static const String keyThemeMode = 'penguhabit_theme_mode';
  static const String keyLocale = 'penguhabit_locale';
  static const String keyCurrentUser = 'penguhabit_current_user';
  static const String keyHabits = 'penguhabit_habits_v1';
  static const String keyCompletions = 'penguhabit_completions_v1';
  static const String keyNotificationSettings = 'penguhabit_notifications_v1';
  static const String keyBadges = 'penguhabit_badges_v1';

  // Streak Milestones
  static const int streakSilverDays = 21;
  static const int streakGoldDays = 42;
  static const int streakDiamondDays = 66;
  static const int streakMasterDays = 84;
  static const int microBadgeStep = 5;

  // Validation Rules
  static const int minPasswordLength = 8;

  // Date and Time constants
  static const int daysInWeek = 7;
}
