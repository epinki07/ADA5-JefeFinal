# Change log

## 2026-11-23 — Phase 10: Hito 1 demonstration

- Added an Android demonstration entry point that uses the Firebase Auth Emulator and shares the normal Flutter screens.
- Rechecked Flutter and Spring Boot tests. Verified ten products across three PostgreSQL categories and confirmed that a second seed run added zero rows.
- Built the ARM64 APK and checked registration, the generic login error, local password recovery, catalog categories, and sign-out on Android API 36.

## 2026-11-23 — Phase 9: delivery readiness

- Moved the shopping assistant action to the catalog toolbar. It had accidentally been placed inside the delete confirmation; added a widget test for access and dialog contents.
- Replaced the inherited ADA 4 app README with ADA 5 setup, checks, and delivery guidance; clarified that Firebase options must match the registered platform app.
- Added a Hito 1/Hito 2 delivery checklist with real evidence status, Git-date and remote audits, and an unsent Teams message draft.
- Passed all eight Flutter tests, targeted Dart analysis, backend tests, and `git diff --check`. Device acceptance remains open because real Firebase configuration and mobile execution are not yet available.
- Added catalog widget checks for create, edit, cancel/delete, request payloads, and refresh. All ten Flutter tests and targeted Dart analysis passed; mobile persistence remains unverified.

## 2026-11-18 — Phase 0: source consolidation

- Created the `ADA5` workspace and cloned the original Flutter, market backend, billing API, and WebTrack showcase repositories into `ADA5/sources/`.
- Created this separate local repository with `app/` copied from `login_river_animation` at `9cd4eafb92b657b315fbd9cd284aedddbc020713`.
- Copied `backend/` from `market-backend-2026-3-b` at `148da49860a749ce3b098f096c303c350abfdab6`.
- Kept `SistemaFacturacion` at `67219dd43a1451584d4f63024c5ad278f8278920` and `webtrack-2` at `e7c9161f2bab07faba0bd72ed699d6faac039957` as read-only source references. Their code has not been merged.
- Added repository documentation, requirement traceability, project memory, and a monorepo ignore file.
- Adjusted the backend ignore rules so its safe default `application.properties` and Gradle wrapper configuration are included while local credentials remain ignored.
- Verified the copied baseline: Flutter unit tests and Spring Boot tests pass. Flutter static analysis stops at the intentionally untracked Firebase configuration file; no placeholder credentials were invented.
- Removed three inherited whitespace issues found during the first staged diff review.
- Clarified that Gradle must be run from the backend directory.
- Recorded the owner's decision to use the existing market product model and PostgreSQL path as the submission baseline; retained the previous-theme requirement as an explicit grading risk.
- Refactored the Flutter login to check only empty fields and display a single global authentication error while preserving the Rive success/failure triggers, loading state, and catalog navigation.
- Added a full phased development plan covering all mandatory rubric items, all three extra-credit items, invoice integration, failure handling, verification gates, and delivery evidence.
- Added a reusable phase log template and a Phase 00 log documenting source movement and actual baseline checks.
- Added an environment-based PostgreSQL profile and an idempotent ten-product seed; expanded the H2 sample catalog to ten products. Verified Spring Boot startup and `GET /products` against local PostgreSQL, repeated the seed without duplicates, and passed backend regression tests.
- Restarted the backend and confirmed that the PostgreSQL catalog still returns ten products.
- Added Flutter registration and password-reset screens, connected both from Login, and preserved the rubric's return-to-Login behavior after Firebase creates a session. Targeted Dart analysis and existing Flutter tests passed; live Firebase delivery remains unverified.
- Updated the Flutter product list to show category and stock, treat an empty API response as an empty list, and show a friendly Retry state without raw exception details.
- Added `imageUrl` across the product entity, domain model, mapper, request DTO, and controller, plus a product PUT path that preserves existing barcode data. Verified PUT/GET persistence and missing-ID 404 against local PostgreSQL; backend tests passed.
- Moved Flutter HTTP logic into `app/lib/product_api.dart`, replaced the product list with image cards, search/category filters, create/edit/delete controls, and a validated product form. Added `GET /categories` so creation still works when there are no active products. Dart analysis, Flutter tests, backend tests, and local PostgreSQL API checks passed; mobile UI acceptance remains pending.
- Added a Settings screen with Firebase profile details and sign-out. Added the official Google Sign-In package and connected its current authentication flow to Firebase and the existing Rive success navigation. Targeted Dart analysis and Flutter tests passed; real mobile OAuth remains pending owner configuration.
- Added voice search using `speech_to_text` 7.5.0. Moved recognized words into the existing catalog filter, added Android/iOS permission declarations, and passed Dart analysis and Flutter tests. Microphone and permission behavior still needs mobile verification.
- Selected Gemini Interactions API for the shopping assistant after owner delegation. Added a server-only key setting, bounded live-catalog context, `POST /assistant`, provider response parsing and failure handling, and a Flutter assistant screen reachable from the catalog. Backend tests with a local fake provider and endpoint checks, targeted Dart analysis, and Flutter tests passed. A real Gemini call and mobile acceptance remain pending.
- Added an original Lottie pulse to the assistant loading state and a static fallback for reduced-motion users. The asset parses successfully, and targeted Dart analysis and Flutter tests pass; mobile visual acceptance remains pending.
- Added assistant widget tests for question submission, loading/answer display, and the provider-unavailable state; all five Flutter tests passed.
- Audited the original billing API's invoice header, line, tax, service, and controller contracts. Documented a single-backend PostgreSQL integration boundary and requested clarification on internal receipts versus stamped CFDI before moving invoice code.
- Added catalog widget tests for name/category filtering and stopped-server Retry. The Retry test found and drove a fix for a `setState` callback that returned a `Future`; all seven Flutter tests now pass.
