import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';

class ProfileImageService extends ChangeNotifier {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();

  bool _isUploading = false;
  String? _currentProfileImageUrl;

  bool get isUploading => _isUploading;
  String? get currentProfileImageUrl => _currentProfileImageUrl;

  // Charger l'URL de l'image de profil actuelle
  Future<void> loadCurrentProfileImage() async {
    if (_auth.currentUser == null) return;

    try {
      final doc = await _firestore
          .collection('doctors')
          .doc(_auth.currentUser!.uid)
          .get();

      if (doc.exists) {
        _currentProfileImageUrl = doc.data()?['photoURL'];
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors du chargement de l\'image de profil: $e');
      }
    }
  }

  // Sélectionner une image depuis la galerie
  Future<File?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        return File(image.path);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la sélection d\'image: $e');
      }
    }
    return null;
  }

  // Prendre une photo avec l'appareil photo
  Future<File?> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        return File(image.path);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la prise de photo: $e');
      }
    }
    return null;
  }

  // Uploader l'image de profil vers Firebase Storage
  Future<String?> uploadProfileImage(File imageFile) async {
    if (_auth.currentUser == null) return null;

    _setUploading(true);

    try {
      // Créer une référence unique pour l'image
      final ref = _storage
          .ref()
          .child('doctor_profile_images')
          .child('${_auth.currentUser!.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg');

      // Uploader le fichier
      final uploadTask = await ref.putFile(imageFile);
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      // Mettre à jour l'URL dans Firestore
      await _firestore
          .collection('doctors')
          .doc(_auth.currentUser!.uid)
          .update({
        'photoURL': downloadUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Mettre à jour l'URL locale
      _currentProfileImageUrl = downloadUrl;
      notifyListeners();

      return downloadUrl;
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de l\'upload de l\'image: $e');
      }
      rethrow;
    } finally {
      _setUploading(false);
    }
  }

  // Supprimer l'image de profil
  Future<void> deleteProfileImage() async {
    if (_auth.currentUser == null || _currentProfileImageUrl == null) return;

    _setUploading(true);

    try {
      // Supprimer l'image de Firebase Storage
      final ref = _storage.refFromURL(_currentProfileImageUrl!);
      await ref.delete();

      // Mettre à jour Firestore
      await _firestore
          .collection('doctors')
          .doc(_auth.currentUser!.uid)
          .update({
        'photoURL': null,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Mettre à jour l'URL locale
      _currentProfileImageUrl = null;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la suppression de l\'image: $e');
      }
      rethrow;
    } finally {
      _setUploading(false);
    }
  }

  // Obtenir l'URL de l'image de profil avec fallback
  String getProfileImageUrl() {
    if (_currentProfileImageUrl != null && _currentProfileImageUrl!.isNotEmpty) {
      return _currentProfileImageUrl!;
    }
    
    // URL par défaut ou initiales
    return '';
  }

  // Vérifier si l'utilisateur a une image de profil
  bool get hasProfileImage => 
      _currentProfileImageUrl != null && _currentProfileImageUrl!.isNotEmpty;

  void _setUploading(bool uploading) {
    _isUploading = uploading;
    notifyListeners();
  }

  // Méthode utilitaire pour obtenir les initiales du nom
  String getInitials(String? name) {
    if (name == null || name.isEmpty) return 'Dr';
    
    final words = name.trim().split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    } else {
      return words[0][0].toUpperCase();
    }
  }
}
