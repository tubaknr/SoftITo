import 'package:flutter/material.dart';
import '../constants/app_radius.dart';
import '../constants/app_spacing.dart';
import '../extensions/context_extensions.dart';

enum StatusType {
  beklemede,
  inceleniyor,
  eslesti,
  onaylandi,
  acik,
  gorusmePlanlandi,
  revizeIstendi,
  yakinda,
  kapandi,
  hata,
}

class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.type,
    this.customLabel,
  });

  final StatusType type;
  final String? customLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final textTheme = context.textTheme;

    final Color statusColor;
    final IconData statusIcon;
    final String defaultLabel;

    switch (type) {
      case StatusType.beklemede:
        statusColor = colors.info;
        statusIcon = Icons.schedule_rounded;
        defaultLabel = 'Beklemede';
        break;
      case StatusType.inceleniyor:
        statusColor = colors.info;
        statusIcon = Icons.schedule_rounded;
        defaultLabel = 'İnceleniyor';
        break;
      case StatusType.eslesti:
        statusColor = colors.success;
        statusIcon = Icons.check_circle_rounded;
        defaultLabel = 'Eşleşti';
        break;
      case StatusType.onaylandi:
        statusColor = colors.success;
        statusIcon = Icons.check_circle_rounded;
        defaultLabel = 'Onaylandı';
        break;
      case StatusType.acik:
        statusColor = colors.success;
        statusIcon = Icons.check_circle_rounded;
        defaultLabel = 'Açık';
        break;
      case StatusType.gorusmePlanlandi:
        statusColor = colors.orbit;
        statusIcon = Icons.event_available_rounded;
        defaultLabel = 'Görüşme Planlandı';
        break;
      case StatusType.revizeIstendi:
        statusColor = colors.warning;
        statusIcon = Icons.edit_note_rounded;
        defaultLabel = 'Revize İstendi';
        break;
      case StatusType.yakinda:
        statusColor = colors.warning;
        statusIcon = Icons.hourglass_top_rounded;
        defaultLabel = 'Yakında';
        break;
      case StatusType.kapandi:
        statusColor = colors.danger;
        statusIcon = Icons.block_rounded;
        defaultLabel = 'Kapandı';
        break;
      case StatusType.hata:
        statusColor = colors.danger;
        statusIcon = Icons.error_outline_rounded;
        defaultLabel = 'Hata';
        break;
    }

    final label = customLabel ?? defaultLabel;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.14),
        borderRadius: AppRadius.pill,
        border: Border.all(
          color: statusColor.withValues(alpha: 0.28),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, size: 14, color: statusColor),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: textTheme.labelMedium?.copyWith(
              color: statusColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
