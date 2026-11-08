// ========================================
// DOSYA: health_timeline_tile.dart
// NE İŞE YARAR: Sağlık zaman çizelgesi
// satırını ve ilerleme barını görüntüler.
// NASIL ÇALIŞIR: Tamamlanma durumu ve orana
// göre dikey çizgi ve durum ikonu çizer.
// SOLID: SRP - Sadece tek bir zaman çizelgesi
// satırını görselleştirir.
// ========================================

import 'package:flutter/material.dart';
import '../models/health_milestone.dart';
import '../theme/app_theme.dart';

// SRP: Zaman çizelgesi satır bileşeni.
class HealthTimelineTile extends StatelessWidget {
  final HealthMilestone milestone;
  final bool isCompleted;
  final double progress;
  final bool isFirst;
  final bool isLast;

  const HealthTimelineTile({
    super.key,
    required this.milestone,
    required this.isCompleted,
    required this.progress,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTimelineIndicator(),
          const SizedBox(width: 14),
          Expanded(child: _buildContentCard()),
        ],
      ),
    );
  }

  Widget _buildTimelineIndicator() {
    final activeColor =
        isCompleted ? AppTheme.primary : AppTheme.onSurfaceMuted;

    return Column(
      children: [
        Container(
          width: 2,
          height: 16,
          color: isFirst ? Colors.transparent : activeColor,
        ),
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted
                ? AppTheme.primaryContainer
                : AppTheme.surfaceHigh,
            border: Border.all(
              color: isCompleted
                  ? AppTheme.primary
                  : AppTheme.outline,
              width: 2,
            ),
          ),
          child: Icon(
            isCompleted ? Icons.check_rounded : Icons.hourglass_top_rounded,
            size: 16,
            color: activeColor,
          ),
        ),
        Expanded(
          child: Container(
            width: 2,
            color: isLast ? Colors.transparent : activeColor,
          ),
        ),
      ],
    );
  }

  Widget _buildContentCard() {
    final percent = (progress * 100).toInt();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCompleted
              ? AppTheme.outlineActive
              : AppTheme.outline,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(milestone.title, style: AppTheme.titleSmall),
              Text(
                isCompleted ? '%100' : '%$percent',
                style: AppTheme.labelCaps.copyWith(
                  color: isCompleted
                      ? AppTheme.primary
                      : AppTheme.secondaryCyan,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(milestone.description, style: AppTheme.bodyMedium),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: AppTheme.surfaceHighest,
              valueColor: AlwaysStoppedAnimation<Color>(
                isCompleted
                    ? AppTheme.primary
                    : AppTheme.secondaryCyan,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
