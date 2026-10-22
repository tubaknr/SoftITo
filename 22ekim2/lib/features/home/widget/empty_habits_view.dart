import 'package:flutter/material.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/penguin_mascot_painter.dart';

/// Empty state widget displayed when no habits exist
class EmptyHabitsView extends StatelessWidget {
  const EmptyHabitsView({super.key, required this.onAddHabit});

  final VoidCallback onAddHabit;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const PenguinMascotWidget(
              pose: PenguinPose.curiousEmpty,
              size: 200,
            ),
            const SizedBox(height: 24),
            _buildEmptyTexts(context),
            const SizedBox(height: 24),
            PrimaryGradientButton(
              label: context.loc.addFirstHabit,
              onPressed: onAddHabit,
              width: 280,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyTexts(BuildContext context) {
    return Column(
      children: [
        Text(
          context.loc.emptyHabitsTitle,
          textAlign: TextAlign.center,
          style: context.typography.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: context.colors.textMain,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          context.loc.emptyHabitsSubtitle,
          textAlign: TextAlign.center,
          style: context.typography.bodyMedium?.copyWith(
            color: context.colors.textMuted,
          ),
        ),
      ],
    );
  }
}
