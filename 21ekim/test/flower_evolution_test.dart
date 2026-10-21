import 'package:flutter_test/flutter_test.dart';
import 'package:focus_and_grow/core/constants/app_constants.dart';
import 'package:focus_and_grow/features/focus/controller/focus_controller.dart';

void main() {
  group('Çiçek Yaşam Döngüsü ve Büyüme Algoritması Testleri', () {
    final now = DateTime(2026, 10, 21, 12, 0);

    test('0 saniye odaklanmada Tohum evresi olmalıdır', () {
      final stage = FocusController.calculateFlowerStage(
        totalSeconds: 0,
        lastActiveAt: now,
        currentTime: now,
      );
      expect(stage, equals(FlowerStage.seed));
    });

    test('15 dakika (900 sn) odaklanmada Filiz evresi olmalıdır', () {
      final stage = FocusController.calculateFlowerStage(
        totalSeconds: 15 * 60,
        lastActiveAt: now,
        currentTime: now,
      );
      expect(stage, equals(FlowerStage.sprout));
    });

    test('1 saat (3600 sn) odaklanmada Fidan evresi olmalıdır', () {
      final stage = FocusController.calculateFlowerStage(
        totalSeconds: 3600,
        lastActiveAt: now,
        currentTime: now,
      );
      expect(stage, equals(FlowerStage.sapling));
    });

    test('3 saat (10800 sn) odaklanmada Yapraklı Gövde evresi olmalıdır', () {
      final stage = FocusController.calculateFlowerStage(
        totalSeconds: 3 * 3600,
        lastActiveAt: now,
        currentTime: now,
      );
      expect(stage, equals(FlowerStage.leafyStem));
    });

    test('8 saat (28800 sn) odaklanmada Tomurcuk evresi olmalıdır', () {
      final stage = FocusController.calculateFlowerStage(
        totalSeconds: 8 * 3600,
        lastActiveAt: now,
        currentTime: now,
      );
      expect(stage, equals(FlowerStage.bud));
    });

    test('20 saat (72000 sn) odaklanmada Açmış Çiçek evresi olmalıdır', () {
      final stage = FocusController.calculateFlowerStage(
        totalSeconds: 20 * 3600,
        lastActiveAt: now,
        currentTime: now,
      );
      expect(stage, equals(FlowerStage.blooming));
    });

    test('50 saat (180000 sn) odaklanmada Olgun Çiçek evresi olmalıdır', () {
      final stage = FocusController.calculateFlowerStage(
        totalSeconds: 50 * 3600,
        lastActiveAt: now,
        currentTime: now,
      );
      expect(stage, equals(FlowerStage.mature));
    });

    test('7 gün girilmezse çiçek Solgun (wilted) olmalıdır', () {
      final sevenDaysAgo = now.subtract(const Duration(days: 7, hours: 1));
      final stage = FocusController.calculateFlowerStage(
        totalSeconds: 100 * 3600,
        lastActiveAt: sevenDaysAgo,
        currentTime: now,
      );
      expect(stage, equals(FlowerStage.wilted));
    });

    test('30 gün girilmezse çiçek Ölür (dead) ve sıfırlanır', () {
      final thirtyDaysAgo = now.subtract(const Duration(days: 30, hours: 2));
      final stage = FocusController.calculateFlowerStage(
        totalSeconds: 100 * 3600,
        lastActiveAt: thirtyDaysAgo,
        currentTime: now,
      );
      expect(stage, equals(FlowerStage.dead));
    });
  });
}
