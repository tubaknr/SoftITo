import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/flower_painter.dart';
import '../../auth/controller/auth_controller.dart';
import '../../auth/models/user_model.dart';
import '../../auth/view/welcome_page.dart';
import '../../focus/controller/focus_controller.dart';
import '../../shell/controller/shell_controller.dart';
import '../widget/profile_stats_card.dart';

/// Kullanıcının Kendi Profil ve Ayarlar Sayfası (Sekme 4)
class ProfilePage extends StatelessWidget {
  final VoidCallback onLogoutOrDelete;

  const ProfilePage({super.key, required this.onLogoutOrDelete});

  void _showResetStatsDialog(BuildContext context) {
    final loc = context.loc;
    final isDark = context.isDark;

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor:
              isDark ? AppColors.darkCardSurface : const Color(0xFFFFFDF8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text(
            loc.resetStatsDialogTitle,
            style: AppTypography.heading2(isDark: isDark),
          ),
          content: Text(
            loc.resetStatsDialogMessage,
            style: AppTypography.body(isDark: isDark),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(loc.cancel, style: const TextStyle(color: AppColors.textMuted)),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.dustyRoseAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                await FocusController.instance.clearAllData();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(loc.resetSuccess),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  );
                }
              },
              child: Text(loc.confirm, style: const TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    final loc = context.loc;
    final isDark = context.isDark;

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor:
              isDark ? AppColors.darkCardSurface : const Color(0xFFFFFDF8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text(
            loc.deleteAccountDialogTitle,
            style: AppTypography.heading2(isDark: isDark).copyWith(
              color: AppColors.coralRedError,
            ),
          ),
          content: Text(
            loc.deleteAccountDialogMessage,
            style: AppTypography.body(isDark: isDark),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(loc.cancel, style: const TextStyle(color: AppColors.textMuted)),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.coralRedError,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                await AuthController.instance.deleteAccount();
                await FocusController.instance.clearAllData();
                onLogoutOrDelete();
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (_) => WelcomePage(
                        onLoginSuccess: () {
                          ShellController.instance.resetToHome();
                        },
                      ),
                    ),
                    (route) => false,
                  );
                }
              },
              child: Text(loc.confirm, style: const TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final loc = context.loc;
    final isDark = context.isDark;

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor:
              isDark ? AppColors.darkCardSurface : const Color(0xFFFFFDF8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text(
            loc.logoutDialogTitle,
            style: AppTypography.heading2(isDark: isDark).copyWith(
              color: AppColors.coralRedError,
            ),
          ),
          content: Text(
            loc.logoutDialogMessage,
            style: AppTypography.body(isDark: isDark),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(loc.cancel, style: const TextStyle(color: AppColors.textMuted)),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.coralRedError,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                await AuthController.instance.logout();
                onLogoutOrDelete();
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (_) => WelcomePage(
                        onLoginSuccess: () {
                          ShellController.instance.resetToHome();
                        },
                      ),
                    ),
                    (route) => false,
                  );
                }
              },
              child: Text(loc.confirm, style: const TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    final isDark = context.isDark;

    return ValueListenableBuilder<UserModel?>(
      valueListenable: AuthController.instance,
      builder: (context, user, _) {
        final userName = user?.name ?? 'Doğa Dostu';
        final userAge = user?.age ?? 25;
        final isPrivate = user?.isPrivate ?? false;

        return ValueListenableBuilder<List<dynamic>>(
          valueListenable: FocusController.instance,
          builder: (context, _, __) {
            final stage = FocusController.instance.currentFlowerStage;
            final todaySeconds = FocusController.instance.todayFocusSeconds;
            final totalSeconds = FocusController.instance.totalFocusSeconds;
            final weeklySeconds = (todaySeconds * 5).clamp(0, totalSeconds);

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Column(
                children: [
                  // Profil Avatarı
                  Center(
                    child: Container(
                      width: 86,
                      height: 86,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark
                            ? AppColors.darkCardSurface
                            : Colors.white.withValues(alpha: 0.9),
                        border: Border.all(
                          color: AppColors.dustyRoseAccent,
                          width: 2,
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: CustomPaint(
                        painter: FlowerPainter(
                          stage: stage,
                          animationProgress: 0.4,
                          isDark: isDark,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // İsim ve Yaş
                  Text(
                    '$userName, $userAge',
                    style: AppTypography.heading1Bold(isDark: isDark).copyWith(
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 4),

                  Text(
                    user?.email ?? '',
                    style: AppTypography.mottoText(isDark: isDark).copyWith(
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Kullanıcının Çiçeğinin Son Durumu
                  Center(
                    child: FlowerView(
                      stage: stage,
                      size: 200,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Kişisel İstatistikler (Public Profile ile aynı bileşen)
                  ProfileStatsCard(
                    dailySeconds: todaySeconds,
                    weeklySeconds: weeklySeconds,
                    yearlySeconds: totalSeconds,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 20),

                  // Gizlilik Toggle Kartı: "Hesabını toplulukta gösterme"
                  Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkCardSurface.withValues(alpha: 0.85)
                          : Colors.white.withValues(alpha: 0.75),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.1)
                            : Colors.white.withValues(alpha: 0.8),
                        width: 1.2,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      child: SwitchListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        title: Text(
                          loc.hideInCommunity,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.textCharcoal,
                          ),
                        ),
                        activeThumbColor: AppColors.dustyRoseAccent,
                        value: isPrivate,
                        onChanged: (val) {
                          AuthController.instance.togglePrivacy(val);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // "İstatistikleri Sil" Butonu
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textCharcoal,
                      minimumSize: const Size(double.infinity, 50),
                      side: BorderSide(
                        color: AppColors.dustyRoseAccent.withValues(alpha: 0.6),
                        width: 1.2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    icon: const Icon(Icons.refresh_rounded, size: 20),
                    label: Text(
                      loc.resetStatsButton,
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () => _showResetStatsDialog(context),
                  ),
                  const SizedBox(height: 14),

                  // "Hesabı Sil" Butonu
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.coralRedError,
                      minimumSize: const Size(double.infinity, 50),
                      side: const BorderSide(
                        color: AppColors.coralRedError,
                        width: 1.2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    icon: const Icon(Icons.delete_forever_rounded, size: 20),
                    label: Text(
                      loc.deleteAccountButton,
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onPressed: () => _showDeleteAccountDialog(context),
                  ),
                  const SizedBox(height: 14),

                  // "Çıkış Yap" Butonu
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.coralRedError,
                      minimumSize: const Size(double.infinity, 50),
                      side: const BorderSide(
                        color: AppColors.coralRedError,
                        width: 1.2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    icon: const Icon(Icons.logout_rounded, size: 20),
                    label: Text(
                      loc.logoutButton,
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onPressed: () => _showLogoutDialog(context),
                  ),
                  const SizedBox(height: 100), // Alt bar payı
                ],
              ),
            );
          },
        );
      },
    );
  }
}
