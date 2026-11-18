# Full development plan

This plan covers the mandatory 50 points, the three optional challenges worth up to 11 additional points, and the owner's requested invoice integration. It is an execution order, not a claim that unfinished features work. The source of truth for completion is `RUBRIC_TRACE.md` plus a verified phase log.

## Working rules for every phase

1. Record the starting commit, affected files, and expected behavior in `docs/phase-logs/NN-name.md` before moving or editing code.
2. Make one small, reviewable change at a time. Keep `ADA5/sources/` untouched and document any code copied or adapted from it.
3. Check the normal path, one failure path, and the device path when a feature reaches the UI. Record commands, outcomes, and evidence in the phase log.
4. If a check fails, keep the phase open. Record the symptom and reproduction steps, isolate the affected layer, fix it, and repeat the failed check plus nearby regression checks. Do not mark a requirement complete based only on compilation.
5. Update `CHANGELOG.md`, `RUBRIC_TRACE.md`, and project memory after each change. A phase closes only when its exit gate passes and its commit uses the owner's Git identity. Never add a collaborator or bot account.
6. Do not invent Firebase, Supabase, database, Google OAuth, AI-provider, or Teams values. Keep real credentials out of Git. Ask the owner for missing account configuration when the related phase requires it.
7. Record actual commit dates. The rubric requires work on distinct days; multiple commits on one day do not satisfy that rule.

## Phase map

| Phase | Main outcome | Depends on | Deadline gate |
| --- | --- | --- | --- |
| 0. Baseline and audit | Local integration repo, source inventory, traceability | None | Complete locally |
| 1. Runtime and data foundation | Reproducible Flutter/backend startup, PostgreSQL path | 0 | Before Hito 1 acceptance |
| 2. Hito 1 identity | Generic login, registration, recovery, logout | 1 | Before Nov 24 |
| 3. Hito 1 catalog and submission | 10+ products, category, mobile evidence, Git audit | 1–2 | Teams Nov 24; review Nov 25 |
| 4. Hito 2 images and API contract | `imageUrl`, Supabase images, product update endpoint | 3 | Before Hito 2 UI work |
| 5. Hito 2 catalog and CRUD | Mobile cards, search/filter, full product CRUD, network states | 4 | Before Dec 1 |
| 6. Hito 2 identity and profile | Settings profile and Google Sign-In on mobile | 2, 5 | Before Dec 1 |
| 7. All extra-credit features | Assistant, voice search or scanner, added animation | 5–6 | Before Dec 1 if claimed |
| 8. Invoice integration | Billing flow integrated without breaking product rubric | 5–7 | After mandatory acceptance; include by Dec 1 only if verified |
| 9. Final acceptance and delivery | Device demonstration, evidence, repo audit, Teams package | 3–8 | Teams Dec 1; review Dec 2 |

## Phase 0 — Baseline and audit (local setup complete)

- **0.1 Source capture:** Clone Flutter, market backend, billing API, and WebTrack references under `ADA5/sources/`; record source commit SHAs.
- **0.2 Compatible assembly:** Copy Flutter to `app/` and market backend to `backend/`; do not copy the second Spring Boot application into the same runtime yet.
- **0.3 Traceability:** Maintain source inventory, decisions, rubric trace, change log, and phase logs in English.
- **Exit gate:** Clean Git status and passing baseline tests. `flutter analyze` remains limited by the intentionally untracked Firebase configuration. See `phase-logs/00-baseline.md`.

## Phase 1 — Runtime and data foundation

- **1.1 Firebase and device setup:** Configure the owner's real Firebase project locally, email/password provider, Android/iOS app identity, and an emulator or physical device. Keep config files ignored. Test app startup and an existing test login on a mobile device.
- **1.2 PostgreSQL setup:** Keep H2 for fast automated tests; add an explicit PostgreSQL runtime profile or environment configuration. Define schema evolution and seed strategy before changing entities. Test startup, product query, restart persistence, and database connection failure.
- **1.3 Contract snapshot:** Record `/products` request/response JSON, category shape, status codes, and base URL for emulator versus physical phone. Compare with Flutter parsing.
- **Failure branch:** If Firebase setup fails, capture the exact SDK/platform error before changing UI code. If PostgreSQL fails, check connection settings, schema, and seed separately; keep H2 tests passing while diagnosing it.
- **Exit gate:** A mobile device can sign in and read products from Spring Boot backed by PostgreSQL; configuration is reproducible without committing secrets.

## Phase 2 — Hito 1 identity

- **2.1 Login:** Keep the Rive bear success/failure triggers, loading state, and replacement navigation. Only reject empty fields locally; show a generic authentication error. Test valid, invalid, empty, and offline cases on device.
- **2.2 Registration:** Add a screen reachable from Login with institutional email rule, rubric password rules, confirmation, and `createUserWithEmailAndPassword`. Decide how to handle the Firebase session created at sign-up before navigating. Test validation, successful registration, duplicate account, and back navigation.
- **2.3 Password recovery:** Add a reachable form/dialog using `sendPasswordResetEmail`. Test valid submission, malformed address, offline behavior, and receipt with a controlled test account. Show a neutral confirmation for account privacy.
- **2.4 Logout:** Verify Firebase sign-out from the catalog, return to Login, and blocked access to the catalog after sign-out.
- **Failure branch:** If a Firebase operation fails, record its error code privately in the phase log without exposing account existence or credentials in the UI. Recheck the Rive flow after any navigation change.
- **Exit gate:** All four account flows work on a mobile device and meet the Hito 1 wording.

## Phase 3 — Hito 1 catalog and submission

- **3.1 Data:** Use the owner-selected market product model and add at least ten meaningful products and categories in PostgreSQL. Record that the previous-semester theme is unverified, as required by the rubric.
- **3.2 Catalog:** Display name, stock, price, and the nested category returned by the backend; handle missing/empty category data without a crash.
- **3.3 Git and credentials:** Confirm the Flutter and Spring Boot repository links, inspect tracked filenames/history for sensitive config, and document local setup. Keep the author's identity as the owner.
- **3.4 Evidence:** Record the mobile registration, generic login error, password-recovery email, and catalog. Prepare Teams links and a short video or screenshots. Check at least three commits on three distinct days before submission.
- **Failure branch:** If the device cannot reach port 8090, verify the API on the host, then the correct emulator/phone address and network permission. If product count differs after restart, inspect PostgreSQL seed and persistence before filming.
- **Exit gate:** Hito 1 evidence is reproducible and the Nov 24 Teams package is ready; mark the Nov 25 review separately after it occurs.

## Phase 4 — Hito 2 images and API contract

- **4.1 Backend field:** Add `imageUrl` to `Producto`, `Product`, `ProductMapper`, request DTOs, and the PostgreSQL schema. Preserve existing product reads and writes.
- **4.2 Supabase:** Configure a public bucket named `productos`, upload product images, store public URLs in PostgreSQL, and test one valid URL and one missing image. Do not put a service-role key in Flutter.
- **4.3 Product update:** Add a PUT endpoint and persistence path for existing products, including validation and missing-ID behavior. Verify GET, POST, PUT, and DELETE API contracts with PostgreSQL.
- **Failure branch:** If image URLs are absent in Flutter, trace database → entity → mapper → JSON → widget. If migration fails, diagnose and repair the schema before adding UI work; do not erase existing data to make a test pass.
- **Exit gate:** The API returns and updates `imageUrl` and the four product operations pass targeted tests against PostgreSQL.

## Phase 5 — Hito 2 catalog and CRUD

- **5.1 Product UI:** Replace the basic `ListTile` view with mobile cards/grid showing image, name, category, formatted price, and stock indicator. Add image fallback, loading, empty, and error states.
- **5.2 Search/filter:** Add name search and/or category filtering; verify combined and empty-result cases. Keep the criterion exact: one working method satisfies the mandatory rubric.
- **5.3 Write flows:** Add create, edit, and delete screens/actions with validation, loading protection, confirmation for delete, and list refresh. Check persistence after app restart.
- **5.4 Network recovery:** Replace raw exception text with a friendly server-unavailable view and a functional Retry button. Test with Spring Boot stopped and restarted.
- **Failure branch:** For a failed write, compare Flutter request JSON with the backend DTO and HTTP response. Check duplicate taps and stale list state before treating the UI as complete.
- **Exit gate:** On a mobile device, a user can search and complete GET, POST, PUT, and DELETE; changes survive a backend restart in PostgreSQL.

## Phase 6 — Hito 2 identity and profile

- **6.1 Settings:** Add a reachable Settings/Preferences screen containing the Firebase user's email, avatar/photo, UID, creation date, and sign-out action. Test absent optional profile fields.
- **6.2 Google Sign-In:** Configure the Firebase provider and Android/iOS platform files locally. Add the login button and preserve the bear success/navigation flow. Ask the owner whether Google access is restricted to institutional accounts before enforcing a domain rule.
- **Failure branch:** If Google login fails, inspect provider enablement, platform registration, SHA-1/URL scheme, and account state in that order. Recheck email/password login afterward.
- **Exit gate:** Email/password and Google login both reach the catalog on a mobile device; profile and logout work for both account types.

## Phase 7 — All optional extra-credit features

- **7.1 Shopping assistant (+6):** Choose an API provider and credentials with the owner. Put its secret on the server, supply the current catalog as bounded context, and test price/category questions plus unsupported requests, empty catalog, timeouts, and provider failures.
- **7.2 Voice search or visual scanner (+3):** Prefer voice search if device permissions and supported package behavior are verified. Connect recognized text to the real catalog search; test permission denied, silence, and a successful query. Use a scanner only if explicitly selected or voice is infeasible.
- **7.3 Added animation (+2):** Add one Rive/Lottie animation beyond the existing login bear to a meaningful state. Test that slow devices and reduced motion do not block the task flow.
- **Failure branch:** Keep each extra behind an isolated UI path so provider or device failure cannot break mandatory catalog and authentication flows. Do not claim points from a mock response.
- **Exit gate:** Each extra is demonstrated on device and recorded separately in the rubric trace and evidence log.

## Phase 8 — Invoice integration

- **8.1 Contract design:** Map billable products to invoice line items and decide whether invoice data belongs in the existing backend or a separate service. Avoid two competing product/customer models.
- **8.2 Controlled import:** Adapt only the needed invoice domain, persistence, service, and controller code from `SistemaFacturacion`; record source paths and refactoring in the phase log. Move invoice persistence to PostgreSQL without disturbing product data.
- **8.3 Mobile flow:** Add invoice creation/history only after product CRUD and identity work. Test totals, tax calculations, persistence, authorization, and failures.
- **Failure branch:** If the invoice module destabilizes mandatory endpoints, isolate it and restore the last passing product build before proceeding. The Hito 2 rubric remains the release gate.
- **Exit gate:** Invoice features work end to end on mobile and all mandatory product/authentication regression checks still pass.

## Phase 9 — Final acceptance and delivery

- **9.1 Automated checks:** Run Flutter tests/static analysis and backend tests; verify API integration with PostgreSQL. Re-run any failed check after fixes.
- **9.2 Device matrix:** Demonstrate email login, registration, recovery, Google login, profile/logout, images, search, product CRUD, Retry, all claimed extras, and invoices if included. Check at least one emulator and the intended demonstration device.
- **9.3 Evidence and history:** Capture Supabase bucket evidence, repository links, a mobile video, and the Git day/commit counts. Hito 2 needs four additional commits across three later days after Hito 1, for at least seven commits across six distinct days in total. Existing three commits from Nov 18 count as one day.
- **9.4 Publication and handoff:** Resolve the final repository name, review files to be published, create the GitHub repository under the owner's account without collaborators, push, verify the public links, then prepare the exact Teams submission package. Record the result of the Dec 2 in-person review separately.
- **Failure branch:** Do not submit a broken build as complete. Record the failing criterion, fix it, rerun its check and nearby flows, and update the evidence. If an external service is unavailable, document the blocker without claiming that criterion passed.
- **Exit gate:** All 50 mandatory points and each claimed extra have device evidence, passing checks, and traceable commits. The final status must distinguish code completion from Teams submission and in-person review.
