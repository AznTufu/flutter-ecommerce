# Script de configuration automatique KeyboardShop
# Exécutez ce script depuis PowerShell : .\setup.ps1

Write-Host "================================" -ForegroundColor Cyan
Write-Host "   KeyboardShop Setup Script    " -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# Vérifier Flutter
Write-Host "[1/6] Vérification de Flutter..." -ForegroundColor Yellow
$flutterVersion = flutter --version 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Flutter est installé" -ForegroundColor Green
} else {
    Write-Host "✗ Flutter n'est pas installé" -ForegroundColor Red
    Write-Host "Installez Flutter depuis https://flutter.dev" -ForegroundColor Yellow
    exit 1
}

# Vérifier Firebase CLI
Write-Host ""
Write-Host "[2/6] Vérification de Firebase CLI..." -ForegroundColor Yellow
$firebaseVersion = firebase --version 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Firebase CLI est installé" -ForegroundColor Green
} else {
    Write-Host "✗ Firebase CLI n'est pas installé" -ForegroundColor Red
    Write-Host "Installez avec : npm install -g firebase-tools" -ForegroundColor Yellow
    exit 1
}

# Installer les dépendances Flutter
Write-Host ""
Write-Host "[3/6] Installation des dépendances Flutter..." -ForegroundColor Yellow
flutter pub get
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Dépendances installées" -ForegroundColor Green
} else {
    Write-Host "✗ Erreur lors de l'installation des dépendances" -ForegroundColor Red
    exit 1
}

# Vérifier FlutterFire CLI
Write-Host ""
Write-Host "[4/6] Vérification de FlutterFire CLI..." -ForegroundColor Yellow
$flutterfireVersion = flutterfire --version 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ FlutterFire CLI est installé" -ForegroundColor Green
} else {
    Write-Host "⚠ FlutterFire CLI n'est pas installé" -ForegroundColor Yellow
    Write-Host "Installation en cours..." -ForegroundColor Yellow
    dart pub global activate flutterfire_cli
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ FlutterFire CLI installé" -ForegroundColor Green
    } else {
        Write-Host "✗ Erreur lors de l'installation de FlutterFire CLI" -ForegroundColor Red
        exit 1
    }
}

# Connexion Firebase
Write-Host ""
Write-Host "[5/6] Connexion à Firebase..." -ForegroundColor Yellow
Write-Host "Une fenêtre de navigateur va s'ouvrir pour vous connecter." -ForegroundColor Cyan
firebase login
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Connecté à Firebase" -ForegroundColor Green
} else {
    Write-Host "✗ Erreur lors de la connexion à Firebase" -ForegroundColor Red
    exit 1
}

# Configuration FlutterFire
Write-Host ""
Write-Host "[6/6] Configuration de Firebase dans le projet..." -ForegroundColor Yellow
Write-Host "Sélectionnez votre projet Firebase et les plateformes (Web minimum)." -ForegroundColor Cyan
flutterfire configure
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Firebase configuré" -ForegroundColor Green
} else {
    Write-Host "✗ Erreur lors de la configuration de Firebase" -ForegroundColor Red
    exit 1
}

# Résumé
Write-Host ""
Write-Host "================================" -ForegroundColor Cyan
Write-Host "     Configuration terminée     " -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "✅ Toutes les étapes sont complétées !" -ForegroundColor Green
Write-Host ""
Write-Host "Prochaines étapes :" -ForegroundColor Yellow
Write-Host "1. Allez dans Firebase Console : https://console.firebase.google.com/" -ForegroundColor White
Write-Host "2. Sélectionnez votre projet" -ForegroundColor White
Write-Host "3. Authentication > Sign-in method > Email/Password > Enable" -ForegroundColor White
Write-Host ""
Write-Host "Pour lancer l'application :" -ForegroundColor Yellow
Write-Host "  flutter run -d chrome" -ForegroundColor Cyan
Write-Host ""
Write-Host "Pour les tests :" -ForegroundColor Yellow
Write-Host "  flutter test" -ForegroundColor Cyan
Write-Host ""
Write-Host "Consultez GETTING_STARTED.md pour plus d'informations." -ForegroundColor White
Write-Host ""
