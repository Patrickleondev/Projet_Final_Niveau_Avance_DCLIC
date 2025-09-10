# RENDU PROJET - Application Patient SanoC

## Informations du Projet

**Nom du Projet :** SanoC - Application de Santé Communautaire  
**Type :** Application Mobile Flutter  
**Plateforme :** Android  
**Date de Rendu :** 9 Septembre 2025  

## Objectif du Projet

Développer une application mobile de santé communautaire permettant aux patients de :
- Gérer leurs rendez-vous médicaux
- Consulter leur dossier médical
- Recevoir des rappels de médicaments
- Communiquer avec les médecins
- Accéder aux services de santé locaux

## Fonctionnalités Implémentées

### Authentification
- [x] Inscription/Connexion avec email et mot de passe
- [x] Connexion avec Google Sign-In
- [x] Récupération de mot de passe
- [x] Gestion des profils utilisateur

### Tableau de Bord
- [x] Vue d'ensemble des services
- [x] Informations de rendez-vous
- [x] Navigation vers les fonctionnalités
- [x] Interface responsive et moderne

### Gestion des Rendez-vous
- [x] Prise de rendez-vous en ligne
- [x] Consultation du planning
- [x] Notifications de rappel
- [x] Annulation/modification

### Dossier Médical
- [x] Consultation des documents médicaux
- [x] Téléchargement des PDFs
- [x] Visualisation des analyses
- [x] Historique des consultations

### Rappels de Médicaments
- [x] Ajout de médicaments
- [x] Configuration des horaires
- [x] Gestion des fréquences
- [x] Notifications personnalisées

### Services de Santé
- [x] Localisation des hôpitaux
- [x] Navigation GPS
- [x] Don de sang
- [x] Téléconsultation

### Communication
- [x] Chat avec les médecins
- [x] Partage de fichiers (photos, PDFs)
- [x] Notifications en temps réel
- [x] Historique des conversations

### Profil et Paramètres
- [x] Gestion des informations personnelles
- [x] Modification du mot de passe
- [x] Paramètres de notification
- [x] Support et aide

## Technologies Utilisées

- **Framework :** Flutter 3.0+
- **Langage :** Dart
- **Backend :** Firebase
  - Authentication
  - Firestore Database
  - Cloud Storage
  - Cloud Messaging
- **Services :** Google Maps, Google Sign-In
- **Base de données locale :** SQLite
- **État :** Provider Pattern

## Structure du Projet

```
patient/
├── lib/
│   ├── pages/              # Pages de l'application
│   │   ├── dashboard.dart
│   │   ├── createAccount.dart
│   │   ├── medical_record_page.dart
│   │   ├── rappels_medicaments.dart
│   │   ├── chat_page.dart
│   │   └── ...
│   ├── services/           # Services métier
│   │   ├── firebase_auth_service.dart
│   │   ├── notification_service.dart
│   │   ├── pdf_generator_service.dart
│   │   └── ...
│   ├── widgets/            # Composants réutilisables
│   │   └── common/
│   └── main.dart          # Point d'entrée
├── android/               # Configuration Android
├── assets/                # Ressources (images, icônes)
├── docs/                  # Documentation
├── apk/                   # APKs générés
└── pubspec.yaml          # Dépendances Flutter
```

## Installation et Utilisation

### Prérequis
- Flutter SDK 3.0+
- Android Studio
- Compte Firebase configuré

### Installation
```bash
# Cloner le projet
git clone https://github.com/Patrickleondev/Projet_Final_Niveau_Avance_DCLIC.git

# Aller dans le dossier patient
cd frontend-mobile/patient

# Installer les dépendances
flutter pub get

# Générer l'APK
flutter build apk --release
```

### Configuration Firebase
1. Créer un projet Firebase
2. Activer Authentication, Firestore, Storage
3. Télécharger `google-services.json`
4. Placer le fichier dans `android/app/`

## Livrables

### Code Source
- [x] Code source complet de l'application patient
- [x] Structure organisée et commentée
- [x] Gestion d'erreurs implémentée
- [x] Tests unitaires de base

### Documentation
- [x] README détaillé
- [x] Commentaires dans le code
- [x] Guide d'installation
- [x] Documentation des services

### APK
- [x] APK de debug
- [x] APK de release
- [x] Signé et prêt pour l'installation

### Captures d'Écran
- [ ] Interface d'authentification
- [ ] Tableau de bord
- [ ] Gestion des rendez-vous
- [ ] Dossier médical
- [ ] Rappels de médicaments
- [ ] Chat et communication
- [ ] Profil utilisateur

## Interface Utilisateur

L'application utilise un design moderne avec :
- **Couleurs :** Palette orange/bleu pour la santé
- **Typographie :** Police Poppins pour la lisibilité
- **Navigation :** Bottom navigation intuitive
- **Responsive :** Adaptation aux différentes tailles d'écran
- **Accessibilité :** Support des lecteurs d'écran

## Sécurité

- Authentification Firebase sécurisée
- Chiffrement des données sensibles
- Validation des entrées utilisateur
- Gestion des permissions Android
- Exclusion des fichiers de configuration du dépôt Git

## Améliorations Futures

- [ ] Support iOS
- [ ] Mode hors ligne avancé
- [ ] Intégration avec d'autres services de santé
- [ ] Analytics et monitoring
- [ ] Tests automatisés complets

## Développeur

**Patrick Leon**  
Étudiant en Développement d'Applications Mobiles  
Projet de niveau avancé - DCLIC  

## Support

Pour toute question technique ou problème :
- GitHub Issues : [Lien vers les issues]
- Email : [Votre email]
- Documentation : Voir le README principal

---

**Note :** Ce projet a été développé dans le cadre d'un projet de niveau avancé en développement d'applications mobiles Flutter.
