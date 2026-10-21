import 'package:flutter/foundation.dart';
import '../data/community_repository.dart';
import '../data/mock_community_data.dart';
import '../models/community_user_model.dart';

/// Topluluk, sıralama ve filtreleme Controller'ı (Saf Dart & Birim Test Edilebilir).
class CommunityController extends ValueNotifier<List<CommunityUserModel>> {
  final CommunityRepository _repository;

  CommunityController({CommunityRepository? repository})
      : _repository = repository ?? MockCommunityRepository(),
        super([]);

  static final CommunityController instance = CommunityController();

  final ValueNotifier<String?> selectedCountryFilter = ValueNotifier<String?>(null);
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  Future<void> init() async {
    isLoading.value = true;
    final users = await _repository.getAllUsers();
    value = users;
    isLoading.value = false;
  }

  void setCountryFilter(String? country) {
    selectedCountryFilter.value = country;
  }

  // --- Sıralama ve Filtreleme Mantığı (Saf Dart) ---

  /// Ülkeler Sıralaması (İlk 10)
  /// Gizli kullanıcıları (isPrivate == true) hariç tutar, ülke toplam sürelerine göre büyükten küçüğe sıralar.
  static List<CountryRankingModel> computeCountryRankings(
      List<CommunityUserModel> users) {
    final publicUsers = users.where((u) => !u.isPrivate).toList();
    final countryTotals = <String, int>{};
    final countryCounts = <String, int>{};

    for (final user in publicUsers) {
      countryTotals[user.country] =
          (countryTotals[user.country] ?? 0) + user.totalFocusSeconds;
      countryCounts[user.country] = (countryCounts[user.country] ?? 0) + 1;
    }

    final sortedEntries = countryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final top10 = sortedEntries.take(10).toList();
    final result = <CountryRankingModel>[];

    for (int i = 0; i < top10.length; i++) {
      final entry = top10[i];
      result.add(
        CountryRankingModel(
          rank: i + 1,
          country: entry.key,
          totalFocusSeconds: entry.value,
          userCount: countryCounts[entry.key] ?? 0,
        ),
      );
    }

    return result;
  }

  /// Dünyada İlk 50 (Global Liderlik Panosu)
  /// Gizli profilleri eler, opsiyonel ülke filtresi uygular, toplam süreye göre sıralayıp ilk 50'yi döner.
  static List<CommunityUserModel> computeWorldTop50(
    List<CommunityUserModel> users, {
    String? countryFilter,
  }) {
    var filtered = users.where((u) => !u.isPrivate).toList();

    if (countryFilter != null && countryFilter.isNotEmpty) {
      filtered = filtered.where((u) => u.country == countryFilter).toList();
    }

    filtered.sort((a, b) => b.totalFocusSeconds.compareTo(a.totalFocusSeconds));

    return filtered.take(50).toList();
  }

  List<CountryRankingModel> get top10Countries =>
      computeCountryRankings(value);

  List<CommunityUserModel> get filteredTop50 => computeWorldTop50(
        value,
        countryFilter: selectedCountryFilter.value,
      );

  List<String> get availableCountries {
    final publicUsers = value.where((u) => !u.isPrivate).toList();
    final set = publicUsers.map((u) => u.country).toSet();
    final list = set.toList()..sort();
    return list;
  }

  /// Bir kullanıcının dünya sıralamasındaki derecesini hesaplar (1-indexed).
  static int computeUserWorldRank(
    List<CommunityUserModel> allUsers,
    CommunityUserModel targetUser,
  ) {
    final publicUsers = allUsers.where((u) => !u.isPrivate).toList();
    publicUsers.sort((a, b) => b.totalFocusSeconds.compareTo(a.totalFocusSeconds));
    final index = publicUsers.indexWhere((u) => u.id == targetUser.id);
    if (index != -1) return index + 1;
    final higherCount = publicUsers
        .where((u) => u.totalFocusSeconds > targetUser.totalFocusSeconds)
        .length;
    return higherCount + 1;
  }

  /// Bir kullanıcının kendi ülkesindeki sıralamasını hesaplar (1-indexed).
  static int computeUserCountryRank(
    List<CommunityUserModel> allUsers,
    CommunityUserModel targetUser,
  ) {
    final countryUsers = allUsers
        .where((u) => !u.isPrivate && u.country == targetUser.country)
        .toList();
    countryUsers.sort((a, b) => b.totalFocusSeconds.compareTo(a.totalFocusSeconds));
    final index = countryUsers.indexWhere((u) => u.id == targetUser.id);
    if (index != -1) return index + 1;
    final higherCount = countryUsers
        .where((u) => u.totalFocusSeconds > targetUser.totalFocusSeconds)
        .length;
    return higherCount + 1;
  }

  int getUserWorldRank(CommunityUserModel user) =>
      computeUserWorldRank(value, user);

  int getUserCountryRank(CommunityUserModel user) =>
      computeUserCountryRank(value, user);
}
