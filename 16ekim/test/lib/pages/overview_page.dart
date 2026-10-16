import 'package:flutter/material.dart';

import '../state/wallet_store.dart';
import '../utils/formatters.dart';
import '../widgets/action_sheets.dart';
import '../widgets/asset_tile.dart';
import '../widgets/transaction_tile.dart';

class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key, required this.store, required this.onSeeAll});

  final WalletStore store;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    final latest = store.transactions.take(3).toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        _BalanceCard(store: store),
        const SizedBox(height: 24),
        const Text('Hızlı işlemler', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _QuickAction(
                icon: Icons.add_rounded,
                label: 'Para ekle',
                onTap: () => showAddMoneySheet(context, store),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickAction(
                icon: Icons.send_rounded,
                label: 'Gönder',
                onTap: () => showSendSheet(context, store),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickAction(
                icon: Icons.swap_horiz_rounded,
                label: 'Dönüştür',
                onTap: () => showConvertSheet(context, store),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _AllocationCard(store: store),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Son işlemler', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            TextButton(onPressed: onSeeAll, child: const Text('Tümünü gör')),
          ],
        ),
        const SizedBox(height: 4),
        if (latest.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: Text('Henüz işlem yok', style: TextStyle(color: Colors.black54))),
          )
        else
          for (final item in latest)
            TransactionTile(item: item, onTap: () => showTransactionDetail(context, item)),
      ],
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.store});

  final WalletStore store;

  @override
  Widget build(BuildContext context) {
    final hidden = store.balanceHidden;
    final change = store.dailyChangePercent;
    final up = change >= 0;
    String mask(String value) => hidden ? '₺ ••••••' : value;

    return Container(
      padding: const EdgeInsets.fromLTRB(22, 14, 22, 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0F766E), Color(0xFF14B8A6)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('Toplam bakiye', style: TextStyle(color: Colors.white70, fontSize: 15)),
              const Spacer(),
              IconButton(
                onPressed: store.toggleBalanceHidden,
                tooltip: hidden ? 'Bakiyeyi göster' : 'Bakiyeyi gizle',
                icon: Icon(
                  hidden ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          Text(
            mask(formatTry(store.totalBalance)),
            style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                up ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                color: Colors.white,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                hidden ? '•••' : '%${formatNumber(change.abs())} • Portföy 24 saat',
                style: const TextStyle(color: Color(0xFFD5F5F0), fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(child: _MiniStat(label: 'Nakit', value: mask(formatTry(store.cash)))),
              Expanded(
                child: _MiniStat(label: 'Varlıklar', value: mask(formatTry(store.portfolioValue))),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15),
          ),
        ],
      );
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                height: 62,
                width: double.infinity,
                child: Icon(icon, color: cashColor),
              ),
            ),
          ),
          const SizedBox(height: 7),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      );
}

/// Toplam bakiyenin nakit ve varlıklar arasında nasıl dağıldığını gösterir.
class _AllocationCard extends StatelessWidget {
  const _AllocationCard({required this.store});

  final WalletStore store;

  @override
  Widget build(BuildContext context) {
    final total = store.totalBalance;
    final parts = <({String label, double value, Color color})>[
      (label: 'Nakit', value: store.cash, color: cashColor),
      for (final a in store.assets) (label: a.symbol, value: a.value, color: assetColor(a.symbol)),
    ].where((p) => p.value > 0).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Dağılım', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          if (total <= 0 || parts.isEmpty)
            const Text('Henüz bakiye yok', style: TextStyle(color: Colors.black54))
          else ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: 12,
                child: Row(
                  children: [
                    for (final p in parts)
                      Expanded(
                        flex: ((p.value / total) * 1000).round().clamp(1, 1000).toInt(),
                        child: ColoredBox(color: p.color),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 6,
              children: [
                for (final p in parts)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(color: p.color, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${p.label} %${formatNumber(p.value / total * 100, decimals: 1)}',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
