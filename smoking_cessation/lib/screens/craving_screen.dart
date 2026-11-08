// ========================================
// DOSYA: craving_screen.dart
// NE İŞE YARAR: Kriz anında 5 dk geri sayım
// ve 4-7-8 nefes egzersizi ekranını sunar.
// NASIL ÇALIŞIR: CravingController dinler,
// saniye ve faz durumuna göre arayüz çizer.
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

  void _onClose() {
    _controller?.stopSession();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = _controller ?? AppScope.of(context).cravingController;

    return Scaffold(
      backgroundColor: AppTheme.surfaceLowest,
      body: ListenableBuilder(
        listenable: ctrl,
        builder: (context, _) => SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            children: _buildContent(ctrl),
          ),
        ),
      ),
    );
  }

  // Sayfa içerik widget listesi.
  List<Widget> _buildContent(CravingController ctrl) {
    return [
      _buildTopHeader(),
      const SizedBox(height: 20),
      CravingTimerHeader(
        remainingSeconds: ctrl.remainingSeconds,
      ),
      const SizedBox(height: 16),
      BreathingCircle(
        progress: ctrl.phaseProgress,
        phaseTitle: ctrl.phaseTitle,
        phase: ctrl.currentPhase,
        countdown: ctrl.phaseCountdown,
      ),
      const SizedBox(height: 14),
      NatureSoundPill(
        isPlaying: ctrl.isNatureSoundPlaying,
        onToggle: ctrl.toggleNatureSound,
      ),
      const SizedBox(height: 20),
      const BiologicalFactCard(),
      const SizedBox(height: 20),
      _buildWinButton(ctrl),
    ];
  }

  // Üst SOS başlık ve kapatma butonu.
  Widget _buildTopHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                '● SOS ACİL RAHATLAMA',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.secondaryCyan,
                  letterSpacing: 0.6,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Derin Bir Nefes Al, Bu Kriz Geçecek',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          style: IconButton.styleFrom(
            backgroundColor: const Color(0x1AFFFFFF),
            shape: const CircleBorder(),
          ),
          icon: const Icon(Icons.close_rounded, color: Colors.white),
          onPressed: _onClose,
        ),
      ],
    );
  }

  // Krizi yendim başarı ve kapatma butonu.
  Widget _buildWinButton(CravingController ctrl) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primary,
          foregroundColor: const Color(0xFF022C22),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
        ),
        onPressed: () {
          ctrl.completeSession();
          Navigator.of(context).pop();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.check_circle_outline_rounded,
              color: Color(0xFF022C22),
              size: 22,
            ),
            SizedBox(width: 8),
            Text(
              'Krizi Yendim!',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFF022C22),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
