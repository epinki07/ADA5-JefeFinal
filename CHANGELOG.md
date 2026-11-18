# Change log

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
