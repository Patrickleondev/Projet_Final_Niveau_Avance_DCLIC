# SanoC Patient - Application de Santé Communautaire

## Vue d'Ensemble

SanoC Patient est une application mobile de santé communautaire développée avec Flutter dans le cadre du projet de fin de formation DCLIC 2025. L'application vise à améliorer l'accès aux soins de santé en Afrique en offrant une solution numérique complète et sécurisée.

## Fonctionnalités Principales

- **Authentification sécurisée** avec Firebase Auth et Google Sign-In
- **Dossier médical numérique** avec synchronisation cloud/local
- **Système de rendez-vous** avec notifications automatiques
- **Rappels de médicaments** programmés
- **Gestion des dons de sang** avec géolocalisation
- **Carte interactive** des centres de santé
- **Notifications push** et locales

## Installation

### Prérequis
- Android 5.0+ (API 21+)
- Connexion Internet
- 100 MB d'espace de stockage

### Installation de l'APK
1. Téléchargez le fichier `app-release.apk`
2. Activez "Sources inconnues" dans les paramètres Android
3. Installez l'APK en suivant les instructions
4. Lancez l'application et créez votre compte

### Installation depuis le Code Source
```bash
# Cloner le projet
git clone [URL_DU_REPO]
cd frontend-mobile/patient

# Installer les dépendances
flutter pub get

# Compiler l'application
flutter build apk --release
```

## Configuration

### Firebase
1. Créez un projet Firebase
2. Activez Authentication, Firestore, Storage et Cloud Messaging
3. Configurez les règles de sécurité
4. Remplacez les placeholders dans `firebase_options.dart`

### Permissions Android
L'application demande les permissions suivantes :
- Caméra (photos de profil)
- Stockage (données locales)
- Localisation (carte interactive)
- Notifications (rappels et alertes)

## Utilisation

### Première Ouverture
1. Suivez l'onboarding (5 écrans)
2. Créez votre compte ou connectez-vous
3. Configurez votre profil médical
4. Explorez les fonctionnalités

### Navigation
- **Accueil** : Tableau de bord avec résumé
- **Rendez-vous** : Gestion des consultations
- **Dossier Médical** : Historique médical
- **Dons de Sang** : Participation aux dons
- **Profil** : Gestion du compte

## Architecture Technique

### Technologies
- **Framework** : Flutter 3.7.2
- **Langage** : Dart
- **Backend** : Firebase (BaaS)
- **Base de données** : Firestore + SQLite
- **Authentification** : Firebase Auth
- **Notifications** : Firebase Cloud Messaging
- **Cartes** : Google Maps API

### Structure du Projet
```
lib/
├── main.dart                 # Point d'entrée
├── services/                 # Services métier
├── pages/                    # Pages de l'application
├── Profile/                  # Gestion du profil
└── widgets/                  # Composants réutilisables
```

## Sécurité

- Authentification sécurisée via Firebase
- Chiffrement des données en transit et au repos
- Règles de sécurité Firestore strictes
- Validation des entrées utilisateur
- Gestion sécurisée des tokens

## Performance

- APK optimisé (66.1 MB)
- Chargement rapide (< 3 secondes)
- Cache local pour l'accès hors ligne
- Synchronisation intelligente des données

## Tests

### Tests Effectués
- Tests unitaires des services
- Tests d'intégration des flux utilisateur
- Tests de performance sur différents appareils
- Tests de sécurité des authentifications

### Qualité du Code
- Analyse statique avec Flutter Analyze
- Respect des conventions Dart/Flutter
- Documentation complète du code
- Architecture modulaire et maintenable

## Documentation

- **Guide d'Installation** : `GUIDE_INSTALLATION_UTILISATION.md`
- **Documentation Technique** : `README_TECHNIQUE.md`
- **Résumé du Projet** : `RESUME_PROJET.md`
- **Fichiers de Soumission** : `FICHIERS_SOUMISSION.md`

## Déploiement

### Build de Production
```bash
# APK de production
flutter build apk --release

# Bundle Android (pour Google Play)
flutter build appbundle --release
```

### Configuration
- **Version** : 1.0.0+1
- **Min SDK** : 21 (Android 5.0)
- **Target SDK** : 34 (Android 14)
- **Architecture** : ARM64, ARMv7, x86_64

## Support

### Contact
- **Email** : support@sanoc-app.com
- **Projet** : SanoC - Application de Santé Communautaire
- **Formation** : DCLIC 2025

### Dépannage
Consultez le guide d'installation pour les problèmes courants et leurs solutions.

## Licence

Ce projet est développé dans le cadre du projet de fin de formation DCLIC 2025. Tous droits réservés.

## Évolutions Futures

- **Version 1.1** : Amélioration de l'interface utilisateur
- **Version 1.2** : Intégration de la téléconsultation
- **Version 2.0** : Support iOS

---

**Développé avec Flutter pour DCLIC 2025**  
**Technologies** : Flutter, Firebase, Dart  
**Architecture** : Mobile-First, BaaS, Offline-First