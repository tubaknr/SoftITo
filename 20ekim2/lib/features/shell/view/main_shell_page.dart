import 'package:flutter/material.dart';
import '../../../core/controllers/session_controller.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../my_vehicles/view/my_vehicles_page.dart';
import '../../owner_profile/view/owner_profile_page.dart';
import '../../renter_profile/view/renter_profile_page.dart';
import '../../reservation/view/reservations_page.dart';
import '../../vehicle_list/controller/vehicle_list_controller.dart';
import '../../vehicle_list/view/vehicle_list_page.dart';

class MainShellPage extends StatefulWidget {
  const MainShellPage({
    required this.sessionController,
    super.key,
  });

  final SessionController sessionController;

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  int _currentIndex = 0;
  late final VehicleListController _vehicleListController;

  @override
  void initState() {
    super.initState();
    _vehicleListController = VehicleListController();
  }

  @override
  void dispose() {
    _vehicleListController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<SessionState>(
      valueListenable: widget.sessionController,
      builder: (BuildContext ctx, SessionState session, _) {
        final bool isOwner = session.isOwner;

        // Sekmeler listesi
        final List<Widget> pages = isOwner
            ? <Widget>[
                VehicleListPage(
                  controller: _vehicleListController,
                  sessionController: widget.sessionController,
                ),
                MyVehiclesPage(
                  sessionController: widget.sessionController,
                ),
                ReservationsPage(
                  sessionController: widget.sessionController,
                ),
                OwnerProfilePage(
                  sessionController: widget.sessionController,
                  ownerId: session.userId,
                  isOwnProfile: true,
                ),
              ]
            : <Widget>[
                VehicleListPage(
                  controller: _vehicleListController,
                  sessionController: widget.sessionController,
                ),
                ReservationsPage(
                  sessionController: widget.sessionController,
                ),
                RenterProfilePage(
                  sessionController: widget.sessionController,
                  renterId: session.userId,
                  isOwnProfile: true,
                ),
              ];

        // İndeks taşmasını önleme
        final int safeIndex = _currentIndex >= pages.length ? 0 : _currentIndex;

        return Scaffold(
          body: IndexedStack(
            index: safeIndex,
            children: pages,
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: safeIndex,
            onDestinationSelected: (int idx) => setState(() => _currentIndex = idx),
            destinations: isOwner
                ? <NavigationDestination>[
                    NavigationDestination(
                      icon: const Icon(Icons.directions_car_outlined),
                      selectedIcon: const Icon(Icons.directions_car_rounded),
                      label: context.l10n.navVehicles,
                    ),
                    NavigationDestination(
                      icon: const Icon(Icons.garage_outlined),
                      selectedIcon: const Icon(Icons.garage_rounded),
                      label: context.l10n.navMyVehicles,
                    ),
                    NavigationDestination(
                      icon: const Icon(Icons.event_note_outlined),
                      selectedIcon: const Icon(Icons.event_note_rounded),
                      label: context.l10n.navReservations,
                    ),
                    NavigationDestination(
                      icon: const Icon(Icons.person_outline_rounded),
                      selectedIcon: const Icon(Icons.person_rounded),
                      label: context.l10n.navProfile,
                    ),
                  ]
                : <NavigationDestination>[
                    NavigationDestination(
                      icon: const Icon(Icons.directions_car_outlined),
                      selectedIcon: const Icon(Icons.directions_car_rounded),
                      label: context.l10n.navVehicles,
                    ),
                    NavigationDestination(
                      icon: const Icon(Icons.event_note_outlined),
                      selectedIcon: const Icon(Icons.event_note_rounded),
                      label: context.l10n.navReservations,
                    ),
                    NavigationDestination(
                      icon: const Icon(Icons.person_outline_rounded),
                      selectedIcon: const Icon(Icons.person_rounded),
                      label: context.l10n.navProfile,
                    ),
                  ],
          ),
        );
      },
    );
  }
}
