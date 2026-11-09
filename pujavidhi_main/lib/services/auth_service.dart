import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DevoteeUser {
  final String uid;
  final String email;
  final String displayName;
  final bool isAnonymous;
  final bool isPro;
  final DateTime createdAt;

  const DevoteeUser({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.isAnonymous,
    required this.isPro,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'email': email,
    'displayName': displayName,
    'isAnonymous': isAnonymous,
    'isPro': isPro,
    'createdAt': createdAt.toIso8601String(),
  };

  factory DevoteeUser.fromJson(Map<String, dynamic> json) {
    return DevoteeUser(
      uid: json['uid']?.toString() ?? 'guest_devotee',
      email: json['email']?.toString() ?? '',
      displayName: json['displayName']?.toString() ?? 'Devotee',
      isAnonymous: json['isAnonymous'] == true,
      isPro: json['isPro'] == true,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

class AuthService {
  static const String _keyUser = 'pujavidhi_current_user_v2';
  static const String projectId = 'pujavidhi-app-2026';
  static const String baseUrl =
      'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents';

  static DevoteeUser? _currentUser;

  static DevoteeUser get currentUser =>
      _currentUser ??
      DevoteeUser(
        uid: 'guest_${DateTime.now().millisecondsSinceEpoch}',
        email: '',
        displayName: 'Guest Devotee',
        isAnonymous: true,
        isPro: false,
        createdAt: DateTime.now(),
      );

  static Future<DevoteeUser> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_keyUser);
      if (raw != null) {
        _currentUser = DevoteeUser.fromJson(jsonDecode(raw) as Map<String, dynamic>);
        return _currentUser!;
      }
    } catch (_) {}

    // Default to Anonymous Guest Mode
    final guestId = 'guest_${DateTime.now().millisecondsSinceEpoch}';
    final guest = DevoteeUser(
      uid: guestId,
      email: '',
      displayName: 'Guest Devotee',
      isAnonymous: true,
      isPro: false,
      createdAt: DateTime.now(),
    );
    await _saveUser(guest);
    _currentUser = guest;
    return guest;
  }

  static Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final cleanEmail = email.trim().toLowerCase();
      final uid = 'user_${cleanEmail.hashCode.abs()}';

      final user = DevoteeUser(
        uid: uid,
        email: cleanEmail,
        displayName: name.trim(),
        isAnonymous: false,
        isPro: false,
        createdAt: DateTime.now(),
      );

      // Save to local device
      await _saveUser(user);
      _currentUser = user;

      // Sync to Firebase Firestore users collection in background
      _syncUserToFirestore(user);
      return true;
    } catch (e) {
      debugPrint('Registration error: $e');
      return false;
    }
  }

  static Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final cleanEmail = email.trim().toLowerCase();
      final uid = 'user_${cleanEmail.hashCode.abs()}';

      // Check remote Firestore or local fallback
      final remote = await _fetchUserFromFirestore(uid);
      if (remote != null) {
        _currentUser = remote;
        await _saveUser(remote);
        return true;
      }

      // Default mock login
      final user = DevoteeUser(
        uid: uid,
        email: cleanEmail,
        displayName: cleanEmail.split('@').first,
        isAnonymous: false,
        isPro: false,
        createdAt: DateTime.now(),
      );
      _currentUser = user;
      await _saveUser(user);
      _syncUserToFirestore(user);
      return true;
    } catch (e) {
      debugPrint('Sign in error: $e');
      return false;
    }
  }

  static Future<void> signOut() async {
    final guestId = 'guest_${DateTime.now().millisecondsSinceEpoch}';
    final guest = DevoteeUser(
      uid: guestId,
      email: '',
      displayName: 'Guest Devotee',
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

  static Future<void> _syncUserToFirestore(DevoteeUser user) async {
    try {
      final client = HttpClient()..connectionTimeout = const Duration(seconds: 8);
      final req = await client.patchUrl(Uri.parse('$baseUrl/users/${user.uid}'));
      req.headers.contentType = ContentType.json;

      final fields = {
        'uid': {'stringValue': user.uid},
        'email': {'stringValue': user.email},
        'displayName': {'stringValue': user.displayName},
        'isAnonymous': {'booleanValue': user.isAnonymous},
        'isPro': {'booleanValue': user.isPro},
        'updatedAt': {'stringValue': DateTime.now().toUtc().toIso8601String()},
      };

      req.write(jsonEncode({'fields': fields}));
      await req.close();
    } catch (_) {}
  }

  static Future<DevoteeUser?> _fetchUserFromFirestore(String uid) async {
    try {
      final client = HttpClient()..connectionTimeout = const Duration(seconds: 8);
      final req = await client.getUrl(Uri.parse('$baseUrl/users/$uid'));
      final res = await req.close();
      if (res.statusCode == 200) {
        final body = await res.transform(utf8.decoder).join();
        final jsonDoc = jsonDecode(body) as Map<String, dynamic>;
        final fields = jsonDoc['fields'] as Map<String, dynamic>? ?? {};

        return DevoteeUser(
          uid: fields['uid']?['stringValue'] ?? uid,
          email: fields['email']?['stringValue'] ?? '',
          displayName: fields['displayName']?['stringValue'] ?? 'Devotee',
          isAnonymous: fields['isAnonymous']?['booleanValue'] ?? false,
          isPro: fields['isPro']?['booleanValue'] ?? false,
          createdAt: DateTime.now(),
        );
      }
    } catch (_) {}
    return null;
  }
}
