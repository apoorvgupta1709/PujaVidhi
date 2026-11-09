class JapaRecord {
  final String id;
  final DateTime timestamp;
  final int totalBeads;
  final int totalRounds;
  final String mantraName;
  final int durationSeconds;

  const JapaRecord({
    required this.id,
    required this.timestamp,
    required this.totalBeads,
    required this.totalRounds,
    required this.mantraName,
    required this.durationSeconds,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'timestamp': timestamp.toIso8601String(),
    'totalBeads': totalBeads,
    'totalRounds': totalRounds,
    'mantraName': mantraName,
    'durationSeconds': durationSeconds,
  };

  factory JapaRecord.fromJson(Map<String, dynamic> json) => JapaRecord(
    id: json['id'] as String,
    timestamp: DateTime.parse(json['timestamp'] as String),
    totalBeads: json['totalBeads'] as int,
    totalRounds: json['totalRounds'] as int,
    mantraName: json['mantraName'] as String,
    durationSeconds: json['durationSeconds'] as int,
  );
}

class MonetizationConfig {
  final bool adsEnabled;
  final String bannerAdUnitId;
  final String interstitialAdUnitId;
  final String rewardedAdUnitId;
  final int adFrequencyInterval;
  final int primePassPriceINR;
  final String festiveDiscountBanner;

  const MonetizationConfig({
    this.adsEnabled = true,
    this.bannerAdUnitId = "ca-app-pub-3940256099942544/6300978111",
    this.interstitialAdUnitId = "ca-app-pub-3940256099942544/1033173712",
    this.rewardedAdUnitId = "ca-app-pub-3940256099942544/5224354917",
    this.adFrequencyInterval = 2,
    this.primePassPriceINR = 99,
    this.festiveDiscountBanner = "Festive Offer: 33% Off Lifetime Bhakt Prime Pass!",
  });
}
