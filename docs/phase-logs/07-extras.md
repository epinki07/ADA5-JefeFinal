# Phase 07 — optional extra credit

## Status and scope

- Status: in progress
- Starting commit: `c0484a4`
- Rubric items: catalog-aware assistant (+6), voice search or visual scanner (+3), additional animation (+2)

## Planned changes and verification

- Voice search will feed recognized words into the existing catalog search. Verify permission denied, no speech, and a real spoken product name on mobile.
- Added `speech_to_text` 7.5.0, Android microphone/recognition declarations, iOS permission descriptions, and a catalog microphone control. Recognized words update the same search query as typed input. `dart analyze` and existing Flutter tests passed; device verification remains.
- The owner delegated the provider choice. Selected Gemini Interactions API with configurable `gemini-3.5-flash-lite` default. The server now loads active products, sends id/name/category/price/stock as bounded context, and calls the provider with `store=false` and a server-only `GEMINI_API_KEY`. Added `POST /assistant`, input validation, a dedicated Flutter question screen, and user-friendly unavailable states. The endpoint returns 503 if no key or provider failure occurs; it does not interrupt catalog operations.
- Verification: `./gradlew test` passed with service tests for live catalog context, blank question, and empty catalog; a local fake HTTP provider test checked request/response shape and key header; endpoint tests checked 400 and 503. A second Spring context initially collided with the first test's H2 seed; giving it a separate in-memory database fixed the failure and the full suite passed. Targeted Dart analysis and `flutter test` passed. Real Gemini response and mobile device flow remain unverified.
- The extra animation must be distinct from the existing login bear and visible in a meaningful flow. Verify that it does not block use.
- Added an original `assets/assistant_pulse.json` Lottie animation for the assistant loading state, using `lottie` 3.8.2. Reduced-motion settings show a static icon instead. The animation asset parsed in a Flutter test, and targeted Dart analysis and all Flutter tests passed. Visual performance on a mobile device remains pending.

## Exit gate

- [ ] Assistant works with a live catalog and a real provider API
- [ ] Voice or scanner works on a mobile device
- [ ] New animation works on a mobile device

Reference for the speech plugin and permissions: https://pub.dev/packages/speech_to_text
Gemini references: https://ai.google.dev/gemini-api/docs/interactions-overview and https://ai.google.dev/gemini-api/docs/pricing
Lottie package reference: https://pub.dev/packages/lottie
