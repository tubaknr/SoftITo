import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../habits/models/habit.dart';
import '../models/habit_completion.dart';

/// Tactile habit card adhering to Stitch design system specs
class HabitCardItem extends StatelessWidget {
  const HabitCardItem({
    super.key,
    required this.habit,
    required this.isCompleted,
    required this.streak,
    this.completion,
    required this.onToggle,
    required this.onTapCard,
  });

  final Habit habit;
  final bool isCompleted;
  final int streak;
  final HabitCompletion? completion;
  final VoidCallback onToggle;
  final VoidCallback onTapCard;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final habitColor = AppColors.getHabitColor(habit.colorIndex);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isCompleted
              ? const Color(0xFF34D399).withValues(alpha: 0.45)
              : colors.borderLight.withValues(alpha: 0.7),
          width: isCompleted ? 1.4 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isCompleted
                ? const Color(0xFF34D399).withValues(alpha: 0.10)
                : const Color(0xFF1E3A8A).withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTapCard,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                _buildCategoryBadge(habitColor),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDetails(context, colors),
                ),
                const SizedBox(width: 10),
                _buildTickButton(colors),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryBadge(Color habitColor) {
    final emoji = _detectCategoryEmoji(habit.title);

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: habitColor.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          emoji,
          style: const TextStyle(fontSize: 22),
        ),
      ),
    );
  }

  String _detectCategoryEmoji(String title) {
    final lower = title.toLowerCase();
    if (lower.contains('su') || lower.contains('water') || lower.contains('sıvı')) {
      return '💧';
    }
    if (lower.contains('kitap') || lower.contains('oku') || lower.contains('book')) {
      return '📖';
    }
    if (lower.contains('yürü') || lower.contains('koş') || lower.contains('spor') || lower.contains('walk')) {
      return '🏃';
    }
    if (lower.contains('meditasyon') || lower.contains('nefes') || lower.contains('yoga')) {
      return '🧘';
    }
    if (lower.contains('yaz') || lower.contains('günlük') || lower.contains('not') || lower.contains('journal')) {
      return '✍️';
    }
    if (lower.contains('kod') || lower.contains('yazılım') || lower.contains('çalış') || lower.contains('code')) {
      return '💻';
    }
    return '🌱';
  }

  Widget _buildDetails(BuildContext context, dynamic colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          habit.displayTitle(context.loc.isTr),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.typography.titleMedium?.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: isCompleted
                ? colors.textDisabled
                : colors.textMain,
            decoration: isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        const SizedBox(height: 3),
        Row(
          children: [
            if (streak > 0) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  context.loc.streakDays(streak),
                  style: const TextStyle(
                    color: Color(0xFFD97706),
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '•',
                style: TextStyle(color: colors.textDisabled, fontSize: 11),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              habit.isEveryday ? context.loc.frequencyDaily : context.loc.frequencyCustom,
              style: context.typography.bodySmall?.copyWith(
                color: colors.textMuted,
                fontSize: 12,
              ),
            ),
            if (completion?.moodEntry != null) ...[
              const SizedBox(width: 6),
              Text(
                completion!.moodEntry!.mood.emoji,
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildTickButton(dynamic colors) {
    return GestureDetector(
      onTap: onToggle,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: isCompleted
              ? const LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [Color(0xFF00855B), Color(0xFF34D399)],
                )
              : null,
          color: isCompleted ? null : Colors.transparent,
          border: isCompleted
              ? null
              : Border.all(
                  color: const Color(0xFF93C5FD),
                  width: 2.0,
                ),
          boxShadow: isCompleted
              ? [
                  BoxShadow(
                    color: const Color(0xFF34D399).withValues(alpha: 0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Icon(
            Icons.check_rounded,
            size: isCompleted ? 24 : 20,
            color: isCompleted ? Colors.white : const Color(0xFF93C5FD),
          ),
        ),
      ),
    );
  }
}
