import 'package:flutter/material.dart';
import '../models/vidhi_model.dart';
import '../services/firebase_sync_service.dart';

class VidhiProvider with ChangeNotifier {
  final List<PujaVidhi> _vidhis = [];
  String _selectedCategory = "All";
  bool _isLoading = true;

  List<PujaVidhi> get vidhis {
    if (_selectedCategory == "All") return _vidhis;
    return _vidhis
        .where((v) =>
            v.regionalTag.toLowerCase().contains(_selectedCategory.toLowerCase()) ||
            v.festivalTag.toLowerCase().contains(_selectedCategory.toLowerCase()))
        .toList();
  }

  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;

  VidhiProvider() {
    _initVidhis();

    // Listen to real-time sync updates from Firebase/Admin App
    FirebaseSyncService.vidhisStream.listen((syncedVidhis) {
      if (syncedVidhis.isNotEmpty) {
        _vidhis.clear();
        _vidhis.addAll(syncedVidhis);
        notifyListeners();
      }
    });
  }

  void filterCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void toggleSamagriItem(PujaVidhi vidhi, int index) {
    vidhi.samagriList[index].isChecked = !vidhi.samagriList[index].isChecked;
    notifyListeners();
  }

  Future<void> _initVidhis() async {
    _isLoading = true;
    notifyListeners();

    final fetched = await FirebaseSyncService.syncVidhis();
    if (fetched.isNotEmpty) {
      _vidhis.clear();
      _vidhis.addAll(fetched);
    }
    _isLoading = false;
    notifyListeners();
  }
}
