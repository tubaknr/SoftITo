// ========================================
// DOSYA: quit_calculator.dart
// NE İŞE YARAR: Süre, tasarruf ve sağlık
// kazanımı formüllerini hesaplar.
// NASIL ÇALIŞIR: Saf fonksiyonlarla girdi
// alır ve hesaplanan sayıları döner.
// SOLID: SRP - Sadece matematiksel ve
// mantıksal hesaplama sorumluluğu vardır.
// ========================================

import '../models/health_milestone.dart';

// SRP: Tüm sigara bırakma hesaplarını yapar.
class QuitCalculator {
  QuitCalculator._();

  // Bırakma anından bu yana geçen süreyi bulur.
  static Duration elapsedDuration(
    DateTime quitDateTime,
    DateTime now,
  ) {
    if (now.isBefore(quitDateTime)) {
      return Duration.zero;
    }
    return now.difference(quitDateTime);
  }

  // Geçen süreyi ondalıklı gün cinsine çevirir.
  static double elapsedDaysDecimal(Duration elapsed) {
    if (elapsed <= Duration.zero) return 0.0;
    return elapsed.inMicroseconds /
        (24.0 * 3600.0 * 1000000.0);
  }

  // İçilmeyen sigara adedini aşağı yuvarlar.
  static int unsmokedCigarettes(
    double elapsedDays,
    int cigarettesPerDay,
  ) {
    if (elapsedDays <= 0 || cigarettesPerDay <= 0) return 0;
    return (elapsedDays * cigarettesPerDay).floor();
  }

  // Sigara başına düşen birim fiyatı bulur.
  static double pricePerCigarette(
    double packPrice,
    int cigarettesPerPack,
  ) {
    if (packPrice <= 0 || cigarettesPerPack <= 0) return 0.0;
    return packPrice / cigarettesPerPack;
  }

  // Toplam biriken tasarruf tutarını hesaplar.
  static double moneySaved(
    int unsmokedCount,
    double singlePrice,
  ) {
    if (unsmokedCount <= 0 || singlePrice <= 0) return 0.0;
    return unsmokedCount * singlePrice;
  }

  // Kilometre taşının başlayıp
  // başlamadığını kontrol eder.
  static bool isMilestoneCompleted(
    Duration elapsed,
    HealthMilestone milestone,
  ) {
    return elapsed >= milestone.startDuration;
  }

  // Kilometre taşının ilerleme oranını döner.
  static double milestoneProgress(
    Duration elapsed,
    HealthMilestone milestone,
  ) {
    if (elapsed <= Duration.zero) return 0.0;
    final totalSec = milestone.endDuration.inSeconds;
    if (totalSec <= 0) return 1.0;
    final ratio = elapsed.inSeconds / totalSec;
    return ratio.clamp(0.0, 1.0);
  }

  // Kazanılan yaşam süresi (sigara başına 11 dk).
  static Duration lifeRegained(int unsmokedCount) {
    if (unsmokedCount <= 0) return Duration.zero;
    return Duration(minutes: unsmokedCount * 11);
  }
}
