import 'package:flutter/material.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/rating_stars.dart';
import '../../owner_profile/data/mock_owner_data.dart';
import '../../owner_profile/models/owner_user.dart';
import '../models/vehicle.dart';

class VehicleCard extends StatelessWidget {
  const VehicleCard({
    required this.vehicle,
    required this.onTap,
    super.key,
  });

  final Vehicle vehicle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final OwnerUser? owner = MockOwnerData.getById(vehicle.ownerId);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Görsel / Üst Banner Alanı (16:9 Oranında)
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Hero(
                    tag: 'vehicle_image_${vehicle.id}',
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[
                            context.colorScheme.primary.withAlpha(40),
                            context.colorScheme.secondaryContainer,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          vehicle.type.icon,
                          size: 72,
                          color: context.colorScheme.primary.withAlpha(160),
                        ),
                      ),
                    ),
                  ),
                  // Araç Tipi Rozeti
                  Positioned(
                    top: AppSpacing.sm,
                    left: AppSpacing.sm,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: context.colorScheme.surface.withAlpha(220),
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                        border: Border.all(
                          color: context.colorScheme.outlineVariant,
                          width: 0.8,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(vehicle.type.icon, size: 14, color: context.colorScheme.primary),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            vehicle.type.localized(context.l10n),
                            style: context.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: context.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // İç Kamera Var Rozeti (varsa)
                  if (vehicle.hasInteriorCamera)
                    Positioned(
                      top: AppSpacing.sm,
                      right: AppSpacing.sm,
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.xs),
                        decoration: BoxDecoration(
                          color: context.colorScheme.surface.withAlpha(220),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.videocam_rounded,
                          size: 16,
                          color: Colors.green,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Bilgi Alanı
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Satır 1: Marka-Model-Yıl ve Puan
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          vehicle.fullName,
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: context.colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      RatingStars(
                        rating: vehicle.rating,
                        ratingCount: vehicle.ratingCount,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  // Satır 2: Teknik Özet (Vites, Yakıt, Koltuk, Km)
                  Wrap(
                    spacing: AppSpacing.md,
                    runSpacing: AppSpacing.xs,
                    children: <Widget>[
                      _FeatureItem(
                        icon: Icons.speed_rounded,
                        text: '${(vehicle.mileageKm / 1000).toStringAsFixed(0)}k km',
                      ),
                      _FeatureItem(
                        icon: Icons.tune_rounded,
                        text: vehicle.transmission.localized(context.l10n),
                      ),
                      _FeatureItem(
                        icon: Icons.local_gas_station_rounded,
                        text: vehicle.fuelType.localized(context.l10n),
                      ),
                      _FeatureItem(
                        icon: Icons.airline_seat_recline_normal_rounded,
                        text: '${vehicle.seatCount} koltuk',
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const Divider(height: 1),
                  const SizedBox(height: AppSpacing.sm),
                  // Satır 3: Günlük Fiyat ve Sahip Adı
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: context.colorScheme.primaryContainer,
                            child: Icon(
                              Icons.person_rounded,
                              size: 14,
                              color: context.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            owner?.displayName ?? 'Araç Sahibi',
                            style: context.textTheme.bodySmall?.copyWith(
                              color: context.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: '₺${vehicle.dailyPrice.toStringAsFixed(0)}',
                              style: context.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: context.colorScheme.primary,
                              ),
                            ),
                            TextSpan(
                              text: ' ${context.l10n.perDay}',
                              style: context.textTheme.labelSmall?.copyWith(
                                color: context.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  const _FeatureItem({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(
          icon,
          size: 14,
          color: context.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          text,
          style: context.textTheme.labelMedium?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
