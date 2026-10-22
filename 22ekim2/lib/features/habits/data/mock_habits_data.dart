import '../../reflection/models/mood_entry.dart';
import '../models/habit.dart';
import '../../home/models/habit_completion.dart';

/// Pre-populated mock habit and completion records for rich demonstration
class MockHabitsData {
  const MockHabitsData._();

  static List<Habit> get initialHabits {
    final now = DateTime.now();
    return [
      Habit(
        id: 'h_water',
        title: 'Günlük 2 Litre Su İç 💧',
        description: 'Vücudunu canlı ve enerjik tutmak için düzenli su tüket.',
        repeatDays: const [1, 2, 3, 4, 5, 6, 7], // Every day
        reminderTime: '08:30',
        colorIndex: 0, // Sky Blue
        createdAt: now.subtract(const Duration(days: 30)),
      ),
      Habit(
        id: 'h_book',
        title: '20 Sayfa Kitap Oku 📖',
        description: 'Yeni ufuklar keşfetmek için sakin bir okuma seansı.',
        repeatDays: const [1, 2, 3, 4, 5, 6, 7], // Every day
        reminderTime: '21:00',
        colorIndex: 4, // Purple
        createdAt: now.subtract(const Duration(days: 25)),
      ),
      Habit(
        id: 'h_walk',
        title: '30 Dakika Yürüyüş & Temiz Hava 🏃',
        description: 'Zihnini boşalt, penguen gibi adımlarını sıklaştır.',
        repeatDays: const [1, 3, 5, 6], // Mon, Wed, Fri, Sat
        reminderTime: '18:00',
        colorIndex: 1, // Mint Green
        createdAt: now.subtract(const Duration(days: 20)),
      ),
      Habit(
        id: 'h_meditation',
        title: 'Sabah Meditasyonu & Nefes 🧘',
        description: 'Dingin bir gün başlangıcı için 10 dakika nefes egzersizi.',
        repeatDays: const [1, 2, 3, 4, 5], // Weekdays
        reminderTime: '07:30',
        colorIndex: 3, // Coral Pink
        createdAt: now.subtract(const Duration(days: 15)),
      ),
      Habit(
        id: 'h_code',
        title: 'Temiz Kod Pratiği 💻',
        description: 'Mimariye sadık kalarak bir modülü gözden geçir ve geliştir.',
        repeatDays: const [1, 2, 3, 4, 5, 6], // Mon-Sat
        reminderTime: '14:00',
        colorIndex: 5, // Indigo
        createdAt: now.subtract(const Duration(days: 18)),
      ),
    ];
  }

  static List<HabitCompletion> initialCompletions(DateTime referenceToday) {
    final completions = <HabitCompletion>[];

    // Simulate completion history for water (last 7 days to form a streak!)
    for (int i = 1; i <= 7; i++) {
      final date = referenceToday.subtract(Duration(days: i));
      completions.add(
        HabitCompletion(
          id: 'c_water_$i',
          habitId: 'h_water',
          date: DateTime(date.year, date.month, date.day),
          completedAt: date.add(const Duration(hours: 19)),
          moodEntry: MoodEntry(
            mood: i % 2 == 0 ? Mood.awesome : Mood.happy,
            note: 'Harika hissettirdi, penguen gibi hafifledim! (Gün -$i)',
            recordedAt: date.add(const Duration(hours: 19)),
          ),
        ),
      );
    }

    // Book reading completions (days 1, 2, 3, 5, 6)
    for (final dayOffset in [1, 2, 3, 5, 6]) {
      final date = referenceToday.subtract(Duration(days: dayOffset));
      completions.add(
        HabitCompletion(
          id: 'c_book_$dayOffset',
          habitId: 'h_book',
          date: DateTime(date.year, date.month, date.day),
          completedAt: date.add(const Duration(hours: 21, minutes: 30)),
          moodEntry: MoodEntry(
            mood: Mood.calm,
            note: 'Çok huzurlu bir bölümdü. Zihnim dinlendi.',
            recordedAt: date.add(const Duration(hours: 21, minutes: 30)),
          ),
        ),
      );
    }

    // Meditation completions (days 1, 2, 4)
    for (final dayOffset in [1, 2, 4]) {
      final date = referenceToday.subtract(Duration(days: dayOffset));
      completions.add(
        HabitCompletion(
          id: 'c_med_$dayOffset',
          habitId: 'h_meditation',
          date: DateTime(date.year, date.month, date.day),
          completedAt: date.add(const Duration(hours: 8)),
          moodEntry: MoodEntry(
            mood: Mood.happy,
            note: 'Güne dingince başladım.',
            recordedAt: date.add(const Duration(hours: 8)),
          ),
        ),
      );
    }

    return completions;
  }
}
