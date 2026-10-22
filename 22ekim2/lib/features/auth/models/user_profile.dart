/// Immutable user profile model
class UserProfile {
  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.languageCode = 'tr',
    this.isDarkMode = false,
  });

  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String languageCode;
  final bool isDarkMode;

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    String? languageCode,
    bool? isDarkMode,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      languageCode: languageCode ?? this.languageCode,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'languageCode': languageCode,
      'isDarkMode': isDarkMode,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      languageCode: (json['languageCode'] as String?) ?? 'tr',
      isDarkMode: (json['isDarkMode'] as bool?) ?? false,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfile &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          email == other.email &&
          avatarUrl == other.avatarUrl &&
          languageCode == other.languageCode &&
          isDarkMode == other.isDarkMode;

  @override
  int get hashCode => Object.hash(
        id,
        name,
        email,
        avatarUrl,
        languageCode,
        isDarkMode,
      );
}
