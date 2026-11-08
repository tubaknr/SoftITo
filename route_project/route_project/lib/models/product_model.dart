class ProductModel { // Tek Bir Ürünün Verisini Tutan Model Class'ıdır.
  final int id; // Ürünün Benzersiz id'sidir.
  final String title; // Ürünün Adıdır.
  final double price; // Ürünün Fiyatıdır.
  final String imageUrl; // Ürün Görselinin URL'idir.
  final String category; // Ürünün Ait Olduğu Kategoridir.

  const ProductModel({ // Tüm Field'ları required Alan const Constructor'dır.
    required this.id, // id Field'ını required Yapar.
    required this.title, // title Field'ını required Yapar.
    required this.price, // price Field'ını required Yapar.
    required this.imageUrl, // imageUrl Field'ını required Yapar.
    required this.category, // category Field'ını required Yapar.
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) { // JSON Map'inden ProductModel Üreten factory Constructor'dır.
    return ProductModel( // Okunan Değerlerle Yeni Bir ProductModel Döndürür.
      id: json['id'] as int? ?? 0, // id null İse 0 Kullanır.
      title: json['title'] as String? ?? 'İsimsiz Ürün', // title null İse 'İsimsiz Ürün' Kullanır.
      price: (json['price'] as num?)?.toDouble() ?? 0.0, // price'ı double'a Çevirir, null İse 0.0 Kullanır.
      imageUrl: // imageUrl Field'ının Değerini Belirler.
          json['image'] as String? ?? // JSON'daki image Değerini String Olarak Okur.
          'https://via.placeholder.com/150?text=Resim+Yok', // image null İse Placeholder Görsel URL'ini Kullanır.
      category: json['category'] as String? ?? 'Genel', // category null İse 'Genel' Kullanır.
    );
  }
}