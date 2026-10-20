import 'package:flutter/material.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/controllers/session_controller.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/section_header.dart';
import '../../owner_profile/view/owner_profile_page.dart';
import '../../renter_profile/view/renter_profile_page.dart';
import '../../vehicle_list/data/mock_vehicle_data.dart';
import '../../vehicle_list/models/enums.dart';
import '../../vehicle_list/models/vehicle.dart';
import '../controller/mock_traffic_service.dart';
import '../data/mock_reservation_data.dart';
import '../models/reservation.dart';

class ReservationDetailPage extends StatefulWidget {
  const ReservationDetailPage({
    required this.reservation,
    required this.sessionController,
    super.key,
  });

  final Reservation reservation;
  final SessionController sessionController;

  @override
  State<ReservationDetailPage> createState() => _ReservationDetailPageState();
}

class _ReservationDetailPageState extends State<ReservationDetailPage> {
  late Reservation _reservation;

  @override
  void initState() {
    super.initState();
    _reservation = widget.reservation;
  }

  Future<void> _cancelReservation() async {
    final bool? confirmed = await ConfirmDialog.show(
      context: context,
      title: 'Rezervasyonu İptal Et',
      content: 'Bu rezervasyonu iptal etmek istediğinize emin misiniz? Bu işlem geri alınamaz.',
      confirmLabel: 'Rezervasyonu İptal Et',
      isDestructive: true,
    );

    if (confirmed == true && mounted) {
      setState(() {
        _reservation = _reservation.copyWith(status: ReservationStatus.cancelled);
      });
      // Mock veriyi de güncelle
      final int idx = MockReservationData.reservations.indexWhere((Reservation r) => r.id == _reservation.id);
      if (idx != -1) {
        MockReservationData.reservations[idx] = _reservation;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rezervasyon başarıyla iptal edildi.')),
      );
    }
  }

  Future<void> _simulateDelay() async {
    final MockTrafficService trafficService = MockTrafficService(
      notificationController: NotificationController(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('MockTrafficService anlık trafik verisini hesaplıyor...'),
        duration: Duration(seconds: 1),
      ),
    );

    final int delay = await trafficService.simulateDelay(
      partyName: 'Kiracı Ahmet Y.',
      destination: _reservation.pickupLocation,
    );

    if (!mounted) return;

    showDialog<void>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        icon: const Icon(Icons.traffic_rounded, color: Colors.orange, size: 48),
        title: Text(context.l10n.simulateDelayDialogTitle),
        content: Text(
          'Trafik yoğunluğu simülasyonuna göre tahmini gecikme: $delay dakika.\n\nKarşı tarafa uygulama içi bilgilendirme gönderildi: "Ahmet Y. buluşma noktasına yaklaşık $delay dakika geç kalacak."',
        ),
        actions: <Widget>[
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(context.l10n.dialogClose),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Vehicle? vehicle = MockVehicleData.vehicles
        .cast<Vehicle?>()
        .firstWhere((Vehicle? v) => v?.id == _reservation.vehicleId, orElse: () => null);

    final bool isCompletedOrCancelled =
        _reservation.status == ReservationStatus.completed ||
        _reservation.status == ReservationStatus.cancelled;

    Color statusColor = context.appColors.success;
    if (_reservation.status == ReservationStatus.cancelled) {
      statusColor = context.appColors.danger;
    } else if (_reservation.status == ReservationStatus.pending) {
      statusColor = context.appColors.warning;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.reservationDetailTitle),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Durum Rozeti
              Card(
                color: statusColor.withAlpha(25),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  side: BorderSide(color: statusColor.withAlpha(90)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(Icons.info_outline_rounded, color: statusColor, size: 20),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            context.l10n.reservationStatusLabel,
                            style: TextStyle(fontWeight: FontWeight.w600, color: statusColor),
                          ),
                        ],
                      ),
                      Text(
                        _reservation.status.localized(context.l10n),
                        style: TextStyle(fontWeight: FontWeight.w800, color: statusColor),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Araç Kartı
              SectionHeader(title: 'Kiralama Aracı'),
              Card(
                child: ListTile(
                  leading: Icon(
                    vehicle?.type.icon ?? Icons.directions_car_rounded,
                    size: 32,
                    color: context.colorScheme.primary,
                  ),
                  title: Text(vehicle?.fullName ?? 'Araç Detayı', style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Text('Plaka: ${vehicle?.plate ?? ''}'),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Tarihler ve Yerler
              SectionHeader(title: 'Teslimat & Lokasyon'),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    children: <Widget>[
                      _DetailRow(
                        icon: Icons.location_on_rounded,
                        label: 'Teslim Alma:',
                        value: '${_reservation.pickupLocation}\n${_reservation.pickupDateTime.day}.${_reservation.pickupDateTime.month}.${_reservation.pickupDateTime.year} ${_reservation.pickupDateTime.hour.toString().padLeft(2, '0')}:${_reservation.pickupDateTime.minute.toString().padLeft(2, '0')}',
                      ),
                      const Divider(height: AppSpacing.lg),
                      _DetailRow(
                        icon: Icons.location_on_outlined,
                        label: 'Teslim Etme:',
                        value: '${_reservation.returnLocation}\n${_reservation.returnDateTime.day}.${_reservation.returnDateTime.month}.${_reservation.returnDateTime.year} ${_reservation.returnDateTime.hour.toString().padLeft(2, '0')}:${_reservation.returnDateTime.minute.toString().padLeft(2, '0')}',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Ödeme Durumu ve Tutar
              SectionHeader(title: 'Ödeme Detayı'),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(context.l10n.paymentStatusLabel, style: context.textTheme.labelSmall),
                          Text(
                            _reservation.paymentStatus.localized(context.l10n),
                            style: TextStyle(
                              color: _reservation.paymentStatus == PaymentStatus.paid
                                  ? context.appColors.success
                                  : context.appColors.warning,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '₺${_reservation.totalPrice.toStringAsFixed(0)}',
                        style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: context.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Karşı Taraf Profili Kısayolu
              SectionHeader(title: 'İlgili Kişiler'),
              Card(
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person_rounded)),
                  title: const Text('Araç Sahibi Profili'),
                  subtitle: const Text('Mehmet K. profilini görüntüle'),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => OwnerProfilePage(
                          sessionController: widget.sessionController,
                          ownerId: _reservation.ownerId,
                          isOwnProfile: false,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Card(
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.badge_rounded)),
                  title: const Text('Kiracı Profili'),
                  subtitle: const Text('Ahmet Y. profilini görüntüle'),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => RenterProfilePage(
                          sessionController: widget.sessionController,
                          renterId: _reservation.renterId,
                          isOwnProfile: false,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Gecikme Simülasyonu Butonu
              OutlinedButton.icon(
                onPressed: _simulateDelay,
                icon: const Icon(Icons.schedule_rounded),
                label: Text(context.l10n.simulateDelayButton),
              ),
              const SizedBox(height: AppSpacing.md),

              // Rezervasyonu İptal Et Butonu
              if (!isCompletedOrCancelled)
                FilledButton.tonal(
                  style: FilledButton.styleFrom(
                    backgroundColor: context.colorScheme.errorContainer,
                    foregroundColor: context.colorScheme.onErrorContainer,
                  ),
                  onPressed: _cancelReservation,
                  child: Text(context.l10n.cancelReservationButton),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(icon, size: 20, color: context.colorScheme.primary),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                label,
                style: context.textTheme.labelSmall?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                value,
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
