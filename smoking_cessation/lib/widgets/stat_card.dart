// ========================================
// DOSYA: stat_card.dart
// NE İŞE YARAR: Tasarruf ve kazanım metrik
// kartlarını görüntüler.
// NASIL ÇALIŞIR: İkon, başlık, değer ve alt
// metin parametreleriyle kart üretir.
// SOLID: SRP - Sadece metrik kartı sunar.
// ========================================

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// SRP: Tekil istatistik kartı bileşeni.
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color accentColor;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    this.accentColor = AppTheme.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: accentColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title.toUpperCase(),
                  style: AppTheme.labelCaps,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: AppTheme.labelMetric.copyWith(color: accentColor),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(subtitle!, style: AppTheme.bodySmall),
          ],
        ],
      ),
    );
  }
}
