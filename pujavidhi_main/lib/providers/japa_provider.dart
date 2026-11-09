import 'package:flutter/material.dart';
import '../models/japa_model.dart';
import '../services/storage_service.dart';
import '../services/admob_service.dart';
import '../core/sound_service.dart';

class JapaProvider with ChangeNotifier {
  int _currentBead = 0;
  int _completedRounds = 0;
  int _targetRounds = 11;
  String _selectedMantra = "ॐ नमः शिवाय (Om Namah Shivaya)";
  final DateTime _sessionStart = DateTime.now();
  List<JapaRecord> _history = [];

  final List<String> availableMantras = [
    "ॐ नमः शिवाय (Om Namah Shivaya)",
    "हरे कृष्ण हरे कृष्ण कृष्ण कृष्ण हरे हरे (Hare Krishna)",
    "ॐ गं गणपतये नमः (Om Gam Ganapataye Namaha)",
    "गायत्री मन्त्र (Gayatri Mantra)",
    "ॐ नमो भगवते वासुदेवाय (Om Namo Bhagavate)",
    "श्री राम जय राम जय जय राम (Ram Naam Japa)",
    "महामृत्युंजय मन्त्र (Mahamrityunjaya Mantra)",
  ];

  int get currentBead => _currentBead;
  int get completedRounds => _completedRounds;
  int get targetRounds => _targetRounds;
  String get selectedMantra => _selectedMantra;
  List<JapaRecord> get history => _history;

  JapaProvider() {
    _loadHistory();
  }

  void _loadHistory() {
    _history = StorageService.getJapaHistory();
    notifyListeners();
  }

  void setSelectedMantra(String mantra) {
    _selectedMantra = mantra;
    notifyListeners();
  }

  void setTargetRounds(int target) {
    _targetRounds = target;
    notifyListeners();
  }

  void countNextBead({required bool isProUser, required BuildContext context}) {
    SoundService.playJapaClick();
    _currentBead++;

    if (_currentBead >= 108) {
      _currentBead = 0;
      _completedRounds++;
      SoundService.triggerRoundCompleteHaptic();
      SoundService.playTempleBell();

      final record = JapaRecord(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        timestamp: DateTime.now(),
        totalBeads: 108,
        totalRounds: _completedRounds,
        mantraName: _selectedMantra,
        durationSeconds: DateTime.now().difference(_sessionStart).inSeconds,
      );
      StorageService.saveJapaRecord(record);
      _history.insert(0, record);

      // Trigger Interstitial ad check after completing a round
      AdMobService.showInterstitialIfAllowed(
        isProUser: isProUser,
        onDismissed: () {},
      );
    }
    notifyListeners();
  }

  void resetCounter() {
    _currentBead = 0;
    notifyListeners();
  }
}
