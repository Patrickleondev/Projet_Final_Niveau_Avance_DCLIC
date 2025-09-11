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
    required String bloodType,
    required int unitsNeeded,
    required String urgency, // 'low', 'medium', 'high', 'critical'
    String? notes,
    String? contactPerson,
    String? contactPhone,
    required GeoPoint location,
  }) async {
    _setLoading(true);
    
    try {
      await _firestore.collection('blood_requests').add({
        'hospitalId': hospitalId,
        'hospitalName': hospitalName,
        'bloodType': bloodType,
        'unitsNeeded': unitsNeeded,
        'urgency': urgency,
        'notes': notes,
        'contactPerson': contactPerson,
        'contactPhone': contactPhone,
        'location': location,
        'status': 'active', // 'active', 'fulfilled', 'expired'
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'expiresAt': FieldValue.serverTimestamp(), // Expire dans 48h
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

  // Récupérer toutes les demandes actives
  Stream<QuerySnapshot> getActiveBloodRequests() {
    return _firestore
        .collection('blood_requests')
        .where('status', isEqualTo: 'active')
        .orderBy('urgency', descending: true)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Récupérer les demandes par type de sang
  Stream<QuerySnapshot> getBloodRequestsByType(String bloodType) {
    return _firestore
        .collection('blood_requests')
        .where('status', isEqualTo: 'active')
        .where('bloodType', isEqualTo: bloodType)
        .orderBy('urgency', descending: true)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Récupérer les demandes par localisation (dans un rayon donné)
  Stream<QuerySnapshot> getBloodRequestsByLocation(
    GeoPoint userLocation,
    double radiusInKm,
  ) {
    // Note: Firestore ne supporte pas nativement les requêtes géospatiales
    // Cette implémentation est simplifiée - en production, utilisez Algolia ou similaire
    return _firestore
        .collection('blood_requests')
        .where('status', isEqualTo: 'active')
        .orderBy('urgency', descending: true)
        .snapshots();
  }

  // Enregistrer un don de sang
  Future<void> registerBloodDonation({
    required String donorId,
    required String donorName,
    required String bloodType,
    required String hospitalId,
    required String hospitalName,
    required DateTime donationDate,
    required int unitsDonated,
    String? notes,
  }) async {
    _setLoading(true);
    
    try {
      // Créer l'enregistrement du don
      await _firestore.collection('blood_donations').add({
        'donorId': donorId,
        'donorName': donorName,
        'bloodType': bloodType,
        'hospitalId': hospitalId,
        'hospitalName': hospitalName,
        'donationDate': donationDate,
        'unitsDonated': unitsDonated,
        'notes': notes,
        'status': 'completed', // 'scheduled', 'completed', 'cancelled'
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Mettre à jour le profil du donneur
      await _firestore.collection('users').doc(donorId).update({
        'lastDonationDate': donationDate,
        'totalDonations': FieldValue.increment(1),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Vérifier si des demandes peuvent être satisfaites
      await _checkAndFulfillRequests(bloodType, unitsDonated, hospitalId);
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de l\'enregistrement du don: $e');
      }
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Vérifier et satisfaire les demandes
  Future<void> _checkAndFulfillRequests(
    String bloodType,
    int unitsDonated,
    String hospitalId,
  ) async {
    try {
      final requests = await _firestore
          .collection('blood_requests')
          .where('status', isEqualTo: 'active')
          .where('bloodType', isEqualTo: bloodType)
          .where('hospitalId', isEqualTo: hospitalId)
          .orderBy('urgency', descending: true)
          .get();

      int remainingUnits = unitsDonated;

      for (final doc in requests.docs) {
        if (remainingUnits <= 0) break;

        final request = doc.data();
        final unitsNeeded = (request['unitsNeeded'] as num).toInt();
        final unitsToFulfill = remainingUnits >= unitsNeeded 
            ? unitsNeeded 
            : remainingUnits;

        // Mettre à jour la demande
        await doc.reference.update({
          'unitsNeeded': FieldValue.increment(-unitsToFulfill),
          'updatedAt': FieldValue.serverTimestamp(),
        });

        // Si la demande est complètement satisfaite
        if ((request['unitsNeeded'] as num).toInt() <= unitsToFulfill) {
          await doc.reference.update({
            'status': 'fulfilled',
            'fulfilledAt': FieldValue.serverTimestamp(),
          });
        }

        remainingUnits -= unitsToFulfill;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la vérification des demandes: $e');
      }
    }
  }

  // Récupérer l'historique des dons d'un donneur
  Stream<QuerySnapshot> getDonorHistory(String donorId) {
    return _firestore
        .collection('blood_donations')
        .where('donorId', isEqualTo: donorId)
        .orderBy('donationDate', descending: true)
        .snapshots();
  }

  // Récupérer les statistiques des dons
  Future<Map<String, dynamic>> getDonationStatistics() async {
    try {
      final totalDonations = await _firestore
          .collection('blood_donations')
          .where('status', isEqualTo: 'completed')
          .get();

      final activeRequests = await _firestore
          .collection('blood_requests')
          .where('status', isEqualTo: 'active')
          .get();

      int totalUnitsDonated = 0;
      for (final doc in totalDonations.docs) {
        totalUnitsDonated += (doc.data()['unitsDonated'] as num? ?? 0).toInt();
      }

      int totalUnitsNeeded = 0;
      for (final doc in activeRequests.docs) {
        totalUnitsNeeded += (doc.data()['unitsNeeded'] as num? ?? 0).toInt();
      }

      return {
        'totalDonations': totalDonations.docs.length,
        'totalUnitsDonated': totalUnitsDonated,
        'activeRequests': activeRequests.docs.length,
        'totalUnitsNeeded': totalUnitsNeeded,
      };
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la récupération des statistiques: $e');
      }
      return {};
    }
  }

  // Planifier un don de sang
  Future<void> scheduleBloodDonation({
    required String donorId,
    required String donorName,
    required String bloodType,
    required String hospitalId,
    required String hospitalName,
    required DateTime scheduledDate,
    String? notes,
  }) async {
    _setLoading(true);
    
    try {
      await _firestore.collection('blood_donations').add({
        'donorId': donorId,
        'donorName': donorName,
        'bloodType': bloodType,
        'hospitalId': hospitalId,
        'hospitalName': hospitalName,
        'scheduledDate': scheduledDate,
        'notes': notes,
        'status': 'scheduled',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la planification du don: $e');
      }
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Annuler un don planifié
  Future<void> cancelScheduledDonation(String donationId) async {
    try {
      await _firestore
          .collection('blood_donations')
          .doc(donationId)
          .update({
        'status': 'cancelled',
        'cancelledAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de l\'annulation du don: $e');
      }
      rethrow;
    }
  }

  // Récupérer les dons planifiés d'un donneur
  Stream<QuerySnapshot> getScheduledDonations(String donorId) {
    return _firestore
        .collection('blood_donations')
        .where('donorId', isEqualTo: donorId)
        .where('status', isEqualTo: 'scheduled')
        .orderBy('scheduledDate')
        .snapshots();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
