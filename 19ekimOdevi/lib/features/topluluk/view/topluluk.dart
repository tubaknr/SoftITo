import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/section_header.dart';
import '../controller/topluluk_controller.dart';
import '../models/topluluk_model.dart';
import '../widget/topluluk_gonderi_card.dart';

class ToplulukView extends StatefulWidget {
  final ToplulukController? controller;

  const ToplulukView({super.key, this.controller});

  @override
  State<ToplulukView> createState() => _ToplulukViewState();
}

class _ToplulukViewState extends State<ToplulukView> {
  late final ToplulukController _controller;
  late final bool _internalController;
  final TextEditingController _metinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
      _internalController = false;
    } else {
      _controller = ToplulukController();
      _internalController = true;
    }
  }

  @override
  void dispose() {
    _metinController.dispose();
    if (_internalController) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _showNewPostDialog() {
    _metinController.clear();
    final colors = context.spaceColors;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.isDark ? colors.nightBlue : colors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Toplulukta Paylaşım Yap',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _metinController,
                maxLength: 280,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText:
                      'Gelişmeleri, deneyimlerinizi veya sorularınızı paylaşın (en fazla 280 karakter)...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    final basarili = _controller.gonderiEkle(
                      metin: _metinController.text,
                    );
                    if (basarili) {
                      Navigator.of(ctx).pop();
                    }
                  },
                  icon: const Icon(Icons.send_rounded, size: 16),
                  label: const Text(AppStrings.paylas),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showReplyDialog(String gonderiId) {
    _metinController.clear();
    final colors = context.spaceColors;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.isDark ? colors.nightBlue : colors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Gönderiye Yanıt Yaz',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _metinController,
                maxLength: 280,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Yanıtınız (en fazla 280 karakter)...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    final basarili = _controller.yanitEkle(
                      gonderiId: gonderiId,
                      metin: _metinController.text,
                    );
                    if (basarili) {
                      Navigator.of(ctx).pop();
                    }
                  },
                  icon: const Icon(Icons.reply_rounded, size: 16),
                  label: const Text('Yanıtla'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ToplulukKullaniciDurumu>(
      valueListenable: _controller.kullaniciDurumu,
      builder: (context, durum, _) {
        final paylasabilir = durum == ToplulukKullaniciDurumu.onayli;

        return Scaffold(
          appBar: _buildAppBar(durum),
          body: Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    const SliverToBoxAdapter(
                      child: SectionHeader(
                        title: 'Girişimci Topluluğu',
                        subtitle:
                            'Kabul edilmiş girişimcilerin mikro-paylaşım akışı',
                      ),
                    ),
                    _buildGonderiList(paylasabilir),
                  ],
                ),
              ),
              if (!paylasabilir) _buildPermissionWarningBanner(),
            ],
          ),
          floatingActionButton: paylasabilir
              ? FloatingActionButton.extended(
                  onPressed: _showNewPostDialog,
                  icon: const Icon(Icons.edit_note_rounded),
                  label: const Text(AppStrings.paylas),
                )
              : null,
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(ToplulukKullaniciDurumu durum) {
    final colors = context.spaceColors;
    final isApproved = durum == ToplulukKullaniciDurumu.onayli;

    return AppBar(
      title: const Text('Girişimci Topluluğu'),
      actions: [
        TextButton.icon(
          onPressed: () {
            _controller.kullaniciDurumuAyarla(
              isApproved
                  ? ToplulukKullaniciDurumu.onaysiz
                  : ToplulukKullaniciDurumu.onayli,
            );
          },
          icon: Icon(
            isApproved
                ? Icons.verified_user_rounded
                : Icons.lock_outline_rounded,
            size: 16,
            color: isApproved ? colors.ascensionLime : colors.warningAmber,
          ),
          label: Text(
            isApproved ? 'Onaylı Girişimci' : 'Onaysız',
            style: TextStyle(
              fontSize: 12,
              color: isApproved ? colors.ascensionLime : colors.warningAmber,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionWarningBanner() {
    final colors = context.spaceColors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colors.warningAmber.withValues(alpha: 0.15),
        border: Border(
          top: BorderSide(color: colors.warningAmber.withValues(alpha: 0.3)),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 20,
            color: colors.warningAmber,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Paylaşım, beğeni ve yanıt için iş planınızın onaylanması gerekir.',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colors.warningAmber,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGonderiList(bool paylasabilir) {
    return ValueListenableBuilder<List<ToplulukGonderiModel>>(
      valueListenable: _controller.gonderiler,
      builder: (context, liste, _) {
        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final g = liste[index];
            return ToplulukGonderiCard(
              gonderi: g,
              paylasabilir: paylasabilir,
              onBegeni: () => _controller.begeniDegistir(g.id),
              onYanitla: () => _showReplyDialog(g.id),
            );
          }, childCount: liste.length),
        );
      },
    );
  }
}
