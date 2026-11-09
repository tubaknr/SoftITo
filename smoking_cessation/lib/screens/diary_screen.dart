// ========================================
// DOSYA: diary_screen.dart
// NE İŞE YARAR: Günlük bırakma günlüğü,
// takvim ve zincir takibini görüntüler.
// NASIL ÇALIŞIR: DiaryController durumunu
// dinler, kayıt formu ve takvimi sunar.
// SOLID: SRP - Sadece günlük ana ekranı.
// ========================================

import 'package:flutter/material.dart';
import '../features/diary/diary_controller.dart';
import '../main.dart';
import '../theme/app_theme.dart';
import '../widgets/diary_calendar.dart';
import 'diary_entry_screen.dart';

// SRP: Günlük takvim ve streak ekranı.
class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  DateTime _currentMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  );

  void _onDaySelected(DateTime date, DiaryController controller) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DiaryEntryScreen(
          diaryController: controller,
          date: date,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appScope = AppScope.of(context);
    final diaryCtrl = appScope.diaryController;
    final quitCtrl = appScope.quitController;

    return ListenableBuilder(
      listenable: diaryCtrl,
      builder: (context, _) => ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        children: _buildContent(
          diaryCtrl,
          diaryCtrl.currentStreak,
          quitCtrl.elapsedDuration.inDays,
        ),
      ),
    );
  }

  // Sayfa içerik listesini oluşturur.
  List<Widget> _buildContent(
    DiaryController diaryCtrl,
    int streak,
    int days,
  ) {
    return [
      _buildTopHeader(days),
      const SizedBox(height: 16),
      DiaryCheckInCard(diaryCtrl: diaryCtrl),
      const SizedBox(height: 16),
      DiaryCalendar(
        currentMonth: _currentMonth,
        logs: diaryCtrl.logs,
        onDayTapped: (d) => _onDaySelected(d, diaryCtrl),
        onPreviousMonth: () => setState(() {
          _currentMonth = DateTime(
            _currentMonth.year,
            _currentMonth.month - 1,
            1,
          );
        }),
        onNextMonth: () => setState(() {
          _currentMonth = DateTime(
            _currentMonth.year,
            _currentMonth.month + 1,
            1,
          );
        }),
      ),
      const SizedBox(height: 16),
      DiaryStatCards(streak: streak),
    ];
  }

  // Üst gün sayısı ve ay başlık bloğu.
  Widget _buildTopHeader(int days) {
    const monthNames = [
      'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
    ];
    final now = DateTime.now();
    final monthStr = '${monthNames[now.month - 1]} ${now.year}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'GÜN $days • TEMİZ CİĞERLER',
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.bold,
                color: AppTheme.primary,
                letterSpacing: 0.6,
              ),
            ),
            Text(
              monthStr,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          'Günlük Bırakma Günlüğü',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
