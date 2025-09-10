import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationService extends ChangeNotifier {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  bool _isInitialized = false;
  String? _fcmToken;
  List<Map<String, dynamic>> _notifications = [];

  bool get isInitialized => _isInitialized;
  String? get fcmToken => _fcmToken;
  List<Map<String, dynamic>> get notifications => _notifications;

  // Initialiser le service de notifications
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialiser timezone
      tz.initializeTimeZones();
      
      // Demander les permissions
      await _requestPermissions();
      
      // Initialiser les notifications locales
      await _initializeLocalNotifications();
      
      // Configurer Firebase Cloud Messaging
      await _configureFCM();
      
      // Écouter les messages en arrière-plan
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      
      // Écouter les messages quand l'app est en arrière-plan
      FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);
      
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de l\'initialisation des notifications: $e');
      }
    }
  }

  // Demander les permissions
  Future<void> _requestPermissions() async {
    final settings = await _fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('Permissions accordées');
      }
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('Permissions provisoires accordées');
      }
    } else {
      if (kDebugMode) {
        print('Permissions refusées');
      }
    }
  }

  // Initialiser les notifications locales
  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  // Configurer Firebase Cloud Messaging
  Future<void> _configureFCM() async {
    // Obtenir le token FCM
    _fcmToken = await _fcm.getToken();
    if (kDebugMode) {
      print('Token FCM: $_fcmToken');
    }

    // Écouter les changements de token
    _fcm.onTokenRefresh.listen((token) {
      _fcmToken = token;
      if (kDebugMode) {
        print('Nouveau token FCM: $token');
      }
    });
  }

  // Gérer les messages en premier plan
  void _handleForegroundMessage(RemoteMessage message) {
    if (kDebugMode) {
      print('Message reçu en premier plan: ${message.notification?.title}');
    }
    
    // Afficher une notification locale
    _showLocalNotification(
      id: message.hashCode,
      title: message.notification?.title ?? 'Nouvelle notification',
      body: message.notification?.body ?? '',
      payload: message.data.toString(),
    );
  }

  // Gérer les messages en arrière-plan
  void _handleBackgroundMessage(RemoteMessage message) {
    if (kDebugMode) {
      print('Message reçu en arrière-plan: ${message.notification?.title}');
    }
  }

  // Gérer le tap sur une notification
  void _onNotificationTapped(NotificationResponse response) {
    if (kDebugMode) {
      print('Notification tapée: ${response.payload}');
    }
  }

  // Afficher une notification locale
  Future<void> _showLocalNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'sanoc_doctor_channel',
      'SanoC Docteur Notifications',
      channelDescription: 'Notifications pour les médecins SanoC',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(id, title, body, details, payload: payload);
  }

  // Programmer une notification locale
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'sanoc_doctor_scheduled',
      'SanoC Docteur Rappels',
      channelDescription: 'Rappels programmés pour les médecins',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      details,
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // Annuler une notification
  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
  }

  // Annuler toutes les notifications
  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  // Charger les notifications de l'utilisateur depuis Firestore
  Future<void> loadUserNotifications() async {
    if (_auth.currentUser == null) return;

    try {
      final snapshot = await _firestore
          .collection('doctor_notifications')
          .where('doctorId', isEqualTo: _auth.currentUser!.uid)
          .orderBy('createdAt', descending: true)
          .limit(50)
          .get();

      _notifications = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'title': data['title'] ?? '',
          'message': data['message'] ?? '',
          'type': data['type'] ?? 'general',
          'isRead': data['isRead'] ?? false,
          'createdAt': data['createdAt'],
          'data': data['data'] ?? {},
        };
      }).toList();

      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors du chargement des notifications: $e');
      }
    }
  }

  // Marquer une notification comme lue
  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await _firestore
          .collection('doctor_notifications')
          .doc(notificationId)
          .update({'isRead': true});

      // Mettre à jour la liste locale
      final index = _notifications.indexWhere((n) => n['id'] == notificationId);
      if (index != -1) {
        _notifications[index]['isRead'] = true;
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la mise à jour de la notification: $e');
      }
    }
  }

  // Marquer toutes les notifications comme lues
  Future<void> markAllNotificationsAsRead() async {
    if (_auth.currentUser == null) return;

    try {
      final batch = _firestore.batch();
      final unreadNotifications = _notifications.where((n) => !n['isRead']).toList();

      for (final notification in unreadNotifications) {
        final docRef = _firestore.collection('doctor_notifications').doc(notification['id']);
        batch.update(docRef, {'isRead': true});
      }

      await batch.commit();

      // Mettre à jour la liste locale
      for (final notification in _notifications) {
        notification['isRead'] = true;
      }
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la mise à jour des notifications: $e');
      }
    }
  }

  // Créer une notification pour un médecin
  Future<void> createDoctorNotification({
    required String doctorId,
    required String title,
    required String message,
    required String type,
    Map<String, dynamic>? data,
  }) async {
    try {
      await _firestore.collection('doctor_notifications').add({
        'doctorId': doctorId,
        'title': title,
        'message': message,
        'type': type,
        'data': data ?? {},
        'isRead': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la création de la notification: $e');
      }
    }
  }

  // Obtenir le nombre de notifications non lues
  int get unreadCount => _notifications.where((n) => !n['isRead']).length;
}