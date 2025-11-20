# KeyboardShop - Flutter E-Commerce Platform

A feature-rich e-commerce application for custom mechanical keyboards, built with Flutter 3.24.0, featuring Firebase authentication, Clean Architecture/MVVM pattern, and state management with Riverpod.

---

## Features

### Core Functionality
- **Firebase Authentication** - Secure email/password authentication
- **Product Catalog** - Browse, search, and filter mechanical keyboards
- **Product Details** - Comprehensive product information with image galleries
- **Shopping Cart** - Real-time cart management with quantity control
- **Checkout System** - Complete order placement workflow
- **Order History** - Track past purchases with detailed information
- **User Profile** - Account management and personalization

### Platform-Specific Features
- **PWA Support** (Web) - Installable progressive web app with service workers
- **Native Sharing** (Android) - Share products via Android's native share sheet
- **Biometric Authentication** (iOS/Android) - FaceID/TouchID/Fingerprint support

### Technical Excellence
- **Clean Architecture** - Separation of concerns with Domain/Data/Presentation layers
- **Riverpod State Management** - Type-safe, testable state management
- **go_router Navigation** - Declarative routing with authentication guards
- **Comprehensive Testing** - 47 tests (43 unit + 4 widget) with 50%+ coverage
- **CI/CD Pipeline** - Automated testing, building, and deployment via GitHub Actions

---

## Getting Started

### Prerequisites

Before you begin, ensure you have the following installed:

```bash
Flutter SDK >= 3.24.0
Dart SDK >= 3.5.0
Node.js >= 18.x (for Firebase CLI)
Git
```

Verify your Flutter installation:
```bash
flutter --version
flutter doctor
```

---

## Installation Guide

### Step 1: Clone the Repository

```bash
git clone https://github.com/AznTufu/flutter-ecommerce.git
cd flutter-ecommerce
```

### Step 2: Install Dependencies

```bash
flutter pub get
```

This will install all required packages including:
- `firebase_core` & `firebase_auth` - Firebase integration
- `flutter_riverpod` - State management
- `go_router` - Navigation
- `local_auth` - Biometric authentication
- `share_plus` - Native sharing
- `shared_preferences` & `flutter_secure_storage` - Local storage

### Step 3: Firebase Setup

#### 3.1 Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click **"Add project"** or select an existing project
3. Follow the setup wizard
4. Enable **Firebase Authentication**:
   - Navigate to **Authentication** > **Sign-in method**
   - Enable **Email/Password** provider
   - Click **Save**

#### 3.2 Install Firebase CLI

```bash
npm install -g firebase-tools
firebase login
```

#### 3.3 Install FlutterFire CLI

```bash
dart pub global activate flutterfire_cli
```

#### 3.4 Configure Firebase for Your Project

```bash
flutterfire configure
```

This command will:
- Prompt you to select your Firebase project
- Auto-generate `lib/firebase_options.dart` with your configuration
- Configure platforms (Web, Android, iOS)

**⚠️ IMPORTANT**: The existing `firebase_options.dart` contains placeholder values. You **MUST** run `flutterfire configure` to generate real Firebase credentials for authentication to work.

---

## Running the Application

### Web (Chrome)
```bash
flutter run -d chrome
```

### Android Emulator/Device
```bash
flutter devices
flutter run -d <device_id>
```

### iOS Simulator (macOS only)
```bash
flutter run -d ios
```

### Production Build

```bash
flutter build web --release --web-renderer canvaskit
flutter build apk --release
flutter build ios --release
```

---

## Project Architecture

The project follows **Clean Architecture** principles with three distinct layers:

```
lib/
├── core/                                    # Core utilities and constants
│   ├── constants/
│   │   ├── app_constants.dart              # Global constants
│   │   └── firebase_error_messages.dart    # Auth error translations
│   ├── services/
│   │   ├── biometric_service.dart          # Biometric auth wrapper
│   │   └── platform_service.dart           # Platform detection
│   └── utils/
│       ├── keyboard_mock_data.dart         # Mock product data
│       ├── platform_helper.dart            # Platform utilities
│       └── validators.dart                 # Input validation
│
├── data/                                    # Data Layer
│   ├── datasources/
│   │   ├── auth_datasource.dart            # Firebase Auth API calls
│   │   ├── keyboard_local_datasource.dart  # Local JSON data source
│   │   └── order_local_datasource.dart     # Order persistence
│   ├── models/
│   │   ├── keyboard_model.dart             # Product data model
│   │   └── order_model.dart                # Order data model
│   └── repositories/
│       ├── auth_repository_impl.dart       # Auth repo implementation
│       ├── keyboard_repository_impl.dart   # Product repo implementation
│       └── order_repository_impl.dart      # Order repo implementation
│
├── domain/                                  # Domain Layer (Business Logic)
│   ├── entities/
│   │   ├── keyboard.dart                   # Product entity
│   │   ├── order.dart                      # Order entity
│   │   └── user.dart                       # User entity
│   └── repositories/
│       ├── auth_repository.dart            # Auth contract
│       ├── keyboard_repository.dart        # Product contract
│       └── order_repository.dart           # Order contract
│
├── presentation/                            # Presentation Layer (UI)
│   ├── pages/
│   │   ├── auth/
│   │   │   ├── login_page.dart             # Login screen
│   │   │   └── register_page.dart          # Registration screen
│   │   ├── cart/
│   │   │   └── cart_page.dart              # Shopping cart
│   │   ├── catalog/
│   │   │   └── catalog_page.dart           # Product listing
│   │   ├── checkout/
│   │   │   └── checkout_page.dart          # Order checkout
│   │   ├── orders/
│   │   │   └── orders_page.dart            # Order history
│   │   ├── product/
│   │   │   └── product_detail_page.dart    # Product details
│   │   └── profile/
│   │       └── profile_page.dart           # User profile
│   │
│   ├── providers/
│   │   ├── auth_provider.dart              # Auth state management
│   │   ├── biometric_provider.dart         # Biometric state
│   │   ├── cart_provider.dart              # Cart state
│   │   ├── keyboard_provider.dart          # Product state
│   │   └── order_provider.dart             # Order state
│   │
│   ├── router/
│   │   └── app_router.dart                 # go_router configuration
│   │
│   └── widgets/                             # Reusable UI components
│       ├── biometric_lock_screen.dart      # Biometric prompt
│       ├── keyboard_card.dart              # Product card
│       └── ...
│
├── firebase_options.dart                    # Firebase configuration
└── main.dart                                # Application entry point
```

---

## Authentication Flow

### Supported Features
- **Registration**: Email + password (minimum 6 characters)
- **Login**: Email/password authentication
- **Logout**: Secure session termination
- **Biometric Lock**: iOS FaceID / Android Fingerprint (optional)
- **Route Guards**: Automatic redirect to `/login` for unauthenticated users

---

## Testing

### Run All Tests
```bash
flutter test
```

### Run Tests with Coverage
```bash
flutter test --coverage
```

### Test Coverage Report
- **Total Tests**: 47 (43 unit + 4 widget)
- **Coverage**: 50%+ (enforced by CI/CD)
- **Location**: `test/`

Test structure:
```
test/
├── cart_provider_test.dart           # Cart state tests
├── core/
│   └── utils/
│       └── validators_test.dart      # Input validation tests
├── domain/
│   └── entities/
│       ├── keyboard_test.dart        # Product entity tests
│       ├── order_test.dart           # Order entity tests
│       └── user_test.dart            # User entity tests
└── widgets/
    └── keyboard_card_test.dart       # Widget tests
```

---

## CI/CD Pipeline

### GitHub Actions Workflows

#### **1. CI/CD Pipeline** (`.github/workflows/ci-cd.yml`)
Triggered on: `push` to `main`/`master`/`develop`

**Stages:**
1. **Test** - Run `flutter test --coverage`
2. **Build** - Build Flutter web (`flutter build web --release`)
3. **Deploy** - Deploy to Vercel (production only for `main`/`master`)

#### **2. Coverage Verification** (`.github/workflows/coverage.yml`)
Triggered on: `push` and `pull_request`

**Actions:**
- Calculates test coverage
- Fails if coverage < 50%
- Displays coverage percentage in logs

## Navigation Routes

The app uses **go_router** with the following routes:

| Route | Description | Auth Required |
|-------|-------------|---------------|
| `/login` | Login screen | No |
| `/register` | Registration screen | No |
| `/catalog` | Product catalog (home) | No |
| `/product/:id` | Product details | No |
| `/cart` | Shopping cart | No |
| `/checkout` | Checkout process | Yes |
| `/orders` | Order history | Yes |
| `/profile` | User profile | Yes |

**Authentication Guard**: Unauthenticated users are automatically redirected to `/login` when accessing protected routes.

---

## License

MIT License - See LICENSE file for details

