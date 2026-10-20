import 'package:flutter/material.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../models/fikir_model.dart';

class AvukatKarti extends StatelessWidget {
  const AvukatKarti({
    super.key,
    required this.avukat,
    this.onIletisimeGec,
  });

  final AtananAvukat avukat;
  final VoidCallback? onIletisimeGec;

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final textTheme = context.textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppRadius.lg,
        border: Border.all(color: colors.outline, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: colors.surfaceHigh,
                child: Icon(Icons.gavel_rounded, color: colors.dawn, size: 22),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ücretsiz Hukuki Danışmanınız',
                      style: textTheme.labelMedium?.copyWith(color: colors.dawn),
                    ),
                    Text(
                      avukat.adSoyad,
                      style: textTheme.titleLarge?.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _InfoRow(icon: Icons.account_balance_rounded, label: '${avukat.baro} — Sicil: ${avukat.sicilNo}'),
          const SizedBox(height: AppSpacing.xs),
          _InfoRow(icon: Icons.verified_user_rounded, label: avukat.uzmanlik),
          const SizedBox(height: AppSpacing.xs),
          _InfoRow(icon: Icons.phone_rounded, label: avukat.telefon),
          const SizedBox(height: AppSpacing.xs),
          _InfoRow(icon: Icons.email_rounded, label: avukat.eposta),
          const SizedBox(height: AppSpacing.lg),
          OutlinedButton(
            onPressed: onIletisimeGec ?? () {},
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: colors.dawn, width: 1.2),
              shape: const RoundedRectangleBorder(borderRadius: AppRadius.pill),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.chat_bubble_outline_rounded, size: 18, color: colors.dawn),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Avukatla İletişime Geç',
                  style: textTheme.titleMedium?.copyWith(
                    color: colors.dawn,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final textTheme = context.textTheme;

    return Row(
      children: [
        Icon(icon, size: 16, color: colors.textMuted),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            label,
            style: textTheme.bodyMedium?.copyWith(color: colors.textPrimary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
