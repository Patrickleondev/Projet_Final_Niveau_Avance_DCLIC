import 'package:flutter/material.dart';

class MockProfileImageService extends ChangeNotifier {
  String? _profileImageUrl;
  String? _userName;
  String? _userEmail;

  String? get profileImageUrl => _profileImageUrl;
  String? get userName => _userName;
  String? get userEmail => _userEmail;

  void setUserInfo(String? name, String? email) {
    _userName = name;
    _userEmail = email;
    notifyListeners();
  }

  String getInitials() {
    if (_userName != null && _userName!.isNotEmpty) {
      final words = _userName!.split(' ');
      if (words.length >= 2) {
        return '${words[0][0]}${words[1][0]}'.toUpperCase();
      } else {
        return _userName![0].toUpperCase();
      }
    } else if (_userEmail != null && _userEmail!.isNotEmpty) {
      return _userEmail![0].toUpperCase();
    }
    return 'U';
  }

  Future<String?> pickImageFromGallery() async {
    // Simulation d'une sélection d'image
    await Future.delayed(const Duration(seconds: 1));
    _profileImageUrl = 'mock_image_url_${DateTime.now().millisecondsSinceEpoch}';
    notifyListeners();
    return _profileImageUrl;
  }

  Future<String?> pickImageFromCamera() async {
    // Simulation d'une prise de photo
    await Future.delayed(const Duration(seconds: 1));
    _profileImageUrl = 'mock_camera_image_url_${DateTime.now().millisecondsSinceEpoch}';
    notifyListeners();
    return _profileImageUrl;
  }

  Future<void> deleteProfileImage() async {
    _profileImageUrl = null;
    notifyListeners();
  }

  Future<String?> uploadProfileImage(String imagePath) async {
    // Simulation d'un upload
    await Future.delayed(const Duration(seconds: 2));
    _profileImageUrl = 'uploaded_image_url_${DateTime.now().millisecondsSinceEpoch}';
    notifyListeners();
    return _profileImageUrl;
  }
}
