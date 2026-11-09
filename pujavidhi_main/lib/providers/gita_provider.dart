import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/gita_model.dart';
import '../services/firebase_sync_service.dart';

class GitaProvider with ChangeNotifier {
  static const String _keyBookmarks = 'pujavidhi_gita_bookmarks_v1';

  List<GitaChapter> _chapters = [];
  List<GitaShloka> _shlokas = [];
  final Set<String> _bookmarkedIds = {};
  String _selectedTopic = 'All';
  String _searchQuery = '';
  bool _isLoading = true;

  StreamSubscription<List<GitaChapter>>? _chSub;
  StreamSubscription<List<GitaShloka>>? _shSub;

  List<GitaChapter> get chapters => _chapters;
  List<GitaShloka> get shlokas => _shlokas;
  Set<String> get bookmarkedIds => _bookmarkedIds;
  String get selectedTopic => _selectedTopic;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;

  GitaProvider() {
    _init();
  }

  Future<void> _init() async {
    await _loadBookmarks();
    await _loadData();

    _chSub = FirebaseSyncService.gitaChaptersStream.listen((chs) {
      if (chs.isNotEmpty) {
        _chapters = List.from(chs);
        notifyListeners();
      }
    });

    _shSub = FirebaseSyncService.gitaShlokasStream.listen((shs) {
      if (shs.isNotEmpty) {
        _shlokas = List.from(shs);
        _applyBookmarks();
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _chSub?.cancel();
    _shSub?.cancel();
    super.dispose();
  }

  Future<void> _loadData() async {
    // 1. Immediately display offline synced data (0ms delay)
    final res = await FirebaseSyncService.loadOfflineGita();
    _chapters = List<GitaChapter>.from(res['chapters'] ?? []);
    _shlokas = List<GitaShloka>.from(res['shlokas'] ?? []);
    _applyBookmarks();
    _isLoading = false;
    notifyListeners();

    // 2. Trigger non-blocking background sync from Firestore
    unawaited(FirebaseSyncService.syncGitaInBackground());
  }

  Future<void> _loadBookmarks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList(_keyBookmarks) ?? [];
      _bookmarkedIds.clear();
      _bookmarkedIds.addAll(list);
    } catch (_) {}
  }

  void _applyBookmarks() {
    for (final s in _shlokas) {
      s.isBookmarked = _bookmarkedIds.contains(s.id);
    }
  }

  Future<void> toggleBookmark(GitaShloka shloka) async {
    final willBookmark = !_bookmarkedIds.contains(shloka.id);
    if (willBookmark) {
      _bookmarkedIds.add(shloka.id);
    } else {
      _bookmarkedIds.remove(shloka.id);
    }
    shloka.isBookmarked = willBookmark;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_keyBookmarks, _bookmarkedIds.toList());
    } catch (_) {}
  }

  void setTopic(String topic) {
    _selectedTopic = topic;
    notifyListeners();
  }

  void setSearchQuery(String q) {
    _searchQuery = q;
    notifyListeners();
  }

  List<GitaShloka> getShlokasForChapter(int chapterNum) {
    return _shlokas.where((s) => s.chapterNumber == chapterNum).toList();
  }

  List<GitaShloka> get bookmarkedShlokas {
    return _shlokas.where((s) => _bookmarkedIds.contains(s.id)).toList();
  }

  List<GitaShloka> get filteredShlokas {
    return _shlokas.where((s) {
      if (_selectedTopic != 'All' && s.topicTag != _selectedTopic) {
        return false;
      }
      if (_searchQuery.trim().isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return s.textSanskrit.contains(q) ||
          s.textTransliteration.toLowerCase().contains(q) ||
          s.translationHindi.contains(q) ||
          s.translationEnglish.toLowerCase().contains(q) ||
          s.topicTag.toLowerCase().contains(q);
    }).toList();
  }

  /// Today's Divine Shloka (Verse of the day based on day of year)
  GitaShloka? get dailyVerse {
    if (_shlokas.isEmpty) return null;
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    final index = dayOfYear % _shlokas.length;
    return _shlokas[index];
  }
}
