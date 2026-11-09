import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  DevoteeUser _user = AuthService.currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  DevoteeUser get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool get isAuthenticated => !_user.isAnonymous;
  bool get isGuest => _user.isAnonymous;
  String get displayName => _user.isAnonymous ? "Guest Devotee" : _user.displayName;
  String get email => _user.email;

  AuthProvider() {
    _init();
  }

  Future<void> _init() async {
    _user = await AuthService.init();
    notifyListeners();
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final ok = await AuthService.register(name: name, email: email, password: password);
    _isLoading = false;
    if (ok) {
      _user = AuthService.currentUser;
      notifyListeners();
      return true;
    } else {
      _errorMessage = "Registration failed. Please check details.";
      notifyListeners();
      return false;
    }
  }

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final ok = await AuthService.signIn(email: email, password: password);
    _isLoading = false;
    if (ok) {
      _user = AuthService.currentUser;
      notifyListeners();
      return true;
    } else {
      _errorMessage = "Invalid credentials. Please try again.";
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    await AuthService.signOut();
    _user = AuthService.currentUser;
    notifyListeners();
  }

  Future<void> markPro(bool isPro) async {
    await AuthService.markPro(isPro);
    _user = AuthService.currentUser;
    notifyListeners();
  }
}
