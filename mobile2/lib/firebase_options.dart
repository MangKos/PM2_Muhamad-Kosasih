import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyD9zG8QZBsC970ra7brwoa0KXznWJcsjGw',
    appId: '1:974422184616:web:5110cd93fc4abf7f10689d',
    messagingSenderId: '974422184616',
    projectId: 'sahabat-bugar',
    authDomain: 'sahabat-bugar.firebaseapp.com',
    storageBucket: 'sahabat-bugar.firebasestorage.app',
    measurementId: 'G-XXXXXXXXXX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD9zG8QZBsC970ra7brwoa0KXznWJcsjGw',
    appId: '1:974422184616:android:5110cd93fc4abf7f10689d',
    messagingSenderId: '974422184616',
    projectId: 'sahabat-bugar',
    storageBucket: 'sahabat-bugar.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD9zG8QZBsC970ra7brwoa0KXznWJcsjGw',
    appId: '1:974422184616:ios:5110cd93fc4abf7f10689d',
    messagingSenderId: '974422184616',
    projectId: 'sahabat-bugar',
    storageBucket: 'sahabat-bugar.firebasestorage.app',
    iosBundleId: 'com.example.sahabatBugar',
  );
}
