# SanoC - Application Docteur

## Vue d'ensemble

SanoC Docteur est une application mobile professionnelle développée avec Flutter, conçue pour les médecins et professionnels de santé. Cette application permet la gestion complète des patients, des rendez-vous, des dossiers médicaux et des demandes de dons de sang, tout en offrant des outils de communication et de téléconsultation.

## Fonctionnalités principales

- **Authentification sécurisée** : Connexion et inscription des médecins via Firebase Authentication
- **Gestion des patients** : Base de données complète avec recherche et filtrage avancés
- **Gestion des rendez-vous** : Planification, modification et suivi des consultations
- **Dossiers médicaux** : Création et consultation des dossiers, prescriptions et résultats
- **Demandes de dons de sang** : Gestion des alertes et suivi des demandes
- **Notifications intelligentes** : Alertes patient, rappels de rendez-vous et notifications d'urgence
- **Téléconsultation** : Visioconférence et communication patient-médecin
- **Gestion des créneaux** : Planification des disponibilités et optimisation du temps

## Architecture technique

### Frontend
- **Framework** : Flutter (Dart)
- **Gestion d'état** : Provider
- **Navigation** : Routes nommées
- **UI/UX** : Material Design 3 avec thème médical

### Backend
- **Authentification** : Firebase Authentication
- **Base de données** : Firebase Firestore
- **Stockage** : Firebase Storage
- **Notifications** : Firebase Cloud Messaging + Notifications locales
- **Géolocalisation** : Google Maps API

### Structure du projet
```
lib/
├── main.dart                 # Point d'entrée principal
├── services/                 # Services backend
│   ├── firebase_auth_service.dart
│   ├── patient_service.dart
│   ├── appointment_service.dart
│   ├── medical_record_service.dart
│   ├── blood_donation_service.dart
│   └── notification_service.dart
├── pages/                    # Pages de l'application
├── widgets/                  # Composants réutilisables
│   ├── common/              # Widgets communs
│   ├── dashboard/           # Widgets spécifiques au dashboard
│   ├── patients/            # Widgets de gestion des patients
│   └── appointments/        # Widgets de gestion des RDV
```

## Prérequis

- Flutter SDK (version 3.0.0 ou supérieure)
- Dart SDK (version 2.17.0 ou supérieure)
- Android Studio / VS Code
- Compte Firebase
- Clé API Google Maps

## Installation et configuration

### 1. Cloner le projet
```bash
git clone [URL_DU_REPO]
cd frontend-mobile/docteur
```

### 2. Installer les dépendances
```bash
flutter pub get
```

### 3. Configuration Firebase
Suivez le guide détaillé dans `GUIDE_FIREBASE.md` pour :
- Créer un projet Firebase
- Configurer Authentication, Firestore, Storage et Cloud Messaging
- Télécharger les fichiers de configuration
- Mettre à jour `firebase_options.dart`

### 4. Configuration Google Maps
- Obtenir une clé API Google Maps
- L'ajouter dans `android/app/src/main/AndroidManifest.xml`

### 5. Lancer l'application
```bash
flutter run
```

## Configuration des services

### Firebase
L'application utilise Firebase comme backend principal. Assurez-vous que tous les services suivants sont activés :
- **Authentication** : Email/Mot de passe, Google (optionnel)
- **Firestore** : Base de données en temps réel
- **Storage** : Stockage des fichiers
- **Cloud Messaging** : Notifications push

### Notifications
Le système de notifications combine Firebase Cloud Messaging pour les notifications push et les notifications locales pour les rappels et alertes.

## Développement

### Ajouter une nouvelle fonctionnalité
1. Créer le service correspondant dans `lib/services/`
2. Implémenter l'interface utilisateur dans `lib/pages/`
3. Créer les widgets nécessaires dans `lib/widgets/`
4. Ajouter la navigation dans `main.dart`

### Tests
```bash
# Tests unitaires
flutter test

# Tests d'intégration
flutter test integration_test/

# Analyse du code
flutter analyze
```

### Build
```bash
# APK de debug
flutter build apk --debug

# APK de release
flutter build apk --release

# Bundle Android App
flutter build appbundle
```

## Déploiement

### Android
1. Générer l'APK ou App Bundle
2. Signer l'application
3. Tester sur appareils physiques
4. Publier sur Google Play Store

### iOS
1. Configurer les certificats de développement
2. Générer l'IPA
3. Tester sur appareils physiques
4. Soumettre à l'App Store

## Sécurité

- Authentification obligatoire pour toutes les opérations
- Règles de sécurité Firestore strictes avec vérification des permissions
- Chiffrement des données sensibles
- Validation des données côté client et serveur
- Gestion des rôles et permissions par utilisateur

## Maintenance

### Mise à jour des dépendances
```bash
flutter pub upgrade
flutter pub outdated
```

### Surveillance Firebase
- Monitorer l'utilisation des services
- Vérifier les règles de sécurité
- Analyser les performances

## Support et contribution

### Documentation
- `GUIDE_FIREBASE.md` : Configuration Firebase détaillée
- `PLAN_DEVELOPPEMENT.md` : Roadmap du développement
- `README.md` : Ce fichier

### Code Source
- **Services backend** : Prêts à l'utilisation
- **Pages principales** : Structure de base existante
- **Widgets** : À développer selon les besoins
- **Configuration** : En attente de configuration Firebase

## Prochaines étapes

### Phase 1 : Configuration Firebase (Cette semaine)
1. **Suivre le guide Firebase** (`GUIDE_FIREBASE.md`)
2. **Créer le projet Firebase** sur console.firebase.google.com
3. **Configurer tous les services** : Authentication, Firestore, Storage, Cloud Messaging
4. **Télécharger les fichiers de configuration**
5. **Tester la connexion Firebase**

### Phase 2 : Intégration des Services (Semaine prochaine)
1. **Intégrer les services Firebase** dans l'application
2. **Tester l'authentification** des médecins
3. **Implémenter la gestion des patients**
4. **Tester les notifications** Firebase Cloud Messaging

## Licence

Ce projet est développé dans le cadre de la formation DCLIC OIF 2025 en développement mobile Flutter.

## Contact

Pour toute question ou support technique, consultez la documentation ou contactez l'équipe de développement.

---

**Note** : Cette application est en cours de développement. Certaines fonctionnalités peuvent ne pas être encore disponibles ou nécessiter une configuration supplémentaire.
