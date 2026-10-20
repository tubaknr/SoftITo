import 'package:flutter/material.dart';
import '../constants/app_spacing.dart';
import '../extensions/context_extensions.dart';

class RatingStars extends StatelessWidget {
  const RatingStars({
    required this.rating,
    this.ratingCount,
    this.starSize = 16.0,
    this.showNumericRating = true,
    super.key,
  });

  final double rating;
  final int? ratingCount;
  final double starSize;
  final bool showNumericRating;

  @override
  Widget build(BuildContext context) {
    final Color ratingColor = context.appColors.rating;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.star_rounded,
          color: ratingColor,
          size: starSize,
        ),
        if (showNumericRating) ...<Widget>[
          const SizedBox(width: AppSpacing.xs),
          Text(
            rating.toStringAsFixed(1),
            style: context.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: context.colorScheme.onSurface,
            ),
          ),
        ],
        if (ratingCount != null) ...<Widget>[
          const SizedBox(width: AppSpacing.xs),
          Text(
            '($ratingCount)',
            style: context.textTheme.labelSmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}
