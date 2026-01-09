import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Providers & Services
import 'providers/cart_provider.dart';
import 'services/auth_service.dart';
import 'services/firestore_service.dart';

// Screens
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/checkout_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const FreshifyApp());
}

class FreshifyApp extends StatelessWidget {
  const FreshifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Cart state management
        ChangeNotifierProvider(create: (_) => CartProvider()),
        // Authentication state management
        ChangeNotifierProvider(create: (_) => AuthService()),
        // Firestore data fetching service
        Provider(create: (_) => FirestoreService()),
      ],
      child: MaterialApp(
        title: 'Freshify',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          useMaterial3: true, // Recommended for modern Flutter UI
        ),
        debugShowCheckedModeBanner: false,
        // The root of your app is the Login Screen
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginScreen(),
          '/login': (context) => const LoginScreen(), // Alias for easier navigation
          '/signup': (context) => const SignupScreen(),
          '/home': (context) => const HomeScreen(),
          '/cart': (context) => const CartScreen(),
          '/checkout': (context) => const CheckoutScreen(),
        },
      ),
    );
  }
}