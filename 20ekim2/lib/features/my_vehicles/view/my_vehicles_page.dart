import 'package:flutter/material.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/controllers/session_controller.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/validators/app_validators.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/rating_stars.dart';
import '../../vehicle_detail/view/vehicle_detail_page.dart';
import '../../vehicle_list/models/enums.dart';
import '../../vehicle_list/models/vehicle.dart';
import '../controller/my_vehicles_controller.dart';

class MyVehiclesPage extends StatefulWidget {
  const MyVehiclesPage({
    required this.sessionController,
    super.key,
  });

  final SessionController sessionController;

  @override
  State<MyVehiclesPage> createState() => _MyVehiclesPageState();
}

class _MyVehiclesPageState extends State<MyVehiclesPage> {
  late final MyVehiclesController _controller;

  @override
  void initState() {
    super.initState();
    final String ownerId = widget.sessionController.value.userId ?? 'owner_1';
    _controller = MyVehiclesController(ownerId: ownerId);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showAddEditVehicleDialog([Vehicle? vehicleToEdit]) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final bool isEditing = vehicleToEdit != null;

    final TextEditingController brandCtrl = TextEditingController(text: vehicleToEdit?.brand ?? '');
    final TextEditingController modelCtrl = TextEditingController(text: vehicleToEdit?.model ?? '');
    final TextEditingController yearCtrl = TextEditingController(text: vehicleToEdit?.year.toString() ?? '2023');
    final TextEditingController plateCtrl = TextEditingController(text: vehicleToEdit?.plate ?? '34 ABC 789');
    final TextEditingController kmCtrl = TextEditingController(text: vehicleToEdit?.mileageKm.toString() ?? '15000');
    final TextEditingController dailyPriceCtrl = TextEditingController(text: vehicleToEdit?.dailyPrice.toStringAsFixed(0) ?? '1200');
    final TextEditingController policyCtrl = TextEditingController(text: vehicleToEdit?.insurancePolicyName ?? 'Kasko_Police.pdf');

    VehicleType selectedType = vehicleToEdit?.type ?? VehicleType.car;
    TransmissionType selectedTrans = vehicleToEdit?.transmission ?? TransmissionType.automatic;
    FuelType selectedFuel = vehicleToEdit?.fuelType ?? FuelType.gasoline;
    int seatCount = vehicleToEdit?.seatCount ?? 5;
    bool hasCamera = vehicleToEdit?.hasInteriorCamera ?? true;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (BuildContext ctx) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      isEditing ? context.l10n.editVehicleTitle : context.l10n.addNewVehicleTitle,
                      style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    // Araç Tipi Seçimi
                    DropdownButtonFormField<VehicleType>(
                      initialValue: selectedType,
                      decoration: InputDecoration(labelText: context.l10n.vehicleTypeTitle),
                      items: VehicleType.values.map((VehicleType t) {
                        return DropdownMenuItem<VehicleType>(
                          value: t,
                          child: Text(t.localized(context.l10n)),
                        );
                      }).toList(),
                      onChanged: (VehicleType? v) {
                        if (v != null) setModalState(() => selectedType = v);
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            controller: brandCtrl,
                            decoration: InputDecoration(labelText: context.l10n.brandTitle),
                            validator: AppValidators.required(context.l10n),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: TextFormField(
                            controller: modelCtrl,
                            decoration: InputDecoration(labelText: context.l10n.modelTitle),
                            validator: AppValidators.required(context.l10n),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            controller: yearCtrl,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(labelText: context.l10n.yearRangeTitle),
                            validator: AppValidators.required(context.l10n),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: TextFormField(
                            controller: plateCtrl,
                            decoration: InputDecoration(labelText: context.l10n.plateLabel),
                            validator: AppValidators.turkishPlate(context.l10n),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            controller: kmCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Kilometre'),
                            validator: AppValidators.required(context.l10n),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: TextFormField(
                            controller: dailyPriceCtrl,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(labelText: 'Günlük Fiyat (₺)'),
                            validator: AppValidators.positivePrice(context.l10n),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    // Vites ve Yakıt
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: DropdownButtonFormField<TransmissionType>(
                            initialValue: selectedTrans,
                            decoration: InputDecoration(labelText: context.l10n.transmissionTitle),
                            items: TransmissionType.values.map((TransmissionType t) {
                              return DropdownMenuItem<TransmissionType>(
                                value: t,
                                child: Text(t.localized(context.l10n)),
                              );
                            }).toList(),
                            onChanged: (TransmissionType? v) {
                              if (v != null) setModalState(() => selectedTrans = v);
                            },
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: DropdownButtonFormField<FuelType>(
                            initialValue: selectedFuel,
                            decoration: InputDecoration(labelText: context.l10n.fuelTypeTitle),
                            items: FuelType.values.map((FuelType f) {
                              return DropdownMenuItem<FuelType>(
                                value: f,
                                child: Text(f.localized(context.l10n)),
                              );
                            }).toList(),
                            onChanged: (FuelType? v) {
                              if (v != null) setModalState(() => selectedFuel = v);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      value: hasCamera,
                      onChanged: (bool val) => setModalState(() => hasCamera = val),
                      title: const Text('İç Güvenlik Kamerası'),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    FilledButton(
                      onPressed: () {
                        if (!formKey.currentState!.validate()) return;

                        final double price = double.parse(dailyPriceCtrl.text.trim());
                        final int year = int.parse(yearCtrl.text.trim());
                        final int km = int.parse(kmCtrl.text.trim());

                        if (isEditing) {
                          final Vehicle updated = vehicleToEdit.copyWith(
                            type: selectedType,
                            brand: brandCtrl.text.trim(),
                            model: modelCtrl.text.trim(),
                            year: year,
                            plate: plateCtrl.text.trim().toUpperCase(),
                            mileageKm: km,
                            dailyPrice: price,
                            transmission: selectedTrans,
                            fuelType: selectedFuel,
                            seatCount: seatCount,
                            hasInteriorCamera: hasCamera,
                          );
                          _controller.updateVehicle(updated);
                        } else {
                          final Vehicle newV = Vehicle(
                            id: 'v_${DateTime.now().millisecondsSinceEpoch}',
                            ownerId: widget.sessionController.value.userId ?? 'owner_1',
                            type: selectedType,
                            brand: brandCtrl.text.trim(),
                            model: modelCtrl.text.trim(),
                            year: year,
                            plate: plateCtrl.text.trim().toUpperCase(),
                            chassisOrIdNo: 'ID${DateTime.now().millisecondsSinceEpoch}',
                            transmission: selectedTrans,
                            fuelType: selectedFuel,
                            seatCount: seatCount,
                            mileageKm: km,
                            accidentHistory: AccidentHistory.clean,
                            accidentDescription: 'Temiz ve bakımlı.',
                            expertiseReportImage: 'assets/images/expertise_default.png',
                            images: const <String>['assets/images/default_car.png'],
                            hourlyPrice: price / 8,
                            dailyPrice: price,
                            weeklyPrice: price * 6,
                            monthlyPrice: price * 22,
                            rating: 5.0,
                            ratingCount: 1,
                            rentCount: 0,
                            hasInteriorCamera: hasCamera,
                            insurancePolicyName: policyCtrl.text.trim(),
                          );
                          _controller.addVehicle(newV);
                        }

                        Navigator.of(ctx).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(isEditing ? 'Araç güncellendi.' : 'Yeni araç başarıyla eklendi.'),
                            backgroundColor: context.appColors.success,
                          ),
                        );
                      },
                      child: Text(isEditing ? 'Güncelle' : 'Kaydet ve Yayınla'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _deleteVehicle(Vehicle vehicle) async {
    final bool? confirmed = await ConfirmDialog.show(
      context: context,
      title: 'Aracı Sil',
      content: context.l10n.deleteVehicleConfirmation,
      isDestructive: true,
    );

    if (confirmed == true && mounted) {
      _controller.removeVehicle(vehicle.id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Araç başarıyla sistemden kaldırıldı.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.myVehiclesTitle),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditVehicleDialog(),
        icon: const Icon(Icons.add_rounded),
        label: Text(context.l10n.addVehicleButton),
      ),
      body: SafeArea(
        child: ValueListenableBuilder<List<Vehicle>>(
          valueListenable: _controller,
          builder: (BuildContext ctx, List<Vehicle> vehicles, _) {
            if (vehicles.isEmpty) {
              return EmptyState(
                icon: Icons.garage_outlined,
                title: 'Henüz kayıtlı bir aracınız yok.',
                actionLabel: context.l10n.addVehicleButton,
                onAction: () => _showAddEditVehicleDialog(),
              );
            }

            final double totalRevenue = vehicles.fold(
              0.0,
              (double prev, Vehicle v) => prev + (v.rentCount * v.dailyPrice * 2.5),
            );

            return ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: <Widget>[
                // Gelir Özeti Kartı
                Card(
                  color: context.colorScheme.primaryContainer.withAlpha(60),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              context.l10n.vehicleTotalEarnings,
                              style: context.textTheme.labelMedium,
                            ),
                            Text(
                              '₺${totalRevenue.toStringAsFixed(0)}',
                              style: context.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: context.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.account_balance_wallet_rounded,
                          size: 36,
                          color: context.colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Araç Listesi
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: vehicles.length,
                  separatorBuilder: (BuildContext _, int index) => const SizedBox(height: AppSpacing.md),
                  itemBuilder: (BuildContext context, int index) {
                    final Vehicle v = vehicles[index];
                    return Card(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => VehicleDetailPage(
                                vehicle: v,
                                sessionController: widget.sessionController,
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
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.all(AppSpacing.sm),
                                    decoration: BoxDecoration(
                                      color: context.colorScheme.primaryContainer,
                                      borderRadius: BorderRadius.circular(AppRadius.sm),
                                    ),
                                    child: Icon(v.type.icon, color: context.colorScheme.primary),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          v.fullName,
                                          style: context.textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(
                                          'Plaka: ${v.plate}',
                                          style: context.textTheme.bodySmall?.copyWith(
                                            color: context.colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit_outlined, size: 20),
                                    onPressed: () => _showAddEditVehicleDialog(v),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete_outline_rounded, size: 20, color: context.appColors.danger),
                                    onPressed: () => _deleteVehicle(v),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              const Divider(height: 1),
                              const SizedBox(height: AppSpacing.sm),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  RatingStars(rating: v.rating, ratingCount: v.ratingCount),
                                  Text(
                                    '${v.rentCount} kiralama',
                                    style: context.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    '₺${v.dailyPrice.toStringAsFixed(0)} ${context.l10n.perDay}',
                                    style: context.textTheme.labelLarge?.copyWith(
                                      fontWeight: FontWeight.w700,
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
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
