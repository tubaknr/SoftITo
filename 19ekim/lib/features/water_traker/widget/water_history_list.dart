import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/water_log.dart';

class WaterHistoryList extends StatelessWidget {
  const WaterHistoryList({
    super.key,
    required this.logs,
  });

  final List<WaterLog> logs;

  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty) {
      return const _EmptyHistoryPlaceholder();
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: logs.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        return _WaterHistoryTile(log: logs[index]);
      },
    );
  }
}

class _EmptyHistoryPlaceholder extends StatelessWidget {
  const _EmptyHistoryPlaceholder();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Text(
          'Henüz su tüketimi kaydedilmedi.',
          style: theme.textTheme.bodyMedium,
        ),
      ),
    );
  }
}

class _WaterHistoryTile extends StatelessWidget {
  const _WaterHistoryTile({required this.log});

  final WaterLog log;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeStr =
        '${log.timestamp.hour.toString().padLeft(2, '0')}:${log.timestamp.minute.toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.check_circle, color: AppColors.neonCyan, size: 20),
              const SizedBox(width: 12),
              Text('${log.amountMl} ml Su', style: theme.textTheme.titleMedium),
            ],
          ),
          Text(timeStr, style: theme.textTheme.labelSmall),
        ],
      ),
    );
  }
}
