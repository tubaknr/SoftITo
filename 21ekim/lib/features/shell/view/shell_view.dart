import 'package:flutter/material.dart';
import '../../../core/widgets/fg_bottom_bar.dart';
import '../../../core/widgets/fg_top_bar.dart';
import '../../../core/widgets/gradient_scaffold.dart';
import '../../auth/controller/auth_controller.dart';
import '../../auth/models/user_model.dart';
import '../../community/view/community_page.dart';
import '../../focus/controller/focus_controller.dart';
import '../../home/view/home_page.dart';
import '../../profile/view/profile_page.dart';
import '../../stats/view/stats_page.dart';
import '../controller/shell_controller.dart';

/// Ana Uygulama Kabuğu (Shell: IndexedStack + Yüzen FGBottomBar + FGTopBar)
class ShellView extends StatelessWidget {
  final VoidCallback onLogoutOrDelete;

  const ShellView({
    super.key,
    required this.onLogoutOrDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<UserModel?>(
      valueListenable: AuthController.instance,
      builder: (context, user, _) {
        return ValueListenableBuilder<List<dynamic>>(
          valueListenable: FocusController.instance,
          builder: (context, _, __) {
            final flowerStage = FocusController.instance.currentFlowerStage;

            return ValueListenableBuilder<int>(
              valueListenable: ShellController.instance,
              builder: (context, currentTab, _) {
                return GradientScaffold(
                  appBar: FGTopBar(
                    isAuthFlow: false,
                    userName: user?.name,
                    userFlowerStage: flowerStage,
                  ),
                  bottomNavigationBar: FGBottomBar(
                    currentIndex: currentTab,
                    onTabSelected: (index) {
                      ShellController.instance.setTab(index);
                    },
                  ),
                  body: IndexedStack(
                    index: currentTab,
                    children: [
                      const HomePage(),
                      const StatsPage(),
                      const CommunityPage(),
                      ProfilePage(onLogoutOrDelete: onLogoutOrDelete),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
