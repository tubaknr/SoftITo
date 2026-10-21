/// Focus & Grow Kullanıcı Veri Modeli (Immutable).
class UserModel {
  final String id;
  final String name;
  final String email;
  final int age;
  final String country;
  final bool isPrivate; // "Hesabını toplulukta gösterme" seçeneği
  final String? photoUrl;
  final DateTime registeredAt;
  final DateTime lastActiveAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
    required this.country,
    this.isPrivate = false,
    this.photoUrl,
    required this.registeredAt,
    required this.lastActiveAt,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    int? age,
    String? country,
    bool? isPrivate,
    String? photoUrl,
    DateTime? registeredAt,
    DateTime? lastActiveAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      age: age ?? this.age,
      country: country ?? this.country,
      isPrivate: isPrivate ?? this.isPrivate,
      photoUrl: photoUrl ?? this.photoUrl,
      registeredAt: registeredAt ?? this.registeredAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'age': age,
      'country': country,
      'isPrivate': isPrivate,
      'photoUrl': photoUrl,
      'registeredAt': registeredAt.toIso8601String(),
      'lastActiveAt': lastActiveAt.toIso8601String(),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? 'user_1',
      name: json['name'] as String? ?? 'Doğa Dostu',
      email: json['email'] as String? ?? 'doga@focusgrow.app',
      age: json['age'] as int? ?? 25,
      country: json['country'] as String? ?? 'Türkiye',
      isPrivate: json['isPrivate'] as bool? ?? false,
      photoUrl: json['photoUrl'] as String?,
      registeredAt: json['registeredAt'] != null
          ? DateTime.parse(json['registeredAt'] as String)
          : DateTime.now(),
      lastActiveAt: json['lastActiveAt'] != null
          ? DateTime.parse(json['lastActiveAt'] as String)
          : DateTime.now(),
    );
  }
}
