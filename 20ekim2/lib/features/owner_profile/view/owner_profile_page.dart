import 'package:flutter/material.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/controllers/session_controller.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/rating_stars.dart';
import '../../../core/widgets/section_header.dart';
import '../../renter_profile/view/renter_profile_page.dart';
import '../../settings/view/settings_page.dart';
import '../../vehicle_detail/view/vehicle_detail_page.dart';
import '../../vehicle_list/data/mock_vehicle_data.dart';
import '../../vehicle_list/models/review.dart';
import '../../vehicle_list/models/vehicle.dart';
import '../data/mock_owner_data.dart';
import '../models/owner_user.dart';

class OwnerProfilePage extends StatefulWidget {
  const OwnerProfilePage({
    required this.sessionController,
    this.ownerId,
    this.isOwnProfile = false,
    super.key,
  });

  final SessionController sessionController;
  final String? ownerId;
  final bool isOwnProfile;

  @override
  State<OwnerProfilePage> createState() => _OwnerProfilePageState();
}

class _OwnerProfilePageState extends State<OwnerProfilePage> {
  bool _showAllReviews = false;

  void _showEditProfileDialog(OwnerUser owner) {
    final TextEditingController nameCtrl = TextEditingController(text: owner.firstName);
    final TextEditingController aboutCtrl = TextEditingController(text: owner.about);
    final TextEditingController cityCtrl = TextEditingController(text: owner.city);

    showDialog<void>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: Text(context.l10n.editProfile),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(labelText: context.l10n.firstNameLabel),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: cityCtrl,
                decoration: InputDecoration(labelText: context.l10n.cityLabel),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: aboutCtrl,
                maxLines: 3,
                decoration: InputDecoration(labelText: context.l10n.aboutMe),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(context.l10n.dialogCancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profil başarıyla güncellendi.')),
              );
            },
            child: Text(context.l10n.saveProfile),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String targetId = widget.ownerId ??
        widget.sessionController.value.userId ??
        'owner_1';
    final OwnerUser owner = MockOwnerData.getById(targetId) ?? MockOwnerData.owners.first;

    final List<Vehicle> ownerVehicles = MockVehicleData.vehicles
        .where((Vehicle v) => owner.vehicleIds.contains(v.id))
        .toList();

    final List<Review> displayedReviews = _showAllReviews
        ? owner.reviews
        : owner.reviews.take(3).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isOwnProfile ? context.l10n.navProfile : context.l10n.ownerProfileTitle),
        actions: <Widget>[
          if (widget.isOwnProfile) ...<Widget>[
            IconButton(
              tooltip: context.l10n.editProfile,
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => _showEditProfileDialog(owner),
            ),
            IconButton(
              tooltip: context.l10n.settingsTitle,
              icon: const Icon(Icons.settings_outlined),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => SettingsPage(
                      sessionController: widget.sessionController,
                    ),
                  ),
                );
              },
            ),
          ],
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Üst Bölüm: Profil Kartı
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 36,
                            backgroundColor: context.colorScheme.primaryContainer,
                            child: Text(
                              owner.firstName.substring(0, 1),
                              style: context.textTheme.headlineMedium?.copyWith(
                                color: context.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.lg),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '${owner.displayName} (${owner.ageRange})',
                                  style: context.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  owner.location,
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    color: context.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  '${context.l10n.memberSinceLabel}: ${owner.memberSince}',
                                  style: context.textTheme.bodySmall?.copyWith(
                                    color: context.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        owner.about,
                        style: context.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      const Divider(height: 1),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          RatingStars(
                            rating: owner.ownerRating,
                            ratingCount: owner.ownerReviewCount,
                          ),
                          Text(
                            owner.responseTime,
                            style: context.textTheme.labelSmall?.copyWith(
                              color: context.appColors.success,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Sahibin Araçları Bölümü
              SectionHeader(
                title: context.l10n.vehiclesOfOwner,
                subtitle: '${ownerVehicles.length} araç',
              ),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                height: 140,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: ownerVehicles.length,
                  separatorBuilder: (BuildContext _, int index) => const SizedBox(width: AppSpacing.md),
                  itemBuilder: (BuildContext ctx, int index) {
                    final Vehicle v = ownerVehicles[index];
                    return SizedBox(
                      width: 240,
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => VehicleDetailPage(
                                  vehicle: v,
                                  sessionController: widget.sessionController,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Icon(v.type.icon, size: 20, color: context.colorScheme.primary),
                                    const SizedBox(width: AppSpacing.xs),
                                    Expanded(
                                      child: Text(
                                        v.fullName,
                                        style: context.textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.w700,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    RatingStars(rating: v.rating),
                                    Text(
                                      '${v.rentCount} kez',
                                      style: context.textTheme.labelSmall,
                                    ),
                                  ],
                                ),
                                Text(
                                  '₺${v.dailyPrice.toStringAsFixed(0)} ${context.l10n.perDay}',
                                  style: context.textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: context.colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Yorumlar Bölümü
              SectionHeader(
                title: 'Kiracıların Bu Araç Sahibi Hakkındaki Yorumları',
                subtitle: '${owner.reviews.length} değerlendirme',
              ),
              const SizedBox(height: AppSpacing.sm),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: displayedReviews.length,
                separatorBuilder: (BuildContext _, int index) => const SizedBox(height: AppSpacing.md),
                itemBuilder: (BuildContext ctx, int index) {
                  final Review review = displayedReviews[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                      builder: (_) => RenterProfilePage(
                                        sessionController: widget.sessionController,
                                        renterId: review.authorId,
                                        isOwnProfile: false,
                                      ),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: <Widget>[
                                    CircleAvatar(
                                      radius: 14,
                                      backgroundColor: context.colorScheme.primaryContainer,
                                      child: Icon(
                                        Icons.person_rounded,
                                        size: 16,
                                        color: context.colorScheme.primary,
                                      ),
                                    ),
                                    const SizedBox(width: AppSpacing.sm),
                                    Text(
                                      review.authorName,
                                      style: context.textTheme.labelLarge?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              RatingStars(rating: review.rating),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            review.text,
                            style: context.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              if (owner.reviews.length > 3)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.md),
                    child: TextButton.icon(
                      icon: Icon(
                        _showAllReviews
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                      ),
                      label: Text(
                        _showAllReviews
                            ? context.l10n.showLessReviews
                            : context.l10n.showMoreReviews,
                      ),
                      onPressed: () {
                        setState(() => _showAllReviews = !_showAllReviews);
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
