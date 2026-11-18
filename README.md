# ADA5 Jefe Final

An in-progress Flutter mobile application and Spring Boot product API for the ADA5 integrative assignment. The repository is assembled from existing projects owned by `epinki07`. The billing API remains a reference until its data model can be integrated without weakening the assignment requirements.

## Layout

- `app/`: Flutter app with Rive bear login, Firebase Authentication, and a product list.
- `backend/`: Spring Boot product and purchase API.
- `docs/`: source inventory, [phase plan](docs/PHASE_PLAN.md), phase logs, rubric trace, and decisions.
- `CHANGELOG.md`: English record of each integration change.

## Current status

This is a baseline, not a completed submission. The app already calls `GET /products`, signs in with Firebase, signs out, and offers a retry button. The backend already exposes product read, create, and delete operations. See [rubric trace](docs/RUBRIC_TRACE.md) for evidence and remaining work.

Follow the [full development plan](docs/PHASE_PLAN.md). Each implemented phase gets a log based on [the template](docs/PHASE_LOG_TEMPLATE.md), including source movement, tests, failures, and the exit gate.

## Local setup

1. Configure Firebase locally using `app/lib/firebase_options.example.dart` as a template. Keep the real `firebase_options.dart` out of Git.
2. From `backend/`, run `./gradlew bootRun`; the checked-in default configuration uses H2 on port 8090 for local development.
3. Run `flutter pub get` and `flutter run` inside `app/` on an Android emulator or physical phone. Set `API_BASE_URL` for a physical phone.

For PostgreSQL, create a database and provide `DB_URL`, `DB_USER`, and `DB_PASSWORD` as local environment variables. From `backend/`, run `./gradlew bootRun --args=--spring.profiles.active=postgres`. After JPA creates the schema, apply `backend/sql/seed-postgres.sql` with `psql`; it adds ten market products without duplicating them on a second run. Keep database credentials outside Git.

The PostgreSQL path has been verified against a local test database. Firebase device setup, a billable-product theme, and mobile acceptance tests still need to be completed. Do not use this baseline as evidence that the assignment is finished.

## Ownership

The Git author identity is inherited from the owner's local Git configuration. This repository does not add a collaborator or bot account.
