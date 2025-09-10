# Guide de Dépannage APK

## Problème : L'APK ne s'ouvre pas après installation

### Solutions à essayer dans l'ordre :

#### 1. Vérifier les paramètres de sécurité Android
```
Paramètres > Sécurité > Sources inconnues (ACTIVER)
OU
Paramètres > Applications > Accès spécial > Installer des applications inconnues
```

#### 2. Vérifier l'espace de stockage
- Assurez-vous d'avoir au moins 500 MB d'espace libre
- L'application nécessite de l'espace pour les données

#### 3. Redémarrer l'appareil
- Redémarrez votre téléphone après l'installation
- Essayez de lancer l'application

#### 4. Vérifier la compatibilité
- Android 6.0 (API 23) minimum requis
- Vérifiez la version Android dans : Paramètres > À propos du téléphone

#### 5. Réinstaller l'APK
- Désinstallez l'application si elle existe
- Réinstallez l'APK
- Attendez que l'installation soit complète

#### 6. Vérifier les permissions
L'application demande ces permissions :
- Caméra
- Localisation
- Notifications
- Stockage

### Diagnostic avancé

#### Vérifier les logs d'erreur
```bash
# Connectez votre appareil en USB
adb logcat | grep -i "sanoc\|flutter\|error"
```

#### Tester en mode debug
```bash
flutter run --release
```

### Applications testées sur :
- Android 10 (API 29)
- Android 11 (API 30)
- Android 12 (API 31)
- Android 13 (API 33)

### Si le problème persiste

1. Contactez le support technique
2. Fournissez ces informations :
   - Modèle du téléphone
   - Version Android
   - Message d'erreur exact
   - Capture d'écran si possible

### Versions alternatives

Si l'APK ne fonctionne pas, essayez :
- Version debug : `flutter run --debug`
- Version web : `flutter run -d chrome`
- Version desktop : `flutter run -d windows`

## Checklist de vérification

- [ ] Sources inconnues activées
- [ ] Espace de stockage suffisant (>500 MB)
- [ ] Android 6.0+ installé
- [ ] Permissions accordées
- [ ] Application réinstallée
- [ ] Appareil redémarré
- [ ] Pas d'antivirus bloquant
