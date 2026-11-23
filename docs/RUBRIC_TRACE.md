# ADA5 rubric trace

Statuses: **Present**, **Partial**, **Missing**, **Decision needed**. These describe source inspection, not a runtime acceptance test.

## Milestone 1 — 20 points, due November 24, 2026

| Requirement | Status | Evidence / next action |
| --- | --- | --- |
| Generic login error; retain bear animation, loading, and navigation | Partial | Android API 36 displayed the Rive login and generic error, and opened the catalog after successful login with Firebase Auth Emulator. Production Firebase remains unverified. |
| Registration with institutional email and password rules | Partial | Android displayed form validation and returned to login after creating a test account against Firebase Auth Emulator. Production Firebase remains unverified. |
| Password recovery | Partial | The Android request generated a local Auth Emulator reset code. Real inbox delivery remains unverified. |
| Sign-out | Present | Android returned to login and Back did not reopen the catalog after signing out of the local Firebase session. |
| Previous semester theme and at least 10 products | Partial | PostgreSQL served the owner's selected market catalog with ten products across three categories, and Android displayed the catalog. Previous-theme compliance remains unverified. |
| Show product category | Present | Android displayed category names returned by Spring Boot and PostgreSQL. |
| Keep credentials out of GitHub | Partial | Ignore rules exist; audit tracked files and setup instructions before publication. |
| Mobile evidence and three commits on three different days | Partial | The Hito 1 advance includes six Android captures. Git history covers two distinct days. |

## Milestone 2 — 30 points, due December 1, 2026

| Requirement | Status | Evidence / next action |
| --- | --- | --- |
| `imageUrl` in entity, domain, mapper, database, and Flutter | Partial | Backend entity/domain/mapper/DTO and PostgreSQL round-trip passed; Flutter display and real Supabase URLs remain. |
| Public Supabase product-image bucket | Missing | Requires project configuration and uploaded images. |
| Redesigned catalog with image, category, price, and stock | Partial | Flutter cards and image fallback are implemented and statically analyzed; real image/device evidence remains. |
| Search by name and/or category filter | Partial | Flutter name search and category chips are implemented; device behavior remains unverified. |
| Product GET, POST, PUT, DELETE from Flutter | Partial | Flutter API client and create/edit/delete controls are implemented; backend POST/PUT/DELETE passed against PostgreSQL and widget tests cover create/edit/delete plus refresh. Mobile UI verification remains. |
| Friendly network error with Retry | Partial | The raw exception was replaced with a friendly message; stopped-server device verification remains. |
| Settings screen with user profile and sign-out | Partial | Settings shows email, photo/avatar, UID, creation date, and sign-out; device verification remains. |
| Google Sign-In on a mobile device | Partial | Official `google_sign_in` 7.2.0 flow is wired to Firebase and the Rive success path; provider/platform setup and device sign-in remain. |
| Mobile video, bucket evidence, four more commits across three later days | Missing | Complete after the app works on device. |

## Optional extra credit — up to 11 points

| Requirement | Points | Status |
| --- | ---: | --- |
| Catalog-aware shopping assistant | 6 | Partial: Flutter screen reachable from the catalog toolbar, Spring Boot endpoint, current-catalog context, and failure handling are implemented; tests use a local fake provider. A real key, provider call, and device demonstration remain. |
| Voice search or visual scanner | 3 | Partial: voice search is wired to catalog search and statically analyzed; mobile microphone verification remains. |
| Additional Rive or Lottie animation | 2 | Partial: an original Lottie pulse is shown while the assistant is answering, with a reduced-motion static fallback; asset parsing and Dart analysis passed, but mobile visual verification remains. |

## Acceptance rule

Mark a requirement complete only after code review and a successful on-device demonstration. Screenshots, Git history, and Teams submissions are separate delivery artifacts.

Use [the delivery checklist](DELIVERY_CHECKLIST.md) to track evidence and submission links. The twelve commits preceding the November 23 delivery-readiness phase are dated November 18, and the local repository has no remote.
