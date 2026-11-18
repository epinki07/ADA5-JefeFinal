# Phase 00 — baseline and audit

## Status and scope

- Status: locally verified; device acceptance pending
- Starting commit: new repository
- Rubric items: source readiness and traceability; no product criterion is marked complete by this phase alone
- Expected user-visible behavior: inherited Flutter login and product list remain available

## Source movement and changes

| Source path and commit | Destination path | Change made | Reason |
| --- | --- | --- | --- |
| `login_river_animation` at `9cd4eafb92b657b315fbd9cd284aedddbc020713` | `app/` | Copied, then changed login errors to a global message in commit `2031bb7` | Preserve the working Flutter/Firebase/Rive baseline |
| `market-backend-2026-3-b` at `148da49860a749ce3b098f096c303c350abfdab6` | `backend/` | Copied; retained safe configuration and Gradle wrapper files | Preserve the product API already called by Flutter |
| `SistemaFacturacion` at `67219dd43a1451584d4f63024c5ad278f8278920` | `ADA5/sources/SistemaFacturacion/` | Reference clone only | Invoice integration needs a separate contract |
| `webtrack-2` at `e7c9161f2bab07faba0bd72ed699d6faac039957` | `ADA5/sources/webtrack-2/` | Reference clone only | Published repository contains product documentation, not application source |

## Verification

| Check | Command or device steps | Expected | Actual | Evidence |
| --- | --- | --- | --- | --- |
| Flutter unit tests | `flutter test` in `app/` | Pass | Passed, 2 tests | Local command output |
| Backend tests | `./gradlew test` in `backend/` | Pass | Passed | Local command output |
| Login static analysis | `dart analyze lib/screens/login_screen.dart` in `app/` | No issues | No issues | Local command output |
| Full Flutter analysis | `flutter analyze` in `app/` | No issues after owner config | Blocked by ignored `firebase_options.dart` | Local command output |
| Device test | Firebase login and product request on mobile | Work end to end | Not run; owner configuration required | Pending |

## Failures and repairs

| Symptom | Reproduction | Root cause | Fix | Recheck |
| --- | --- | --- | --- | --- |
| Full Flutter analysis reports missing import and symbol | `flutter analyze` | Real Firebase options are intentionally untracked and absent locally | Obtain the owner's real config in Phase 1; never commit fake values | Re-run full analysis and device start |

## Exit gate

- [x] Source clones captured and documented
- [x] Compatible baseline assembled
- [x] Available unit tests and targeted analysis passed
- [ ] Full app and device path verified with real Firebase and PostgreSQL

## Open questions and next phase

- Open questions: final GitHub repository name; Google account eligibility; invoice role in final demonstration.
- Next phase: Phase 1 runtime and data foundation, then Phase 2 identity.
