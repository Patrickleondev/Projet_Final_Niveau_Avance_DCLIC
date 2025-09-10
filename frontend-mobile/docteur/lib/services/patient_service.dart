import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class PatientService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // Récupérer la liste des patients d'un médecin
  Stream<QuerySnapshot> getPatients(String doctorId) {
    return _firestore
        .collection('patients')
        .where('assignedDoctors', arrayContains: doctorId)
        .orderBy('lastName')
        .orderBy('firstName')
        .snapshots();
  }

  // Récupérer un patient spécifique
  Future<Map<String, dynamic>?> getPatient(String patientId) async {
    try {
      final doc = await _firestore.collection('patients').doc(patientId).get();
      return doc.exists ? doc.data() : null;
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la récupération du patient: $e');
      }
      return null;
    }
  }

  // Rechercher des patients
  Stream<QuerySnapshot> searchPatients(String doctorId, String searchTerm) {
    if (searchTerm.isEmpty) {
      return getPatients(doctorId);
    }

    return _firestore
        .collection('patients')
        .where('assignedDoctors', arrayContains: doctorId)
        .where('searchTerms', arrayContains: searchTerm.toLowerCase())
        .snapshots();
  }

  // Ajouter un nouveau patient
  Future<void> addPatient({
    required String doctorId,
    required String firstName,
    required String lastName,
    required String dateOfBirth,
    required String gender,
    String? phoneNumber,
    String? email,
    String? address,
    String? emergencyContact,
    String? bloodType,
    String? allergies,
    String? medicalHistory,
  }) async {
    _setLoading(true);
    
    try {
      final searchTerms = [
        firstName.toLowerCase(),
        lastName.toLowerCase(),
        '${firstName.toLowerCase()} ${lastName.toLowerCase()}',
        phoneNumber?.toLowerCase() ?? '',
        email?.toLowerCase() ?? '',
      ].where((term) => term.isNotEmpty).toList();

      await _firestore.collection('patients').add({
        'firstName': firstName,
        'lastName': lastName,
        'dateOfBirth': dateOfBirth,
        'gender': gender,
        'phoneNumber': phoneNumber,
        'email': email,
        'address': address,
        'emergencyContact': emergencyContact,
        'bloodType': bloodType,
        'allergies': allergies ?? [],
        'medicalHistory': medicalHistory ?? '',
        'assignedDoctors': [doctorId],
        'searchTerms': searchTerms,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de l\'ajout du patient: $e');
      }
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Mettre à jour un patient
  Future<void> updatePatient({
    required String patientId,
    String? firstName,
    String? lastName,
    String? dateOfBirth,
    String? gender,
    String? phoneNumber,
    String? email,
    String? address,
    String? emergencyContact,
    String? bloodType,
    List<String>? allergies,
    String? medicalHistory,
  }) async {
    try {
      final updates = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (firstName != null) updates['firstName'] = firstName;
      if (lastName != null) updates['lastName'] = lastName;
      if (dateOfBirth != null) updates['dateOfBirth'] = dateOfBirth;
      if (gender != null) updates['gender'] = gender;
      if (phoneNumber != null) updates['phoneNumber'] = phoneNumber;
      if (email != null) updates['email'] = email;
      if (address != null) updates['address'] = address;
      if (emergencyContact != null) updates['emergencyContact'] = emergencyContact;
      if (bloodType != null) updates['bloodType'] = bloodType;
      if (allergies != null) updates['allergies'] = allergies;
      if (medicalHistory != null) updates['medicalHistory'] = medicalHistory;

      // Mettre à jour les termes de recherche si le nom change
      if (firstName != null || lastName != null) {
        final patient = await getPatient(patientId);
        if (patient != null) {
          final currentFirstName = firstName ?? patient['firstName'];
          final currentLastName = lastName ?? patient['lastName'];
          final searchTerms = [
            currentFirstName.toLowerCase(),
            currentLastName.toLowerCase(),
            '${currentFirstName.toLowerCase()} ${currentLastName.toLowerCase()}',
            patient['phoneNumber']?.toLowerCase() ?? '',
            patient['email']?.toLowerCase() ?? '',
          ].where((term) => term.isNotEmpty).toList();
          
          updates['searchTerms'] = searchTerms;
        }
      }

      await _firestore.collection('patients').doc(patientId).update(updates);
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la mise à jour du patient: $e');
      }
      rethrow;
    }
  }

  // Supprimer un patient
  Future<void> deletePatient(String patientId) async {
    try {
      await _firestore.collection('patients').doc(patientId).delete();
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la suppression du patient: $e');
      }
      rethrow;
    }
  }

  // Assigner un patient à un médecin
  Future<void> assignPatientToDoctor(String patientId, String doctorId) async {
    try {
      await _firestore.collection('patients').doc(patientId).update({
        'assignedDoctors': FieldValue.arrayUnion([doctorId]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de l\'assignation du patient: $e');
      }
      rethrow;
    }
  }

  // Retirer un patient d'un médecin
  Future<void> removePatientFromDoctor(String patientId, String doctorId) async {
    try {
      await _firestore.collection('patients').doc(patientId).update({
        'assignedDoctors': FieldValue.arrayRemove([doctorId]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors du retrait du patient: $e');
      }
      rethrow;
    }
  }

  // Récupérer les statistiques des patients
  Future<Map<String, dynamic>> getPatientStatistics(String doctorId) async {
    try {
      final patientsSnapshot = await _firestore
          .collection('patients')
          .where('assignedDoctors', arrayContains: doctorId)
          .get();

      final totalPatients = patientsSnapshot.docs.length;
      int maleCount = 0;
      int femaleCount = 0;
      int otherCount = 0;

      for (final doc in patientsSnapshot.docs) {
        final gender = doc.data()['gender'];
        switch (gender) {
          case 'male':
            maleCount++;
            break;
          case 'female':
            femaleCount++;
            break;
          default:
            otherCount++;
        }
      }

      return {
        'totalPatients': totalPatients,
        'maleCount': maleCount,
        'femaleCount': femaleCount,
        'otherCount': otherCount,
      };
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la récupération des statistiques: $e');
      }
      return {};
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Récupérer les patients d'un médecin spécifique
  Stream<QuerySnapshot> getDoctorPatients(String doctorId) {
    return _firestore
        .collection('patients')
        .where('assignedDoctors', arrayContains: doctorId)
        .orderBy('lastName')
        .orderBy('firstName')
        .snapshots();
  }
}
