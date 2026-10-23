import 'package:flutter/material.dart';
import '../../../core/extensions/context_extensions.dart';
import '../controller/settings_controller.dart';

/// Modal dialog showing backup confirmation and stats
class SettingsBackupDialog extends StatelessWidget {
  const SettingsBackupDialog({super.key, required this.result});

  final SettingsBackupResult result;

  static Future<void> show(BuildContext context, SettingsBackupResult result) {
    return showDialog<void>(
      context: context,
      builder: (_) => SettingsBackupDialog(result: result),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: context.colors.successLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.cloud_done_rounded, color: context.colors.success, size: 22),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              context.loc.backupDialogTitle,
              style: context.typography.titleMedium?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      content: Text(
        context.loc.backupDialogContent(
          result.habitsCount,
          result.completionsCount,
          result.badgesCount,
        ),
        style: context.typography.bodyMedium,
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: context.colors.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            context.loc.backupOkAction,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

/// Confirmation dialog for user sign out
class SettingsLogoutDialog extends StatelessWidget {
  const SettingsLogoutDialog({super.key});

  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (_) => const SettingsLogoutDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      title: Text(
        context.loc.logoutAction,
        style: context.typography.titleMedium?.copyWith(
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
      ),
      content: Text(
        context.loc.confirmLogout,
        style: context.typography.bodyMedium,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            context.loc.cancelAction,
            style: TextStyle(color: context.colors.textMuted),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            context.loc.logoutAction,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
