import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class DevoteeUser {
  final String uid;
  final String email;
  final String displayName;
  final String? photoUrl;
  final String provider; // 'google', 'password', 'guest'
  final bool isAnonymous;
  final bool isPro;
  final DateTime createdAt;

  const DevoteeUser({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoUrl,
    this.provider = 'guest',
    required this.isAnonymous,
    required this.isPro,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'email': email,
    'displayName': displayName,
    'photoUrl': photoUrl,
    'provider': provider,
    'isAnonymous': isAnonymous,
    'isPro': isPro,
    'createdAt': createdAt.toIso8601String(),
  };

  factory DevoteeUser.fromJson(Map<String, dynamic> json) {
    return DevoteeUser(
      uid: json['uid']?.toString() ?? 'guest_devotee',
      email: json['email']?.toString() ?? '',
      displayName: json['displayName']?.toString() ?? 'Devotee',
      photoUrl: json['photoUrl']?.toString(),
      provider: json['provider']?.toString() ?? 'guest',
      isAnonymous: json['isAnonymous'] == true,
      isPro: json['isPro'] == true,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  factory DevoteeUser.fromFirebase(User user, {bool isPro = false, String? customName, String? provider}) {
    final name = (customName != null && customName.isNotEmpty)
        ? customName
        : (user.displayName != null && user.displayName!.isNotEmpty)
            ? user.displayName!
            : (user.email != null && user.email!.contains('@'))
                ? user.email!.split('@').first
                : 'Devotee';

    return DevoteeUser(
      uid: user.uid,
      email: user.email ?? '',
      displayName: name,
      photoUrl: user.photoURL,
      provider: provider ?? (user.providerData.isNotEmpty ? user.providerData.first.providerId : 'password'),
      isAnonymous: user.isAnonymous,
      isPro: isPro,
      createdAt: user.metadata.creationTime ?? DateTime.now(),
    );
  }
}

class AuthService {
  static const String _keyUser = 'pujavidhi_current_user_v3';
  static const String projectId = 'pujavidhi-app-2026';
  static const String apiKey = 'AIzaSyCxThu44KNbSyTSlGmHefYraN36U63lVAk';
  static const String firestoreBaseUrl =
      'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents';

  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: '316916193859-grntv8loerin7ur3nl2nnorempcalffv.apps.googleusercontent.com',
    scopes: ['email', 'profile'],
  );

  static DevoteeUser? _currentUser;

  static DevoteeUser get currentUser =>
      _currentUser ??
      DevoteeUser(
        uid: 'guest_${DateTime.now().millisecondsSinceEpoch}',
        email: '',
        displayName: 'Guest Devotee',
        provider: 'guest',
        isAnonymous: true,
        isPro: false,
        createdAt: DateTime.now(),
      );

  static Future<DevoteeUser> init() async {
    // 1. Check if Firebase Auth already has an active signed-in user
    try {
      final fbUser = _auth.currentUser;
      if (fbUser != null && !fbUser.isAnonymous) {
        _currentUser = DevoteeUser.fromFirebase(fbUser);
        await _saveUser(_currentUser!);
        // Sync to firestore in background
        _syncUserToFirestore(_currentUser!);
        return _currentUser!;
      }
    } catch (_) {}

    // 2. Fallback to cached local preferences
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_keyUser);
      if (raw != null) {
        _currentUser = DevoteeUser.fromJson(jsonDecode(raw) as Map<String, dynamic>);
        return _currentUser!;
      }
    } catch (_) {}

    // 3. Default to Anonymous Guest Mode
    final guestId = 'guest_${DateTime.now().millisecondsSinceEpoch}';
    final guest = DevoteeUser(
      uid: guestId,
      email: '',
      displayName: 'Guest Devotee',
      provider: 'guest',
      isAnonymous: true,
      isPro: false,
      createdAt: DateTime.now(),
    );
    await _saveUser(guest);
    _currentUser = guest;
    return guest;
  }

  /// Register new devotee with Email & Password in Firebase Authentication
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final cleanEmail = email.trim().toLowerCase();
    final cleanName = name.trim();

    try {
      // 1. Create User in Firebase Auth
      final credential = await _auth.createUserWithEmailAndPassword(
        email: cleanEmail,
        password: password,
      );

      final user = credential.user;
      if (user != null) {
        // Set display name in Firebase Auth
        await user.updateDisplayName(cleanName);

        final devotee = DevoteeUser.fromFirebase(
          user,
          customName: cleanName,
          provider: 'password',
        );

        _currentUser = devotee;
        await _saveUser(devotee);

        // Store user document in Firestore /users/{uid}
        await _syncUserToFirestore(devotee);
        return {'success': true};
      }
      return {'success': false, 'error': 'User registration could not be completed.'};
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Auth Register Error: ${e.code} - ${e.message}');
      String msg = 'Registration failed.';
      if (e.code == 'email-already-in-use') {
        msg = 'This email is already registered. Please sign in instead.';
      } else if (e.code == 'weak-password') {
        msg = 'Password should be at least 6 characters.';
      } else if (e.code == 'invalid-email') {
        msg = 'Please enter a valid email address.';
      }
      return {'success': false, 'error': msg};
    } catch (e) {
      debugPrint('Registration error: $e');
      return {'success': false, 'error': 'Registration failed: ${e.toString()}'};
    }
  }

  /// Sign In with Email & Password via Firebase Authentication
  static Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    final cleanEmail = email.trim().toLowerCase();

    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: cleanEmail,
        password: password,
      );

      final user = credential.user;
      if (user != null) {
        final devotee = DevoteeUser.fromFirebase(user, provider: 'password');
        _currentUser = devotee;
        await _saveUser(devotee);

        // Sync and refresh profile from Firestore
        _syncUserToFirestore(devotee);
        return {'success': true};
      }
      return {'success': false, 'error': 'Sign in failed.'};
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Auth SignIn Error: ${e.code} - ${e.message}');
      String msg = 'Sign in failed.';
      if (e.code == 'user-not-found' || e.code == 'wrong-password' || e.code == 'invalid-credential') {
        msg = 'Invalid email or password. Please verify your details.';
      } else if (e.code == 'user-disabled') {
        msg = 'This user account has been disabled.';
      } else if (e.code == 'invalid-email') {
        msg = 'Please enter a valid email address.';
      }
      return {'success': false, 'error': msg};
    } catch (e) {
      debugPrint('Sign in error: $e');
      return {'success': false, 'error': 'Sign in failed: ${e.toString()}'};
    }
  }

  /// One-Tap Google Sign-In with Firebase Authentication
  static Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      // Trigger Google Account Picker
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // Devotee cancelled the sign-in prompt
        return {'success': false, 'error': 'Google Sign-In was cancelled.'};
      }

      // Obtain OAuth tokens
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase Authentication
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        final devotee = DevoteeUser.fromFirebase(
          user,
          customName: googleUser.displayName,
          provider: 'google.com',
        );

        _currentUser = devotee;
        await _saveUser(devotee);

        // Store devotee in Firestore /users/{uid}
        await _syncUserToFirestore(devotee);
        return {'success': true};
      }
      return {'success': false, 'error': 'Google authentication failed.'};
    } on FirebaseAuthException catch (e) {
      debugPrint('Google Firebase Auth Error: ${e.code} - ${e.message}');
      return {'success': false, 'error': e.message ?? 'Google Sign-In failed.'};
    } catch (e) {
      debugPrint('Google sign in general error: $e');
      return {'success': false, 'error': 'Google Sign-In error: ${e.toString()}'};
    }
  }

  /// Send Password Reset Email via Firebase Auth
  static Future<bool> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim().toLowerCase());
      return true;
    } catch (e) {
      debugPrint('Password reset error: $e');
      return false;
    }
  }

  /// Sign out from Firebase and Google
  static Future<void> signOut() async {
    try {
      await _auth.signOut();
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }
    } catch (_) {}

    final guestId = 'guest_${DateTime.now().millisecondsSinceEpoch}';
    final guest = DevoteeUser(
      uid: guestId,
      email: '',
      displayName: 'Guest Devotee',
      provider: 'guest',
      isAnonymous: true,
      isPro: false,
      createdAt: DateTime.now(),
    );
    _currentUser = guest;
    await _saveUser(guest);
  }

  static Future<void> markPro(bool isPro) async {
    if (_currentUser == null) return;
    final updated = DevoteeUser(
      uid: _currentUser!.uid,
      email: _currentUser!.email,
      displayName: _currentUser!.displayName,
      photoUrl: _currentUser!.photoUrl,
      provider: _currentUser!.provider,
      isAnonymous: _currentUser!.isAnonymous,
      isPro: isPro,
      createdAt: _currentUser!.createdAt,
    );
    _currentUser = updated;
    await _saveUser(updated);
    _syncUserToFirestore(updated);
  }

  static Future<void> _saveUser(DevoteeUser user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyUser, jsonEncode(user.toJson()));
    } catch (_) {}
  }

  /// Sync user profile to Firestore `users/{uid}` collection
  static Future<void> _syncUserToFirestore(DevoteeUser user) async {
    try {
      final client = HttpClient()..connectionTimeout = const Duration(seconds: 10);
      final req = await client.patchUrl(Uri.parse('$firestoreBaseUrl/users/${user.uid}'));
      req.headers.contentType = ContentType.json;

      final fields = {
        'uid': {'stringValue': user.uid},
        'email': {'stringValue': user.email},
        'displayName': {'stringValue': user.displayName},
        'provider': {'stringValue': user.provider},
        'isAnonymous': {'booleanValue': user.isAnonymous},
        'isPro': {'booleanValue': user.isPro},
        'updatedAt': {'stringValue': DateTime.now().toUtc().toIso8601String()},
      };

      if (user.photoUrl != null && user.photoUrl!.isNotEmpty) {
        fields['photoUrl'] = {'stringValue': user.photoUrl!};
      }

      req.write(jsonEncode({'fields': fields}));
      await req.close();
    } catch (e) {
      debugPrint('Firestore user sync notice: $e');
    }
  }
}
