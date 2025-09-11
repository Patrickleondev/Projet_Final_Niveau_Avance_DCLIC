# Guide de Test - Application SanoC Patient

## Problème d'Écran Noir - Solution

L'écran noir que vous rencontrez est causé par la configuration Firebase non complète. Nous avons créé une version de test qui fonctionne sans Firebase.

## Solutions Disponibles

### Option 1 : Mode Test (Recommandé pour les tests)

1. **Utiliser le fichier main_mock.dart**
   ```bash
   # Dans le dossier frontend-mobile/patient
   flutter run lib/main_mock.dart
   ```

2. **Ou modifier temporairement main.dart**
   - Remplacez l'import dans main.dart :
   ```dart
   // Remplacer ces lignes :
   import 'services/firebase_auth_service.dart';
   import 'services/notification_service.dart';
   import 'services/profile_image_service.dart';
   
   // Par :
   import 'services/mock_auth_service.dart';
   import 'services/mock_notification_service.dart';
   import 'services/mock_profile_image_service.dart';
   ```

3. **Et remplacer les providers :**
   ```dart
   providers: [
     ChangeNotifierProvider(create: (_) => MockAuthService()),
     ChangeNotifierProvider(create: (_) => MockNotificationService()),
     ChangeNotifierProvider(create: (_) => MockProfileImageService()),
   ],
   ```

### Option 2 : Configuration Firebase Complète

Pour utiliser l'application avec Firebase :

1. **Créer un projet Firebase**
   - Allez sur [console.firebase.google.com](https://console.firebase.google.com)
   - Créez un nouveau projet
   - Ajoutez une application Android

2. **Télécharger google-services.json**
   - Téléchargez le fichier `google-services.json`
   - Placez-le dans `android/app/`

3. **Configurer firebase_options.dart**
   - Remplacez les valeurs placeholder par vos vraies valeurs Firebase

## Test de l'Application

### Connexion Test
- **Email** : `test@example.com`
- **Mot de passe** : `password123`
- **Nom** : `Utilisateur Test`

### Fonctionnalités Testables

1. **Authentification**
   - Connexion/Inscription
   - Connexion Google (simulée)
   - Réinitialisation mot de passe

2. **Tableau de bord**
   - Navigation entre les sections
   - Affichage des fonctionnalités

3. **Notifications**
   - Affichage des notifications mock
   - Marquer comme lu
   - Supprimer

4. **Profil**
   - Modification des informations
   - Gestion de la photo de profil (simulée)

## Permissions Android

L'application demande automatiquement les permissions suivantes :

- **Internet** : Pour la connexion réseau
- **Localisation** : Pour les cartes et géolocalisation
- **Caméra** : Pour prendre des photos de profil
- **Stockage** : Pour sauvegarder les images
- **Notifications** : Pour les rappels de médicaments

## Génération APK de Test

```bash
# APK Debug
flutter build apk --debug

# APK Release
flutter build apk --release

# APK Release avec signature
flutter build apk --release --split-per-abi
```

## Dépannage

### Écran Noir Persistant
1. Vérifiez que vous utilisez `main_mock.dart`
2. Redémarrez l'application
3. Vérifiez les logs : `flutter logs`

### Erreurs de Permissions
1. Allez dans Paramètres > Applications > SanoC
2. Activez toutes les permissions
3. Redémarrez l'application

### Problèmes de Build
```bash
# Nettoyer le projet
flutter clean
flutter pub get

# Rebuild
flutter build apk --release
```

## Prochaines Étapes

1. **Tester toutes les fonctionnalités** avec le mode mock
2. **Configurer Firebase** pour la version finale
3. **Générer l'APK final** avec Firebase
4. **Tester sur différents appareils**

## Support

Si vous rencontrez des problèmes :
1. Vérifiez les logs Flutter
2. Testez d'abord avec le mode mock
3. Configurez Firebase étape par étape
