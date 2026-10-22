import 'package:flutter/material.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/gradient_scaffold.dart';
import '../../../core/widgets/penguin_mascot_painter.dart';
import '../../auth/controller/auth_controller.dart';
import '../../shell/view/shell_page.dart';

/// Post-registration transition page (Sayfa 2)
class WelcomeAfterRegisterPage extends StatelessWidget {
  const WelcomeAfterRegisterPage({super.key, required this.authController});

  final AuthController authController;

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
        child: Column(
          children: [
            const Spacer(),
            const PenguinMascotWidget(
              pose: PenguinPose.celebrating,
              size: 220,
            ),
            const SizedBox(height: 32),
            _buildPostRegisterText(context),
            const Spacer(),
            _buildProceedButton(context),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildPostRegisterText(BuildContext context) {
    return Column(
      children: [
        Text(
          context.loc.mottoQuestion,
          textAlign: TextAlign.center,
          style: context.typography.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: context.colors.textMain,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          '"${context.loc.brandMotto}"',
          textAlign: TextAlign.center,
          style: context.typography.bodyMedium?.copyWith(
            color: context.colors.textMuted,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildProceedButton(BuildContext context) {
    return Column(
      children: [
        PrimaryGradientButton(
          label: context.loc.proceedAction,
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (_) => ShellPage(authController: authController),
              ),
              (route) => false,
            );
          },
        ),
        const SizedBox(height: 16),
        UnderlineLinkButton(
          label: context.loc.proceedAction,
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (_) => ShellPage(authController: authController),
              ),
              (route) => false,
            );
          },
        ),
      ],
    );
  }
}
