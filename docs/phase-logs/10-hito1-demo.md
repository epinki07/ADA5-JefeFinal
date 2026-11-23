# Phase 10 — Hito 1 local demonstration

This phase starts from commit `44588ab`. It adds a credential-free Android demonstration target for the existing Flutter screens, verifies email/password against the Firebase Auth Emulator, and packages source and evidence for Hito 1.

## Verification

| Check | Actual result |
| --- | --- |
| Flutter tests | 10 passed. |
| Demo Dart analysis | Passed for the demo entry point, shared app, screens, API client, and tests. |
| Spring Boot tests | 13 passed on a fresh test run. |
| PostgreSQL and product API | A fresh database contains ten products across three categories. The second seed run inserted zero rows. The API returned all ten. |
| Android build | Debug ARM64 APK built and installed on the API 36 emulator. Opened the Rive login screen. |
| Registration, invalid login, and reset | Android showed institutional email and password validation, returned to login after account creation, and showed one invalid-credentials message. The Auth Emulator recorded a synthetic password-reset code. |
| Successful login and sign-out | Android opened the Spring Boot catalog backed by PostgreSQL, displayed product categories, returned to login after sign-out, and blocked Back navigation to the catalog. |

The local demo uses a synthetic Firebase project via the official Auth Emulator. Production Firebase and real inbox delivery require the owner's account configuration. The source ZIP includes six Android captures, the PostgreSQL response, and a PDF with verified results and open items.
