import 'package:flutter_test/flutter_test.dart';
import 'package:kiralago/core/controllers/locale_controller.dart';
import 'package:kiralago/core/controllers/session_controller.dart';
import 'package:kiralago/core/controllers/theme_controller.dart';
import 'package:kiralago/main.dart';

void main() {
  testWidgets('KiralaGoApp smoke test - WelcomePage displays correctly', (WidgetTester tester) async {
    final ThemeController themeController = ThemeController();
    final LocaleController localeController = LocaleController();
    final SessionController sessionController = SessionController();

    await tester.pumpWidget(
      KiralaGoApp(
        themeController: themeController,
        localeController: localeController,
        sessionController: sessionController,
      ),
    );
    await tester.pumpAndSettle();

    // Uygulama başlığı ve rol butonlarının görünürlüğünü doğrula
    expect(find.text('KiralaGo'), findsOneWidget);
    expect(find.text('Araç kiralamak istiyorum'), findsOneWidget);
    expect(find.text('Araç kiralamaya vermek istiyorum'), findsOneWidget);
  });
}
