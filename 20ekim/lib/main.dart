import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/shell/view/shell_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeController.instance.init();
  runApp(const YorungeApp());
}

class YorungeApp extends StatelessWidget {
  const YorungeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.instance.themeMode,
      builder: (context, themeMode, _) {
        return MaterialApp(
          title: 'Yörünge',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.day,
          darkTheme: AppTheme.night,
          themeMode: themeMode,
          home: const ShellView(),
        );
      },
    );
  }
}
