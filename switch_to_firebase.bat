@echo off
echo Basculement vers le mode Firebase...

REM Restaurer le main.dart original
if exist "lib/main_original.dart" (
    copy "lib/main_original.dart" "lib/main.dart"
    echo Mode Firebase restauré
) else (
    echo Fichier main.dart original non trouvé
    echo Veuillez configurer Firebase manuellement
)

REM Restaurer la page de connexion originale
if exist "lib/pages/createAccount_original.dart" (
    copy "lib/pages/createAccount_original.dart" "lib/pages/createAccount.dart"
    echo Page de connexion Firebase restaurée
) else (
    echo Page de connexion originale non trouvée
)

echo.
echo Mode Firebase activé !
echo Assurez-vous d'avoir configuré Firebase avant de lancer l'application
echo.
pause
