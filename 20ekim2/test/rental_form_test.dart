import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kiralago/core/controllers/session_controller.dart';
import 'package:kiralago/core/theme/app_theme.dart';
import 'package:kiralago/features/reservation/view/rental_form_page.dart';
import 'package:kiralago/features/vehicle_list/data/mock_vehicle_data.dart';
import 'package:kiralago/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  testWidgets('RentalFormPage opens without layout exceptions', (WidgetTester tester) async {
    final SessionController sessionController = SessionController();
    await sessionController.login(
      role: UserRole.renter,
      userId: 'renter_1',
      displayName: 'Ahmet Y.',
      email: 'ahmet@kiralago.com',
      rememberMe: false,
    );

    final DateTime now = DateTime.now();
    final DateTimeRange range = DateTimeRange(
      start: now.add(const Duration(days: 2)),
      end: now.add(const Duration(days: 5)),
    );

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
        home: RentalFormPage(
          vehicle: MockVehicleData.vehicles.first,
          selectedRange: range,
          sessionController: sessionController,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Kiralama ve Teslim Sözleşmesi'), findsOneWidget);
    expect(find.byType(RentalFormPage), findsOneWidget);
  });
}
