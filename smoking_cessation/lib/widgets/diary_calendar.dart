// ========================================
// DOSYA: diary_calendar.dart
// NE İŞE YARAR: Özel el yazımı aylık takvim
// görünümünü sunar.
// NASIL ÇALIŞIR: Tarih matematiği ile günleri
// 7 sütunlu ızgarada yeşil/kırmızı renklendirir.
// SOLID: SRP - Sadece takvim ızgarasını çizer.
// ========================================

import 'package:flutter/material.dart';
import '../models/daily_log.dart';
import '../theme/app_theme.dart';

// SRP: Paket bağımlılığı olmayan aylık takvim.
class DiaryCalendar extends StatelessWidget {
  final DateTime currentMonth;
  final Map<String, DailyLog> logs;
  final ValueChanged<DateTime> onDayTapped;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;

  const DiaryCalendar({
    super.key,
    required this.currentMonth,
    required this.logs,
    required this.onDayTapped,
    required this.onPreviousMonth,
    required this.onNextMonth,
  });

  static const List<String> _weekdays = [
    'Pt', 'Sa', 'Ça', 'Pe', 'Cu', 'Ct', 'Pz'
  ];

  static const List<String> _months = [
    'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
    'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.outline),
      ),
      child: Column(
        children: [
          _buildMonthHeader(),
          const SizedBox(height: 12),
          _buildWeekdayHeader(),
          const SizedBox(height: 8),
          _buildDaysGrid(),
        ],
      ),
    );
  }

  Widget _buildMonthHeader() {
    final title = '${_months[currentMonth.month - 1]} ${currentMonth.year}';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left_rounded),
          onPressed: onPreviousMonth,
        ),
        Text(title, style: AppTheme.titleSmall),
        IconButton(
          icon: const Icon(Icons.chevron_right_rounded),
          onPressed: onNextMonth,
        ),
      ],
    );
  }

  Widget _buildWeekdayHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: _weekdays.map((w) {
        return Expanded(
          child: Center(child: Text(w, style: AppTheme.labelCaps)),
        );
      }).toList(),
    );
  }

  Widget _buildDaysGrid() {
    final year = currentMonth.year;
    final month = currentMonth.month;
    final firstDay = DateTime(year, month, 1);
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final leadingBlanks = firstDay.weekday - 1;

    final totalCells = leadingBlanks + daysInMonth;
    final rowCount = (totalCells / 7).ceil();

    return Column(
      children: List.generate(rowCount, (rowIndex) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (colIndex) {
              final cellIndex = (rowIndex * 7) + colIndex;
              final dayNum = cellIndex - leadingBlanks + 1;

              if (dayNum < 1 || dayNum > daysInMonth) {
                return const Expanded(child: SizedBox(height: 36));
              }

              final cellDate = DateTime(year, month, dayNum);
              return Expanded(child: _buildDayCell(cellDate));
            }),
          ),
        );
      }),
    );
  }

  Widget _buildDayCell(DateTime cellDate) {
    final dateKey = DateKey.format(cellDate);
    final isFuture = DateKey.isFuture(cellDate);
    final isToday = DateKey.isToday(dateKey);
    final log = logs[dateKey];

    Color bgColor = Colors.transparent;
    Color textColor = AppTheme.onSurface;
    Border? border;

    if (isToday) {
      border = Border.all(color: AppTheme.primaryBright, width: 1.5);
    }

    if (log != null) {
      if (log.smokeFree) {
        bgColor = AppTheme.primaryContainer;
        textColor = AppTheme.primary;
      } else {
        bgColor = AppTheme.dangerSosGlow;
        textColor = AppTheme.dangerSos;
      }
    } else if (isFuture) {
      textColor = AppTheme.onSurfaceMuted;
    }

    return GestureDetector(
      onTap: isFuture ? null : () => onDayTapped(cellDate),
      child: Center(
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
            border: border,
          ),
          child: Center(
            child: Text(
              '${cellDate.day}',
              style: TextStyle(
                fontSize: 13,
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
