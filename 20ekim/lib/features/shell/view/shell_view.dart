import 'package:flutter/material.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../fikir_durumu/controller/fikir_durumu_controller.dart';
import '../../mentor/controller/mentor_controller.dart';
import '../../mentor/view/mentor.dart';
import '../../programlar/controller/program_controller.dart';
import '../../programlar/view/programlar.dart';
import '../../topluluk/controller/topluluk_controller.dart';
import '../../topluluk/view/topluluk.dart';
import '../../yatirimci/controller/yatirimci_controller.dart';
import '../../yatirimci/view/yatirimci.dart';
import '../controller/shell_controller.dart';

class ShellView extends StatefulWidget {
  const ShellView({super.key});

  @override
  State<ShellView> createState() => _ShellViewState();
}

class _ShellViewState extends State<ShellView> {
  late final ShellController _shellController;
  late final FikirDurumuController _fikirController;
  late final MentorController _mentorController;
  late final YatirimciController _yatirimciController;
  late final ProgramController _programController;
  late final ToplulukController _toplulukController;

  @override
  void initState() {
    super.initState();
    _shellController = ShellController();
    _fikirController = FikirDurumuController();
    _mentorController = MentorController();
    _yatirimciController = YatirimciController();
    _programController = ProgramController();
    _toplulukController = ToplulukController(initialOnayli: true);
  }

  @override
  void dispose() {
    _shellController.dispose();
    _fikirController.dispose();
    _mentorController.dispose();
    _yatirimciController.dispose();
    _programController.dispose();
    _toplulukController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;

    return ValueListenableBuilder<int>(
      valueListenable: _shellController.currentIndex,
      builder: (context, currentIndex, _) {
        return Scaffold(
          body: IndexedStack(
            index: currentIndex,
            children: [
              MentorView(
                mentorController: _mentorController,
                fikirController: _fikirController,
              ),
              YatirimciView(
                controller: _yatirimciController,
              ),
              ProgramlarView(
                controller: _programController,
              ),
              ToplulukView(
                controller: _toplulukController,
              ),
            ],
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: colors.outline, width: 1),
              ),
            ),
            child: NavigationBar(
              selectedIndex: currentIndex,
              onDestinationSelected: _shellController.setIndex,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.psychology_alt_rounded),
                  label: 'Mentor',
                ),
                NavigationDestination(
                  icon: Icon(Icons.rocket_launch_rounded),
                  label: 'Yatırımcılar',
                ),
                NavigationDestination(
                  icon: Icon(Icons.workspace_premium_rounded),
                  label: 'Programlar',
                ),
                NavigationDestination(
                  icon: Icon(Icons.hub_rounded),
                  label: 'Topluluk',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
