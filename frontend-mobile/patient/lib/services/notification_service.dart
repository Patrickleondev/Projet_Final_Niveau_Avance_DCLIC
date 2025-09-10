import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class NotificationService extends ChangeNotifier {
  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get notifications => _notifications;
  bool get isLoading => _isLoading;

  // Charger les notifications depuis le stockage local
  Future<void> loadNotifications() async {
    _setLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final notificationsJson = prefs.getString('notifications') ?? '[]';
      final List<dynamic> notificationsList = json.decode(notificationsJson);
      
      // Si aucune notification sauvegardée, créer des notifications par défaut
      if (notificationsList.isEmpty) {
        _notifications = [
          {
            'id': '1',
            'title': 'Rappel de médicament',
            'message': 'Il est temps de prendre votre Paracétamol',
            'type': 'medication',
            'isRead': false,
            'timestamp': DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
            'priority': 'high',
          },
          {
            'id': '2',
            'title': 'Rendez-vous confirmé',
            'message': 'Votre rendez-vous avec Dr. Martin est confirmé pour demain à 14h',
            'type': 'appointment',
            'isRead': false,
            'timestamp': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
            'priority': 'medium',
          },
          {
            'id': '3',
            'title': 'Résultats d\'analyse disponibles',
            'message': 'Vos résultats de prise de sang sont maintenant disponibles',
            'type': 'medical',
            'isRead': true,
            'timestamp': DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
            'priority': 'medium',
          },
        ];
        await _saveNotifications();
      } else {
        _notifications = notificationsList.cast<Map<String, dynamic>>();
      }
    } catch (e) {
      print('Erreur chargement notifications: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Sauvegarder les notifications
  Future<void> _saveNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('notifications', json.encode(_notifications));
    } catch (e) {
      print('Erreur sauvegarde notifications: $e');
    }
  }

  // Marquer une notification comme lue
  Future<void> markAsRead(String notificationId) async {
    final index = _notifications.indexWhere((n) => n['id'] == notificationId);
    if (index != -1) {
      _notifications[index]['isRead'] = true;
      await _saveNotifications();
      notifyListeners();
    }
  }

  // Marquer toutes les notifications comme lues
  Future<void> markAllAsRead() async {
    for (var notification in _notifications) {
      notification['isRead'] = true;
    }
    await _saveNotifications();
    notifyListeners();
  }

  // Supprimer une notification
  Future<void> deleteNotification(String notificationId) async {
    _notifications.removeWhere((n) => n['id'] == notificationId);
    await _saveNotifications();
    notifyListeners();
  }

  // Ajouter une nouvelle notification
  Future<void> addNotification({
    required String title,
    required String message,
    required String type,
    String priority = 'medium',
  }) async {
    final notification = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'title': title,
      'message': message,
      'type': type,
      'isRead': false,
      'timestamp': DateTime.now().toIso8601String(),
      'priority': priority,
    };

    _notifications.insert(0, notification);
    await _saveNotifications();
    notifyListeners();
  }

  // Obtenir le nombre de notifications non lues
  int get unreadCount {
    return _notifications.where((n) => !n['isRead']).length;
  }

  // Obtenir les notifications par type
  List<Map<String, dynamic>> getNotificationsByType(String type) {
    return _notifications.where((n) => n['type'] == type).toList();
  }

  // Obtenir les notifications non lues
  List<Map<String, dynamic>> get unreadNotifications {
    return _notifications.where((n) => !n['isRead']).toList();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Simuler l'envoi de notifications périodiques
  Future<void> scheduleMedicationReminder(String medicationName, String time) async {
    await addNotification(
      title: 'Rappel de médicament',
      message: 'Il est temps de prendre votre $medicationName',
      type: 'medication',
      priority: 'high',
    );
  }

  // Simuler une notification de rendez-vous
  Future<void> scheduleAppointmentReminder(String doctorName, DateTime appointmentTime) async {
    await addNotification(
      title: 'Rappel de rendez-vous',
      message: 'Vous avez un rendez-vous avec $doctorName dans 1 heure',
      type: 'appointment',
      priority: 'high',
    );
  }
}