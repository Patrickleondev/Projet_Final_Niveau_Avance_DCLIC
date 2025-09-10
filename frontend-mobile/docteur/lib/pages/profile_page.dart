import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../services/firebase_auth_service.dart';
import '../services/profile_image_service.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // Charger l'image de profil au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileImageService>().loadCurrentProfileImage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Profil",
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
      ),
      body: Consumer2<FirebaseAuthService, ProfileImageService>(
        builder: (context, authService, profileImageService, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // En-tête du profil
                _buildProfileHeader(authService, profileImageService),
                const SizedBox(height: 24),
                
                // Informations professionnelles
                _buildProfessionalInfo(context, authService),
                const SizedBox(height: 24),
                
                // Options du profil
                _buildProfileOptions(context, authService),
                const SizedBox(height: 24),
                
                // Bouton de déconnexion
                _buildLogoutButton(context, authService),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(FirebaseAuthService authService, ProfileImageService profileImageService) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.red[100],
                backgroundImage: profileImageService.hasProfileImage
                    ? NetworkImage(profileImageService.currentProfileImageUrl!)
                    : null,
                child: !profileImageService.hasProfileImage
                    ? Text(
                        profileImageService.getInitials(authService.userData?['name']),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      )
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => _showImagePickerDialog(authService, profileImageService),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            authService.userData?['name'] ?? 'Dr. Utilisateur',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            authService.userData?['specialty'] ?? 'Spécialité non renseignée',
            style: TextStyle(
              fontSize: 16,
              color: Colors.red[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            authService.userData?['hospitalName'] ?? 'Hôpital non renseigné',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          if (profileImageService.isUploading) ...[
            const SizedBox(height: 16),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProfessionalInfo(BuildContext context, FirebaseAuthService authService) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Informations Professionnelles",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.email,
            label: "Email",
            value: authService.userData?['email'] ?? "Non renseigné",
            onTap: () => _showEditDialog(context, authService, 'email', 'Email'),
          ),
          _buildInfoRow(
            icon: Icons.phone,
            label: "Téléphone",
            value: authService.userData?['phoneNumber'] ?? "Non renseigné",
            onTap: () => _showEditDialog(context, authService, 'phoneNumber', 'Téléphone'),
          ),
          _buildInfoRow(
            icon: Icons.badge,
            label: "Numéro de licence",
            value: authService.userData?['licenseNumber'] ?? "Non renseigné",
            onTap: () => _showEditDialog(context, authService, 'licenseNumber', 'Numéro de licence'),
          ),
          _buildInfoRow(
            icon: Icons.location_on,
            label: "Adresse",
            value: authService.userData?['address'] ?? "Non renseignée",
            onTap: () => _showEditDialog(context, authService, 'address', 'Adresse'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: Colors.red, size: 20),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      color: value == "Non renseigné" || value == "Non renseignée"
                          ? Colors.grey
                          : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.edit, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOptions(BuildContext context, FirebaseAuthService authService) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildOptionTile(
            icon: Icons.notifications,
            title: "Notifications",
            onTap: () {
              // TODO: Naviguer vers la page des notifications
            },
          ),
          _buildOptionTile(
            icon: Icons.security,
            title: "Sécurité",
            onTap: () {
              // TODO: Naviguer vers les paramètres de sécurité
            },
          ),
          _buildOptionTile(
            icon: Icons.help,
            title: "Aide et Support",
            onTap: () {
              // TODO: Naviguer vers l'aide
            },
          ),
          _buildOptionTile(
            icon: Icons.info,
            title: "À propos",
            onTap: () {
              _showAboutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.red),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton(BuildContext context, FirebaseAuthService authService) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () => _showLogoutDialog(context, authService),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          "Se déconnecter",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  // Afficher le dialogue de sélection d'image
  void _showImagePickerDialog(FirebaseAuthService authService, ProfileImageService profileImageService) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galerie'),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickAndUploadImage(profileImageService, ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Appareil photo'),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickAndUploadImage(profileImageService, ImageSource.camera);
                },
              ),
              if (profileImageService.hasProfileImage)
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text('Supprimer la photo', style: TextStyle(color: Colors.red)),
                  onTap: () async {
                    Navigator.pop(context);
                    await _deleteProfileImage(profileImageService);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  // Sélectionner et uploader une image
  Future<void> _pickAndUploadImage(ProfileImageService profileImageService, ImageSource source) async {
    try {
      File? imageFile;
      
      if (source == ImageSource.gallery) {
        imageFile = await profileImageService.pickImageFromGallery();
      } else {
        imageFile = await profileImageService.pickImageFromCamera();
      }

      if (imageFile != null) {
        await profileImageService.uploadProfileImage(imageFile);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Photo de profil mise à jour avec succès'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la mise à jour: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Supprimer la photo de profil
  Future<void> _deleteProfileImage(ProfileImageService profileImageService) async {
    try {
      await profileImageService.deleteProfileImage();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Photo de profil supprimée'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la suppression: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Afficher le dialogue d'édition
  void _showEditDialog(BuildContext context, FirebaseAuthService authService, String field, String label) {
    final controller = TextEditingController(text: authService.userData?[field] ?? '');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Modifier $label'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await authService.updateProfile(
                  phoneNumber: field == 'phoneNumber' ? controller.text : null,
                  address: field == 'address' ? controller.text : null,
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Profil mis à jour avec succès'),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Erreur: ${e.toString()}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Sauvegarder'),
          ),
        ],
      ),
    );
  }

  // Afficher le dialogue de déconnexion
  void _showLogoutDialog(BuildContext context, FirebaseAuthService authService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Se déconnecter'),
        content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              await authService.signOut();
              if (mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Se déconnecter'),
          ),
        ],
      ),
    );
  }

  // Afficher le dialogue À propos
  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'SanoC Docteur',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.medical_services, size: 48, color: Colors.red),
      children: [
        const Text('Application de gestion médicale pour les professionnels de santé.'),
        const SizedBox(height: 16),
        const Text('Développé avec Flutter et Firebase.'),
      ],
    );
  }
}
