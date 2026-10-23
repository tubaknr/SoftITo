import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/confetti_overlay.dart';
import '../../habits/controller/habits_controller.dart';
import '../../habits/models/habit.dart';
import '../../habits/view/habits_list_page.dart';
import '../../habits/widget/habit_form_sheet.dart';
import '../../reflection/widget/reflection_bottom_sheet.dart';
import '../models/habit_completion.dart';
import '../widget/empty_habits_view.dart';
import '../widget/habit_card_item.dart';
import '../widget/hero_motivational_banner.dart';

/// Main Home tab screen displaying today's scheduled habits and Bento progress
class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.controller});

  final HabitsController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: controller.celebrationTrigger,
      builder: (context, triggerCount, _) {
        return ConfettiOverlay(
          triggerCount: triggerCount,
          child: _HomeHabitScrollBody(controller: controller),
        );
      },
    );
  }
}

class _HomeHabitScrollBody extends StatelessWidget {
  const _HomeHabitScrollBody({required this.controller});

  final HabitsController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([controller.habits, controller.completions]),
      builder: (context, _) {
        final today = controller.dateTimeService.today();
        final todayHabits = controller.habitsForDate(today);
        final completedCount =
            todayHabits.where((h) => controller.isCompleted(h.id, today)).length;
        final maxStreak = todayHabits.fold<int>(0, (max, h) {
          final s = controller.getStreak(h.id);
          return s > max ? s : max;
        });

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: HeroMotivationalBanner(
                completedCount: completedCount,
                totalCount: todayHabits.length,
                activeStreak: maxStreak,
              ),
            ),
            SliverToBoxAdapter(
              child: _HomeHabitsHeader(controller: controller),
            ),
            if (todayHabits.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: EmptyHabitsView(
                  onAddHabit: () {
                    HabitFormSheet.show(
                      context,
                      onSave: (habit) => controller.saveHabit(habit),
                    );
                  },
                ),
              )
            else ...[
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final habit = todayHabits[index];
                      final isDone = controller.isCompleted(habit.id, today);
                      final completion = controller.getCompletion(habit.id, today);
                      final streak = controller.getStreak(habit.id);

                      return HabitCardItem(
                        habit: habit,
                        isCompleted: isDone,
                        streak: streak,
                        completion: completion,
                        onToggle: () => _handleToggle(
                            context, habit, isDone, completion, today),
                        onTapCard: () =>
                            _handleTapCard(context, habit, completion, today),
                      );
                    },
                    childCount: todayHabits.length,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 110),
                  child: _QuickReflectionCard(
                    onTap: () {
                      final firstDone = todayHabits.firstWhere(
                        (h) => controller.isCompleted(h.id, today),
                        orElse: () => todayHabits.first,
                      );
                      ReflectionBottomSheet.show(
                        context,
                        habitTitle: firstDone.displayTitle(context.loc.isTr),
                        onSave: (mood, note) {
                          controller.saveMoodAndNote(
                              firstDone.id, today, mood, note);
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Future<void> _handleToggle(
    BuildContext context,
    Habit habit,
    bool isDone,
    HabitCompletion? completion,
    DateTime today,
  ) async {
    if (isDone) {
      if (completion?.moodEntry != null) {
        final confirm = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(context.loc.tabHome),
            content: Text(context.loc.confirmUndoWithNote),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: Text(context.loc.cancelAction),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: Text(context.loc.deleteAction),
              ),
            ],
          ),
        );
        if (confirm != true) return;
      }
      await controller.toggleHabit(habit.id, today);
    } else {
      final comp = await controller.toggleHabit(habit.id, today);
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.loc.completedHabitToast),
          backgroundColor: context.colors.success,
          duration: const Duration(seconds: 2),
        ),
      );

      if (comp != null) {
        await ReflectionBottomSheet.show(
          context,
          habitTitle: habit.displayTitle(context.loc.isTr),
          onSave: (mood, note) {
            controller.saveMoodAndNote(habit.id, today, mood, note);
          },
        );
      }
    }
  }

  void _handleTapCard(
    BuildContext context,
    Habit habit,
    HabitCompletion? completion,
    DateTime today,
  ) {
    ReflectionBottomSheet.show(
      context,
      habitTitle: habit.displayTitle(context.loc.isTr),
      initialMood: completion?.moodEntry?.mood,
      initialNote: completion?.moodEntry?.note,
      onSave: (mood, note) {
        controller.saveMoodAndNote(habit.id, today, mood, note);
      },
    );
  }
}

class _HomeHabitsHeader extends StatelessWidget {
  const _HomeHabitsHeader({required this.controller});

  final HabitsController controller;

  @override
  Widget build(BuildContext context) {
    final today = controller.dateTimeService.today();
    final localeName = Localizations.localeOf(context).languageCode;
    final dateFormatted = DateFormat('EEEE, d MMMM', localeName).format(today);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.loc.todayHabits,
                style: context.typography.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: context.colors.textMain,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                dateFormatted,
                style: context.typography.bodySmall?.copyWith(
                  color: context.colors.textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Row(
            children: [
              _buildAddHabitPill(context),
              const SizedBox(width: 4),
              _buildAllHabitsButton(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddHabitPill(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HabitFormSheet.show(
            context,
            onSave: (habit) => controller.saveHabit(habit),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFD8E2FF),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.add_rounded, size: 16, color: Color(0xFF001A42)),
              const SizedBox(width: 3),
              Text(
                context.loc.newAction,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF001A42),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAllHabitsButton(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => HabitsListPage(controller: controller),
          ),
        );
      },
      child: Text(
        context.loc.allHabits,
        style: context.typography.labelLarge?.copyWith(
          color: context.colors.textLink,
          fontSize: 12,
          decoration: TextDecoration.none,
        ),
      ),
    );
  }
}

class _QuickReflectionCard extends StatelessWidget {
  const _QuickReflectionCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerUp: (_) => onTap(),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFEDE9FE), Color(0xFFE0F2FE)],
          ),
          border: Border.all(
            color: const Color(0xFFC7D2FE).withValues(alpha: 0.6),
          ),
        ),
        child: Row(
          children: [
            const Text('💭', style: TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.loc.addAwarenessNote,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                      color: Color(0xFF1E1B4B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    context.loc.awarenessNoteSub,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF4338CA),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_upward_rounded,
              color: Color(0xFF4338CA),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
