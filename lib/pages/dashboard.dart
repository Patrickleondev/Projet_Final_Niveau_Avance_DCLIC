// ignore_for_file: deprecated_member_use, unused_import

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/firebase_auth_service.dart';
import '../widgets/common/app_bar_widget.dart';
import 'prise_rdv.dart';
import 'medical_record_page.dart';
import 'rappels_medicaments.dart';
import 'blood_donation.dart';
import 'hospitals.dart';
import 'teleconsultation_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: const CustomAppBar(
        title: "Accueil",
        showBackButton: false,
      ),
      body: Consumer<FirebaseAuthService>(
        builder: (context, authService, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // En-tête de bienvenue
                _buildWelcomeHeader(authService),
                const SizedBox(height: 24),
                
                // Informations de rendez-vous
                _buildAppointmentSection(),
                
                const SizedBox(height: 24),
                
                // Grille des fonctionnalités
                _buildFeaturesGrid(),
                
                const SizedBox(height: 24),
                
                // Section des services rapides
                _buildQuickServices(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWelcomeHeader(FirebaseAuthService authService) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Bienvenue, ${authService.userName ?? 'Utilisateur'}",
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Comment allez-vous aujourd'hui?",
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildAppointmentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Rendez-vous",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.blue[200]!,
              width: 1,
            ),
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AppointmentBookingPage(
                    onAppointmentConfirmed: (appointmentDetails) {
                      print("Appointment confirmed: $appointmentDetails");
                    },
                  ),
                ),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.calendar_today,
                    color: Colors.blue,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Prochain rendez-vous",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Dr. Marie Dupont",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "15 Janvier 2025 à 14:30",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Centre Médical Saint-Jean",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[400],
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Services",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.1,
          children: [
            _buildFeatureCard(
              title: "Rendez-vous",
              subtitle: "Prendre un RDV",
              icon: Icons.calendar_today,
              color: Colors.blue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AppointmentBookingPage(
                      onAppointmentConfirmed: (appointmentDetails) {
                        print("Appointment confirmed: $appointmentDetails");
                      },
                    ),
                  ),
                );
              },
            ),
            _buildFeatureCard(
              title: "Dossier Médical",
              subtitle: "Consulter vos dossiers",
              icon: Icons.folder,
              color: Colors.green,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MedicalRecordPage(),
                  ),
                );
              },
            ),
            _buildFeatureCard(
              title: "Rappels",
              subtitle: "Gérer vos médicaments",
              icon: Icons.medication,
              color: Colors.orange,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MedicationRemindersPage(),
                  ),
                );
              },
              badgeText: "3",
            ),
            _buildFeatureCard(
              title: "Don de Sang",
              subtitle: "Sauver des vies",
              icon: Icons.favorite,
              color: Colors.red,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BloodDonationPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    String? badgeText,
    bool isCompact = false,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(isCompact ? 16 : 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: 24,
                    ),
                  ),
                  if (badgeText != null) ...[
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        badgeText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 16),
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: isCompact ? 14 : 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 4),
              Flexible(
                child: Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: isCompact ? 11 : 12,
                    color: Colors.grey[600],
                  ),
                  maxLines: isCompact ? 1 : 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickServices() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Services Rapides",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildFeatureCard(
                title: "Hôpitaux",
                subtitle: "Trouver un centre",
                icon: Icons.local_hospital,
                color: Colors.purple,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HospitalsPage(),
                    ),
                  );
                },
                isCompact: true,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFeatureCard(
                title: "Téléconsultation",
                subtitle: "Consultation en ligne",
                icon: Icons.video_call,
                color: Colors.teal,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TeleconsultationPage(
                        doctorName: "Dr. Marie Dupont",
                        doctorSpecialty: "Médecin Généraliste",
                        doctorAvatar: "assets/images/doctor.png",
                        nurseAvatar: "assets/images/infirmiere.png",
                        isVideoCall: true,
                      ),
                    ),
                  );
                },
                isCompact: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
