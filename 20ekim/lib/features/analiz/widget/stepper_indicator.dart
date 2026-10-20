import 'package:flutter/material.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';

class StepperIndicator extends StatelessWidget {
  const StepperIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.stepTitles,
    required this.onStepTapped,
  });

  final int currentStep;
  final int totalSteps;
  final List<String> stepTitles;
  final ValueChanged<int> onStepTapped;

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final textTheme = context.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Bölüm ${currentStep + 1} / $totalSteps: ${stepTitles[currentStep]}',
              style: textTheme.labelLarge?.copyWith(
                color: colors.dawn,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              '%${(((currentStep + 1) / totalSteps) * 100).toInt()}',
              style: textTheme.labelMedium?.copyWith(
                color: colors.textMuted,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: List.generate(totalSteps, (index) {
            final isCompleted = index < currentStep;
            final isCurrent = index == currentStep;

            final Color barColor;
            if (isCurrent) {
              barColor = colors.dawn;
            } else if (isCompleted) {
              barColor = colors.success;
            } else {
              barColor = colors.outline;
            }

            return Expanded(
              child: GestureDetector(
                onTap: () => onStepTapped(index),
                child: Container(
                  height: 6,
                  margin: EdgeInsets.only(
                    right: index == totalSteps - 1 ? 0 : AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: barColor,
                    borderRadius: AppRadius.pill,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
