# Guide de Configuration Firebase - SanoC Docteur

## Prérequis

- Compte Google
- Accès à [console.firebase.google.com](https://console.firebase.google.com)
- Application Flutter configurée

## Étapes de Configuration

### 1. Créer un Projet Firebase

1. **Accéder à la console Firebase**
   - Allez sur [console.firebase.google.com](https://console.firebase.google.com)
   - Connectez-vous avec votre compte Google

2. **Créer un nouveau projet**
   - Cliquez sur "Créer un projet"
   - Nom du projet : `sanoc-health-app` (ou votre nom préféré)
   - Activez Google Analytics (recommandé)
   - Cliquez sur "Créer le projet"

3. **Attendre la création**
   - Firebase va créer votre projet
   - Cliquez sur "Continuer" une fois terminé

### 2. Configurer l'Application Android

1. **Ajouter une application Android**
   - Dans la console Firebase, cliquez sur l'icône Android
   - Package name : `com.example.sanoc.docteur` (ou votre package)
   - Surnom de l'app : `SanoC Docteur`
   - Cliquez sur "Enregistrer l'app"

2. **Télécharger le fichier de configuration**
   - Téléchargez `google-services.json`
   - Placez-le dans `frontend-mobile/docteur/android/app/`

3. **Configurer le build.gradle**
   - Ouvrez `android/build.gradle`
   - Ajoutez dans `dependencies` :
   ```gradle
   classpath 'com.google.gms:google-services:4.3.15'
   ```

   - Ouvrez `android/app/build.gradle`
   - Ajoutez en bas du fichier :
   ```gradle
   apply plugin: 'com.google.gms.google-services'
   ```

### 3. Configurer l'Application iOS (si nécessaire)

1. **Ajouter une application iOS**
   - Cliquez sur l'icône iOS
   - Bundle ID : `com.example.sanoc.docteur`
   - Surnom de l'app : `SanoC Docteur`
   - Cliquez sur "Enregistrer l'app"

2. **Télécharger le fichier de configuration**
   - Téléchargez `GoogleService-Info.plist`
   - Placez-le dans `frontend-mobile/docteur/ios/Runner/`

3. **Ajouter à Xcode**
   - Ouvrez le projet dans Xcode
   - Glissez-déposez `GoogleService-Info.plist` dans Runner
   - Cochez "Copy items if needed"

### 4. Activer les Services Firebase

#### Authentication
1. Dans la console Firebase, allez dans "Authentication"
2. Cliquez sur "Commencer"
3. Activez les méthodes d'authentification :
   - **Email/Mot de passe** : Activé
   - **Google** : Activé (optionnel)
   - **Téléphone** : Activé (optionnel)

#### Firestore Database
1. Allez dans "Firestore Database"
2. Cliquez sur "Créer une base de données"
3. Choisissez le mode :
   - **Mode production** : Recommandé pour la production
   - **Mode test** : Pour le développement (expire dans 30 jours)
4. Choisissez l'emplacement : `europe-west1` (recommandé pour l'Europe)

#### Cloud Messaging
1. Allez dans "Cloud Messaging"
2. Cliquez sur "Commencer"
3. Notez le **Server Key** (sera nécessaire pour les notifications)

#### Storage
1. Allez dans "Storage"
2. Cliquez sur "Commencer"
3. Choisissez l'emplacement : `europe-west1`
4. Règles de sécurité : Commencez en mode test

### 5. Configurer les Règles de Sécurité

#### Firestore Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Règles pour les médecins
    match /doctors/{doctorId} {
      allow read, write: if request.auth != null && request.auth.uid == doctorId;
    }
    
    // Règles pour les patients
    match /patients/{patientId} {
      allow read, write: if request.auth != null && 
        request.auth.uid in resource.data.assignedDoctors;
    }
    
    // Règles pour les rendez-vous
    match /appointments/{appointmentId} {
      allow read, write: if request.auth != null && 
        (resource.data.doctorId == request.auth.uid || 
         resource.data.patientId in get(/databases/$(database)/documents/patients/$(resource.data.patientId)).data.assignedDoctors);
    }
    
    // Règles pour les dossiers médicaux
    match /medical_records/{recordId} {
      allow read, write: if request.auth != null && 
        (resource.data.doctorId == request.auth.uid || 
         resource.data.patientId in get(/databases/$(database)/documents/patients/$(resource.data.patientId)).data.assignedDoctors);
    }
    
    // Règles pour les demandes de sang
    match /blood_requests/{requestId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.userType in ['doctor', 'admin'];
    }
    
    // Règles pour les dons de sang
    match /blood_donations/{donationId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.userType in ['doctor', 'admin'];
    }
  }
}
```

#### Storage Rules
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Images de profil des médecins
    match /doctors/{doctorId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == doctorId;
    }
    
    // Documents médicaux
    match /medical_documents/{patientId}/{allPaths=**} {
      allow read, write: if request.auth != null && 
        request.auth.uid in get(/databases/$(database)/documents/patients/$(patientId)).data.assignedDoctors;
    }
    
    // Images des patients
    match /patients/{patientId}/{allPaths=**} {
      allow read, write: if request.auth != null && 
        request.auth.uid in get(/databases/$(database)/documents/patients/$(patientId)).data.assignedDoctors;
    }
  }
}
```

### 6. Mettre à Jour le Code Flutter

1. **Installer les dépendances**
   ```bash
   cd frontend-mobile/docteur
   flutter pub get
   ```

2. **Initialiser Firebase dans main.dart**
   ```dart
   import 'package:firebase_core/firebase_core.dart';
   import 'firebase_options.dart';
   
   void main() async {
     WidgetsFlutterBinding.ensureInitialized();
     await Firebase.initializeApp(
       options: DefaultFirebaseOptions.currentPlatform,
     );
     runApp(MyApp());
   }
   ```

3. **Mettre à jour firebase_options.dart**
   - Remplacez les valeurs `YOUR_*` par celles de votre projet
   - Ou utilisez FlutterFire CLI pour générer automatiquement

### 7. Utiliser FlutterFire CLI (Recommandé)

1. **Installer FlutterFire CLI**
   ```bash
   dart pub global activate flutterfire_cli
   ```

2. **Configurer automatiquement**
   ```bash
   cd frontend-mobile/docteur
   flutterfire configure
   ```

3. **Sélectionner votre projet**
   - Choisissez votre projet Firebase
   - Sélectionnez les plateformes (Android/iOS)
   - FlutterFire générera automatiquement `firebase_options.dart`

## Variables d'Environnement

### Android
- `google-services.json` dans `android/app/`
- Package name dans `android/app/build.gradle`

### iOS
- `GoogleService-Info.plist` dans `ios/Runner/`
- Bundle ID dans `ios/Runner/Info.plist`

## Test de la Configuration

1. **Lancer l'application**
   ```bash
   flutter run
   ```

2. **Vérifier la connexion**
   - L'application doit se lancer sans erreur Firebase
   - Vérifiez les logs pour les erreurs de configuration

3. **Tester l'authentification**
   - Essayez de créer un compte médecin
   - Vérifiez dans la console Firebase que l'utilisateur est créé

## Résolution des Problèmes

### Erreur "No Firebase App"
- Vérifiez que `Firebase.initializeApp()` est appelé avant `runApp()`
- Vérifiez que `firebase_options.dart` est correctement configuré

### Erreur "Permission denied"
- Vérifiez les règles de sécurité Firestore
- Vérifiez que l'utilisateur est authentifié

### Erreur "Network error"
- Vérifiez votre connexion internet
- Vérifiez que Firebase est accessible depuis votre région

## Monitoring et Analytics

1. **Firebase Analytics**
   - Activez dans la console Firebase
   - Surveillez l'utilisation de votre app

2. **Crashlytics**
   - Activez pour détecter les crashes
   - Intégrez dans votre workflow de développement

3. **Performance Monitoring**
   - Surveillez les performances de votre app
   - Identifiez les goulots d'étranglement

## Sécurité

1. **Règles de sécurité strictes**
   - Ne jamais permettre l'accès public aux données
   - Toujours vérifier l'authentification
   - Vérifier les permissions des médecins sur les patients

2. **Validation des données**
   - Validez les données côté client ET serveur
   - Utilisez des schémas de validation

3. **Audit régulier**
   - Vérifiez régulièrement les règles de sécurité
   - Surveillez les accès suspects

## Ressources Utiles

- [Documentation Firebase Flutter](https://firebase.flutter.dev/)
- [Console Firebase](https://console.firebase.google.com/)
- [Règles de sécurité Firestore](https://firebase.google.com/docs/firestore/security/get-started)
- [FlutterFire CLI](https://firebase.flutter.dev/docs/cli/)

---

**Note importante** : Ce guide couvre la configuration de base. Pour la production, consultez la documentation officielle Firebase et suivez les meilleures pratiques de sécurité.
