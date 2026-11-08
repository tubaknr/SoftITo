// ========================================
// DOSYA: craving_screen.dart
// NE İŞE YARAR: Kriz anında 5 dk geri sayım
// ve nefes egzersizi sunar.
// NASIL ÇALIŞIR: CravingController ile nefes
// fazı, sözler ve sayacı yönetir.
// SOLID: SRP - Kriz müdahale arayüzü sunar.
// ========================================

import 'package:flutter/material.dart';
import '../features/craving/craving_controller.dart';
import '../main.dart';
import '../theme/app_theme.dart';
import '../widgets/breathing_circle.dart';

// SRP: Canım çekti kriz müdahale ekranı.
class CravingScreen extends StatefulWidget {
  const CravingScreen({super.key});

  @override
  State<CravingScreen> createState() => _CravingScreenState();
}

class _CravingScreenState extends State<CravingScreen> {
  CravingController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller == null) {
      _controller = AppScope.of(context).cravingController;
      _controller!.startSession();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = _controller ?? AppScope.of(context).cravingController;

    return Scaffold(
      backgroundColor: AppTheme.surfaceLowest,
      appBar: AppBar(
        title: const Text('Kriz Müdahalesi'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () {
            ctrl.stopSession();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ListenableBuilder(
        listenable: ctrl,
        builder: (context, _) => SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _buildTimerSection(ctrl),
              const SizedBox(height: 16),
              BreathingCircle(
                progress: ctrl.phaseProgress,
                phaseTitle: ctrl.phaseTitle,
                phase: ctrl.currentPhase,
              ),
              const SizedBox(height: 16),
              _buildQuoteCard(ctrl),
              const SizedBox(height: 20),
              _buildActionFooter(ctrl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimerSection(CravingController ctrl) {
    final m = (ctrl.remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (ctrl.remainingSeconds % 60).toString().padLeft(2, '0');

    return Column(
      children: [
        Text(
          ctrl.isSuccess ? '00:00' : '$m:$s',
          style: AppTheme.displayCounter.copyWith(
            color: AppTheme.secondaryCyan,
            fontSize: 44,
          ),
        ),
        const SizedBox(height: 4),
        const Text('Kriz isteği ortalama 3-5 dk sürer',
            style: AppTheme.bodySmall),
      ],
    );
  }

  Widget _buildQuoteCard(CravingController ctrl) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.outline),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.format_quote_rounded,
                  color: AppTheme.warningAmber, size: 20),
              const SizedBox(width: 8),
              const Expanded(
                child: Text('MOTİVASYON', style: AppTheme.labelCaps),
              ),
              IconButton(
                icon: const Icon(Icons.refresh_rounded, size: 20),
                color: AppTheme.onSurfaceVariant,
                onPressed: ctrl.nextQuote,
                tooltip: 'Yeni Söz',
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '"${ctrl.currentQuote}"',
            textAlign: TextAlign.center,
            style: AppTheme.bodyLarge.copyWith(fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Widget _buildActionFooter(CravingController ctrl) {
    if (ctrl.isSuccess) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.primaryContainer,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.outlineActive),
        ),
        child: Column(
          children: [
            const Icon(Icons.check_circle_rounded,
                color: AppTheme.primary, size: 36),
            const SizedBox(height: 8),
            const Text('Başardın! Krizi Yendin.',
                style: AppTheme.titleSmall),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: AppTheme.surfaceLowest,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Geri Dön'),
            ),
          ],
        ),
      );
    }

    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primary,
        foregroundColor: AppTheme.surfaceLowest,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      icon: const Icon(Icons.sentiment_very_satisfied_rounded),
      label: const Text(
        'Krizi Yendim! (Temizim)',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      onPressed: ctrl.completeSession,
    );
  }
}
