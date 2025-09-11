import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/notification_service.dart';
import 'package:intl/intl.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    // Charger les notifications au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationService>().loadNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Notifications",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Consumer<NotificationService>(
            builder: (context, notificationService, child) {
              return TextButton(
                onPressed: () async {
                  await notificationService.markAllAsRead();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Toutes les notifications ont été marquées comme lues'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: const Text(
                  'Tout marquer lu',
                  style: TextStyle(color: Colors.deepOrange),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<NotificationService>(
        builder: (context, notificationService, child) {
          if (notificationService.notifications.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Aucune notification',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Vous recevrez des notifications ici',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: notificationService.notifications.length,
            itemBuilder: (context, index) {
              final notification = notificationService.notifications[index];
              return _buildNotificationCard(
                notification: notification,
                onTap: () async {
                  await notificationService.markAsRead(notification['id']);
                },
                onDelete: () async {
                  await notificationService.deleteNotification(notification['id']);
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildNotificationCard({
    required Map<String, dynamic> notification,
    required VoidCallback onTap,
    required VoidCallback onDelete,
  }) {
    final title = notification['title'] ?? '';
    final message = notification['message'] ?? '';
    final type = notification['type'] ?? 'general';
    final isRead = notification['isRead'] ?? false;
    final createdAt = notification['createdAt'];

    // Déterminer l'icône et la couleur selon le type
    IconData icon;
    Color color;
    
    switch (type) {
      case 'appointment':
        icon = Icons.calendar_today;
        color = Colors.blue;
        break;
      case 'medication':
        icon = Icons.medication;
        color = Colors.orange;
        break;
      case 'blood_donation':
        icon = Icons.favorite;
        color = Colors.red;
        break;
      case 'medical_record':
        icon = Icons.description;
        color = Colors.green;
        break;
      case 'system':
        icon = Icons.build;
        color = Colors.grey;
        break;
      default:
        icon = Icons.notifications;
        color = Colors.deepOrange;
    }

    // Formater la date
    String timeText = 'Maintenant';
    if (createdAt != null) {
      final now = DateTime.now();
      final notificationTime = createdAt.toDate();
      final difference = now.difference(notificationTime);

      if (difference.inMinutes < 1) {
        timeText = 'Maintenant';
      } else if (difference.inMinutes < 60) {
        timeText = 'Il y a ${difference.inMinutes} min';
      } else if (difference.inHours < 24) {
        timeText = 'Il y a ${difference.inHours}h';
      } else if (difference.inDays < 7) {
        timeText = 'Il y a ${difference.inDays} jour${difference.inDays > 1 ? 's' : ''}';
      } else {
        timeText = DateFormat('dd/MM/yyyy').format(notificationTime);
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isRead ? FontWeight.w500 : FontWeight.bold,
            color: isRead ? Colors.grey[600] : Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              timeText,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isRead)
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'delete') {
                  onDelete();
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Supprimer'),
                    ],
                  ),
                ),
              ],
              child: const Icon(
                Icons.more_vert,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
