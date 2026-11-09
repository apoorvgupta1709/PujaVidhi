import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class AppProvider with ChangeNotifier {
  bool _isProUser = false;
  String _familyName = "Sharma Parivar";
  bool _isDarkMode = false;
  int _activePassPrice = 99;

  bool get isProUser => _isProUser;
  String get familyName => _familyName;
  bool get isDarkMode => _isDarkMode;
  int get activePassPrice => _activePassPrice;

  AppProvider() {
    _loadState();
  }

  void _loadState() {
    _isProUser = StorageService.getIsPro();
    _familyName = StorageService.getFamilyName();
    _isDarkMode = StorageService.isDarkMode();
    notifyListeners();
  }

  Future<void> activateBhaktPrimePass() async {
    _isProUser = true;
    await StorageService.setIsPro(true);
    notifyListeners();
  }

  Future<void> setFamilyName(String name) async {
    _familyName = name;
    await StorageService.setFamilyName(name);
    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    await StorageService.setDarkMode(_isDarkMode);
    notifyListeners();
  }

  void setPassPrice(int price) {
    _activePassPrice = price;
    notifyListeners();
  }
}
