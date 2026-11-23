import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'local-auth-emulator',
      appId: '1:1:android:1',
      messagingSenderId: '1',
      projectId: 'demo-ada5',
    ),
  );
  await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  runApp(const MainApp());
}
