import 'dart:math';

import 'package:flutter/material.dart';

import '../models/app_notification.dart';
import '../models/asset_model.dart';
import '../models/transaction_model.dart';
import '../utils/formatters.dart';

/// Uygulamanın tüm durumu (bakiye, varlıklar, işlemler, bildirimler) burada tutulur.
/// Sayfalar bu sınıfı dinler; veri değişince ekran kendiliğinden yenilenir.
/// Hata döndürebilen işlemler `String?` verir: null = başarılı, metin = hata mesajı.
class WalletStore extends ChangeNotifier {
  WalletStore() {
    final now = DateTime.now();
    _transactions.addAll([
      TransactionItem(
        id: '1',
        title: 'Bitcoin alımı',
        category: 'Yatırım',
        date: now.subtract(const Duration(hours: 2)),
        amount: 2500,
        isExpense: true,
        icon: Icons.add_shopping_cart_rounded,
      ),
      TransactionItem(
        id: '2',
        title: 'Para yatırma',
        category: 'Banka transferi',
        date: now.subtract(const Duration(days: 1)),
        amount: 5000,
        isExpense: false,
        icon: Icons.account_balance_rounded,
      ),
      TransactionItem(
        id: '3',
        title: 'Ethereum satışı',
        category: 'Yatırım',
        date: now.subtract(const Duration(days: 3)),
        amount: 1850,
        isExpense: false,
        icon: Icons.sell_rounded,
      ),
      TransactionItem(
        id: '4',
        title: 'Para gönderme',
        category: 'Transfer',
        date: now.subtract(const Duration(days: 5)),
        amount: 1200,
        isExpense: true,
        icon: Icons.north_east_rounded,
      ),
    ]);
    _notifications.add(AppNotification(
      title: 'Hoş geldiniz',
      body: 'Kumbara cüzdanınız kullanıma hazır.',
      time: now,
    ));
    _unread = 1;
  }

  final Random _random = Random();
  double _cash = 24500;
  bool _balanceHidden = false;
  int _unread = 0;
  int _nextId = 5;

  List<Asset> _assets = [
    const Asset(symbol: 'BTC', name: 'Bitcoin', price: 3562000, change24h: 2.14, balance: 0.018),
    const Asset(symbol: 'ETH', name: 'Ethereum', price: 126400, change24h: -0.82, balance: 0.76),
    const Asset(symbol: 'USDT', name: 'Tether', price: 34.20, change24h: 0.03, balance: 425.0),
  ];
  final List<TransactionItem> _transactions = [];
  final List<AppNotification> _notifications = [];

  // ---------- Okunabilir değerler ----------
  double get cash => _cash;
  bool get balanceHidden => _balanceHidden;
  int get unreadCount => _unread;
  List<Asset> get assets => List.unmodifiable(_assets);
  List<TransactionItem> get transactions => List.unmodifiable(_transactions);
  List<AppNotification> get notifications => List.unmodifiable(_notifications);

  double get portfolioValue => _assets.fold(0.0, (sum, a) => sum + a.value);
  double get totalBalance => _cash + portfolioValue;

  /// Portföyün ağırlıklı 24 saatlik değişimi (%).
  double get dailyChangePercent {
    final pv = portfolioValue;
    if (pv == 0) return 0;
    return _assets.fold(0.0, (sum, a) => sum + a.value * a.change24h) / pv;
  }

  double get totalIncome =>
      _transactions.where((t) => !t.isExpense).fold(0.0, (s, t) => s + t.amount);
  double get totalExpense =>
      _transactions.where((t) => t.isExpense).fold(0.0, (s, t) => s + t.amount);

  // ---------- İşlemler ----------
  String? addMoney(double amount) {
    final value = roundMoney(amount);
    if (value <= 0) return 'Geçerli bir tutar girin.';
    _cash = roundMoney(_cash + value);
    _record(
      title: 'Para yatırma',
      category: 'Banka transferi',
      amount: value,
      isExpense: false,
      icon: Icons.account_balance_rounded,
      notifyTitle: 'Para yatırıldı',
      notifyBody: '${formatTry(value)} cüzdanınıza eklendi.',
    );
    return null;
  }

  String? send(String recipient, double amount) {
    final value = roundMoney(amount);
    if (recipient.trim().length < 3) return 'Alıcı bilgisi girin.';
    if (value <= 0) return 'Geçerli bir tutar girin.';
    if (value > _cash) return 'Yetersiz bakiye. Mevcut nakit: ${formatTry(_cash)}';
    _cash = roundMoney(_cash - value);
    _record(
      title: '${recipient.trim()} kişisine gönderim',
      category: 'Transfer',
      amount: value,
      isExpense: true,
      icon: Icons.north_east_rounded,
      notifyTitle: 'Para gönderildi',
      notifyBody: '${formatTry(value)} ${recipient.trim()} kişisine gönderildi.',
    );
    return null;
  }

  /// [tryAmount] kadar TL ile varlık satın alır.
  String? buy(String symbol, double tryAmount) {
    final index = _assets.indexWhere((a) => a.symbol == symbol);
    if (index == -1) return 'Varlık bulunamadı.';
    var spend = roundMoney(tryAmount);
    if (spend <= 0) return 'Geçerli bir tutar girin.';
    if (spend > _cash) {
      if (spend - _cash < 0.01) {
        spend = _cash;
      } else {
        return 'Yetersiz nakit bakiye.';
      }
    }
    final asset = _assets[index];
    final quantity = spend / asset.price;
    _assets[index] = asset.copyWith(balance: asset.balance + quantity);
    _cash = roundMoney(_cash - spend);
    _record(
      title: '${asset.name} alımı',
      category: 'Yatırım',
      amount: spend,
      isExpense: true,
      icon: Icons.add_shopping_cart_rounded,
      notifyTitle: 'Alım tamamlandı',
      notifyBody: '${formatNumber(quantity, decimals: 6)} ${asset.symbol} satın alındı.',
    );
    return null;
  }

  /// [quantity] adet varlığı satıp TL'ye çevirir.
  String? sell(String symbol, double quantity) {
    final index = _assets.indexWhere((a) => a.symbol == symbol);
    if (index == -1) return 'Varlık bulunamadı.';
    if (quantity <= 0) return 'Geçerli bir miktar girin.';
    final asset = _assets[index];
    var qty = quantity;
    if (qty > asset.balance) {
      if (qty - asset.balance < 1e-7) {
        qty = asset.balance;
      } else {
        return 'Elinizdeki ${asset.symbol} miktarını aşıyor.';
      }
    }
    final proceeds = roundMoney(qty * asset.price);
    var remaining = asset.balance - qty;
    if (remaining < 1e-9) remaining = 0;
    _assets[index] = asset.copyWith(balance: remaining);
    _cash = roundMoney(_cash + proceeds);
    _record(
      title: '${asset.name} satışı',
      category: 'Yatırım',
      amount: proceeds,
      isExpense: false,
      icon: Icons.sell_rounded,
      notifyTitle: 'Satış tamamlandı',
      notifyBody: '${formatNumber(qty, decimals: 6)} ${asset.symbol} satıldı, ${formatTry(proceeds)} nakde eklendi.',
    );
    return null;
  }

  /// Piyasa fiyatlarını küçük rastgele oynatır (demo amaçlı "yenile").
  void refreshPrices() {
    _assets = _assets.map((a) {
      final range = a.symbol == 'USDT' ? 0.2 : 4.0;
      final pct = _random.nextDouble() * range - range / 2;
      return a.copyWith(
        price: a.price * (1 + pct / 100),
        change24h: a.change24h + pct,
      );
    }).toList();
    notifyListeners();
  }

  // ---------- Arayüz durumu ----------
  void toggleBalanceHidden() {
    _balanceHidden = !_balanceHidden;
    notifyListeners();
  }

  void markAllRead() {
    if (_unread == 0) return;
    _unread = 0;
    notifyListeners();
  }

  void clearNotifications() {
    _notifications.clear();
    _unread = 0;
    notifyListeners();
  }

  // ---------- İç yardımcı ----------
  void _record({
    required String title,
    required String category,
    required double amount,
    required bool isExpense,
    required IconData icon,
    required String notifyTitle,
    required String notifyBody,
  }) {
    final now = DateTime.now();
    _transactions.insert(
      0,
      TransactionItem(
        id: '${_nextId++}',
        title: title,
        category: category,
        date: now,
        amount: amount,
        isExpense: isExpense,
        icon: icon,
      ),
    );
    _notifications.insert(0, AppNotification(title: notifyTitle, body: notifyBody, time: now));
    if (_notifications.length > 30) _notifications.removeLast();
    _unread++;
    notifyListeners();
  }
}
