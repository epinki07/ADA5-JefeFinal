import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app.dart';

const _apiKey = String.fromEnvironment('FIREBASE_API_KEY');
const _appId = String.fromEnvironment('FIREBASE_APP_ID');
const _senderId = String.fromEnvironment('FIREBASE_SENDER_ID');
const _projectId = String.fromEnvironment('FIREBASE_PROJECT_ID');
const _authDomain = String.fromEnvironment('FIREBASE_AUTH_DOMAIN');
const _iosBundleId = String.fromEnvironment('FIREBASE_IOS_BUNDLE_ID');
const _googleIosClient = String.fromEnvironment('GOOGLE_IOS_CLIENT_ID');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if ([_apiKey, _appId, _senderId, _projectId].any((value) => value.isEmpty)) {
    runApp(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Esta compilación requiere configurar Firebase.'),
          ),
        ),
      ),
    );
    return;
  }
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: _apiKey,
      appId: _appId,
      messagingSenderId: _senderId,
      projectId: _projectId,
      authDomain: _authDomain == '' ? null : _authDomain,
      iosBundleId: _iosBundleId == '' ? null : _iosBundleId,
      iosClientId: _googleIosClient == '' ? null : _googleIosClient,
    ),
  );
  runApp(const MainApp());
}
