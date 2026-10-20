import 'package:flutter/material.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';

class SignaturePad extends StatefulWidget {
  const SignaturePad({
    required this.title,
    required this.onSaved,
    this.initialSigned = false,
    super.key,
  });

  final String title;
  final ValueChanged<bool> onSaved;
  final bool initialSigned;

  @override
  State<SignaturePad> createState() => _SignaturePadState();
}

class _SignaturePadState extends State<SignaturePad> {
  final List<Offset?> _points = <Offset?>[];
  late bool _isSigned;

  @override
  void initState() {
    super.initState();
    _isSigned = widget.initialSigned;
  }

  void _clear() {
    setState(() {
      _points.clear();
      _isSigned = false;
    });
    widget.onSaved(false);
  }

  void _save() {
    if (_points.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen önce imza alanına çizim yapınız.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    setState(() => _isSigned = true);
    widget.onSaved(true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.signatureSaved),
        backgroundColor: context.appColors.success,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              widget.title,
              style: context.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: context.colorScheme.onSurface,
              ),
            ),
            if (_isSigned)
              Row(
                children: <Widget>[
                  Icon(
                    Icons.check_circle_rounded,
                    size: 16,
                    color: context.appColors.success,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'İmzalandı',
                    style: context.textTheme.labelSmall?.copyWith(
                      color: context.appColors.success,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          height: 160.0,
          decoration: BoxDecoration(
            color: context.colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: _isSigned
                  ? context.appColors.success
                  : context.colorScheme.outlineVariant,
              width: _isSigned ? 1.5 : 1.0,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: <Widget>[
              if (_points.isEmpty && !_isSigned)
                Center(
                  child: Text(
                    context.l10n.signaturePadHint,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.onSurfaceVariant.withAlpha(150),
                    ),
                  ),
                ),
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onPanStart: (DragStartDetails details) {
                    setState(() {
                      _points.add(details.localPosition);
                    });
                  },
                  onPanUpdate: (DragUpdateDetails details) {
                    setState(() {
                      _points.add(details.localPosition);
                    });
                  },
                  onPanEnd: (DragEndDetails details) {
                    setState(() {
                      _points.add(null);
                    });
                  },
                  child: CustomPaint(
                    painter: _SignaturePainter(
                      points: _points,
                      strokeColor: context.colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            TextButton.icon(
              onPressed: _points.isEmpty && !_isSigned ? null : _clear,
              icon: const Icon(Icons.delete_outline_rounded, size: 16),
              label: Text(context.l10n.clearSignature),
            ),
            const SizedBox(width: AppSpacing.sm),
            FilledButton.tonalIcon(
              onPressed: _points.isEmpty || _isSigned ? null : _save,
              icon: const Icon(Icons.save_rounded, size: 16),
              label: Text(context.l10n.saveSignature),
            ),
          ],
        ),
      ],
    );
  }
}

class _SignaturePainter extends CustomPainter {
  const _SignaturePainter({
    required this.points,
    required this.strokeColor,
  });

  final List<Offset?> points;
  final Color strokeColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = strokeColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_SignaturePainter oldDelegate) => true;
}
