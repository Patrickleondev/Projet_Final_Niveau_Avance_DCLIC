import 'package:flutter/material.dart';

class SecuritySettingsPage extends StatelessWidget {
  const SecuritySettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Paramètres de sécurité",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Option : Activer la double authentification
          _buildSecurityOption(
            context,
            icon: Icons.fingerprint,
            title: "Double authentification",
            description:
                "Activez la double authentification pour sécuriser votre compte.",
            onTap: () {
              _showDoubleAuthDialog(context);
            },
          ),
          const Divider(),
          // Option : Vérification par empreinte digitale
          _buildSecurityOption(
            context,
            icon: Icons.lock,
            title: "Vérification par empreinte digitale",
            description:
                "Ajoutez une vérification biométrique pour accéder à l'application.",
            onTap: () {
              _showFingerprintDialog(context);
            },
          ),
          const Divider(),
          // Option : Politique de confidentialité
          _buildSecurityOption(
            context,
            icon: Icons.privacy_tip,
            title: "Politique de confidentialité",
            description:
                "Découvrez comment vos données sont traitées et sécurisées.",
            onTap: () {
              _showPrivacyPolicy(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepOrange, size: 32),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        description,
        style: const TextStyle(fontSize: 14, color: Colors.grey),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
      onTap: onTap,
    );
  }

  // Dialog pour activer la double authentification
  void _showDoubleAuthDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Double authentification"),
          content: const Text(
            "Souhaitez-vous activer la double authentification pour sécuriser votre compte ?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Double authentification activée !"),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
              ),
              child: const Text("Activer"),
            ),
          ],
        );
      },
    );
  }

  // Dialog pour activer la vérification par empreinte digitale
  void _showFingerprintDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Vérification par empreinte digitale"),
          content: const Text(
            "Souhaitez-vous activer la vérification par empreinte digitale pour accéder à l'application ?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Vérification par empreinte activée !"),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
              ),
              child: const Text("Activer"),
            ),
          ],
        );
      },
    );
  }

  // Dialog pour afficher la politique de confidentialité
  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Politique de confidentialité"),
          content: const SingleChildScrollView(
            child: Text(
              "Vos données sont chiffrées et sécurisées. Nous utilisons des protocoles modernes pour protéger vos informations contre les accès non autorisés. Consultez notre site pour plus de détails.",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Fermer"),
            ),
          ],
        );
      },
    );
  }
}
