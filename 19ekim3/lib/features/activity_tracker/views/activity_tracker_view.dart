import 'package:flutter/material.dart';
import '../controllers/activity_tracker_controller.dart';
import '../models/activity_tracker_model.dart';
import '../widgets/activity_tracker_card.dart';

class ActivityTrackerView extends StatelessWidget {
  final ActivityTrackerController controller;

  const ActivityTrackerView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ActivityTracker Modülü'),
        actions: [
          IconButton(
            tooltip: 'Sıfırla',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: controller.reset,
          ),
        ],
      ),
      body: ValueListenableBuilder<ActivityTrackerModel>(
        valueListenable: controller.state,
        builder: (context, model, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ActivityTrackerCard(
                  model: model,
                  onIncrement: controller.increment,
                  onToggle: controller.toggleStatus,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
