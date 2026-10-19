import 'package:flutter/material.dart';

import '../models/asset_model.dart';
import '../state/wallet_store.dart';
import '../utils/formatters.dart';
import '../widgets/action_sheets.dart';
import '../widgets/asset_tile.dart';

class AssetsPage extends StatelessWidget {
  const AssetsPage({super.key, required this.store});

  final WalletStore store;

  Future<void> _refresh() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    store.refreshPrices();
  }

  void _openDetail(BuildContext context, Asset asset) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: assetColor(asset.symbol),
                  child: Text(
                    asset.symbol.substring(0, 1),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${asset.name} (${asset.symbol})',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 18),
            _InfoRow('Güncel fiyat', formatTry(asset.price)),
            _InfoRow(
              '24 saat',
              '${asset.change24h >= 0 ? '+' : ''}${formatNumber(asset.change24h)}%',
            ),
            _InfoRow('Elinizdeki', '${formatNumber(asset.balance, decimals: 6)} ${asset.symbol}'),
            _InfoRow('Değeri', formatTry(asset.value)),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.pop(sheetContext);
                      showConvertSheet(context, store, symbol: asset.symbol, buy: true);
                    },
                    icon: const Icon(Icons.add_shopping_cart_rounded),
                    label: const Text('Al'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: asset.balance <= 0
                        ? null
                        : () {
                            Navigator.pop(sheetContext);
                            showConvertSheet(context, store, symbol: asset.symbol, buy: false);
                          },
                    icon: const Icon(Icons.sell_rounded),
                    label: const Text('Sat'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final change = store.dailyChangePercent;
    final up = change >= 0;
    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          const Text('Portföy değeri', style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 4),
          Text(
            formatTry(store.portfolioValue),
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                up ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                size: 18,
                color: up ? Colors.green.shade700 : Colors.red.shade600,
              ),
              const SizedBox(width: 4),
              Text(
                '%${formatNumber(change.abs())} (24 saat)',
                style: TextStyle(
                  color: up ? Colors.green.shade700 : Colors.red.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Fiyatları yenilemek için aşağı çekin. Ayrıntı için varlığa dokunun.',
            style: TextStyle(color: Colors.black45, fontSize: 12),
          ),
          const SizedBox(height: 16),
          for (final asset in store.assets)
            AssetTile(asset: asset, onTap: () => _openDetail(context, asset)),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Colors.black54)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
      );
}
