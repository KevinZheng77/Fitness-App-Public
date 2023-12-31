// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        return macos;
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
    apiKey: 'AIzaSyAEp0AHlB21x2Affiwl2AAGVFItGWMvpJ4',
    appId: '1:987978474104:web:25eb87fe054150b61c438d',
    messagingSenderId: '987978474104',
    projectId: 'fitnessapp-kevin-jenna',
    authDomain: 'fitnessapp-kevin-jenna.firebaseapp.com',
    storageBucket: 'fitnessapp-kevin-jenna.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBCw4XsaX2ix0BQqUmGuNQmkqiuJaqcYHY',
    appId: '1:987978474104:android:76b6da55128e6e181c438d',
    messagingSenderId: '987978474104',
    projectId: 'fitnessapp-kevin-jenna',
    storageBucket: 'fitnessapp-kevin-jenna.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAKKdqFFZeyVF_djnWhXUouHDwduEOu_Zs',
    appId: '1:987978474104:ios:3b8f1413d42968681c438d',
    messagingSenderId: '987978474104',
    projectId: 'fitnessapp-kevin-jenna',
    storageBucket: 'fitnessapp-kevin-jenna.appspot.com',
    iosClientId: '987978474104-b5vieleanofbhh9h4m1ejgh1rv5vpn6j.apps.googleusercontent.com',
    iosBundleId: 'com.example.myProjectApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAKKdqFFZeyVF_djnWhXUouHDwduEOu_Zs',
    appId: '1:987978474104:ios:3b8f1413d42968681c438d',
    messagingSenderId: '987978474104',
    projectId: 'fitnessapp-kevin-jenna',
    storageBucket: 'fitnessapp-kevin-jenna.appspot.com',
    iosClientId: '987978474104-b5vieleanofbhh9h4m1ejgh1rv5vpn6j.apps.googleusercontent.com',
    iosBundleId: 'com.example.myProjectApp',
  );
}
