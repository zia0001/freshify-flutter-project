# Freshify - Flutter Ecommerce App

A fully-featured ecommerce Flutter app for **Web** and **Android** with Firebase integration.

## Features Implemented

✅ Login/Signup with input validation (name, phone, email, password)
✅ Home page with products loaded from `assets/products.json`
✅ Category filters (Fruits, Vegetables, Dairy, etc.)
✅ Add to cart with +/- quantity controls
✅ Cart badge indicator in app bar
✅ Cart page with live total price calculation
✅ Checkout page (collect user info & address)
✅ Cash on Delivery payment method
✅ Orders saved to Firestore with user ID
✅ Responsive design (Web & Mobile)
✅ Provider-based state management

## Project Structure

```
freshify_app/
├── lib/
│   ├── main.dart               # App entry, Firebase init, routes
│   ├── firebase_options.dart   # Firebase config (placeholder)
│   ├── models/
│   │   ├── product.dart
│   │   └── cart_item.dart
│   ├── providers/
│   │   └── cart_provider.dart  # Cart state management
│   ├── services/
│   │   ├── auth_service.dart   # Firebase Auth
│   │   └── firestore_service.dart  # Firestore & local JSON loading
│   └── screens/
│       ├── login_screen.dart
│       ├── signup_screen.dart
│       ├── home_screen.dart
│       ├── cart_screen.dart
│       └── checkout_screen.dart
├── assets/
│   ├── products.json           # Product catalog (configurable)
│   └── images/                 # Product images folder (add PNG files here)
├── pubspec.yaml
└── README.md
```

## Quick Start

### 1. Install Dependencies

```bash
cd freshify_app
flutter pub get
```

### 2. Configure Firebase (Required)

Install FlutterFire CLI and configure your Firebase project:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

Follow the prompts:

- Select your Firebase project (or create one)
- Enable **Android** and **Web** platforms
- This generates the real `lib/firebase_options.dart`

### 3. Set Up Firestore & Auth in Firebase Console

Go to [Firebase Console](https://console.firebase.google.com/):

1. **Authentication**
   - Enable **Email/Password** sign-in method
2. **Firestore Database**
   - Create a database
   - Start in **Test Mode** for development (set security rules before production)
3. **Create Collections**
   - `users` — stores user profiles (auto-created via `AuthService`)
   - `orders` — stores customer orders (auto-created via `CheckoutScreen`)

### 4. Add Product Images

Place product images in `assets/images/` (e.g., `apple.png`, `banana.png`, etc.):

```bash
mkdir -p assets/images
# Add your PNG images here
```

Update `assets/products.json` with the correct image paths.

### 5. Run on Web

```bash
flutter run -d chrome
```

### 6. Run on Android

```bash
flutter run -d emulator-5554
# Or connect an Android device and run:
flutter run
```

## Firebase Database Structure

### Collections

#### `users` Collection

```json
{
  "uid": {
    "name": "John Doe",
    "phone": "1234567890",
    "email": "john@example.com",
    "createdAt": "2025-01-09T10:30:00Z"
  }
}
```

#### `orders` Collection

```json
{
  "orderId": {
    "userId": "uid123",
    "items": [
      {
        "productId": "p1",
        "name": "Apple",
        "price": 2.5,
        "quantity": 3
      }
    ],
    "total": 7.5,
    "address": "123 Main St, City, State",
    "phone": "1234567890",
    "name": "John Doe",
    "paymentMethod": "Cash on Delivery",
    "createdAt": "2025-01-09T10:35:00Z"
  }
}
```

## Firebase Security Rules (Firestore)

For **Production**, update these security rules in your Firebase Console:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only read/write their own profile
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
    }

    // Orders: users can read their own, write new
    match /orders/{orderId} {
      allow read: if request.auth.uid == resource.data.userId;
      allow create: if request.auth.uid != null;
    }
  }
}
```

## Important Notes

- **Product Images:** No hardcoded assets in the app. All product data (names, prices, image paths) come from `assets/products.json`.
- **Firebase Options:** Run `flutterfire configure` to generate the real `lib/firebase_options.dart`.
- **Test Mode:** For development, Firestore starts in test mode. Before going to production, set proper security rules.
- **Image Assets:** Add product images as PNG files in `assets/images/`. Update `pubspec.yaml` if you add subdirectories.

## Troubleshooting

1. **Firebase Init Error:** Run `flutterfire configure` to generate correct platform configs.
2. **Image Not Loading:** Ensure `assets/images/product_name.png` exists and paths in `products.json` match.
3. **Firestore Write Errors:** Check Firestore security rules in Firebase Console.

## Next Steps

- Add real product images to `assets/images/`
- Connect to a backend API to fetch products dynamically
- Add search and wishlist features
- Implement multiple payment methods
- Add order tracking and notifications

---

Happy coding! 🚀
