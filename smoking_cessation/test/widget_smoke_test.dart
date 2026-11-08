// ========================================
// DOSYA: widget_smoke_test.dart
// NE İŞE YARAR: Ekran akışları ve arayüzün
// duman (smoke) testlerini koşturur.
// NASIL ÇALIŞIR: flutter_test ile sahte
// servisler üzerinde widget testi yapar.
// SOLID: Arayüz ve bağımlılık testleri.
// ========================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smoking_cessation/features/craving/craving_controller.dart';
import 'package:smoking_cessation/features/diary/diary_controller.dart';
import 'package:smoking_cessation/features/quit/quit_controller.dart';
import 'package:smoking_cessation/main.dart';
import 'package:smoking_cessation/models/user_profile.dart';
import 'package:smoking_cessation/screens/home_shell_screen.dart';
import 'package:smoking_cessation/screens/onboarding_date_screen.dart';
import 'package:smoking_cessation/services/notification_service.dart';
import 'package:smoking_cessation/services/storage_service.dart';

void main() {
  late InMemoryStorageService storage;
  late FakeNotificationService notifications;
  late QuitController quitController;
  late DiaryController diaryController;
  late CravingController cravingController;

  setUp(() async {
    storage = InMemoryStorageService();
    notifications = FakeNotificationService();
    quitController = QuitController(storage, notifications);
    diaryController = DiaryController(storage);
    cravingController = CravingController();

    await quitController.init();
    await diaryController.init();
  });

  Widget createTestApp() {
    return AppScope(
      quitController: quitController,
      diaryController: diaryController,
      cravingController: cravingController,
      child: const SmokingCessationApp(),
    );
  }

  testWidgets('Profil yoksa OnboardingDateScreen açılmalı',
      (tester) async {
    await tester.pumpWidget(createTestApp());
    await tester.pumpAndSettle();

    expect(find.byType(OnboardingDateScreen), findsOneWidget);
    expect(find.text('Sigarayı ne zaman bıraktın?'), findsOneWidget);
  });

  testWidgets('Profil varsa HomeShellScreen açılmalı ve sekmeler çalışmalı',
      (tester) async {
    final profile = UserProfile(
      quitDateTime: DateTime.now().subtract(const Duration(days: 2)),
      cigarettesPerDay: 20,
      packPrice: 100.0,
      cigarettesPerPack: 20,
    );
    await quitController.saveProfile(profile);

    await tester.pumpWidget(createTestApp());
    await tester.pumpAndSettle();

    expect(find.byType(HomeShellScreen), findsOneWidget);
    expect(find.text('DUMANSIZ GEÇEN SÜRE'), findsOneWidget);

    // Sağlık sekmesine geçiş
    await tester.tap(find.byIcon(Icons.favorite_border));
    await tester.pumpAndSettle();
    expect(find.text('Biyolojik İyileşme'), findsOneWidget);

    // Günlük sekmesine geçiş
    await tester.tap(find.byIcon(Icons.calendar_month_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Bugün İçmedim'), findsOneWidget);

    // Ayarlar sekmesine geçiş
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    expect(find.text('PROFİL BİLGİLERİ'), findsOneWidget);
  });

  testWidgets('Bildirim ayarı değişince bildirim servisi senkronize olmalı',
      (tester) async {
    final profile = UserProfile(
      quitDateTime: DateTime.now().subtract(const Duration(days: 1)),
      cigarettesPerDay: 15,
      packPrice: 80.0,
      cigarettesPerPack: 20,
    );
    await quitController.saveProfile(profile);
    expect(notifications.isDailyScheduled, isTrue);

    // Bildirimi kapat
    final updated = quitController.settings
        .copyWith(notificationsEnabled: false);
    await quitController.saveSettings(updated);
    expect(notifications.isCancelled, isTrue);
  });
}
