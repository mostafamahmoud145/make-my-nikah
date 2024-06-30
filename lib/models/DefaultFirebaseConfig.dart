import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseConfig {
  static FirebaseOptions? get platformOptions {
    if (Platform.isIOS || Platform.isMacOS) {
      // iOS and MacOS
      return const FirebaseOptions(
        appId: '1:778423108071:ios:f3407f294be06d4f7b3d42',
        apiKey: 'AIzaSyA3Zp6J3zG3JgNlTEJgOwkWO7_vjp9z4ns',
        projectId: 'make-my-nikah-d49f5',
        messagingSenderId: '778423108071',
        iosBundleId: 'com.app.MakeMyNikah',
        iosClientId: '778423108071-fparobi7je3ec7dtep7l9ocu8iosonmr.apps.googleusercontent.com',
        androidClientId: '778423108071-757oqrqckukl0reu52q68tnnnav3srq2.apps.googleusercontent.com',
        databaseURL: 'https://make-my-nikah-d49f5-default-rtdb.europe-west1.firebasedatabase.app',
        storageBucket: 'make-my-nikah-d49f5.appspot.com',
      );
    } else {
      // Android
      log("Analytics Dart-only initializer doesn't work on Android, please make sure to add the config file.");

      return null;
    }
  }
}
