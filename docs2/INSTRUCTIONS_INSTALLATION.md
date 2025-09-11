# Instructions d'Installation et d'Utilisation - SanoC Patient

## Prérequis

### Logiciels Requis
- **Flutter SDK** : Version 3.0 ou supérieure
- **Android Studio** : Version 2022.1 ou supérieure
- **Git** : Pour cloner le projet
- **Java JDK** : Version 11 ou supérieure

### Comptes et Services
- **Compte Google** : Pour Firebase et Google Sign-In
- **Compte Firebase** : Pour les services backend
- **Compte Google Cloud** : Pour l'API Google Maps

## Installation

### Étape 1 : Cloner le Projet
```bash
git clone https://github.com/Patrickleondev/Projet_Final_Niveau_Avance_DCLIC.git
cd Projet_Final_Niveau_Avance_DCLIC/frontend-mobile/patient
```

### Étape 2 : Installer Flutter
1. Télécharger Flutter depuis [flutter.dev](https://flutter.dev)
2. Extraire dans un dossier (ex: `C:\flutter`)
3. Ajouter `C:\flutter\bin` au PATH système
4. Vérifier l'installation : `flutter doctor`

### Étape 3 : Configuration Android
1. Installer Android Studio
2. Installer Android SDK (API 33+)
3. Configurer un émulateur Android ou connecter un appareil
4. Activer le mode développeur sur l'appareil physique

### Étape 4 : Installer les Dépendances
```bash
flutter pub get
```

## Configuration Firebase

### Étape 1 : Créer un Projet Firebase
1. Aller sur [console.firebase.google.com](https://console.firebase.google.com)
2. Cliquer sur "Créer un projet"
3. Nommer le projet "SanoC" (ou autre nom)
4. Activer Google Analytics (optionnel)

### Étape 2 : Configurer Authentication
1. Dans Firebase Console → Authentication
2. Aller dans l'onglet "Sign-in method"
3. Activer "Email/Password"
4. Activer "Google" et configurer avec votre compte

### Étape 3 : Configurer Firestore
1. Dans Firebase Console → Firestore Database
2. Cliquer sur "Créer une base de données"
3. Choisir "Mode test" pour commencer
4. Sélectionner une région (europe-west1 recommandé)

### Étape 4 : Configurer Storage
1. Dans Firebase Console → Storage
2. Cliquer sur "Commencer"
3. Choisir "Mode test"
4. Sélectionner la même région que Firestore

### Étape 5 : Télécharger la Configuration
1. Dans Firebase Console → Paramètres du projet
2. Aller dans l'onglet "Général"
3. Dans "Vos applications", cliquer sur l'icône Android
4. Entrer le nom du package : `com.example.sanoc`
5. Télécharger `google-services.json`
6. Placer le fichier dans `android/app/`

### Étape 6 : Configurer Google Sign-In
1. Dans Firebase Console → Authentication → Sign-in method
2. Cliquer sur "Google"
3. Copier le "Web SDK configuration"
4. Aller sur [Google Cloud Console](https://console.cloud.google.com)
5. Créer des identifiants OAuth 2.0
6. Configurer les domaines autorisés

## Génération de l'APK

### APK de Debug
```bash
flutter build apk --debug
```
L'APK sera généré dans : `build/app/outputs/flutter-apk/app-debug.apk`

### APK de Release
```bash
flutter build apk --release
```
L'APK sera généré dans : `build/app/outputs/flutter-apk/app-release.apk`

### Installation sur Appareil
```bash
# Via ADB
adb install build/app/outputs/flutter-apk/app-debug.apk

# Ou copier l'APK sur l'appareil et l'installer manuellement
```

## Utilisation de l'Application

### Première Utilisation
1. **Lancer l'application** sur l'appareil
2. **Créer un compte** ou se connecter avec Google
3. **Compléter le profil** avec les informations personnelles
4. **Explorer les fonctionnalités** via le tableau de bord

### Fonctionnalités Principales

#### Authentification
- Créer un compte avec email/mot de passe
- Se connecter avec Google
- Récupérer un mot de passe oublié

#### Tableau de Bord
- Vue d'ensemble des services
- Accès rapide aux fonctionnalités
- Informations de rendez-vous

#### Rendez-vous
- Prendre un nouveau rendez-vous
- Consulter le planning
- Modifier/annuler un rendez-vous

#### Dossier Médical
- Consulter les documents médicaux
- Télécharger les PDFs
- Visualiser les analyses

#### Rappels de Médicaments
- Ajouter des médicaments
- Configurer les horaires
- Gérer les fréquences

#### Services de Santé
- Localiser les hôpitaux
- Navigation GPS
- Informations sur le don de sang

#### Communication
- Chat avec les médecins
- Partage de fichiers
- Notifications

## Résolution de Problèmes

### Erreur "Flutter not found"
```bash
# Vérifier le PATH
echo $PATH

# Ajouter Flutter au PATH
export PATH="$PATH:/chemin/vers/flutter/bin"
```

### Erreur "Android SDK not found"
1. Ouvrir Android Studio
2. Aller dans File → Settings → Appearance & Behavior → System Settings → Android SDK
3. Installer Android SDK Platform 33
4. Configurer ANDROID_HOME dans les variables d'environnement

### Erreur "Firebase configuration"
1. Vérifier que `google-services.json` est dans `android/app/`
2. Vérifier que le package name correspond
3. Rebuild le projet : `flutter clean && flutter pub get`

### Erreur "Google Sign-In"
1. Vérifier la configuration OAuth dans Google Cloud Console
2. Vérifier que le SHA-1 est configuré
3. Obtenir le SHA-1 : `keytool -list -v -keystore ~/.android/debug.keystore`

### L'application ne se lance pas
1. Vérifier les logs : `flutter logs`
2. Nettoyer le projet : `flutter clean`
3. Reinstaller les dépendances : `flutter pub get`
4. Rebuild : `flutter build apk --debug`

## Tests et Validation

### Tests de Base
1. **Installation** : L'APK s'installe correctement
2. **Lancement** : L'application se lance sans erreur
3. **Authentification** : Connexion/déconnexion fonctionne
4. **Navigation** : Toutes les pages sont accessibles
5. **Fonctionnalités** : Chaque fonctionnalité répond

### Tests de Performance
1. **Temps de lancement** : < 3 secondes
2. **Navigation fluide** : Pas de lag
3. **Chargement des données** : < 2 secondes
4. **Gestion mémoire** : Pas de fuites

## Sécurité

### Bonnes Pratiques
- Ne jamais commiter `google-services.json`
- Utiliser des variables d'environnement pour les clés
- Valider toutes les entrées utilisateur
- Chiffrer les données sensibles

### Permissions Android
L'application demande les permissions suivantes :
- `CAMERA` : Pour les photos de profil
- `READ_EXTERNAL_STORAGE` : Pour accéder aux fichiers
- `WRITE_EXTERNAL_STORAGE` : Pour sauvegarder les documents
- `INTERNET` : Pour les services Firebase
- `ACCESS_FINE_LOCATION` : Pour la géolocalisation

## Support

### En cas de problème
1. Vérifier cette documentation
2. Consulter les logs Flutter
3. Vérifier la configuration Firebase
4. Contacter le développeur

### Ressources Utiles
- [Documentation Flutter](https://docs.flutter.dev)
- [Documentation Firebase](https://firebase.google.com/docs)
- [GitHub du projet](https://github.com/Patrickleondev/Projet_Final_Niveau_Avance_DCLIC)

---

**Note :** Ces instructions sont spécifiques à l'environnement de développement utilisé. Adaptez selon votre configuration locale.
