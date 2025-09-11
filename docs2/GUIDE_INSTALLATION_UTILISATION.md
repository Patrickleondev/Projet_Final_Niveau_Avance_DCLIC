# Guide d'Installation et d'Utilisation - SanoC Patient

## Table des Matières
1. [Présentation de l'Application](#présentation-de-lapplication)
2. [Prérequis](#prérequis)
3. [Installation](#installation)
4. [Configuration Initiale](#configuration-initiale)
5. [Utilisation de l'Application](#utilisation-de-lapplication)
6. [Fonctionnalités Principales](#fonctionnalités-principales)
7. [Dépannage](#dépannage)
8. [Support Technique](#support-technique)

## Présentation de l'Application

SanoC Patient est une application mobile de santé communautaire développée avec Flutter. Elle permet aux patients de :
- Gérer leur dossier médical numérique
- Prendre des rendez-vous avec des médecins
- Recevoir des rappels de médicaments
- Participer aux dons de sang
- Accéder à une carte interactive des centres de santé

## Prérequis

### Matériel
- Smartphone Android (version 5.0 ou supérieure)
- Connexion Internet (WiFi ou données mobiles)
- Espace de stockage : minimum 100 MB

### Logiciel
- Android 5.0 (API niveau 21) ou supérieur
- Google Play Services (pour l'authentification Google)

## Installation

### Méthode 1 : Téléchargement Direct (Recommandée)

1. **Télécharger l'APK depuis Google Drive**
   - Cliquez sur le lien de téléchargement fourni : [LIEN_GOOGLE_DRIVE]
   - Le fichier `SanoC-Patient-v1.0.0.apk` sera téléchargé sur votre appareil
   - Taille du fichier : 66.1 MB

2. **Activer l'installation depuis des sources inconnues**
   - Allez dans **Paramètres** > **Sécurité**
   - Activez **Sources inconnues** ou **Installer des applications inconnues**
   - Sélectionnez votre navigateur ou gestionnaire de fichiers

3. **Installer l'application**
   - Ouvrez le fichier APK téléchargé
   - Suivez les instructions d'installation
   - Acceptez les permissions demandées
   - L'application "SanoC" apparaîtra dans votre liste d'applications

### Méthode 2 : Installation via APK Local (Développeurs)

1. **Télécharger l'APK**
   - Localisez le fichier `app-release.apk` dans le dossier `build/app/outputs/flutter-apk/`
   - Copiez le fichier sur votre smartphone Android

2. **Activer l'installation depuis des sources inconnues**
   - Allez dans **Paramètres** > **Sécurité**
   - Activez **Sources inconnues** ou **Installer des applications inconnues**
   - Sélectionnez votre navigateur ou gestionnaire de fichiers

3. **Installer l'application**
   - Ouvrez le fichier APK avec un gestionnaire de fichiers
   - Suivez les instructions d'installation
   - Acceptez les permissions demandées

### Méthode 3 : Installation via Flutter (Développeurs)

1. **Prérequis de développement**
   ```bash
   # Installer Flutter SDK
   # Installer Android Studio
   # Configurer les variables d'environnement
   ```

2. **Cloner le projet**
   ```bash
   git clone [URL_DU_REPO]
   cd frontend-mobile/patient
   ```

3. **Installer les dépendances**
   ```bash
   flutter pub get
   ```

4. **Compiler et installer**
   ```bash
   flutter build apk --release
   flutter install
   ```

## Configuration Initiale

### Première Ouverture

1. **Écran d'Onboarding**
   - L'application présente 5 écrans d'introduction
   - Découvrez les fonctionnalités principales
   - Naviguez avec les boutons "Suivant" et "Commencer"

2. **Création de Compte**
   - Choisissez entre **S'inscrire** ou **Se connecter**
   - Remplissez les informations requises :
     - Nom complet
     - Email
     - Mot de passe (minimum 6 caractères)
     - Numéro de téléphone
     - Adresse

3. **Authentification Google (Optionnel)**
   - Cliquez sur "Continuer avec Google"
   - Sélectionnez votre compte Google
   - Autorisez l'accès aux informations de base

### Configuration du Profil

1. **Photo de Profil**
   - Appuyez sur l'icône caméra dans le profil
   - Choisissez entre galerie ou appareil photo
   - L'image sera automatiquement sauvegardée

2. **Informations Médicales**
   - Groupe sanguin
   - Allergies connues
   - Médicaments actuels
   - Antécédents médicaux

## Utilisation de l'Application

### Navigation Principale

L'application utilise une navigation par onglets en bas de l'écran :

- **Accueil** : Tableau de bord avec résumé des informations
- **Rendez-vous** : Gestion des consultations
- **Dossier Médical** : Historique médical complet
- **Dons de Sang** : Participation aux dons
- **Profil** : Gestion du compte utilisateur

### Tableau de Bord (Accueil)

1. **Statistiques Rapides**
   - Rendez-vous à venir
   - Rappels de médicaments
   - Notifications non lues

2. **Accès Rapide**
   - Prendre un rendez-vous
   - Consulter le dossier médical
   - Voir les notifications
   - Accéder à la carte des centres de santé

### Gestion des Rendez-vous

1. **Prendre un Rendez-vous**
   - Sélectionnez un médecin
   - Choisissez la date et l'heure
   - Indiquez le motif de consultation
   - Confirmez le rendez-vous

2. **Suivi des Rendez-vous**
   - Consultez l'historique
   - Annulez si nécessaire
   - Recevez des rappels automatiques

### Dossier Médical

1. **Consultations**
   - Historique complet des consultations
   - Prescriptions médicales
   - Résultats d'analyses

2. **Médicaments**
   - Liste des médicaments prescrits
   - Rappels de prise
   - Historique des traitements

### Notifications

1. **Types de Notifications**
   - Rappels de rendez-vous
   - Rappels de médicaments
   - Alertes de dons de sang
   - Notifications système

2. **Gestion**
   - Marquer comme lues
   - Supprimer les notifications
   - Paramétrer les préférences

## Fonctionnalités Principales

### 1. Authentification Sécurisée
- Connexion par email/mot de passe
- Authentification Google
- Gestion des sessions utilisateur

### 2. Dossier Médical Numérique
- Stockage sécurisé des données médicales
- Synchronisation en temps réel
- Accès hors ligne (données mises en cache)

### 3. Système de Rendez-vous
- Prise de rendez-vous en ligne
- Gestion des créneaux disponibles
- Notifications automatiques

### 4. Rappels de Médicaments
- Programmation des rappels
- Notifications locales
- Suivi de l'observance

### 5. Gestion des Dons de Sang
- Inscription comme donneur
- Notifications d'urgences
- Géolocalisation des centres

### 6. Carte Interactive
- Localisation des centres de santé
- Navigation GPS
- Informations de contact

## Dépannage

### Problèmes Courants

1. **L'application ne se lance pas**
   - Vérifiez que votre Android est en version 5.0+
   - Redémarrez votre smartphone
   - Réinstallez l'application

2. **Problèmes de connexion**
   - Vérifiez votre connexion Internet
   - Testez avec WiFi et données mobiles
   - Redémarrez l'application

3. **Erreurs d'authentification**
   - Vérifiez vos identifiants
   - Utilisez la réinitialisation de mot de passe
   - Contactez le support technique

4. **Notifications ne fonctionnent pas**
   - Vérifiez les permissions de notification
   - Allez dans Paramètres > Applications > SanoC > Notifications
   - Activez toutes les permissions

### Permissions Requises

L'application demande les permissions suivantes :

- **Caméra** : Pour prendre des photos de profil
- **Stockage** : Pour sauvegarder les données locales
- **Localisation** : Pour la carte interactive
- **Notifications** : Pour les rappels et alertes
- **Internet** : Pour la synchronisation des données

## Support Technique

### Contact
- **Email** : support@sanoc-app.com
- **Téléphone** : +228 XX XX XX XX
- **Site Web** : www.sanoc-app.com

### Documentation
- **Guide Utilisateur** : Disponible dans l'application
- **FAQ** : Section Aide dans l'application
- **Tutoriels Vidéo** : Chaîne YouTube officielle

### Mises à Jour
- L'application se met à jour automatiquement
- Les nouvelles versions sont notifiées
- Consultez les notes de version pour les nouveautés

## Informations Techniques

### Version Actuelle
- **Version** : 1.0.0
- **Build** : Release
- **Taille** : 66.1 MB
- **Dernière mise à jour** : Janvier 2025

### Technologies Utilisées
- **Framework** : Flutter 3.7.2
- **Langage** : Dart
- **Backend** : Firebase
- **Base de données** : Firestore + SQLite
- **Authentification** : Firebase Auth
- **Stockage** : Firebase Storage

### Compatibilité
- **Android** : 5.0+ (API 21+)
- **Architecture** : ARM64, ARMv7, x86_64
- **Résolution** : Optimisé pour tous les écrans
- **Orientation** : Portrait et paysage

---

**Note** : Ce guide est fourni dans le cadre du projet de fin de formation DCLIC 2025. Pour toute question technique ou fonctionnelle, n'hésitez pas à contacter l'équipe de développement.
