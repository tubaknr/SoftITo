import 'package:flutter/material.dart';
import '../controller/water_tracker_controller.dart';
import '../widget/quick_add_water_buttons.dart';
import '../widget/water_history_list.dart';
import '../widget/water_progress_card.dart';

class WaterTrackerView extends StatelessWidget {
  const WaterTrackerView({
    super.key,
    required this.controller,
  });

  final WaterTrackerController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WaterProgressCard(
                currentMl: controller.currentAmountMl,
                baseGoalMl: controller.baseGoalMl,
                workoutBonusMl: controller.workoutBonusMl,
                totalGoalMl: controller.totalGoalMl,
                progress: controller.progressRatio,
                progressPercentage: controller.progressPercentage,
                remainingMl: controller.remainingMl,
                isGoalReached: controller.isGoalReached,
              ),
              const SizedBox(height: 20),
              QuickAddWaterButtons(
                onAddWater: controller.addWater,
              ),
              const SizedBox(height: 24),
              const _SectionHeader(title: 'Bugünkü Tüketim Geçmişi'),
              const SizedBox(height: 12),
              WaterHistoryList(logs: controller.logs),
            ],
          ),
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(title, style: theme.textTheme.titleMedium);
  }
}
