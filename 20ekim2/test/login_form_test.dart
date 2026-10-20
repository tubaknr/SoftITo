import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kiralago/core/controllers/session_controller.dart';
import 'package:kiralago/core/theme/app_theme.dart';
import 'package:kiralago/features/auth/widget/login_form.dart';
import 'package:kiralago/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  testWidgets('LoginForm validation and successful mock submit test', (WidgetTester tester) async {
    final SessionController sessionController = SessionController();
    bool successCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('tr'),
        theme: AppTheme.lightTheme,
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: LoginForm(
              role: UserRole.renter,
              sessionController: sessionController,
              onSuccess: () => successCalled = true,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Giriş butonunu bul ve tıkla
    final Finder loginBtn = find.byType(FilledButton);
    expect(loginBtn, findsOneWidget);

    await tester.tap(loginBtn);
    // Simüle gecikmeyi tüket
    await tester.pump(const Duration(milliseconds: 650));
    await tester.pumpAndSettle();

    expect(successCalled, isTrue);
    expect(sessionController.value.isLoggedIn, isTrue);
    expect(sessionController.value.role, equals(UserRole.renter));
  });
}
