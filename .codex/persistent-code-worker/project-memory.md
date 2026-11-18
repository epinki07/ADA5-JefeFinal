# Persistent Code Worker Memory

## Project

- Name: ADA5-JefeFinal
- Root: /Users/diegoramirezmagana/ADA5/ADA5-JefeFinal
- Started: 2026-11-18 21:29 UTC
- Last Updated: 2026-11-18 21:29 UTC

## Current Assignment

Build the ADA5 Flutter mobile project with Firebase, Spring Boot, PostgreSQL, Supabase images, full rubric and optional extras; document every change in English.

## Success Criteria

- [ ] Implement the requested behavior
- [ ] Verify the change with appropriate checks
- [ ] Review the diff and remove partial scaffolding
- [ ] Hand off with risks and blockers clearly stated

## Constraints

- Follow every mandatory and optional ADA5 rubric item; do not invent missing facts.
- Document each integration change in English.
- Use the owner's Git identity; do not add collaborators.
- Keep the source clones unchanged.

## Important Files

- `app/lib/main.dart`, `app/lib/screens/login_screen.dart`, `app/lib/screens/products_screen.dart`
- `backend/src/main/java/mx/edu/tecdesoftware/market_backend/persistence/web/controller/ProductController.java`
- `backend/src/main/java/mx/edu/tecdesoftware/market_backend/persistence/entity/Producto.java`
- `docs/RUBRIC_TRACE.md`, `docs/SOURCE_INVENTORY.md`, `CHANGELOG.md`

## Architecture Notes

- Flutter calls the market backend at `/products`; Firebase authenticates in the client.
- The market backend has product/purchase domain layers and can run with H2 locally; the assignment requires PostgreSQL data.
- The billing API is a separate Spring Boot application with an invoice model; merging it requires a deliberate boundary.

## Decisions

- Consolidate the existing Flutter and market backend projects as the first compatible baseline.
- Keep the billing and WebTrack repositories as references until the product flow is complete.

## Open Questions

- Exact previous-semester database theme.
- Final repository name; `ADA5-JefeFinal` is the reversible working name.
- Google account eligibility and the role of invoices in the final demonstration.

## Active Plan

- Verify that the copied baseline is complete and contains no local secrets.
- Commit the initial documented baseline under the owner's identity.
- Resolve theme and name before product seed and publication.
- Implement rubric items in dependency order, then optional extras.

## Completed Work

- Created `ADA5/sources/` and cloned four relevant repositories.
- Copied the Flutter and market backend baselines into a new local Git repository.
- Wrote English source inventory, rubric trace, decisions, README, and change log.

## Validation Log

- `flutter test` passed (2 tests).
- `backend/./gradlew test` passed.
- `flutter analyze` reported two issues at `app/lib/main.dart` because `lib/firebase_options.dart` is intentionally untracked and is not yet configured locally.
- Source clones remained clean after consolidation.

## Risks And Blockers

- Theme cannot be inferred from the public repositories: the market seed is grocery while the billing API is financial.
- Android/iOS Firebase setup and a live PostgreSQL database require local credentials/configuration.
- WebTrack's published repository does not contain its source implementation.
- Full Flutter static analysis and device execution require the owner's real Firebase configuration. Do not add fake values or commit the local file.

## Restart Notes

- Source clones are under `ADA5/sources/` and should remain unchanged.
- The integration repository is `ADA5/ADA5-JefeFinal/` pending the owner's final name.
- Continue with validation, then implement Milestone 1. Do not claim rubric completion from source inspection alone.
