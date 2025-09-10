import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class MedicalRecordService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // Récupérer les dossiers médicaux d'un patient
  Stream<QuerySnapshot> getPatientMedicalRecords(String patientId) {
    return _firestore
        .collection('medical_records')
        .where('patientId', isEqualTo: patientId)
        .orderBy('date', descending: true)
        .snapshots();
  }

  // Récupérer un dossier médical spécifique
  Future<Map<String, dynamic>?> getMedicalRecord(String recordId) async {
    try {
      final doc = await _firestore.collection('medical_records').doc(recordId).get();
      return doc.exists ? doc.data() : null;
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la récupération du dossier médical: $e');
      }
      return null;
    }
  }

  // Créer un nouveau dossier médical
  Future<void> createMedicalRecord({
    required String patientId,
    required String doctorId,
    required String title,
    required String description,
    required DateTime date,
    required String recordType, // 'consultation', 'examen', 'prescription', 'resultat'
    String? diagnosis,
    String? treatment,
    String? prescription,
    List<String>? symptoms,
    Map<String, dynamic>? vitalSigns,
    String? notes,
    List<String>? attachments, // URLs des fichiers
  }) async {
    _setLoading(true);
    
    try {
      await _firestore.collection('medical_records').add({
        'patientId': patientId,
        'doctorId': doctorId,
        'title': title,
        'description': description,
        'date': date,
        'recordType': recordType,
        'diagnosis': diagnosis ?? '',
        'treatment': treatment ?? '',
        'prescription': prescription ?? '',
        'symptoms': symptoms ?? [],
        'vitalSigns': vitalSigns ?? {},
        'notes': notes ?? '',
        'attachments': attachments ?? [],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la création du dossier médical: $e');
      }
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Mettre à jour un dossier médical
  Future<void> updateMedicalRecord({
    required String recordId,
    String? title,
    String? description,
    String? diagnosis,
    String? treatment,
    String? prescription,
    List<String>? symptoms,
    Map<String, dynamic>? vitalSigns,
    String? notes,
    List<String>? attachments,
  }) async {
    try {
      final updates = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (title != null) updates['title'] = title;
      if (description != null) updates['description'] = description;
      if (diagnosis != null) updates['diagnosis'] = diagnosis;
      if (treatment != null) updates['treatment'] = treatment;
      if (prescription != null) updates['prescription'] = prescription;
      if (symptoms != null) updates['symptoms'] = symptoms;
      if (vitalSigns != null) updates['vitalSigns'] = vitalSigns;
      if (notes != null) updates['notes'] = notes;
      if (attachments != null) updates['attachments'] = attachments;

      await _firestore.collection('medical_records').doc(recordId).update(updates);
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la mise à jour du dossier médical: $e');
      }
      rethrow;
    }
  }

  // Supprimer un dossier médical
  Future<void> deleteMedicalRecord(String recordId) async {
    try {
      await _firestore.collection('medical_records').doc(recordId).delete();
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la suppression du dossier médical: $e');
      }
      rethrow;
    }
  }

  // Récupérer les consultations d'un patient
  Stream<QuerySnapshot> getPatientConsultations(String patientId) {
    return _firestore
        .collection('medical_records')
        .where('patientId', isEqualTo: patientId)
        .where('recordType', isEqualTo: 'consultation')
        .orderBy('date', descending: true)
        .snapshots();
  }

  // Récupérer les prescriptions d'un patient
  Stream<QuerySnapshot> getPatientPrescriptions(String patientId) {
    return _firestore
        .collection('medical_records')
        .where('patientId', isEqualTo: patientId)
        .where('recordType', isEqualTo: 'prescription')
        .orderBy('date', descending: true)
        .snapshots();
  }

  // Récupérer les résultats d'examens d'un patient
  Stream<QuerySnapshot> getPatientTestResults(String patientId) {
    return _firestore
        .collection('medical_records')
        .where('patientId', isEqualTo: patientId)
        .where('recordType', isEqualTo: 'resultat')
        .orderBy('date', descending: true)
        .snapshots();
  }

  // Créer une prescription
  Future<void> createPrescription({
    required String patientId,
    required String doctorId,
    required String medicationName,
    required String dosage,
    required String frequency,
    required DateTime startDate,
    DateTime? endDate,
    String? instructions,
    String? notes,
  }) async {
    _setLoading(true);
    
    try {
      await _firestore.collection('medical_records').add({
        'patientId': patientId,
        'doctorId': doctorId,
        'title': 'Prescription: $medicationName',
        'description': 'Prescription médicale',
        'date': startDate,
        'recordType': 'prescription',
        'medicationName': medicationName,
        'dosage': dosage,
        'frequency': frequency,
        'startDate': startDate,
        'endDate': endDate,
        'instructions': instructions ?? '',
        'notes': notes ?? '',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la création de la prescription: $e');
      }
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Créer un résultat d'examen
  Future<void> createTestResult({
    required String patientId,
    required String doctorId,
    required String testName,
    required String result,
    required DateTime testDate,
    String? laboratory,
    String? normalRange,
    String? interpretation,
    String? recommendations,
    List<String>? attachments,
  }) async {
    _setLoading(true);
    
    try {
      await _firestore.collection('medical_records').add({
        'patientId': patientId,
        'doctorId': doctorId,
        'title': 'Résultat: $testName',
        'description': 'Résultat d\'examen médical',
        'date': testDate,
        'recordType': 'resultat',
        'testName': testName,
        'result': result,
        'testDate': testDate,
        'laboratory': laboratory ?? '',
        'normalRange': normalRange ?? '',
        'interpretation': interpretation ?? '',
        'recommendations': recommendations ?? '',
        'attachments': attachments ?? [],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la création du résultat d\'examen: $e');
      }
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Rechercher dans les dossiers médicaux
  Stream<QuerySnapshot> searchMedicalRecords({
    required String patientId,
    String? searchTerm,
    String? recordType,
  }) {
    Query query = _firestore
        .collection('medical_records')
        .where('patientId', isEqualTo: patientId);

    if (recordType != null) {
      query = query.where('recordType', isEqualTo: recordType);
    }

    if (searchTerm != null && searchTerm.isNotEmpty) {
      // Note: Firestore ne supporte pas la recherche de texte complet
      // Cette implémentation est simplifiée
      query = query.orderBy('title');
    }

    return query.orderBy('date', descending: true).snapshots();
  }

  // Récupérer les statistiques des dossiers médicaux
  Future<Map<String, dynamic>> getMedicalRecordStatistics(String patientId) async {
    try {
      final recordsSnapshot = await _firestore
          .collection('medical_records')
          .where('patientId', isEqualTo: patientId)
          .get();

      int totalRecords = 0;
      int consultationCount = 0;
      int prescriptionCount = 0;
      int testResultCount = 0;
      int otherCount = 0;

      for (final doc in recordsSnapshot.docs) {
        final recordType = doc.data()['recordType'];
        totalRecords++;
        
        switch (recordType) {
          case 'consultation':
            consultationCount++;
            break;
          case 'prescription':
            prescriptionCount++;
            break;
          case 'resultat':
            testResultCount++;
            break;
          default:
            otherCount++;
        }
      }

      return {
        'totalRecords': totalRecords,
        'consultationCount': consultationCount,
        'prescriptionCount': prescriptionCount,
        'testResultCount': testResultCount,
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
}
