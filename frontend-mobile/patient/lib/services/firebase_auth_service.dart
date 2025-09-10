import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  
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
      final doc = await _firestore
          .collection('users')
          .doc(_user!.uid)
          .get();
      
      if (doc.exists) {
        _userData = doc.data()!;
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors du chargement des données utilisateur: $e');
      }
    }
  }

  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String name,
    required String userType, // 'patient', 'doctor', 'donor'
    String? phoneNumber,
    String? dateOfBirth,
  }) async {
    _setLoading(true);
    
    try {
      // Créer l'utilisateur Firebase Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Créer le document utilisateur dans Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'name': name,
        'userType': userType,
        'phoneNumber': phoneNumber,
        'dateOfBirth': dateOfBirth,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLogin': FieldValue.serverTimestamp(),
        'isActive': true,
        'profileCompleted': false,
      });

      // Mettre à jour le nom d'affichage
      await userCredential.user!.updateDisplayName(name);
      
      return userCredential;
    } catch (e) {
      _setLoading(false);
      rethrow;
    }
  }

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Mettre à jour la dernière connexion
      if (userCredential.user != null) {
        await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .update({
          'lastLogin': FieldValue.serverTimestamp(),
        });
      }

      return userCredential;
    } catch (e) {
      _setLoading(false);
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    _setLoading(true);
    
    try {
      // Déclencher le flux d'authentification Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        _setLoading(false);
        return null; // L'utilisateur a annulé la connexion
      }

      // Obtenir les détails d'authentification de la demande
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Créer un nouvel identifiant
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Une fois connecté, retourner l'UserCredential
      final userCredential = await _auth.signInWithCredential(credential);
      
      // Vérifier si c'est un nouvel utilisateur et créer son profil
      if (userCredential.additionalUserInfo?.isNewUser == true) {
        await _createGoogleUserProfile(userCredential.user!, googleUser);
      } else {
        // Mettre à jour la dernière connexion pour un utilisateur existant
        await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .update({
          'lastLogin': FieldValue.serverTimestamp(),
        });
      }

      return userCredential;
    } catch (e) {
      _setLoading(false);
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _createGoogleUserProfile(User user, GoogleSignInAccount googleUser) async {
    try {
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': user.email,
        'name': user.displayName ?? googleUser.displayName,
        'userType': 'patient', // Par défaut, les utilisateurs Google sont des patients
        'phoneNumber': user.phoneNumber,
        'photoURL': user.photoURL ?? googleUser.photoUrl,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLogin': FieldValue.serverTimestamp(),
        'isActive': true,
        'profileCompleted': false,
        'signInMethod': 'google',
      });
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la création du profil Google: $e');
      }
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la déconnexion: $e');
      }
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateProfile({
    String? name,
    String? phoneNumber,
    String? dateOfBirth,
    String? address,
    String? emergencyContact,
  }) async {
    if (_user == null) return;

    try {
      final updates = <String, dynamic>{};
      
      if (name != null) updates['name'] = name;
      if (phoneNumber != null) updates['phoneNumber'] = phoneNumber;
      if (dateOfBirth != null) updates['dateOfBirth'] = dateOfBirth;
      if (address != null) updates['address'] = address;
      if (emergencyContact != null) updates['emergencyContact'] = emergencyContact;
      
      updates['profileCompleted'] = true;
      updates['updatedAt'] = FieldValue.serverTimestamp();

      await _firestore
          .collection('users')
          .doc(_user!.uid)
          .update(updates);

      // Mettre à jour le nom d'affichage Firebase Auth
      if (name != null) {
        await _user!.updateDisplayName(name);
      }

      // Recharger les données utilisateur
      await _loadUserData();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteAccount() async {
    if (_user == null) return;

    try {
      // Supprimer les données Firestore
      await _firestore
          .collection('users')
          .doc(_user!.uid)
          .delete();

      // Supprimer le compte Firebase Auth
      await _user!.delete();
    } catch (e) {
      rethrow;
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Méthodes utilitaires
  String? get userId => _user?.uid;
  String? get userName => _userData?['name'] ?? _user?.displayName;
  String? get userEmail => _user?.email;
  String? get userPhone => _userData?['phoneNumber'];
  String? get userAddress => _userData?['address'];

  // Mettre à jour le mot de passe
  Future<void> updatePassword(String newPassword) async {
    if (_user == null) {
      throw Exception('Utilisateur non connecté');
    }
    
    try {
      await _user!.updatePassword(newPassword);
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour du mot de passe: $e');
    }
  }

  // Mettre à jour l'email
  Future<void> updateEmail(String newEmail) async {
    if (_user == null) {
      throw Exception('Utilisateur non connecté');
    }

    try {
      // Note: updateEmail nécessite une réauthentification récente
      // Pour l'instant, on met à jour seulement dans Firestore
      await _firestore
          .collection('users')
          .doc(_user!.uid)
          .update({
        'email': newEmail,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      // Recharger les données utilisateur
      await _loadUserData();
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour de l\'email: $e');
    }
  }

  // Envoyer un email de réinitialisation de mot de passe
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Erreur lors de l\'envoi de l\'email de réinitialisation: $e');
    }
  }
  String? get userType => _userData?['userType'];
  bool get isProfileCompleted => _userData?['profileCompleted'] ?? false;
}
