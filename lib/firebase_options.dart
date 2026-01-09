import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    // Return platform-specific options
    // For Web
    if (identical(0, 0.0)) {
      return web;
    }
    // Default to Android/Web (Flutter handles platform detection)
    return web;
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDchTBylqc5D64VzXShpTQsGv-cUsku_w0',
    appId: '1:659910513148:web:f2f82c1a88872c79f06279',
    messagingSenderId: '659910513148',
    projectId: 'freshify-app-5f44c',
    authDomain: 'freshify-app-5f44c.firebaseapp.com',
    storageBucket: 'freshify-app-5f44c.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDchTBylqc5D64VzXShpTQsGv-cUsku_w0',
    appId: '1:659910513148:android:f2f82c1a88872c79f06279',
    messagingSenderId: '659910513148',
    projectId: 'freshify-app-5f44c',
  );
}
