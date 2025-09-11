# Documentation des Classes Métier - SanoC Patient

## Vue d'Ensemble

Ce document présente l'architecture des classes métier de l'application SanoC Patient, organisées selon le pattern MVC (Model-View-Controller) avec une approche orientée services.

## Architecture Générale

L'application suit une architecture en couches :
- **Presentation Layer** : Pages et Widgets (UI)
- **Business Layer** : Services et Modèles métier
- **Data Layer** : Firebase, SQLite, et APIs externes

## Classes de Services (Business Logic)

### FirebaseAuthService
**Localisation :** `lib/services/firebase_auth_service.dart`

**Responsabilités :**
- Gestion de l'authentification utilisateur
- Connexion/déconnexion
- Inscription de nouveaux utilisateurs
- Gestion des profils utilisateur
- Intégration Google Sign-In

**Méthodes principales :**
```dart
class FirebaseAuthService extends ChangeNotifier {
  // Authentification
  Future<UserCredential?> signInWithEmail(String email, String password)
  Future<UserCredential?> signUpWithEmail(String email, String password)
  Future<void> signOut()
  
  // Gestion profil
  Future<void> updateProfile({String? name, String? phone, String? address})
  Future<void> updateEmail(String newEmail)
  Future<void> updatePassword(String newPassword)
  
  // Google Sign-In
  Future<UserCredential?> signInWithGoogle()
  
  // Récupération mot de passe
  Future<void> sendPasswordResetEmail(String email)
}
```

### NotificationService
**Localisation :** `lib/services/notification_service.dart`

**Responsabilités :**
- Gestion des notifications push
- Notifications locales
- Gestion des rappels de médicaments
- Historique des notifications

**Méthodes principales :**
```dart
class NotificationService extends ChangeNotifier {
  Future<void> initializeNotifications()
  Future<void> scheduleMedicationReminder(Medication medication)
  Future<void> cancelNotification(int id)
  List<Notification> getNotifications()
  Future<void> markAsRead(int notificationId)
}
```

### MedicalDocumentService
**Localisation :** `lib/services/medical_document_service.dart`

**Responsabilités :**
- Gestion des documents médicaux
- Téléchargement de PDFs
- Synchronisation avec Firebase Storage
- Cache local des documents

**Méthodes principales :**
```dart
class MedicalDocumentService {
  Future<List<MedicalDocument>> getMedicalDocuments()
  Future<void> downloadDocument(String documentId)
  Future<void> uploadDocument(File file, String patientId)
  Future<void> deleteDocument(String documentId)
}
```

### PDFGeneratorService
**Localisation :** `lib/services/pdf_generator_service.dart`

**Responsabilités :**
- Génération de PDFs dynamiques
- Création de rapports médicaux
- Export des données patient
- Formatage des documents

**Méthodes principales :**
```dart
class PDFGeneratorService {
  static Future<File> generateMedicalRecordPDF(PatientData data)
  static Future<void> openPDF(File pdfFile)
  static Future<File> generateAppointmentReport(Appointment appointment)
}
```

### MapsService
**Localisation :** `lib/services/maps_service.dart`

**Responsabilités :**
- Intégration avec Google Maps
- Navigation GPS
- Géolocalisation des hôpitaux
- Calcul d'itinéraires

**Méthodes principales :**
```dart
class MapsService {
  static Future<void> getDirectionsTo(String destination)
  static Future<List<Hospital>> getNearbyHospitals(double latitude, double longitude)
  static Future<Location> getCurrentLocation()
}
```

### FileAttachmentService
**Localisation :** `lib/services/file_attachment_service.dart`

**Responsabilités :**
- Gestion des pièces jointes dans le chat
- Sélection d'images et documents
- Upload vers Firebase Storage
- Gestion des permissions

**Méthodes principales :**
```dart
class FileAttachmentService {
  static Future<File?> pickImage({ImageSource source = ImageSource.gallery})
  static Future<File?> pickDocument()
  static Future<String> uploadFile(File file, String chatId)
  static IconData getFileIcon(String fileName)
}
```

### ProfileImageService
**Localisation :** `lib/services/profile_image_service.dart`

**Responsabilités :**
- Gestion des images de profil
- Génération d'avatars avec initiales
- Upload et synchronisation des images
- Cache local des images

**Méthodes principales :**
```dart
class ProfileImageService extends ChangeNotifier {
  String? get currentProfileImageUrl
  Future<void> uploadProfileImage(File imageFile)
  Future<void> deleteProfileImage()
  String getInitials(String? name)
  Widget buildAvatar({double size = 40})
}
```

## Modèles de Données (Models)

### User
**Localisation :** Modèle implicite dans FirebaseAuthService

**Propriétés :**
```dart
class User {
  final String uid;
  final String email;
  final String? displayName;
  final String? phoneNumber;
  final String? address;
  final String? photoURL;
  final DateTime createdAt;
  final DateTime lastLoginAt;
}
```

### MedicalDocument
**Localisation :** Modèle implicite dans MedicalDocumentService

**Propriétés :**
```dart
class MedicalDocument {
  final String id;
  final String patientId;
  final String title;
  final String type; // 'analysis', 'prescription', 'consultation'
  final String downloadUrl;
  final DateTime createdAt;
  final String doctorName;
  final Map<String, dynamic> metadata;
}
```

### Medication
**Localisation :** Modèle implicite dans MedicationRemindersPage

**Propriétés :**
```dart
class Medication {
  final String id;
  final String name;
  final String time;
  final String frequency;
  final bool isActive;
  final DateTime createdAt;
  final String? notes;
}
```

### Appointment
**Localisation :** Modèle implicite dans les pages de rendez-vous

**Propriétés :**
```dart
class Appointment {
  final String id;
  final String patientId;
  final String doctorId;
  final String doctorName;
  final String specialty;
  final DateTime dateTime;
  final String status; // 'scheduled', 'completed', 'cancelled'
  final String? notes;
  final String location;
}
```

### Hospital
**Localisation :** Modèle implicite dans HospitalsPage

**Propriétés :**
```dart
class Hospital {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String phone;
  final List<String> services;
  final String? website;
  final double rating;
}
```

### ChatMessage
**Localisation :** Modèle implicite dans ChatPage

**Propriétés :**
```dart
class ChatMessage {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime timestamp;
  final String type; // 'text', 'image', 'document'
  final String? attachmentUrl;
  final bool isRead;
}
```

## Pages (Controllers/Views)

### DashboardPage
**Localisation :** `lib/pages/dashboard.dart`

**Responsabilités :**
- Affichage du tableau de bord principal
- Navigation vers les fonctionnalités
- Affichage des informations de rendez-vous
- Gestion de l'état de l'interface

### CreateAccountPage
**Localisation :** `lib/pages/createAccount.dart`

**Responsabilités :**
- Authentification utilisateur
- Inscription de nouveaux comptes
- Gestion des erreurs d'authentification
- Intégration Google Sign-In

### MedicalRecordPage
**Localisation :** `lib/pages/medical_record_page.dart`

**Responsabilités :**
- Affichage des documents médicaux
- Téléchargement de PDFs
- Gestion des analyses et prescriptions
- Interface de visualisation

### MedicationRemindersPage
**Localisation :** `lib/pages/rappels_medicaments.dart`

**Responsabilités :**
- Gestion des rappels de médicaments
- Ajout/modification/suppression de médicaments
- Configuration des horaires
- Notifications de rappel

### ChatPage
**Localisation :** `lib/pages/chat_page.dart`

**Responsabilités :**
- Interface de chat avec les médecins
- Gestion des messages
- Partage de fichiers
- Notifications en temps réel

### ProfilePage
**Localisation :** `lib/Profile/profile.dart`

**Responsabilités :**
- Gestion du profil utilisateur
- Modification des informations personnelles
- Paramètres de l'application
- Gestion de la sécurité

## Widgets Réutilisables

### CustomAppBar
**Localisation :** `lib/widgets/common/app_bar_widget.dart`

**Responsabilités :**
- Barre de navigation personnalisée
- Affichage du profil utilisateur
- Notifications et recherche
- Navigation contextuelle

### AnalysisCard
**Localisation :** Widget dans MedicalRecordPage

**Responsabilités :**
- Affichage des analyses médicales
- Actions de visualisation et téléchargement
- Formatage des données médicales

## Gestion d'État

L'application utilise le pattern Provider pour la gestion d'état :

```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => FirebaseAuthService()),
    ChangeNotifierProvider(create: (_) => NotificationService()),
    ChangeNotifierProvider(create: (_) => ProfileImageService()),
  ],
  child: MaterialApp(...),
)
```

## Flux de Données

1. **Authentification :** FirebaseAuthService ↔ Firebase Auth
2. **Documents médicaux :** MedicalDocumentService ↔ Firebase Storage
3. **Notifications :** NotificationService ↔ Firebase Messaging
4. **Profil :** ProfileImageService ↔ Firebase Storage
5. **Données locales :** SharedPreferences pour les préférences

## Sécurité

- Authentification Firebase sécurisée
- Validation des entrées utilisateur
- Gestion des permissions Android
- Chiffrement des données sensibles
- Exclusion des fichiers de configuration du dépôt

## Performance

- Cache local des images et documents
- Lazy loading des listes
- Optimisation des requêtes Firebase
- Gestion mémoire avec dispose()
- Pagination des données volumineuses

## Tests

- Tests unitaires pour les services
- Tests d'intégration pour les flux critiques
- Tests UI pour les composants principaux
- Validation des modèles de données

---

**Note :** Cette documentation reflète l'architecture actuelle de l'application et peut évoluer avec les nouvelles fonctionnalités.
