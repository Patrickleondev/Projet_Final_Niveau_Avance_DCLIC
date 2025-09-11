import 'package:flutter/material.dart';

class MockNotificationService extends ChangeNotifier {
  List<Map<String, dynamic>> _notifications = [];
  int _unreadCount = 0;

  List<Map<String, dynamic>> get notifications => _notifications;
  int get unreadCount => _unreadCount;

  MockNotificationService() {
    _initializeMockNotifications();
  }

  void _initializeMockNotifications() {
    _notifications = [
      {
        'id': '1',
        'title': 'Rappel de médicament',
        'body': 'Il est temps de prendre votre médicament du matin',
        'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
        'isRead': false,
        'type': 'medication',
      },
      {
        'id': '2',
        'title': 'Rendez-vous confirmé',
        'body': 'Votre rendez-vous avec Dr. Martin est confirmé pour demain à 14h',
        'timestamp': DateTime.now().subtract(const Duration(days: 1)),
        'isRead': true,
        'type': 'appointment',
      },
      {
        'id': '3',
        'title': 'Demande de don de sang',
        'body': 'Urgent: Demande de don de sang de type O+ à l\'hôpital central',
        'timestamp': DateTime.now().subtract(const Duration(days: 2)),
        'isRead': false,
        'type': 'blood_donation',
      },
    ];
    _unreadCount = _notifications.where((n) => !n['isRead']).length;
    notifyListeners();
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    final index = _notifications.indexWhere((n) => n['id'] == notificationId);
    if (index != -1) {
      _notifications[index]['isRead'] = true;
      _unreadCount = _notifications.where((n) => !n['isRead']).length;
      notifyListeners();
    }
  }

  Future<void> markAllNotificationsAsRead() async {
    for (var notification in _notifications) {
      notification['isRead'] = true;
    }
    _unreadCount = 0;
    notifyListeners();
  }

  Future<void> deleteNotification(String notificationId) async {
    _notifications.removeWhere((n) => n['id'] == notificationId);
    _unreadCount = _notifications.where((n) => !n['isRead']).length;
    notifyListeners();
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    // Simulation d'une notification programmée
    print('Notification programmée: $title à ${scheduledDate.toString()}');
  }

  Future<void> cancelNotification(int id) async {
    print('Notification annulée: $id');
  }

  Future<void> cancelAllNotifications() async {
    print('Toutes les notifications annulées');
  }
}
