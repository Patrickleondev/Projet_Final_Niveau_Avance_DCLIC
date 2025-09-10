import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirebaseAuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  Map<String, dynamic>? _userData;
  bool _isLoading = false;

  User? get user => _user;
  Map<String, dynamic>? get userData => _userData;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  FirebaseAuthService() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  void _onAuthStateChanged(User? user) {
    _user = user;
    if (user != null) {
      _loadUserData();
    } else {
      _userData = null;
    }
    notifyListeners();
  }

  Future<void> _loadUserData() async {
    if (_user == null) return;

    try {
      final doc = await _firestore.collection('doctors').doc(_user!.uid).get();
      if (doc.exists) {
        _userData = doc.data();
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors du chargement des données utilisateur: $e');
      }
    }
  }

  // Inscription d'un nouveau médecin
  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String name,
    required String specialty,
    required String licenseNumber,
    String? phoneNumber,
    String? hospitalName,
    String? address,
  }) async {
    _setLoading(true);
    
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Créer le profil du médecin dans Firestore
      await _firestore.collection('doctors').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'specialty': specialty,
        'licenseNumber': licenseNumber,
        'phoneNumber': phoneNumber,
        'hospitalName': hospitalName,
        'address': address,
        'userType': 'doctor',
        'profileCompleted': true,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return userCredential;
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de l\'inscription: $e');
      }
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Connexion
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la connexion: $e');
      }
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Déconnexion
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Réinitialisation du mot de passe
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Mise à jour du profil
  Future<void> updateProfile({
    String? name,
    String? specialty,
    String? phoneNumber,
    String? hospitalName,
    String? address,
    String? bio,
    String? profileImageUrl,
  }) async {
    if (_user == null) return;

    try {
      final updates = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (name != null) updates['name'] = name;
      if (specialty != null) updates['specialty'] = specialty;
      if (phoneNumber != null) updates['phoneNumber'] = phoneNumber;
      if (hospitalName != null) updates['hospitalName'] = hospitalName;
      if (address != null) updates['address'] = address;
      if (bio != null) updates['bio'] = bio;
      if (profileImageUrl != null) updates['profileImageUrl'] = profileImageUrl;

      await _firestore.collection('doctors').doc(_user!.uid).update(updates);
      await _loadUserData();
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la mise à jour du profil: $e');
      }
      rethrow;
    }
  }

  // Suppression du compte
  Future<void> deleteAccount() async {
    if (_user == null) return;

    try {
      // Supprimer les données Firestore
      await _firestore.collection('doctors').doc(_user!.uid).delete();
      
      // Supprimer le compte Firebase
      await _user!.delete();
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la suppression du compte: $e');
      }
      rethrow;
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Getters utiles
  String? get userId => _user?.uid;
  String? get userName => _userData?['name'] ?? _user?.displayName;
  String? get userEmail => _user?.email;
  String? get userSpecialty => _userData?['specialty'];
  String? get userLicenseNumber => _userData?['licenseNumber'];
  String? get userHospitalName => _userData?['hospitalName'];
  bool get isProfileCompleted => _userData?['profileCompleted'] ?? false;
}
