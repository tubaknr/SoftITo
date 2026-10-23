import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:penguhabit/core/l10n/app_localizations.dart';
import 'package:penguhabit/core/services/date_time_service.dart';
import 'package:penguhabit/core/services/local_store.dart';
import 'package:penguhabit/core/services/notification_service.dart';
import 'package:penguhabit/core/theme/app_theme.dart';
import 'package:penguhabit/features/auth/controller/auth_controller.dart';
import 'package:penguhabit/features/auth/data/auth_repository.dart';
import 'package:penguhabit/features/habits/controller/habits_controller.dart';
import 'package:penguhabit/features/habits/data/habits_repository.dart';
import 'package:penguhabit/features/notifications/controller/notifications_controller.dart';
import 'package:penguhabit/features/profile/view/profile_page.dart';
import 'package:penguhabit/features/settings/controller/settings_controller.dart';
import 'package:penguhabit/features/settings/view/settings_view.dart';
import 'package:penguhabit/features/shell/widget/app_top_bar.dart';

class _FakeLocalStore implements LocalStore {
  final Map<String, dynamic> _data = {};

  @override
  Future<String?> getString(String key) async => _data[key] as String?;

  @override
  Future<bool> setString(String key, String value) async {
    _data[key] = value;
    return true;
  }

  @override
  Future<bool> remove(String key) async {
    _data.remove(key);
    return true;
  }

  @override
  Future<bool> clear() async {
    _data.clear();
    return true;
  }
}

class _FakeDateTimeService implements DateTimeService {
  @override
  DateTime now() => DateTime(2026, 10, 23, 10, 0);

  @override
  DateTime today() => DateTime(2026, 10, 23);
}

Widget createTestApp(Widget child) {
  return MaterialApp(
    theme: AppTheme.lightTheme,
    locale: const Locale('tr'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    home: Scaffold(body: child),
  );
}

void main() {
  late _FakeLocalStore localStore;
  late _FakeDateTimeService dateTimeService;
  late LocalAuthRepository authRepo;
  late AuthController authController;
  late LocalHabitsRepository habitsRepo;
  late HabitsController habitsController;
  late NotificationsController notificationsController;

  setUp(() async {
    localStore = _FakeLocalStore();
    dateTimeService = _FakeDateTimeService();

    authRepo = LocalAuthRepository(localStore: localStore);
    authController = AuthController(repository: authRepo);
    await authRepo.signUp(
      name: 'Ayşe Test',
      email: 'ayse@example.com',
      password: 'password123',
    );
    await authController.init();

    habitsRepo = LocalHabitsRepository(
      localStore: localStore,
      dateTimeService: dateTimeService,
    );
    habitsController = HabitsController(
      repository: habitsRepo,
      dateTimeService: dateTimeService,
    );
    await habitsController.loadData();

    notificationsController = NotificationsController(
      localStore: localStore,
      notificationService: MockNotificationService(),
    );
  });

  group('Settings Feature Widget Tests', () {
    testWidgets('Profile page has gear button on the right of name and opens SettingsView',
        (tester) async {
      await tester.pumpWidget(
        createTestApp(
          ProfilePage(
            authController: authController,
            habitsController: habitsController,
            notificationsController: notificationsController,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Gear button exists
      final gearButton = find.byIcon(Icons.settings_outlined);
      expect(gearButton, findsOneWidget);

      // Tap gear button
      await tester.tap(gearButton);
      await tester.pumpAndSettle();

      // SettingsView opened
      expect(find.byType(SettingsView), findsOneWidget);
      expect(find.text('Ayarlar'), findsOneWidget);
    });

    testWidgets('Profile page NO LONGER has language, theme, backup, logout controls',
        (tester) async {
      await tester.pumpWidget(
        createTestApp(
          ProfilePage(
            authController: authController,
            habitsController: habitsController,
            notificationsController: notificationsController,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // None of the removed controls should be in ProfilePage
      expect(find.text('Dil / Language'), findsNothing);
      expect(find.text('Karanlık Tema'), findsNothing);
      expect(find.text('Verileri Yedekle'), findsNothing);
      expect(find.text('Çıkış Yap'), findsNothing);
      expect(find.byIcon(Icons.logout_rounded), findsNothing);
      expect(find.byIcon(Icons.backup_rounded), findsNothing);
    });

    testWidgets('AppTopBar NO LONGER has language pill (TR/EN) or theme toggle button',
        (tester) async {
      await tester.pumpWidget(
        createTestApp(
          Scaffold(
            appBar: AppTopBar(
              authController: authController,
              notificationsController: notificationsController,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // TR / EN pills and dark mode toggles should NOT be present in AppTopBar
      expect(find.text('TR'), findsNothing);
      expect(find.text('EN'), findsNothing);
      expect(find.byIcon(Icons.dark_mode_rounded), findsNothing);
      expect(find.byIcon(Icons.light_mode_rounded), findsNothing);

      // Notification bell remains
      expect(find.byIcon(Icons.notifications_none_rounded), findsOneWidget);
    });

    testWidgets('SettingsView has all 4 core functions: Language, Theme, Backup, Logout',
        (tester) async {
      final settingsController = SettingsController(
        authController: authController,
        habitsController: habitsController,
      );

      await tester.pumpWidget(
        createTestApp(
          SettingsView(controller: settingsController),
        ),
      );
      await tester.pumpAndSettle();

      // 4 functions present
      expect(find.text('Dil / Language'), findsOneWidget);
      expect(find.text('Karanlık Tema'), findsOneWidget);
      expect(find.text('Verileri Yedekle'), findsOneWidget);
      expect(find.text('Çıkış Yap'), findsOneWidget);

      // Section titles present
      expect(find.text('Görünüm'), findsOneWidget);
      expect(find.text('Veri'), findsOneWidget);
      expect(find.text('Hesap'), findsOneWidget);
    });
  });
}
