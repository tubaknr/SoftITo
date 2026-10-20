import 'package:flutter/material.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../controller/topluluk_controller.dart';
import '../models/topluluk_model.dart';
import '../widget/gonderi_item.dart';

class ToplulukView extends StatefulWidget {
  const ToplulukView({
    super.key,
    required this.controller,
  });

  final ToplulukController controller;

  @override
  State<ToplulukView> createState() => _ToplulukViewState();
}

class _ToplulukViewState extends State<ToplulukView> {
  void _openYeniGonderiSheet() {
    final colors = context.spaceColors;
    final textTheme = context.textTheme;
    final textController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final charCount = textController.text.length;
            final isOverLimit = charCount > 280;

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
                left: AppSpacing.xl,
                right: AppSpacing.xl,
                top: AppSpacing.lg,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Toplulukta Paylaş',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '$charCount / 280',
                        style: textTheme.labelMedium?.copyWith(
                          color: isOverLimit ? colors.danger : colors.textMuted,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: textController,
                    maxLines: 4,
                    maxLength: 280,
                    autofocus: true,
                    onChanged: (_) => setSheetState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Girişimindeki bir kilometre taşını ya da deneyimini anlat...',
                      counterText: '',
                      border: OutlineInputBorder(
                        borderRadius: AppRadius.sm,
                        borderSide: BorderSide(color: colors.outline),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  FilledButton(
                    onPressed: charCount > 0 && !isOverLimit
                        ? () {
                            final success = widget.controller.gonderiPaylas(
                              textController.text,
                            );
                            if (success) {
                              Navigator.of(context).pop();
                            } else {
                              _showErrorSnackBar();
                            }
                          }
                        : null,
                    child: const Text('Paylaş'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _openYanitSheet(String gonderiId) {
    final colors = context.spaceColors;
    final textTheme = context.textTheme;
    final textController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final charCount = textController.text.length;

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
                left: AppSpacing.xl,
                right: AppSpacing.xl,
                top: AppSpacing.lg,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Yanıt Yaz',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '$charCount / 280',
                        style: textTheme.labelMedium?.copyWith(color: colors.textMuted),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: textController,
                    maxLines: 3,
                    maxLength: 280,
                    autofocus: true,
                    onChanged: (_) => setSheetState(() {}),
                    decoration: const InputDecoration(
                      hintText: 'Girişimciye yanıtını yaz...',
                      counterText: '',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  FilledButton(
                    onPressed: charCount > 0
                        ? () {
                            final success = widget.controller.yanitEkle(
                              gonderiId,
                              textController.text,
                            );
                            if (success) {
                              Navigator.of(context).pop();
                            } else {
                              _showErrorSnackBar();
                            }
                          }
                        : null,
                    child: const Text('Yanıtı Gönder'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showErrorSnackBar() {
    final msg = widget.controller.hataMesaji.value;
    if (msg == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: context.spaceColors.danger,
      ),
    );
    widget.controller.hataTemizle();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final textTheme = context.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Girişimci Topluluğu'),
      ),
      body: Column(
        children: [
          // Feed List
          Expanded(
            child: ValueListenableBuilder<List<GonderiModel>>(
              valueListenable: widget.controller.gonderiler,
              builder: (context, gonderiler, _) {
                return ListView.builder(
                  itemCount: gonderiler.length,
                  itemBuilder: (context, index) {
                    final item = gonderiler[index];
                    return GonderiItem(
                      gonderi: item,
                      onBegen: () {
                        final ok = widget.controller.begen(item.id);
                        if (!ok) _showErrorSnackBar();
                      },
                      onYanitYaz: () => _openYanitSheet(item.id),
                    );
                  },
                );
              },
            ),
          ),

          // Bottom Bar: Action button or Unapproved banner
          ValueListenableBuilder<bool>(
            valueListenable: widget.controller.kullaniciOnayliMi,
            builder: (context, isOnayli, _) {
              if (isOnayli) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: AppSpacing.md,
                  ),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    border: Border(top: BorderSide(color: colors.outline, width: 1)),
                  ),
                  child: SafeArea(
                    top: false,
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: _openYeniGonderiSheet,
                            borderRadius: AppRadius.pill,
                            child: Container(
                              height: 44,
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.lg,
                              ),
                              decoration: BoxDecoration(
                                color: colors.surfaceHigh,
                                borderRadius: AppRadius.pill,
                                border: Border.all(color: colors.outline, width: 1),
                              ),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Neler oluyor? Paylaş...',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colors.textMuted,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        IconButton(
                          onPressed: _openYeniGonderiSheet,
                          icon: Icon(Icons.add_circle_rounded, color: colors.dawn, size: 36),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: AppSpacing.md,
                  ),
                  decoration: BoxDecoration(
                    color: colors.surfaceHigh,
                    border: Border(top: BorderSide(color: colors.outline, width: 1)),
                  ),
                  child: SafeArea(
                    top: false,
                    child: Row(
                      children: [
                        Icon(Icons.lock_outline_rounded, color: colors.warning, size: 20),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            'Paylaşım ve yanıt için iş planınızın onaylanması gerekir.',
                            style: textTheme.bodySmall?.copyWith(color: colors.textMuted),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
