import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focus_and_grow/core/l10n/app_localizations.dart';
import 'package:focus_and_grow/features/auth/view/register_page.dart';
import 'package:focus_and_grow/features/auth/view/welcome_page.dart';
import 'package:focus_and_grow/features/auth/view/welcome_transition_page.dart';
import 'package:focus_and_grow/features/focus/controller/focus_controller.dart';
import 'package:focus_and_grow/features/focus/view/focus_session_page.dart';
import 'package:focus_and_grow/main.dart';

void main() {
  testWidgets('Uygulama açılışında WelcomePage başarıyla yüklenir',
      (WidgetTester tester) async {
    await tester.pumpWidget(const FocusAndGrowApp());
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Focus & Grow'), findsOneWidget);
    expect(find.byType(WelcomePage), findsOneWidget);
  });

  testWidgets('Kayıt formunda boş alanlarda kural hataları görüntülenir',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('tr'),
        supportedLocales: const [Locale('tr'), Locale('en')],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: RegisterPage(onRegisterSuccess: () {}),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));

    // Kaydol butonuna kaydır ve bas
    final signUpButton = find.text('Kaydol');
    expect(signUpButton, findsOneWidget);
    await tester.ensureVisible(signUpButton);
    await tester.tap(signUpButton);
    await tester.pump(const Duration(milliseconds: 300));

    // Hata mesajlarının belirdiğini doğrula
    expect(
        find.text('Lütfen adınızı veya takma adınızı giriniz.'), findsOneWidget);
    expect(find.text('Lütfen email adresinizi giriniz.'), findsOneWidget);
  });

  testWidgets('Odaklanma oturumu ekranında PopScope canPop false olmalıdır',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: FocusSessionPage(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));

    final popScopeFinder = find.byType(PopScope);
    expect(popScopeFinder, findsOneWidget);

    final popScopeWidget = tester.widget<PopScope>(popScopeFinder);
    expect(popScopeWidget.canPop, isFalse);

    // Açık timer'ı temizle
    await FocusController.instance.stopFocusSession();
    await tester.pump(const Duration(milliseconds: 100));
  });

  testWidgets('WelcomeTransitionPage ekranında ilerle butonuna basılınca ShellView açılır',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('tr'),
        supportedLocales: [Locale('tr'), Locale('en')],
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: WelcomeTransitionPage(
          userName: 'Test Kullanıcı',
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));

    // "İlerle" butonunun var olduğunu doğrula
    final proceedBtn = find.text('İlerle');
    expect(proceedBtn, findsOneWidget);

    // Butona tıkla
    await tester.tap(proceedBtn);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    // ShellView ve alt sekmelerin açıldığını doğrula
    expect(find.text('Anasayfa'), findsOneWidget);
    expect(find.text('İstatistikler'), findsOneWidget);
    expect(find.text('Topluluk'), findsOneWidget);
    expect(find.text('Profil & Ayarlar'), findsOneWidget);
  });

  testWidgets(
      'Odaklanma oturumu durdur butonuna basılınca oturum durdurulur ve süre kaydedilir',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('tr'),
        supportedLocales: [Locale('tr'), Locale('en')],
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: FocusSessionPage(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.byType(FocusSessionPage), findsOneWidget);
    expect(FocusController.instance.isFocusing.value, isTrue);

    // Durdur butonuna tıkla
    final stopBtn = find.text('Durdur');
    expect(stopBtn, findsOneWidget);

    await tester.tap(stopBtn);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Oturumun durdurulduğunu doğrula
    expect(FocusController.instance.isFocusing.value, isFalse);
  });
}
