// ========================================
// DOSYA: breathing_circle.dart
// NE İŞE YARAR: 4-7-8 nefes egzersizi dairesi,
// sayaç ve kriz kartı bileşenlerini sunar.
// NASIL ÇALIŞIR: Faz ve saniye sayacına göre
// dinamik nefes halkalarını ve kartları çizer.
// SOLID: SRP - Kriz anı görsel bileşenleri.
// ========================================

import 'package:flutter/material.dart';
import '../features/craving/craving_controller.dart';
import '../theme/app_theme.dart';

// SRP: Animasyonlu 4-7-8 nefes dairesi.
class BreathingCircle extends StatelessWidget {
  final double progress;
  final String phaseTitle;
  final BreathingPhase phase;
  final int countdown;

  const BreathingCircle({
    super.key,
    required this.progress,
    required this.phaseTitle,
    required this.phase,
    required this.countdown,
  });

  @override
  Widget build(BuildContext context) {
    // Ölçek 0.88 ile 1.12 arasında genişler
    final scale = 0.88 + (progress * 0.24);

    return SizedBox(
      height: 260,
      width: 260,
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

  // Dış neon hava dalgası halkası.
  Widget _buildOuterRing() {
    return Container(
      width: 250,
      height: 250,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0x1406B6D4),
        border: Border.all(
          color: const Color(0x3306B6D4),
          width: 1.5,
        ),
      ),
    );
  }

  // Orta kılavuz nefes halkası.
  Widget _buildMiddleRing() {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0x1F06B6D4),
        border: Border.all(
          color: const Color(0x4D06B6D4),
          width: 2,
        ),
      ),
    );
  }

  // Merkez nefes durumu ve saniye dairesi.
  Widget _buildInnerCircle() {
    return Container(
      width: 154,
      height: 154,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF13222D),
        border: Border.all(
          color: AppTheme.secondaryCyan,
          width: 2.5,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3306B6D4),
            blurRadius: 24,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.air_rounded,
            color: Color(0xFF4EDEA3),
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            phaseTitle,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$countdown',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.secondaryCyan,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                'sn',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.secondaryCyan,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          const Text(
            '4–7–8 Ritmi',
            style: TextStyle(
              fontSize: 11,
              color: AppTheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

// SRP: Doğa sesi açıp kapama hap butonu.
class NatureSoundPill extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onToggle;

  const NatureSoundPill({
    super.key,
    required this.isPlaying,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onToggle,
          child: _buildPillBody(),
        ),
      ),
    );
  }

  // Doğa sesi butonu gövdesi.
  Widget _buildPillBody() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: isPlaying
            ? const Color(0x3310B981)
            : const Color(0x1A223040),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isPlaying
              ? AppTheme.primary
              : const Color(0x33FFFFFF),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPlaying
                ? Icons.volume_up_rounded
                : Icons.volume_mute_rounded,
            color: isPlaying
                ? AppTheme.primaryBright
                : AppTheme.onSurfaceVariant,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            isPlaying ? 'Doğa Sesi: Açık' : 'Doğa Sesi: Kapalı',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isPlaying
                  ? AppTheme.primaryBright
                  : AppTheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

// SRP: Biyolojik kriz gerçeği kartı.
class BiologicalFactCard extends StatelessWidget {
  const BiologicalFactCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF131D26),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x1FFFFFFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader(),
          const SizedBox(height: 8),
          _buildCardText(),
        ],
      ),
    );
  }

  // Biyolojik kart başlık satırı.
  Widget _buildCardHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: const [
            Icon(
              Icons.show_chart_rounded,
              color: AppTheme.primary,
              size: 18,
            ),
            SizedBox(width: 8),
            Text(
              'BİYOLOJİK GERÇEK',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppTheme.primary,
                letterSpacing: 0.6,
              ),
            ),
          ],
        ),
        const Text(
          'Pik:  3  dk',
          style: TextStyle(
            fontSize: 12,
            color: AppTheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  // Biyolojik kart açıklama metni.
  Widget _buildCardText() {
    return const Text(
      'Sigara içme isteği ortalama 3–5 dakika sürer. '
      'Bu dalga birazdan geçecek ve ciğerlerin '
      'sana teşekkür edecek.',
      style: TextStyle(
        fontSize: 12.5,
        height: 1.4,
        color: AppTheme.onSurfaceVariant,
      ),
    );
  }
}

// SRP: 5 dakikalık dijital kriz geri sayımı.
class CravingTimerHeader extends StatelessWidget {
  final int remainingSeconds;

  const CravingTimerHeader({
    super.key,
    required this.remainingSeconds,
  });

  @override
  Widget build(BuildContext context) {
    final m = (remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (remainingSeconds % 60).toString().padLeft(2, '0');

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.timer_outlined,
              size: 16,
              color: AppTheme.secondaryCyan,
            ),
            SizedBox(width: 6),
            Text(
              '5 DAKİKALIK KRİZ GERİ SAYIMI',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.bold,
                color: AppTheme.secondaryCyan,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '$m : $s',
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4EDEA3),
            letterSpacing: 2,
            fontFeatures: [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}
