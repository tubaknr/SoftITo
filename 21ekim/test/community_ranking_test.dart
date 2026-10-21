import 'package:flutter_test/flutter_test.dart';
import 'package:focus_and_grow/core/constants/app_constants.dart';
import 'package:focus_and_grow/features/community/controller/community_controller.dart';
import 'package:focus_and_grow/features/community/models/community_user_model.dart';

void main() {
  group('Topluluk Sıralama ve Gizlilik Testleri', () {
    final sampleUsers = [
      const CommunityUserModel(
        id: '1',
        name: 'Mahmut Yılmaz',
        age: 57,
        country: 'Türkiye',
        totalFocusSeconds: 5000,
        streakDays: 10,
        flowerStage: FlowerStage.mature,
        isPrivate: false,
        dailySeconds: 500,
        weeklySeconds: 2500,
        yearlySeconds: 5000,
      ),
      const CommunityUserModel(
        id: '2',
        name: 'Gizli Kullanıcı',
        age: 30,
        country: 'Türkiye',
        totalFocusSeconds: 999999, // Çok yüksek süre ama gizli
        streakDays: 50,
        flowerStage: FlowerStage.mature,
        isPrivate: true,
        dailySeconds: 1000,
        weeklySeconds: 5000,
        yearlySeconds: 999999,
      ),
      const CommunityUserModel(
        id: '3',
        name: 'John Doe',
        age: 28,
        country: 'Amerika Birleşik Devletleri',
        totalFocusSeconds: 4000,
        streakDays: 8,
        flowerStage: FlowerStage.blooming,
        isPrivate: false,
        dailySeconds: 400,
        weeklySeconds: 2000,
        yearlySeconds: 4000,
      ),
      const CommunityUserModel(
        id: '4',
        name: 'Claire Dubois',
        age: 32,
        country: 'Fransa',
        totalFocusSeconds: 3000,
        streakDays: 6,
        flowerStage: FlowerStage.bud,
        isPrivate: false,
        dailySeconds: 300,
        weeklySeconds: 1500,
        yearlySeconds: 3000,
      ),
    ];

    test('Gizli kullanıcılar ülke sıralamasına dahil edilmemelidir', () {
      final rankings = CommunityController.computeCountryRankings(sampleUsers);

      expect(rankings.length, equals(3));
      // Türkiye toplamı gizli kullanıcı (999999) hariç sadece 5000 olmalıdır
      final tr = rankings.firstWhere((r) => r.country == 'Türkiye');
      expect(tr.totalFocusSeconds, equals(5000));
      expect(tr.userCount, equals(1));
    });

    test('Gizli kullanıcılar Dünyada İlk 50 listesinden elenmelidir', () {
      final top50 = CommunityController.computeWorldTop50(sampleUsers);

      expect(top50.any((u) => u.name == 'Gizli Kullanıcı'), isFalse);
      expect(top50.first.name, equals('Mahmut Yılmaz'));
    });

    test('Ülke filtresi doğru çalışmalıdır', () {
      final filtered = CommunityController.computeWorldTop50(
        sampleUsers,
        countryFilter: 'Fransa',
      );

      expect(filtered.length, equals(1));
      expect(filtered.first.name, equals('Claire Dubois'));
    });

    test('Kullanıcının dünya ve ülke sıralaması doğru hesaplanmalıdır', () {
      final mahmut = sampleUsers[0]; // Mahmut Yılmaz (5000 sn)
      final john = sampleUsers[2]; // John Doe (4000 sn, ABD)
      final claire = sampleUsers[3]; // Claire Dubois (3000 sn, Fransa)

      // Dünya sıralaması (Gizli kullanıcı hariç): 1: Mahmut, 2: John, 3: Claire
      expect(CommunityController.computeUserWorldRank(sampleUsers, mahmut), equals(1));
      expect(CommunityController.computeUserWorldRank(sampleUsers, john), equals(2));
      expect(CommunityController.computeUserWorldRank(sampleUsers, claire), equals(3));

      // Ülke sıralaması
      expect(CommunityController.computeUserCountryRank(sampleUsers, mahmut), equals(1));
      expect(CommunityController.computeUserCountryRank(sampleUsers, john), equals(1));
    });
  });
}
