import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appType = kIsWeb
      ? 'web'
      : defaultTargetPlatform == TargetPlatform.iOS
      ? 'ios'
      : 'android';
  await Firebase.initializeApp(
    options: FirebaseOptions(
      // Firebase Installations checks the key's format on iOS before Auth uses the emulator.
      apiKey: 'A00000000000000000000000000000000000000',
      appId: '1:1:$appType:1',
      messagingSenderId: '1',
      projectId: 'demo-ada5',
    ),
  );
  await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  runApp(const MainApp());
}
