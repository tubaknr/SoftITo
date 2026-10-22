import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:penguhabit/core/l10n/app_localizations.dart';
import 'package:penguhabit/core/services/date_time_service.dart';
import 'package:penguhabit/core/services/local_store.dart';
import 'package:penguhabit/core/theme/app_theme.dart';
import 'package:penguhabit/features/calendar/view/calendar_page.dart';
import 'package:penguhabit/features/habits/controller/habits_controller.dart';
import 'package:penguhabit/features/habits/data/habits_repository.dart';
import 'package:penguhabit/features/habits/models/habit.dart';
import 'package:penguhabit/features/home/view/home_page.dart';
import 'package:penguhabit/features/home/widget/empty_habits_view.dart';
import 'package:penguhabit/features/home/widget/habit_card_item.dart';
import 'package:penguhabit/features/reflection/models/mood_entry.dart';
import 'package:penguhabit/features/reflection/widget/reflection_bottom_sheet.dart';

Widget _buildTestApp(Widget child) {
  return MaterialApp(
    theme: AppTheme.lightTheme,
    locale: const Locale('tr'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    home: Scaffold(body: child),
  );
}

void main() {
  group('Widget Tests — PenguHabit Critical Flows', () {
    testWidgets('Empty state displays curious mascot and add button when no habits', (tester) async {
      final mockStore = MockLocalStore();
      final mockDate = MockDateTimeService(DateTime(2026, 10, 22));
      final repo = LocalHabitsRepository(
        localStore: mockStore,
        dateTimeService: mockDate,
      );
      final controller = HabitsController(
        repository: repo,
        dateTimeService: mockDate,
      );

      // Explicitly set empty habits list
      controller.habits.value = [];

      await tester.pumpWidget(_buildTestApp(HomePage(controller: controller)));
      await tester.pumpAndSettle();

      expect(find.byType(EmptyHabitsView), findsOneWidget);
      expect(find.text('Hiç alışkanlık eklememişsin!'), findsOneWidget);
      expect(find.text('Hemen İlk Alışkanlığını Ekle'), findsOneWidget);
    });

    testWidgets('Habit completion toggles status and triggers celebration feedback', (tester) async {
      final mockStore = MockLocalStore();
      final mockDate = MockDateTimeService(DateTime(2026, 10, 22)); // Thursday
      final repo = LocalHabitsRepository(
        localStore: mockStore,
        dateTimeService: mockDate,
      );
      final controller = HabitsController(
        repository: repo,
        dateTimeService: mockDate,
      );

      final habit = Habit(
        id: 'test_habit_1',
        title: 'Günde 2 Litre Su İç 💧',
        repeatDays: const [1, 2, 3, 4, 5, 6, 7],
        createdAt: mockDate.now(),
      );

      controller.habits.value = [habit];
      controller.completions.value = [];

      await tester.pumpWidget(_buildTestApp(HomePage(controller: controller)));
      await tester.pumpAndSettle();

      expect(find.byType(HabitCardItem), findsOneWidget);
      expect(find.text('Günde 2 Litre Su İç 💧'), findsOneWidget);

      // Tap the checkbox to complete habit
      final checkboxFinder = find.byType(GestureDetector).last;
      await tester.tap(checkboxFinder);
      await tester.pumpAndSettle();

      // Verify completion state updated
      expect(controller.isCompleted(habit.id, mockDate.today()), isTrue);
      // Reflection modal should open
      expect(find.byType(ReflectionBottomSheet), findsOneWidget);
      expect(find.text('Bu alışkanlığı tamamlayınca nasıl hissettim?'), findsOneWidget);

      // Tap Skip on reflection modal
      await tester.tap(find.text('Atla'));
      await tester.pumpAndSettle();

      expect(find.byType(ReflectionBottomSheet), findsNothing);
    });

    testWidgets('Reflection sheet allows selecting emotion emoji and entering note', (tester) async {
      Mood? savedMood;
      String? savedNote;

      await tester.pumpWidget(
        _buildTestApp(
          ReflectionBottomSheet(
            habitTitle: 'Kitap Oku 📖',
            onSave: (mood, note) {
              savedMood = mood;
              savedNote = note;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Bu alışkanlığı tamamlayınca nasıl hissettim?'), findsOneWidget);
      expect(find.text('Kitap Oku 📖'), findsOneWidget);

      // Select 'Harika' emoji
      await tester.tap(find.text('🤩'));
      await tester.pump();

      // Enter awareness note
      await tester.enterText(
        find.byType(TextField),
        'Penguen gibi tırmanıyorum!',
      );
      await tester.pump();

      // Tap Save
      await tester.tap(find.text('Notu Alışkanlığa Ekle'));
      await tester.pumpAndSettle();

      expect(savedMood, equals(Mood.awesome));
      expect(savedNote, equals('Penguen gibi tırmanıyorum!'));
    });

    testWidgets('Calendar page displays habit names inside day cells', (tester) async {
      final mockStore = MockLocalStore();
      final mockDate = MockDateTimeService(DateTime(2026, 10, 22));
      final repo = LocalHabitsRepository(
        localStore: mockStore,
        dateTimeService: mockDate,
      );
      final controller = HabitsController(
        repository: repo,
        dateTimeService: mockDate,
      );

      final habit = Habit(
        id: 'cal_habit_test',
        title: 'Su İç 💧',
        repeatDays: const [1, 2, 3, 4, 5, 6, 7],
        createdAt: mockDate.now(),
      );

      controller.habits.value = [habit];
      controller.completions.value = [];

      await tester.pumpWidget(_buildTestApp(CalendarPage(controller: controller)));
      await tester.pumpAndSettle();

      expect(find.byType(CalendarPage), findsOneWidget);
      expect(find.textContaining('Su İç 💧'), findsWidgets);
    });
  });
}
