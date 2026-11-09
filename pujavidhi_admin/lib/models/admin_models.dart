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

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'deity': deity,
    'festivalTag': festivalDate,
    'regionalTag': regionalTag,
    'estimatedMinutes': estimatedMinutes,
    'samagriList': samagriItems.map((s) => {'name': s, 'quantity': '1 unit', 'category': 'Essential', 'isChecked': false}).toList(),
  };

  factory FestivalVidhiEntry.fromJson(Map<String, dynamic> json) {
    final rawSamagri = json['samagriList'] as List<dynamic>? ?? [];
    final items = rawSamagri.map((i) {
      if (i is Map) return i['name']?.toString() ?? '';
      return i.toString();
    }).where((s) => s.isNotEmpty).toList();

    return FestivalVidhiEntry(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      deity: json['deity']?.toString() ?? '',
      festivalDate: json['festivalTag']?.toString() ?? json['festivalDate']?.toString() ?? '',
      regionalTag: json['regionalTag']?.toString() ?? '',
      estimatedMinutes: json['estimatedMinutes'] is int
          ? json['estimatedMinutes']
          : int.tryParse(json['estimatedMinutes']?.toString() ?? '30') ?? 30,
      samagriItems: items.isNotEmpty ? items : ["Gangajal", "Diyas", "Roli", "Akshat"],
    );
  }
}

class MediaUploadItem {
  final String id;
  String title;
  String hindiTitle;
  String deity;
  String category; // Aarti, Chalisa, Wallpaper
  String mediaType; // Audio (MP3/WAV), Image (PNG/JPEG)
  String fileUrl;
  double sizeMB;
  String status; // Uploaded, Processing, Draft
  String significance;
  List<Map<String, dynamic>> lyrics;

  MediaUploadItem({
    required this.id,
    required this.title,
    this.hindiTitle = '',
    this.deity = 'All Deities',
    required this.category,
    required this.mediaType,
    required this.fileUrl,
    required this.sizeMB,
    required this.status,
    this.significance = '',
    this.lyrics = const [],
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'hindiTitle': hindiTitle,
    'deity': deity,
    'category': category,
    'durationSec': (sizeMB * 30).round(),
    'localAssetPath': 'audio/temple_bell.wav',
    'remoteStreamUrl': fileUrl,
    'significance': significance,
    'lyrics': lyrics,
  };

  factory MediaUploadItem.fromJson(Map<String, dynamic> json) {
    final rawLyrics = json['lyrics'] as List<dynamic>? ?? [];
    return MediaUploadItem(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      hindiTitle: json['hindiTitle']?.toString() ?? '',
      deity: json['deity']?.toString() ?? '',
      category: json['category']?.toString() ?? 'Aarti',
      mediaType: 'Audio (MP3)',
      fileUrl: json['remoteStreamUrl']?.toString() ?? json['fileUrl']?.toString() ?? '',
      sizeMB: (json['durationSec'] is int ? json['durationSec'] / 30.0 : 4.5).toDouble(),
      status: 'Live on Cloud',
      significance: json['significance']?.toString() ?? '',
      lyrics: rawLyrics.map((l) => Map<String, dynamic>.from(l as Map)).toList(),
    );
  }
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

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'message': message,
    'scheduledTime': scheduledTime,
    'muhuratDetail': muhuratDetail,
    'isScheduled': isScheduled,
  };

  factory NotificationBroadcast.fromJson(Map<String, dynamic> json) {
    return NotificationBroadcast(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      scheduledTime: json['scheduledTime']?.toString() ?? '06:00 AM',
      muhuratDetail: json['muhuratDetail']?.toString() ?? '',
      isScheduled: json['isScheduled'] == true,
    );
  }
}

class AdminMonetizationConfig {
  bool adsEnabled;
  bool bannerEnabled;
  bool interstitialEnabled;
  bool rewardedEnabled;
  int adFrequencyInterval;
  int passPriceINR;
  String festiveBanner;
  String bannerId;
  String interstitialId;
  String rewardedId;

  AdminMonetizationConfig({
    this.adsEnabled = true,
    this.bannerEnabled = true,
    this.interstitialEnabled = true,
    this.rewardedEnabled = true,
    this.adFrequencyInterval = 1,
    this.passPriceINR = 99,
    this.festiveBanner = "Festive Offer: 33% Off Lifetime Bhakt Prime Pass!",
    this.bannerId = "ca-app-pub-3940256099942544/6300978111",
    this.interstitialId = "ca-app-pub-3940256099942544/1033173712",
    this.rewardedId = "ca-app-pub-3940256099942544/5224354917",
  });

  Map<String, dynamic> toJson() => {
    'admob_enabled': adsEnabled,
    'banner_enabled': bannerEnabled,
    'interstitial_enabled': interstitialEnabled,
    'rewarded_enabled': rewardedEnabled,
    'interstitial_frequency_rounds': adFrequencyInterval,
    'bhakt_prime_price': passPriceINR,
    'festive_discount_enabled': passPriceINR < 149,
    'banner_ad_unit_id': bannerId,
    'interstitial_ad_unit_id': interstitialId,
    'rewarded_ad_unit_id': rewardedId,
  };

  factory AdminMonetizationConfig.fromJson(Map<String, dynamic> json) {
    return AdminMonetizationConfig(
      adsEnabled: json['admob_enabled'] == true || json['adsEnabled'] == true,
      bannerEnabled: json['banner_enabled'] != false,
      interstitialEnabled: json['interstitial_enabled'] != false,
      rewardedEnabled: json['rewarded_enabled'] != false,
      adFrequencyInterval: json['interstitial_frequency_rounds'] is int
          ? json['interstitial_frequency_rounds']
          : int.tryParse(json['interstitial_frequency_rounds']?.toString() ?? '1') ?? 1,
      passPriceINR: json['bhakt_prime_price'] is int
          ? json['bhakt_prime_price']
          : int.tryParse(json['bhakt_prime_price']?.toString() ?? '99') ?? 99,
      festiveBanner: json['festiveBanner']?.toString() ?? "Festive Offer: 33% Off Lifetime Bhakt Prime Pass!",
      bannerId: json['banner_ad_unit_id']?.toString() ?? "ca-app-pub-3940256099942544/6300978111",
      interstitialId: json['interstitial_ad_unit_id']?.toString() ?? "ca-app-pub-3940256099942544/1033173712",
      rewardedId: json['rewarded_ad_unit_id']?.toString() ?? "ca-app-pub-3940256099942544/5224354917",
    );
  }
}

class AdminWallpaperItem {
  final String id;
  String title;
  String deity;
  String imageUrl;
  String thumbnail;
  String mantraSanskrit;
  String quoteEnglish;
  List<String> gradientColors;
  String iconBadge;
  bool isFeatured;
  bool is4k;
  int downloadsCount;
  String category;

  AdminWallpaperItem({
    required this.id,
    required this.title,
    required this.deity,
    required this.imageUrl,
    this.thumbnail = '',
    this.mantraSanskrit = '',
    this.quoteEnglish = '',
    this.gradientColors = const ['#1E1B4B', '#312E81', '#6366F1'],
    this.iconBadge = '🕉️',
    this.isFeatured = true,
    this.is4k = true,
    this.downloadsCount = 108,
    this.category = 'General',
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'deity': deity,
    'imageUrl': imageUrl,
    'thumbnail': thumbnail,
    'mantraSanskrit': mantraSanskrit,
    'quoteEnglish': quoteEnglish,
    'gradientColors': gradientColors,
    'iconBadge': iconBadge,
    'isFeatured': isFeatured,
    'is4k': is4k,
    'downloadsCount': downloadsCount,
    'category': category,
  };

  factory AdminWallpaperItem.fromJson(Map<String, dynamic> json) {
    List<String> colors = ['#1E1B4B', '#312E81', '#6366F1'];
    if (json['gradientColors'] is List) {
      colors = (json['gradientColors'] as List).map((c) => c.toString()).toList();
    }
    return AdminWallpaperItem(
      id: json['id']?.toString() ?? 'wp_${DateTime.now().millisecondsSinceEpoch}',
      title: json['title']?.toString() ?? 'Divine Darshan',
      deity: json['deity']?.toString() ?? 'All Deities',
      imageUrl: json['imageUrl']?.toString() ?? '',
      thumbnail: json['thumbnail']?.toString() ?? json['imageUrl']?.toString() ?? '',
      mantraSanskrit: json['mantraSanskrit']?.toString() ?? '',
      quoteEnglish: json['quoteEnglish']?.toString() ?? '',
      gradientColors: colors,
      iconBadge: json['iconBadge']?.toString() ?? '🕉️',
      isFeatured: json['isFeatured'] == true || json['isFeatured'] == 'true',
      is4k: json['is4k'] != false && json['is4k'] != 'false',
      downloadsCount: int.tryParse(json['downloadsCount']?.toString() ?? '108') ?? 108,
      category: json['category']?.toString() ?? 'General',
    );
  }
}
