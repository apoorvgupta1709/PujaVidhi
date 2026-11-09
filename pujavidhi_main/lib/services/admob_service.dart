import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../core/app_constants.dart';
import 'firebase_sync_service.dart';

class AdMobService {
  static bool _initialized = false;
  static InterstitialAd? _interstitialAd;
  static RewardedAd? _rewardedAd;
  static int _interstitialCounter = 0;

  static bool get isAdMobEnabled =>
      FirebaseSyncService.latestConfig['admob_enabled'] ?? true;
  static bool get isBannerEnabled =>
      isAdMobEnabled && (FirebaseSyncService.latestConfig['banner_enabled'] ?? true);
  static bool get isInterstitialEnabled =>
      isAdMobEnabled && (FirebaseSyncService.latestConfig['interstitial_enabled'] ?? true);
  static bool get isRewardedEnabled =>
      isAdMobEnabled && (FirebaseSyncService.latestConfig['rewarded_enabled'] ?? true);
  static int get adFrequencyInterval =>
      FirebaseSyncService.latestConfig['interstitial_frequency_rounds'] ??
      AppConstants.defaultAdFrequencyInterval;

  static String get bannerAdUnitId =>
      FirebaseSyncService.latestConfig['banner_ad_unit_id']?.toString() ??
      AppConstants.testBannerId;
  static String get interstitialAdUnitId =>
      FirebaseSyncService.latestConfig['interstitial_ad_unit_id']?.toString() ??
      AppConstants.testInterstitialId;
  static String get rewardedAdUnitId =>
      FirebaseSyncService.latestConfig['rewarded_ad_unit_id']?.toString() ??
      AppConstants.testRewardedId;

  static Future<void> initialize() async {
    if (_initialized) return;
    try {
      await MobileAds.instance.initialize();
      _initialized = true;

      // Listen for remote config updates from Admin App via Firebase
      FirebaseSyncService.configStream.listen((cfg) {
        debugPrint('AdMobService: Remote config updated by Admin App: $cfg');
      });

      if (isInterstitialEnabled) loadInterstitialAd();
      if (isRewardedEnabled) loadRewardedAd();
    } catch (e) {
      debugPrint("AdMob initialization skipped/failed: $e");
    }
  }

  // Interstitial Ad Management (Controlled by Admin App)
  static void loadInterstitialAd() {
    if (!isInterstitialEnabled) return;
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (error) {
          _interstitialAd = null;
        },
      ),
    );
  }

  static void showInterstitialIfAllowed({
    required bool isProUser,
    required VoidCallback onDismissed,
  }) {
    // 1. Pro users NEVER see ads
    // 2. If Admin App disabled AdMob or Interstitials, bypass immediately
    if (isProUser || !isInterstitialEnabled) {
      onDismissed();
      return;
    }

    _interstitialCounter++;
    if (_interstitialCounter >= adFrequencyInterval && _interstitialAd != null) {
      _interstitialCounter = 0;
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          loadInterstitialAd();
          onDismissed();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          loadInterstitialAd();
          onDismissed();
        },
      );
      _interstitialAd!.show();
    } else {
      onDismissed();
    }
  }

  // Rewarded Ad Management (Controlled by Admin App)
  static void loadRewardedAd() {
    if (!isRewardedEnabled) return;
    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
        },
        onAdFailedToLoad: (error) {
          _rewardedAd = null;
        },
      ),
    );
  }

  static void showRewardedAd({
    required bool isProUser,
    required VoidCallback onUserEarnedReward,
    required VoidCallback onDismissedWithoutReward,
  }) {
    // 1. Pro users get instant reward
    // 2. If Admin App disabled Rewarded ads, bypass and grant reward immediately
    if (isProUser || !isRewardedEnabled) {
      onUserEarnedReward();
      return;
    }

    if (_rewardedAd != null) {
      bool earned = false;
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          loadRewardedAd();
          if (earned) {
            onUserEarnedReward();
          } else {
            onDismissedWithoutReward();
          }
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          loadRewardedAd();
          // Fallback reward on failure to avoid blocking user
          onUserEarnedReward();
        },
      );

      _rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          earned = true;
        },
      );
    } else {
      // If ad not ready, grant reward gracefully
      loadRewardedAd();
      onUserEarnedReward();
    }
  }
}
