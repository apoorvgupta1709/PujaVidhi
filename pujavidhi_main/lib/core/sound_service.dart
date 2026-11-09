import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

class SoundService {
  static final AudioPlayer _fxPlayer = AudioPlayer();

  static Future<void> playTempleBell() async {
    try {
      HapticFeedback.mediumImpact();
      await _fxPlayer.stop();
      await _fxPlayer.play(AssetSource('audio/temple_bell.wav'));
    } catch (_) {
      HapticFeedback.mediumImpact();
    }
  }

  static Future<void> playShankh() async {
    try {
      HapticFeedback.heavyImpact();
      await _fxPlayer.stop();
      await _fxPlayer.play(AssetSource('audio/shankh_sound.wav'));
    } catch (_) {
      HapticFeedback.heavyImpact();
    }
  }

  static Future<void> playJapaClick() async {
    try {
      HapticFeedback.selectionClick();
      await _fxPlayer.stop();
      await _fxPlayer.play(AssetSource('audio/japa_click.wav'));
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
