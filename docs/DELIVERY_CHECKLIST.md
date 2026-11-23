# ADA 5 delivery checklist

Prepared November 23, 2026. This file separates local verification from evidence that still needs a configured mobile device and external accounts. Do not submit unchecked items as completed.

## Hito 1 — due November 24

| Evidence | Status | Capture or action |
| --- | --- | --- |
| Repository link | Pending | This local repository has no Git remote. Choose the final repository name, publish under the owner's account, and verify the link. |
| Credentials absent from Git | Locally checked | Ignored Firebase and platform files are not tracked. Repeat the filename/content audit before publishing. |
| Three commits on three distinct days | Pending | The twelve commits preceding this phase are all dated November 18. This November 23 delivery-readiness commit establishes a second day; a third distinct day is still required. Do not alter commit dates to satisfy the rubric. |
| Registration with institutional address and password rules | Code and widget checks only | On a configured Android device, record valid registration, invalid domain, weak password, duplicate account, and return to login. Hide account details. |
| Generic login failure and Rive bear | Code and widget checks only | Record invalid credentials, loading/failure animation, successful login, and navigation. |
| Password recovery | Code only | Use a controlled test account and record receipt of the recovery email without exposing the reset link. |
| Ten products with category | PostgreSQL API verified November 18 | Record the API count and a mobile catalog screen backed by PostgreSQL. Check persistence after backend restart. |
| Sign-out | Code only | Record the logout action and that the catalog cannot be reached afterward. |
| Teams submission and review | Pending | Send the verified repository and evidence links on November 24. Record the November 25 in-person review after it happens. |

## Hito 2 — due December 1

| Evidence | Status | Capture or action |
| --- | --- | --- |
| Public Supabase `productos` bucket and product images | Pending | Create the bucket, upload images, store public HTTPS URLs, and record bucket plus mobile evidence. |
| Image, category, price, stock cards; search/filter | Code and widget checks only | Record actual images, fallback, search, filter, and no-results behavior on device. |
| Product GET, POST, PUT, DELETE and Retry | Backend and widget checks only | Demonstrate each action on device, confirm persistence after restart, and stop/restart backend to prove Retry. |
| Profile and Google Sign-In | Code only | Configure Firebase provider and platform OAuth; demonstrate login, profile, and logout on device. |
| Assistant, voice search, extra animation | Local tests only | Demonstrate with a real provider key kept on the server, microphone permission and recognized product name, and visible animation. Claim optional points only after this evidence exists. |
| Invoice integration | Awaiting scope | Confirm internal receipt versus stamped CFDI before implementation. |
| Four later commits across three later days | Pending | Audit dates after Hito 1. The November 18 baseline contains twelve commits; this November 23 phase starts a second date. |
| Final video, repository, bucket, Teams, review | Pending | Verify links and video by December 1; record the December 2 in-person review separately. |

## Local verification snapshot

- November 23: `flutter test` passed all eight tests after the catalog assistant placement fix, including its new access-path test.
- November 23: targeted `dart analyze` for the changed catalog screen and widget test found no issues.
- November 23: `backend/./gradlew test` passed.
- `flutter analyze` and mobile launch remain dependent on a real local `app/lib/firebase_options.dart`; the repository intentionally does not contain it.
- `flutter devices` found macOS and Chrome, but no connected mobile device. `flutter emulators` found `Flutter_Pixel_API_36`, which still needs Firebase configuration before an acceptance run.
- `git remote -v` returned no remote. The twelve commits before this phase were all dated November 18; verify the November 23 commit and second distinct date after committing.

## Teams message draft — Hito 1

Replace bracketed fields only with verified evidence before sending:

> ADA 5 — Hito 1
>
> Repositorio: [verified GitHub URL]
>
> Evidencia móvil: [video or image folder URL]
>
> La demostración incluye registro, acceso con error genérico y animación, recuperación de contraseña, cierre de sesión y catálogo PostgreSQL con al menos diez productos y categoría.
>
> Integrante: Diego Ramírez Magaña.

The message is a draft. Its feature sentence must be shortened if any device criterion remains unverified at submission time.
