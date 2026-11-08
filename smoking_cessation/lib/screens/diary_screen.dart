// ========================================
// DOSYA: diary_screen.dart
// NE İŞE YARAR: Günlük takip, takvim ve streak
// zincirini görüntüler.
// NASIL ÇALIŞIR: DiaryController durumunu
// dinler ve takvim günlerini yönetir.
// SOLID: SRP - Sadece günlük ana ekranı.
// ========================================

import 'package:flutter/material.dart';
import '../features/diary/diary_controller.dart';
import '../main.dart';
import '../models/daily_log.dart';
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
    final diaryCtrl = AppScope.of(context).diaryController;

    return ListenableBuilder(
      listenable: diaryCtrl,
      builder: (context, _) => ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildStreakCard(diaryCtrl.currentStreak),
          const SizedBox(height: 16),
          _buildQuickCheckIn(diaryCtrl),
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
        ],
      ),
    );
  }

  Widget _buildStreakCard(int streak) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.outline),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: AppTheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.bolt_rounded,
                color: AppTheme.primary, size: 28),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$streak GÜN TEMİZ ZİNCİR',
                  style: AppTheme.headlineMedium.copyWith(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(height: 2),
              const Text('Zinciri kırma, devam et!',
                  style: AppTheme.bodySmall),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickCheckIn(DiaryController diaryCtrl) {
    final todayKey = DateKey.format(DateTime.now());
    final todayLog = diaryCtrl.getLog(todayKey);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.outlineActive),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('BUGÜN İÇTİN Mİ?', style: AppTheme.labelCaps),
                const SizedBox(height: 4),
                Text(
                  todayLog == null
                      ? 'Henüz durum kaydedilmedi'
                      : (todayLog.smokeFree
                          ? 'Bugün temiz işaretlendi'
                          : 'Bugün içildi olarak girildi'),
                  style: AppTheme.bodyMedium,
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: todayLog?.smokeFree == true
                  ? AppTheme.primaryContainer
                  : AppTheme.primary,
              foregroundColor: todayLog?.smokeFree == true
                  ? AppTheme.primary
                  : AppTheme.surfaceLowest,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            icon: const Icon(Icons.check_rounded, size: 18),
            label: const Text('Bugün İçmedim'),
            onPressed: () => diaryCtrl.setSmokeFreeToday(true),
          ),
        ],
      ),
    );
  }
}
