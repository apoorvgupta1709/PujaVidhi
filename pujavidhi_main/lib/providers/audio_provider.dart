import 'package:flutter/material.dart';
import '../models/audio_track_model.dart';
import '../services/audio_service.dart';
import '../services/storage_service.dart';
import '../services/admob_service.dart';

class AudioProvider with ChangeNotifier {
  final AudioService _audioService = AudioService();
  final List<AudioTrack> _tracks = [];
  AudioTrack? _activeTrack;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  int _activeLyricIndex = 0;

  List<AudioTrack> get tracks => _tracks;
  AudioTrack? get activeTrack => _activeTrack;
  bool get isPlaying => _isPlaying;
  bool get isLooping => _audioService.isLooping;
  Duration get position => _position;
  Duration get duration => _duration;
  int get activeLyricIndex => _activeLyricIndex;

  AudioProvider() {
    _initLibrary();

    _audioService.isPlayingStream.listen((playing) {
      _isPlaying = playing;
      notifyListeners();
    });

    _audioService.positionStream.listen((pos) {
      _position = pos;
      _updateLyricIndex(pos);
      notifyListeners();
    });

    _audioService.durationStream.listen((dur) {
      _duration = dur;
      notifyListeners();
    });

    _audioService.trackStream.listen((track) {
      _activeTrack = track;
      notifyListeners();
    });
  }

  void _initLibrary() {
    final downloaded = StorageService.getDownloadedTrackIds();

    _tracks.addAll([
      AudioTrack(
        id: "aarti_ganesh",
        title: "Jai Ganesh Deva",
        deity: "Lord Ganesha",
        category: "Aarti",
        durationSec: 185,
        localAssetPath: "audio/temple_bell.wav",
        remoteStreamUrl: "https://actions.google.com/sounds/v1/spiritual/temple_bell.ogg",
        isDownloaded: downloaded.contains("aarti_ganesh"),
        lyrics: const [
          LyricLine(timestampSec: 0, devanagari: "जय गणेश जय गणेश जय गणेश देवा ।", english: "Jai Ganesh Jai Ganesh Jai Ganesh Deva ।"),
          LyricLine(timestampSec: 15, devanagari: "माता जाकी पार्वती पिता महादेवा ॥", english: "Mata Jaaki Parvati Pita Mahadeva ॥"),
          LyricLine(timestampSec: 30, devanagari: "एक दंत दयावंत चार भुजाधारी ।", english: "Ek Dant Dayavant Chaar Bhujaadhari ।"),
          LyricLine(timestampSec: 45, devanagari: "माथे पर तिलक सोहे मूसे की सवारी ॥", english: "Maathe Par Tilak Sohe Moose Ki Sawari ॥"),
          LyricLine(timestampSec: 60, devanagari: "पान चढ़े फूल चढ़े और चढ़े मेवा ।", english: "Paan Chadhe Phool Chadhe Aur Chadhe Mewa ।"),
          LyricLine(timestampSec: 75, devanagari: "लड्डुअन का भोग लगे संत करें सेवा ॥", english: "Ladduan Ka Bhog Lage Sant Karein Seva ॥"),
          LyricLine(timestampSec: 90, devanagari: "दीनन की लाज राखो शंभु सुत वारी ।", english: "Deenan Ki Laaj Rakho Shambhu Sut Vaari ।"),
          LyricLine(timestampSec: 110, devanagari: "कामना को पूर्ण करो जग बलिहारी ॥", english: "Kaamana Ko Poorna Karo Jag Balihaari ॥"),
        ],
      ),
      AudioTrack(
        id: "chalisa_hanuman",
        title: "Shri Hanuman Chalisa",
        deity: "Lord Hanuman",
        category: "Chalisa",
        durationSec: 540,
        localAssetPath: "audio/temple_bell.wav",
        remoteStreamUrl: "https://actions.google.com/sounds/v1/spiritual/temple_bell.ogg",
        isDownloaded: downloaded.contains("chalisa_hanuman"),
        lyrics: const [
          LyricLine(timestampSec: 0, devanagari: "श्रीगुरु चरन सरोज रज निज मनु मुकुरु सुधारि ।", english: "Shri Guru Charan Saroj Raj Nija Manu Mukuru Sudhari ।"),
          LyricLine(timestampSec: 20, devanagari: "बरनउ रघुबर बिमल जसु जो दायकु फल चारि ॥", english: "Barnau Raghubara Bimal Jasu Jo Dayaku Phal Chaari ॥"),
          LyricLine(timestampSec: 40, devanagari: "बुद्धिहीन तनु जानिके सुमिरौ पवन कुमार ।", english: "Buddhiheen Tanu Jaanike Sumirau Pavan Kumar ।"),
          LyricLine(timestampSec: 60, devanagari: "बल बुधि बिद्या देहु मोहि हरहु कलेस बिकार ॥", english: "Bala Buddhi Vidya Dehu Mohi Harahu Kalesh Bikaar ॥"),
          LyricLine(timestampSec: 80, devanagari: "जय हनुमान ज्ञान गुन सागर । जय कपीस तिहुं लोक उजागर ॥", english: "Jai Hanuman Gyan Gun Sagar । Jai Kapees Tihu Lok Ujaagar ॥"),
          LyricLine(timestampSec: 110, devanagari: "राम दूत अतुलित बल धामा । अंजनि पुत्र पवनसुत नामा ॥", english: "Ram Doot Atulit Bal Dhaama । Anjani Putra Pavansut Naama ॥"),
        ],
      ),
      AudioTrack(
        id: "aarti_jagdish",
        title: "Om Jai Jagdish Hare",
        deity: "Lord Vishnu",
        category: "Aarti",
        durationSec: 320,
        localAssetPath: "audio/temple_bell.wav",
        remoteStreamUrl: "https://actions.google.com/sounds/v1/spiritual/temple_bell.ogg",
        isDownloaded: downloaded.contains("aarti_jagdish"),
        lyrics: const [
          LyricLine(timestampSec: 0, devanagari: "ॐ जय जगदीश हरे, स्वामी जय जगदीश हरे ।", english: "Om Jai Jagdish Hare, Swami Jai Jagdish Hare ।"),
          LyricLine(timestampSec: 25, devanagari: "भक्त जनों के संकट, दास जनों के संकट, क्षण में दूर करे ॥", english: "Bhakt Janon Ke Sankat, Daas Janon Ke Sankat, Kshan Mein Door Kare ॥"),
          LyricLine(timestampSec: 50, devanagari: "जो ध्यावे फल पावे, दुःख बिनसे मन का ।", english: "Jo Dhyave Phal Pave, Dukh Binse Man Ka ।"),
          LyricLine(timestampSec: 75, devanagari: "सुख सम्पत्ति घर आवे, कष्ट मिटे तन का ॥", english: "Sukh Sampatti Ghar Aave, Kasht Mite Tan Ka ॥"),
        ],
      ),
      AudioTrack(
        id: "aarti_shiv",
        title: "Om Jai Shiv Omkara",
        deity: "Lord Shiva",
        category: "Aarti",
        durationSec: 290,
        localAssetPath: "audio/shankh_sound.wav",
        remoteStreamUrl: "https://actions.google.com/sounds/v1/spiritual/temple_bell.ogg",
        isDownloaded: downloaded.contains("aarti_shiv"),
        lyrics: const [
          LyricLine(timestampSec: 0, devanagari: "ॐ जय शिव ओंकारा, स्वामी हर शिव ओंकारा ।", english: "Om Jai Shiv Omkara, Swami Har Shiv Omkara ।"),
          LyricLine(timestampSec: 22, devanagari: "ब्रह्मा विष्णु सदाशिव अर्द्धांगी धारा ॥", english: "Brahma Vishnu Sadashiv Ardhangi Dhaara ॥"),
          LyricLine(timestampSec: 45, devanagari: "एकानन चतुरानन पंचानन राजे ।", english: "Ekanan Chaturanana Panchanan Raje ।"),
          LyricLine(timestampSec: 68, devanagari: "हंसासन गरुड़ासन वृषवाहन साजे ॥", english: "Hansasana Garudasana Vrishavahana Saje ॥"),
        ],
      ),
      AudioTrack(
        id: "aarti_durga",
        title: "Jai Ambe Gauri",
        deity: "Maa Durga",
        category: "Aarti",
        durationSec: 310,
        localAssetPath: "audio/temple_bell.wav",
        remoteStreamUrl: "https://actions.google.com/sounds/v1/spiritual/temple_bell.ogg",
        isDownloaded: downloaded.contains("aarti_durga"),
        lyrics: const [
          LyricLine(timestampSec: 0, devanagari: "जय अम्बे गौरी, मैया जय श्यामा गौरी ।", english: "Jai Ambe Gauri, Maiya Jai Shyama Gauri ।"),
          LyricLine(timestampSec: 25, devanagari: "तुमको निसदिन ध्यावत, हरि ब्रह्मा शिवरी ॥", english: "Tumko Nisdin Dhyavat, Hari Brahma Shivri ॥"),
          LyricLine(timestampSec: 50, devanagari: "मांग सिन्दूर विराजत, टीको मृगमद को ।", english: "Maang Sindoor Virajat, Teeko Mrigmad Ko ।"),
          LyricLine(timestampSec: 75, devanagari: "उज्ज्वल से दोउ नैना, चन्द्रबदन नीको ॥", english: "Ujjwal Se Dou Naina, Chandra Badan Neeko ॥"),
        ],
      ),
    ]);
  }

  void _updateLyricIndex(Duration pos) {
    if (_activeTrack == null || _activeTrack!.lyrics.isEmpty) return;
    final sec = pos.inSeconds;
    int idx = 0;
    for (int i = 0; i < _activeTrack!.lyrics.length; i++) {
      if (sec >= _activeTrack!.lyrics[i].timestampSec) {
        idx = i;
      }
    }
    if (idx != _activeLyricIndex) {
      _activeLyricIndex = idx;
      notifyListeners();
    }
  }

  void playTrack(AudioTrack track) {
    _activeTrack = track;
    _activeLyricIndex = 0;
    _audioService.playTrack(track);
    notifyListeners();
  }

  void togglePlayPause() {
    if (_isPlaying) {
      _audioService.pause();
    } else {
      if (_activeTrack != null) {
        _audioService.resume();
      } else if (_tracks.isNotEmpty) {
        playTrack(_tracks.first);
      }
    }
  }

  void seek(Duration pos) {
    _audioService.seek(pos);
  }

  void toggleLoop() {
    _audioService.toggleLoop();
    notifyListeners();
  }

  void playBell() {
    _audioService.playBellOverlay();
  }

  void playShankh() {
    _audioService.playShankhOverlay();
  }

  // Rewarded Ad integration for offline audio download (Free users watch ad, Prime is instant)
  void downloadTrackOffline({
    required AudioTrack track,
    required bool isProUser,
    required BuildContext context,
  }) {
    AdMobService.showRewardedAd(
      isProUser: isProUser,
      onUserEarnedReward: () {
        track.isDownloaded = true;
        StorageService.markTrackDownloaded(track.id);
        notifyListeners();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("✨ '${track.title}' downloaded for offline devotion!"),
            backgroundColor: const Color(0xFF7E191B),
          ),
        );
      },
      onDismissedWithoutReward: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Watch the complete message to download offline audio.")),
        );
      },
    );
  }
}
