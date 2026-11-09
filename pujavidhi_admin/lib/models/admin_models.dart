class FestivalVidhiEntry {
  final String id;
  String title;
  String deity;
  String festivalDate;
  String regionalTag;
  int estimatedMinutes;
  List<String> samagriItems;

  FestivalVidhiEntry({
    required this.id,
    required this.title,
    required this.deity,
    required this.festivalDate,
    required this.regionalTag,
    required this.estimatedMinutes,
    required this.samagriItems,
  });
}

class MediaUploadItem {
  final String id;
  String title;
  String category; // Aarti, Chalisa, Wallpaper
  String mediaType; // Audio (MP3/WAV), Image (PNG/JPEG)
  String fileUrl;
  double sizeMB;
  String status; // Uploaded, Processing, Draft

  MediaUploadItem({
    required this.id,
    required this.title,
    required this.category,
    required this.mediaType,
    required this.fileUrl,
    required this.sizeMB,
    required this.status,
  });
}

class NotificationBroadcast {
  final String id;
  String title;
  String message;
  String scheduledTime; // e.g. "06:00 AM Daily"
  String muhuratDetail;
  bool isScheduled;

  NotificationBroadcast({
    required this.id,
    required this.title,
    required this.message,
    required this.scheduledTime,
    required this.muhuratDetail,
    this.isScheduled = true,
  });
}

class AdminMonetizationConfig {
  bool adsEnabled;
  int adFrequencyInterval;
  int passPriceINR;
  String festiveBanner;
  String bannerId;
  String interstitialId;
  String rewardedId;

  AdminMonetizationConfig({
    this.adsEnabled = true,
    this.adFrequencyInterval = 2,
    this.passPriceINR = 99,
    this.festiveBanner = "Festive Offer: 33% Off Lifetime Bhakt Prime Pass!",
    this.bannerId = "ca-app-pub-3940256099942544/6300978111",
    this.interstitialId = "ca-app-pub-3940256099942544/1033173712",
    this.rewardedId = "ca-app-pub-3940256099942544/5224354917",
  });
}
