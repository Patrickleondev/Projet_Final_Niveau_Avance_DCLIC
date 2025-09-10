# Documentation Technique - SanoC Patient

## Vue d'Ensemble du Projet

SanoC Patient est une application mobile de santé communautaire développée avec Flutter. Elle fait partie d'un écosystème plus large incluant une application dédiée aux médecins (SanoC Docteur).

## Architecture Technique

### Stack Technologique

- **Frontend** : Flutter 3.7.2 (Dart)
- **Backend** : Firebase (BaaS - Backend as a Service)
- **Base de données** : 
  - Firestore (données en ligne)
  - SQLite (données locales hors ligne)
- **Authentification** : Firebase Authentication
- **Stockage** : Firebase Storage
- **Notifications** : Firebase Cloud Messaging + Flutter Local Notifications
- **Cartes** : Google Maps API
- **Gestion d'état** : Provider

### Structure du Projet

```
lib/
├── main.dart                 # Point d'entrée de l'application
├── firebase_options.dart     # Configuration Firebase
├── services/                 # Services métier
│   ├── firebase_auth_service.dart
│   ├── notification_service.dart
│   ├── profile_image_service.dart
│   ├── medical_record_service.dart
│   ├── blood_donation_service.dart
│   └── appointment_service.dart
├── pages/                    # Pages de l'application
│   ├── onboarding_page.dart
│   ├── createAccount.dart
│   ├── dashboard.dart
│   ├── appointment_booking.dart
│   ├── medical_records.dart
│   ├── blood_donation.dart
│   ├── notification_page.dart
│   └── teleconsultation.dart
├── Profile/                  # Gestion du profil utilisateur
│   └── profile.dart
└── widgets/                  # Composants réutilisables
    └── common/
        ├── app_bar.dart
        ├── feature_card.dart
        └── appointment_info.dart
```

## Services Implémentés

### 1. FirebaseAuthService
**Responsabilité** : Gestion de l'authentification utilisateur

**Fonctionnalités** :
- Inscription/Connexion par email
- Authentification Google
- Gestion des sessions
- Réinitialisation de mot de passe

**Méthodes principales** :
```dart
Future<UserCredential> signUp({required String email, required String password, required String name, required String userType})
Future<UserCredential> signIn({required String email, required String password})
Future<UserCredential> signInWithGoogle()
Future<void> signOut()
Future<void> resetPassword(String email)
```

### 2. NotificationService
**Responsabilité** : Gestion des notifications locales et push

**Fonctionnalités** :
- Notifications locales programmées
- Notifications Firebase Cloud Messaging
- Gestion des permissions
- Stockage des notifications en base

**Méthodes principales** :
```dart
Future<void> initialize()
Future<void> scheduleNotification({required int id, required String title, required String body, required DateTime scheduledDate})
Future<void> loadUserNotifications()
Future<void> markNotificationAsRead(String notificationId)
```

### 3. ProfileImageService
**Responsabilité** : Gestion des images de profil

**Fonctionnalités** :
- Sélection d'images (galerie/appareil photo)
- Upload vers Firebase Storage
- Gestion des URLs d'images
- Génération d'initiales

**Méthodes principales** :
```dart
Future<File?> pickImageFromGallery()
Future<File?> pickImageFromCamera()
Future<String?> uploadProfileImage(File imageFile)
Future<void> deleteProfileImage()
```

### 4. MedicalRecordService
**Responsabilité** : Gestion des dossiers médicaux

**Fonctionnalités** :
- CRUD des dossiers médicaux
- Synchronisation Firestore/SQLite
- Gestion des consultations
- Stockage des prescriptions

**Méthodes principales** :
```dart
Future<void> createMedicalRecord({required String patientId, required String title, required String description})
Future<List<Map<String, dynamic>>> getPatientMedicalRecords(String patientId)
Future<void> updateMedicalRecord({required String recordId, required Map<String, dynamic> updates})
Future<void> deleteMedicalRecord(String recordId)
```

### 5. BloodDonationService
**Responsabilité** : Gestion des dons de sang

**Fonctionnalités** :
- Création de demandes de sang
- Inscription comme donneur
- Gestion des urgences
- Statistiques des dons

**Méthodes principales** :
```dart
Future<void> createBloodRequest({required String bloodType, required int unitsNeeded, required String hospitalName})
Future<List<Map<String, dynamic>>> getActiveBloodRequests()
Future<void> registerBloodDonation({required String bloodType, required int unitsDonated})
Future<Map<String, dynamic>> getDonationStatistics()
```

### 6. AppointmentService
**Responsabilité** : Gestion des rendez-vous

**Fonctionnalités** :
- Prise de rendez-vous
- Gestion des créneaux
- Notifications de rappel
- Historique des consultations

**Méthodes principales** :
```dart
Future<void> createAppointment({required String doctorId, required String patientId, required DateTime date})
Future<List<Map<String, dynamic>>> getPatientAppointments(String patientId)
Future<void> updateAppointmentStatus(String appointmentId, String status)
Future<void> cancelAppointment(String appointmentId)
```

## Configuration Firebase

### Collections Firestore

1. **users** : Profils utilisateurs
```json
{
  "uid": "string",
  "name": "string",
  "email": "string",
  "userType": "patient|doctor",
  "phoneNumber": "string",
  "address": "string",
  "bloodGroup": "string",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

2. **medical_records** : Dossiers médicaux
```json
{
  "patientId": "string",
  "doctorId": "string",
  "title": "string",
  "description": "string",
  "recordType": "consultation|examen|prescription|resultat",
  "date": "timestamp",
  "diagnosis": "string",
  "treatment": "string",
  "prescription": "string",
  "createdAt": "timestamp"
}
```

3. **appointments** : Rendez-vous
```json
{
  "patientId": "string",
  "doctorId": "string",
  "patientName": "string",
  "doctorName": "string",
  "date": "timestamp",
  "time": "string",
  "type": "consultation|suivi|urgence",
  "status": "pending|confirmed|cancelled|completed",
  "notes": "string",
  "createdAt": "timestamp"
}
```

4. **blood_requests** : Demandes de sang
```json
{
  "bloodType": "string",
  "unitsNeeded": "number",
  "hospitalName": "string",
  "urgency": "normal|high|urgent",
  "description": "string",
  "status": "active|fulfilled|cancelled",
  "createdAt": "timestamp"
}
```

5. **notifications** : Notifications utilisateur
```json
{
  "userId": "string",
  "title": "string",
  "message": "string",
  "type": "appointment|medication|blood_donation|general",
  "isRead": "boolean",
  "data": "object",
  "createdAt": "timestamp"
}
```

### Règles de Sécurité Firestore

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Règles pour les utilisateurs
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // Règles pour les dossiers médicaux
    match /medical_records/{recordId} {
      allow read, write: if request.auth != null && 
        resource.data.patientId == request.auth.uid;
    }

    // Règles pour les rendez-vous
    match /appointments/{appointmentId} {
      allow read, write: if request.auth != null && 
        (resource.data.patientId == request.auth.uid || 
         resource.data.doctorId == request.auth.uid);
    }

    // Règles pour les demandes de sang
    match /blood_requests/{requestId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.userType in ['doctor', 'admin'];
    }

    // Règles pour les notifications
    match /notifications/{notificationId} {
      allow read, write: if request.auth != null && 
        resource.data.userId == request.auth.uid;
    }
  }
}
```

## Base de Données Locale (SQLite)

### Tables

1. **medical_records** : Cache des dossiers médicaux
```sql
CREATE TABLE medical_records (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  firestore_id TEXT UNIQUE,
  patient_id TEXT NOT NULL,
  title TEXT NOT NULL,
  description TEXT,
  record_type TEXT NOT NULL,
  date INTEGER NOT NULL,
  diagnosis TEXT,
  treatment TEXT,
  prescription TEXT,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  synced INTEGER DEFAULT 0
);
```

2. **appointments** : Cache des rendez-vous
```sql
CREATE TABLE appointments (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  firestore_id TEXT UNIQUE,
  patient_id TEXT NOT NULL,
  doctor_id TEXT NOT NULL,
  date INTEGER NOT NULL,
  time TEXT NOT NULL,
  type TEXT NOT NULL,
  status TEXT NOT NULL,
  notes TEXT,
  created_at INTEGER NOT NULL,
  synced INTEGER DEFAULT 0
);
```

3. **notifications** : Cache des notifications
```sql
CREATE TABLE notifications (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  firestore_id TEXT UNIQUE,
  user_id TEXT NOT NULL,
  title TEXT NOT NULL,
  message TEXT NOT NULL,
  type TEXT NOT NULL,
  is_read INTEGER DEFAULT 0,
  data TEXT,
  created_at INTEGER NOT NULL,
  synced INTEGER DEFAULT 0
);
```

## Gestion d'État

L'application utilise le pattern Provider pour la gestion d'état :

```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => FirebaseAuthService()),
    ChangeNotifierProvider(create: (_) => NotificationService()),
    ChangeNotifierProvider(create: (_) => ProfileImageService()),
    ChangeNotifierProvider(create: (_) => MedicalRecordService()),
    ChangeNotifierProvider(create: (_) => BloodDonationService()),
    ChangeNotifierProvider(create: (_) => AppointmentService()),
  ],
  child: MaterialApp(...),
)
```

## Permissions Android

### AndroidManifest.xml
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
<uses-permission android:name="android.permission.VIBRATE" />
<uses-permission android:name="android.permission.WAKE_LOCK" />
```

## Dépendances Principales

### pubspec.yaml
```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Gestion d'état
  provider: ^6.1.1
  
  # Base de données locale
  sqflite: ^2.3.0
  path: ^1.8.3
  
  # Firebase
  firebase_auth: ^4.16.0
  firebase_core: ^2.17.0
  cloud_firestore: ^4.15.5
  firebase_storage: ^11.6.6
  firebase_messaging: ^14.7.20
  
  # Notifications
  flutter_local_notifications: ^17.2.3
  timezone: ^0.9.2
  
  # Géolocalisation et cartes
  google_maps_flutter: ^2.12.1
  geolocator: ^10.1.0
  
  # UI et utilitaires
  image_picker: ^0.8.7+4
  shared_preferences: ^2.1.0
  intl: ^0.19.0
  google_sign_in: ^6.2.1
```

## Tests et Qualité

### Tests Unitaires
- Tests des services métier
- Tests de validation des données
- Tests de synchronisation

### Tests d'Intégration
- Tests des flux utilisateur complets
- Tests de l'intégration Firebase
- Tests de la base de données locale

### Analyse de Code
```bash
flutter analyze
flutter test
flutter test integration_test/
```

## Déploiement

### Build de Production
```bash
# APK de production
flutter build apk --release

# Bundle Android (pour Google Play)
flutter build appbundle --release
```

### Configuration de Build
- **Version** : 1.0.0+1
- **Min SDK** : 21 (Android 5.0)
- **Target SDK** : 34 (Android 14)
- **Architecture** : ARM64, ARMv7, x86_64

## Sécurité

### Mesures Implémentées
1. **Authentification sécurisée** via Firebase Auth
2. **Chiffrement des données** en transit et au repos
3. **Règles de sécurité Firestore** strictes
4. **Validation des entrées** utilisateur
5. **Gestion sécurisée des tokens** d'authentification

### Bonnes Pratiques
- Pas de stockage de mots de passe en local
- Utilisation de HTTPS pour toutes les communications
- Validation côté client et serveur
- Logs de sécurité pour les actions sensibles

## Performance

### Optimisations
1. **Lazy loading** des listes longues
2. **Cache local** pour les données fréquemment utilisées
3. **Compression d'images** avant upload
4. **Pagination** des requêtes Firestore
5. **Mise en cache** des notifications

### Monitoring
- Firebase Analytics pour le suivi d'usage
- Firebase Crashlytics pour les rapports d'erreurs
- Métriques de performance intégrées

## Maintenance et Évolutions

### Roadmap
1. **Version 1.1** : Amélioration de l'interface utilisateur
2. **Version 1.2** : Intégration de la téléconsultation
3. **Version 1.3** : Intelligence artificielle pour les recommandations
4. **Version 2.0** : Support iOS

### Maintenance
- Mises à jour de sécurité régulières
- Corrections de bugs prioritaires
- Amélioration continue des performances
- Support utilisateur actif

---

**Développé dans le cadre du projet de fin de formation DCLIC 2025**
**Technologies** : Flutter, Firebase, Dart
**Architecture** : Mobile-First, BaaS, Offline-First
