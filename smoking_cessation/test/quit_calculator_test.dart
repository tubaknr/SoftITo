// ========================================
// DOSYA: quit_calculator_test.dart
// NE İŞE YARAR: QuitCalculator hesaplamalarını
// ve StorageService operasyonlarını test eder.
// NASIL ÇALIŞIR: Birim testleri koşturulur.
// SOLID: Hesaplama doğruluğunu garanti eder.
// ========================================

import 'package:flutter_test/flutter_test.dart';
import 'package:smoking_cessation/models/health_milestone.dart';
import 'package:smoking_cessation/services/quit_calculator.dart';
import 'package:smoking_cessation/services/storage_service.dart';

void main() {
  group('QuitCalculator Testleri', () {
    test('Geçen süre ve gelecek tarih kontrolü', () {
      final quit = DateTime(2026, 11, 8, 10, 0);
      final now = DateTime(2026, 11, 8, 12, 30);
      final future = DateTime(2026, 11, 8, 9, 0);

      final elapsed = QuitCalculator.elapsedDuration(quit, now);
      expect(elapsed.inMinutes, 150);

      final zeroElapsed =
          QuitCalculator.elapsedDuration(quit, future);
      expect(zeroElapsed, Duration.zero);
    });

    test('Ondalıklı gün ve içilmeyen sigara hesabı', () {
      final halfDay = const Duration(hours: 12);
      final days = QuitCalculator.elapsedDaysDecimal(halfDay);
      expect(days, closeTo(0.5, 0.001));

      // 1.5 gün * 20 sigara = 30 adet
      final threeHalfDays = const Duration(hours: 36);
      final unsmoked = QuitCalculator.unsmokedCigarettes(
        QuitCalculator.elapsedDaysDecimal(threeHalfDays),
        20,
      );
      expect(unsmoked, 30);
    });

    test('Birim fiyat ve biriken para hesabı', () {
      final unitPrice =
          QuitCalculator.pricePerCigarette(100.0, 20);
      expect(unitPrice, 5.0);

      final totalSaved = QuitCalculator.moneySaved(28, unitPrice);
      expect(totalSaved, 140.0);
    });

    test('Sağlık kazanımları tamamlanma ve ilerleme hesabı', () {
      final milestone = const HealthMilestone(
        id: 'test',
        title: 'Test',
        description: 'Açıklama',
        startDuration: Duration(hours: 12),
        endDuration: Duration(hours: 24),
      );

      // 6 saat: henüz tamamlanmadı, ilerleme 0.25
      final at6h = const Duration(hours: 6);
      expect(
        QuitCalculator.isMilestoneCompleted(at6h, milestone),
        isFalse,
      );
      expect(
        QuitCalculator.milestoneProgress(at6h, milestone),
        closeTo(0.25, 0.01),
      );

      // 12 saat: başlangıç süresine ulaşıldı
      final at12h = const Duration(hours: 12);
      expect(
        QuitCalculator.isMilestoneCompleted(at12h, milestone),
        isTrue,
      );
      expect(
        QuitCalculator.milestoneProgress(at12h, milestone),
        closeTo(0.5, 0.01),
      );

      // 30 saat: bitişi geçti, ilerleme 1.0
      final at30h = const Duration(hours: 30);
      expect(
        QuitCalculator.milestoneProgress(at30h, milestone),
        1.0,
      );
    });

    test('Kazanılan ömür hesabı (1 sigara = 11 dk)', () {
      final regained = QuitCalculator.lifeRegained(10);
      expect(regained.inMinutes, 110);
    });
  });

  group('StorageService Testleri', () {
    test('InMemoryStorageService temel işlemleri', () async {
      final storage = InMemoryStorageService();
      await storage.writeString('key1', 'value1');

      final read = await storage.readString('key1');
      expect(read, 'value1');

      await storage.remove('key1');
      expect(await storage.readString('key1'), isNull);

      await storage.writeString('key2', 'value2');
      await storage.clear();
      expect(await storage.readString('key2'), isNull);
    });
  });
}
