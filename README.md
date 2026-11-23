# ADA5 Jefe Final

A Flutter point-of-sale app and Spring Boot API for the ADA5 integrative assignment. The app uses the product catalog to register sales in PostgreSQL, deduct stock, and display each internal receipt and the sales history.

## Layout

- `app/`: Flutter app with Rive login, Firebase Authentication, catalog, sales, and receipts.
- `backend/`: Spring Boot catalog, purchase, and sales endpoints.
- `docs/`: source inventory, [phase plan](docs/PHASE_PLAN.md), phase logs, rubric trace, and decisions.
- [Delivery checklist](docs/DELIVERY_CHECKLIST.md): evidence, Git dates, external setup, and Teams draft.
- `CHANGELOG.md`: English record of each integration change.

## Current status

The Flutter app includes Firebase authentication, product browsing and editing, and network retry. Spring Boot exposes the product API and runs against PostgreSQL for assignment demonstrations. See the [rubric trace](docs/RUBRIC_TRACE.md) for verification and remaining work.

## Sales demonstration

1. Start PostgreSQL, the Spring Boot API, Firebase Auth Emulator, and Android using the [local demonstration guide](app/README.md#android-demonstration-with-local-firebase).
2. Sign in, open **Ventas**, and choose **Nueva venta**. Select product quantities and a payment method, then register the sale.
3. The app shows the folio, line items, and total in MXN. Open the same receipt from sales history or use `GET /sales/{id}` in [local Swagger](http://localhost:8090/swagger-ui.html).

The API verifies current price and stock when it records a sale, saves the receipt and stock change in one transaction, and handles retries using the original request ID. Product names and prices are preserved on saved receipts. The receipt is an internal sales document. Payment processing and CFDI stamping require separate integrations.

Follow the [full development plan](docs/PHASE_PLAN.md). Each implemented phase gets a log based on [the template](docs/PHASE_LOG_TEMPLATE.md), including source movement, tests, failures, and the exit gate.

## Local setup

1. Configure Firebase locally using `app/lib/firebase_options.example.dart` as a template. Keep the real `firebase_options.dart` out of Git.
2. From `backend/`, run `./gradlew bootRun`; the checked-in default configuration uses H2 on port 8090 for local development.
3. Run `flutter pub get` and `flutter run` inside `app/` on an Android emulator or physical phone. Set `API_BASE_URL` for a physical phone.

For PostgreSQL, create a database and provide `DB_URL`, `DB_USER`, and `DB_PASSWORD` as local environment variables. From `backend/`, run `./gradlew bootRun --args=--spring.profiles.active=postgres`. After JPA creates the schema, apply `backend/sql/seed-postgres.sql` with `psql`; it adds ten market products without duplicating them on a second run. Keep database credentials outside Git.

The optional shopping assistant uses Google's Gemini Interactions API. Set `GEMINI_API_KEY` in the backend process environment to enable it; optionally override `GEMINI_MODEL` (default: `gemini-3.5-flash-lite`). The key never belongs in Flutter or Git. Without it, `POST /assistant` returns 503 and the product catalog remains available. The assistant currently reads up to 100 active products from the backend. This local integration should not be published with a provider key until Firebase authorization protects the assistant and product-write endpoints.

The PostgreSQL path has been verified against a local test database. The Android demonstration uses Firebase Auth Emulator. Production Firebase, the previous-semester theme, and externally hosted images still require verification. Keep the backend on a private development interface for the demonstration.

## Ownership

The Git author identity is inherited from the owner's local Git configuration. This repository does not add a collaborator or bot account.
