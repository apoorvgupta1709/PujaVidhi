class LyricLine {
  final int timestampSec;
  final String devanagari;
  final String english;

  const LyricLine({
    required this.timestampSec,
    required this.devanagari,
    required this.english,
  });

  Map<String, dynamic> toJson() => {
    'timestampSec': timestampSec,
    'devanagari': devanagari,
    'english': english,
  };

  factory LyricLine.fromJson(Map<String, dynamic> json) {
    return LyricLine(
      timestampSec: json['timestampSec'] is int
          ? json['timestampSec']
          : int.tryParse(json['timestampSec']?.toString() ?? '0') ?? 0,
      devanagari: json['devanagari']?.toString() ?? '',
      english: json['english']?.toString() ?? '',
    );
  }
}

class AudioTrack {
  final String id;
  final String title;
  final String hindiTitle;
  final String deity;
  final String category; // Aarti, Chalisa, Mantra, Stotra
  final int durationSec;
  final String localAssetPath;
  final String remoteStreamUrl;
  final String significance;
  final List<LyricLine> lyrics;
  bool isDownloaded;

  AudioTrack({
    required this.id,
    required this.title,
    this.hindiTitle = '',
    required this.deity,
    required this.category,
    required this.durationSec,
    required this.localAssetPath,
    required this.remoteStreamUrl,
    this.significance = '',
    required this.lyrics,
    this.isDownloaded = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'hindiTitle': hindiTitle,
    'deity': deity,
    'category': category,
    'durationSec': durationSec,
    'localAssetPath': localAssetPath,
    'remoteStreamUrl': remoteStreamUrl,
    'significance': significance,
    'lyrics': lyrics.map((l) => l.toJson()).toList(),
    'isDownloaded': isDownloaded,
  };

  factory AudioTrack.fromJson(Map<String, dynamic> json) {
    final rawLyrics = json['lyrics'] as List<dynamic>? ?? [];
    return AudioTrack(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      hindiTitle: json['hindiTitle']?.toString() ?? '',
      deity: json['deity']?.toString() ?? '',
      category: json['category']?.toString() ?? 'Aarti',
      durationSec: json['durationSec'] is int
          ? json['durationSec']
          : int.tryParse(json['durationSec']?.toString() ?? '180') ?? 180,
      localAssetPath: json['localAssetPath']?.toString() ?? 'audio/temple_bell.wav',
      remoteStreamUrl: json['remoteStreamUrl']?.toString() ?? '',
      significance: json['significance']?.toString() ?? '',
      lyrics: rawLyrics.map((l) => LyricLine.fromJson(l as Map<String, dynamic>)).toList(),
      isDownloaded: json['isDownloaded'] == true,
    );
  }
}
