class AppConstants {
  static const String appName = "PujaVidhi";
  static const String appVersion = "1.0.0";
  
  // Signature attribution - STRICTLY for Settings screen only
  static const String settingsAttribution = "v$appVersion • Made with ❤️ by Apoorv";

  // Official Google Mobile Ads Test Unit IDs (Android)
  static const String testBannerId = "ca-app-pub-3940256099942544/6300978111";
  static const String testInterstitialId = "ca-app-pub-3940256099942544/1033173712";
  static const String testRewardedId = "ca-app-pub-3940256099942544/5224354917";

  // Bhakt Prime Pass Defaults
  static const int defaultPassPriceINR = 99;
  static const int strikePassPriceINR = 149;

  // Interstitial Ad Frequency Cap (e.g. after every 1 japa round or every 2 chapter views)
  static const int defaultAdFrequencyInterval = 2;

  // Storage Keys
  static const String keyIsPro = "pujavidhi_is_pro_active";
  static const String keyFamilyName = "pujavidhi_custom_family_name";
  static const String keyJapaHistory = "pujavidhi_japa_history_records";
  static const String keyDownloadedTracks = "pujavidhi_downloaded_tracks";
  static const String keyDarkMode = "pujavidhi_dark_mode_enabled";
}
