# ADA 5 Flutter app

This app provides Firebase email/password registration, login, recovery, Google sign-in, a product catalog with search and CRUD, and sales with internal receipts and history. It also has profile settings, voice search, and an optional shopping assistant. The Spring Boot API lives in `../backend/`.

## Android with a Firebase project

1. In Firebase Project Settings, register the Android application ID `com.example.login_rive_animation`. From `android/`, run `./gradlew signingReport` and add the debug SHA-1 and SHA-256 fingerprints in Firebase. Use the signing fingerprints for the build that will run on the test device.
2. Enable the Email/Password and Google providers in Firebase Authentication. Download the updated Android `google-services.json` after enabling Google.
3. From this directory, run `python3 tool/configure_firebase_android.py /path/to/google-services.json`. The script writes the ignored `firebase.android.local.json` and reads the web OAuth client ID used by Android Google Sign-In.
4. Start Spring Boot and PostgreSQL with the root README instructions. Run `flutter pub get` and `flutter run --dart-define-from-file=firebase.android.local.json` on an Android device with Google Play services. The Android emulator uses `http://10.0.2.2:8090`. For a USB-connected phone, run `adb reverse tcp:8090 tcp:8090` and pass `--dart-define=API_BASE_URL=http://127.0.0.1:8090` for a debug build.

Verify registration with an institutional test mailbox, request a reset and check the inbox, then sign in with Google and open the profile. Keep downloaded and generated Firebase configuration files local.

The optional assistant calls `POST /assistant` through the backend. Set `GEMINI_API_KEY` only in the backend environment to enable a real provider response. The catalog remains usable without this key.

## Android demonstration with local Firebase

Use an Android Studio emulator, PostgreSQL, Java, Flutter, and Node.js. Start the backend with the PostgreSQL profile on port 8090 and apply `backend/sql/seed-postgres.sql` as described above. Then run these commands in separate terminals:

```sh
# Repository root
npx --yes firebase-tools@15.37.0 emulators:start --only auth --project demo-ada5
```

```sh
# app/
flutter pub get
flutter run --target lib/main_demo.dart
```

The demo uses Firebase Authentication's local emulator on port 9099. Register a fictitious account with the institutional domain and enter the same credentials at login. The emulator prints recovery links in its local console. Use the standard `lib/main.dart` entry point and a configured Firebase project to verify delivery to a real inbox and Google sign-in.

From the product list, tap **Ventas**, then **Nueva venta**. Choose quantities and a payment method. Register the sale to see its receipt, then return to the history and reopen it. The catalog refreshes stock when you return to it.

## iOS

The local demo also runs with `flutter run --target lib/main_demo.dart` on an iOS simulator with Xcode. Use the same PostgreSQL, API, and Firebase Auth Emulator processes on the Mac. The simulator connects to the Mac on `127.0.0.1:8090` for the API and `localhost:9099` for authentication. See the [deployment guide](../docs/DEPLOYMENT.md#android-and-ios-builds) for production Firebase, signing, and TestFlight.

## Checks

Run `flutter test` and `flutter analyze` from this directory. The real Firebase configuration is supplied at build time.

## Delivery

Use `../docs/RUBRIC_TRACE.md` for requirement status and `../docs/DELIVERY_CHECKLIST.md` for the evidence and submission package. Do not include Firebase options, service keys, database passwords, or test-account passwords in the repository or video.
