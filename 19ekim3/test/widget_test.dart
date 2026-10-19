import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_tracker/main.dart';

void main() {
  testWidgets('FitLife Pro smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FitnessTrackerApp());
    expect(find.text('FitLife Pro'), findsOneWidget);
  });
}
