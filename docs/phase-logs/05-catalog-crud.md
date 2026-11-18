# Phase 05 — mobile catalog and CRUD

## Status and scope

- Status: in progress
- Starting commit: `dc0b242`
- Rubric items: image catalog, search/filter, GET/POST/PUT/DELETE, friendly Retry
- Expected behavior: Flutter displays product cards and persists user changes through Spring Boot/PostgreSQL.

## Planned movement and verification

| Source | Destination | Reason |
| --- | --- | --- |
| Existing `ProductsScreen` | `app/lib/screens/products_screen.dart` | Extend the working API-connected screen |
| New product form | `app/lib/screens/product_form_screen.dart` | Keep create/edit validation separate from catalog display |
| Existing network code in `ProductsScreen` | `app/lib/product_api.dart` | Centralize GET/POST/PUT/DELETE and base URL logic |
| Existing category entity and mapper | `backend/.../CategoryController.java` and `CategoriaCrudRepository.java` | Allow product creation even when no active product provides category choices |

- Verify static analysis and Flutter tests after each UI change.
- Verify create, edit, delete, search, and stopped-server Retry on an Android emulator with real Firebase configuration.
- Keep the phase open until PostgreSQL persistence and mobile behavior are both observed.
- `dart analyze` passed for the product API, catalog, and form. `flutter test` passed the existing two tests. `./gradlew test` passed.
- PostgreSQL API checks passed: GET categories returned three, POST created product 11, DELETE returned 200, and GET products returned the original ten active products.
- The mobile UI path remains unverified because the real Firebase options file is absent.
- Added injectable `ProductApi` to `ProductsScreen` for widget-level behavior checks. Tests verified name search, category filtering, server-unavailable text, and Retry. The Retry test found a real `setState` error: its callback returned a `Future`. Changed it to a synchronous callback that stores the new future. The full Flutter suite passed (7 tests). Mobile acceptance still remains.
