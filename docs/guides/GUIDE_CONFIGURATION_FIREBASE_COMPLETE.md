# Guide de Configuration Firebase Complète

## Étape 1 : Créer un Projet Firebase

1. **Aller sur Firebase Console**
   - Ouvrez [console.firebase.google.com](https://console.firebase.google.com)
   - Connectez-vous avec votre compte Google

2. **Créer un nouveau projet**
   - Cliquez sur "Ajouter un projet"
   - Nom du projet : `sanoc-patient` (ou votre choix)
   - Activez Google Analytics (recommandé)
   - Choisissez votre compte Analytics

## Étape 2 : Ajouter une Application Android

1. **Ajouter Android**
   - Cliquez sur l'icône Android
   - Nom du package : `com.example.sanoc` (ou votre package)
   - Nom de l'application : `SanoC`
   - SHA-1 : (voir section SHA-1 ci-dessous)

2. **Télécharger google-services.json**
   - Téléchargez le fichier
   - Placez-le dans `android/app/google-services.json`

## Étape 3 : Obtenir le SHA-1

### Méthode 1 : Via Android Studio
```bash
# Dans le dossier android
./gradlew signingReport
```

### Méthode 2 : Via keytool
```bash
# Pour debug
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

# Pour release (si vous avez une clé)
keytool -list -v -keystore path/to/your/keystore.jks -alias your-key-alias
```

### Méthode 3 : Via Flutter
```bash
# Dans le dossier du projet
flutter build apk --debug
# Le SHA-1 sera affiché dans les logs
```

## Étape 4 : Configurer Firebase Services

### Authentication
1. **Activer Authentication**
   - Dans Firebase Console > Authentication
   - Cliquez sur "Commencer"
   - Onglet "Sign-in method"
   - Activez "Email/Password"
   - Activez "Google" (optionnel)

### Firestore Database
1. **Créer une base de données**
   - Dans Firebase Console > Firestore Database
   - Cliquez sur "Créer une base de données"
   - Mode : "Test" (pour commencer)
   - Choisissez une région

### Storage
1. **Activer Storage**
   - Dans Firebase Console > Storage
   - Cliquez sur "Commencer"
   - Règles de sécurité : "Test" (pour commencer)

### Cloud Messaging
1. **Activer FCM**
   - Dans Firebase Console > Cloud Messaging
   - Le service est automatiquement activé

## Étape 5 : Configurer firebase_options.dart

1. **Installer FlutterFire CLI**
   ```bash
   dart pub global activate flutterfire_cli
   ```

2. **Configurer automatiquement**
   ```bash
   flutterfire configure
   ```

3. **Ou configurer manuellement**
   - Remplacez les valeurs dans `lib/firebase_options.dart`
   - Utilisez les valeurs de votre projet Firebase

## Étape 6 : Tester la Configuration

1. **Vérifier la connexion**
   ```bash
   flutter run
   ```

2. **Tester l'authentification**
   - Créez un compte
   - Connectez-vous
   - Vérifiez dans Firebase Console > Authentication

3. **Tester Firestore**
   - Créez des données
   - Vérifiez dans Firebase Console > Firestore

## Étape 7 : Règles de Sécurité

### Firestore Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Utilisateurs peuvent lire/écrire leurs propres données
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Dossiers médicaux
    match /medical_records/{recordId} {
      allow read, write: if request.auth != null;
    }
    
    // Rendez-vous
    match /appointments/{appointmentId} {
      allow read, write: if request.auth != null;
    }
    
    // Dons de sang
    match /blood_donations/{donationId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

### Storage Rules
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /users/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## Étape 8 : Génération APK Final

1. **APK Debug avec Firebase**
   ```bash
   flutter build apk --debug
   ```

2. **APK Release avec Firebase**
   ```bash
   flutter build apk --release
   ```

3. **APK Release signé**
   ```bash
   flutter build apk --release --split-per-abi
   ```

## Dépannage

### Erreur "Firebase not initialized"
- Vérifiez que `google-services.json` est présent
- Vérifiez la configuration dans `firebase_options.dart`

### Erreur "Permission denied"
- Vérifiez les règles de sécurité Firestore
- Vérifiez que l'utilisateur est authentifié

### Erreur SHA-1
- Ajoutez le SHA-1 correct dans Firebase Console
- Redémarrez l'application

## Structure des Données Firestore

### Collection `users`
```json
{
  "uid": "user_id",
  "email": "user@example.com",
  "name": "Nom Utilisateur",
  "userType": "patient",
  "createdAt": "timestamp",
  "profileImageUrl": "url"
}
```

### Collection `medical_records`
```json
{
  "id": "record_id",
  "patientId": "user_id",
  "doctorId": "doctor_id",
  "title": "Titre",
  "description": "Description",
  "date": "timestamp",
  "medications": ["med1", "med2"]
}
```

### Collection `appointments`
```json
{
  "id": "appointment_id",
  "patientId": "user_id",
  "doctorId": "doctor_id",
  "date": "timestamp",
  "status": "confirmed",
  "type": "consultation"
}
```

## Support

- [Documentation Firebase](https://firebase.google.com/docs)
- [Documentation FlutterFire](https://firebase.flutter.dev/)
- [Console Firebase](https://console.firebase.google.com)
