import 'package:flutter/material.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../models/topluluk_model.dart';

class GonderiItem extends StatelessWidget {
  const GonderiItem({
    super.key,
    required this.gonderi,
    required this.onBegen,
    required this.onYanitYaz,
  });

  final GonderiModel gonderi;
  final VoidCallback onBegen;
  final VoidCallback onYanitYaz;

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final textTheme = context.textTheme;
    final initials = gonderi.yazarAd.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              CircleAvatar(
                radius: 20,
                backgroundColor: colors.surfaceHigh,
                child: Text(
                  initials,
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              // Body
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Author & Venture name
                    Row(
                      children: [
                        Text(
                          gonderi.yazarAd,
                          style: textTheme.labelLarge?.copyWith(
                            color: colors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          '• ${gonderi.girisimAd}',
                          style: textTheme.bodySmall?.copyWith(color: colors.orbit),
                        ),
                        const Spacer(),
                        Text(
                          gonderi.zaman,
                          style: textTheme.bodySmall?.copyWith(color: colors.textMuted),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    // Post text
                    Text(
                      gonderi.metin,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colors.textPrimary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    // Like & Reply counts
                    Row(
                      children: [
                        InkWell(
                          onTap: onBegen,
                          borderRadius: AppRadius.pill,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: AppSpacing.xs,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  gonderi.begenildiMi
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_border_rounded,
                                  size: 16,
                                  color: gonderi.begenildiMi ? colors.danger : colors.textMuted,
                                ),
                                const SizedBox(width: AppSpacing.xs),
                                Text(
                                  '${gonderi.begeniSayisi}',
                                  style: textTheme.labelMedium?.copyWith(
                                    color: gonderi.begenildiMi ? colors.danger : colors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.lg),
                        InkWell(
                          onTap: onYanitYaz,
                          borderRadius: AppRadius.pill,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: AppSpacing.xs,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.chat_bubble_outline_rounded,
                                  size: 16,
                                  color: colors.textMuted,
                                ),
                                const SizedBox(width: AppSpacing.xs),
                                Text(
                                  '${gonderi.yanitlar.length}',
                                  style: textTheme.labelMedium?.copyWith(color: colors.textMuted),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Single-level replies section
                    if (gonderi.yanitlar.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.sm),
                      ...gonderi.yanitlar.map((yanit) {
                        return Container(
                          margin: const EdgeInsets.only(top: AppSpacing.xs),
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          decoration: BoxDecoration(
                            color: colors.surfaceHigh.withValues(alpha: 0.5),
                            borderRadius: AppRadius.sm,
                            border: Border.all(color: colors.outline, width: 0.5),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    yanit.yazarAd,
                                    style: textTheme.labelMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: colors.dawn,
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.xs),
                                  Text(
                                    '(${yanit.girisimAd})',
                                    style: textTheme.bodySmall?.copyWith(fontSize: 10),
                                  ),
                                  const Spacer(),
                                  Text(
                                    yanit.zaman,
                                    style: textTheme.bodySmall?.copyWith(fontSize: 10),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                yanit.metin,
                                style: textTheme.bodyMedium?.copyWith(fontSize: 13),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        // Divider line (style.md Section 7.4)
        Divider(color: colors.outline, height: 1, thickness: 1),
      ],
    );
  }
}
