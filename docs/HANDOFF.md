# ADA5 handoff for November 24, 2026

ADA5 is a Flutter point-of-sale app with an authenticated Spring Boot API and PostgreSQL. The owner asked to pause implementation and continue the next day. The corrected iOS build had already started when work paused.

## What is ready to show

- The public [repository](https://github.com/epinki07/ADA5-JefeFinal) contains the Flutter app, Java API, setup instructions, and grading evidence. [Demo v0.3](https://github.com/epinki07/ADA5-JefeFinal/releases/tag/demo-mobile-v0.3.0) contains the verified Android ARM64 APK and the current Spring Boot JAR. [Demo v0.2](https://github.com/epinki07/ADA5-JefeFinal/releases/tag/demo-android-v0.2.0) contains the Android walkthrough video and evidence package.
- Android completed a MXN 29 sale in the updated local demo, reopened the saved receipt from history, and confirmed the stock deductions through the API. The demo uses the API on port `8090` and the local Firebase Authentication emulator. See the [Android demo instructions](../app/README.md#android-demonstration-with-local-firebase).
- The production API passed a test using live Firebase tokens and a temporary PostgreSQL database. An authenticated reader could see the catalog. An operator could record and retrieve a sale and repeat the same request without a second stock deduction. The temporary identities and database were removed.
- Flutter analysis passed, all 13 Flutter tests passed, and all 19 Spring Boot tests passed locally. An earlier GitHub Actions run built the container and verified PostgreSQL. Maven Central returned HTTP 429 during a later independent CI run. [Successful API job](https://github.com/epinki07/ADA5-JefeFinal/actions/runs/45334218122/job/138242367939)
- Flutter reuses HTTP connections, decodes thumbnails at their display size, and shortened the login transition by 1.6 seconds. The API loads each product and its category in one query and exposes a database health check at `/healthz`.

## iOS status

- Firebase now has an iOS registration for `com.epinki07.ada5`. The downloaded `GoogleService-Info.plist` was validated and converted into the ignored local Flutter and Xcode settings. It includes the Google OAuth client. A temporary account verified email/password registration and sign-in through the Firebase Auth API and was then removed.
- Xcode compiled the iOS Simulator app and the launch log showed that Firebase Installations aborted on the demo's incorrectly formatted synthetic API key. Commit `da4d7fa` corrects the demo key. Start by checking [the corrected build](https://github.com/epinki07/ADA5-JefeFinal/actions/runs/45338197310) for a successful launch and screenshot. The earlier simulator artifact is useful for reproducing the reported crash.
- Physical iPhone testing and TestFlight distribution are pending. Use Xcode with the owner's signing team, the iOS Firebase settings, and the deployed API's HTTPS URL. Check email/password, Google sign-in, catalog, and a test sale on the device. [Build and signing instructions](DEPLOYMENT.md#android-and-ios-builds)

## Free hosting status

- The owner chose a free deployment. The root `render.yaml` defines a Free Docker service with HTTPS and `/healthz`. It passed validation against Render's official JSON Schema. Supabase Free supplies PostgreSQL and the public product-photo bucket. Render can sleep after 15 minutes and wake on the next request. Supabase can pause projects after a week of low activity. [Deployment instructions](DEPLOYMENT.md#free-demo-on-render-and-supabase)
- The image built under the revised configuration. A conservative local startup run capped at 512 MiB and 0.1 CPU reached Spring Data initialization but did not pass `/healthz` within 85 seconds. Verify the actual Free service's cold start and adjust startup or client timeout based on its measurements before calling the hosted demo ready.
- The dedicated `ADA5` organization is visible in Supabase. Project creation, the database schema and seed, and upload of the ten photos are pending. Create the project under the Free plan, use the dedicated `ada5` schema, and publish only the generated catalog photos in the `productos` bucket. Keep connection credentials out of Git and enter them in Render's environment settings.
- The Render CLI authorization was stopped at the pause. Resume the owner's authorization, deploy the blueprint on Free, configure verified TLS to the Supabase session pooler, and set the Firebase operator UID. Check the public HTTPS URL for `/healthz`, HTTP 401 without a session, and a completed sale with an operator. Build the app against that URL after it passes these checks.
- Cloudflare remains an alternative. Wrangler's dry run and local Worker verified the container, health check, photo serving, and rejection of unsigned catalog requests. Cloudflare was not used for the free deployment because Containers requires Workers Paid.

## Rubric and submission

Hito 1 now has commits dated November 18, 23, and 24 in Mérida time. Teams submission and the in-person review remain pending. Hito 2 still needs the hosted photo bucket and mobile evidence, a complete Google sign-in, and commits on the later dates required by the rubric. See the [delivery checklist](DELIVERY_CHECKLIST.md) and [rubric trace](RUBRIC_TRACE.md).
