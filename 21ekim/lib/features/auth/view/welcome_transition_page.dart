import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/fg_buttons.dart';
import '../../../core/widgets/fg_top_bar.dart';
import '../../../core/widgets/flower_painter.dart';
import '../../../core/widgets/gradient_scaffold.dart';
import '../../shell/controller/shell_controller.dart';
import '../../shell/view/shell_view.dart';

/// Başarılı Kayıt Sonrası Karşılama ve Geçiş Sayfası
class WelcomeTransitionPage extends StatefulWidget {
  final String userName;
  final VoidCallback? onProceed;

  const WelcomeTransitionPage({
    super.key,
    required this.userName,
    this.onProceed,
  });

  @override
  State<WelcomeTransitionPage> createState() => _WelcomeTransitionPageState();
}

class _WelcomeTransitionPageState extends State<WelcomeTransitionPage> {
  late final TapGestureRecognizer _tapRecognizer;

  @override
  void initState() {
    super.initState();
    _tapRecognizer = TapGestureRecognizer()..onTap = _handleProceed;
  }

  @override
  void dispose() {
    _tapRecognizer.dispose();
    super.dispose();
  }

  void _handleProceed() {
    widget.onProceed?.call();
    ShellController.instance.resetToHome();

    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => ShellView(
          onLogoutOrDelete: () {
            ShellController.instance.resetToHome();
          },
        ),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    final isDark = context.isDark;

    final proceedCapitalized = loc.isTr ? 'İlerle' : 'Proceed';

    return GradientScaffold(
      appBar: const FGTopBar(isAuthFlow: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Minik taze filiz çiçeği
              const Center(
                child: FlowerView(
                  stage: FlowerStage.sprout,
                  size: 200,
                ),
              ),
              const SizedBox(height: 36),

              // "Merhaba {kullanıcı ismi}"
              Text(
                loc.welcomeUser(widget.userName),
                textAlign: TextAlign.center,
                style: AppTypography.heading1Bold(isDark: isDark).copyWith(
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 20),

              // "Odaklanarak hayatını daha derinden hissetmeye başlamak için ilerle"
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: AppTypography.mottoText(isDark: isDark).copyWith(
                    fontSize: 18,
                    height: 1.6,
                  ),
                  children: [
                    TextSpan(text: loc.welcomeTransitionText),
                    TextSpan(
                      text: loc.proceedLink,
                      style: AppTypography.underlineLink(isDark: isDark).copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.dustyRoseAccent,
                      ),
                      recognizer: _tapRecognizer,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Dokunmayı kolaylaştıran zarif Pill butonu
              PrimaryPillButton(
                text: proceedCapitalized,
                onPressed: _handleProceed,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
