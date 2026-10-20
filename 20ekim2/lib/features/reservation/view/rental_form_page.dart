import 'package:flutter/material.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/controllers/session_controller.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/validators/app_validators.dart';
import '../../../core/widgets/section_header.dart';
import '../../owner_profile/data/mock_owner_data.dart';
import '../../owner_profile/models/owner_user.dart';
import '../../renter_profile/data/mock_renter_data.dart';
import '../../renter_profile/models/renter_user.dart';
import '../../vehicle_list/models/enums.dart';
import '../../vehicle_list/models/vehicle.dart';
import '../data/mock_reservation_data.dart';
import '../models/rental_form.dart';
import '../models/reservation.dart';
import '../widget/signature_pad.dart';
import 'reservation_detail_page.dart';

class RentalFormPage extends StatefulWidget {
  const RentalFormPage({
    required this.vehicle,
    required this.selectedRange,
    required this.sessionController,
    super.key,
  });

  final Vehicle vehicle;
  final DateTimeRange selectedRange;
  final SessionController sessionController;

  @override
  State<RentalFormPage> createState() => _RentalFormPageState();
}

class _RentalFormPageState extends State<RentalFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _pickupPlaceCtrl;
  late TextEditingController _returnPlaceCtrl;
  late DateTime _pickupTime;
  late DateTime _returnTime;

  String _paymentMethod = 'card';
  double _fuelLevel = 1.0;
  bool _cameraAcknowledged = false;
  bool _renterSigned = false;
  bool _ownerSigned = false;

  final Map<String, bool> _photos = <String, bool>{
    'front': true,
    'rear': true,
    'right': true,
    'left': true,
  };

  @override
  void initState() {
    super.initState();
    _pickupPlaceCtrl = TextEditingController(text: 'Kadıköy İskele Meydanı, İstanbul');
    _returnPlaceCtrl = TextEditingController(text: 'Kadıköy İskele Meydanı, İstanbul');
    _pickupTime = widget.selectedRange.start.copyWith(hour: 10, minute: 0);
    _returnTime = widget.selectedRange.end.copyWith(hour: 18, minute: 0);
  }

  @override
  void dispose() {
    _pickupPlaceCtrl.dispose();
    _returnPlaceCtrl.dispose();
    super.dispose();
  }

  double get _totalPrice {
    final int days = widget.selectedRange.duration.inDays == 0
        ? 1
        : widget.selectedRange.duration.inDays;
    return days * widget.vehicle.dailyPrice;
  }

  Future<void> _pickDateTime({required bool isPickup}) async {
    final DateTime current = isPickup ? _pickupTime : _returnTime;

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (pickedDate == null || !mounted) return;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(current),
    );
    if (pickedTime == null || !mounted) return;

    setState(() {
      final DateTime combined = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      if (isPickup) {
        _pickupTime = combined;
      } else {
        _returnTime = combined;
      }
    });
  }

  void _simulateOwnerSignature() {
    showDialog<void>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: Text(context.l10n.ownerSignatureLabel),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text('Araç sahibi e-imza simülasyonu:'),
              const SizedBox(height: AppSpacing.md),
              SignaturePad(
                title: 'Araç Sahibi İmzası',
                initialSigned: _ownerSigned,
                onSaved: (bool signed) {
                  setState(() => _ownerSigned = signed);
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitRental() {
    final FormState? form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    if (_returnTime.isBefore(_pickupTime) || _returnTime.isAtSameMomentAs(_pickupTime)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.valReturnAfterPickup),
          backgroundColor: context.appColors.danger,
        ),
      );
      return;
    }

    if (widget.vehicle.hasInteriorCamera && !_cameraAcknowledged) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Lütfen araç içi kamera bilgilendirmesini onaylayınız.'),
          backgroundColor: context.appColors.warning,
        ),
      );
      return;
    }

    if (!_renterSigned || !_ownerSigned) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.valSignaturesRequired),
          backgroundColor: context.appColors.danger,
        ),
      );
      return;
    }

    showDialog<void>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: const Text('Kiralama Onayı'),
        content: Text(
          '${widget.vehicle.fullName} aracı için toplam ₺${_totalPrice.toStringAsFixed(0)} tutarındaki kiralama sözleşmesini onaylıyor musunuz?',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(context.l10n.dialogCancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Diyalog kapa
              _completeBooking();
            },
            child: Text(context.l10n.dialogConfirm),
          ),
        ],
      ),
    );
  }

  void _completeBooking() {
    final OwnerUser? owner = MockOwnerData.getById(widget.vehicle.ownerId);
    final String currentUserId = widget.sessionController.value.userId ?? 'renter_1';
    final RenterUser? renter = MockRenterData.getById(currentUserId);

    final RentalForm form = RentalForm(
      brand: widget.vehicle.brand,
      model: widget.vehicle.model,
      year: widget.vehicle.year,
      plate: widget.vehicle.plate,
      chassisOrIdNo: widget.vehicle.chassisOrIdNo,
      ownerName: owner?.displayName ?? 'Mehmet K.',
      ownerAgeRange: owner?.ageRange ?? '35–44',
      renterName: renter?.displayName ?? 'Ahmet Y.',
      renterAge: renter?.age ?? 42,
      renterOccupation: renter?.occupation ?? 'Yazılım Mimarı',
      pickupPlace: _pickupPlaceCtrl.text.trim(),
      pickupTime: _pickupTime,
      returnPlace: _returnPlaceCtrl.text.trim(),
      returnTime: _returnTime,
      price: _totalPrice,
      paymentMethod: _paymentMethod == 'card'
          ? context.l10n.paymentMethodCard
          : context.l10n.paymentMethodCash,
      paymentSummary: 'Toplam: ₺${_totalPrice.toStringAsFixed(0)} (Ödendi / Provizyon Tamamlandı)',
      insurancePolicyName: widget.vehicle.insurancePolicyName,
      hasInteriorCamera: _cameraAcknowledged,
      fuelLevelBefore: _fuelLevel,
      ownerSigned: _ownerSigned,
      renterSigned: _renterSigned,
    );

    final Reservation newReservation = Reservation(
      id: 'res_${DateTime.now().millisecondsSinceEpoch}',
      vehicleId: widget.vehicle.id,
      ownerId: widget.vehicle.ownerId,
      renterId: currentUserId,
      pickupDateTime: _pickupTime,
      pickupLocation: _pickupPlaceCtrl.text.trim(),
      returnDateTime: _returnTime,
      returnLocation: _returnPlaceCtrl.text.trim(),
      totalPrice: _totalPrice,
      paymentStatus: PaymentStatus.paid,
      status: ReservationStatus.confirmed,
      rentalForm: form,
    );

    MockReservationData.reservations.insert(0, newReservation);

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) => AlertDialog(
        icon: Icon(Icons.check_circle_rounded, color: context.appColors.success, size: 54),
        title: Text(context.l10n.rentalSuccessDialogTitle),
        content: Text(context.l10n.rentalSuccessDialogContent),
        actions: <Widget>[
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Diyaloğu kapat
              Navigator.of(context).pushReplacement(
                MaterialPageRoute<void>(
                  builder: (_) => ReservationDetailPage(
                    reservation: newReservation,
                    sessionController: widget.sessionController,
                  ),
                ),
              );
            },
            child: const Text('Rezervasyon Detayına Git'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final OwnerUser? owner = MockOwnerData.getById(widget.vehicle.ownerId);
    final String currentUserId = widget.sessionController.value.userId ?? 'renter_1';
    final RenterUser renter = MockRenterData.getById(currentUserId) ?? MockRenterData.renters.first;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.rentalFormTitle),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // 1. Araç Bilgileri
                SectionHeader(title: context.l10n.vehicleInfoSection),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      children: <Widget>[
                        _InfoRow(label: 'Araç', value: widget.vehicle.fullName),
                        _InfoRow(label: context.l10n.plateLabel, value: widget.vehicle.plate),
                        _InfoRow(label: context.l10n.chassisLabel, value: widget.vehicle.chassisOrIdNo),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // 2. Araç Sahibi Bilgileri
                SectionHeader(title: context.l10n.ownerInfoSection),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      children: <Widget>[
                        _InfoRow(label: 'Araç Sahibi', value: owner?.displayName ?? 'Mehmet K.'),
                        _InfoRow(label: 'Yaş Aralığı', value: owner?.ageRange ?? '35–44'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // 3. Kiracı Bilgileri
                SectionHeader(title: context.l10n.renterInfoSection),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      children: <Widget>[
                        _InfoRow(label: 'Kiracı Adı', value: renter.displayName),
                        _InfoRow(label: 'Yaş / Meslek', value: '${renter.age} / ${renter.occupation}'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // 4. Teslim Alma
                SectionHeader(title: context.l10n.pickupSection),
                TextFormField(
                  controller: _pickupPlaceCtrl,
                  decoration: InputDecoration(
                    labelText: context.l10n.pickupLocationLabel,
                    prefixIcon: const Icon(Icons.location_on_rounded),
                  ),
                  validator: AppValidators.minLength(3, context.l10n),
                ),
                const SizedBox(height: AppSpacing.sm),
                ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    side: BorderSide(color: context.colorScheme.outlineVariant),
                  ),
                  leading: const Icon(Icons.calendar_today_rounded),
                  title: Text(context.l10n.pickupDateLabel),
                  subtitle: Text(
                    '${_pickupTime.day}.${_pickupTime.month}.${_pickupTime.year} ${_pickupTime.hour.toString().padLeft(2, '0')}:${_pickupTime.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  trailing: const Icon(Icons.edit_rounded, size: 18),
                  onTap: () => _pickDateTime(isPickup: true),
                ),
                const SizedBox(height: AppSpacing.lg),

                // 5. Teslim Etme
                SectionHeader(title: context.l10n.returnSection),
                TextFormField(
                  controller: _returnPlaceCtrl,
                  decoration: InputDecoration(
                    labelText: context.l10n.returnLocationLabel,
                    prefixIcon: const Icon(Icons.location_on_outlined),
                  ),
                  validator: AppValidators.minLength(3, context.l10n),
                ),
                const SizedBox(height: AppSpacing.sm),
                ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    side: BorderSide(color: context.colorScheme.outlineVariant),
                  ),
                  leading: const Icon(Icons.event_available_rounded),
                  title: Text(context.l10n.returnDateLabel),
                  subtitle: Text(
                    '${_returnTime.day}.${_returnTime.month}.${_returnTime.year} ${_returnTime.hour.toString().padLeft(2, '0')}:${_returnTime.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  trailing: const Icon(Icons.edit_rounded, size: 18),
                  onTap: () => _pickDateTime(isPickup: false),
                ),
                const SizedBox(height: AppSpacing.lg),

                // 6. Ücret ve Ödeme
                SectionHeader(title: context.l10n.pricingAndPaymentSection),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(context.l10n.totalPriceLabel, style: context.textTheme.titleMedium),
                            Text(
                              '₺${_totalPrice.toStringAsFixed(0)}',
                              style: context.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: context.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: AppSpacing.lg),
                        Text(context.l10n.paymentMethodLabel, style: context.textTheme.labelMedium),
                        const SizedBox(height: AppSpacing.sm),
                        SegmentedButton<String>(
                          segments: <ButtonSegment<String>>[
                            ButtonSegment<String>(
                              value: 'card',
                              icon: const Icon(Icons.credit_card_rounded),
                              label: Text(context.l10n.paymentMethodCard),
                            ),
                            ButtonSegment<String>(
                              value: 'cash',
                              icon: const Icon(Icons.payments_rounded),
                              label: Text(context.l10n.paymentMethodCash),
                            ),
                          ],
                          selected: <String>{_paymentMethod},
                          onSelectionChanged: (Set<String> s) => setState(() => _paymentMethod = s.first),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // 7. Kiralama Öncesi Dış Fotoğraflar
                SectionHeader(
                  title: context.l10n.photosSection,
                  subtitle: context.l10n.photosSectionDesc,
                ),
                Row(
                  children: _photos.entries.map((MapEntry<String, bool> e) {
                    final String label = e.key == 'front'
                        ? context.l10n.photoFront
                        : (e.key == 'rear'
                            ? context.l10n.photoRear
                            : (e.key == 'right'
                                ? context.l10n.photoRight
                                : context.l10n.photoLeft));
                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                        decoration: BoxDecoration(
                          color: context.colorScheme.surfaceContainer,
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          border: Border.all(color: context.appColors.success),
                        ),
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.check_circle_rounded, color: context.appColors.success, size: 20),
                            const SizedBox(height: AppSpacing.xs),
                            Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppSpacing.lg),

                // 8. Kiralama Öncesi Yakıt Miktarı
                SectionHeader(title: context.l10n.fuelSection),
                SegmentedButton<double>(
                  segments: <ButtonSegment<double>>[
                    ButtonSegment<double>(value: 0.25, label: Text(context.l10n.fuelQuarter)),
                    ButtonSegment<double>(value: 0.50, label: Text(context.l10n.fuelHalf)),
                    ButtonSegment<double>(value: 0.75, label: Text(context.l10n.fuelThreeQuarters)),
                    ButtonSegment<double>(value: 1.0, label: Text(context.l10n.fuelFull)),
                  ],
                  selected: <double>{_fuelLevel},
                  onSelectionChanged: (Set<double> s) => setState(() => _fuelLevel = s.first),
                ),
                const SizedBox(height: AppSpacing.lg),

                // 9. İç Kamera Onayı
                if (widget.vehicle.hasInteriorCamera) ...<Widget>[
                  SectionHeader(title: context.l10n.cameraSection),
                  CheckboxListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      side: BorderSide(color: context.colorScheme.outlineVariant),
                    ),
                    value: _cameraAcknowledged,
                    onChanged: (bool? val) => setState(() => _cameraAcknowledged = val ?? false),
                    title: Text(
                      context.l10n.cameraCheckboxLabel,
                      style: context.textTheme.bodyMedium,
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],

                // 10. Sigorta Poliçesi
                SectionHeader(title: context.l10n.insuranceSection),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      children: <Widget>[
                        const Icon(Icons.security_rounded, color: Colors.blue, size: 28),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.vehicle.insurancePolicyName,
                                style: const TextStyle(fontWeight: FontWeight.w700),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Kasko Poliçe Detayları (PDF)',
                                style: context.textTheme.bodySmall?.copyWith(
                                  color: context.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size.zero,
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.sm,
                            ),
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(context.l10n.policyDownloadedMessage),
                                backgroundColor: context.appColors.success,
                              ),
                            );
                          },
                          icon: const Icon(Icons.download_rounded, size: 16),
                          label: Text(context.l10n.downloadPolicyButton),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // 11. E-İmzalar
                SectionHeader(title: context.l10n.signaturesSection),
                SignaturePad(
                  title: context.l10n.renterSignatureLabel,
                  initialSigned: _renterSigned,
                  onSaved: (bool val) => setState(() => _renterSigned = val),
                ),
                const SizedBox(height: AppSpacing.lg),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          _ownerSigned ? Icons.verified_user_rounded : Icons.pending_actions_rounded,
                          color: _ownerSigned ? context.appColors.success : context.appColors.warning,
                          size: 28,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                context.l10n.ownerSignatureLabel,
                                style: const TextStyle(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _ownerSigned
                                    ? 'Araç sahibi sözleşmeyi e-imzaladı'
                                    : 'Araç sahibi imzası bekleniyor (simülasyon)',
                                style: context.textTheme.bodySmall?.copyWith(
                                  color: context.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        FilledButton.tonal(
                          style: FilledButton.styleFrom(
                            minimumSize: Size.zero,
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.sm,
                            ),
                          ),
                          onPressed: _simulateOwnerSignature,
                          child: Text(_ownerSigned ? 'Yeniden İmzala' : 'İmzala'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),

                // Onayla Butonu
                FilledButton(
                  onPressed: _submitRental,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(context.l10n.confirmRentalButton),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(label, style: TextStyle(color: context.colorScheme.onSurfaceVariant)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
