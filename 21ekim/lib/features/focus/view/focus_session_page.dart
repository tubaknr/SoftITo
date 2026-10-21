import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/fg_buttons.dart';
import '../../../core/widgets/flower_painter.dart';
import '../../../core/widgets/gradient_scaffold.dart';
import '../controller/focus_controller.dart';

/// Odaklanma Oturumu Ekranı (Kilitli Tam Ekran Mod, Sıfır Dikkat Dağınıklığı)
class FocusSessionPage extends StatefulWidget {
  const FocusSessionPage({super.key});

  @override
  State<FocusSessionPage> createState() => _FocusSessionPageState();
}

class _FocusSessionPageState extends State<FocusSessionPage>
    with WidgetsBindingObserver {
  static const MethodChannel _windowChannel =
      MethodChannel('focus_and_grow/window');
  bool _isStopping = false;
  bool _isReady = false;
  Size? _initialSize;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    FocusController.instance.startFocusSession();
    _setupFullScreen();
  }

  Future<void> _setupFullScreen() async {
    await _enterFullScreen();

    if (!kIsWeb && Platform.isMacOS) {
      try {
        _windowChannel.setMethodCallHandler((call) async {
          if (call.method == 'onWindowShrink' && _isReady) {
            _handleStop();
          }
        });
      } catch (_) {}
    }

    if (const bool.fromEnvironment('FLUTTER_TEST')) {
      if (mounted) {
        _initialSize = MediaQuery.maybeOf(context)?.size;
        _isReady = true;
      }
    } else {
      // Ekranın tam ekrana geçiş animasyonunun tamamlanmasını bekle (1200ms)
      await Future<void>.delayed(const Duration(milliseconds: 1200));
      if (mounted) {
        _initialSize = MediaQuery.maybeOf(context)?.size;
        _isReady = true;
      }
    }
  }

  Future<void> _enterFullScreen() async {
    try {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } catch (_) {}

    if (!const bool.fromEnvironment('FLUTTER_TEST') &&
        !kIsWeb &&
        Platform.isMacOS) {
      try {
        await _windowChannel.invokeMethod('enterFullScreen');
      } catch (_) {}
    }
  }

  Future<void> _exitFullScreen() async {
    try {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    } catch (_) {}

    if (!const bool.fromEnvironment('FLUTTER_TEST') &&
        !kIsWeb &&
        Platform.isMacOS) {
      try {
        await _windowChannel.invokeMethod('exitFullScreen');
      } catch (_) {}
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (!_isReady) return;
    // Mobilde veya masaüstünde kullanıcı başka uygulamaya geçerse, arka plana atarsa veya pencereyi gizlerse
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      _handleStop();
    }
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    if (!_isReady) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _isStopping || !_isReady) return;
      final currentSize = MediaQuery.maybeOf(context)?.size;
      if (currentSize != null && _initialSize != null) {
        // Eğer ekran boyutu başlangıçtaki tam ekran boyutundan belirgin şekilde (en az 100px) küçültülmüşse
        if (currentSize.width < _initialSize!.width - 100 ||
            currentSize.height < _initialSize!.height - 100) {
          _handleStop();
        }
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (!kIsWeb && Platform.isMacOS) {
      try {
        _windowChannel.setMethodCallHandler(null);
      } catch (_) {}
    }
    _exitFullScreen();
    super.dispose();
  }

  Future<void> _handleStop() async {
    if (_isStopping) return;
    _isStopping = true;

    final recordedSeconds = await FocusController.instance.stopFocusSession();
    await _exitFullScreen();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.dustyRoseAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Text(
          'Odaklanma tamamlandı! Süre: ${FocusController.formatDigitalTime(recordedSeconds)}',
          style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
    );

    if (mounted) {
      Navigator.maybeOf(context)?.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    final isDark = context.isDark;

    return PopScope(
      canPop: false, // Odaklanırken geri tuşu ve kaydırma hareketi kesinlikle engellenir
      child: GradientScaffold(
        showWatermark: false, // Odak oturumunda tam sıfır dikkat dağınıklığı
        body: SafeArea(
          child: ValueListenableBuilder<List<dynamic>>(
            valueListenable: FocusController.instance,
            builder: (context, _, __) {
              final stage = FocusController.instance.currentFlowerStage;

              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),

                      // Ekranın merkezinde dev, meditatif çiçek
                      FlowerView(
                        stage: stage,
                        size: 290,
                      ),
                      const SizedBox(height: 36),

                      // Büyük ve zarif sayaç (00:45:56)
                      ValueListenableBuilder<int>(
                        valueListenable: FocusController.instance.elapsedSeconds,
                        builder: (context, elapsed, _) {
                          return Text(
                            FocusController.formatDigitalTime(elapsed),
                            style: AppTypography.timerDisplay(isDark: isDark),
                          );
                        },
                      ),
                      const SizedBox(height: 48),

                      // Tek Aksiyon Butonu: "Durdur"
                      StopButton(
                        label: loc.stopFocus,
                        onPressed: _handleStop,
                      ),

                      const Spacer(),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
