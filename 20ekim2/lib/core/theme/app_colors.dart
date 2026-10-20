import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.success,
    required this.warning,
    required this.danger,
    required this.rating,
    required this.calendarBooked,
    required this.calendarSelected,
    required this.calendarAvailable,
    required this.ctaGradientStart,
    required this.ctaGradientEnd,
  });

  final Color success;
  final Color warning;
  final Color danger;
  final Color rating;
  final Color calendarBooked;
  final Color calendarSelected;
  final Color calendarAvailable;
  final Color ctaGradientStart;
  final Color ctaGradientEnd;

  static const AppColors light = AppColors(
    success: Color(0xFF1E8E4E),
    warning: Color(0xFFB26A00),
    danger: Color(0xFFBA1A1A),
    rating: Color(0xFFF5A400),
    calendarBooked: Color(0xFFFBE1E1),
    calendarSelected: Color(0xFF2457F5),
    calendarAvailable: Color(0xFFE6F4EA),
    ctaGradientStart: Color(0xFF2457F5),
    ctaGradientEnd: Color(0xFFFF8A00),
  );

  static const AppColors dark = AppColors(
    success: Color(0xFF6FD79A),
    warning: Color(0xFFFFC46B),
    danger: Color(0xFFFFB4AB),
    rating: Color(0xFFFFC83D),
    calendarBooked: Color(0xFF4A2226),
    calendarSelected: Color(0xFF9DB4FF),
    calendarAvailable: Color(0xFF1D3326),
    ctaGradientStart: Color(0xFF5B7FFF),
    ctaGradientEnd: Color(0xFFFF9F2E),
  );

  @override
  AppColors copyWith({
    Color? success,
    Color? warning,
    Color? danger,
    Color? rating,
    Color? calendarBooked,
    Color? calendarSelected,
    Color? calendarAvailable,
    Color? ctaGradientStart,
    Color? ctaGradientEnd,
  }) {
    return AppColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
      rating: rating ?? this.rating,
      calendarBooked: calendarBooked ?? this.calendarBooked,
      calendarSelected: calendarSelected ?? this.calendarSelected,
      calendarAvailable: calendarAvailable ?? this.calendarAvailable,
      ctaGradientStart: ctaGradientStart ?? this.ctaGradientStart,
      ctaGradientEnd: ctaGradientEnd ?? this.ctaGradientEnd,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      success: Color.lerp(success, other.success, t) ?? success,
      warning: Color.lerp(warning, other.warning, t) ?? warning,
      danger: Color.lerp(danger, other.danger, t) ?? danger,
      rating: Color.lerp(rating, other.rating, t) ?? rating,
      calendarBooked: Color.lerp(calendarBooked, other.calendarBooked, t) ?? calendarBooked,
      calendarSelected: Color.lerp(calendarSelected, other.calendarSelected, t) ?? calendarSelected,
      calendarAvailable: Color.lerp(calendarAvailable, other.calendarAvailable, t) ?? calendarAvailable,
      ctaGradientStart: Color.lerp(ctaGradientStart, other.ctaGradientStart, t) ?? ctaGradientStart,
      ctaGradientEnd: Color.lerp(ctaGradientEnd, other.ctaGradientEnd, t) ?? ctaGradientEnd,
    );
  }
}
