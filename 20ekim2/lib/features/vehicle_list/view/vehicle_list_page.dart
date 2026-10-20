import 'package:flutter/material.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/controllers/session_controller.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/empty_state.dart';
import '../../vehicle_detail/view/vehicle_detail_page.dart';
import '../controller/vehicle_list_controller.dart';
import '../models/enums.dart';
import '../models/vehicle.dart';
import '../models/vehicle_filter.dart';
import '../widget/filter_bottom_sheet.dart';
import '../widget/vehicle_card.dart';

class VehicleListPage extends StatefulWidget {
  const VehicleListPage({
    required this.controller,
    required this.sessionController,
    super.key,
  });

  final VehicleListController controller;
  final SessionController sessionController;

  @override
  State<VehicleListPage> createState() => _VehicleListPageState();
}

class _VehicleListPageState extends State<VehicleListPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openFilterSheet() {
    FilterBottomSheet.show(
      context: context,
      initialFilter: widget.controller.filter,
      allVehicles: widget.controller.allVehicles,
      onApply: (VehicleFilter newFilter) {
        widget.controller.setFilter(newFilter);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.appName),
        actions: <Widget>[
          IconButton(
            tooltip: context.l10n.filterButton,
            icon: Badge(
              isLabelVisible: widget.controller.filter.hasActiveFilters,
              child: const Icon(Icons.tune_rounded),
            ),
            onPressed: _openFilterSheet,
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // Arama Kutusu ve Hızlı Filtre Butonu
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.xs,
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: context.l10n.searchVehicleHint,
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded),
                          onPressed: () {
                            _searchController.clear();
                            widget.controller.updateSearchQuery('');
                            setState(() {});
                          },
                        )
                      : null,
                ),
                onChanged: (String val) {
                  widget.controller.updateSearchQuery(val);
                  setState(() {});
                },
              ),
            ),
            // Aktif Filtre Chip'leri
            AnimatedBuilder(
              animation: widget.controller,
              builder: (BuildContext ctx, _) {
                final VehicleFilter filter = widget.controller.filter;
                final List<Widget> chips = <Widget>[];

                if (filter.type != null) {
                  chips.add(
                    InputChip(
                      label: Text(filter.type!.localized(context.l10n)),
                      onDeleted: () => widget.controller
                          .setFilter(filter.copyWith(clearType: true)),
                    ),
                  );
                }
                if (filter.brand != null) {
                  chips.add(
                    InputChip(
                      label: Text(filter.brand!),
                      onDeleted: () => widget.controller
                          .setFilter(filter.copyWith(clearBrand: true)),
                    ),
                  );
                }
                if (filter.transmission != null) {
                  chips.add(
                    InputChip(
                      label: Text(filter.transmission!.localized(context.l10n)),
                      onDeleted: () => widget.controller
                          .setFilter(filter.copyWith(clearTransmission: true)),
                    ),
                  );
                }
                if (filter.fuelType != null) {
                  chips.add(
                    InputChip(
                      label: Text(filter.fuelType!.localized(context.l10n)),
                      onDeleted: () => widget.controller
                          .setFilter(filter.copyWith(clearFuelType: true)),
                    ),
                  );
                }
                if (filter.minSeats != null) {
                  chips.add(
                    InputChip(
                      label: Text('${filter.minSeats}+ Koltuk'),
                      onDeleted: () => widget.controller
                          .setFilter(filter.copyWith(clearMinSeats: true)),
                    ),
                  );
                }
                if (filter.sortBy != SortByOption.highestRating) {
                  chips.add(
                    InputChip(
                      avatar: const Icon(Icons.sort_rounded, size: 16),
                      label: Text(filter.sortBy.localized(context.l10n)),
                      onDeleted: () => widget.controller.setSortOption(SortByOption.highestRating),
                    ),
                  );
                }

                if (chips.isEmpty) return const SizedBox.shrink();

                return SizedBox(
                  height: 48,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    itemCount: chips.length,
                    separatorBuilder: (BuildContext _, int index) => const SizedBox(width: AppSpacing.sm),
                    itemBuilder: (_, int index) => chips[index],
                  ),
                );
              },
            ),
            const SizedBox(height: AppSpacing.xs),
            // Araç Listesi
            Expanded(
              child: ValueListenableBuilder<List<Vehicle>>(
                valueListenable: widget.controller,
                builder: (BuildContext ctx, List<Vehicle> vehicles, _) {
                  if (vehicles.isEmpty) {
                    return EmptyState(
                      icon: Icons.directions_car_outlined,
                      title: context.l10n.emptyVehicleList,
                      actionLabel: context.l10n.emptyVehicleListAction,
                      onAction: () {
                        _searchController.clear();
                        widget.controller.clearFilter();
                        setState(() {});
                      },
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    itemCount: vehicles.length,
                    separatorBuilder: (BuildContext _, int index) => const SizedBox(height: AppSpacing.lg),
                    itemBuilder: (BuildContext context, int index) {
                      final Vehicle vehicle = vehicles[index];
                      return VehicleCard(
                        vehicle: vehicle,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => VehicleDetailPage(
                                vehicle: vehicle,
                                sessionController: widget.sessionController,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
