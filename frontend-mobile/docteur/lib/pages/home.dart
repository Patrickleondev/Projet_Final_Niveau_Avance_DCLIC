import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/firebase_auth_service.dart';
import '../services/notification_service.dart';
import '../services/profile_image_service.dart';
import 'rendez_vous.dart';
import 'patient_liste.dart';
import 'alertes.dart';
import 'profile_page.dart';
import 'blood_management.dart';

class HomePage extends StatelessWidget {
  final String title;

  const HomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Consumer3<FirebaseAuthService, NotificationService, ProfileImageService>(
      builder: (context, authService, notificationService, profileImageService, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Bonjour, ${authService.userData?['name'] ?? 'Dr. Utilisateur'}",
              style: const TextStyle(color: Colors.black),
            ),
            centerTitle: false,
            backgroundColor: Colors.white,
            elevation: 0,
            actions: [
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications, color: Colors.black),
                    onPressed: () {
                      // TODO: Naviguer vers les notifications
                    },
                  ),
                  if (notificationService.unreadCount > 0)
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
                          '${notificationService.unreadCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfilePage()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.red[100],
                    backgroundImage: profileImageService.hasProfileImage
                        ? NetworkImage(profileImageService.currentProfileImageUrl!)
                        : null,
                    child: !profileImageService.hasProfileImage
                        ? Text(
                            profileImageService.getInitials(authService.userData?['name']),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          )
                        : null,
                  ),
                ),
              ),
            ],
          ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section "Aujourd'hui"
            Text(
              "Aujourd'hui",
              style: TextStyle(
                fontSize: screenHeight * 0.03,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCard("Rendez-vous", "12", Colors.red, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RendezVousPage(),
                    ),
                  );
                }),
                _buildStatCard("Urgences", "3", Colors.orange, () {
                  // Action pour urgences
                }),
                _buildStatCard("Messages", "5", Colors.blue, () {
                  // Action pour messages
                }),
              ],
            ),
            const SizedBox(height: 20),
            // Grille des options
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildGridOption(
                    "Mes Rendez-vous",
                    "12 aujourd'hui",
                    Icons.calendar_today,
                    Colors.red,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RendezVousPage(),
                        ),
                      );
                    },
                  ),
                  _buildGridOption(
                    "Mes Patients",
                    "256 total",
                    Icons.person,
                    Colors.green,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PatientListePage(),
                        ),
                      );
                    },
                  ),
                  _buildGridOption(
                    "Notifications",
                    "3 nouvelles",
                    Icons.notifications,
                    Colors.blue,
                    () {
                      // Action pour notifications
                    },
                  ),
                  _buildGridOption(
                    "Gestion Dons de Sang",
                    "2 demandes",
                    Icons.bloodtype,
                    Colors.orange,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BloodManagementPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Onglet "Accueil" sélectionné
        onTap: (index) {
          // Navigation entre les onglets
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard, color: Colors.red),
            label: "Accueil",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "Rendez-vous",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: "Dossiers Médicaux",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Alertes",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: "Messages"),
        ],
      ),
        );
      },
    );
  }

  Widget _buildStatCard(
    String title,
    String count,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              count,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 5),
            Text(title, style: TextStyle(fontSize: 16, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildGridOption(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
