import 'package:flutter/material.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/gradient_scaffold.dart';
import '../../onboarding/view/welcome_page.dart';
import '../controller/settings_controller.dart';
import '../widget/settings_dialogs.dart';
import '../widget/settings_section_card.dart';
import '../widget/settings_tile.dart';

/// SettingsView displays the 4 core settings: Language, Theme Mode, Backup Data, Logout.
/// Complies with `project.md` Section 8: clean architecture, <= 40 lines build method.
class SettingsView extends StatelessWidget {
  const SettingsView({super.key, required this.controller});

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: SafeArea(
        child: Column(
          children: [
            _SettingsHeaderBar(title: context.loc.settingsTitle),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    _AppearanceSection(controller: controller),
                    const SizedBox(height: 18),
                    _DataSection(controller: controller),
                    const SizedBox(height: 18),
                    _AccountSection(controller: controller),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsHeaderBar extends StatelessWidget {
  const _SettingsHeaderBar({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: context.colors.textMain, size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 4),
          Text(
            title,
            style: context.typography.titleLarge?.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: context.colors.textMain,
            ),
          ),
        ],
      ),
    );
  }
}

class _AppearanceSection extends StatelessWidget {
  const _AppearanceSection({required this.controller});

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SettingsSectionCard(
      title: context.loc.appearanceSection,
      children: [
        ValueListenableBuilder<Locale>(
          valueListenable: controller.localeNotifier,
          builder: (ctx, locale, _) {
            final isTr = locale.languageCode == 'tr';
            return SettingsTile(
              icon: Icons.language_rounded,
              iconColor: colors.primary,
              title: context.loc.languageToggle,
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: colors.bgCardSubtle,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: colors.borderLight),
                ),
                child: Text(
                  isTr ? 'TR (Türkçe)' : 'EN (English)',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: colors.primary,
                  ),
                ),
              ),
              onTap: () => controller.toggleLocale(),
            );
          },
        ),
        ValueListenableBuilder<ThemeMode>(
          valueListenable: controller.themeModeNotifier,
          builder: (ctx, mode, _) {
            final isDark = mode == ThemeMode.dark;
            return SettingsTile(
              icon: Icons.dark_mode_outlined,
              iconColor: isDark ? colors.accentSun : colors.textMuted,
              title: context.loc.themeModeToggle,
              trailing: Transform.scale(
                scale: 0.85,
                child: Switch.adaptive(
                  value: isDark,
                  activeTrackColor: colors.primary,
                  onChanged: (_) => controller.toggleTheme(),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _DataSection extends StatelessWidget {
  const _DataSection({required this.controller});

  final SettingsController controller;

  Future<void> _onBackupPressed(BuildContext context) async {
    final result = await controller.backupData();
    if (!context.mounted) return;
    await SettingsBackupDialog.show(context, result);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SettingsSectionCard(
      title: context.loc.dataSection,
      children: [
        SettingsTile(
          icon: Icons.cloud_upload_rounded,
          iconColor: colors.primary,
          title: context.loc.backupData,
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'JSON',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: colors.primary,
              ),
            ),
          ),
          onTap: () => _onBackupPressed(context),
        ),
      ],
    );
  }
}

class _AccountSection extends StatelessWidget {
  const _AccountSection({required this.controller});

  final SettingsController controller;

  Future<void> _onLogoutPressed(BuildContext context) async {
    final confirmed = await SettingsLogoutDialog.show(context);
    if (confirmed == true) {
      await controller.logout();
      if (!context.mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => WelcomePage(authController: controller.authController),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SettingsSectionCard(
      title: context.loc.accountSection,
      children: [
        SettingsTile(
          icon: Icons.logout_rounded,
          iconColor: Colors.redAccent,
          title: context.loc.logoutAction,
          titleColor: Colors.redAccent,
          trailing: const Icon(Icons.chevron_right_rounded, size: 20, color: Colors.redAccent),
          onTap: () => _onLogoutPressed(context),
        ),
      ],
    );
  }
}
