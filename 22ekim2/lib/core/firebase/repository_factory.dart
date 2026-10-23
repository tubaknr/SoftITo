import '../services/date_time_service.dart';
import '../services/local_store.dart';
import '../../features/auth/data/auth_repository.dart';
import '../../features/auth/data/firebase_auth_repository.dart';
import '../../features/habits/data/firestore_habits_repository.dart';
import '../../features/habits/data/habits_repository.dart';
import '../../firebase_options.dart';
import 'firebase_service.dart';

/// Senior Factory creating either production Firebase repositories or offline Local repositories
class RepositoryFactory {
  /// Create Authentication repository based on Firebase availability
  static AuthRepository createAuthRepository({
    required LocalStore localStore,
  }) {
    final fb = FirebaseService.instance;
    if (fb.isInitialized && fb.auth != null && fb.firestore != null) {
      return FirebaseAuthRepository(
        auth: fb.auth!,
        firestore: fb.firestore!,
        localStore: localStore,
      );
    }
    return LocalAuthRepository(localStore: localStore);
  }

  /// Create Habits & Analytics data repository scoped to the active user
  static HabitsRepository createHabitsRepository({
    required String? userId,
    required LocalStore localStore,
    required DateTimeService dateTimeService,
  }) {
    final fb = FirebaseService.instance;
    if (fb.isInitialized &&
        fb.firestore != null &&
        userId != null &&
        userId.isNotEmpty &&
        DefaultFirebaseOptions.isConfigured) {
      return FirestoreHabitsRepository(
        userId: userId,
        firestore: fb.firestore!,
        localStore: localStore,
        dateTimeService: dateTimeService,
      );
    }
    return LocalHabitsRepository(
      localStore: localStore,
      dateTimeService: dateTimeService,
    );
  }
}
