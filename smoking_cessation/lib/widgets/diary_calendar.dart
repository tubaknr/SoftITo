// ========================================
// DOSYA: diary_calendar.dart
// NE İŞE YARAR: Takvim, günlük kayıt kartı
// ve seri istatistik bloklarını sunar.
// NASIL ÇALIŞIR: Gün, durum, kriz seviyesi ve
// not bilgilerini interaktif olarak yönetir.
// SOLID: SRP - Günlük ekranı görsel bileşenleri.
// ========================================

import 'package:flutter/material.dart';
import '../features/diary/diary_controller.dart';
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
    'PT', 'SA', 'ÇA', 'PE', 'CU', 'CT', 'PZ'
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
        color: const Color(0xFF131D26),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0x1FFFFFFF)),
      ),
      child: Column(
        children: [
          _buildMonthHeader(),
          const SizedBox(height: 14),
          _buildWeekdayHeader(),
          const SizedBox(height: 8),
          _buildDaysGrid(),
          const SizedBox(height: 14),
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildMonthHeader() {
    final title = '${_months[currentMonth.month - 1]} ${currentMonth.year}';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: const [
            Icon(
              Icons.calendar_month_rounded,
              color: AppTheme.secondaryCyan,
              size: 20,
            ),
            SizedBox(width: 8),
            Text(
              'Takvim & Zincir Takibi',
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.chevron_left_rounded,
                size: 20,
                color: Colors.white70,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: onPreviousMonth,
            ),
            const SizedBox(width: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 4),
            IconButton(
              icon: const Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: Colors.white70,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: onNextMonth,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeekdayHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: _weekdays.map((w) {
        return Expanded(
          child: Center(
            child: Text(
              w,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFF94A3B8),
              ),
            ),
          ),
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
          padding: const EdgeInsets.symmetric(vertical: 3.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (colIndex) {
              final cellIndex = (rowIndex * 7) + colIndex;
              final dayNum = cellIndex - leadingBlanks + 1;

              if (dayNum < 1 || dayNum > daysInMonth) {
                return const Expanded(child: SizedBox(height: 38));
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

    Color dotColor = Colors.transparent;
    bool hasDot = false;

    if (log != null) {
      hasDot = true;
      if (!log.smokeFree) {
        dotColor = const Color(0xFFF87171); // Kriz Yaşandı
      } else if ((log.cravingLevel ?? 1) >= 3) {
        dotColor = const Color(0xFFFBBF24); // Zorlanılan Gün
      } else {
        dotColor = const Color(0xFF34D399); // Temiz / Başarılı
      }
    }

    return GestureDetector(
      onTap: isFuture ? null : () => onDayTapped(cellDate),
      child: Center(
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFF0F171F),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isToday
                  ? AppTheme.primary
                  : const Color(0x14FFFFFF),
              width: isToday ? 1.5 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${cellDate.day}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isFuture
                      ? const Color(0x33FFFFFF)
                      : Colors.white,
                ),
              ),
              if (hasDot) ...[
                const SizedBox(height: 2),
                DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: dotColor,
                  ),
                  child: const SizedBox(width: 4, height: 4),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildLegendItem('Temiz / Başarılı', const Color(0xFF34D399)),
        _buildLegendItem('Zorlanılan Gün', const Color(0xFFFBBF24)),
        _buildLegendItem('Kriz Yaşandı', const Color(0xFFF87171)),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
          child: const SizedBox(width: 6, height: 6),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF94A3B8),
          ),
        ),
      ],
    );
  }
}

// SRP: Günlük durum hızlı kayıt kartı.
class DiaryCheckInCard extends StatefulWidget {
  final DiaryController diaryCtrl;

  const DiaryCheckInCard({super.key, required this.diaryCtrl});

  @override
  State<DiaryCheckInCard> createState() => _DiaryCheckInCardState();
}

class _DiaryCheckInCardState extends State<DiaryCheckInCard> {
  int _cravingLevel = 1;
  late final TextEditingController _noteCtrl;

  @override
  void initState() {
    super.initState();
    final todayKey = DateKey.format(DateTime.now());
    final existing = widget.diaryCtrl.getLog(todayKey);
    _cravingLevel = existing?.cravingLevel ?? 1;
    _noteCtrl = TextEditingController(text: existing?.note ?? '');
  }

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  String _getLevelText(int level) {
    switch (level) {
      case 1:
        return '1: Rahat Seviye';
      case 2:
        return '2: Hafif Seviye';
      case 3:
        return '3: Orta Seviye';
      case 4:
        return '4: Zor Seviye';
      case 5:
        return '5: Şiddetli Kriz';
      default:
        return '$level: Normal';
    }
  }

  void _onSave() {
    final todayKey = DateKey.format(DateTime.now());
    final existing = widget.diaryCtrl.getLog(todayKey);
    final updated =
        (existing ?? DailyLog(date: todayKey, smokeFree: true)).copyWith(
      cravingLevel: _cravingLevel,
      note: _noteCtrl.text,
    );
    widget.diaryCtrl.saveLog(updated);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Günlük kaydınız başarıyla güncellendi!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF131D26),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0x1FFFFFFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderRow(),
          const SizedBox(height: 12),
          _buildSmokeFreeButton(),
          const SizedBox(height: 16),
          _buildCravingSection(),
          const SizedBox(height: 14),
          _buildNoteSection(),
          const SizedBox(height: 14),
          _buildSaveButton(),
        ],
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: const [
            Icon(
              Icons.edit_note_rounded,
              color: AppTheme.primary,
              size: 20,
            ),
            SizedBox(width: 8),
            Text(
              'Bugün sigara içtin mi?',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 3,
          ),
          decoration: BoxDecoration(
            color: const Color(0x1AFFFFFF),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Text(
            'Bugün',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF94A3B8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSmokeFreeButton() {
    final todayKey = DateKey.format(DateTime.now());
    final log = widget.diaryCtrl.getLog(todayKey);
    final isClean = log?.smokeFree ?? true;

    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isClean
              ? const Color(0xFF34D399)
              : const Color(0xFFF87171),
          foregroundColor: const Color(0xFF022C22),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        onPressed: () {
          widget.diaryCtrl.setSmokeFreeToday(!isClean);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isClean
                  ? Icons.verified_rounded
                  : Icons.cancel_rounded,
              color: const Color(0xFF022C22),
              size: 24,
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isClean ? 'Bugün İçmedim' : 'Bugün İçildi',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF022C22),
                  ),
                ),
                Text(
                  isClean ? '(Temizim)' : '(Kayıt Alındı)',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF065F46),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCravingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'ÇEKİM / KRİZ YOĞUNLUĞU',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFF94A3B8),
                letterSpacing: 0.5,
              ),
            ),
            Text(
              _getLevelText(_cravingLevel),
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.bold,
                color: AppTheme.secondaryCyan,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(5, (index) {
            final level = index + 1;
            final isSelected = _cravingLevel == level;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _cravingLevel = level),
                child: Container(
                  margin: EdgeInsets.only(right: index < 4 ? 6 : 0),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F171F),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.primary
                          : const Color(0x1AFFFFFF),
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.local_fire_department_rounded,
                        size: 18,
                        color: isSelected
                            ? AppTheme.primary
                            : const Color(0xFF94A3B8),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '$level',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? AppTheme.primary
                              : const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildNoteSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'KISA NOT EKLE',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Color(0xFF94A3B8),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _noteCtrl,
          maxLines: 2,
          style: const TextStyle(fontSize: 13, color: Colors.white),
          decoration: InputDecoration(
            hintText:
                'Akşam kahvesi sonrası zorlandım ama nefes '
                'egzersizi yaptım...',
            hintStyle: const TextStyle(
              fontSize: 12.5,
              color: Color(0xFF64748B),
            ),
            filled: true,
            fillColor: const Color(0xFF0F171F),
            contentPadding: const EdgeInsets.all(12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0x1FFFFFFF)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0x1FFFFFFF)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.primary),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          backgroundColor: const Color(0xFF1E293B),
          foregroundColor: Colors.white,
          side: const BorderSide(color: Color(0x33FFFFFF)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        icon: const Icon(Icons.archive_outlined, size: 18),
        label: const Text(
          'Kaydet',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        onPressed: _onSave,
      ),
    );
  }
}

// SRP: Seri ve tetikleyici ikili alt kartı.
class DiaryStatCards extends StatelessWidget {
  final int streak;

  const DiaryStatCards({super.key, required this.streak});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildStreakCard()),
        const SizedBox(width: 12),
        Expanded(child: _buildTriggerCard()),
      ],
    );
  }

  Widget _buildStreakCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF131D26),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x1FFFFFFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'MEVCUT SERİ',
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF94A3B8),
                  letterSpacing: 0.5,
                ),
              ),
              Icon(
                Icons.bolt_rounded,
                color: AppTheme.primary,
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$streak',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'Gün',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.secondaryCyan,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          const Text(
            'Kesintisiz Temiz',
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTriggerCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF131D26),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x1FFFFFFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'EN ÇOK TETİKLEYEN',
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF94A3B8),
                  letterSpacing: 0.5,
                ),
              ),
              Icon(
                Icons.access_time_rounded,
                color: AppTheme.secondaryCyan,
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Akşam Saatleri',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            '20:00 - 22:30 arası',
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }
}
