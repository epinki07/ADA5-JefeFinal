# ADA5 Jefe Final

A Flutter point-of-sale app and Spring Boot API for the ADA5 integrative assignment. The app uses the product catalog to register sales in PostgreSQL, deduct stock, and display each internal receipt and the sales history.

The [Android demo release](https://github.com/epinki07/ADA5-JefeFinal/releases/tag/demo-android-v0.2.0) includes a video, the emulator APK, the Spring Boot JAR, and the evidence package.

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

1. For real Firebase authentication, follow the [Android configuration guide](app/README.md#android-with-a-firebase-project). For the self-contained demo, use Firebase Auth Emulator instead.
2. From `backend/`, run `./gradlew bootRun`; the checked-in default configuration uses H2 on port 8090 for local development.
3. Run `flutter pub get` and the matching Flutter command in the Android configuration or emulator guide. Set `API_BASE_URL` for a physical phone.

For PostgreSQL, create a database and provide `DB_URL`, `DB_USER`, and `DB_PASSWORD` as local environment variables. From `backend/`, run `./gradlew bootRun --args=--spring.profiles.active=postgres`. After JPA creates the schema, apply `backend/sql/seed-postgres.sql` with `psql`; it adds ten market products without duplicating them on a second run. Keep database credentials outside Git.

Apply `backend/sql/catalog-images-postgres.sql` after the seed to display the included product images. It fills missing image URLs without overwriting URLs already assigned by the owner. To use a public Supabase bucket instead, follow the [product image setup](docs/PRODUCT_IMAGES.md).

The optional shopping assistant uses Google's Gemini Interactions API. Set `GEMINI_API_KEY` in the backend process environment to enable it; optionally override `GEMINI_MODEL` (default: `gemini-3.5-flash-lite`). The key never belongs in Flutter or Git. Without it, `POST /assistant` returns 503 and the product catalog remains available. The assistant currently reads up to 100 active products from the backend. This local integration should not be published with a provider key until Firebase authorization protects the assistant and product-write endpoints.

The PostgreSQL path has been verified against a local test database. The public Android demo uses Firebase Auth Emulator. A separate local build verified registration, email/password sign-in, and delivery of the recovery email against the owner's live Firebase project. Google sign-in, the previous-semester theme, and externally hosted images still require verification. Keep the backend on a private development interface for the demonstration.

## Ownership

The Git author identity is inherited from the owner's local Git configuration. This repository does not add a collaborator or bot account.
