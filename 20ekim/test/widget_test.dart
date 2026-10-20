import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yorunge/main.dart';

void main() {
  testWidgets('Yörünge app smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const YorungeApp());
    await tester.pumpAndSettle();

    expect(find.text('Yörünge'), findsWidgets);
    expect(find.text('Mentor'), findsWidgets);
    expect(find.text('Yatırımcılar'), findsWidgets);
    expect(find.text('Programlar'), findsWidgets);
    expect(find.text('Topluluk'), findsWidgets);
  });
}
