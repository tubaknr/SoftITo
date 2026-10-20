import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/controllers/locale_controller.dart';
import 'core/controllers/session_controller.dart';
import 'core/controllers/theme_controller.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/view/welcome_page.dart';
import 'features/shell/view/main_shell_page.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final ThemeController themeController = ThemeController();
  final LocaleController localeController = LocaleController();
  final SessionController sessionController = SessionController();

  runApp(
    KiralaGoApp(
      themeController: themeController,
      localeController: localeController,
      sessionController: sessionController,
    ),
  );
}

class KiralaGoApp extends StatelessWidget {
  const KiralaGoApp({
    required this.themeController,
    required this.localeController,
    required this.sessionController,
    super.key,
  });

  final ThemeController themeController;
  final LocaleController localeController;
  final SessionController sessionController;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge(<Listenable>[
        themeController,
        localeController,
        sessionController,
      ]),
      builder: (BuildContext context, _) {
        return MaterialApp(
          title: 'KiralaGo',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeController.value,
          locale: localeController.value,
          localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: sessionController.value.isLoggedIn
              ? MainShellPage(sessionController: sessionController)
              : WelcomePage(
                  sessionController: sessionController,
                  themeController: themeController,
                  localeController: localeController,
                ),
        );
      },
    );
  }
}
