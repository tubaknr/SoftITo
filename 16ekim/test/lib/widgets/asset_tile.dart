import 'package:flutter/material.dart';

import '../models/asset_model.dart';
import '../utils/formatters.dart';

const cashColor = Color(0xFF0F766E);

Color assetColor(String symbol) => switch (symbol) {
      'BTC' => const Color(0xFFF59E0B),
      'ETH' => const Color(0xFF6366F1),
      'USDT' => const Color(0xFF22C55E),
      _ => cashColor,
    };

class AssetTile extends StatelessWidget {
  const AssetTile({super.key, required this.asset, required this.onTap});

  final Asset asset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final positive = asset.change24h >= 0;
    return Card(
      elevation: 0,
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: CircleAvatar(
          backgroundColor: assetColor(asset.symbol),
          child: Text(
            asset.symbol.substring(0, 1),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(asset.name, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(
          '${formatNumber(asset.balance, decimals: asset.balance < 1 ? 4 : 2)} ${asset.symbol}',
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(formatTry(asset.value), style: const TextStyle(fontWeight: FontWeight.w700)),
            Text(
              '${positive ? '+' : ''}${formatNumber(asset.change24h)}%',
              style: TextStyle(
                color: positive ? Colors.green.shade700 : Colors.red.shade600,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
