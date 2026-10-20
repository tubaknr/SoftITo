import 'package:flutter/material.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';

class IdeaStatusBadge extends StatelessWidget {
  const IdeaStatusBadge({
    super.key,
    required this.statusText,
    required this.progress,
    required this.onTap,
  });

  final String statusText;
  final double progress; // 0.0 to 1.0
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final textTheme = context.textTheme;

    return Semantics(
      button: true,
      label: 'Fikir durumum, $statusText',
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.pill,
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: AppRadius.pill,
            border: Border.all(
              color: colors.outline,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: colors.dawn.withValues(alpha: 0.15),
                blurRadius: 12,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Circular progress indicator (Orbit ring)
              SizedBox(
                width: 20,
                height: 20,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: 1.0,
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        colors.outline,
                      ),
                    ),
                    CircularProgressIndicator(
                      value: progress.clamp(0.0, 1.0),
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        colors.dawn,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              // Status text
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fikir Durumu',
                    style: textTheme.labelMedium?.copyWith(
                      color: colors.textMuted,
                      fontSize: 10,
                      height: 1.1,
                    ),
                  ),
                  Text(
                    statusText,
                    style: textTheme.labelMedium?.copyWith(
                      color: colors.dawn,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: AppSpacing.xs),
              Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: colors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
