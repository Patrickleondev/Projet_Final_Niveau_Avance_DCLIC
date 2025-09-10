@echo off
echo ========================================
echo    GENERATION APK FINAL SANOC DOCTEUR
echo ========================================
echo.

echo [1/4] Nettoyage des builds precedents...
flutter clean
echo.

echo [2/4] Recuperation des dependances...
flutter pub get
echo.

echo [3/4] Generation de l'APK en mode release...
flutter build apk --release
echo.

echo [4/4] Copie de l'APK vers le dossier release...
if not exist "release\APK" mkdir "release\APK"
copy "build\app\outputs\flutter-apk\app-release.apk" "release\APK\sanoc_docteur_v1.0.apk"
echo.

echo ========================================
echo    APK GENERE AVEC SUCCES !
echo ========================================
echo.
echo Fichier APK : release\APK\sanoc_docteur_v1.0.apk
echo.
echo Instructions d'installation :
echo 1. Activez "Sources inconnues" dans les parametres Android
echo 2. Installez l'APK sur votre appareil
echo 3. L'application devrait s'ouvrir automatiquement
echo.
echo NOTE: Cette version utilise des services mock (pas de Firebase)
echo.
pause
