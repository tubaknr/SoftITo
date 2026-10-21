import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../l10n/app_localizations.dart';
import '../l10n/locale_controller.dart';
import '../theme/app_typography.dart';
import '../theme/theme_controller.dart';
import 'flower_painter.dart';

/// Focus & Grow şeffaf üst bar bileşeni.
class FGTopBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isAuthFlow;
  final bool showBackButton;
  final String? userName;
  final FlowerStage? userFlowerStage;
  final VoidCallback? onBack;

  const FGTopBar({
    super.key,
    this.isAuthFlow = false,
    this.showBackButton = false,
    this.userName,
    this.userFlowerStage,
    this.onBack,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final loc = AppLocalizations.of(context);

    return SafeArea(
      bottom: false,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            // Sol Taraf: Geri butonu veya Kullanıcı Karşılama Alanı
            if (showBackButton)
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 20,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
                ),
                onPressed: onBack ?? () => Navigator.of(context).maybePop(),
              )
            else if (!isAuthFlow)
              Expanded(
                child: Row(
                  children: [
                    // Kişiye özel mini çiçek logosu / avatar
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark
                            ? AppColors.darkCardSurface
                            : Colors.white.withValues(alpha: 0.8),
                        border: Border.all(
                          color: AppColors.dustyRoseAccent.withValues(alpha: 0.5),
                          width: 1.2,
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: CustomPaint(
                        painter: FlowerPainter(
                          stage: userFlowerStage ?? FlowerStage.sprout,
                          animationProgress: 0.2,
                          isDark: isDark,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // "Hoşgeldin, [İsim]"
                    Flexible(
                      child: RichText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${loc.welcomeHeader} ',
                              style: AppTypography.heading1Light(isDark: isDark)
                                  .copyWith(fontSize: 16),
                            ),
                            TextSpan(
                              text: userName?.isNotEmpty == true
                                  ? userName!
                                  : 'Doğa Dostu',
                              style: AppTypography.heading1Bold(isDark: isDark)
                                  .copyWith(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              const Spacer(),

            // Sağ Taraf: Tema Switcher & TR/EN Dil Seçici
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Tema Değiştirici (Güneş / Ay)
                ValueListenableBuilder<ThemeMode>(
                  valueListenable: ThemeController.instance,
                  builder: (context, themeMode, _) {
                    final isDarkMode = themeMode == ThemeMode.dark;
                    return IconButton(
                      tooltip: isDarkMode ? 'Aydınlık Mod' : 'Karanlık Mod',
                      icon: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) =>
                            RotationTransition(turns: animation, child: child),
                        child: Icon(
                          isDarkMode
                              ? Icons.wb_sunny_rounded
                              : Icons.nightlight_round,
                          key: ValueKey(isDarkMode),
                          color: isDarkMode
                              ? const Color(0xFFFFD54F)
                              : AppColors.textCharcoal,
                          size: 22,
                        ),
                      ),
                      onPressed: () => ThemeController.instance.toggleTheme(),
                    );
                  },
                ),
                const SizedBox(width: 4),

                // TR | EN Dil Seçici Pill
                ValueListenableBuilder<Locale>(
                  valueListenable: LocaleController.instance,
                  builder: (context, locale, _) {
                    final isTr = locale.languageCode == 'tr';
                    return GestureDetector(
                      onTap: () => LocaleController.instance.toggleLocale(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkCardSurface.withValues(alpha: 0.9)
                              : Colors.white.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.dustyRoseAccent.withValues(alpha: 0.4),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'TR',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight:
                                    isTr ? FontWeight.bold : FontWeight.normal,
                                color: isTr
                                    ? AppColors.dustyRoseAccent
                                    : (isDark
                                        ? AppColors.darkTextMuted
                                        : AppColors.textMuted),
                              ),
                            ),
                            Text(
                              ' | ',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                color: isDark
                                    ? AppColors.darkTextMuted
                                    : AppColors.textMuted,
                              ),
                            ),
                            Text(
                              'EN',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight:
                                    !isTr ? FontWeight.bold : FontWeight.normal,
                                color: !isTr
                                    ? AppColors.dustyRoseAccent
                                    : (isDark
                                        ? AppColors.darkTextMuted
                                        : AppColors.textMuted),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
