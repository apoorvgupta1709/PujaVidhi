import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/audio_track_model.dart';
import '../models/vidhi_model.dart';
import '../models/vrat_model.dart';
import '../models/gita_model.dart';
import '../models/wallpaper_model.dart';

class FirebaseSyncService {
  static const String projectId = 'pujavidhi-app-2026';
  static const String baseUrl =
      'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents';

  static const String cacheKeyAartis = 'pujavidhi_cached_aartis_v2';
  static const String cacheKeyVidhis = 'pujavidhi_cached_vidhis_v2';
  static const String cacheKeyVrats = 'pujavidhi_cached_vrats_v2';
  static const String cacheKeyGita = 'pujavidhi_cached_gita_v2';
  static const String cacheKeyWallpapers = 'pujavidhi_cached_wallpapers_v2';
  static const String cacheKeyConfig = 'pujavidhi_cached_config_v2';

  // Stream controllers to notify providers when remote updates land
  static final StreamController<List<AudioTrack>> _aartisController =
      StreamController<List<AudioTrack>>.broadcast();
  static final StreamController<List<PujaVidhi>> _vidhisController =
      StreamController<List<PujaVidhi>>.broadcast();
  static final StreamController<List<VratItem>> _vratsController =
      StreamController<List<VratItem>>.broadcast();
  static final StreamController<List<GitaChapter>> _gitaChaptersController =
      StreamController<List<GitaChapter>>.broadcast();
  static final StreamController<List<GitaShloka>> _gitaShlokasController =
      StreamController<List<GitaShloka>>.broadcast();
  static final StreamController<List<DevotionalWallpaper>> _wallpapersController =
      StreamController<List<DevotionalWallpaper>>.broadcast();
  static final StreamController<Map<String, dynamic>> _configController =
      StreamController<Map<String, dynamic>>.broadcast();

  static Stream<List<AudioTrack>> get aartisStream => _aartisController.stream;
  static Stream<List<PujaVidhi>> get vidhisStream => _vidhisController.stream;
  static Stream<List<VratItem>> get vratsStream => _vratsController.stream;
  static Stream<List<GitaChapter>> get gitaChaptersStream => _gitaChaptersController.stream;
  static Stream<List<GitaShloka>> get gitaShlokasStream => _gitaShlokasController.stream;
  static Stream<List<DevotionalWallpaper>> get wallpapersStream => _wallpapersController.stream;
  static Stream<Map<String, dynamic>> get configStream => _configController.stream;

  // Cache of latest values
  static List<AudioTrack> latestAartis = [];
  static List<PujaVidhi> latestVidhis = [];
  static List<VratItem> latestVrats = [];
  static List<GitaChapter> latestGitaChapters = [];
  static List<GitaShloka> latestGitaShlokas = [];
  static List<DevotionalWallpaper> latestWallpapers = [];
  static Map<String, dynamic> latestConfig = {
    'admob_enabled': true,
    'banner_enabled': true,
    'interstitial_enabled': true,
    'rewarded_enabled': true,
    'interstitial_frequency_rounds': 1,
    'bhakt_prime_price': 99,
  };

  /// Unpack Firestore typed REST JSON into clean standard Dart primitives
  static dynamic unpackFirestoreValue(Map<String, dynamic>? val) {
    if (val == null) return null;
    if (val.containsKey('stringValue')) return val['stringValue'];
    if (val.containsKey('booleanValue')) return val['booleanValue'];
    if (val.containsKey('integerValue')) return int.tryParse(val['integerValue'].toString()) ?? 0;
    if (val.containsKey('doubleValue')) return double.tryParse(val['doubleValue'].toString()) ?? 0.0;
    if (val.containsKey('nullValue')) return null;
    if (val.containsKey('arrayValue')) {
      final values = val['arrayValue']['values'] as List<dynamic>? ?? [];
      return values.map((v) => unpackFirestoreValue(v as Map<String, dynamic>)).toList();
    }
    if (val.containsKey('mapValue')) {
      final fields = val['mapValue']['fields'] as Map<String, dynamic>? ?? {};
      final map = <String, dynamic>{};
      for (final entry in fields.entries) {
        map[entry.key] = unpackFirestoreValue(entry.value as Map<String, dynamic>);
      }
      return map;
    }
    return null;
  }

  static Map<String, dynamic> unpackFirestoreDoc(Map<String, dynamic> doc) {
    final fields = doc['fields'] as Map<String, dynamic>? ?? {};
    final result = <String, dynamic>{};
    for (final entry in fields.entries) {
      result[entry.key] = unpackFirestoreValue(entry.value as Map<String, dynamic>);
    }
    // Extract document ID from doc name if not already in fields
    final docName = doc['name']?.toString() ?? '';
    final docId = docName.split('/').last;
    if (!result.containsKey('id') || (result['id'] as String).isEmpty) {
      result['id'] = docId;
    }
    return result;
  }

  /// Master Background Sync: Fetches latest from Firestore, updates cache & notifies providers
  static Future<void> syncAll() async {
    try {
      await Future.wait([
        syncConfig(),
        syncAartis(),
        syncVidhis(),
        syncVrats(),
        syncGita(),
        syncWallpapers(),
      ]);
    } catch (e) {
      debugPrint('FirebaseSyncService syncAll error: $e');
    }
  }

  /// 1. Sync Monetization & AdMob Config
  static Future<Map<String, dynamic>> syncConfig() async {
    // First attempt remote fetch
    try {
      final client = HttpClient()..connectionTimeout = const Duration(seconds: 8);
      final req = await client.getUrl(Uri.parse('$baseUrl/pujavidhi_config/monetization'));
      final res = await req.close();
      if (res.statusCode == 200) {
        final body = await res.transform(utf8.decoder).join();
        final jsonDoc = jsonDecode(body) as Map<String, dynamic>;
        final unpacked = unpackFirestoreDoc(jsonDoc);
        latestConfig = unpacked;
        _saveToCache(cacheKeyConfig, jsonEncode(unpacked));
        if (!_configController.isClosed) _configController.add(unpacked);
        debugPrint('FirebaseSyncService: Synced monetization config from Firestore.');
        return unpacked;
      }
    } catch (e) {
      debugPrint('FirebaseSyncService: Remote config fetch fallback: $e');
    }

    // Fallback to local cache
    final cached = await _loadFromCache(cacheKeyConfig);
    if (cached != null) {
      try {
        final data = jsonDecode(cached) as Map<String, dynamic>;
        latestConfig = data;
        return data;
      } catch (_) {}
    }

    // Ultimate fallback: bundled JSON
    try {
      final bundledStr = await rootBundle.loadString('assets/data/monetization_config.json');
      final bundledData = jsonDecode(bundledStr) as Map<String, dynamic>;
      latestConfig = bundledData;
      return bundledData;
    } catch (_) {
      return latestConfig;
    }
  }

  /// 2. Sync All Aartis (media_tracks collection)
  static Future<List<AudioTrack>> syncAartis() async {
    // Attempt remote fetch from Firestore
    try {
      final client = HttpClient()..connectionTimeout = const Duration(seconds: 10);
      final req = await client.getUrl(Uri.parse('$baseUrl/media_tracks?pageSize=100'));
      final res = await req.close();
      if (res.statusCode == 200) {
        final body = await res.transform(utf8.decoder).join();
        final root = jsonDecode(body) as Map<String, dynamic>;
        final docs = root['documents'] as List<dynamic>? ?? [];

        final tracks = <AudioTrack>[];
        for (final d in docs) {
          final unpacked = unpackFirestoreDoc(d as Map<String, dynamic>);
          tracks.add(AudioTrack.fromJson(unpacked));
        }

        if (tracks.isNotEmpty) {
          latestAartis = tracks;
          final jsonList = tracks.map((t) => t.toJson()).toList();
          _saveToCache(cacheKeyAartis, jsonEncode(jsonList));
          if (!_aartisController.isClosed) _aartisController.add(tracks);
          debugPrint('FirebaseSyncService: Synced ${tracks.length} Aartis from Firestore.');
          return tracks;
        }
      }
    } catch (e) {
      debugPrint('FirebaseSyncService: Aartis remote fetch fallback: $e');
    }

    // Fallback to local cache
    final cached = await _loadFromCache(cacheKeyAartis);
    if (cached != null) {
      try {
        final list = jsonDecode(cached) as List<dynamic>;
        final tracks = list.map((i) => AudioTrack.fromJson(i as Map<String, dynamic>)).toList();
        if (tracks.isNotEmpty) {
          latestAartis = tracks;
          return tracks;
        }
      } catch (_) {}
    }

    // Ultimate fallback: bundled production asset
    try {
      final bundledStr = await rootBundle.loadString('assets/data/aartis_production.json');
      final list = jsonDecode(bundledStr) as List<dynamic>;
      final tracks = list.map((i) => AudioTrack.fromJson(i as Map<String, dynamic>)).toList();
      latestAartis = tracks;
      return tracks;
    } catch (e) {
      debugPrint('FirebaseSyncService: Failed to load bundled aartis: $e');
      return latestAartis;
    }
  }

  /// 3. Sync All Puja Vidhis (festivals_and_vidhis collection)
  static Future<List<PujaVidhi>> syncVidhis() async {
    // Attempt remote fetch from Firestore
    try {
      final client = HttpClient()..connectionTimeout = const Duration(seconds: 10);
      final req = await client.getUrl(Uri.parse('$baseUrl/festivals_and_vidhis?pageSize=100'));
      final res = await req.close();
      if (res.statusCode == 200) {
        final body = await res.transform(utf8.decoder).join();
        final root = jsonDecode(body) as Map<String, dynamic>;
        final docs = root['documents'] as List<dynamic>? ?? [];

        final vidhis = <PujaVidhi>[];
        for (final d in docs) {
          final unpacked = unpackFirestoreDoc(d as Map<String, dynamic>);
          vidhis.add(PujaVidhi.fromJson(unpacked));
        }

        if (vidhis.isNotEmpty) {
          latestVidhis = vidhis;
          final jsonList = vidhis.map((v) => v.toJson()).toList();
          _saveToCache(cacheKeyVidhis, jsonEncode(jsonList));
          if (!_vidhisController.isClosed) _vidhisController.add(vidhis);
          debugPrint('FirebaseSyncService: Synced ${vidhis.length} Vidhis from Firestore.');
          return vidhis;
        }
      }
    } catch (e) {
      debugPrint('FirebaseSyncService: Vidhis remote fetch fallback: $e');
    }

    // Fallback to local cache
    final cached = await _loadFromCache(cacheKeyVidhis);
    if (cached != null) {
      try {
        final list = jsonDecode(cached) as List<dynamic>;
        final vidhis = list.map((i) => PujaVidhi.fromJson(i as Map<String, dynamic>)).toList();
        if (vidhis.isNotEmpty) {
          latestVidhis = vidhis;
          return vidhis;
        }
      } catch (_) {}
    }

    // Ultimate fallback: bundled production asset
    try {
      final bundledStr = await rootBundle.loadString('assets/data/vidhis_production.json');
      final list = jsonDecode(bundledStr) as List<dynamic>;
      final vidhis = list.map((i) => PujaVidhi.fromJson(i as Map<String, dynamic>)).toList();
      latestVidhis = vidhis;
      return vidhis;
    } catch (e) {
      debugPrint('FirebaseSyncService: Failed to load bundled vidhis: $e');
      return latestVidhis;
    }
  }

  /// 4. Sync Vrat & Upvas Calendar (vrat_calendar collection)
  static Future<List<VratItem>> syncVrats() async {
    try {
      final client = HttpClient()..connectionTimeout = const Duration(seconds: 10);
      final req = await client.getUrl(Uri.parse('$baseUrl/vrat_calendar?pageSize=100'));
      final res = await req.close();
      if (res.statusCode == 200) {
        final body = await res.transform(utf8.decoder).join();
        final jsonDoc = jsonDecode(body) as Map<String, dynamic>;
        final docs = jsonDoc['documents'] as List<dynamic>? ?? [];
        final vrats = <VratItem>[];
        for (final d in docs) {
          final unpacked = unpackFirestoreDoc(d as Map<String, dynamic>);
          vrats.add(VratItem.fromJson(unpacked));
        }
        if (vrats.isNotEmpty) {
          latestVrats = vrats;
          _saveToCache(cacheKeyVrats, jsonEncode(vrats.map((v) => v.toJson()).toList()));
          if (!_vratsController.isClosed) _vratsController.add(vrats);
          debugPrint('FirebaseSyncService: Synced ${vrats.length} vrats from Firestore.');
          return vrats;
        }
      }
    } catch (e) {
      debugPrint('FirebaseSyncService: Remote vrats fetch fallback: $e');
    }

    // Fallback to local cache
    final cached = await _loadFromCache(cacheKeyVrats);
    if (cached != null) {
      try {
        final list = jsonDecode(cached) as List<dynamic>;
        final vrats = list.map((i) => VratItem.fromJson(i as Map<String, dynamic>)).toList();
        if (vrats.isNotEmpty) {
          latestVrats = vrats;
          return vrats;
        }
      } catch (_) {}
    }

    // Fallback to bundled JSON
    try {
      final bundledStr = await rootBundle.loadString('assets/data/vrats_production.json');
      final list = jsonDecode(bundledStr) as List<dynamic>;
      final vrats = list.map((i) => VratItem.fromJson(i as Map<String, dynamic>)).toList();
      latestVrats = vrats;
      return vrats;
    } catch (e) {
      debugPrint('FirebaseSyncService: Failed to load bundled vrats: $e');
      return latestVrats;
    }
  }

  static bool _isSyncingWallpapers = false;

  /// Loads offline 4K Wallpapers immediately from local cache or bundled production asset
  static Future<List<DevotionalWallpaper>> loadOfflineWallpapers() async {
    if (latestWallpapers.isNotEmpty) return latestWallpapers;

    // 1. Check local cache
    final cached = await _loadFromCache(cacheKeyWallpapers);
    if (cached != null) {
      try {
        final list = jsonDecode(cached) as List<dynamic>;
        final items = list.map((i) => DevotionalWallpaper.fromJson(i as Map<String, dynamic>)).toList();
        if (items.isNotEmpty) {
          latestWallpapers = items;
          return items;
        }
      } catch (_) {}
    }

    // 2. Fallback to bundled JSON asset
    try {
      final bundledStr = await rootBundle.loadString('assets/data/wallpapers_production.json');
      final list = jsonDecode(bundledStr) as List<dynamic>;
      final items = list.map((i) => DevotionalWallpaper.fromJson(i as Map<String, dynamic>)).toList();
      latestWallpapers = items;
      return items;
    } catch (e) {
      debugPrint('FirebaseSyncService: Error loading bundled wallpapers: $e');
      return latestWallpapers;
    }
  }

  /// Silent Background Sync for Wallpapers from Firestore
  static Future<void> syncWallpapersInBackground() async {
    if (_isSyncingWallpapers) return;
    _isSyncingWallpapers = true;

    try {
      final client = HttpClient()..connectionTimeout = const Duration(seconds: 12);
      final req = await client.getUrl(Uri.parse('$baseUrl/wallpapers?pageSize=100'));
      final res = await req.close();
      if (res.statusCode == 200) {
        final body = await res.transform(utf8.decoder).join();
        final jsonDoc = jsonDecode(body) as Map<String, dynamic>;
        final docs = jsonDoc['documents'] as List<dynamic>? ?? [];

        final items = <DevotionalWallpaper>[];
        for (final d in docs) {
          final unpacked = unpackFirestoreDoc(d as Map<String, dynamic>);
          items.add(DevotionalWallpaper.fromJson(unpacked));
        }

        if (items.isNotEmpty) {
          latestWallpapers = items;
          _saveToCache(cacheKeyWallpapers, jsonEncode(items.map((w) => w.toJson()).toList()));
          if (!_wallpapersController.isClosed) _wallpapersController.add(items);
          debugPrint('FirebaseSyncService: Synced ${items.length} wallpapers from Firestore.');
        }
      }
    } catch (e) {
      debugPrint('FirebaseSyncService: Wallpapers background sync notice: $e');
    } finally {
      _isSyncingWallpapers = false;
    }
  }

  /// 5. Sync 4K Wallpapers (Offline-first + Background Sync)
  static Future<List<DevotionalWallpaper>> syncWallpapers() async {
    final offline = await loadOfflineWallpapers();
    unawaited(syncWallpapersInBackground());
    return offline;
  }

  static bool _isSyncingGita = false;

  /// Loads offline Gita immediately (from local synced file cache or bundled production asset).
  /// Executes in < 20ms so UI displays instantly without any spinner.
  static Future<Map<String, dynamic>> loadOfflineGita() async {
    if (latestGitaChapters.isNotEmpty && latestGitaShlokas.isNotEmpty) {
      return {'chapters': latestGitaChapters, 'shlokas': latestGitaShlokas};
    }

    // 1. Check local synced file cache (saved from previous Firestore sync)
    try {
      final dir = await getApplicationDocumentsDirectory();
      final cacheFile = File('${dir.path}/gita_synced_cache.json');
      if (await cacheFile.exists()) {
        final content = await cacheFile.readAsString();
        final data = jsonDecode(content) as Map<String, dynamic>;
        final chList = (data['chapters'] as List<dynamic>? ?? [])
            .map((c) => GitaChapter.fromJson(c as Map<String, dynamic>))
            .toList();
        final shList = (data['shlokas'] as List<dynamic>? ?? [])
            .map((s) => GitaShloka.fromJson(s as Map<String, dynamic>))
            .toList();
        if (chList.isNotEmpty && shList.isNotEmpty) {
          latestGitaChapters = chList;
          latestGitaShlokas = shList;
          debugPrint('FirebaseSyncService: Loaded ${chList.length} chapters & ${shList.length} shlokas from local synced file cache.');
          return {'chapters': latestGitaChapters, 'shlokas': latestGitaShlokas};
        }
      }
    } catch (e) {
      debugPrint('FirebaseSyncService: Local synced cache read notice: $e');
    }

    // 2. Load bundled production asset (all 18 chapters & 701 shlokas)
    try {
      final bundledStr = await rootBundle.loadString('assets/data/gita_production.json');
      final data = jsonDecode(bundledStr) as Map<String, dynamic>;
      final chList = (data['chapters'] as List<dynamic>? ?? [])
          .map((c) => GitaChapter.fromJson(c as Map<String, dynamic>))
          .toList();
      final shList = (data['shlokas'] as List<dynamic>? ?? [])
          .map((s) => GitaShloka.fromJson(s as Map<String, dynamic>))
          .toList();
      if (chList.isNotEmpty) latestGitaChapters = chList;
      if (shList.isNotEmpty) latestGitaShlokas = shList;
      debugPrint('FirebaseSyncService: Loaded ${chList.length} chapters & ${shList.length} shlokas from bundled offline asset.');
      return {'chapters': latestGitaChapters, 'shlokas': latestGitaShlokas};
    } catch (e) {
      debugPrint('FirebaseSyncService: Failed to load bundled Gita asset: $e');
      return {'chapters': latestGitaChapters, 'shlokas': latestGitaShlokas};
    }
  }

  /// Silent Background Sync: pulls latest chapters & shlokas from Firestore
  /// Runs completely in the background without blocking the UI.
  static Future<void> syncGitaInBackground() async {
    if (_isSyncingGita) return;
    _isSyncingGita = true;

    try {
      final client = HttpClient()..connectionTimeout = const Duration(seconds: 15);
      final chReq = await client.getUrl(Uri.parse('$baseUrl/gita_chapters?pageSize=50'));
      final chRes = await chReq.close();
      final List<GitaChapter> chapters = [];
      if (chRes.statusCode == 200) {
        final body = await chRes.transform(utf8.decoder).join();
        final jsonDoc = jsonDecode(body) as Map<String, dynamic>;
        final docs = jsonDoc['documents'] as List<dynamic>? ?? [];
        for (final d in docs) {
          final unpacked = unpackFirestoreDoc(d as Map<String, dynamic>);
          chapters.add(GitaChapter.fromJson(unpacked));
        }
        chapters.sort((a, b) => a.chapterNumber.compareTo(b.chapterNumber));
      }

      final List<GitaShloka> shlokas = [];
      String? pageToken;
      do {
        final url = '$baseUrl/gita_shlokas?pageSize=300${pageToken != null ? '&pageToken=$pageToken' : ''}';
        final shReq = await client.getUrl(Uri.parse(url));
        final shRes = await shReq.close();
        if (shRes.statusCode == 200) {
          final body = await shRes.transform(utf8.decoder).join();
          final jsonDoc = jsonDecode(body) as Map<String, dynamic>;
          final docs = jsonDoc['documents'] as List<dynamic>? ?? [];
          for (final d in docs) {
            final unpacked = unpackFirestoreDoc(d as Map<String, dynamic>);
            shlokas.add(GitaShloka.fromJson(unpacked));
          }
          pageToken = jsonDoc['nextPageToken'] as String?;
        } else {
          break;
        }
      } while (pageToken != null && pageToken.isNotEmpty);

      shlokas.sort((a, b) {
        final chCmp = a.chapterNumber.compareTo(b.chapterNumber);
        if (chCmp != 0) return chCmp;
        return a.verseNumber.compareTo(b.verseNumber);
      });

      if (chapters.isNotEmpty) {
        latestGitaChapters = chapters;
        if (!_gitaChaptersController.isClosed) _gitaChaptersController.add(chapters);
      }
      if (shlokas.isNotEmpty) {
        latestGitaShlokas = shlokas;
        if (!_gitaShlokasController.isClosed) _gitaShlokasController.add(shlokas);
      }

      if (chapters.isNotEmpty && shlokas.isNotEmpty) {
        try {
          final dir = await getApplicationDocumentsDirectory();
          final cacheFile = File('${dir.path}/gita_synced_cache.json');
          final cacheMap = {
            'chapters': chapters.map((c) => c.toJson()).toList(),
            'shlokas': shlokas.map((s) => s.toJson()).toList(),
          };
          await cacheFile.writeAsString(jsonEncode(cacheMap));
          debugPrint('FirebaseSyncService: Gita background sync cached ${chapters.length} chapters & ${shlokas.length} shlokas.');
        } catch (e) {
          debugPrint('FirebaseSyncService: Failed to save Gita file cache: $e');
        }
      }
    } catch (e) {
      debugPrint('FirebaseSyncService: Gita background sync notice: $e');
    } finally {
      _isSyncingGita = false;
    }
  }

  /// 5. Sync Shrimad Bhagavad Gita (Offline-first + Background Sync)
  /// Returns offline data instantly (< 20ms) and syncs in background.
  static Future<Map<String, dynamic>> syncGita() async {
    final offline = await loadOfflineGita();
    unawaited(syncGitaInBackground());
    return offline;
  }

  static Future<void> _saveToCache(String key, String value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
    } catch (_) {}
  }

  static Future<String?> _loadFromCache(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    } catch (_) {
      return null;
    }
  }
}
