# Phase 06 — profile and Google Sign-In

## Status and scope

- Status: in progress
- Starting commit: `42c0021`
- Rubric items: Settings profile, logout, Google Sign-In with Rive flow
- Expected behavior: authenticated users can inspect their Firebase profile and sign out; Google users reach the catalog on mobile.

## Source movement and changes

| Source | Destination | Change | Reason |
| --- | --- | --- | --- |
| Existing catalog and login | Flutter screens | Add Settings navigation and Google identity flow | Meet Hito 2 identity requirements |
| New Settings screen | `app/lib/screens/settings_screen.dart` | Shows Firebase profile fields and sign-out | Place the rubric profile badge inside Settings |
| Official Google package | `app/pubspec.yaml`, `app/pubspec.lock`, and Login | Added `google_sign_in` 7.2.0 and connected Google credential to Firebase | Use current mobile authentication API |

## Verification and failure path

- Use the official `google_sign_in` 7.x initialization/authentication API and Firebase credential flow.
- Run targeted Dart analysis and Flutter tests after code changes.
- Live Google flow requires the owner's Firebase provider, Android SHA-1, and platform configuration; it cannot be marked verified without a device sign-in.
- Targeted Dart analysis passed for Login, Catalog, and Settings. Existing Flutter tests passed.
- Reference: https://firebase.google.com/docs/auth/flutter/federated-auth and https://pub.dev/packages/google_sign_in

## Exit gate

- [ ] Profile fields and logout work for email and Google accounts on mobile
- [ ] Google sign-in triggers the bear and reaches the catalog on mobile
- [ ] Error and cancellation paths are handled without a crash
