# ADA 5 delivery checklist

Prepared November 23, 2026. This file separates local verification from evidence that still needs a configured mobile device and external accounts. Do not submit unchecked items as completed.

## Hito 1 — due November 24

| Evidence | Status | Capture or action |
| --- | --- | --- |
| Repository link | Published | Public repository under the owner's account. [ADA5-JefeFinal](https://github.com/epinki07/ADA5-JefeFinal) |
| Credentials absent from Git | Verified | The Android Firebase download and generated local build configuration are ignored and do not appear in the public repository. |
| Three commits on three distinct days | Pending | The twelve commits preceding this phase are all dated November 18. This November 23 delivery-readiness commit establishes a second day; a third distinct day is still required. Do not alter commit dates to satisfy the rubric. |
| Registration with institutional address and password rules | Android local demo verified | Captured the form validation and checked successful registration and return to login. Verify with the owner's Firebase project. |
| Generic login failure and Rive bear | Android local demo verified | Captured the Rive login screen and generic wrong-password message. |
| Password recovery | Android local demo verified | The Auth Emulator generated a reset code. Use a controlled real account to verify inbox delivery without exposing the link. |
| Ten products with category | Android and PostgreSQL API verified | Captured product categories on Android and saved the API response with ten products. Phase 03 recorded persistence across a backend restart. |
| Sign-out | Android local demo verified | Captured the return to login and verified that Back does not reopen the catalog. |
| Teams submission and review | Pending | Send the verified repository and evidence links on November 24. Record the November 25 in-person review after it happens. |

## Hito 2 — due December 1

| Evidence | Status | Capture or action |
| --- | --- | --- |
| Public Supabase `productos` bucket and product images | Pending | Create the bucket, upload images, store public HTTPS URLs, and record bucket plus mobile evidence. |
| Image, category, price, stock cards; search/filter | Android and PostgreSQL verified | Ten bundled images loaded through the API. Android displayed the cards, filtered by name and category, and kept the existing image fallback. |
| Product GET, POST, PUT, DELETE and Retry | Android and PostgreSQL verified | Created, edited, and deleted a temporary product with API readbacks. Airplane mode triggered the friendly error; Retry recovered the catalog after reconnection. |
| Profile and Google Sign-In | Profile verified with Firebase Auth Emulator | Android displayed account email, UID, and creation date. Real Google OAuth requires the updated Android Firebase config and device test. |
| Assistant, voice search, extra animation | Local tests only | Demonstrate with a real provider key kept on the server, microphone permission and recognized product name, and visible animation. Claim optional points only after this evidence exists. |
| Sales and internal receipt | Android and PostgreSQL verified | Recorded `V-00001` for MXN 29.00, confirmed stock deductions, and reopened the receipt from the history. |
| Four later commits across three later days | Pending | Audit dates after Hito 1. The November 18 baseline contains twelve commits; this November 23 phase starts a second date. |
| Final video, repository, bucket, Teams, review | Local Android demo recorded | Public source and local Android video are available. Hosted image and Google sign-in evidence, Teams submission, and the in-person review remain pending. |

## Local verification snapshot

- November 23: rebuilt the Android ARM64 demo APK and opened the Rive login screen on the API 36 emulator. The demo uses the local Firebase Auth Emulator.
- November 23: reran all 10 Flutter and 13 Spring Boot tests. Targeted Dart analysis passed for the demo entry point, shared app, screens, API client, and tests.
- November 23: loaded ten products across three categories into a fresh PostgreSQL database and verified `GET /products`. Reapplying the seed inserted zero rows.
- November 23: `flutter test` passed all ten tests after adding catalog create/edit/delete widget checks, including the assistant access-path test.
- November 23: targeted `dart analyze` for the changed catalog screen and widget test found no issues.
- November 23: `backend/./gradlew test` passed.
- Full `flutter analyze` passed without credentials. The Firebase Android setup script consumed the registered app file and generated ignored compile-time settings. The local version uses Firebase Auth Emulator.
- Local Android checks use `Flutter_Pixel_API_36`. Real-account verification requires the owner's Firebase project configuration.
- The owner registered the Android app in Firebase and supplied the client configuration. The APK compiled against the real project. Authentication check indicated that providers were still pending activation.
- The repository is public. The verified history contains two distinct commit days, November 18 and November 23.

## Teams message draft — Hito 1

Replace bracketed fields only with verified evidence before sending:

> ADA 5 — Hito 1
>
> Repositorio: https://github.com/epinki07/ADA5-JefeFinal
>
> Evidencia móvil: [video or image folder URL]
>
> La demostración incluye registro, acceso con error genérico y animación, recuperación de contraseña, cierre de sesión y catálogo PostgreSQL con al menos diez productos y categoría.
>
> Integrante: Diego Ramírez Magaña.

The message is a draft. Its feature sentence must be shortened if any device criterion remains unverified at submission time.

The Hito 1 package contains the source, six Android captures, and the ten-product API response. The recovery capture documents the local Firebase Auth Emulator flow. Production inbox delivery remains open.
