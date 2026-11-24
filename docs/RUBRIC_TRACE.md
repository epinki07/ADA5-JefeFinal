# ADA5 rubric trace

Statuses: **Present**, **Partial**, **Missing**, **Decision needed**. These describe source inspection, not a runtime acceptance test.

## Milestone 1 — 20 points, due November 24, 2026

| Requirement | Status | Evidence / next action |
| --- | --- | --- |
| Generic login error; retain bear animation, loading, and navigation | Present | Android API 36 displayed the Rive login and generic error in the local demo. The live Firebase build signed in with email and password and opened the catalog. |
| Registration with institutional email and password rules | Present | Android displayed form validation in the emulator demo and registered an institutional-domain test account against live Firebase. The app returned to login after creating the account. |
| Password recovery | Present | The live Android build requested a reset through Firebase and the owner confirmed receipt in a real inbox. |
| Sign-out | Present | Android returned to login and Back did not reopen the catalog after signing out of the local Firebase session. |
| Previous semester theme and at least 10 products | Partial | PostgreSQL served the owner's selected market catalog with ten products across three categories, and Android displayed the catalog. Previous-theme compliance remains unverified. |
| Show product category | Present | Android displayed category names returned by Spring Boot and PostgreSQL. |
| Keep credentials out of GitHub | Present | The downloaded Android and iOS Firebase files and generated build options are ignored. Public demo releases use the emulator configuration. |
| Mobile evidence and three commits on three different days | Present | The Hito 1 advance includes six Android captures. Git history covers November 18, 23, and 24 in Mérida time. |

## Milestone 2 — 30 points, due December 1, 2026

| Requirement | Status | Evidence / next action |
| --- | --- | --- |
| `imageUrl` in entity, domain, mapper, database, and Flutter | Present | PostgreSQL provided ten image paths, Spring Boot served the WebP files, and Android rendered photos on the catalog cards. Supabase hosting is tracked separately. |
| Public Supabase product-image bucket | Missing | The ADA5 organization exists. The Free project, bucket, and image upload are pending. |
| Redesigned catalog with image, category, price, and stock | Present | Android displayed photos, names, categories, prices, and stock from the PostgreSQL catalog. |
| Search by name and/or category filter | Present | Android verified the Bolillo search and Panaderia selection. Both removed products outside the filter. |
| Product GET, POST, PUT, DELETE from Flutter | Present | Android created a temporary product, edited stock from 6 to 8, and deleted it. API readbacks checked PostgreSQL state after each mobile action. |
| Friendly network error with Retry | Present | Android showed the friendly error in airplane mode and restored the catalog after reconnecting and tapping Retry. |
| Settings screen with user profile and sign-out | Present | Android displayed the emulator account email, avatar, UID and creation date; sign-out was verified in the Hito 1 flow. |
| Google Sign-In on a mobile device | Partial | Google is enabled and its web OAuth client is configured. The local APK opened the Google account chooser on an Android emulator with Google Play services. Completing the account sign-in and returning to the catalog remain open. |
| Mobile video, bucket evidence, four more commits across three later days | Partial | Android video shows photo cards, search, category filtering, profile, and the saved sale receipt. Supabase evidence and later commit dates remain open. |

## Optional extra credit — up to 11 points

| Requirement | Points | Status |
| --- | ---: | --- |
| Catalog-aware shopping assistant | 6 | Partial: Flutter screen reachable from the catalog toolbar, Spring Boot endpoint, current-catalog context, and failure handling are implemented; tests use a local fake provider. A real key, provider call, and device demonstration remain. |
| Voice search or visual scanner | 3 | Partial: voice search is wired to catalog search and statically analyzed; mobile microphone verification remains. |
| Additional Rive or Lottie animation | 2 | Partial: an original Lottie pulse is shown while the assistant is answering, with a reduced-motion static fallback; asset parsing and Dart analysis passed, but mobile visual verification remains. |

## Acceptance rule

Mark a requirement complete only after code review and a successful on-device demonstration. Screenshots, Git history, and Teams submissions are separate delivery artifacts.

Use [the delivery checklist](DELIVERY_CHECKLIST.md) to track evidence and submission links and the [handoff notes](HANDOFF.md) to resume iOS and hosting work.
