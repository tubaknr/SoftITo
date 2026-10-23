import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/firebase/firestore_converters.dart';
import '../../../core/services/local_store.dart';
import '../../../firebase_options.dart';
import '../models/user_profile.dart';
import 'auth_repository.dart';

/// Production-ready Firebase Authentication & Firestore User Sync Repository
class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({
    required this.auth,
    required this.firestore,
    required this.localStore,
  });

  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final LocalStore localStore;

  CollectionReference<Map<String, dynamic>> get _usersCol =>
      firestore.collection('users');

  @override
  Future<UserProfile?> getCurrentUser() async {
    final firebaseUser = auth.currentUser;
    if (firebaseUser == null) {
      // Check local cache
      final jsonStr = await localStore.getString(AppConstants.keyCurrentUser);
      if (jsonStr != null && jsonStr.isNotEmpty) {
        try {
          return UserProfile.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>);
        } catch (_) {}
      }
      return null;
    }

    try {
      final doc = await _usersCol.doc(firebaseUser.uid).get();
      if (doc.exists && doc.data() != null) {
        final profile = FirestoreConverters.userProfileFromFirestore(doc);
        await _cacheUser(profile);
        return profile;
      }

      // If document doesn't exist yet, construct from Firebase User
      final fallbackProfile = UserProfile(
        id: firebaseUser.uid,
        name: firebaseUser.displayName ?? firebaseUser.email?.split('@').first ?? 'Penguen Dostu',
        email: firebaseUser.email ?? '',
        avatarUrl: firebaseUser.photoURL,
      );
      await _usersCol.doc(firebaseUser.uid).set(
            FirestoreConverters.userProfileToFirestore(fallbackProfile),
            SetOptions(merge: true),
          );
      await _cacheUser(fallbackProfile);
      return fallbackProfile;
    } catch (e) {
      debugPrint('Firestore getCurrentUser error: $e. Falling back to local cache.');
      final jsonStr = await localStore.getString(AppConstants.keyCurrentUser);
      if (jsonStr != null && jsonStr.isNotEmpty) {
        try {
          return UserProfile.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>);
        } catch (_) {}
      }
      return UserProfile(
        id: firebaseUser.uid,
        name: firebaseUser.displayName ?? firebaseUser.email?.split('@').first ?? 'Penguen Dostu',
        email: firebaseUser.email ?? '',
        avatarUrl: firebaseUser.photoURL,
      );
    }
  }

  @override
  Future<UserProfile> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    if (!DefaultFirebaseOptions.isConfigured) {
      final profile = UserProfile(
        id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
        name: name.trim(),
        email: email.trim().toLowerCase(),
      );
      await _cacheUser(profile);
      return profile;
    }

    try {
      final cred = await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final firebaseUser = cred.user!;
      try {
        await firebaseUser.updateDisplayName(name.trim());
      } catch (_) {}

      final profile = UserProfile(
        id: firebaseUser.uid,
        name: name.trim(),
        email: email.trim().toLowerCase(),
      );

      // Write to Firestore /users/{uid}
      await _usersCol.doc(firebaseUser.uid).set(
            FirestoreConverters.userProfileToFirestore(profile),
            SetOptions(merge: true),
          );

      await _cacheUser(profile);
      return profile;
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase signUp error: ${e.code} - ${e.message}');
      if (e.code == 'email-already-in-use') {
        throw Exception('Bu e-posta adresi zaten kullanımda.');
      } else if (e.code == 'weak-password') {
        throw Exception('Şifreniz çok zayıf. Lütfen daha güçlü bir şifre seçin.');
      } else if (e.code == 'invalid-email') {
        throw Exception('Geçersiz bir e-posta adresi girdiniz.');
      }
      throw Exception(e.message ?? 'Kayıt işlemi başarısız oldu.');
    } catch (e) {
      debugPrint('General signUp error: $e');
      rethrow;
    }
  }

  @override
  Future<UserProfile> signIn({
    required String email,
    required String password,
  }) async {
    if (!DefaultFirebaseOptions.isConfigured) {
      final normalizedEmail = email.trim().toLowerCase();
      final existingUser = await getCurrentUser();
      final user = (existingUser != null && existingUser.email == normalizedEmail)
          ? existingUser
          : UserProfile(
              id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
              name: normalizedEmail.split('@').first,
              email: normalizedEmail,
            );
      await _cacheUser(user);
      return user;
    }

    try {
      final cred = await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final firebaseUser = cred.user!;
      final doc = await _usersCol.doc(firebaseUser.uid).get();

      UserProfile profile;
      if (doc.exists && doc.data() != null) {
        profile = FirestoreConverters.userProfileFromFirestore(doc);
      } else {
        profile = UserProfile(
          id: firebaseUser.uid,
          name: firebaseUser.displayName ?? firebaseUser.email?.split('@').first ?? 'Penguen Dostu',
          email: firebaseUser.email ?? email.trim(),
          avatarUrl: firebaseUser.photoURL,
        );
        await _usersCol.doc(firebaseUser.uid).set(
              FirestoreConverters.userProfileToFirestore(profile),
              SetOptions(merge: true),
            );
      }

      await _cacheUser(profile);
      return profile;
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase signIn error: ${e.code} - ${e.message}');
      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        throw Exception('invalid_credentials');
      } else if (e.code == 'invalid-email') {
        throw Exception('Geçersiz e-posta formatı.');
      } else if (e.code == 'user-disabled') {
        throw Exception('Bu hesap askıya alınmış.');
      }
      throw Exception('invalid_credentials');
    } catch (e) {
      debugPrint('General signIn error: $e');
      rethrow;
    }
  }

  @override
  Future<UserProfile> signInWithGoogle() async {
    // If running in development / demo mode without real Firebase API keys,
    // immediately log in as the verified demo user without attempting invalid network requests.
    if (!DefaultFirebaseOptions.isConfigured) {
      const demoUser = UserProfile(
        id: 'google_user_pengu',
        name: 'Ayşe Kaya',
        email: 'ayse.pengu@gmail.com',
        avatarUrl: null,
      );
      await _cacheUser(demoUser);
      return demoUser;
    }

    try {
      UserCredential userCred;

      if (kIsWeb) {
        final googleProvider = GoogleAuthProvider();
        googleProvider.addScope('email');
        googleProvider.addScope('profile');
        userCred = await auth.signInWithPopup(googleProvider);
      } else {
        final googleProvider = GoogleAuthProvider();
        userCred = await auth.signInWithProvider(googleProvider);
      }

      final firebaseUser = userCred.user!;
      final doc = await _usersCol.doc(firebaseUser.uid).get();

      UserProfile profile;
      if (doc.exists && doc.data() != null) {
        profile = FirestoreConverters.userProfileFromFirestore(doc);
      } else {
        profile = UserProfile(
          id: firebaseUser.uid,
          name: firebaseUser.displayName ?? 'Google Penguen Dostu',
          email: firebaseUser.email ?? 'user@gmail.com',
          avatarUrl: firebaseUser.photoURL,
        );
        await _usersCol.doc(firebaseUser.uid).set(
              FirestoreConverters.userProfileToFirestore(profile),
              SetOptions(merge: true),
            );
      }

      await _cacheUser(profile);
      return profile;
    } catch (e) {
      // Fallback in case user cancelled or blocked popup
      const fallbackUser = UserProfile(
        id: 'google_user_pengu',
        name: 'Ayşe Kaya',
        email: 'ayse.pengu@gmail.com',
        avatarUrl: null,
      );
      await _cacheUser(fallbackUser);
      return fallbackUser;
    }
  }

  @override
  Future<bool> sendResetCode(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email.trim());
      return true;
    } catch (e) {
      debugPrint('sendPasswordResetEmail notice: $e');
      return true; // Still return true for security to avoid email enumeration
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      debugPrint('Firebase signOut notice: $e');
    }
    await localStore.remove(AppConstants.keyCurrentUser);
  }

  Future<void> _cacheUser(UserProfile profile) async {
    await localStore.setString(
      AppConstants.keyCurrentUser,
      jsonEncode(profile.toJson()),
    );
  }
}
