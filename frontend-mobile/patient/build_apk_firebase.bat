@echo off
echo Construction de l'APK avec Firebase...

REM Nettoyer le projet
echo Nettoyage du projet...
flutter clean

REM Récupérer les dépendances
echo Récupération des dépendances...
flutter pub get

REM Construire l'APK debug
echo Construction de l'APK debug...
flutter build apk --debug

REM Construire l'APK release
echo Construction de l'APK release...
flutter build apk --release

REM Construire l'APK release optimisé
echo Construction de l'APK release optimisé...
flutter build apk --release --split-per-abi

echo.
echo APK générés avec succès !
echo.
echo Fichiers générés :
echo - Debug: build\app\outputs\flutter-apk\app-debug.apk
echo - Release: build\app\outputs\flutter-apk\app-release.apk
echo - Release optimisé: build\app\outputs\flutter-apk\app-arm64-v8a-release.apk
echo.

REM Copier les APK dans le dossier release
echo Copie des APK dans le dossier release...
if not exist "release\APK" mkdir "release\APK"

copy "build\app\outputs\flutter-apk\app-debug.apk" "release\APK\SanoC-Patient-Debug.apk"
copy "build\app\outputs\flutter-apk\app-release.apk" "release\APK\SanoC-Patient-Release.apk"

if exist "build\app\outputs\flutter-apk\app-arm64-v8a-release.apk" (
    copy "build\app\outputs\flutter-apk\app-arm64-v8a-release.apk" "release\APK\SanoC-Patient-Release-ARM64.apk"
)

echo.
echo APK copiés dans release\APK\
echo.
pause
