# Configuration Firebase Actuelle - SanoC Patient

## Projet Firebase

- **Nom du projet** : SanoC Health App
- **Project ID** : `sanoc-health-app`
- **Project Number** : `1021401416720`

## Configuration Android

- **Package Name** : `com.example.sanoc`
- **App ID** : `1:1021401416720:android:435b9a71d8921a0b8a7695`
- **API Key** : `AIzaSyA1Vq8fUjdLw8D5aAcYiDBpJGb66byX_Y4`
- **Storage Bucket** : `sanoc-health-app.firebasestorage.app`

## Services Activés

### 1. Authentication
- **Email/Password** : Activé
- **Google Sign-In** : Activé
- **SHA-1 Debug** : `208a4e077f6385892e03c864134fd08f4cfce1b6`

### 2. Firestore Database
- **Mode** : Test (pour le développement)
- **Région** : Par défaut
- **Collections** :
  - `users` : Données utilisateurs
  - `medical_records` : Dossiers médicaux
  - `appointments` : Rendez-vous
  - `blood_donations` : Dons de sang
  - `notifications` : Notifications

### 3. Storage
- **Règles** : Test (pour le développement)
- **Structure** : `/users/{userId}/profile_images/`

### 4. Cloud Messaging
- **FCM** : Activé
- **Notifications** : Push et locales

## Fichiers de Configuration

### 1. google-services.json
- **Emplacement** : `android/app/google-services.json`
- **Statut** : ✅ Configuré

### 2. firebase_options.dart
- **Emplacement** : `lib/firebase_options.dart`
- **Statut** : ✅ Configuré avec les vraies valeurs

### 3. build.gradle.kts
- **Plugin Google Services** : ✅ Activé
- **Core Library Desugaring** : ✅ Activé

## Test de la Configuration

### 1. Vérification de la Connexion
```bash
flutter run
```

### 2. Test d'Authentification
- Inscription : `test@example.com` / `password123`
- Connexion Google : Bouton "Continuer avec Google"

### 3. Vérification Firebase Console
- [Console Firebase](https://console.firebase.google.com/project/sanoc-health-app)
- Vérifier les utilisateurs dans Authentication
- Vérifier les données dans Firestore

## Génération APK

### Script Automatique
```bash
# Exécuter le script
build_apk_firebase.bat
```

### Commandes Manuelles
```bash
# APK Debug
flutter build apk --debug

# APK Release
flutter build apk --release

# APK Release Optimisé
flutter build apk --release --split-per-abi
```

## Prochaines Étapes

1. **Tester l'application** avec Firebase
2. **Vérifier la synchronisation** des données
3. **Configurer les règles de sécurité** Firestore
4. **Générer l'APK final** pour la soumission

## Dépannage

### Problèmes Courants

1. **Écran noir** : Vérifier la connexion Internet
2. **Erreur d'authentification** : Vérifier les méthodes activées
3. **Données non synchronisées** : Vérifier les règles Firestore

### Logs Utiles
```bash
# Logs Flutter
flutter logs

# Logs Firebase
# Vérifier dans Firebase Console > Functions > Logs
```

## Support

- **Console Firebase** : [console.firebase.google.com/project/sanoc-health-app](https://console.firebase.google.com/project/sanoc-health-app)
- **Documentation** : [firebase.google.com/docs](https://firebase.google.com/docs)
- **FlutterFire** : [firebase.flutter.dev](https://firebase.flutter.dev)
