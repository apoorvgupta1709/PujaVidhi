import 'package:flutter/material.dart';
import '../models/admin_models.dart';
import 'admin_firebase_service.dart';

class AdminProvider with ChangeNotifier {
  final List<FestivalVidhiEntry> _vidhis = [];
  final List<MediaUploadItem> _mediaList = [];
  final List<NotificationBroadcast> _broadcasts = [];
  AdminMonetizationConfig _monetization = AdminMonetizationConfig();
  bool _isLoading = false;
  String _statusMessage = "Connected to Firebase Firestore";

  List<FestivalVidhiEntry> get vidhis => _vidhis;
  List<MediaUploadItem> get mediaList => _mediaList;
  List<NotificationBroadcast> get broadcasts => _broadcasts;
  AdminMonetizationConfig get monetization => _monetization;
  bool get isLoading => _isLoading;
  String get statusMessage => _statusMessage;

  AdminProvider() {
    initFromFirebase();
  }

  Future<void> initFromFirebase() async {
    _isLoading = true;
    _statusMessage = "Syncing data from Firebase...";
    notifyListeners();

    try {
      // 1. Fetch monetization remote config
      final cfg = await AdminFirebaseService.fetchMonetizationConfig();
      if (cfg != null) {
        _monetization = cfg;
      }

      // 2. Fetch Aartis and Media
      final media = await AdminFirebaseService.fetchMediaItems();
      if (media.isNotEmpty) {
        _mediaList.clear();
        _mediaList.addAll(media);
      }

      // 3. Fetch Vidhis
      final remoteVidhis = await AdminFirebaseService.fetchVidhis();
      if (remoteVidhis.isNotEmpty) {
        _vidhis.clear();
        _vidhis.addAll(remoteVidhis);
      }

      _statusMessage = "Firebase Synced (${_mediaList.length} Aartis, ${_vidhis.length} Vidhis live)";
    } catch (e) {
      _statusMessage = "Offline Mode (Using local defaults): $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // --- Monetization & AdMob Controls ---
  Future<bool> saveMonetizationToFirebase() async {
    _statusMessage = "Pushing AdMob & Pricing settings to Firebase...";
    notifyListeners();

    final ok = await AdminFirebaseService.pushMonetizationConfig(_monetization);
    if (ok) {
      _statusMessage = "AdMob settings live on mobile clients!";
    } else {
      _statusMessage = "Failed to update Firebase monetization settings.";
    }
    notifyListeners();
    return ok;
  }

  void toggleAds(bool enabled) {
    _monetization.adsEnabled = enabled;
    notifyListeners();
    saveMonetizationToFirebase();
  }

  void toggleBanner(bool enabled) {
    _monetization.bannerEnabled = enabled;
    notifyListeners();
    saveMonetizationToFirebase();
  }

  void toggleInterstitial(bool enabled) {
    _monetization.interstitialEnabled = enabled;
    notifyListeners();
    saveMonetizationToFirebase();
  }

  void toggleRewarded(bool enabled) {
    _monetization.rewardedEnabled = enabled;
    notifyListeners();
    saveMonetizationToFirebase();
  }

  void setAdFrequency(int interval) {
    _monetization.adFrequencyInterval = interval;
    notifyListeners();
    saveMonetizationToFirebase();
  }

  void setPrimePassPrice(int price) {
    _monetization.passPriceINR = price;
    notifyListeners();
    saveMonetizationToFirebase();
  }

  void setFestiveBanner(String banner) {
    _monetization.festiveBanner = banner;
    notifyListeners();
    saveMonetizationToFirebase();
  }

  // --- Vidhi Management ---
  Future<void> addVidhi(FestivalVidhiEntry entry) async {
    _vidhis.add(entry);
    notifyListeners();
    _statusMessage = "Pushing ${entry.title} to Firebase...";
    notifyListeners();
    await AdminFirebaseService.pushVidhi(entry);
    _statusMessage = "${entry.title} is now live on mobile app!";
    notifyListeners();
  }

  // --- Media & Aarti Management ---
  Future<void> addMedia(MediaUploadItem item) async {
    _mediaList.add(item);
    notifyListeners();
    _statusMessage = "Pushing ${item.title} to Firebase...";
    notifyListeners();
    await AdminFirebaseService.pushMediaItem(item);
    _statusMessage = "${item.title} is now live on mobile app!";
    notifyListeners();
  }

  // --- Notification Broadcaster ---
  Future<void> addBroadcast(NotificationBroadcast broadcast) async {
    _broadcasts.add(broadcast);
    notifyListeners();
    _statusMessage = "Broadcasting notification to Firebase...";
    notifyListeners();
    await AdminFirebaseService.pushBroadcast(broadcast);
    _statusMessage = "Morning broadcast scheduled!";
    notifyListeners();
  }
}
