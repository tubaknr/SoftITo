import 'package:flutter/material.dart';

/// Custom theme extension for PenguHabit style tokens
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  const AppThemeExtension({
    required this.primary,
    required this.primaryLight,
    required this.primaryDark,
    required this.accentSun,
    required this.accentOrange,
    required this.accentCoral,
    required this.success,
    required this.successLight,
    required this.warning,
    required this.info,
    required this.bgApp,
    required this.bgCard,
    required this.bgCardSubtle,
    required this.textMain,
    required this.textMuted,
    required this.textDisabled,
    required this.textOnPrimary,
    required this.textLink,
    required this.borderLight,
    required this.borderFocus,
    required this.heroGradient,
    required this.dawnGradient,
    required this.btnPrimaryGradient,
    required this.badgeGoldGradient,
  });

  final Color primary;
  final Color primaryLight;
  final Color primaryDark;
  final Color accentSun;
  final Color accentOrange;
  final Color accentCoral;
  final Color success;
  final Color successLight;
  final Color warning;
  final Color info;
  final Color bgApp;
  final Color bgCard;
  final Color bgCardSubtle;
  final Color textMain;
  final Color textMuted;
  final Color textDisabled;
  final Color textOnPrimary;
  final Color textLink;
  final Color borderLight;
  final Color borderFocus;

  final LinearGradient heroGradient;
  final LinearGradient dawnGradient;
  final LinearGradient btnPrimaryGradient;
  final LinearGradient badgeGoldGradient;

  @override
  ThemeExtension<AppThemeExtension> copyWith({
    Color? primary,
    Color? primaryLight,
    Color? primaryDark,
    Color? accentSun,
    Color? accentOrange,
    Color? accentCoral,
    Color? success,
    Color? successLight,
    Color? warning,
    Color? info,
    Color? bgApp,
    Color? bgCard,
    Color? bgCardSubtle,
    Color? textMain,
    Color? textMuted,
    Color? textDisabled,
    Color? textOnPrimary,
    Color? textLink,
    Color? borderLight,
    Color? borderFocus,
    LinearGradient? heroGradient,
    LinearGradient? dawnGradient,
    LinearGradient? btnPrimaryGradient,
    LinearGradient? badgeGoldGradient,
  }) {
    return AppThemeExtension(
      primary: primary ?? this.primary,
      primaryLight: primaryLight ?? this.primaryLight,
      primaryDark: primaryDark ?? this.primaryDark,
      accentSun: accentSun ?? this.accentSun,
      accentOrange: accentOrange ?? this.accentOrange,
      accentCoral: accentCoral ?? this.accentCoral,
      success: success ?? this.success,
      successLight: successLight ?? this.successLight,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      bgApp: bgApp ?? this.bgApp,
      bgCard: bgCard ?? this.bgCard,
      bgCardSubtle: bgCardSubtle ?? this.bgCardSubtle,
      textMain: textMain ?? this.textMain,
      textMuted: textMuted ?? this.textMuted,
      textDisabled: textDisabled ?? this.textDisabled,
      textOnPrimary: textOnPrimary ?? this.textOnPrimary,
      textLink: textLink ?? this.textLink,
      borderLight: borderLight ?? this.borderLight,
      borderFocus: borderFocus ?? this.borderFocus,
      heroGradient: heroGradient ?? this.heroGradient,
      dawnGradient: dawnGradient ?? this.dawnGradient,
      btnPrimaryGradient: btnPrimaryGradient ?? this.btnPrimaryGradient,
      badgeGoldGradient: badgeGoldGradient ?? this.badgeGoldGradient,
    );
  }

  @override
  ThemeExtension<AppThemeExtension> lerp(
    covariant ThemeExtension<AppThemeExtension>? other,
    double t,
  ) {
    if (other is! AppThemeExtension) return this;
    return AppThemeExtension(
      primary: Color.lerp(primary, other.primary, t) ?? primary,
      primaryLight: Color.lerp(primaryLight, other.primaryLight, t) ?? primaryLight,
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t) ?? primaryDark,
      accentSun: Color.lerp(accentSun, other.accentSun, t) ?? accentSun,
      accentOrange: Color.lerp(accentOrange, other.accentOrange, t) ?? accentOrange,
      accentCoral: Color.lerp(accentCoral, other.accentCoral, t) ?? accentCoral,
      success: Color.lerp(success, other.success, t) ?? success,
      successLight: Color.lerp(successLight, other.successLight, t) ?? successLight,
      warning: Color.lerp(warning, other.warning, t) ?? warning,
      info: Color.lerp(info, other.info, t) ?? info,
      bgApp: Color.lerp(bgApp, other.bgApp, t) ?? bgApp,
      bgCard: Color.lerp(bgCard, other.bgCard, t) ?? bgCard,
      bgCardSubtle: Color.lerp(bgCardSubtle, other.bgCardSubtle, t) ?? bgCardSubtle,
      textMain: Color.lerp(textMain, other.textMain, t) ?? textMain,
      textMuted: Color.lerp(textMuted, other.textMuted, t) ?? textMuted,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t) ?? textDisabled,
      textOnPrimary: Color.lerp(textOnPrimary, other.textOnPrimary, t) ?? textOnPrimary,
      textLink: Color.lerp(textLink, other.textLink, t) ?? textLink,
      borderLight: Color.lerp(borderLight, other.borderLight, t) ?? borderLight,
      borderFocus: Color.lerp(borderFocus, other.borderFocus, t) ?? borderFocus,
      heroGradient: LinearGradient.lerp(heroGradient, other.heroGradient, t) ?? heroGradient,
      dawnGradient: LinearGradient.lerp(dawnGradient, other.dawnGradient, t) ?? dawnGradient,
      btnPrimaryGradient: LinearGradient.lerp(btnPrimaryGradient, other.btnPrimaryGradient, t) ?? btnPrimaryGradient,
      badgeGoldGradient: LinearGradient.lerp(badgeGoldGradient, other.badgeGoldGradient, t) ?? badgeGoldGradient,
    );
  }
}
