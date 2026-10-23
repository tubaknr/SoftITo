import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/firebase/firebase_service.dart';
import 'core/firebase/repository_factory.dart';
import 'core/l10n/app_localizations.dart';
import 'core/l10n/locale_controller.dart';
import 'core/services/local_store.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/auth/controller/auth_controller.dart';
import 'features/onboarding/view/welcome_page.dart';
import 'features/shell/view/shell_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize theme, language, and authentication state
  await ThemeController.instance.init();
  await LocaleController.instance.init();

  // Initialize Firebase (Firebase Auth & Cloud Firestore)
  await FirebaseService.instance.init();

  const localStore = SharedPreferencesLocalStore();
  final authRepository = RepositoryFactory.createAuthRepository(localStore: localStore);
  final authController = AuthController(repository: authRepository);
  await authController.init();

  runApp(PenguHabitApp(authController: authController));
}

/// PenguHabit root application widget
class PenguHabitApp extends StatelessWidget {
  const PenguHabitApp({super.key, required this.authController});

  final AuthController authController;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.instance,
      builder: (context, themeMode, _) {
        return ValueListenableBuilder<Locale>(
          valueListenable: LocaleController.instance,
          builder: (context, locale, _) {
            return MaterialApp(
              title: 'PenguHabit',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeMode,
              locale: locale,
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              home: ValueListenableBuilder(
                valueListenable: authController.currentUser,
                builder: (context, user, _) {
                  if (user != null) {
                    return ShellPage(authController: authController);
                  }
                  return WelcomePage(authController: authController);
                },
              ),
            );
          },
        );
      },
    );
  }
}
