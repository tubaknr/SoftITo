import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../theme/app_colors.dart';

extension BuildContextExtensions on BuildContext {
  AppColors get appColors =>
      Theme.of(this).extension<AppColors>() ?? AppColors.light;

  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  TextTheme get textTheme => Theme.of(this).textTheme;

  AppLocalizations get l10n {
    final AppLocalizations? localizations = AppLocalizations.of(this);
    assert(
      localizations != null,
      'No AppLocalizations found in BuildContext. Ensure Localizations.delegate is provided.',
    );
    return localizations!;
  }
}
