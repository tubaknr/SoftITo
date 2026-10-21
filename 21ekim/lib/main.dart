import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/l10n/app_localizations.dart';
import 'core/l10n/locale_controller.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/auth/controller/auth_controller.dart';
import 'features/auth/models/user_model.dart';
import 'features/auth/view/welcome_page.dart';
import 'features/community/controller/community_controller.dart';
import 'features/focus/controller/focus_controller.dart';
import 'features/shell/controller/shell_controller.dart';
import 'features/shell/view/shell_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Asenkron başlatmalar ve yerel depolama yüklemeleri
  await ThemeController.instance.loadThemeMode();
  await LocaleController.instance.loadLocale();
  await AuthController.instance.init();
  await FocusController.instance.init();
  await CommunityController.instance.init();

  runApp(const FocusAndGrowApp());
}

/// Focus & Grow (F&G) Kök Uygulama Widget'ı
class FocusAndGrowApp extends StatelessWidget {
  const FocusAndGrowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.instance,
      builder: (context, themeMode, _) {
        return ValueListenableBuilder<Locale>(
          valueListenable: LocaleController.instance,
          builder: (context, currentLocale, _) {
            return MaterialApp(
              title: 'Focus & Grow',
              debugShowCheckedModeBanner: false,
              themeMode: themeMode,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              locale: currentLocale,
              supportedLocales: const [
                Locale('tr'),
                Locale('en'),
              ],
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              home: const AppRootGate(),
            );
          },
        );
      },
    );
  }
}

/// Kullanıcı oturum durumuna göre Landing veya Shell ekranına yönlendiren Gate
class AppRootGate extends StatelessWidget {
  const AppRootGate({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<UserModel?>(
      valueListenable: AuthController.instance,
      builder: (context, user, _) {
        if (user != null) {
          return ShellView(
            onLogoutOrDelete: () {
              ShellController.instance.resetToHome();
            },
          );
        } else {
          return WelcomePage(
            onLoginSuccess: () {
              ShellController.instance.resetToHome();
            },
          );
        }
      },
    );
  }
}
