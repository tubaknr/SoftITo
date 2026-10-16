import 'package:flutter/material.dart';

import '../state/wallet_store.dart';
import '../utils/formatters.dart';
import '../widgets/transaction_tile.dart';

enum _TxFilter { all, income, expense }

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key, required this.store});

  final WalletStore store;

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  _TxFilter _filter = _TxFilter.all;

  @override
  Widget build(BuildContext context) {
    final store = widget.store;
    final items = store.transactions.where((t) {
      switch (_filter) {
        case _TxFilter.all:
          return true;
        case _TxFilter.income:
          return !t.isExpense;
        case _TxFilter.expense:
          return t.isExpense;
      }
    }).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                label: 'Toplam gelir',
                value: formatTry(store.totalIncome),
                color: Colors.green.shade700,
                icon: Icons.south_west_rounded,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SummaryCard(
                label: 'Toplam gider',
                value: formatTry(store.totalExpense),
                color: Colors.red.shade600,
                icon: Icons.north_east_rounded,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: SegmentedButton<_TxFilter>(
            segments: const [
              ButtonSegment(value: _TxFilter.all, label: Text('Tümü')),
              ButtonSegment(value: _TxFilter.income, label: Text('Gelir')),
              ButtonSegment(value: _TxFilter.expense, label: Text('Gider')),
            ],
            selected: {_filter},
            onSelectionChanged: (selection) => setState(() => _filter = selection.first),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '${items.length} işlem',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),
        if (items.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.inbox_rounded, size: 40, color: Colors.black38),
                  SizedBox(height: 8),
                  Text('Bu filtrede işlem yok', style: TextStyle(color: Colors.black54)),
                ],
              ),
            ),
          )
        else
          for (final item in items)
            TransactionTile(item: item, onTap: () => showTransactionDetail(context, item)),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  final String label;
  final String value;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: color),
                const SizedBox(width: 6),
                Text(label, style: const TextStyle(color: Colors.black54, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 6),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ),
          ],
        ),
      );
}
