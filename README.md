# Handmade E-Commerce App

A multi-vendor Flutter marketplace for handmade crafts, featuring customer and seller experiences with Firebase backend.

## Features

### Customer
- **Authentication** — Email/password + Google sign-in, password reset
- **Home** — Featured products, top-rated products, category browsing
- **Search & Filter** — Product search by name, category filtering, price/sort filters
- **Product Details** — Image carousel, seller info, tags, reviews, add to cart/wishlist
- **Cart** — Quantity management, coupon codes, address selection, payment method
- **Wishlist** — Save/favorite products
- **Orders** — Order history with status filtering (Pending → Confirmed → Preparing → Shipped → Delivered → Cancelled), order details with progress slider
- **Checkout** — Paymob integration, PayPal support, Cash on Delivery
- **Profile** — Edit profile, default address, notifications
- **Reviews** — Star rating + comment per product
- **Seller Shops** — View seller profile, products, contact seller
- **Localization** — English & Arabic support
- **Notifications** — Firebase Cloud Messaging, local notifications, real-time updates

### Seller
- **Dashboard** — Sales stats, order count, earnings chart
- **Product Management** — Add/edit/delete products, toggle active status
- **Order Management** — View incoming orders, update status, manage inventory
- **Earnings** — Track earnings, payout history
- **Profile** — Manage shop info, contact details

### Admin
- **Dashboard** — Platform-wide statistics (orders, users, revenue)
- **Order Management** — View all orders, update statuses
- **User Management** — View/manage customers and sellers

## Architecture

```
lib/
├── core/                    # Shared across all features
│   ├── constants/
│   ├── di/                  # Dependency injection
│   ├── extension/           # Dart extensions (validation, localization)
│   ├── functions/           # Shared utility functions
│   ├── models/              # Shared data models
│   ├── routes/              # GetX route definitions
│   ├── services/            # Core services (Firebase, Hive, etc.)
│   ├── theme/               # Colors, text styles, theme
│   ├── utils/               # Parse helpers, time formatting
│   └── widgets/             # Reusable UI components
│
├── features/                # Feature modules
│   ├── admin/               # Admin dashboard & management
│   ├── auth/                # Login, register, password reset
│   ├── customer/            # Customer app (cart, orders, etc.)
│   ├── home/                # Role-based decider screen
│   ├── l10n/                # Localization (ARB files)
│   ├── notifications/       # FCM + local notifications
│   ├── onboarding/          # Onboarding screens
│   ├── payment/             # Paymob & PayPal integration
│   ├── seller/              # Seller dashboard & shop management
│   └── splash/              # Splash screen
│
├── firebase_options.dart
└── main.dart
```

Each feature follows a **feature-first** structure with clear separation:

```
feature/
├── data/       # Models, services, repositories
├── logic/      # Cubits/states (BLoC pattern)
└── ui/         # Screens, widgets
```

### State Management
- **flutter_bloc** — Cubit pattern for all business logic
- **GetX** — Navigation & routing only

### Backend
- **Firebase Firestore** — Primary database
- **Firebase Auth** — Authentication (email + Google)
- **Firebase Storage** — Product & profile images
- **Firebase Cloud Messaging** — Push notifications
- **Firebase Crashlytics** — Error reporting
- **Firebase Analytics** — Usage analytics
- **Firebase Remote Config** — Feature flags & configuration

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter 3.38+ / Dart 3.10+ |
| State Management | flutter_bloc 9.x (Cubit) |
| Navigation | GetX |
| Backend | Firebase (Firestore, Auth, Storage, FCM) |
| Payments | Paymob SDK, PayPal (flutter_paypal_payment) |
| Local Storage | Hive (onboarding state, auth cache) |
| Localization | Flutter ARB (English + Arabic) |
| UI Utilities | flutter_screenutil, flutter_svg, fl_chart |
| CI/Dev | flutter_launcher_icons, flutter_native_splash |

## Getting Started

### Prerequisites
- Flutter SDK 3.38+
- Dart SDK 3.10+
- Firebase project with Firestore, Auth, Storage, FCM enabled
- Android Studio / VS Code

### Setup

```bash
# 1. Clone the repository
git clone https://github.com/your-org/handmade_ecommerce_app.git
cd handmade_ecommerce_app

# 2. Install dependencies
flutter pub get

# 3. Generate localizations
flutter gen-l10n

# 4. Configure Firebase
# Place your google-services.json (Android) and GoogleService-Info.plist (iOS)
# in the respective platform directories, then:
flutterfire configure

# 5. Run the app
flutter run
```

### Firebase Setup
1. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
2. Enable **Authentication** (Email/Password + Google)
3. Enable **Cloud Firestore** (test mode initially)
4. Enable **Firebase Storage**
5. Enable **Firebase Cloud Messaging**
6. Enable **Crashlytics**
7. Run `flutterfire configure` to link the project
8. Create the following Firestore collections:
   - `users` — Customer profiles
   - `products` — Product listings
   - `categories` — Product categories
   - `orders` — Order records
   - `carts` — Shopping carts
   - `wishlists` — User wishlists
   - `reviews` — Product reviews
   - `sellers` — Seller profiles
   - `notifications` — User notifications

### Firestore Security Rules (development)

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## Scripts

```bash
flutter analyze     # Static analysis
flutter test        # Run tests
flutter gen-l10n    # Regenerate localizations
flutter run         # Run the app
```

## Project Stats

- **~200+ Dart files** across core + 10 feature modules
- **10 customer sub-features** (cart, home, orders, product_details, profile, reviews, search, shop_details, wishlist, notifications)
- **Firebase services**: Auth, Firestore, Storage, FCM, Crashlytics, Analytics, Remote Config
- **flutter analyze**: 0 errors, ~21 issues (all pre-existing info/warnings)
