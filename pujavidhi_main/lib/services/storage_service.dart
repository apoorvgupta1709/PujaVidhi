import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/app_constants.dart';
import '../models/japa_model.dart';

class StorageService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Bhakt Prime Pass Pro Status
  static bool getIsPro() {
    return _prefs?.getBool(AppConstants.keyIsPro) ?? false;
  }

  static Future<void> setIsPro(bool value) async {
    await _prefs?.setBool(AppConstants.keyIsPro, value);
  }

  // Custom Family Name for Greeting Cards
  static String getFamilyName() {
    return _prefs?.getString(AppConstants.keyFamilyName) ?? "Sharma Parivar";
  }

  static Future<void> setFamilyName(String name) async {
    await _prefs?.setString(AppConstants.keyFamilyName, name);
  }

  // Japa Sadhana History Records
  static List<JapaRecord> getJapaHistory() {
    final raw = _prefs?.getStringList(AppConstants.keyJapaHistory);
    if (raw == null || raw.isEmpty) return [];
    try {
      return raw.map((item) => JapaRecord.fromJson(jsonDecode(item) as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveJapaRecord(JapaRecord record) async {
    final list = getJapaHistory();
    list.insert(0, record);
    // keep latest 100
    final trimmed = list.take(100).toList();
    final strings = trimmed.map((r) => jsonEncode(r.toJson())).toList();
    await _prefs?.setStringList(AppConstants.keyJapaHistory, strings);
  }

  // Offline Downloaded Tracks
  static Set<String> getDownloadedTrackIds() {
    final raw = _prefs?.getStringList(AppConstants.keyDownloadedTracks);
    return raw?.toSet() ?? <String>{};
  }

  static Future<void> markTrackDownloaded(String trackId) async {
    final set = getDownloadedTrackIds();
    set.add(trackId);
    await _prefs?.setStringList(AppConstants.keyDownloadedTracks, set.toList());
  }

  // Dark Mode Setting
  static bool isDarkMode() {
    return _prefs?.getBool(AppConstants.keyDarkMode) ?? false;
  }

  static Future<void> setDarkMode(bool value) async {
    await _prefs?.setBool(AppConstants.keyDarkMode, value);
  }
}
