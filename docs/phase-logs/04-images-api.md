# Phase 04 — images and product update API

## Status and scope

- Status: in progress
- Starting commit: `ba87289`
- Rubric items: `imageUrl` across persistence/domain/mapper/API; product PUT operation
- Expected behavior: product image URLs survive PostgreSQL reads/writes, and an existing product can be updated by ID.

## Source movement and changes

| Source | Destination | Change | Reason |
| --- | --- | --- | --- |
| Existing product model | `backend/src/main/java/...` | Extend entity, domain, mapper, request, service, and controller | Meet the Hito 2 contract |
| Existing product repository | `backend/src/main/java/.../persistence/ProductoRepository.java` | Update the persisted entity in place | Preserve barcode and other fields during PUT |

## Verification and failure path

- Run backend tests, then POST/PUT/GET against local PostgreSQL.
- Verify missing product ID returns 404 and persisted image URL is present in JSON.
- Supabase bucket and real image delivery require the owner's account and remain a separate gate.
- `./gradlew test` passed. Local PostgreSQL PUT/GET round-trip returned the test image URL, preserved the original barcode, and returned 404 for a missing product ID.

## Exit gate

- [x] `imageUrl` persists and returns in JSON
- [x] PUT updates an existing product and rejects a missing ID
- [x] Backend tests pass
- [ ] Supabase image loads on mobile
