import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AppointmentService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // Récupérer les rendez-vous d'un médecin
  Stream<QuerySnapshot> getDoctorAppointments(String doctorId) {
    return _firestore
        .collection('appointments')
        .where('doctorId', isEqualTo: doctorId)
        .orderBy('date')
        .orderBy('time')
        .snapshots();
  }

  // Récupérer les rendez-vous à venir d'un médecin
  Future<List<Map<String, dynamic>>> getUpcomingAppointments(String doctorId) async {
    final now = DateTime.now();
    final snapshot = await _firestore
        .collection('appointments')
        .where('doctorId', isEqualTo: doctorId)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(now))
        .orderBy('date')
        .orderBy('time')
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        ...data,
      };
    }).toList();
  }

  // Récupérer les rendez-vous passés d'un médecin
  Future<List<Map<String, dynamic>>> getPastAppointments(String doctorId) async {
    final now = DateTime.now();
    final snapshot = await _firestore
        .collection('appointments')
        .where('doctorId', isEqualTo: doctorId)
        .where('date', isLessThan: Timestamp.fromDate(now))
        .orderBy('date', descending: true)
        .orderBy('time', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        ...data,
      };
    }).toList();
  }

  // Récupérer tous les rendez-vous d'un médecin
  Future<List<Map<String, dynamic>>> getAllAppointments(String doctorId) async {
    final snapshot = await _firestore
        .collection('appointments')
        .where('doctorId', isEqualTo: doctorId)
        .orderBy('date', descending: true)
        .orderBy('time', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        ...data,
      };
    }).toList();
  }

  // Récupérer les rendez-vous d'un patient
  Stream<QuerySnapshot> getPatientAppointments(String patientId) {
    return _firestore
        .collection('appointments')
        .where('patientId', isEqualTo: patientId)
        .orderBy('date')
        .orderBy('time')
        .snapshots();
  }

  // Récupérer les rendez-vous pour une date spécifique
  Stream<QuerySnapshot> getAppointmentsByDate(String doctorId, DateTime date) {
    final dateString = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    
    return _firestore
        .collection('appointments')
        .where('doctorId', isEqualTo: doctorId)
        .where('date', isEqualTo: dateString)
        .orderBy('time')
        .snapshots();
  }

  // Créer un nouveau rendez-vous
  Future<void> createAppointment({
    required String doctorId,
    required String patientId,
    required String patientName,
    required DateTime date,
    required String time,
    required String type, // 'consultation', 'suivi', 'urgence'
    String? notes,
    String? duration, // en minutes
    String? status, // 'scheduled', 'confirmed', 'cancelled', 'completed'
  }) async {
    _setLoading(true);
    
    try {
      final dateString = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      
      await _firestore.collection('appointments').add({
        'doctorId': doctorId,
        'patientId': patientId,
        'patientName': patientName,
        'date': dateString,
        'time': time,
        'type': type,
        'notes': notes ?? '',
        'duration': duration ?? '30',
        'status': status ?? 'scheduled',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la création du rendez-vous: $e');
      }
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Mettre à jour un rendez-vous
  Future<void> updateAppointment({
    required String appointmentId,
    String? date,
    String? time,
    String? type,
    String? notes,
    String? duration,
    String? status,
  }) async {
    try {
      final updates = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (date != null) updates['date'] = date;
      if (time != null) updates['time'] = time;
      if (type != null) updates['type'] = type;
      if (notes != null) updates['notes'] = notes;
      if (duration != null) updates['duration'] = duration;
      if (status != null) updates['status'] = status;

      await _firestore.collection('appointments').doc(appointmentId).update(updates);
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la mise à jour du rendez-vous: $e');
      }
      rethrow;
    }
  }

  // Annuler un rendez-vous
  Future<void> cancelAppointment(String appointmentId) async {
    try {
      await _firestore.collection('appointments').doc(appointmentId).update({
        'status': 'cancelled',
        'cancelledAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de l\'annulation du rendez-vous: $e');
      }
      rethrow;
    }
  }

  // Confirmer un rendez-vous
  Future<void> confirmAppointment(String appointmentId) async {
    try {
      await _firestore.collection('appointments').doc(appointmentId).update({
        'status': 'confirmed',
        'confirmedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la confirmation du rendez-vous: $e');
      }
      rethrow;
    }
  }

  // Marquer un rendez-vous comme terminé
  Future<void> completeAppointment(String appointmentId) async {
    try {
      await _firestore.collection('appointments').doc(appointmentId).update({
        'status': 'completed',
        'completedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la finalisation du rendez-vous: $e');
      }
      rethrow;
    }
  }

  // Supprimer un rendez-vous
  Future<void> deleteAppointment(String appointmentId) async {
    try {
      await _firestore.collection('appointments').doc(appointmentId).delete();
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la suppression du rendez-vous: $e');
      }
      rethrow;
    }
  }

  // Vérifier la disponibilité d'un créneau
  Future<bool> isTimeSlotAvailable({
    required String doctorId,
    required String date,
    required String time,
    String? excludeAppointmentId,
  }) async {
    try {
      Query query = _firestore
          .collection('appointments')
          .where('doctorId', isEqualTo: doctorId)
          .where('date', isEqualTo: date)
          .where('time', isEqualTo: time)
          .where('status', whereIn: ['scheduled', 'confirmed']);

      if (excludeAppointmentId != null) {
        query = query.where(FieldPath.documentId, isNotEqualTo: excludeAppointmentId);
      }

      final snapshot = await query.get();
      return snapshot.docs.isEmpty;
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la vérification de disponibilité: $e');
      }
      return false;
    }
  }

  // Récupérer les statistiques des rendez-vous
  Future<Map<String, dynamic>> getAppointmentStatistics(String doctorId) async {
    try {
      final appointmentsSnapshot = await _firestore
          .collection('appointments')
          .where('doctorId', isEqualTo: doctorId)
          .get();

      int totalAppointments = 0;
      int scheduledCount = 0;
      int confirmedCount = 0;
      int completedCount = 0;
      int cancelledCount = 0;

      for (final doc in appointmentsSnapshot.docs) {
        final status = doc.data()['status'];
        totalAppointments++;
        
        switch (status) {
          case 'scheduled':
            scheduledCount++;
            break;
          case 'confirmed':
            confirmedCount++;
            break;
          case 'completed':
            completedCount++;
            break;
          case 'cancelled':
            cancelledCount++;
            break;
        }
      }

      return {
        'totalAppointments': totalAppointments,
        'scheduledCount': scheduledCount,
        'confirmedCount': confirmedCount,
        'completedCount': completedCount,
        'cancelledCount': cancelledCount,
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

  // Mettre à jour le statut d'un rendez-vous
  Future<void> updateAppointmentStatus(String appointmentId, String status) async {
    _setLoading(true);
    
    try {
      await _firestore.collection('appointments').doc(appointmentId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la mise à jour du statut: $e');
      }
      rethrow;
    } finally {
      _setLoading(false);
    }
  }
}
