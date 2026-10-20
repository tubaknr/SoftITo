import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

enum VehicleType {
  car,
  suv,
  van,
  motorcycle,
  scooter,
  commercial;

  String localized(AppLocalizations l10n) {
    switch (this) {
      case VehicleType.car:
        return l10n.typeCar;
      case VehicleType.suv:
        return l10n.typeSuv;
      case VehicleType.van:
        return l10n.typeVan;
      case VehicleType.motorcycle:
        return l10n.typeMotorcycle;
      case VehicleType.scooter:
        return l10n.typeScooter;
      case VehicleType.commercial:
        return l10n.typeCommercial;
    }
  }

  IconData get icon {
    switch (this) {
      case VehicleType.car:
        return Icons.directions_car_rounded;
      case VehicleType.suv:
        return Icons.directions_car_filled_rounded;
      case VehicleType.van:
        return Icons.airport_shuttle_rounded;
      case VehicleType.motorcycle:
        return Icons.two_wheeler_rounded;
      case VehicleType.scooter:
        return Icons.electric_scooter_rounded;
      case VehicleType.commercial:
        return Icons.local_shipping_rounded;
    }
  }
}

enum TransmissionType {
  manual,
  automatic;

  String localized(AppLocalizations l10n) {
    switch (this) {
      case TransmissionType.manual:
        return l10n.transManual;
      case TransmissionType.automatic:
        return l10n.transAutomatic;
    }
  }
}

enum FuelType {
  gasoline,
  diesel,
  electric,
  hybrid;

  String localized(AppLocalizations l10n) {
    switch (this) {
      case FuelType.gasoline:
        return l10n.fuelGasoline;
      case FuelType.diesel:
        return l10n.fuelDiesel;
      case FuelType.electric:
        return l10n.fuelElectric;
      case FuelType.hybrid:
        return l10n.fuelHybrid;
    }
  }
}

enum AccidentHistory {
  clean,
  minor,
  major;

  String localized(AppLocalizations l10n) {
    switch (this) {
      case AccidentHistory.clean:
        return l10n.accClean;
      case AccidentHistory.minor:
        return l10n.accMinor;
      case AccidentHistory.major:
        return l10n.accMajor;
    }
  }
}

enum ReturnTag {
  cleanReturn,
  dirtyReturn,
  fuelFull,
  fuelEmpty,
  onTime,
  lateReturn,
  undamaged,
  damaged,
  rulesFollowed;

  String localized(AppLocalizations l10n) {
    switch (this) {
      case ReturnTag.cleanReturn:
        return l10n.tagCleanReturn;
      case ReturnTag.dirtyReturn:
        return l10n.tagDirtyReturn;
      case ReturnTag.fuelFull:
        return l10n.tagFuelFull;
      case ReturnTag.fuelEmpty:
        return l10n.tagFuelEmpty;
      case ReturnTag.onTime:
        return l10n.tagOnTime;
      case ReturnTag.lateReturn:
        return l10n.tagLateReturn;
      case ReturnTag.undamaged:
        return l10n.tagUndamaged;
      case ReturnTag.damaged:
        return l10n.tagDamaged;
      case ReturnTag.rulesFollowed:
        return l10n.tagRulesFollowed;
    }
  }

  bool get isPositive {
    switch (this) {
      case ReturnTag.cleanReturn:
      case ReturnTag.fuelFull:
      case ReturnTag.onTime:
      case ReturnTag.undamaged:
      case ReturnTag.rulesFollowed:
        return true;
      case ReturnTag.dirtyReturn:
      case ReturnTag.fuelEmpty:
      case ReturnTag.lateReturn:
      case ReturnTag.damaged:
        return false;
    }
  }

  IconData get icon {
    switch (this) {
      case ReturnTag.cleanReturn:
        return Icons.cleaning_services_rounded;
      case ReturnTag.dirtyReturn:
        return Icons.delete_outline_rounded;
      case ReturnTag.fuelFull:
        return Icons.local_gas_station_rounded;
      case ReturnTag.fuelEmpty:
        return Icons.local_gas_station_outlined;
      case ReturnTag.onTime:
        return Icons.schedule_rounded;
      case ReturnTag.lateReturn:
        return Icons.history_toggle_off_rounded;
      case ReturnTag.undamaged:
        return Icons.verified_rounded;
      case ReturnTag.damaged:
        return Icons.report_problem_rounded;
      case ReturnTag.rulesFollowed:
        return Icons.thumb_up_alt_rounded;
    }
  }
}

enum ReservationStatus {
  pending,
  confirmed,
  active,
  completed,
  cancelled;

  String localized(AppLocalizations l10n) {
    switch (this) {
      case ReservationStatus.pending:
        return l10n.statusPending;
      case ReservationStatus.confirmed:
        return l10n.statusConfirmed;
      case ReservationStatus.active:
        return l10n.statusActive;
      case ReservationStatus.completed:
        return l10n.statusCompleted;
      case ReservationStatus.cancelled:
        return l10n.statusCancelled;
    }
  }
}

enum PaymentStatus {
  pending,
  paid;

  String localized(AppLocalizations l10n) {
    switch (this) {
      case PaymentStatus.pending:
        return l10n.paymentStatusPending;
      case PaymentStatus.paid:
        return l10n.paymentStatusPaid;
    }
  }
}

enum SortByOption {
  highestRating,
  priceAsc,
  priceDesc,
  yearDesc,
  yearAsc;

  String localized(AppLocalizations l10n) {
    switch (this) {
      case SortByOption.highestRating:
        return l10n.sortHighestRating;
      case SortByOption.priceAsc:
        return l10n.sortPriceAsc;
      case SortByOption.priceDesc:
        return l10n.sortPriceDesc;
      case SortByOption.yearDesc:
        return l10n.sortYearDesc;
      case SortByOption.yearAsc:
        return l10n.sortYearAsc;
    }
  }
}

enum TargetType {
  vehicle,
  owner,
  renter,
}
