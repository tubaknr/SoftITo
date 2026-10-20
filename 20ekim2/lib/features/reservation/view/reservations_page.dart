import 'package:flutter/material.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/controllers/session_controller.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/empty_state.dart';
import '../../vehicle_list/data/mock_vehicle_data.dart';
import '../../vehicle_list/models/enums.dart';
import '../../vehicle_list/models/vehicle.dart';
import '../data/mock_reservation_data.dart';
import '../models/reservation.dart';
import 'reservation_detail_page.dart';

class ReservationsPage extends StatefulWidget {
  const ReservationsPage({
    required this.sessionController,
    super.key,
  });

  final SessionController sessionController;

  @override
  State<ReservationsPage> createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Reservation> allReservations = MockReservationData.reservations;

    final List<Reservation> upcoming = allReservations.where((Reservation r) {
      return r.status == ReservationStatus.pending ||
          r.status == ReservationStatus.confirmed ||
          r.status == ReservationStatus.active;
    }).toList();

    final List<Reservation> past = allReservations.where((Reservation r) {
      return r.status == ReservationStatus.completed ||
          r.status == ReservationStatus.cancelled;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.reservationsTitle),
        bottom: TabBar(
          controller: _tabController,
          tabs: <Widget>[
            Tab(text: context.l10n.tabUpcoming),
            Tab(text: context.l10n.tabPast),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          _ReservationListView(
            reservations: upcoming,
            sessionController: widget.sessionController,
          ),
          _ReservationListView(
            reservations: past,
            sessionController: widget.sessionController,
          ),
        ],
      ),
    );
  }
}

class _ReservationListView extends StatelessWidget {
  const _ReservationListView({
    required this.reservations,
    required this.sessionController,
  });

  final List<Reservation> reservations;
  final SessionController sessionController;

  @override
  Widget build(BuildContext context) {
    if (reservations.isEmpty) {
      return EmptyState(
        icon: Icons.event_busy_rounded,
        title: context.l10n.emptyReservations,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: reservations.length,
      separatorBuilder: (BuildContext _, int index) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (BuildContext ctx, int index) {
        final Reservation r = reservations[index];
        final Vehicle? vehicle = MockVehicleData.vehicles
            .cast<Vehicle?>()
            .firstWhere((Vehicle? v) => v?.id == r.vehicleId, orElse: () => null);

        Color badgeColor = context.appColors.success;
        if (r.status == ReservationStatus.cancelled) {
          badgeColor = context.appColors.danger;
        } else if (r.status == ReservationStatus.pending) {
          badgeColor = context.appColors.warning;
        }

        return Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => ReservationDetailPage(
                    reservation: r,
                    sessionController: sessionController,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        vehicle?.fullName ?? 'Araç Detayı',
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: badgeColor.withAlpha(25),
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          border: Border.all(color: badgeColor.withAlpha(90)),
                        ),
                        child: Text(
                          r.status.localized(context.l10n),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: badgeColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: <Widget>[
                      Icon(Icons.calendar_today_rounded, size: 14, color: context.colorScheme.onSurfaceVariant),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        '${r.pickupDateTime.day}.${r.pickupDateTime.month}.${r.pickupDateTime.year} - ${r.returnDateTime.day}.${r.returnDateTime.month}.${r.returnDateTime.year}',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: <Widget>[
                      Icon(Icons.location_on_rounded, size: 14, color: context.colorScheme.onSurfaceVariant),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          r.pickupLocation,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const Divider(height: 1),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        r.paymentStatus.localized(context.l10n),
                        style: TextStyle(
                          fontSize: 12,
                          color: r.paymentStatus == PaymentStatus.paid
                              ? context.appColors.success
                              : context.appColors.warning,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '₺${r.totalPrice.toStringAsFixed(0)}',
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: context.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
