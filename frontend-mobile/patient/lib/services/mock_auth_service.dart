import 'package:flutter/material.dart';

class MockAuthService extends ChangeNotifier {
  bool _isLoading = false;
  String? _currentUser;
  String? _userEmail;
  String? _userName;

  bool get isLoading => _isLoading;
  String? get currentUser => _currentUser;
  String? get userEmail => _userEmail;
  String? get userName => _userName;
  bool get isSignedIn => _currentUser != null;

  Future<String?> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    // Simuler un délai de connexion
    await Future.delayed(const Duration(seconds: 2));

    // Simulation d'authentification réussie
    if (email.isNotEmpty && password.isNotEmpty) {
      _currentUser = 'mock_user_${DateTime.now().millisecondsSinceEpoch}';
      _userEmail = email;
      _userName = email.split('@')[0];
      _isLoading = false;
      notifyListeners();
      return null; // Pas d'erreur
    } else {
      _isLoading = false;
      notifyListeners();
      return 'Email et mot de passe requis';
    }
  }

  Future<String?> signUp(String email, String password, {String? name, String? userType}) async {
    _isLoading = true;
    notifyListeners();

    // Simuler un délai d'inscription
    await Future.delayed(const Duration(seconds: 2));

    // Simulation d'inscription réussie
    if (email.isNotEmpty && password.isNotEmpty) {
      _currentUser = 'mock_user_${DateTime.now().millisecondsSinceEpoch}';
      _userEmail = email;
      _userName = name ?? email.split('@')[0];
      _isLoading = false;
      notifyListeners();
      return null; // Pas d'erreur
    } else {
      _isLoading = false;
      notifyListeners();
      return 'Email et mot de passe requis';
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    _currentUser = null;
    _userEmail = null;
    _userName = null;
    _isLoading = false;
    notifyListeners();
  }

  Future<String?> resetPassword(String email) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    _isLoading = false;
    notifyListeners();
    return null; // Pas d'erreur
  }

  Future<String?> signInWithGoogle() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    _currentUser = 'mock_google_user_${DateTime.now().millisecondsSinceEpoch}';
    _userEmail = 'utilisateur@gmail.com';
    _userName = 'Utilisateur Google';
    _isLoading = false;
    notifyListeners();
    return null; // Pas d'erreur
  }
}
