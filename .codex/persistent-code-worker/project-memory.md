# Persistent Code Worker Memory

## Project

- Name: ADA5-JefeFinal
- Root: /Users/diegoramirezmagana/ADA5/ADA5-JefeFinal
- Started: 2026-11-18 21:29 UTC
- Last Updated: 2026-11-23 (local date)

## Current Assignment

Build the ADA5 Flutter mobile project with Firebase, Spring Boot, PostgreSQL, Supabase images, full rubric and optional extras; document every change in English.

## Success Criteria

- [ ] Implement the requested behavior
- [ ] Verify the change with appropriate checks
- [ ] Review the diff and remove partial scaffolding
- [ ] Hand off with risks and blockers clearly stated

## Constraints

- Follow every mandatory and optional ADA5 rubric item; do not invent missing facts.
- Document each integration change in English.
- Use the owner's Git identity; do not add collaborators.
- Keep the source clones unchanged.

## Important Files

- `app/lib/main.dart`, `app/lib/screens/login_screen.dart`, `app/lib/screens/products_screen.dart`
- `backend/src/main/java/mx/edu/tecdesoftware/market_backend/persistence/web/controller/ProductController.java`
- `backend/src/main/java/mx/edu/tecdesoftware/market_backend/persistence/entity/Producto.java`
- `docs/RUBRIC_TRACE.md`, `docs/SOURCE_INVENTORY.md`, `CHANGELOG.md`
- `docs/PHASE_PLAN.md`, `docs/PHASE_LOG_TEMPLATE.md`, `docs/phase-logs/00-baseline.md`

## Architecture Notes

- Flutter calls the market backend at `/products`; Firebase authenticates in the client.
- The market backend has product/purchase domain layers and can run with H2 locally; the assignment requires PostgreSQL data.
- The billing API is a separate Spring Boot application with an invoice model; merging it requires a deliberate boundary.

## Decisions

- Consolidate the existing Flutter and market backend projects as the first compatible baseline.
- Keep the billing and WebTrack repositories as references until the product flow is complete.

## Open Questions

- Final repository name; `ADA5-JefeFinal` is the reversible working name.
- Google account eligibility and the role of invoices in the final demonstration.

## Active Plan

- Verify that the copied baseline is complete and contains no local secrets.
- Commit the initial documented baseline under the owner's identity.
- Use the market model selected by the owner; resolve the final name before GitHub publication.
- Implement rubric items in dependency order, then optional extras.

## Completed Work

- Added Firebase authentication and operator authorization to the production API, deployment Docker image, Cloudflare configuration, and the iOS bootstrap and signing guide.
- Created `ADA5/sources/` and cloned four relevant repositories.
- Copied the Flutter and market backend baselines into a new local Git repository.
- Wrote English source inventory, rubric trace, decisions, README, and change log.
- Created initial local commit `17caf71` with the owner's configured author identity.
- Created the full phase plan and a per-phase evidence log format before further feature work.
- Added the PostgreSQL runtime profile, an idempotent ten-product seed, registration, password recovery, category display, and a friendly product Retry state. See phase logs 01–03.
- Added `imageUrl` and product PUT through Spring Boot and PostgreSQL, plus Flutter catalog cards, search/filter, and product create/edit/delete UI.
- Added Firebase profile/Google Sign-In UI, catalog voice search, and a Gemini shopping-assistant path with a server-only key, bounded live-catalog context, and a dedicated Flutter screen.
- Added an original Lottie loading animation with a reduced-motion fallback for the assistant.

## Validation Log

- The production smoke test verified live Firebase tokens and PostgreSQL with isolated test data. A catalog reader was denied write and sales access. An operator recorded, replayed, and retrieved a sale while stock changed once. Both temporary identities and the database were removed after testing.
- GitHub Actions built and verified the Java container with PostgreSQL. Local Flutter passed analysis and 13 tests. The backend passed 19 tests.
- The current Android demo completed checkout against the updated API on port 8090, reopening the persisted receipt and confirming stock deduction. Wrangler built the container in a dry run, then its local Worker served the health check and product photo from Spring Boot and returned HTTP 401 for anonymous catalog access.
- `flutter test` passed (2 tests).
- `backend/./gradlew test` passed.
- `flutter analyze` reported two issues at `app/lib/main.dart` because `lib/firebase_options.dart` is intentionally untracked and is not yet configured locally.
- Source clones remained clean after consolidation.
- After the login change, `flutter test` passed, `dart analyze lib/screens/login_screen.dart` found no issues, and `dart format --set-exit-if-changed` reported no changes.
- A local PostgreSQL 18.4 test cluster started on port 55432. Spring Boot ran with the `postgres` profile, the seed inserted 10 products, the second seed inserted none, and `GET /products` returned 10 products before and after a backend restart. `./gradlew test` passed.
- `dart analyze` passed for the three identity screens and product screen; `flutter test` passed. Live Firebase and device checks remain pending.
- Shopping-assistant backend tests passed with a fake local provider and endpoint 400/503 checks. A test-context H2 seed collision was resolved by using a separate in-memory database. The full backend suite passed afterward.
- Assistant and animation Dart analysis passed; Flutter tests passed including Lottie asset parsing. Real Gemini and on-device checks remain pending.
- Assistant widget tests passed for question submission, loading/answer display, and provider-unavailable UI. The Flutter suite now has five passing tests.
- Catalog widget tests found and fixed a Retry `setState` callback returning a `Future`. Search, category filtering, error, and recovery checks now pass; the Flutter suite has seven passing tests.

## Risks And Blockers

- Theme cannot be inferred from the public repositories: the market seed is grocery while the billing API is financial.
- Android/iOS Firebase setup and a live PostgreSQL database require local credentials/configuration.
- WebTrack's published repository does not contain its source implementation.
- Full Flutter static analysis and device execution require the owner's real Firebase configuration. Do not add fake values or commit the local file.
- The Gemini assistant requires a server-side owner API key for a real provider test. The backend assistant and product mutation endpoints require Firebase authorization before public deployment.
- The owner chose the market model despite not recalling the previous semester's theme. Rubric compliance for that theme remains unverified, but implementation can proceed.

## Restart Notes

- Source clones are under `ADA5/sources/` and should remain unchanged.
- The integration repository is `ADA5/ADA5-JefeFinal/` pending the owner's final name.
- Continue phase 7 mobile validation after Firebase configuration, then phase 8 invoice integration. Do not claim rubric completion from source inspection alone.
- Follow `docs/PHASE_PLAN.md` and create the next phase log before changing code.
- On November 23, fixed the assistant action being inside the delete dialog; it is now in the catalog toolbar. Eight Flutter tests, targeted Dart analysis, and backend tests pass. See `docs/phase-logs/09-delivery-readiness.md`.
- `docs/DELIVERY_CHECKLIST.md` now tracks Hito 1/Hito 2 evidence and an unsent Teams draft. No Git remote exists, all twelve commits before this phase are dated November 18, and device acceptance remains open without real Firebase configuration. The Android emulator `Flutter_Pixel_API_36` is available but was not used for acceptance. Verify the November 23 commit after it is created.
- Owner clarification is pending on final repository name and whether invoices mean internal receipts or stamped CFDI. Continue independent work, then update the checklist and publication links once answers arrive.
- A November 23 follow-up added catalog widget coverage for create, edit, cancel/delete, request payloads, and refresh. The full Flutter suite now has ten passing tests; see `docs/phase-logs/05-catalog-crud.md`. The device and PostgreSQL combined acceptance path is still open.
- Phase 10 adds `app/lib/main_demo.dart` and `firebase.json` for an Android demo using the local Firebase Auth Emulator. Main and demo share the same Flutter UI. Built the ARM64 APK, ran the 10 Flutter and 13 backend tests, and verified ten products in fresh PostgreSQL. Android API 36 passed registration, invalid and valid login, local recovery, catalog and sign-out. The files in `ADA5/Entrega_Hito1/` include a source ZIP, PDF with six Android captures, and a separate APK. Production Firebase delivery, publication, and the third commit day are still open. See `docs/phase-logs/10-hito1-demo.md` for results.
- Added Flutter sale entry, receipt, and history screens. Spring Boot now saves sales and stock changes atomically in PostgreSQL with locked inventory, decimal amounts, and idempotent requests. All 10 Flutter and 16 Spring Boot tests pass. A separate PostgreSQL run verified concurrent stock handling and persistence after restart. See `docs/phase-logs/08-invoices.md`.
- Android API 36 registered `V-00001` for MXN 29.00 and reopened it from history. The product API confirmed stock deductions. The owner requested public publication and the repository is available at `https://github.com/epinki07/ADA5-JefeFinal`. Local sales evidence and updated binaries are in `ADA5/Entrega_ADA5/`.
- Added ten generated catalog photos, repeatable PostgreSQL assignment, and a documented path to the public Supabase bucket. Local API and Android verified the photo cards, search, category filter, and profile. No Supabase CLI account was active.
- Added a Firebase Android converter and compile-time options so full Flutter analysis passes on an unconfigured checkout. The owner registered the Android package in Firebase and supplied its local client file. The first downloaded file has no Google OAuth client, and the initial Firebase Identity Toolkit check returned `CONFIGURATION_NOT_FOUND`. Finish provider enablement, reload the updated Android client file, and verify a controlled real mailbox and Google Play sign-in when those are available.
- Recorded a 41-second Android video with catalog photos, search/filter, profile, and the saved internal receipt. Android created, edited, and deleted a temporary product and verified each result in PostgreSQL. Airplane mode triggered the friendly error and Retry restored the catalog. Evidence is under `ADA5/Entrega_ADA5/evidencia-hito2/`.
- The owner enabled Email/Password and Google in the registered Firebase project. The live Android build signed in through Firebase with a temporary Email/Password user, opened the catalog and matched the UID in Settings. The account was removed after verification. Google requires the refreshed local Android config and a Google Play-enabled device. Real password recovery still requires an owned test mailbox.
- The live Firebase Android build also verified registration through the form with a temporary institutional-domain account, the generic message for a wrong password, and subsequent successful sign-in. The temporary registration was cleaned up.
- Firebase Identity Toolkit returned the project's Google OAuth web client. It is stored in the ignored Android build options. The Firebase Android fingerprint and the Google account sign-in still require verification. Started downloading the Google APIs system image for a separate Android emulator.
- The owner explicitly authorized a single password recovery email. The live Firebase Android build sent the request and the owner confirmed receipt. No mailbox address or reset link was written to the repository. The recovered Android Google APIs image was verified against the official SDK checksum and installed for the `ADA5_Google_API_36` virtual device.
- The local APK opened the Google account chooser on `ADA5_Google_API_36` (ADB port 5556). User interaction is required to complete the account sign-in and verify the catalog redirect.
