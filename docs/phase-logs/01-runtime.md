# Phase 01 — runtime and data foundation

## Status and scope

- Status: in progress
- Starting commit: `98fb20e`
- Rubric items: PostgreSQL-backed market data, mobile runtime readiness, credential safety
- Expected behavior: the market backend can run against PostgreSQL while H2 remains available for automated tests.

## Changes and source movement

| Source | Destination | Change | Reason |
| --- | --- | --- | --- |
| Existing market backend | `backend/src/main/resources/application-postgres.yml` | Added environment-based PostgreSQL profile | Run the required database without hard-coded credentials |
| Existing market seed | `backend/src/main/resources/data.sql` | Expanded H2 sample catalog from four to ten products | Keep local tests representative |
| New SQL script | `backend/sql/seed-postgres.sql` | Added repeatable ten-product PostgreSQL seed | Prepare a persistent catalog without duplicates |

## Verification and failures

| Check | Actual result | Next action |
| --- | --- | --- |
| `psql --version` | PostgreSQL 18.4 client is available | Configure a local server for integration testing |
| `pg_isready` | No server responds on the default socket | Start an isolated local database or use the owner's existing instance |
| `flutter devices` | No mobile device is connected | Launch the available Android emulator |
| `flutter emulators` | `Flutter_Pixel_API_36` is available | Launch and validate the app when Firebase config is available |
| PostgreSQL profile startup | Spring Boot started against PostgreSQL 18.4 on local port 55432 | Verify persistent data and failure path |
| Product seed | First run inserted 3 categories and 10 products; second run inserted 0 | Confirm count and GET response |
| Product count and GET | SQL count returned 10; `GET /products` returned 10 products with categories | Verify restart persistence |
| Restart persistence | Stopped and restarted Spring Boot; `GET /products` still returned 10 products | Passed |
| Backend regression | `./gradlew test` passed | Continue to the next phase |

## Exit gate

- [x] PostgreSQL startup and product query verified
- [x] PostgreSQL restart persistence verified
- [ ] PostgreSQL connection failure path verified
- [ ] Flutter app starts on a mobile device with real Firebase configuration
- [ ] Normal and failure network paths verified
