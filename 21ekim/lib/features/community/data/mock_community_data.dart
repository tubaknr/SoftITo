import '../../../core/constants/app_constants.dart';
import '../models/community_user_model.dart';
import 'community_repository.dart';

/// 15+ ülkeden 60 kullanıcı içeren Mock Topluluk Veri Kaynağı.
class MockCommunityRepository implements CommunityRepository {
  @override
  Future<List<CommunityUserModel>> getAllUsers() async {
    return _generateMockUsers();
  }

  static List<CommunityUserModel> _generateMockUsers() {
    final rawData = [
      // 1-10
      ('Mahmut Yılmaz', 57, 'Türkiye', 52 * 86400 + 14 * 3600, 42, FlowerStage.mature, false),
      ('Sophia Miller', 29, 'Amerika Birleşik Devletleri', 51 * 86400 + 2 * 3600, 38, FlowerStage.mature, false),
      ('Claire Dubois', 34, 'Fransa', 50 * 86400 + 56 * 60, 35, FlowerStage.mature, false),
      ('Lukas Weber', 41, 'Almanya', 48 * 86400 + 12 * 3600, 31, FlowerStage.blooming, false),
      ('Oliver Smith', 32, 'İngiltere', 47 * 86400 + 18 * 3600, 29, FlowerStage.blooming, false),
      ('Kenji Sato', 45, 'Japonya', 45 * 86400 + 8 * 3600, 30, FlowerStage.blooming, false),
      ('Liam Tremblay', 38, 'Kanada', 43 * 86400 + 20 * 3600, 27, FlowerStage.blooming, false),
      ('Emma van Dijk', 27, 'Hollanda', 41 * 86400 + 15 * 3600, 25, FlowerStage.blooming, false),
      ('Matteo Rossi', 36, 'İtalya', 40 * 86400 + 10 * 3600, 24, FlowerStage.blooming, false),
      ('Alejandro García', 33, 'İspanya', 39 * 86400 + 6 * 3600, 22, FlowerStage.blooming, false),

      // 11-20
      ('Gabriel Silva', 25, 'Brezilya', 37 * 86400 + 12 * 3600, 20, FlowerStage.blooming, false),
      ('Jack Wilson', 31, 'Avustralya', 36 * 86400 + 8 * 3600, 19, FlowerStage.bud, false),
      ('Min-jun Park', 28, 'Güney Kore', 35 * 86400 + 14 * 3600, 18, FlowerStage.bud, false),
      ('Astrid Lindgren', 44, 'İsveç', 33 * 86400 + 9 * 3600, 17, FlowerStage.bud, false),
      ('Henrik Ibsen', 52, 'Norveç', 32 * 86400 + 11 * 3600, 16, FlowerStage.bud, false),
      ('Zeynep Kaya', 26, 'Türkiye', 31 * 86400 + 4 * 3600, 15, FlowerStage.bud, false),
      ('Ethan Davis', 30, 'Amerika Birleşik Devletleri', 30 * 86400 + 7 * 3600, 14, FlowerStage.bud, false),
      ('Camille Bernard', 33, 'Fransa', 29 * 86400 + 15 * 3600, 14, FlowerStage.leafyStem, false),
      ('Felix Becker', 28, 'Almanya', 28 * 86400 + 19 * 3600, 13, FlowerStage.leafyStem, false),
      ('Charlotte Brown', 35, 'İngiltere', 27 * 86400 + 11 * 3600, 12, FlowerStage.leafyStem, false),

      // 21-30
      ('Yuki Tanaka', 29, 'Japonya', 26 * 86400 + 5 * 3600, 12, FlowerStage.leafyStem, false),
      ('Noah Bouchard', 24, 'Kanada', 25 * 86400 + 16 * 3600, 11, FlowerStage.leafyStem, false),
      ('Daan de Jong', 39, 'Hollanda', 24 * 86400 + 10 * 3600, 11, FlowerStage.leafyStem, false),
      ('Lorenzo Ferrari', 42, 'İtalya', 23 * 86400 + 20 * 3600, 10, FlowerStage.leafyStem, false),
      ('Sofia Martinez', 23, 'İspanya', 22 * 86400 + 8 * 3600, 10, FlowerStage.sapling, false),
      ('Lucas Santos', 27, 'Brezilya', 21 * 86400 + 14 * 3600, 9, FlowerStage.sapling, false),
      ('Mia Taylor', 31, 'Avustralya', 20 * 86400 + 18 * 3600, 9, FlowerStage.sapling, false),
      ('Ji-woo Kim', 26, 'Güney Kore', 19 * 86400 + 12 * 3600, 8, FlowerStage.sapling, false),
      ('Elin Larsson', 37, 'İsveç', 18 * 86400 + 15 * 3600, 8, FlowerStage.sapling, false),
      ('Olav Hansen', 46, 'Norveç', 17 * 86400 + 6 * 3600, 7, FlowerStage.sapling, false),

      // 31-40
      ('Emre Demir', 32, 'Türkiye', 16 * 86400 + 22 * 3600, 7, FlowerStage.sapling, false),
      ('Ava Johnson', 29, 'Amerika Birleşik Devletleri', 16 * 86400 + 5 * 3600, 6, FlowerStage.sapling, false),
      ('Antoine Petit', 38, 'Fransa', 15 * 86400 + 14 * 3600, 6, FlowerStage.sprout, false),
      ('Maximilian Schmidt', 34, 'Almanya', 14 * 86400 + 18 * 3600, 6, FlowerStage.sprout, false),
      ('George Evans', 40, 'İngiltere', 13 * 86400 + 9 * 3600, 5, FlowerStage.sprout, false),
      ('Hina Takahashi', 25, 'Japonya', 13 * 86400 + 2 * 3600, 5, FlowerStage.sprout, false),
      ('Chloe Roy', 27, 'Kanada', 12 * 86400 + 16 * 3600, 5, FlowerStage.sprout, false),
      ('Lars Bakker', 31, 'Hollanda', 11 * 86400 + 20 * 3600, 4, FlowerStage.sprout, false),
      ('Giulia Esposito', 28, 'İtalya', 11 * 86400 + 8 * 3600, 4, FlowerStage.sprout, false),
      ('Mateo Lopez', 35, 'İspanya', 10 * 86400 + 14 * 3600, 4, FlowerStage.sprout, false),

      // 41-50
      ('Beatriz Oliveira', 22, 'Brezilya', 9 * 86400 + 17 * 3600, 3, FlowerStage.sprout, false),
      ('Thomas Anderson', 43, 'Avustralya', 9 * 86400 + 4 * 3600, 3, FlowerStage.sprout, false),
      ('Seo-jun Lee', 30, 'Güney Kore', 8 * 86400 + 21 * 3600, 3, FlowerStage.sprout, false),
      ('Maja Andersson', 26, 'İsveç', 8 * 86400 + 10 * 3600, 3, FlowerStage.sprout, false),
      ('Magnus Olsen', 39, 'Norveç', 7 * 86400 + 15 * 3600, 2, FlowerStage.sprout, false),
      ('Elif Çelik', 24, 'Türkiye', 7 * 86400 + 2 * 3600, 2, FlowerStage.sprout, false),
      ('Mason Harris', 36, 'Amerika Birleşik Devletleri', 6 * 86400 + 19 * 3600, 2, FlowerStage.seed, false),
      ('Juliette Roux', 31, 'Fransa', 6 * 86400 + 8 * 3600, 2, FlowerStage.seed, false),
      ('Leon Meyer', 29, 'Almanya', 5 * 86400 + 22 * 3600, 1, FlowerStage.seed, false),
      ('Amelia Walker', 27, 'İngiltere', 5 * 86400 + 11 * 3600, 1, FlowerStage.seed, false),

      // 51-60 (Bazıları gizli profil testleri için)
      ('Ren Watanabe', 33, 'Japonya', 4 * 86400 + 14 * 3600, 1, FlowerStage.seed, false),
      ('Benjamin Gagnon', 37, 'Kanada', 4 * 86400 + 5 * 3600, 1, FlowerStage.seed, false),
      ('Sem Jansen', 25, 'Hollanda', 3 * 86400 + 16 * 3600, 1, FlowerStage.seed, false),
      ('Federico Bianchi', 41, 'İtalya', 3 * 86400 + 7 * 3600, 1, FlowerStage.seed, false),
      ('Lucia Sanchez', 28, 'İspanya', 2 * 86400 + 20 * 3600, 1, FlowerStage.seed, false),
      // Gizli Kullanıcılar (Toplulukta görünmeyecekler)
      ('Gizli Doğa Sever', 30, 'Türkiye', 60 * 86400, 50, FlowerStage.mature, true),
      ('Secret Meditator', 45, 'Amerika Birleşik Devletleri', 58 * 86400, 48, FlowerStage.mature, true),
      ('Silent Monk', 35, 'Japonya', 55 * 86400, 45, FlowerStage.mature, true),
      ('Unknown Wanderer', 28, 'Almanya', 40 * 86400, 30, FlowerStage.blooming, true),
      ('Incognito Sprout', 22, 'Fransa', 20 * 86400, 15, FlowerStage.bud, true),
    ];

    return rawData.asMap().entries.map((entry) {
      final idx = entry.key;
      final item = entry.value;

      final totalSec = item.$4;
      final dailySec = (totalSec ~/ 30).clamp(600, 7200);
      final weeklySec = (dailySec * 5).clamp(3000, 36000);
      final yearlySec = totalSec;

      return CommunityUserModel(
        id: 'community_user_$idx',
        name: item.$1,
        age: item.$2,
        country: item.$3,
        totalFocusSeconds: totalSec,
        streakDays: item.$5,
        flowerStage: item.$6,
        isPrivate: item.$7,
        dailySeconds: dailySec,
        weeklySeconds: weeklySec,
        yearlySeconds: yearlySec,
      );
    }).toList();
  }
}
