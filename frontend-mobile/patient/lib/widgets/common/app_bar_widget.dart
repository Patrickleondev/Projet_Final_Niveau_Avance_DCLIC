import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/firebase_auth_service.dart';
import '../../services/notification_service.dart';
import '../../services/profile_image_service.dart';
import '../../pages/notification_page.dart';
import '../../Profile/profile.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: showBackButton,
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 20,
        ),
      ),
      actions: actions ?? [
        // Bouton recherche
        IconButton(
          icon: const Icon(
            Icons.search,
            color: Colors.black,
            size: 28,
          ),
          onPressed: () {
            // TODO: Implémenter la recherche
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Fonctionnalité de recherche à venir')),
            );
          },
        ),
        // Bouton notifications avec badge
        Consumer<NotificationService>(
          builder: (context, notificationService, child) {
            final unreadCount = notificationService.unreadCount;
            return Stack(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.notifications_none_rounded,
                    color: Colors.black,
                    size: 28,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationsPage(),
                      ),
                    );
                  },
                ),
                if (unreadCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        unreadCount > 99 ? '99+' : unreadCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        const SizedBox(width: 8),
        // Avatar du profil
        Consumer2<FirebaseAuthService, ProfileImageService>(
          builder: (context, authService, profileImageService, child) {
            // Initialiser le service si ce n'est pas fait
            if (!profileImageService.isInitialized) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                profileImageService.initialize();
              });
            }

            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfilePage(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: CircleAvatar(
                  backgroundColor: Colors.deepOrange[100],
                  radius: 20,
                  backgroundImage: profileImageService.hasProfileImage
                      ? NetworkImage(profileImageService.currentProfileImageUrl!)
                      : null,
                  child: !profileImageService.hasProfileImage
                      ? (authService.userName != null
                          ? Text(
                              profileImageService.getInitials(authService.userName),
                              style: const TextStyle(
                                color: Colors.deepOrange,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            )
                          : const Icon(Icons.person, color: Colors.deepOrange))
                      : null,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
