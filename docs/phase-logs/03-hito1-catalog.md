# Phase 03 — Hito 1 catalog and submission

## Status and scope

- Status: in progress
- Starting commit: `98fb20e` plus Phase 1 and 2 working changes
- Rubric items: ten products, visible category, mobile evidence, repository/credential audit

## Source movement and changes

| Source | Destination | Change | Reason |
| --- | --- | --- | --- |
| Existing Flutter product list | `app/lib/screens/products_screen.dart` | Show the backend category and friendly failure state | Match Hito 1 data and Hito 2 retry behavior |

## Verification and failure path

- PostgreSQL returned ten products with nested category data; this was tested before the UI change.
- Targeted Dart analysis and mobile display verification are required after the UI change.
- A server outage must show Retry without a raw exception.
- `dart analyze lib/screens/products_screen.dart` passed after the UI change; device display and outage paths remain unverified.

## Exit gate

- [ ] Category and ten products visible on a mobile device
- [ ] Normal and stopped-server paths verified
- [ ] Hito 1 evidence and distinct-day commit requirements met
