import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import '../models/audio_track_model.dart';
import '../core/sound_service.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();
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
    _player.onPlayerStateChanged.listen((state) {
      _isPlaying = state == PlayerState.playing;
      _playingController.add(_isPlaying);
    });

    _player.onPositionChanged.listen((pos) {
      _position = pos;
      _positionController.add(pos);
    });

    _player.onDurationChanged.listen((dur) {
      _duration = dur;
      _durationController.add(dur);
    });

    _player.onPlayerComplete.listen((_) {
      if (_isLooping && _currentTrack != null) {
        playTrack(_currentTrack!);
      } else {
        _isPlaying = false;
        _playingController.add(false);
      }
    });
  }

  Future<void> playTrack(AudioTrack track) async {
    try {
      _currentTrack = track;
      _trackController.add(track);

      await _player.stop();
      // If local asset
      if (track.localAssetPath.isNotEmpty) {
        await _player.play(AssetSource(track.localAssetPath));
      } else if (track.remoteStreamUrl.isNotEmpty) {
        await _player.play(UrlSource(track.remoteStreamUrl));
      }
    } catch (e) {
      debugPrint("Audio playback error: $e");
    }
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> resume() async {
    await _player.resume();
  }

  Future<void> seek(Duration position) async {
    await _player.seek(position);
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
    _player.dispose();
    _trackController.close();
    _playingController.close();
    _positionController.close();
    _durationController.close();
  }
}
