@echo off
echo Basculement vers le mode Mock...

REM Sauvegarder le main.dart original
if not exist "lib/main_original.dart" (
    copy "lib/main.dart" "lib/main_original.dart"
    echo Fichier main.dart original sauvegardé
)

REM Remplacer par la version mock
copy "lib/main_mock.dart" "lib/main.dart"
echo Mode Mock activé

REM Remplacer la page de connexion
copy "lib/pages/createAccount_mock.dart" "lib/pages/createAccount.dart"
echo Page de connexion mock activée

echo.
echo Application prête pour les tests !
echo Utilisez: flutter run
echo.
pause
