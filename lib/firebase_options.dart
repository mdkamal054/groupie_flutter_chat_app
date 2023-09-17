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
    apiKey: 'AIzaSyCFLFmdtQxk2ozH8zWMMUhPe3HfDydqv-M',
    appId: '1:875190730215:web:00e74ed621ce6a76371142',
    messagingSenderId: '875190730215',
    projectId: 'groupiechatapp-8fbdf',
    authDomain: 'groupiechatapp-8fbdf.firebaseapp.com',
    storageBucket: 'groupiechatapp-8fbdf.appspot.com',
    measurementId: 'G-CKE03GC029',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBUJuTx6bsF5z-9x0BDSjtG0mSBIX66EBo',
    appId: '1:875190730215:android:96c5bdd9a7fb476a371142',
    messagingSenderId: '875190730215',
    projectId: 'groupiechatapp-8fbdf',
    storageBucket: 'groupiechatapp-8fbdf.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAFworDP34tJ84VHSi1VurPDQuxPIrdW88',
    appId: '1:875190730215:ios:cd7a910fa2746bd5371142',
    messagingSenderId: '875190730215',
    projectId: 'groupiechatapp-8fbdf',
    storageBucket: 'groupiechatapp-8fbdf.appspot.com',
    iosBundleId: 'com.diginerds.groupieFlutterChatApp',
  );
}
