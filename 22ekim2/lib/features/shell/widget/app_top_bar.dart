import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../auth/controller/auth_controller.dart';
import '../../notifications/controller/notifications_controller.dart';
import '../../notifications/widget/notification_settings_sheet.dart';

/// Common top bar widget across authenticated screens matching Stitch design
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({
    super.key,
    required this.authController,
    required this.notificationsController,
  });

  final AuthController authController;
  final NotificationsController notificationsController;

  @override
  Size get preferredSize => const Size.fromHeight(68);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: context.padding.top + 6,
        left: 18,
        right: 18,
        bottom: 8,
      ),
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildLeadingAvatarAndGreeting(context),
          _buildActionControls(context),
        ],
      ),
    );
  }

  Widget _buildLeadingAvatarAndGreeting(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: authController.currentUser,
      builder: (context, user, _) {
        final displayName = user?.name.split(' ').first ?? 'Ayşe';
        final initial = displayName.isNotEmpty ? displayName[0].toUpperCase() : 'A';

        return Row(
          children: [
            _buildAvatarWithSprout(context, initial),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      context.loc.smallSteps,
                      style: context.typography.bodySmall?.copyWith(
                        color: context.colors.textMuted,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text('🐧', style: TextStyle(fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 1),
                Text(
                  context.loc.welcomeUser(displayName),
                  style: context.typography.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: context.colors.textMain,
                    fontSize: 18,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildAvatarWithSprout(BuildContext context, String initial) {
    final colors = context.colors;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 42,
          height: 42,
          padding: const EdgeInsets.all(2),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.lightPrimaryLight, AppColors.lightSuccess],
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
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: colors.primary,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -1,
          right: -1,
          child: Container(
            width: 13,
            height: 13,
            decoration: BoxDecoration(
              color: colors.success,
              shape: BoxShape.circle,
              border: Border.all(color: colors.bgCard, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionControls(BuildContext context) {
    return _buildNotificationBell(context);
  }

  Widget _buildNotificationBell(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: Icon(
            Icons.notifications_none_rounded,
            color: context.colors.textMain,
            size: 22,
          ),
          onPressed: () {
            NotificationSettingsSheet.show(
              context,
              controller: notificationsController,
            );
          },
        ),
        Positioned(
          top: 10,
          right: 10,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.redAccent,
              shape: BoxShape.circle,
              border: Border.all(color: context.colors.bgCard, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
