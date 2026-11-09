import 'package:flutter/material.dart';
import '../models/audio_track_model.dart';
import '../services/audio_service.dart';
import '../services/storage_service.dart';
import '../services/admob_service.dart';
import '../services/firebase_sync_service.dart';

class AudioProvider with ChangeNotifier {
  final AudioService _audioService = AudioService();
  final List<AudioTrack> _tracks = [];
  AudioTrack? _activeTrack;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  int _activeLyricIndex = 0;
  bool _isLoading = true;

  List<AudioTrack> get tracks => _tracks;
  AudioTrack? get activeTrack => _activeTrack;
  bool get isPlaying => _isPlaying;
  bool get isLooping => _audioService.isLooping;
  Duration get position => _position;
  Duration get duration => _duration;
  int get activeLyricIndex => _activeLyricIndex;
  bool get isLoading => _isLoading;

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

    // Listen to real-time sync events from Firebase/Admin updates
    FirebaseSyncService.aartisStream.listen((syncedTracks) {
      _updateTracksFromList(syncedTracks);
    });
  }

  Future<void> _initLibrary() async {
    _isLoading = true;
    notifyListeners();

    // Fetch from Firebase with offline cache fallback
    final fetched = await FirebaseSyncService.syncAartis();
    _updateTracksFromList(fetched);
    _isLoading = false;
    notifyListeners();
  }

  void _updateTracksFromList(List<AudioTrack> incoming) {
    if (incoming.isEmpty) return;
    final downloaded = StorageService.getDownloadedTrackIds();

    _tracks.clear();
    for (final t in incoming) {
      t.isDownloaded = downloaded.contains(t.id);
      _tracks.add(t);
    }
    notifyListeners();
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
