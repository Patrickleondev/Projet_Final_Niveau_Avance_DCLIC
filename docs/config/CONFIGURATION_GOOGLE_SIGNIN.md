# Configuration Google Sign-In - SanoC Patient

## Empreinte SHA-1 Obtenue

**SHA-1 : `20:8A:4E:07:7F:63:85:89:2E:03:C8:64:13:4F:D0:8F:4C:FC:E1:B6`**

## Étapes de Configuration

### 1. Configurer Google Sign-In dans Firebase Console

1. **Accéder à Firebase Console**
   - Allez sur [console.firebase.google.com](https://console.firebase.google.com)
   - Sélectionnez votre projet SanoC

2. **Activer Google Sign-In**
   - Allez dans **Authentication** → **Sign-in method**
   - Cliquez sur **Google** dans la liste des fournisseurs
   - Activez le toggle **"Activer"**
   - Cliquez sur **"Enregistrer"**

3. **Ajouter l'empreinte SHA-1**
   - Allez dans **Paramètres du projet** (icône d'engrenage en haut à gauche)
   - Cliquez sur **"Vos applications"**
   - Sélectionnez votre application Android
   - Dans la section **"Empreintes de certificat SHA"**, ajoutez :
     ```
     20:8A:4E:07:7F:63:85:89:2E:03:C8:64:13:4F:D0:8F:4C:FC:E1:B6
     ```
   - Cliquez sur **"Enregistrer"**

4. **Télécharger le nouveau google-services.json**
   - Après avoir ajouté l'empreinte SHA-1, téléchargez le nouveau fichier `google-services.json`
   - Remplacez l'ancien fichier dans `frontend-mobile/patient/android/app/`

### 2. Configuration du Code (Déjà Fait)

Le code a été configuré avec :
- ✅ `FirebaseAuthService` avec méthode `signInWithGoogle()`
- ✅ Bouton Google Sign-In dans `createAccount.dart`
- ✅ Dépendances ajoutées dans `pubspec.yaml`
- ✅ Configuration Gradle mise à jour

### 3. Test de l'Application

1. **Compiler l'application**
   ```bash
   flutter build apk --debug
   ```

2. **Installer sur un appareil physique**
   - Google Sign-In ne fonctionne pas sur l'émulateur
   - Installez l'APK sur un appareil Android réel

3. **Tester la connexion Google**
   - Ouvrez l'application
   - Allez sur la page de connexion
   - Cliquez sur "Continuer avec Google"
   - Sélectionnez un compte Google
   - Vérifiez que la connexion fonctionne

### 4. Dépannage

#### Erreur "DEVELOPER_ERROR"
- Vérifiez que l'empreinte SHA-1 est correctement ajoutée
- Redémarrez l'application après avoir mis à jour `google-services.json`

#### Erreur "SIGN_IN_REQUIRED"
- Vérifiez que Google Sign-In est activé dans Firebase Console
- Vérifiez que le package name correspond

#### L'application ne se compile pas
- Exécutez `flutter clean` puis `flutter pub get`
- Vérifiez que tous les fichiers de configuration sont en place

### 5. Fonctionnalités Disponibles

Avec Google Sign-In configuré, les utilisateurs peuvent :
- Se connecter avec leur compte Google
- Créer automatiquement un profil patient
- Accéder à toutes les fonctionnalités de l'application
- Se déconnecter proprement

### 6. Prochaines Étapes

1. **Tester sur un appareil physique**
2. **Configurer les notifications push**
3. **Implémenter les autres fonctionnalités**
4. **Tester la synchronisation Firestore**

## Notes Importantes

- Google Sign-In nécessite un appareil physique pour fonctionner
- L'empreinte SHA-1 doit correspondre exactement à celle générée
- Le fichier `google-services.json` doit être à jour après chaque modification
- Pour la production, générez une empreinte SHA-1 de production

## Support

Si vous rencontrez des problèmes :
1. Vérifiez la console Firebase pour les erreurs
2. Consultez les logs Flutter avec `flutter logs`
3. Vérifiez que tous les fichiers de configuration sont corrects
