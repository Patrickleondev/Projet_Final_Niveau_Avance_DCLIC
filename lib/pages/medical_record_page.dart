import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'notification_page.dart';
import '/../Profile/profile.dart';
import 'dashboard.dart';
import '../services/medical_document_service.dart';
import '../services/pdf_generator_service.dart';
import '../services/firebase_auth_service.dart';
import 'package:another_flushbar/flushbar.dart';

class MedicalRecordPage extends StatelessWidget {
  const MedicalRecordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true, // Active la flèche de retour
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const DashboardPage()),
            );
          },
        ),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            const Text(
              "Dossier Médical",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: Colors.black,
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
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
              child: const CircleAvatar(
                backgroundImage: AssetImage("assets/images/homme-serieux.jpg"),
                radius: 20,
              ),
            ),
          ],
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Informations personnelles
            const SectionTitle(title: "Informations personnelles"),
            const InfoCard(
              data: {
                "Nom, Prénom": "Ltk Mxz",
                "Âge, Sexe": "45 ans, Masculin",
                "Groupe sanguin": "A+",
                "Allergies": "Pénicilline",
              },
            ),
            const SizedBox(height: 20),

            // Historique médical
            const SectionTitle(title: "Historique médical"),
            const InfoCard(
              data: {
                "Hypertension": "Diagnostiqué le 15 mars 2024",
                "Diabète de type 2": "Diagnostiqué le 3 janvier 2025",
              },
            ),
            const SizedBox(height: 20),

            // Traitements en cours
            const SectionTitle(title: "Traitements en cours"),
            const InfoCard(
              data: {
                "Metformine": "1000mg, 2 fois par jour\nDurée: 6 mois",
                "Amlodipine": "5mg, 1 fois par jour\nDurée: Indéterminée",
              },
            ),
            const SizedBox(height: 20),

            // Résultats d'analyses
            const SectionTitle(title: "Résultats d'analyses"),
            const AnalysisCard(
              analyses: [
                {"title": "Analyse sanguine", "date": "15 février 2025"},
                {"title": "Radiographie thorax", "date": "3 janvier 2025"},
              ],
            ),
            const SizedBox(height: 20),

            // Consultations passées
            const SectionTitle(title: "Consultations passées"),
            const InfoCard(
              data: {
                "Dr. Sophie Laurent": "Contrôle diabète\n20 février 2025",
                "Dr. Pierre Martin": "Suivi tension artérielle\n5 février 2025",
              },
            ),
            const SizedBox(height: 30),

            // Bouton Télécharger mon dossier
            Center(
              child: ElevatedButton.icon(
                onPressed: () => _downloadMedicalRecord(context),
                icon: const Icon(Icons.download, color: Colors.white),
                label: const Text(
                  "Télécharger mon dossier",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fonction pour télécharger le dossier médical
  static Future<void> _downloadMedicalRecord(BuildContext context) async {
    try {
      // Afficher un indicateur de chargement
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      final authService = Provider.of<FirebaseAuthService>(context, listen: false);
      final userId = authService.userId;

      if (userId == null) {
        Navigator.pop(context); // Fermer le dialog de chargement
        _showError(context, "Utilisateur non connecté");
        return;
      }

      // Données médicales à inclure dans le PDF
      final medicalData = {
        'name': authService.userName ?? 'Utilisateur',
        'age': '45 ans',
        'bloodType': 'A+',
        'treatments': [
          'Metformine: 1000mg, 2 fois par jour (Durée: 6 mois)',
          'Amlodipine: 5mg, 1 fois par jour (Durée: Indéterminée)',
        ],
        'analyses': [
          'Analyse sanguine - 15 février 2025',
          'Radiographie thorax - 3 janvier 2025',
        ],
        'consultations': [
          'Dr. Sophie Laurent: Contrôle diabète - 20 février 2025',
          'Dr. Pierre Martin: Suivi tension artérielle - 5 février 2025',
        ],
      };

      // Créer le PDF local
      final pdfPath = await MedicalDocumentService.createLocalMedicalRecordPDF(
        medicalData: medicalData,
      );

      Navigator.pop(context); // Fermer le dialog de chargement

      if (pdfPath != null) {
        _showSuccess(context, "Dossier médical téléchargé avec succès !");
        
        // Optionnel: ouvrir le PDF après téléchargement
        await MedicalDocumentService.openPDF(pdfPath);
      } else {
        _showError(context, "Erreur lors de la génération du dossier");
      }
    } catch (e) {
      Navigator.pop(context); // Fermer le dialog de chargement
      _showError(context, "Erreur: ${e.toString()}");
    }
  }

  // Fonction pour voir un PDF d'analyse
  static Future<void> _viewPDF(BuildContext context, Map<String, String> analysis) async {
    try {
      // Afficher un indicateur de chargement
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Récupérer l'utilisateur connecté
      final authService = Provider.of<FirebaseAuthService>(context, listen: false);
      final userName = authService.userName ?? 'Patient';
      final userEmail = authService.userEmail ?? 'patient@example.com';

      // Données de test pour le PDF
      final treatments = [
        {
          'title': 'Metformine',
          'description': '1000mg, 2 fois par jour',
          'date': 'Depuis 6 mois',
        },
        {
          'title': 'Amlodipine',
          'description': '5mg, 1 fois par jour',
          'date': 'Depuis 3 mois',
        },
      ];

      final analyses = [
        {
          'title': analysis['title'] ?? 'Analyse',
          'date': analysis['date'] ?? DateTime.now().toString().split(' ')[0],
        },
      ];

      final consultations = [
        {
          'title': 'Dr. Sophie Laurent: Contrôle diabète',
          'date': '20 février 2025',
        },
        {
          'title': 'Dr. Pierre Martin: Suivi tension artérielle',
          'date': '5 février 2025',
        },
      ];

      // Générer le PDF avec les vraies données
      final pdfPath = await PDFGeneratorService.generateMedicalRecordPDF(
        patientName: userName,
        patientEmail: userEmail,
        treatments: treatments,
        analyses: analyses,
        consultations: consultations,
      );

      Navigator.pop(context); // Fermer le dialog de chargement

      if (pdfPath != null) {
        // Ouvrir le PDF généré
        final success = await PDFGeneratorService.openPDF(pdfPath);
        if (success) {
          _showSuccess(context, "Document ouvert avec succès !");
        } else {
          _showError(context, "Impossible d'ouvrir le document");
        }
      } else {
        _showError(context, "Erreur lors de la génération du PDF");
      }
    } catch (e) {
      Navigator.pop(context); // Fermer le dialog de chargement
      _showError(context, "Erreur: ${e.toString()}");
    }
  }

  // Afficher un message de succès
  static void _showSuccess(BuildContext context, String message) {
    Flushbar(
      message: message,
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.green,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
    ).show(context);
  }

  // Afficher un message d'erreur
  static void _showError(BuildContext context, String message) {
    Flushbar(
      message: message,
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.red,
      icon: const Icon(Icons.error, color: Colors.white),
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
    ).show(context);
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.red,
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final Map<String, String> data;

  const InfoCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
              data.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    "${entry.key}: ${entry.value}",
                    style: const TextStyle(fontSize: 14),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}

class AnalysisCard extends StatelessWidget {
  final List<Map<String, String>> analyses;

  const AnalysisCard({super.key, required this.analyses});

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          analyses.map((analysis) {
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              title: Text(
                analysis["title"]!,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                analysis["date"]!,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              trailing: TextButton.icon(
                onPressed: () => MedicalRecordPage._viewPDF(context, analysis),
                icon: const Icon(Icons.picture_as_pdf, color: Colors.red),
                label: const Text(
                  "Voir PDF",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            );
          }).toList(),
    );
  }
}
