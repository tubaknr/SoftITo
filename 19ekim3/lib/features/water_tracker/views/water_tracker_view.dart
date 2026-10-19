import 'package:flutter/material.dart';
import '../controllers/water_tracker_controller.dart';
import '../models/water_tracker_model.dart';
import '../widgets/water_tracker_card.dart';

class WaterTrackerView extends StatelessWidget {
  final WaterTrackerController controller;

  const WaterTrackerView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WaterTracker Modülü'),
        actions: [
          IconButton(
            tooltip: 'Sıfırla',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: controller.reset,
          ),
        ],
      ),
      body: ValueListenableBuilder<WaterTrackerModel>(
        valueListenable: controller.state,
        builder: (context, model, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                WaterTrackerCard(
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
