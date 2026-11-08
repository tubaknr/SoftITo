// ========================================
// DOSYA: main.dart
// NE İŞE YARAR: Uygulamanın giriş noktasıdır,
// bağımlılıkları başlatır ve MaterialApp kurar.
// NASIL ÇALIŞIR: SharedPreferences ve controller
// nesnelerini kurup AppScope ile aktarır.
// SOLID: DIP - Bağımlılıklar burada bağlanır.
// ========================================

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/craving/craving_controller.dart';
import 'features/diary/diary_controller.dart';
import 'features/quit/quit_controller.dart';
import 'screens/home_shell_screen.dart';
import 'screens/onboarding_date_screen.dart';
import 'services/notification_service.dart';
import 'services/storage_service.dart';
import 'theme/app_theme.dart';

// DIP: Tüm controller'ları alt ağaca aktarır.
class AppScope extends InheritedWidget {
  final QuitController quitController;
  final DiaryController diaryController;
  final CravingController cravingController;

  const AppScope({
    super.key,
    required this.quitController,
    required this.diaryController,
    required this.cravingController,
    required super.child,
  });

  static AppScope of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope bulunamadı.');
    return scope!;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) =>
      false;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final storage = SharedPrefsStorageService(prefs);

  final notifications = LocalNotificationService();
  try {
    await notifications.init();
    await notifications.requestPermissions();
  } catch (_) {
    // Platform bildirim hatasını yut
  }

  final quitController = QuitController(storage, notifications);
  final diaryController = DiaryController(storage);
  final cravingController = CravingController();

  await quitController.init();
  await diaryController.init();

  runApp(
    AppScope(
      quitController: quitController,
      diaryController: diaryController,
      cravingController: cravingController,
      child: const SmokingCessationApp(),
    ),
  );
}

// SRP: MaterialApp ve başlangıç yönlendirmesi.
class SmokingCessationApp extends StatelessWidget {
  const SmokingCessationApp({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = AppScope.of(context);

    return MaterialApp(
      title: 'Lumina Recovery',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: ListenableBuilder(
        listenable: scope.quitController,
        builder: (context, _) {
          if (!scope.quitController.isOnboarded) {
            return OnboardingDateScreen(
              quitController: scope.quitController,
            );
          }
          return HomeShellScreen(
            quitController: scope.quitController,
          );
        },
      ),
    );
  }
}
