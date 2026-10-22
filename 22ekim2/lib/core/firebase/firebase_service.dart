import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import '../../firebase_options.dart';

/// Central Firebase Coordinator managing initialization and service instances
class FirebaseService {
  FirebaseService._();
  static final FirebaseService instance = FirebaseService._();

  bool _isInitialized = false;
  String? _initError;

  /// Whether Firebase was successfully initialized on this platform
  bool get isInitialized => _isInitialized;

  /// Error message if initialization failed
  String? get initError => _initError;

  /// Get current FirebaseAuth instance if available
  FirebaseAuth? get auth => _isInitialized ? FirebaseAuth.instance : null;

  /// Get current FirebaseFirestore instance if available
  FirebaseFirestore? get firestore => _isInitialized ? FirebaseFirestore.instance : null;

  /// Initialize Firebase with options for the current platform
  Future<bool> init() async {
    if (_isInitialized) return true;

    try {
      if (kIsWeb ||
          defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS ||
          defaultTargetPlatform == TargetPlatform.windows) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );

        // Configure Firestore offline persistence & settings
        try {
          FirebaseFirestore.instance.settings = const Settings(
            persistenceEnabled: true,
            cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
          );
        } catch (settingsError) {
          debugPrint('Firestore settings note: $settingsError');
        }

        _isInitialized = true;
        _initError = null;
        debugPrint('🔥 Firebase successfully initialized for platform: $defaultTargetPlatform (web: $kIsWeb)');
        return true;
      } else {
        _isInitialized = false;
        _initError = 'Unsupported platform for direct Firebase';
        debugPrint('ℹ️ Firebase direct options omitted on $defaultTargetPlatform. Running with Local Store.');
        return false;
      }
    } catch (e, stack) {
      _isInitialized = false;
      _initError = e.toString();
      debugPrint('⚠️ Firebase initialization deferred/offline fallback: $e');
      debugPrint(stack.toString());
      return false;
    }
  }
}
