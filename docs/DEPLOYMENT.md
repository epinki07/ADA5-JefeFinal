# Deploy ADA5

## API and PostgreSQL

Build the Java 21 Docker image from the repository root with `docker build -t ada5-api backend`. The image starts Spring Boot on port `8090` with the `production` profile. Put an HTTPS reverse proxy in front of it and provide these runtime values.

| Variable | Value |
| --- | --- |
| `DB_URL` | JDBC URL for a dedicated PostgreSQL database. Use the provider's certificate and `sslmode=verify-full` for a remote database. |
| `DB_USER`, `DB_PASSWORD` | PostgreSQL credentials for that database. |
| `ADA5_FIREBASE_PROJECT_ID` | The Firebase Authentication project ID. |
| `ADA5_OPERATOR_UIDS` | Firebase Authentication user UIDs, comma separated. Use the **User UID** column in Firebase, enabled only for people who should handle sales and catalog edits. |
| `GEMINI_API_KEY` | Optional backend secret for the shopping assistant. |

Use `GET /healthz` to check database connectivity. Initialize a new database by starting the API first, then run `backend/sql/seed-postgres.sql` and `backend/sql/catalog-images-postgres.sql` against that database with `psql`. GitHub Actions builds the container and checks `/healthz` and anonymous access against PostgreSQL. It also builds a separate iOS Simulator artifact.

Any signed-in account can browse the catalog. Operator accounts can change inventory, use sales history, issue receipts, and use the shopping assistant when configured. Verify that `GET /products` returns `401` without a token, and test a sale and the saved receipt with an operator account. Publish only the `production` profile.

## Cloudflare Containers

The Worker in `deploy/cloudflare` forwards API requests to one Java container and keeps it warm for ten minutes after use. PostgreSQL runs in a separate managed database. Cloudflare Containers requires Workers Paid and usage may incur additional charges. [Cloudflare Containers pricing](https://developers.cloudflare.com/containers/platform/pricing/)

Use a machine with Node.js and a running Docker daemon. From `deploy/cloudflare`, authenticate Wrangler to the owner’s Cloudflare account. In a local file named `.env.production`, set the runtime variables above. Run the dry run first, then publish with the secrets file when the account and PostgreSQL instance are ready.

```sh
npx --yes wrangler@4.167.0 login
npx --yes wrangler@4.167.0 deploy --dry-run
npx --yes wrangler@4.167.0 deploy --secrets-file .env.production
```

Use the HTTPS Worker URL as `API_BASE_URL` for the Flutter builds. Confirm `/healthz` and the Firebase access rules on that URL before distributing them. When updating connection credentials or operator UIDs, ensure the container restarts to read its new runtime settings. [Cloudflare deployment guide](https://developers.cloudflare.com/containers/get-started/)

## Android and iOS builds

Set `--dart-define=ADA5_PROTECTED_API=true` and `--dart-define=API_BASE_URL=https://your-api-host` together in a release build. The API requires an HTTPS origin and uses the signed-in user's Firebase token. Supply each platform’s Firebase configuration separately.

For iOS, register an Apple app in Firebase with bundle ID `com.epinki07.ada5`, or the bundle ID reserved by the owner in Apple Developer. Download its `GoogleService-Info.plist`. From `app/`, generate the local Xcode and Flutter options with the following command.

```sh
python3 tool/configure_firebase_ios.py /path/to/GoogleService-Info.plist
```

With Xcode installed, set the signing team for the Runner target. Build the signed archive with the settings supplied at compile time.

```sh
flutter build ipa \
  --dart-define-from-file=firebase.ios.local.json \
  --dart-define=ADA5_PROTECTED_API=true \
  --dart-define=API_BASE_URL=https://your-api-host
```

Upload the signed build through App Store Connect and validate email sign-in, catalog, and sales on a physical iPhone before distributing it in TestFlight. Use the `ada5-ios-simulator` artifact from the repository's Actions tab for simulator-only checks. [Flutter iOS release guide](https://docs.flutter.dev/deployment/ios)
