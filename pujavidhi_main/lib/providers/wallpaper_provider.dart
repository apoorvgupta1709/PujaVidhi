import 'dart:async';
import 'package:flutter/material.dart';
import '../models/wallpaper_model.dart';
import '../services/firebase_sync_service.dart';

class WallpaperProvider with ChangeNotifier {
  List<DevotionalWallpaper> _wallpapers = [];
  String _selectedCategory = 'All';
  DevotionalWallpaper? _selectedStudioWallpaper;
  bool _isLoading = true;

  StreamSubscription<List<DevotionalWallpaper>>? _sub;

  List<DevotionalWallpaper> get wallpapers => _wallpapers;
  String get selectedCategory => _selectedCategory;
  DevotionalWallpaper? get selectedStudioWallpaper => _selectedStudioWallpaper;
  bool get isLoading => _isLoading;

  List<DevotionalWallpaper> get filteredWallpapers {
    if (_selectedCategory == 'All') return _wallpapers;
    return _wallpapers
        .where((w) =>
            w.category.toLowerCase() == _selectedCategory.toLowerCase() ||
            w.deity.toLowerCase().contains(_selectedCategory.toLowerCase()))
        .toList();
  }

  WallpaperProvider() {
    _init();
  }

  Future<void> _init() async {
    // 1. Immediate offline load
    _wallpapers = await FirebaseSyncService.loadOfflineWallpapers();
    if (_wallpapers.isNotEmpty) {
      _selectedStudioWallpaper = _wallpapers.first;
    }
    _isLoading = false;
    notifyListeners();

    // 2. Listen for background sync updates
    _sub = FirebaseSyncService.wallpapersStream.listen((synced) {
      if (synced.isNotEmpty) {
        _wallpapers = List.from(synced);
        if (_selectedStudioWallpaper == null ||
            !_wallpapers.any((w) => w.id == _selectedStudioWallpaper!.id)) {
          _selectedStudioWallpaper = _wallpapers.first;
        }
        notifyListeners();
      }
    });

    // 3. Trigger background sync
    unawaited(FirebaseSyncService.syncWallpapersInBackground());
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  void setCategory(String cat) {
    _selectedCategory = cat;
    notifyListeners();
  }

  void selectStudioWallpaper(DevotionalWallpaper wp) {
    _selectedStudioWallpaper = wp;
    notifyListeners();
  }
}
