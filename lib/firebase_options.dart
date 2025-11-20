
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAnKUT0ZqFevHNq4wRrJHrttd2hf-NIEx8',
    appId: '1:15572931540:web:a1539b9e66a48ff9acbc41',
    messagingSenderId: '15572931540',
    projectId: 'keyboardshop-flutter',
    authDomain: 'keyboardshop-flutter.firebaseapp.com',
    storageBucket: 'keyboardshop-flutter.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAH8Gbrp_v49l0pkYSyjLipntWXDNpl2Og',
    appId: '1:15572931540:android:85ce25990c1b5f11acbc41',
    messagingSenderId: '15572931540',
    projectId: 'keyboardshop-flutter',
    storageBucket: 'keyboardshop-flutter.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAbM1xLUyphAq7b7JCmYVbAEqS5ZVkhU28',
    appId: '1:15572931540:ios:0bc576ba8d12470facbc41',
    messagingSenderId: '15572931540',
    projectId: 'keyboardshop-flutter',
    storageBucket: 'keyboardshop-flutter.firebasestorage.app',
    iosBundleId: 'com.example.flutterRendu',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAnKUT0ZqFevHNq4wRrJHrttd2hf-NIEx8',
    appId: '1:15572931540:web:37c39d9ab896bf56acbc41',
    messagingSenderId: '15572931540',
    projectId: 'keyboardshop-flutter',
    authDomain: 'keyboardshop-flutter.firebaseapp.com',
    storageBucket: 'keyboardshop-flutter.firebasestorage.app',
  );

}