import 'package:flutter/material.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../models/enums.dart';
import '../models/vehicle.dart';
import '../models/vehicle_filter.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({
    required this.initialFilter,
    required this.allVehicles,
    required this.onApply,
    super.key,
  });

  final VehicleFilter initialFilter;
  final List<Vehicle> allVehicles;
  final ValueChanged<VehicleFilter> onApply;

  static void show({
    required BuildContext context,
    required VehicleFilter initialFilter,
    required List<Vehicle> allVehicles,
    required ValueChanged<VehicleFilter> onApply,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (BuildContext ctx) => FilterBottomSheet(
        initialFilter: initialFilter,
        allVehicles: allVehicles,
        onApply: onApply,
      ),
    );
  }

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late SortByOption _sortBy;
  late VehicleType? _selectedType;
  late String? _selectedBrand;
  late String? _selectedModel;
  late TransmissionType? _selectedTransmission;
  late FuelType? _selectedFuelType;
  late int? _minSeats;
  late double _minYear;
  late double _maxYear;

  @override
  void initState() {
    super.initState();
    _sortBy = widget.initialFilter.sortBy;
    _selectedType = widget.initialFilter.type;
    _selectedBrand = widget.initialFilter.brand;
    _selectedModel = widget.initialFilter.model;
    _selectedTransmission = widget.initialFilter.transmission;
    _selectedFuelType = widget.initialFilter.fuelType;
    _minSeats = widget.initialFilter.minSeats;
    _minYear = (widget.initialFilter.minYear ?? 2020).toDouble();
    _maxYear = (widget.initialFilter.maxYear ?? 2025).toDouble();
  }

  List<String> get _availableBrands {
    final Set<String> brands = widget.allVehicles.map((Vehicle v) => v.brand).toSet();
    return brands.toList()..sort();
  }

  List<String> get _availableModels {
    if (_selectedBrand == null) return <String>[];
    final Set<String> models = widget.allVehicles
        .where((Vehicle v) => v.brand.toLowerCase() == _selectedBrand!.toLowerCase())
        .map((Vehicle v) => v.model)
        .toSet();
    return models.toList()..sort();
  }

  void _clearAll() {
    setState(() {
      _sortBy = SortByOption.highestRating;
      _selectedType = null;
      _selectedBrand = null;
      _selectedModel = null;
      _selectedTransmission = null;
      _selectedFuelType = null;
      _minSeats = null;
      _minYear = 2020.0;
      _maxYear = 2025.0;
    });
  }

  void _apply() {
    final VehicleFilter updated = widget.initialFilter.copyWith(
      sortBy: _sortBy,
      type: _selectedType,
      clearType: _selectedType == null,
      brand: _selectedBrand,
      clearBrand: _selectedBrand == null,
      model: _selectedModel,
      clearModel: _selectedModel == null,
      transmission: _selectedTransmission,
      clearTransmission: _selectedTransmission == null,
      fuelType: _selectedFuelType,
      clearFuelType: _selectedFuelType == null,
      minSeats: _minSeats,
      clearMinSeats: _minSeats == null,
      minYear: _minYear.toInt(),
      maxYear: _maxYear.toInt(),
    );
    widget.onApply(updated);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (BuildContext ctx, ScrollController scrollController) {
        return Column(
          children: <Widget>[
            // Drag Handle
            Container(
              margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Başlık Çubuğu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    context.l10n.filterTitle,
                    style: context.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextButton(
                    onPressed: _clearAll,
                    child: Text(context.l10n.clearFilters),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Filtre Seçenekleri
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(AppSpacing.lg),
                children: <Widget>[
                  // 1. Sıralama
                  Text(
                    context.l10n.sortByTitle,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.xs,
                    children: SortByOption.values.map((SortByOption opt) {
                      final bool isSelected = _sortBy == opt;
                      return ChoiceChip(
                        label: Text(opt.localized(context.l10n)),
                        selected: isSelected,
                        onSelected: (bool selected) {
                          if (selected) setState(() => _sortBy = opt);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // 2. Araç Tipi
                  Text(
                    context.l10n.vehicleTypeTitle,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.xs,
                    children: VehicleType.values.map((VehicleType t) {
                      final bool isSelected = _selectedType == t;
                      return ChoiceChip(
                        avatar: Icon(t.icon, size: 16),
                        label: Text(t.localized(context.l10n)),
                        selected: isSelected,
                        onSelected: (bool selected) {
                          setState(() => _selectedType = selected ? t : null);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // 3. Marka ve Model
                  Text(
                    context.l10n.brandTitle,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  DropdownButtonFormField<String?>(
                    initialValue: _selectedBrand,
                    decoration: InputDecoration(
                      hintText: context.l10n.allBrands,
                    ),
                    items: <DropdownMenuItem<String?>>[
                      DropdownMenuItem<String?>(
                        value: null,
                        child: Text(context.l10n.allBrands),
                      ),
                      ..._availableBrands.map((String b) => DropdownMenuItem<String?>(
                            value: b,
                            child: Text(b),
                          )),
                    ],
                    onChanged: (String? val) {
                      setState(() {
                        _selectedBrand = val;
                        _selectedModel = null;
                      });
                    },
                  ),
                  if (_selectedBrand != null && _availableModels.isNotEmpty) ...<Widget>[
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      context.l10n.modelTitle,
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    DropdownButtonFormField<String?>(
                      initialValue: _selectedModel,
                      decoration: InputDecoration(
                        hintText: context.l10n.allModels,
                      ),
                      items: <DropdownMenuItem<String?>>[
                        DropdownMenuItem<String?>(
                          value: null,
                          child: Text(context.l10n.allModels),
                        ),
                        ..._availableModels.map((String m) => DropdownMenuItem<String?>(
                              value: m,
                              child: Text(m),
                            )),
                      ],
                      onChanged: (String? val) {
                        setState(() => _selectedModel = val);
                      },
                    ),
                  ],
                  const SizedBox(height: AppSpacing.lg),

                  // 4. Model Yılı Aralığı
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        context.l10n.yearRangeTitle,
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '${_minYear.toInt()} - ${_maxYear.toInt()}',
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: context.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  RangeSlider(
                    values: RangeValues(_minYear, _maxYear),
                    min: 2018,
                    max: 2025,
                    divisions: 7,
                    labels: RangeLabels(
                      _minYear.toInt().toString(),
                      _maxYear.toInt().toString(),
                    ),
                    onChanged: (RangeValues values) {
                      setState(() {
                        _minYear = values.start;
                        _maxYear = values.end;
                      });
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // 5. Vites Türü (SegmentedButton)
                  Text(
                    context.l10n.transmissionTitle,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SegmentedButton<TransmissionType?>(
                    segments: <ButtonSegment<TransmissionType?>>[
                      const ButtonSegment<TransmissionType?>(
                        value: null,
                        label: Text('Hepsi'),
                      ),
                      ButtonSegment<TransmissionType?>(
                        value: TransmissionType.automatic,
                        label: Text(TransmissionType.automatic.localized(context.l10n)),
                      ),
                      ButtonSegment<TransmissionType?>(
                        value: TransmissionType.manual,
                        label: Text(TransmissionType.manual.localized(context.l10n)),
                      ),
                    ],
                    selected: <TransmissionType?>{_selectedTransmission},
                    onSelectionChanged: (Set<TransmissionType?> newSelection) {
                      setState(() => _selectedTransmission = newSelection.first);
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // 6. Yakıt Türü
                  Text(
                    context.l10n.fuelTypeTitle,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.xs,
                    children: FuelType.values.map((FuelType f) {
                      final bool isSelected = _selectedFuelType == f;
                      return ChoiceChip(
                        label: Text(f.localized(context.l10n)),
                        selected: isSelected,
                        onSelected: (bool selected) {
                          setState(() => _selectedFuelType = selected ? f : null);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // 7. Minimum Koltuk Sayısı
                  Text(
                    context.l10n.seatCountTitle,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.sm,
                    children: <int>[1, 2, 4, 5, 7, 9].map((int count) {
                      final bool isSelected = _minSeats == count;
                      return ChoiceChip(
                        label: Text('$count+'),
                        selected: isSelected,
                        onSelected: (bool selected) {
                          setState(() => _minSeats = selected ? count : null);
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            // Alt Buton
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: FilledButton(
                onPressed: _apply,
                child: Text(context.l10n.applyFilters),
              ),
            ),
          ],
        );
      },
    );
  }
}
