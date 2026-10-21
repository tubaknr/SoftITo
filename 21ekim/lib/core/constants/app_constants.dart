/// Focus & Grow (F&G) temel sistem ve çiçek yaşam döngüsü sabitleri.
class AppConstants {
  AppConstants._();

  static const String appName = 'Focus & Grow';
  static const String appShortName = 'F&G';
  static const String mottoTr = 'Odaklanarak yaşamı daha derinden hissetmek ister misin?';
  static const String mottoEn = 'Would you like to feel life more deeply through focus?';

  // Çiçek büyüme evreleri eşikleri (saniye cinsinden)
  // Tohum: 0 dk
  // Filiz: 15 dk (900 sn)
  // Fidan: 1 sa (3600 sn)
  // Yapraklı Gövde: 3 sa (10800 sn)
  // Tomurcuk: 8 sa (28800 sn)
  // Açmış Çiçek: 20 sa (72000 sn)
  // Olgun Çiçek: 50 sa (180000 sn)
  static const int seedThresholdSeconds = 0;
  static const int sproutThresholdSeconds = 15 * 60; // 900
  static const int saplingThresholdSeconds = 60 * 60; // 3600
  static const int leafyStemThresholdSeconds = 3 * 3600; // 10800
  static const int budThresholdSeconds = 8 * 3600; // 28800
  static const int bloomingThresholdSeconds = 20 * 3600; // 72000
  static const int matureFlowerThresholdSeconds = 50 * 3600; // 180000

  // Solma ve Ölüm kuralı eşikleri (gün)
  static const int wiltDays = 7;
  static const int deathDays = 30;

  // SharedPreferences anahtarları
  static const String prefKeyThemeMode = 'fg_theme_mode';
  static const String prefKeyLanguageCode = 'fg_language_code';
  static const String prefKeyUser = 'fg_user_profile';
  static const String prefKeySessions = 'fg_focus_sessions';
  static const String prefKeyLastActive = 'fg_last_active_time';
}

/// Çiçek yaşam döngüsü ve evre enum tanımı
enum FlowerStage {
  seed,        // Tohum (0 dk)
  sprout,      // Filiz (15 dk)
  sapling,     // Fidan (1 sa)
  leafyStem,   // Yapraklı gövde (3 sa)
  bud,         // Tomurcuk (8 sa)
  blooming,    // Açmış çiçek (20 sa)
  mature,      // Olgun çiçek (50 sa)
  wilted,      // Solgun (7 gün girilmezse)
  dead,        // Ölü / Tohuma dönüş (30 gün girilmezse)
}
