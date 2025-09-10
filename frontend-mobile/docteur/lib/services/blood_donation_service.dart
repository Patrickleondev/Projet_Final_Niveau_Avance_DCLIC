import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class BloodDonationService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // Créer une demande de don de sang
  Future<void> createBloodRequest({
    required String hospitalId,
    required String hospitalName,
    required String doctorId,
    required String doctorName,
    required String bloodType,
    required int unitsNeeded,
    required String urgency, // 'low', 'medium', 'high', 'critical'
    String? notes,
    String? contactPerson,
    String? contactPhone,
    required GeoPoint location,
    DateTime? expiresAt,
  }) async {
    _setLoading(true);
    
    try {
      final expiresDate = expiresAt ?? DateTime.now().add(const Duration(days: 2));
      
      await _firestore.collection('blood_requests').add({
        'hospitalId': hospitalId,
        'hospitalName': hospitalName,
        'doctorId': doctorId,
        'doctorName': doctorName,
        'bloodType': bloodType,
        'unitsNeeded': unitsNeeded,
        'urgency': urgency,
        'notes': notes ?? '',
        'contactPerson': contactPerson ?? '',
        'contactPhone': contactPhone ?? '',
        'location': location,
        'status': 'active', // 'active', 'fulfilled', 'expired'
        'expiresAt': expiresDate,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la création de la demande: $e');
      }
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Récupérer les demandes de sang d'un hôpital
  Stream<QuerySnapshot> getHospitalBloodRequests(String hospitalId) {
    return _firestore
        .collection('blood_requests')
        .where('hospitalId', isEqualTo: hospitalId)
        .orderBy('urgency', descending: true)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Récupérer les demandes de sang d'un médecin
  Stream<QuerySnapshot> getDoctorBloodRequests(String doctorId) {
    return _firestore
        .collection('blood_requests')
        .where('doctorId', isEqualTo: doctorId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Récupérer toutes les demandes actives
  Stream<QuerySnapshot> getActiveBloodRequests() {
    return _firestore
        .collection('blood_requests')
        .where('status', isEqualTo: 'active')
        .orderBy('urgency', descending: true)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Mettre à jour une demande de sang
  Future<void> updateBloodRequest({
    required String requestId,
    String? bloodType,
    int? unitsNeeded,
    String? urgency,
    String? notes,
    String? contactPerson,
    String? contactPhone,
    DateTime? expiresAt,
    String? status,
  }) async {
    try {
      final updates = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (bloodType != null) updates['bloodType'] = bloodType;
      if (unitsNeeded != null) updates['unitsNeeded'] = unitsNeeded;
      if (urgency != null) updates['urgency'] = urgency;
      if (notes != null) updates['notes'] = notes;
      if (contactPerson != null) updates['contactPerson'] = contactPerson;
      if (contactPhone != null) updates['contactPhone'] = contactPhone;
      if (expiresAt != null) updates['expiresAt'] = expiresAt;
      if (status != null) updates['status'] = status;

      await _firestore.collection('blood_requests').doc(requestId).update(updates);
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la mise à jour de la demande: $e');
      }
      rethrow;
    }
  }

  // Annuler une demande de sang
  Future<void> cancelBloodRequest(String requestId) async {
    try {
      await _firestore.collection('blood_requests').doc(requestId).update({
        'status': 'cancelled',
        'cancelledAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de l\'annulation de la demande: $e');
      }
      rethrow;
    }
  }

  // Marquer une demande comme satisfaite
  Future<void> fulfillBloodRequest(String requestId) async {
    try {
      await _firestore.collection('blood_requests').doc(requestId).update({
        'status': 'fulfilled',
        'fulfilledAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la satisfaction de la demande: $e');
      }
      rethrow;
    }
  }

  // Récupérer les dons de sang reçus
  Stream<QuerySnapshot> getReceivedBloodDonations(String hospitalId) {
    return _firestore
        .collection('blood_donations')
        .where('hospitalId', isEqualTo: hospitalId)
        .where('status', isEqualTo: 'completed')
        .orderBy('donationDate', descending: true)
        .snapshots();
  }

  // Récupérer les statistiques des dons de sang
  Future<Map<String, dynamic>> getBloodDonationStatistics(String hospitalId) async {
    try {
      final requestsSnapshot = await _firestore
          .collection('blood_requests')
          .where('hospitalId', isEqualTo: hospitalId)
          .get();

      final donationsSnapshot = await _firestore
          .collection('blood_donations')
          .where('hospitalId', isEqualTo: hospitalId)
          .where('status', isEqualTo: 'completed')
          .get();

      int totalRequests = 0;
      int activeRequests = 0;
      int fulfilledRequests = 0;
      int totalUnitsRequested = 0;
      int totalUnitsDonated = 0;

      for (final doc in requestsSnapshot.docs) {
        final request = doc.data();
        totalRequests++;
        totalUnitsRequested += (request['unitsNeeded'] as num? ?? 0).toInt();
        
        if (request['status'] == 'active') {
          activeRequests++;
        } else if (request['status'] == 'fulfilled') {
          fulfilledRequests++;
        }
      }

      for (final doc in donationsSnapshot.docs) {
        final donation = doc.data();
        totalUnitsDonated += (donation['unitsDonated'] as num? ?? 0).toInt();
      }

      return {
        'totalRequests': totalRequests,
        'activeRequests': activeRequests,
        'fulfilledRequests': fulfilledRequests,
        'totalUnitsRequested': totalUnitsRequested,
        'totalUnitsDonated': totalUnitsDonated,
        'fulfillmentRate': totalRequests > 0 ? (fulfilledRequests / totalRequests * 100).round() : 0,
      };
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la récupération des statistiques: $e');
      }
      return {};
    }
  }

  // Récupérer l'historique des demandes d'un hôpital
  Stream<QuerySnapshot> getHospitalBloodRequestHistory(String hospitalId) {
    return _firestore
        .collection('blood_requests')
        .where('hospitalId', isEqualTo: hospitalId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Récupérer les demandes par type de sang
  Stream<QuerySnapshot> getBloodRequestsByType(String bloodType) {
    return _firestore
        .collection('blood_requests')
        .where('bloodType', isEqualTo: bloodType)
        .where('status', isEqualTo: 'active')
        .orderBy('urgency', descending: true)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Récupérer les demandes par urgence
  Stream<QuerySnapshot> getBloodRequestsByUrgency(String urgency) {
    return _firestore
        .collection('blood_requests')
        .where('urgency', isEqualTo: urgency)
        .where('status', isEqualTo: 'active')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Rechercher dans les demandes de sang
  Stream<QuerySnapshot> searchBloodRequests({
    String? hospitalId,
    String? bloodType,
    String? urgency,
    String? status,
  }) {
    Query query = _firestore.collection('blood_requests');

    if (hospitalId != null) {
      query = query.where('hospitalId', isEqualTo: hospitalId);
    }
    if (bloodType != null) {
      query = query.where('bloodType', isEqualTo: bloodType);
    }
    if (urgency != null) {
      query = query.where('urgency', isEqualTo: urgency);
    }
    if (status != null) {
      query = query.where('status', isEqualTo: status);
    }

    return query.orderBy('createdAt', descending: true).snapshots();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Obtenir les statistiques des dons
  Future<Map<String, dynamic>> getDonationStatistics() async {
    try {
      final requestsSnapshot = await _firestore.collection('blood_requests').get();
      final donationsSnapshot = await _firestore.collection('blood_donations').get();
      
      int totalRequests = requestsSnapshot.docs.length;
      int fulfilledRequests = requestsSnapshot.docs.where((doc) => doc.data()['status'] == 'fulfilled').length;
      int totalDonations = donationsSnapshot.docs.length;
      
      return {
        'totalRequests': totalRequests,
        'fulfilledRequests': fulfilledRequests,
        'totalDonations': totalDonations,
        'fulfillmentRate': totalRequests > 0 ? (fulfilledRequests / totalRequests * 100).round() : 0,
      };
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la récupération des statistiques: $e');
      }
      return {
        'totalRequests': 0,
        'fulfilledRequests': 0,
        'totalDonations': 0,
        'fulfillmentRate': 0,
      };
    }
  }
}
