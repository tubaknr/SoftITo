import 'package:flutter/material.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/controllers/session_controller.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/rating_stars.dart';
import '../../../core/widgets/section_header.dart';
import '../../settings/view/settings_page.dart';
import '../../vehicle_list/models/enums.dart';
import '../../vehicle_list/models/review.dart';
import '../data/mock_renter_data.dart';
import '../models/renter_user.dart';

class RenterProfilePage extends StatefulWidget {
  const RenterProfilePage({
    required this.sessionController,
    this.renterId,
    this.isOwnProfile = true,
    super.key,
  });

  final SessionController sessionController;
  final String? renterId;
  final bool isOwnProfile;

  @override
  State<RenterProfilePage> createState() => _RenterProfilePageState();
}

class _RenterProfilePageState extends State<RenterProfilePage> {
  bool _showAllReviews = false;

  @override
  Widget build(BuildContext context) {
    final String targetId = widget.renterId ??
        widget.sessionController.value.userId ??
        'renter_1';
    final RenterUser renter = MockRenterData.getById(targetId) ?? MockRenterData.renters.first;

    final List<Review> displayedReviews = _showAllReviews
        ? renter.reviews
        : renter.reviews.take(3).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isOwnProfile ? context.l10n.navProfile : context.l10n.renterProfileTitle),
        actions: <Widget>[
          if (widget.isOwnProfile)
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
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: context.colorScheme.primaryContainer,
                        child: Text(
                          renter.firstName.substring(0, 1),
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
                              '${renter.displayName} (${renter.age})',
                              style: context.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              '${renter.occupation} • ${renter.city}',
                              style: context.textTheme.bodyMedium?.copyWith(
                                color: context.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              '${context.l10n.memberSinceLabel}: ${renter.memberSince}',
                              style: context.textTheme.bodySmall?.copyWith(
                                color: context.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Row(
                              children: <Widget>[
                                RatingStars(
                                  rating: renter.trustScore,
                                  ratingCount: renter.reviewCount,
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Text(
                                  '${renter.totalRentCount} ${context.l10n.totalRentCountLabel}',
                                  style: context.textTheme.labelSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: context.colorScheme.primary,
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
              ),
              const SizedBox(height: AppSpacing.xl),

              // Yorumlar Başlığı
              SectionHeader(
                title: 'Araç Sahiplerinin Bu Kiracı Hakkındaki Yorumları',
                subtitle: '${renter.reviews.length} değerlendirme',
              ),
              const SizedBox(height: AppSpacing.sm),

              // Yorum Listesi
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
                              Row(
                                children: <Widget>[
                                  CircleAvatar(
                                    radius: 14,
                                    backgroundColor: context.colorScheme.secondaryContainer,
                                    child: Icon(
                                      Icons.person_rounded,
                                      size: 16,
                                      color: context.colorScheme.onSecondaryContainer,
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  Text(
                                    review.authorName,
                                    style: context.textTheme.labelLarge?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              RatingStars(rating: review.rating),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            review.text,
                            style: context.textTheme.bodyMedium,
                          ),
                          if (review.returnTags.isNotEmpty) ...<Widget>[
                            const SizedBox(height: AppSpacing.sm),
                            Wrap(
                              spacing: AppSpacing.xs,
                              runSpacing: AppSpacing.xs,
                              children: review.returnTags.map((ReturnTag tag) {
                                final Color tagColor = tag.isPositive
                                    ? context.appColors.success
                                    : context.appColors.danger;

                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.sm,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: tagColor.withAlpha(25),
                                    borderRadius: BorderRadius.circular(AppRadius.sm),
                                    border: Border.all(
                                      color: tagColor.withAlpha(80),
                                      width: 0.8,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Icon(tag.icon, size: 12, color: tagColor),
                                      const SizedBox(width: AppSpacing.xs),
                                      Text(
                                        tag.localized(context.l10n),
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: tagColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),

              // Daha Fazla Göster Butonu
              if (renter.reviews.length > 3)
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
