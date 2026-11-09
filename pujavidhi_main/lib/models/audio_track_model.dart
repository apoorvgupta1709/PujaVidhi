class LyricLine {
  final int timestampSec;
  final String devanagari;
  final String english;

  const LyricLine({
    required this.timestampSec,
    required this.devanagari,
    required this.english,
  });
}

class AudioTrack {
  final String id;
  final String title;
  final String deity;
  final String category; // Aarti, Chalisa, Mantra, Stotra
  final int durationSec;
  final String localAssetPath;
  final String remoteStreamUrl;
  final List<LyricLine> lyrics;
  bool isDownloaded;

  AudioTrack({
    required this.id,
    required this.title,
    required this.deity,
    required this.category,
    required this.durationSec,
    required this.localAssetPath,
    required this.remoteStreamUrl,
    required this.lyrics,
    this.isDownloaded = false,
  });
}
