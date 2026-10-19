import 'package:flutter/material.dart';

import '../models/transaction_model.dart';
import '../utils/formatters.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({super.key, required this.item, required this.onTap});

  final TransactionItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = item.isExpense ? Colors.red.shade600 : Colors.green.shade700;
    return Card(
      elevation: 0,
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        leading: CircleAvatar(
          backgroundColor: item.isExpense ? const Color(0xFFFEE2E2) : const Color(0xFFDCFCE7),
          child: Icon(item.icon, color: color),
        ),
        title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text('${item.category} • ${formatDate(item.date)}'),
        trailing: Text(
          '${item.isExpense ? '-' : '+'}${formatTry(item.amount)}',
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

/// İşlem satırına dokunulunca açılan detay penceresi.
Future<void> showTransactionDetail(BuildContext context, TransactionItem item) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(item.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _DetailRow('İşlem no', '#${item.id}'),
          _DetailRow('Kategori', item.category),
          _DetailRow('Tarih', formatDate(item.date)),
          _DetailRow('Tür', item.isExpense ? 'Gider' : 'Gelir'),
          _DetailRow('Tutar', '${item.isExpense ? '-' : '+'}${formatTry(item.amount)}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Tamam'),
        ),
      ],
    ),
  );
}

class _DetailRow extends StatelessWidget {
  const _DetailRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Colors.black54)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      );
}
