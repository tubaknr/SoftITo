import 'package:flutter/material.dart';

@immutable
class SpaceColors extends ThemeExtension<SpaceColors> {
  const SpaceColors({
    required this.bg,
    required this.surface,
    required this.surfaceHigh,
    required this.outline,
    required this.textPrimary,
    required this.textMuted,
    required this.dawn,
    required this.onDawn,
    required this.dawnEnd,
    required this.orbit,
    required this.onOrbit,
    required this.success,
    required this.info,
    required this.warning,
    required this.danger,
  });

  final Color bg;
  final Color surface;
  final Color surfaceHigh;
  final Color outline;
  final Color textPrimary;
  final Color textMuted;
  final Color dawn;
  final Color onDawn;
  final Color dawnEnd;
  final Color orbit;
  final Color onOrbit;
  final Color success;
  final Color info;
  final Color warning;
  final Color danger;

  LinearGradient get dawnGradient => LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        colors: [dawn, dawnEnd],
      );

  LinearGradient get nightGradient => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [bg, surface],
      );

  static const SpaceColors night = SpaceColors(
    bg: Color(0xFF0F1535),
    surface: Color(0xFF19214D),
    surfaceHigh: Color(0xFF232C63),
    outline: Color(0xFF34407F),
    textPrimary: Color(0xFFF3F5FF),
    textMuted: Color(0xFFA9B2E0),
    dawn: Color(0xFFFFB547),
    onDawn: Color(0xFF0F1535),
    dawnEnd: Color(0xFFFF7A6B),
    orbit: Color(0xFF4ADEDE),
    onOrbit: Color(0xFF0F1535),
    success: Color(0xFF3DDC97),
    info: Color(0xFF6EA8FF),
    warning: Color(0xFFFF9F5A),
    danger: Color(0xFFFF6B7A),
  );

  static const SpaceColors day = SpaceColors(
    bg: Color(0xFFF4F6FF),
    surface: Color(0xFFFFFFFF),
    surfaceHigh: Color(0xFFE9EDFF),
    outline: Color(0xFFCDD4F5),
    textPrimary: Color(0xFF131A44),
    textMuted: Color(0xFF4F5894),
    dawn: Color(0xFF3341D6),
    onDawn: Color(0xFFFFFFFF),
    dawnEnd: Color(0xFFE8710A),
    orbit: Color(0xFF0E8F9A),
    onOrbit: Color(0xFFFFFFFF),
    success: Color(0xFF12805C),
    info: Color(0xFF2F5FD0),
    warning: Color(0xFFB85600),
    danger: Color(0xFFC62F42),
  );

  @override
  SpaceColors copyWith({
    Color? bg,
    Color? surface,
    Color? surfaceHigh,
    Color? outline,
    Color? textPrimary,
    Color? textMuted,
    Color? dawn,
    Color? onDawn,
    Color? dawnEnd,
    Color? orbit,
    Color? onOrbit,
    Color? success,
    Color? info,
    Color? warning,
    Color? danger,
  }) {
    return SpaceColors(
      bg: bg ?? this.bg,
      surface: surface ?? this.surface,
      surfaceHigh: surfaceHigh ?? this.surfaceHigh,
      outline: outline ?? this.outline,
      textPrimary: textPrimary ?? this.textPrimary,
      textMuted: textMuted ?? this.textMuted,
      dawn: dawn ?? this.dawn,
      onDawn: onDawn ?? this.onDawn,
      dawnEnd: dawnEnd ?? this.dawnEnd,
      orbit: orbit ?? this.orbit,
      onOrbit: onOrbit ?? this.onOrbit,
      success: success ?? this.success,
      info: info ?? this.info,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
    );
  }

  @override
  SpaceColors lerp(ThemeExtension<SpaceColors>? other, double t) {
    if (other is! SpaceColors) return this;
    return SpaceColors(
      bg: Color.lerp(bg, other.bg, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceHigh: Color.lerp(surfaceHigh, other.surfaceHigh, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      dawn: Color.lerp(dawn, other.dawn, t)!,
      onDawn: Color.lerp(onDawn, other.onDawn, t)!,
      dawnEnd: Color.lerp(dawnEnd, other.dawnEnd, t)!,
      orbit: Color.lerp(orbit, other.orbit, t)!,
      onOrbit: Color.lerp(onOrbit, other.onOrbit, t)!,
      success: Color.lerp(success, other.success, t)!,
      info: Color.lerp(info, other.info, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
    );
  }
}
