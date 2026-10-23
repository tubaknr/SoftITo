import 'package:flutter/material.dart';
import '../../../core/firebase/repository_factory.dart';
import '../../../core/services/date_time_service.dart';
import '../../../core/services/local_store.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/widgets/gradient_scaffold.dart';
import '../../analytics/view/analytics_page.dart';
import '../../auth/controller/auth_controller.dart';
import '../../calendar/view/calendar_page.dart';
import '../../habits/controller/habits_controller.dart';
import '../../habits/data/habits_repository.dart';
import '../../home/view/home_page.dart';
import '../../notifications/controller/notifications_controller.dart';
import '../../profile/view/profile_page.dart';
import '../controller/shell_controller.dart';
import '../widget/app_bottom_bar.dart';
import '../widget/app_top_bar.dart';

/// Main Shell container with IndexedStack tabs, AppTopBar, and AppBottomBar
class ShellPage extends StatefulWidget {
  const ShellPage({
    super.key,
    required this.authController,
    this.habitsController,
    this.notificationsController,
  });

  final AuthController authController;
  final HabitsController? habitsController;
  final NotificationsController? notificationsController;

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  late final ShellController _shellController;
  late final HabitsController _habitsController;
  late final NotificationsController _notificationsController;

  @override
  void initState() {
    super.initState();
    _shellController = ShellController();

    const localStore = SharedPreferencesLocalStore();
    const dateTimeService = DefaultDateTimeService();
    final notifService = MockNotificationService();

    _notificationsController = widget.notificationsController ??
        NotificationsController(
          localStore: localStore,
          notificationService: notifService,
        );
    _notificationsController.init();

    final currentUserId = widget.authController.currentUser.value?.id;
    _habitsController = widget.habitsController ??
        HabitsController(
          repository: RepositoryFactory.createHabitsRepository(
            userId: currentUserId,
            localStore: localStore,
            dateTimeService: dateTimeService,
          ),
          dateTimeService: dateTimeService,
        );
    _habitsController.loadData();
  }

  @override
  void dispose() {
    _shellController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Column(
            children: [
              AppTopBar(
                authController: widget.authController,
                notificationsController: _notificationsController,
              ),
              Expanded(
                child: ValueListenableBuilder<int>(
                  valueListenable: _shellController,
                  builder: (context, activeIndex, _) {
                    return IndexedStack(
                      index: activeIndex,
                      children: [
                        HomePage(controller: _habitsController),
                        CalendarPage(controller: _habitsController),
                        AnalyticsPage(controller: _habitsController),
                        ProfilePage(
                          authController: widget.authController,
                          habitsController: _habitsController,
                          notificationsController: _notificationsController,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AppBottomBar(controller: _shellController),
          ),
        ],
      ),
    );
  }
}
