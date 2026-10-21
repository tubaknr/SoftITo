import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/flower_painter.dart';
import '../../focus/controller/focus_controller.dart';
import '../controller/community_controller.dart';
import '../models/community_user_model.dart';
import 'public_profile_page.dart';

/// Topluluk Sayfası (Sekme 3)
class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  void _openCountryFilterModal(BuildContext context) {
    final isDark = context.isDark;
    final loc = context.loc;
    final countries = CommunityController.instance.availableCountries;
    final selected = CommunityController.instance.selectedCountryFilter.value;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: isDark ? AppColors.darkCardSurface : const Color(0xFFFFFDF8),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  loc.filterByCountry,
                  style: AppTypography.heading2(isDark: isDark),
                ),
              ),
              const Divider(height: 1),
              ListTile(
                title: Text(
                  loc.allCountries,
                  style: TextStyle(
                    fontWeight:
                        selected == null ? FontWeight.bold : FontWeight.normal,
                    color: selected == null
                        ? AppColors.dustyRoseAccent
                        : (isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textCharcoal),
                  ),
                ),
                trailing: selected == null
                    ? const Icon(Icons.check_circle_rounded,
                        color: AppColors.dustyRoseAccent)
                    : null,
                onTap: () {
                  CommunityController.instance.setCountryFilter(null);
                  Navigator.of(context).pop();
                },
              ),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: countries.length,
                  itemBuilder: (context, index) {
                    final country = countries[index];
                    final isSelected = country == selected;

                    return ListTile(
                      title: Text(
                        country,
                        style: TextStyle(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected
                              ? AppColors.dustyRoseAccent
                              : (isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.textCharcoal),
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle_rounded,
                              color: AppColors.dustyRoseAccent)
                          : null,
                      onTap: () {
                        CommunityController.instance.setCountryFilter(country);
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    final isDark = context.isDark;

    return ValueListenableBuilder<List<CommunityUserModel>>(
      valueListenable: CommunityController.instance,
      builder: (context, users, _) {
        return ValueListenableBuilder<String?>(
          valueListenable: CommunityController.instance.selectedCountryFilter,
          builder: (context, selectedCountry, _) {
            final top10Countries = CommunityController.instance.top10Countries;
            final top50Users = CommunityController.instance.filteredTop50;

            return CustomScrollView(
              slivers: [
                // 1. Ülkeler Sıralaması Başlığı
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                    child: Text(
                      loc.countryRankingsTop10,
                      style: AppTypography.heading2(isDark: isDark),
                    ),
                  ),
                ),

                // 2. İlk 10 Ülke Yatay Kart Listesi
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: top10Countries.length,
                      itemBuilder: (context, index) {
                        return _CountryRankCard(
                          item: top10Countries[index],
                          isDark: isDark,
                          loc: loc,
                        );
                      },
                    ),
                  ),
                ),

                // 3. Sola Dayalı Filtre Butonu ve Dünyada İlk 50 Başlığı
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedCountry != null
                              ? '$selectedCountry (${top50Users.length})'
                              : loc.worldTop50,
                          style: AppTypography.heading2(isDark: isDark),
                        ),
                        // Sola dayalı şık filtre butonu
                        TextButton.icon(
                          style: TextButton.styleFrom(
                            backgroundColor: isDark
                                ? AppColors.darkCardSurface
                                : Colors.white.withValues(alpha: 0.8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(
                                color: AppColors.dustyRoseAccent
                                    .withValues(alpha: 0.4),
                              ),
                            ),
                          ),
                          icon: const Icon(Icons.filter_list_rounded,
                              size: 18, color: AppColors.dustyRoseAccent),
                          label: Text(
                            selectedCountry ?? loc.filterButton,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.dustyRoseAccent,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onPressed: () => _openCountryFilterModal(context),
                        ),
                      ],
                    ),
                  ),
                ),

                // 4. Dünyada İlk 50 Liderlik Listesi (ListView.builder)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final user = top50Users[index];
                        return _WorldUserListItem(
                          rank: index + 1,
                          user: user,
                          isDark: isDark,
                          loc: loc,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => PublicProfilePage(user: user),
                              ),
                            );
                          },
                        );
                      },
                      childCount: top50Users.length,
                    ),
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: 100), // Alt bar payı
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _CountryRankCard extends StatelessWidget {
  final CountryRankingModel item;
  final bool isDark;
  final AppLocalizations loc;

  const _CountryRankCard({
    required this.item,
    required this.isDark,
    required this.loc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      margin: const EdgeInsets.only(right: 12, top: 4, bottom: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkCardSurface.withValues(alpha: 0.85)
            : Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: item.rank == 1
              ? const Color(0xFFFFD54F)
              : (isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.white.withValues(alpha: 0.8)),
          width: item.rank == 1 ? 1.8 : 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: item.rank <= 3
                      ? AppColors.dustyRoseAccent
                      : (isDark
                          ? Colors.white.withValues(alpha: 0.1)
                          : Colors.grey.withValues(alpha: 0.2)),
                ),
                child: Center(
                  child: Text(
                    '${item.rank}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: item.rank <= 3 ? Colors.white : AppColors.textCharcoal,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item.country,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textCharcoal,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            FocusController.formatNaturalDuration(
              item.totalFocusSeconds,
              dayLabel: loc.daysUnit,
              hourLabel: loc.hoursUnit,
              minLabel: loc.minutesUnit,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.dustyRoseAccent,
            ),
          ),
        ],
      ),
    );
  }
}

class _WorldUserListItem extends StatelessWidget {
  final int rank;
  final CommunityUserModel user;
  final bool isDark;
  final AppLocalizations loc;
  final VoidCallback onTap;

  const _WorldUserListItem({
    required this.rank,
    required this.user,
    required this.isDark,
    required this.loc,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkCardSurface.withValues(alpha: 0.75)
            : Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.white.withValues(alpha: 0.7),
          width: 1.1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: ListTile(
          onTap: onTap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 24,
              child: Text(
                '$rank',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: rank <= 3
                      ? AppColors.dustyRoseAccent
                      : (isDark ? AppColors.darkTextMuted : AppColors.textMuted),
                ),
              ),
            ),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark
                    ? AppColors.darkBackground
                    : Colors.white.withValues(alpha: 0.8),
                border: Border.all(
                  color: AppColors.dustyRoseAccent.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: CustomPaint(
                painter: FlowerPainter(
                  stage: user.flowerStage,
                  animationProgress: 0.3,
                  isDark: isDark,
                ),
              ),
            ),
          ],
        ),
        title: Text(
          user.name,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
          ),
        ),
        subtitle: Text(
          '${user.country} • 🔥 ${user.streakDays} ${loc.streakLabel}',
          style: TextStyle(
            fontSize: 11,
            color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
          ),
        ),
        trailing: Text(
          FocusController.formatNaturalDuration(
            user.totalFocusSeconds,
            dayLabel: loc.daysUnit,
            hourLabel: loc.hoursUnit,
            minLabel: loc.minutesUnit,
          ),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.dustyRoseAccent,
          ),
        ),
      ),
    ),
    );
  }
}
