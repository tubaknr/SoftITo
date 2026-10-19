/// Cüzdandaki bir kripto varlığı temsil eder.
class Asset {
  final String symbol;
  final String name;
  final double price; // 1 birimin TL fiyatı
  final double change24h; // son 24 saatteki değişim (%)
  final double balance; // eldeki miktar

  const Asset({
    required this.symbol,
    required this.name,
    required this.price,
    required this.change24h,
    required this.balance,
  });

  /// Eldeki miktarın TL karşılığı.
  double get value => price * balance;

  Asset copyWith({double? price, double? change24h, double? balance}) => Asset(
        symbol: symbol,
        name: name,
        price: price ?? this.price,
        change24h: change24h ?? this.change24h,
        balance: balance ?? this.balance,
      );
}
