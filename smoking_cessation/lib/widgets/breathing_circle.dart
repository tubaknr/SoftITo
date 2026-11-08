// ========================================
// DOSYA: breathing_circle.dart
// NE İŞE YARAR: 4-4-4 nefes egzersizi dairesini
// görsel olarak canlandırır.
// NASIL ÇALIŞIR: Faz oranına göre büyüyüp
// küçülen eşmerkezli halkalar çizer.
// SOLID: SRP - Sadece nefes dairesi sunar.
// ========================================

import 'package:flutter/material.dart';
import '../features/craving/craving_controller.dart';
import '../theme/app_theme.dart';

// SRP: Animasyonlu nefes dairesi bileşeni.
class BreathingCircle extends StatelessWidget {
  final double progress;
  final String phaseTitle;
  final BreathingPhase phase;

  const BreathingCircle({
    super.key,
    required this.progress,
    required this.phaseTitle,
    required this.phase,
  });

  @override
  Widget build(BuildContext context) {
    // Ölçek 0.85 ile 1.15 arasında değişir
    final scale = 0.85 + (progress * 0.3);

    return SizedBox(
      height: 240,
      width: 240,
      child: Center(
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeInOut,
          child: Stack(
            alignment: Alignment.center,
            children: [
              _buildOuterRing(),
              _buildMiddleRing(),
              _buildInnerCircle(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOuterRing() {
    return Container(
      width: 220,
      height: 220,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppTheme.secondaryCyan.withValues(alpha: 0.08),
        border: Border.all(
          color: AppTheme.secondaryCyan.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
    );
  }

  Widget _buildMiddleRing() {
    return Container(
      width: 170,
      height: 170,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppTheme.secondaryCyan.withValues(alpha: 0.15),
        border: Border.all(
          color: AppTheme.secondaryCyan.withValues(alpha: 0.4),
          width: 2,
        ),
      ),
    );
  }

  Widget _buildInnerCircle() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppTheme.surfaceContainer,
        border: Border.all(
          color: AppTheme.secondaryCyan,
          width: 2.5,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x4006B6D4),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Text(
          phaseTitle,
          style: AppTheme.headlineMedium.copyWith(
            color: AppTheme.secondaryCyan,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
