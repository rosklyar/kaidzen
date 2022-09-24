// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
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
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'xxxxxxxxxxxxxxxxxxx',
    appId: 'xxxxxxxxxxxxxxxxxxx',
    messagingSenderId: 'xxxxxxxxxxxxxxxxxxx',
    projectId: 'xxxxxxxxxxxxxxxxxxx',
    authDomain: 'xxxxxxxxxxxxxxxxxxx',
    databaseURL: 'xxxxxxxxxxxxxxxxxxx',
    storageBucket: 'xxxxxxxxxxxxxxxxxxx',
    measurementId: 'xxxxxxxxxxxxxxxxxxx',
  );

  static const FirebaseOptions android = FirebaseOptions(
      apiKey: 'AIzaSyAAYWVJlw1FwcK4xSP-h5I5ognv4x4mxNw',
      appId: '1:16476665240:android:7581584637f0ff9bca67ed',
      messagingSenderId: '16476665240',
      projectId: 'funworkstudiostickygoals');

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBm1T3lKjA_QjO7mTo8gXj3wAPS5BU52NI',
    appId: '1:16476665240:ios:47141ce7e0307437ca67ed',
    messagingSenderId: '16476665240',
    projectId: 'funworkstudiostickygoals',
    storageBucket: 'funworkstudiostickygoals.appspot.com',
    iosClientId:
        '16476665240-ih9fnn4ufva7ebqsqoq6s9gurvme73ik.apps.googleusercontent.com',
    iosBundleId: 'com.funworkstudio.stickygoals.ios',
  );
}
