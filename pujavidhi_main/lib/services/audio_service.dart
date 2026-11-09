import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import '../models/audio_track_model.dart';
import '../core/sound_service.dart';

class AudioService {
  AudioPlayer? _player;
  AudioTrack? _currentTrack;
  bool _isPlaying = false;
  bool _isLooping = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  final _trackController = StreamController<AudioTrack?>.broadcast();
  final _playingController = StreamController<bool>.broadcast();
  final _positionController = StreamController<Duration>.broadcast();
  final _durationController = StreamController<Duration>.broadcast();

  Stream<AudioTrack?> get trackStream => _trackController.stream;
  Stream<bool> get isPlayingStream => _playingController.stream;
  Stream<Duration> get positionStream => _positionController.stream;
  Stream<Duration> get durationStream => _durationController.stream;

  AudioTrack? get currentTrack => _currentTrack;
  bool get isPlaying => _isPlaying;
  bool get isLooping => _isLooping;
  Duration get position => _position;
  Duration get duration => _duration;

  AudioService() {
    _initAudio();
  }

  void _initAudio() {
    try {
      _player = AudioPlayer();
      _player!.onPlayerStateChanged.listen((state) {
        _isPlaying = state == PlayerState.playing;
        if (!_playingController.isClosed) _playingController.add(_isPlaying);
      });

      _player!.onPositionChanged.listen((pos) {
        _position = pos;
        if (!_positionController.isClosed) _positionController.add(pos);
      });

      _player!.onDurationChanged.listen((dur) {
        _duration = dur;
        if (!_durationController.isClosed) _durationController.add(dur);
      });

      _player!.onPlayerComplete.listen((_) {
        if (_isLooping && _currentTrack != null) {
          playTrack(_currentTrack!);
        } else {
          _isPlaying = false;
          if (!_playingController.isClosed) _playingController.add(false);
        }
      });
    } catch (e) {
      debugPrint("AudioPlayer init notice: $e");
    }
  }

  Future<void> playTrack(AudioTrack track) async {
    try {
      _currentTrack = track;
      if (!_trackController.isClosed) _trackController.add(track);

      if (_player == null) return;
      await _player!.stop();
      // If local asset
      if (track.localAssetPath.isNotEmpty) {
        await _player!.play(AssetSource(track.localAssetPath));
      } else if (track.remoteStreamUrl.isNotEmpty) {
        await _player!.play(UrlSource(track.remoteStreamUrl));
      }
    } catch (e) {
      debugPrint("Audio playback error: $e");
    }
  }

  Future<void> pause() async {
    try {
      await _player?.pause();
    } catch (_) {}
  }

  Future<void> resume() async {
    try {
      await _player?.resume();
    } catch (_) {}
  }

  Future<void> seek(Duration position) async {
    try {
      await _player?.seek(position);
    } catch (_) {}
  }

  void toggleLoop() {
    _isLooping = !_isLooping;
  }

  void playBellOverlay() {
    SoundService.playTempleBell();
  }

  void playShankhOverlay() {
    SoundService.playShankh();
  }

  void dispose() {
    try {
      _player?.dispose();
    } catch (_) {}
    _trackController.close();
    _playingController.close();
    _positionController.close();
    _durationController.close();
  }
}
