import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:penguhabit/core/services/date_time_service.dart';
import 'package:penguhabit/core/services/local_store.dart';
import 'package:penguhabit/features/auth/controller/auth_controller.dart';
import 'package:penguhabit/features/auth/data/auth_repository.dart';
import 'package:penguhabit/features/habits/controller/habits_controller.dart';
import 'package:penguhabit/features/habits/data/habits_repository.dart';
import 'package:penguhabit/features/habits/models/habit.dart';
import 'package:penguhabit/features/settings/controller/settings_controller.dart';

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

void main() {
  late _FakeLocalStore localStore;
  late _FakeDateTimeService dateTimeService;
  late LocalAuthRepository authRepo;
  late AuthController authController;
  late LocalHabitsRepository habitsRepo;
  late HabitsController habitsController;

  late ValueNotifier<Locale> localeNotifier;
  late ValueNotifier<ThemeMode> themeModeNotifier;
  late SettingsController settingsController;

  Locale? savedLocale;
  ThemeMode? savedThemeMode;

  setUp(() async {
    localStore = _FakeLocalStore();
    dateTimeService = _FakeDateTimeService();

    authRepo = LocalAuthRepository(localStore: localStore);
    authController = AuthController(repository: authRepo);
    await authRepo.signUp(
      name: 'Test Kullanıcısı',
      email: 'test@example.com',
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

    localeNotifier = ValueNotifier<Locale>(const Locale('tr'));
    themeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.light);

    savedLocale = null;
    savedThemeMode = null;

    settingsController = SettingsController(
      authController: authController,
      habitsController: habitsController,
      localeNotifier: localeNotifier,
      themeModeNotifier: themeModeNotifier,
      onLocaleChanged: (loc) async {
        savedLocale = loc;
        localeNotifier.value = loc;
      },
      onThemeChanged: (mode) async {
        savedThemeMode = mode;
        themeModeNotifier.value = mode;
      },
    );
  });

  group('SettingsController Unit Tests', () {
    test('Initial states reflect locale and theme', () {
      expect(settingsController.isTurkish, isTrue);
      expect(settingsController.isDarkMode, isFalse);
      expect(settingsController.currentLocale, const Locale('tr'));
      expect(settingsController.currentThemeMode, ThemeMode.light);
    });

    test('Locale toggling and direct setting updates notifier & persists', () async {
      await settingsController.toggleLocale();
      expect(settingsController.isTurkish, isFalse);
      expect(settingsController.currentLocale, const Locale('en'));
      expect(savedLocale, const Locale('en'));

      await settingsController.setLocale(const Locale('tr'));
      expect(settingsController.isTurkish, isTrue);
      expect(savedLocale, const Locale('tr'));
    });

    test('Theme toggling and direct setting updates notifier & persists', () async {
      await settingsController.toggleTheme();
      expect(settingsController.isDarkMode, isTrue);
      expect(settingsController.currentThemeMode, ThemeMode.dark);
      expect(savedThemeMode, ThemeMode.dark);

      await settingsController.setThemeMode(ThemeMode.light);
      expect(settingsController.isDarkMode, isFalse);
      expect(savedThemeMode, ThemeMode.light);
    });

    test('Backup collects habit, completion, and badge stats accurately', () async {
      await habitsController.loadData();
      final initialCount = habitsController.habits.value.length;

      await habitsController.saveHabit(
        Habit(
          id: 'habit-custom-1',
          title: 'Kitap Oku',
          repeatDays: const [1, 2, 3],
          colorIndex: 0,
          createdAt: DateTime(2026, 10, 1),
        ),
      );

      final result = await settingsController.backupData();
      expect(result.success, isTrue);
      expect(result.habitsCount, initialCount + 1);
    });

    test('Logout clears session via AuthController', () async {
      expect(authController.currentUser.value, isNotNull);
      await settingsController.logout();
      expect(authController.currentUser.value, isNull);
    });
  });
}
