# ADA 5 Flutter app

This app provides Firebase email/password registration, login, recovery, Google sign-in, a product catalog with search and CRUD, profile settings, voice search, and an optional shopping assistant. The Spring Boot API lives in `../backend/`.

## Local setup

1. Set up the owner's Firebase project for the intended Android or iOS app. Enable Email/Password and Google under Firebase Authentication. Register the app's actual package/bundle ID and complete the platform-specific Google sign-in configuration. The current Android application ID is `com.example.login_rive_animation`; change it deliberately in both Firebase and the project if a final ID is chosen.
2. Provide `lib/firebase_options.dart` locally. `lib/firebase_options.example.dart` shows the shape expected by `main.dart`, but its values are placeholders. Use options for the registered app and keep the real file ignored by Git. Google sign-in also needs the platform configuration required by Firebase/Google Sign-In; the Dart options file alone does not complete that setup.
3. Start `../backend/` with `./gradlew bootRun` for local H2, or configure `DB_URL`, `DB_USER`, and `DB_PASSWORD` and start it with `./gradlew bootRun --args=--spring.profiles.active=postgres` for the ADA 5 PostgreSQL path. Apply `../backend/sql/seed-postgres.sql` after the PostgreSQL schema exists.
4. Run `flutter pub get` and `flutter run` from this directory. The Android emulator uses `http://10.0.2.2:8090`. For a physical phone on the same network, pass `--dart-define=API_BASE_URL=http://HOST_IP:8090`.

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

## Checks

Run `flutter test` for local widget tests. Run `flutter analyze` after providing the local Firebase options file. A successful widget suite does not verify Firebase providers, microphone permissions, image hosting, or mobile network behavior; those need device checks recorded in `../docs/DELIVERY_CHECKLIST.md`.

## Delivery

Use `../docs/RUBRIC_TRACE.md` for requirement status and `../docs/DELIVERY_CHECKLIST.md` for the evidence and submission package. Do not include Firebase options, service keys, database passwords, or test-account passwords in the repository or video.
