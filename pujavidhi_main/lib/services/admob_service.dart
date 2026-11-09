import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../core/app_constants.dart';

class AdMobService {
  static bool _initialized = false;
  static InterstitialAd? _interstitialAd;
  static RewardedAd? _rewardedAd;
  static int _interstitialCounter = 0;

  static Future<void> initialize() async {
    if (_initialized) return;
    try {
      await MobileAds.instance.initialize();
      _initialized = true;
      loadInterstitialAd();
      loadRewardedAd();
    } catch (e) {
      debugPrint("AdMob initialization skipped/failed: $e");
    }
  }

  // Interstitial Ad Management
  static void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AppConstants.testInterstitialId,
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
    // Pro users NEVER see ads
    if (isProUser) {
      onDismissed();
      return;
    }

    _interstitialCounter++;
    if (_interstitialCounter >= AppConstants.defaultAdFrequencyInterval && _interstitialAd != null) {
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

  // Rewarded Ad Management
  static void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: AppConstants.testRewardedId,
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
    if (isProUser) {
      // Pro users get reward instantly without ads
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
