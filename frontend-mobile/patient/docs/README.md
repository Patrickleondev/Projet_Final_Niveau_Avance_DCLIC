# Documentation SanoC Patient

## Structure de la documentation

### Guides (`guides/`)
- `GUIDE_CONFIGURATION_FIREBASE_COMPLETE.md` - Configuration complète Firebase
- `GUIDE_FIREBASE.md` - Guide Firebase de base
- `GUIDE_INSTALLATION_UTILISATION.md` - Installation et utilisation
- `GUIDE_TEST_APPLICATION.md` - Tests de l'application
- `GUIDE_TEST_FIREBASE.md` - Tests Firebase

### Configuration (`config/`)
- `CONFIGURATION_FIREBASE_ACTUELLE.md` - Configuration Firebase actuelle
- `CONFIGURATION_GOOGLE_SIGNIN.md` - Configuration Google Sign-In

### Rapports (`reports/`)
- `RESUME_ACTUEL.md` - Résumé de l'état actuel
- `RESUME_PROJET.md` - Résumé du projet
- `RESUME_SITUATION_ACTUELLE.md` - Situation actuelle
- `FICHIERS_SOUMISSION.md` - Fichiers de soumission
- `PLAN_DEVELOPPEMENT.md` - Plan de développement

## Démarrage rapide

1. **Installation** : Consultez `guides/GUIDE_INSTALLATION_UTILISATION.md`
2. **Configuration Firebase** : Voir `config/CONFIGURATION_FIREBASE_ACTUELLE.md`
3. **Tests** : Suivez `guides/GUIDE_TEST_APPLICATION.md`

## Problèmes connus et solutions

### APK ne s'ouvre pas
- Vérifiez les permissions dans `AndroidManifest.xml`
- Assurez-vous que Firebase est correctement configuré
- Testez en mode debug avant de générer l'APK

### Migration vers SQLite
- Le service `SQLiteStorageService` remplace Firebase Storage
- Consultez `lib/services/sqlite_storage_service.dart`

## Applications

- **Patient** : Application mobile pour les patients
- **Docteur** : Application mobile pour les médecins

## Liens utiles

- [Documentation Flutter](https://flutter.dev/docs)
- [Firebase Console](https://console.firebase.google.com)
- [SQLite Documentation](https://www.sqlite.org/docs.html)
