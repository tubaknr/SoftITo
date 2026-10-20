import 'package:flutter/material.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/controllers/locale_controller.dart';
import '../../../core/controllers/session_controller.dart';
import '../../../core/controllers/theme_controller.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/section_header.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    required this.sessionController,
    this.themeController,
    this.localeController,
    super.key,
  });

  final SessionController sessionController;
  final ThemeController? themeController;
  final LocaleController? localeController;

  Future<void> _logout(BuildContext context) async {
    final bool? confirmed = await ConfirmDialog.show(
      context: context,
      title: context.l10n.logoutConfirmTitle,
      content: context.l10n.logoutConfirmMessage,
      confirmLabel: context.l10n.logoutButton,
      isDestructive: true,
    );

    if (confirmed == true && context.mounted) {
      await sessionController.logout();
      if (!context.mounted) return;
      Navigator.of(context).popUntil((Route<dynamic> r) => r.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.settingsTitle),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: <Widget>[
            // Tema Bölümü
            SectionHeader(title: context.l10n.themeTitle),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SegmentedButton<ThemeMode>(
                      segments: <ButtonSegment<ThemeMode>>[
                        ButtonSegment<ThemeMode>(
                          value: ThemeMode.system,
                          icon: const Icon(Icons.brightness_auto_rounded),
                          label: Text(context.l10n.themeSystem),
                        ),
                        ButtonSegment<ThemeMode>(
                          value: ThemeMode.light,
                          icon: const Icon(Icons.light_mode_rounded),
                          label: Text(context.l10n.themeLight),
                        ),
                        ButtonSegment<ThemeMode>(
                          value: ThemeMode.dark,
                          icon: const Icon(Icons.dark_mode_rounded),
                          label: Text(context.l10n.themeDark),
                        ),
                      ],
                      selected: <ThemeMode>{
                        themeController?.value ??
                            (brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light)
                      },
                      onSelectionChanged: (Set<ThemeMode> newSelection) {
                        themeController?.setThemeMode(newSelection.first);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Dil Bölümü
            SectionHeader(title: context.l10n.languageTitle),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SegmentedButton<String>(
                      segments: <ButtonSegment<String>>[
                        ButtonSegment<String>(
                          value: 'tr',
                          icon: const Icon(Icons.flag_rounded),
                          label: Text(context.l10n.languageTr),
                        ),
                        ButtonSegment<String>(
                          value: 'en',
                          icon: const Icon(Icons.language_rounded),
                          label: Text(context.l10n.languageEn),
                        ),
                      ],
                      selected: <String>{
                        localeController?.value.languageCode ??
                            Localizations.localeOf(context).languageCode
                      },
                      onSelectionChanged: (Set<String> newSelection) {
                        localeController?.setLocale(Locale(newSelection.first));
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),

            // Çıkış Yap Butonu
            FilledButton.tonalIcon(
              style: FilledButton.styleFrom(
                backgroundColor: context.colorScheme.errorContainer,
                foregroundColor: context.colorScheme.onErrorContainer,
              ),
              onPressed: () => _logout(context),
              icon: const Icon(Icons.logout_rounded),
              label: Text(context.l10n.logoutButton),
            ),
          ],
        ),
      ),
    );
  }
}
