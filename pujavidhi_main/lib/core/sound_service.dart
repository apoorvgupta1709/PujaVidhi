import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

class SoundService {
  static AudioPlayer? _fxPlayer;

  static AudioPlayer? _getPlayer() {
    try {
      _fxPlayer ??= AudioPlayer();
      return _fxPlayer;
    } catch (_) {
      return null;
    }
  }

  static Future<void> playTempleBell() async {
    try {
      HapticFeedback.mediumImpact();
      final player = _getPlayer();
      if (player != null) {
        await player.stop();
        await player.play(AssetSource('audio/temple_bell.wav'));
      }
    } catch (_) {
      HapticFeedback.mediumImpact();
    }
  }

  static Future<void> playShankh() async {
    try {
      HapticFeedback.heavyImpact();
      final player = _getPlayer();
      if (player != null) {
        await player.stop();
        await player.play(AssetSource('audio/shankh_sound.wav'));
      }
    } catch (_) {
      HapticFeedback.heavyImpact();
    }
  }

  static Future<void> playJapaClick() async {
    try {
      HapticFeedback.selectionClick();
      final player = _getPlayer();
      if (player != null) {
        await player.stop();
        await player.play(AssetSource('audio/japa_click.wav'));
      }
    } catch (_) {
      HapticFeedback.selectionClick();
    }
  }

  static Future<void> triggerRoundCompleteHaptic() async {
    try {
      HapticFeedback.vibrate();
      await Future.delayed(const Duration(milliseconds: 150));
      HapticFeedback.vibrate();
    } catch (_) {}
  }
}
