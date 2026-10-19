import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../core/widgets/starfield_background.dart';
import '../../analiz/view/analiz.dart';
import '../../fikir_durumu/view/fikir_durumu.dart';
import '../../mentor/view/mentor.dart';
import '../../programlar/view/programlar.dart';
import '../../topluluk/view/topluluk.dart';
import '../../yatirimci/view/yatirimci.dart';
import '../controller/shell_controller.dart';
import '../widget/shell_bottom_bar.dart';

class ShellView extends StatefulWidget {
  final ThemeController themeController;

  const ShellView({super.key, required this.themeController});

  @override
  State<ShellView> createState() => _ShellViewState();
}

class _ShellViewState extends State<ShellView> {
  late final ShellController _shellController;

  @override
  void initState() {
    super.initState();
    _shellController = ShellController();
  }

  @override
  void dispose() {
    _shellController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StarfieldBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _buildTopBar(context),
        body: ValueListenableBuilder<int>(
          valueListenable: _shellController.seciliSekmeIndex,
          builder: (context, index, _) {
            return IndexedStack(
              index: index,
              children: const [
                MentorView(),
                YatirimciView(),
                ProgramlarView(),
                ToplulukView(),
              ],
            );
          },
        ),
        bottomNavigationBar: ValueListenableBuilder<int>(
          valueListenable: _shellController.seciliSekmeIndex,
          builder: (context, index, _) {
            return ShellBottomBar(
              seciliIndex: index,
              onTabSelected: _shellController.sekmeDegistir,
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildTopBar(BuildContext context) {
    final colors = context.spaceColors;
    final isDark = context.isDark;

    return AppBar(
      title: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.nightBlue,
              border: Border.all(color: colors.border),
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/icons/app_icon.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.rocket_launch_rounded,
                  size: 18,
                  color: colors.rocketFlame,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            AppStrings.appName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: colors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          tooltip: 'İş Planı Analiz Testi',
          icon: Icon(Icons.assignment_outlined, color: colors.nebulaCyan),
          onPressed: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute<void>(builder: (_) => const AnalizView()));
          },
        ),
        IconButton(
          tooltip: AppStrings.fikirDurumum,
          icon: Icon(Icons.rocket_rounded, color: colors.rocketFlame),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const FikirDurumuView()),
            );
          },
        ),
        IconButton(
          tooltip: isDark
              ? 'Şafak Moduna Geç (Aydınlık)'
              : 'Derin Uzaya Geç (Karanlık)',
          icon: Icon(
            isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            color: isDark ? colors.ascensionLime : colors.starPurple,
          ),
          onPressed: widget.themeController.toggleTheme,
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}
