import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/asset_model.dart';
import '../state/wallet_store.dart';
import '../utils/formatters.dart';

final _amountInputFormatters = <TextInputFormatter>[
  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
];

Future<void> _openSheet(BuildContext context, Widget child) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    useSafeArea: true,
    builder: (sheetContext) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(sheetContext).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: child,
      ),
    ),
  );
}

Future<void> showAddMoneySheet(BuildContext context, WalletStore store) =>
    _openSheet(context, _AddMoneySheet(store: store));

Future<void> showSendSheet(BuildContext context, WalletStore store) =>
    _openSheet(context, _SendSheet(store: store));

Future<void> showConvertSheet(
  BuildContext context,
  WalletStore store, {
  String? symbol,
  bool buy = true,
}) =>
    _openSheet(
      context,
      _ConvertSheet(
        store: store,
        initialSymbol: symbol ?? store.assets.first.symbol,
        initialBuy: buy,
      ),
    );

Future<void> showNotificationsSheet(BuildContext context, WalletStore store) =>
    _openSheet(context, _NotificationsSheet(store: store));

class _SheetTitle extends StatelessWidget {
  const _SheetTitle(this.title, this.subtitle);

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(color: Colors.black54)),
          ],
        ),
      );
}

// ---------------------------------------------------------------- Para ekle
class _AddMoneySheet extends StatefulWidget {
  const _AddMoneySheet({required this.store});

  final WalletStore store;

  @override
  State<_AddMoneySheet> createState() => _AddMoneySheetState();
}

class _AddMoneySheetState extends State<_AddMoneySheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final amount = parseAmount(_amountController.text)!;
    final messenger = ScaffoldMessenger.of(context);
    final error = widget.store.addMoney(amount);
    Navigator.pop(context);
    messenger.showSnackBar(
      SnackBar(content: Text(error ?? '${formatTry(amount)} cüzdanınıza eklendi.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SheetTitle('Para ekle', 'Banka hesabınızdan cüzdana para yatırın.'),
          TextFormField(
            controller: _amountController,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: _amountInputFormatters,
            decoration: const InputDecoration(
              labelText: 'Tutar',
              prefixText: '₺ ',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              final base = validateAmount(value);
              if (base != null) return base;
              if (parseAmount(value)! > 1000000) {
                return 'Tek seferde en fazla ₺ 1.000.000 eklenebilir.';
              }
              return null;
            },
            onFieldSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              for (final value in const [100, 500, 1000, 5000])
                ActionChip(
                  label: Text('₺ ${formatNumber(value.toDouble(), decimals: 0)}'),
                  onPressed: () => _amountController.text = value.toString(),
                ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(onPressed: _submit, child: const Text('Para ekle')),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------------ Gönder
class _SendSheet extends StatefulWidget {
  const _SendSheet({required this.store});

  final WalletStore store;

  @override
  State<_SendSheet> createState() => _SendSheetState();
}

class _SendSheetState extends State<_SendSheet> {
  final _formKey = GlobalKey<FormState>();
  final _recipientController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _recipientController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final amount = parseAmount(_amountController.text)!;
    final recipient = _recipientController.text.trim();
    final messenger = ScaffoldMessenger.of(context);
    final error = widget.store.send(recipient, amount);
    if (error != null) {
      messenger.showSnackBar(SnackBar(content: Text(error)));
      return;
    }
    Navigator.pop(context);
    messenger.showSnackBar(
      SnackBar(content: Text('${formatTry(amount)} $recipient kişisine gönderildi.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SheetTitle('Para gönder', 'Kullanılabilir nakit: ${formatTry(widget.store.cash)}'),
          TextFormField(
            controller: _recipientController,
            autofocus: true,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Alıcı (ad soyad veya IBAN)',
              border: OutlineInputBorder(),
            ),
            validator: (value) =>
                (value == null || value.trim().length < 3) ? 'Alıcı bilgisi girin.' : null,
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: _amountInputFormatters,
            decoration: const InputDecoration(
              labelText: 'Tutar',
              prefixText: '₺ ',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              final base = validateAmount(value);
              if (base != null) return base;
              if (parseAmount(value)! > widget.store.cash) {
                return 'Yetersiz bakiye.';
              }
              return null;
            },
            onFieldSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(onPressed: _submit, child: const Text('Gönder')),
          ),
        ],
      ),
    );
  }
}

// --------------------------------------------------------------- Dönüştür
class _ConvertSheet extends StatefulWidget {
  const _ConvertSheet({
    required this.store,
    required this.initialSymbol,
    required this.initialBuy,
  });

  final WalletStore store;
  final String initialSymbol;
  final bool initialBuy;

  @override
  State<_ConvertSheet> createState() => _ConvertSheetState();
}

class _ConvertSheetState extends State<_ConvertSheet> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  late bool _buy = widget.initialBuy;
  late String _symbol = widget.initialSymbol;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Asset get _asset => widget.store.assets.firstWhere((a) => a.symbol == _symbol);

  String? get _preview {
    final amount = parseAmount(_controller.text);
    if (amount == null || amount <= 0) return null;
    return _buy
        ? '≈ ${formatNumber(amount / _asset.price, decimals: 6)} $_symbol alacaksınız'
        : '≈ ${formatTry(amount * _asset.price)} nakit alacaksınız';
  }

  void _fillAll() {
    if (_buy) {
      final floored = (widget.store.cash * 100).floorToDouble() / 100;
      _controller.text = floored.toStringAsFixed(2);
    } else {
      final floored = (_asset.balance * 1e8).floorToDouble() / 1e8;
      _controller.text = floored.toStringAsFixed(8);
    }
  }

  String? _validate(String? value) {
    final base = validateAmount(value);
    if (base != null) return base;
    final amount = parseAmount(value)!;
    if (_buy) {
      if (amount > widget.store.cash + 0.005) {
        return 'Yetersiz nakit. Mevcut: ${formatTry(widget.store.cash)}';
      }
    } else {
      if (_asset.balance <= 0) return 'Bu varlıktan elinizde yok.';
      if (amount > _asset.balance + 1e-9) return 'Elinizdeki miktarı aşıyor.';
    }
    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final amount = parseAmount(_controller.text)!;
    final asset = _asset;
    final messenger = ScaffoldMessenger.of(context);
    final error = _buy
        ? widget.store.buy(_symbol, amount)
        : widget.store.sell(_symbol, amount);
    if (error != null) {
      setState(() => _error = error);
      return;
    }
    final message = _buy
        ? '${formatNumber(amount / asset.price, decimals: 6)} $_symbol satın alındı.'
        : '${formatNumber(amount, decimals: 6)} $_symbol satıldı.';
    Navigator.pop(context);
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final asset = _asset;
    final available = _buy
        ? 'Kullanılabilir nakit: ${formatTry(widget.store.cash)}'
        : 'Elinizdeki: ${formatNumber(asset.balance, decimals: 6)} $_symbol';
    final preview = _preview;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SheetTitle(
            'Dönüştür',
            'Güncel fiyat: 1 $_symbol = ${formatTry(asset.price)}',
          ),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<bool>(
              segments: const [
                ButtonSegment(
                  value: true,
                  label: Text('Al'),
                  icon: Icon(Icons.add_shopping_cart_rounded),
                ),
                ButtonSegment(
                  value: false,
                  label: Text('Sat'),
                  icon: Icon(Icons.sell_rounded),
                ),
              ],
              selected: {_buy},
              onSelectionChanged: (selection) {
                _controller.clear();
                setState(() {
                  _buy = selection.first;
                  _error = null;
                });
              },
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            children: [
              for (final a in widget.store.assets)
                ChoiceChip(
                  label: Text(a.symbol),
                  selected: _symbol == a.symbol,
                  onSelected: (_) {
                    _controller.clear();
                    setState(() {
                      _symbol = a.symbol;
                      _error = null;
                    });
                  },
                ),
            ],
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: _amountInputFormatters,
            decoration: InputDecoration(
              labelText: _buy ? 'Harcanacak tutar' : 'Satılacak miktar ($_symbol)',
              prefixText: _buy ? '₺ ' : null,
              helperText: available,
              border: const OutlineInputBorder(),
              suffix: TextButton(onPressed: _fillAll, child: const Text('Tümü')),
            ),
            validator: _validate,
            onFieldSubmitted: (_) => _submit(),
          ),
          if (preview != null) ...[
            const SizedBox(height: 10),
            Text(
              preview,
              style: const TextStyle(color: Color(0xFF0F766E), fontWeight: FontWeight.w600),
            ),
          ],
          if (_error != null) ...[
            const SizedBox(height: 10),
            Text(_error!, style: TextStyle(color: Colors.red.shade700)),
          ],
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _submit,
              child: Text(_buy ? '$_symbol satın al' : '$_symbol sat'),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------- Bildirimler
class _NotificationsSheet extends StatelessWidget {
  const _NotificationsSheet({required this.store});

  final WalletStore store;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final items = store.notifications;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Bildirimler',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(
                  onPressed: items.isEmpty ? null : store.clearNotifications,
                  child: const Text('Temizle'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (items.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.notifications_off_outlined, size: 40, color: Colors.black38),
                      SizedBox(height: 8),
                      Text('Yeni bildirim yok', style: TextStyle(color: Colors.black54)),
                    ],
                  ),
                ),
              )
            else
              for (final n in items)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFE0F2F1),
                    child: Icon(Icons.notifications_rounded, color: Color(0xFF0F766E)),
                  ),
                  title: Text(n.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Text('${n.body}\n${formatDate(n.time)}'),
                  isThreeLine: true,
                ),
          ],
        );
      },
    );
  }
}
