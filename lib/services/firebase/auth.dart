// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get userChanges => _firebaseAuth.userChanges();

  //login with email and password
  Future<User?> loginWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  //logout
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      print(e);
    }
  }

  // Sign in with email and password
  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // Get current user
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }
}

// class FirebaseAuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   // Sign in with email and password
//   Future<User?> signInWithEmailAndPassword(
//     String email,
//     String password,
//   ) async {
//     try {
//       UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       return userCredential.user;
//     } catch (e) {
//       print(e);
//       return null;
//     }
//   }

//   // Sign up with email and password
//   Future<User?> createUserWithEmailAndPassword(
//     String email,
//     String password,
//   ) async {
//     try {
//       UserCredential userCredential = await _auth
//           .createUserWithEmailAndPassword(email: email, password: password);
//       return userCredential.user;
//     } catch (e) {
//       print(e);
//       return null;
//     }
//   }

//   // Sign out
//   Future<void> signOut() async {
//     try {
//       await _auth.signOut();
//     } catch (e) {
//       print(e);
//     }
//   }

//   // Get current user
//   User? getCurrentUser() {
//     return _auth.currentUser;
//   }

//   // Check if user is signed in
//   bool isSignedIn() {
//     return _auth.currentUser != null;
//   }

//   // Send password reset email
//   Future<void> sendPasswordResetEmail(String email) async {
//     try {
//       await _auth.sendPasswordResetEmail(email: email);
//     } catch (e) {
//       print(e);
//     }
//   }

//   // Update user profile
//   Future<void> updateProfile(String displayName, String photoURL) async {
//     User? user = _auth.currentUser;
//     if (user != null) {
//       try {
//         await user.updateProfile(displayName: displayName, photoURL: photoURL);
//         await user.reload();
//       } catch (e) {
//         print(e);
//       }
//     }
//   }

//   // Get user profile
//   Map<String, String?> getUserProfile() {
//     User? user = _auth.currentUser;
//     if (user != null) {
//       return {
//         'displayName': user.displayName,
//         'photoURL': user.photoURL,
//         'email': user.email,
//       };
//     }
//     return {};
//   }

//   // Delete user account
//   Future<void> deleteUser() async {
//     User? user = _auth.currentUser;
//     if (user != null) {
//       try {
//         await user.delete();
//       } catch (e) {
//         print(e);
//       }
//     }
//   }

//   // Update email
//   Future<void> updateEmail(String newEmail) async {
//     User? user = _auth.currentUser;
//     if (user != null) {
//       try {
//         await user.updateEmail(newEmail);
//         await user.reload();
//       } catch (e) {
//         print(e);
//       }
//     }
//   }

//   // Update password
//   Future<void> updatePassword(String newPassword) async {
//     User? user = _auth.currentUser;
//     if (user != null) {
//       try {
//         await user.updatePassword(newPassword);
//       } catch (e) {
//         print(e);
//       }
//     }
//   }

//   // Verify email
//   Future<void> verifyEmail() async {
//     User? user = _auth.currentUser;
//     if (user != null) {
//       try {
//         await user.sendEmailVerification();
//       } catch (e) {
//         print(e);
//       }
//     }
//   }

//   // Check if email is verified
//   bool isEmailVerified() {
//     User? user = _auth.currentUser;
//     if (user != null) {
//       return user.emailVerified;
//     }
//     return false;
//   }

//   // Get user ID
//   String? getUserId() {
//     User? user = _auth.currentUser;
//     if (user != null) {
//       return user.uid;
//     }
//     return null;
//   }

//   // Get user email
//   String? getUserEmail() {
//     User? user = _auth.currentUser;
//     if (user != null) {
//       return user.email;
//     }
//     return null;
//   }

//   // Get user display name
//   String? getUserDisplayName() {
//     User? user = _auth.currentUser;
//     if (user != null) {
//       return user.displayName;
//     }
//     return null;
//   }

//   // Get user photo URL
//   String? getUserPhotoURL() {
//     User? user = _auth.currentUser;
//     if (user != null) {
//       return user.photoURL;
//     }
//     return null;
//   }

//   // Get user phone number
//   String? getUserPhoneNumber() {
//     User? user = _auth.currentUser;
//     if (user != null) {
//       return user.phoneNumber;
//     }
//     return null;
//   }
// }
