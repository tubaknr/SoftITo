class AppDurations {
  AppDurations._();

  /// 150 ms - Hızlı mikro etkileşimler, buton basımları
  static const Duration short = Duration(milliseconds: 150);

  /// 250 ms - Orta süre, sayfa geçişleri, chip ve sekme değişimleri
  static const Duration medium = Duration(milliseconds: 250);

  /// 400 ms - Uzun süre, diyalog açılışları, bottom sheet animasyonları
  static const Duration long = Duration(milliseconds: 400);
}
