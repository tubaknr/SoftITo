import 'package:flutter/material.dart';
import '../extensions/context_extensions.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    required this.title,
    required this.content,
    this.confirmLabel,
    this.cancelLabel,
    this.isDestructive = false,
    super.key,
  });

  final String title;
  final String content;
  final String? confirmLabel;
  final String? cancelLabel;
  final bool isDestructive;

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String content,
    String? confirmLabel,
    String? cancelLabel,
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext ctx) => ConfirmDialog(
        title: title,
        content: content,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        isDestructive: isDestructive,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String resolvedCancel = cancelLabel ?? context.l10n.dialogCancel;
    final String resolvedConfirm = confirmLabel ??
        (isDestructive ? context.l10n.dialogDelete : context.l10n.dialogConfirm);

    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(resolvedCancel),
        ),
        FilledButton(
          style: isDestructive
              ? FilledButton.styleFrom(
                  backgroundColor: context.colorScheme.error,
                  foregroundColor: context.colorScheme.onError,
                )
              : null,
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(resolvedConfirm),
        ),
      ],
    );
  }
}
