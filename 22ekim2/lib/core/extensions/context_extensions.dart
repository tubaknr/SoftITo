import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme_extension.dart';

/// Extension on BuildContext for quick and clean access to theme, colors, and l10n
extension ContextExtensions on BuildContext {
  AppLocalizations get loc => AppLocalizations.of(this);

  AppThemeExtension get colors =>
      Theme.of(this).extension<AppThemeExtension>()!;

  TextTheme get typography => Theme.of(this).textTheme;

  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  double get screenWidth => MediaQuery.of(this).size.width;

  double get screenHeight => MediaQuery.of(this).size.height;

  EdgeInsets get padding => MediaQuery.of(this).padding;
}
