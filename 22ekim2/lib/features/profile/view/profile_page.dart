import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/l10n/locale_controller.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../core/widgets/penguin_mascot_painter.dart';
import '../../analytics/controller/analytics_controller.dart';
import '../../auth/controller/auth_controller.dart';
import '../../badges/models/badge_model.dart';
import '../../habits/controller/habits_controller.dart';
import '../../home/models/habit_completion.dart';
import '../../notifications/controller/notifications_controller.dart';
import '../../notifications/widget/notification_settings_sheet.dart';
import '../../onboarding/view/welcome_page.dart';

/// User Profile screen adhering to `SKILL.md` Section 3.6
class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
    required this.authController,
    required this.habitsController,
    required this.notificationsController,
  });

  final AuthController authController;
  final HabitsController habitsController;
  final NotificationsController notificationsController;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final AnalyticsEngine _analyticsEngine = const AnalyticsEngine();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        widget.authController.currentUser,
        widget.habitsController.habits,
        widget.habitsController.completions,
        widget.habitsController.badges,
        LocaleController.instance,
      ]),
      builder: (context, _) {
        final user = widget.authController.currentUser.value;
        final completions = widget.habitsController.completions.value;
        final badges = widget.habitsController.badges.value;
        final avgMood = _analyticsEngine.calculateAverageMoodScore(completions);

        final double bottomBarSpacing =
            (context.padding.bottom > 0 ? context.padding.bottom : 16.0) + 64.0;

        return Padding(
          padding: EdgeInsets.fromLTRB(16, 6, 16, bottomBarSpacing),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildAvatarCard(context, user, avgMood),
                      const SizedBox(height: 10),
                      _buildTabBar(context),
                      const SizedBox(height: 8),
                      _buildTabContent(context, completions, badges),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              _buildSettingsCard(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAvatarCard(BuildContext context, dynamic user, double avgMood) {
    final colors = context.colors;
    final name = user?.name ?? 'Ayşe Yılmaz';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'A';
    final completedTotal = widget.habitsController.completions.value.length;
    final growScore = completedTotal * 10;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: colors.borderLight.withValues(alpha: 0.8)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E3A8A).withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildUserProfileHeaderRow(context, colors, name, initial),
          const SizedBox(height: 10),
          _buildMetricsBentoSplit(context, colors, completedTotal, growScore),
        ],
      ),
    );
  }

  Widget _buildUserProfileHeaderRow(
    BuildContext context,
    dynamic colors,
    String name,
    String initial,
  ) {
    return Row(
      children: [
        _buildProfileAvatarWithSprout(colors, initial),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 17,
                      color: colors.textMain,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD8E2FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      context.loc.proMember,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF001A42),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Icon(Icons.calendar_today_rounded, size: 12, color: colors.primary),
                  const SizedBox(width: 4),
                  Text(
                    context.loc.growingTogether,
                    style: TextStyle(fontSize: 12, color: colors.textMuted),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: Color(0xFF34D399),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    context.loc.activeStreakTracking,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF006947),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileAvatarWithSprout(dynamic colors, String initial) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 58,
          height: 58,
          padding: const EdgeInsets.all(2.5),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFFFDA4AF), Color(0xFF93C5FD), Color(0xFF34D399)],
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.bgCard,
            ),
            child: Center(
              child: Text(
                initial,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                  color: colors.primary,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -2,
          right: -2,
          child: Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: const Color(0xFF34D399),
              shape: BoxShape.circle,
              border: Border.all(color: colors.bgCard, width: 2),
            ),
            child: const Center(
              child: Icon(Icons.eco_rounded, size: 10, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricsBentoSplit(
    BuildContext context,
    dynamic colors,
    int completedTotal,
    int growScore,
  ) {
    return Container(
      padding: const EdgeInsets.only(top: 14),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colors.borderLight.withValues(alpha: 0.6))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.bgCardSubtle,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD8E2FF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.check_circle_rounded, size: 18, color: colors.primary),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.loc.completedLabel, style: TextStyle(fontSize: 10.5, color: colors.textMuted)),
                        Text(
                          context.loc.smallTicksCount(completedTotal),
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: colors.primary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.bgCardSubtle,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD1FAE5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.trending_up_rounded, size: 18, color: Color(0xFF006947)),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.loc.growthLabel, style: TextStyle(fontSize: 10.5, color: colors.textMuted)),
                        Text(
                          context.loc.bigGrowScore(growScore),
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF006947)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.bgCardSubtle,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelColor: Colors.white,
        unselectedLabelColor: context.colors.textMuted,
        indicator: BoxDecoration(
          color: context.colors.primary,
          borderRadius: BorderRadius.circular(14),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        tabs: [
          Tab(text: context.loc.sectionHabits),
          Tab(text: context.loc.sectionBadges),
          Tab(text: context.loc.sectionNotifications),
          Tab(text: context.loc.sectionNotes),
        ],
      ),
    );
  }

  Widget _buildTabContent(
    BuildContext context,
    List<HabitCompletion> completions,
    List<BadgeModel> badges,
  ) {
    return SizedBox(
      height: 195,
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildHabitsTab(context),
          _buildBadgesTab(context, badges),
          _buildNotificationsTab(context),
          _buildNotesTab(context, completions),
        ],
      ),
    );
  }

  Widget _buildHabitsTab(BuildContext context) {
    final habits = widget.habitsController.habits.value;
    if (habits.isEmpty) {
      return Center(child: Text(context.loc.emptyHabitsTitle));
    }
    return ListView.builder(
      itemCount: habits.length,
      itemBuilder: (context, i) {
        final h = habits[i];
        final streak = widget.habitsController.getStreak(h.id);
        return ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          leading: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: AppColors.getHabitColor(h.colorIndex),
              shape: BoxShape.circle,
            ),
          ),
          title: Text(
            h.displayTitle(context.loc.isTr),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          trailing: Text(context.loc.streakDays(streak)),
        );
      },
    );
  }

  Widget _buildBadgesTab(BuildContext context, List<BadgeModel> badges) {
    if (badges.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const PenguinMascotWidget(pose: PenguinPose.badgeMedal, size: 75),
            const SizedBox(height: 6),
            Text(
              context.loc.noBadgesYet,
              textAlign: TextAlign.center,
              style: context.typography.bodySmall?.copyWith(
                color: context.colors.textMuted,
              ),
            ),
          ],
        ),
      );
    }
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.1,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: badges.length,
      itemBuilder: (context, i) {
        final b = badges[i];
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: context.colors.bgCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: context.colors.borderLight),
          ),
          child: Row(
            children: [
              Text(
                b.level >= 21 ? '🏆' : '⭐',
                style: const TextStyle(fontSize: 22),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      b.displayTitle(context.loc),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11.5),
                    ),
                    Text(
                      context.loc.daysCount(b.level),
                      style: TextStyle(
                        fontSize: 9.5,
                        color: context.colors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNotificationsTab(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: context.colors.bgCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: context.colors.borderLight),
          ),
        ),
        icon: Icon(Icons.tune_rounded, color: context.colors.primary),
        label: Text(
          context.loc.notificationSettingsTitle,
          style: TextStyle(color: context.colors.textMain, fontWeight: FontWeight.w600),
        ),
        onPressed: () {
          NotificationSettingsSheet.show(
            context,
            controller: widget.notificationsController,
          );
        },
      ),
    );
  }

  Widget _buildNotesTab(BuildContext context, List<HabitCompletion> completions) {
    final withNotes = completions.where((c) => c.moodEntry != null && c.moodEntry!.note.isNotEmpty).toList();

    if (withNotes.isEmpty) {
      return Center(
        child: Text(
          context.loc.noNotesYet,
          style: TextStyle(color: context.colors.textMuted),
        ),
      );
    }

    return ListView.builder(
      itemCount: withNotes.length,
      itemBuilder: (context, i) {
        final c = withNotes[i];
        final mood = c.moodEntry!;
        final dateStr = DateFormat('dd.MM.yyyy').format(c.date);

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: context.colors.bgCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: context.colors.borderLight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${mood.mood.emoji} $dateStr',
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                mood.note,
                style: context.typography.bodySmall,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingsCard(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.borderLight),
      ),
      child: Column(
        children: [
          _buildCompactSettingRow(
            icon: Icons.language_rounded,
            iconColor: colors.primary,
            title: context.loc.languageToggle,
            trailing: ValueListenableBuilder<Locale>(
              valueListenable: LocaleController.instance,
              builder: (ctx, locale, _) {
                final isTr = locale.languageCode == 'tr';
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: colors.bgCardSubtle,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: colors.borderLight),
                  ),
                  child: Text(
                    isTr ? 'TR (Türkçe)' : 'EN (English)',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: colors.primary,
                    ),
                  ),
                );
              },
            ),
            onTap: () => LocaleController.instance.toggleLocale(),
          ),
          Divider(height: 1, thickness: 0.8, color: colors.borderLight.withValues(alpha: 0.6)),
          _buildCompactSettingRow(
            icon: Icons.dark_mode_outlined,
            iconColor: context.isDark ? colors.accentSun : colors.textMuted,
            title: context.loc.themeModeToggle,
            trailing: ValueListenableBuilder<ThemeMode>(
              valueListenable: ThemeController.instance,
              builder: (ctx, mode, _) {
                return Transform.scale(
                  scale: 0.8,
                  child: Switch.adaptive(
                    value: mode == ThemeMode.dark,
                    activeTrackColor: colors.primary,
                    onChanged: (_) => ThemeController.instance.toggleTheme(),
                  ),
                );
              },
            ),
          ),
          Divider(height: 1, thickness: 0.8, color: colors.borderLight.withValues(alpha: 0.6)),
          _buildCompactSettingRow(
            icon: Icons.backup_rounded,
            iconColor: colors.primary,
            title: context.loc.backupData,
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'JSON',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: colors.primary,
                ),
              ),
            ),
            onTap: () => _handleBackupData(context),
          ),
          Divider(height: 1, thickness: 0.8, color: colors.borderLight.withValues(alpha: 0.6)),
          _buildCompactSettingRow(
            icon: Icons.logout_rounded,
            iconColor: Colors.redAccent,
            title: context.loc.logoutAction,
            titleColor: Colors.redAccent,
            trailing: const Icon(Icons.chevron_right_rounded, size: 18, color: Colors.redAccent),
            onTap: () => _confirmLogout(context),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactSettingRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    Color? titleColor,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 2),
        child: Row(
          children: [
            Icon(icon, size: 18, color: iconColor),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: titleColor,
                ),
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }

  Future<void> _handleBackupData(BuildContext context) async {
    final habits = widget.habitsController.habits.value;
    final completions = widget.habitsController.completions.value;
    final badges = widget.habitsController.badges.value;

    final isTr = context.loc.isTr;
    final title = isTr ? 'Bulut & Veri Yedekleme' : 'Cloud & Data Backup';
    final desc = isTr
        ? 'Tüm alışkanlık (${habits.length}), tamamlama (${completions.length}) ve rozet (${badges.length}) kayıtlarınız Cloud Firestore ve yerel güvenli depolama ile senkronize edildi.'
        : 'All habit (${habits.length}), completion (${completions.length}), and badge (${badges.length}) records are safely synced with Cloud Firestore and local storage.';

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFD1FAE5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.cloud_done_rounded, color: Color(0xFF006947), size: 22),
            ),
            const SizedBox(width: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
          ],
        ),
        content: Text(desc, style: const TextStyle(fontSize: 13.5)),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(isTr ? 'Harika' : 'Got it', style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.loc.logoutAction),
        content: Text(context.loc.confirmLogout),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(context.loc.cancelAction),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              context.loc.logoutAction,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await widget.authController.logout();
      if (!context.mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => WelcomePage(authController: widget.authController),
        ),
        (route) => false,
      );
    }
  }
}
