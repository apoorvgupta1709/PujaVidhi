import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/admin_models.dart';

class AdminFirebaseService {
  static const String projectId = 'metropulse-transit-2026';
  static const String baseUrl =
      'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents';

  static dynamic _toFirestoreValue(dynamic val) {
    if (val == null) return {'nullValue': null};
    if (val is bool) return {'booleanValue': val};
    if (val is int) return {'integerValue': val.toString()};
    if (val is double) return {'doubleValue': val};
    if (val is String) return {'stringValue': val};
    if (val is List) {
      return {'arrayValue': {'values': val.map((v) => _toFirestoreValue(v)).toList()}};
    }
    if (val is Map) {
      final fields = <String, dynamic>{};
      for (final e in val.entries) {
        fields[e.key.toString()] = _toFirestoreValue(e.value);
      }
      return {'mapValue': {'fields': fields}};
    }
    return {'stringValue': val.toString()};
  }

  static dynamic _unpackFirestoreValue(Map<String, dynamic>? val) {
    if (val == null) return null;
    if (val.containsKey('stringValue')) return val['stringValue'];
    if (val.containsKey('booleanValue')) return val['booleanValue'];
    if (val.containsKey('integerValue')) return int.tryParse(val['integerValue'].toString()) ?? 0;
    if (val.containsKey('doubleValue')) return double.tryParse(val['doubleValue'].toString()) ?? 0.0;
    if (val.containsKey('nullValue')) return null;
    if (val.containsKey('arrayValue')) {
      final values = val['arrayValue']['values'] as List<dynamic>? ?? [];
      return values.map((v) => _unpackFirestoreValue(v as Map<String, dynamic>)).toList();
    }
    if (val.containsKey('mapValue')) {
      final fields = val['mapValue']['fields'] as Map<String, dynamic>? ?? {};
      final map = <String, dynamic>{};
      for (final entry in fields.entries) {
        map[entry.key] = _unpackFirestoreValue(entry.value as Map<String, dynamic>);
      }
      return map;
    }
    return null;
  }

  static Map<String, dynamic> _unpackFirestoreDoc(Map<String, dynamic> doc) {
    final fields = doc['fields'] as Map<String, dynamic>? ?? {};
    final result = <String, dynamic>{};
    for (final entry in fields.entries) {
      result[entry.key] = _unpackFirestoreValue(entry.value as Map<String, dynamic>);
    }
    final docName = doc['name']?.toString() ?? '';
    final docId = docName.split('/').last;
    if (!result.containsKey('id') || (result['id'] as String).isEmpty) {
      result['id'] = docId;
    }
    return result;
  }

  /// Push Document via PATCH
  static Future<bool> setDocument(String collection, String docId, Map<String, dynamic> data) async {
    try {
      final fields = <String, dynamic>{};
      for (final e in data.entries) {
        fields[e.key] = _toFirestoreValue(e.value);
      }
      final payload = jsonEncode({'fields': fields});

      final client = HttpClient()..connectionTimeout = const Duration(seconds: 10);
      final req = await client.patchUrl(Uri.parse('$baseUrl/$collection/$docId'));
      req.headers.contentType = ContentType.json;
      req.write(payload);
      final res = await req.close();
      return res.statusCode == 200;
    } catch (e) {
      debugPrint('AdminFirebaseService.setDocument error for $collection/$docId: $e');
      return false;
    }
  }

  /// Push Monetization Settings to Firestore
  static Future<bool> pushMonetizationConfig(AdminMonetizationConfig config) async {
    final map = config.toJson();
    map['updatedAt'] = DateTime.now().toUtc().toIso8601String();
    return await setDocument('pujavidhi_config', 'monetization', map);
  }

  /// Fetch Monetization Settings from Firestore
  static Future<AdminMonetizationConfig?> fetchMonetizationConfig() async {
    try {
      final client = HttpClient()..connectionTimeout = const Duration(seconds: 8);
      final req = await client.getUrl(Uri.parse('$baseUrl/pujavidhi_config/monetization'));
      final res = await req.close();
      if (res.statusCode == 200) {
        final body = await res.transform(utf8.decoder).join();
        final unpacked = _unpackFirestoreDoc(jsonDecode(body) as Map<String, dynamic>);
        return AdminMonetizationConfig.fromJson(unpacked);
      }
    } catch (e) {
      debugPrint('AdminFirebaseService.fetchMonetizationConfig error: $e');
    }
    return null;
  }

  /// Push Media Item (Aarti / Chalisa) to Firestore
  static Future<bool> pushMediaItem(MediaUploadItem item) async {
    final map = item.toJson();
    map['updatedAt'] = DateTime.now().toUtc().toIso8601String();
    return await setDocument('media_tracks', item.id, map);
  }

  /// Fetch all Aartis from Firestore
  static Future<List<MediaUploadItem>> fetchMediaItems() async {
    try {
      final client = HttpClient()..connectionTimeout = const Duration(seconds: 10);
      final req = await client.getUrl(Uri.parse('$baseUrl/media_tracks?pageSize=100'));
      final res = await req.close();
      if (res.statusCode == 200) {
        final body = await res.transform(utf8.decoder).join();
        final root = jsonDecode(body) as Map<String, dynamic>;
        final docs = root['documents'] as List<dynamic>? ?? [];
        return docs.map((d) {
          final unpacked = _unpackFirestoreDoc(d as Map<String, dynamic>);
          return MediaUploadItem.fromJson(unpacked);
        }).toList();
      }
    } catch (e) {
      debugPrint('AdminFirebaseService.fetchMediaItems error: $e');
    }
    return [];
  }

  /// Push Vidhi to Firestore
  static Future<bool> pushVidhi(FestivalVidhiEntry entry) async {
    final map = entry.toJson();
    map['updatedAt'] = DateTime.now().toUtc().toIso8601String();
    return await setDocument('festivals_and_vidhis', entry.id, map);
  }

  /// Fetch all Vidhis from Firestore
  static Future<List<FestivalVidhiEntry>> fetchVidhis() async {
    try {
      final client = HttpClient()..connectionTimeout = const Duration(seconds: 10);
      final req = await client.getUrl(Uri.parse('$baseUrl/festivals_and_vidhis?pageSize=100'));
      final res = await req.close();
      if (res.statusCode == 200) {
        final body = await res.transform(utf8.decoder).join();
        final root = jsonDecode(body) as Map<String, dynamic>;
        final docs = root['documents'] as List<dynamic>? ?? [];
        return docs.map((d) {
          final unpacked = _unpackFirestoreDoc(d as Map<String, dynamic>);
          return FestivalVidhiEntry.fromJson(unpacked);
        }).toList();
      }
    } catch (e) {
      debugPrint('AdminFirebaseService.fetchVidhis error: $e');
    }
    return [];
  }

  /// Push Daily Notification / Suvichar to Firestore
  static Future<bool> pushBroadcast(NotificationBroadcast broadcast) async {
    final map = broadcast.toJson();
    map['updatedAt'] = DateTime.now().toUtc().toIso8601String();
    return await setDocument('daily_suvichar', broadcast.id, map);
  }
}
