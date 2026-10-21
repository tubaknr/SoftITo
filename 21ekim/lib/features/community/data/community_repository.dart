import '../models/community_user_model.dart';

/// Topluluk veri erişimi için soyut Repository arayüzü.
abstract class CommunityRepository {
  Future<List<CommunityUserModel>> getAllUsers();
}
