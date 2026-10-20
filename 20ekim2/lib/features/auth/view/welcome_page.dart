import 'package:flutter/material.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/controllers/locale_controller.dart';
import '../../../core/controllers/session_controller.dart';
import '../../../core/controllers/theme_controller.dart';
import '../../../core/extensions/context_extensions.dart';
import 'owner_login_page.dart';
import 'renter_login_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({
    required this.sessionController,
    required this.themeController,
    required this.localeController,
    super.key,
  });

  final SessionController sessionController;
  final ThemeController themeController;
  final LocaleController localeController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            tooltip: 'Dil / Language',
            icon: const Icon(Icons.language_rounded),
            onPressed: () => localeController.toggleLocale(),
          ),
          IconButton(
            tooltip: 'Tema',
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
            ),
            onPressed: () {
              final ThemeMode nextMode = Theme.of(context).brightness == Brightness.dark
                  ? ThemeMode.light
                  : ThemeMode.dark;
              themeController.setThemeMode(nextMode);
            },
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            children: <Widget>[
              const Spacer(flex: 1),
              // Logo & İkon
              Hero(
                tag: 'app_logo',
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: context.colorScheme.primary.withAlpha(50),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(
                    'assets/icons/app_icon.png',
                    fit: BoxFit.cover,
                    errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) => Container(
                      color: context.colorScheme.primary,
                      child: const Icon(
                        Icons.directions_car_rounded,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                context.l10n.appName,
                style: context.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: context.colorScheme.primary,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                context.l10n.appSlogan,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(flex: 2),
              // Kiracı Butonu
              _RoleCard(
                title: context.l10n.roleRenterButton,
                description: context.l10n.roleRenterDescription,
                icon: Icons.key_rounded,
                isPrimary: true,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => RenterLoginPage(
                        sessionController: sessionController,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.md),
              // Araç Sahibi Butonu
              _RoleCard(
                title: context.l10n.roleOwnerButton,
                description: context.l10n.roleOwnerDescription,
                icon: Icons.garage_rounded,
                isPrimary: false,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => OwnerLoginPage(
                        sessionController: sessionController,
                      ),
                    ),
                  );
                },
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.isPrimary,
    required this.onTap,
  });

  final String title;
  final String description;
  final IconData icon;
  final bool isPrimary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isPrimary
          ? context.colorScheme.primaryContainer.withAlpha(80)
          : context.colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: BorderSide(
          color: isPrimary
              ? context.colorScheme.primary
              : context.colorScheme.outlineVariant,
          width: isPrimary ? 1.5 : 1.0,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: isPrimary
                      ? context.colorScheme.primary
                      : context.colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(
                  icon,
                  color: isPrimary
                      ? context.colorScheme.onPrimary
                      : context.colorScheme.onSecondaryContainer,
                  size: 26,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: context.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      description,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: context.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
