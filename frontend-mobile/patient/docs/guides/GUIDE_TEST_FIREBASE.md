# Guide de Test Firebase - Application SanoC Patient

## Configuration Firebase Actuelle

Votre projet Firebase est maintenant configuré avec les valeurs suivantes :

- **Project ID** : `sanoc-health-app`
- **App ID** : `1:1021401416720:android:435b9a71d8921a0b8a7695`
- **API Key** : `AIzaSyA1Vq8fUjdLw8D5aAcYiDBpJGb66byX_Y4`
- **Storage Bucket** : `sanoc-health-app.firebasestorage.app`

## Test de l'Application

### 1. Test d'Authentification

**Inscription d'un nouveau compte :**
- Email : `test@example.com`
- Mot de passe : `password123`
- Nom : `Utilisateur Test`

**Connexion :**
- Utilisez les mêmes identifiants

**Connexion Google :**
- Cliquez sur "Continuer avec Google"
- Sélectionnez votre compte Google

### 2. Test des Fonctionnalités

**Tableau de bord :**
- Vérifiez que toutes les sections s'affichent
- Testez la navigation entre les pages

**Notifications :**
- Vérifiez l'affichage des notifications
- Testez "Marquer comme lu"
- Testez la suppression

**Profil :**
- Modifiez vos informations personnelles
- Testez l'upload de photo de profil
- Vérifiez la déconnexion

### 3. Vérification Firebase Console

Allez sur [console.firebase.google.com](https://console.firebase.google.com) et vérifiez :

**Authentication :**
- Vos utilisateurs apparaissent dans "Users"
- Les méthodes de connexion sont activées

**Firestore Database :**
- Collection `users` créée avec vos données
- Données synchronisées en temps réel

**Storage :**
- Images de profil uploadées
- Fichiers organisés par utilisateur

## Dépannage

### Si l'écran reste noir :
1. Vérifiez les logs Flutter : `flutter logs`
2. Redémarrez l'application
3. Vérifiez la connexion Internet

### Si l'authentification échoue :
1. Vérifiez que l'email/mot de passe sont corrects
2. Vérifiez dans Firebase Console > Authentication
3. Activez les méthodes de connexion nécessaires

### Si les données ne se synchronisent pas :
1. Vérifiez les règles Firestore
2. Vérifiez la connexion Internet
3. Vérifiez les permissions utilisateur

## Règles Firestore Recommandées

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
    
    // Notifications
    match /notifications/{notificationId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## Génération APK avec Firebase

```bash
# APK Debug
flutter build apk --debug

# APK Release
flutter build apk --release

# APK Release optimisé
flutter build apk --release --split-per-abi
```

## Prochaines Étapes

1. **Tester toutes les fonctionnalités** avec Firebase
2. **Vérifier la synchronisation** des données
3. **Tester sur différents appareils**
4. **Générer l'APK final** pour la soumission

## Support

- [Console Firebase](https://console.firebase.google.com/project/sanoc-health-app)
- [Documentation Firebase](https://firebase.google.com/docs)
- [Documentation FlutterFire](https://firebase.flutter.dev/)
