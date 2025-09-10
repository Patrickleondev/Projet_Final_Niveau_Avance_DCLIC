# SanoC - Application de Santé Communautaire

## Description

SanoC est une application mobile de santé communautaire développée avec Flutter, offrant des services de gestion médicale pour les patients et les médecins.

## Fonctionnalités

### Application Patient
- **Authentification** : Connexion/Inscription avec Firebase Auth et Google Sign-In
- **Tableau de bord** : Vue d'ensemble des services et rendez-vous
- **Rendez-vous** : Prise de rendez-vous avec les médecins
- **Dossier médical** : Consultation et téléchargement des documents médicaux
- **Rappels de médicaments** : Gestion des rappels de prise de médicaments
- **Don de sang** : Information et gestion des dons de sang
- **Hôpitaux** : Localisation et navigation vers les centres médicaux
- **Téléconsultation** : Consultation en ligne avec les médecins
- **Chat** : Communication avec les médecins et partage de fichiers
- **Profil** : Gestion des informations personnelles et paramètres

### Application Médecin
- **Gestion des patients** : Liste et suivi des patients
- **Rendez-vous** : Gestion du planning et des consultations
- **Dossiers médicaux** : Consultation et mise à jour des dossiers
- **Gestion du sang** : Suivi des demandes de don de sang
- **Profil** : Gestion des informations professionnelles

## Technologies Utilisées

- **Frontend** : Flutter/Dart
- **Backend** : Firebase (Firestore, Auth, Storage, Messaging)
- **Base de données** : Cloud Firestore
- **Authentification** : Firebase Auth + Google Sign-In
- **Notifications** : Firebase Cloud Messaging
- **Stockage** : Firebase Storage + SQLite local
- **Maps** : Google Maps API

## Structure du Projet

```
Projet_Final_Niveau_Avance_DCLIC/
├── frontend-mobile/
│   ├── patient/                 # Application patient
│   │   ├── lib/
│   │   │   ├── pages/          # Pages de l'application
│   │   │   ├── services/       # Services (Firebase, etc.)
│   │   │   ├── widgets/        # Composants réutilisables
│   │   │   └── main.dart       # Point d'entrée
│   │   ├── android/            # Configuration Android
│   │   └── apk/               # APKs générés
│   └── docteur/               # Application médecin
│       ├── lib/
│       ├── android/
│       └── apk/
├── SANOC/                     # Ancienne version
├── SANOC_Docteur/            # Ancienne version médecin
└── Documentation/            # Documents du projet
```

## Installation et Configuration

### Prérequis
- Flutter SDK (version 3.0+)
- Android Studio / VS Code
- Compte Firebase
- Compte Google Cloud (pour Google Sign-In)

### Configuration Firebase

1. Créer un projet Firebase
2. Activer les services suivants :
   - Authentication (Email/Password + Google)
   - Firestore Database
   - Storage
   - Cloud Messaging
3. Télécharger les fichiers de configuration :
   - `google-services.json` pour Android
   - `GoogleService-Info.plist` pour iOS
4. Placer les fichiers dans les dossiers appropriés

### Installation

```bash
# Cloner le projet
git clone https://github.com/Patrickleondev/Projet_Final_Niveau_Avance_DCLIC.git

# Aller dans le dossier patient
cd frontend-mobile/patient

# Installer les dépendances
flutter pub get

# Générer les APKs
flutter build apk --release
```

## Génération des APKs

### Application Patient
```bash
cd frontend-mobile/patient
flutter build apk --release
```

### Application Médecin
```bash
cd frontend-mobile/docteur
flutter build apk --release
```

Les APKs seront générés dans :
- `build/app/outputs/flutter-apk/`
- Dossiers `apk/` pour archivage

## Sécurité

⚠️ **Important** : Les fichiers de configuration Firebase sont exclus du dépôt Git pour des raisons de sécurité :
- `firebase_options.dart`
- `google-services.json`
- `GoogleService-Info.plist`
- Clés de signature Android

## Contribution

1. Fork le projet
2. Créer une branche feature (`git checkout -b feature/nouvelle-fonctionnalite`)
3. Commit les changements (`git commit -am 'Ajout nouvelle fonctionnalité'`)
4. Push vers la branche (`git push origin feature/nouvelle-fonctionnalite`)
5. Créer une Pull Request

## Licence

Ce projet est sous licence MIT. Voir le fichier [LICENSE](LICENSE) pour plus de détails.

## Auteur

**Patrick Leon** - [GitHub](https://github.com/Patrickleondev)

## Support

Pour toute question ou problème, veuillez créer une issue sur GitHub.

---

**Note** : Ce projet est développé dans le cadre d'un projet de niveau avancé en développement d'applications mobiles.