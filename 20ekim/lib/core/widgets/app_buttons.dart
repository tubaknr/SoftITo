import 'package:flutter/material.dart';
import '../constants/app_durations.dart';
import '../constants/app_radius.dart';
import '../constants/app_spacing.dart';
import '../extensions/context_extensions.dart';

class PrimaryDawnButton extends StatefulWidget {
  const PrimaryDawnButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;

  @override
  State<PrimaryDawnButton> createState() => _PrimaryDawnButtonState();
}

class _PrimaryDawnButtonState extends State<PrimaryDawnButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final textTheme = context.textTheme;
    final isEnabled = widget.onPressed != null && !widget.isLoading;

    final content = SizedBox(
      height: 52,
      child: Center(
        child: widget.isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(colors.onDawn),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.icon != null) ...[
                    Icon(widget.icon, size: 18, color: colors.onDawn),
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  Text(
                    widget.label,
                    style: textTheme.labelLarge?.copyWith(
                      color: colors.onDawn,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
      ),
    );

    return GestureDetector(
      onTapDown: isEnabled ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: isEnabled ? (_) => setState(() => _isPressed = false) : null,
      onTapCancel: isEnabled ? () => setState(() => _isPressed = false) : null,
      onTap: isEnabled ? widget.onPressed : null,
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: AppDurations.quick,
        curve: Curves.easeOutCubic,
        child: Container(
          decoration: BoxDecoration(
            color: isEnabled
                ? colors.dawn
                : colors.textMuted.withValues(alpha: 0.40),
            borderRadius: AppRadius.pill,
            boxShadow: isEnabled
                ? [
                    BoxShadow(
                      color: colors.dawn.withValues(alpha: 0.35),
                      blurRadius: 24,
                      spreadRadius: 0,
                    ),
                  ]
                : null,
          ),
          child: content,
        ),
      ),
    );
  }
}

class SecondaryOutlineButton extends StatelessWidget {
  const SecondaryOutlineButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final textTheme = context.textTheme;

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        side: BorderSide(color: colors.outline, width: 1),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: colors.textPrimary),
            const SizedBox(width: AppSpacing.sm),
          ],
          Text(
            label,
            style: textTheme.titleMedium?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
