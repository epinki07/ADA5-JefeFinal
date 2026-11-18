# Source inventory

| Source | Evidence | Reuse decision |
| --- | --- | --- |
| `login_river_animation` | Flutter app with Rive bear, Firebase email/password login, `GET /products`, sign-out, and retry UI. | Copy as `app/`; refactor and extend. |
| `market-backend-2026-3-b` | Java 21 / Spring Boot product and purchase API, JPA entities, MapStruct, Gradle, H2 local config, PostgreSQL dependency. | Copy as `backend/`; extend its product contract. |
| `SistemaFacturacion` | Spring Boot billing API with clients, invoices, line items, taxes, and H2 in-memory persistence. | Reference only for a later invoice module; direct merge would duplicate application bootstrapping and data models. |
| `webtrack-2` | Public README describes a finance PWA; the README says its implementation is private. | Use product ideas only. No source code is available in this clone. |

## Confirmed gaps in the compatible baseline

- The original backend seed had four grocery products. The integration repository now has ten market products; previous-semester theme compliance remains unverified.
- The backend has product GET, POST, and DELETE endpoints; no product PUT endpoint appears in `ProductController`.
- `Producto`, `Product`, `ProductMapper`, and `ProductRequest` lack `imageUrl`.
- The checked-in backend configuration starts with H2; the rubric requires PostgreSQL for the project data.
- The Flutter login still validates email and password per field. The assignment requires a generic login failure.
- The Flutter app has no registration, password-reset, Google sign-in, or profile screen.
- The product list shows name, stock, and price; category, image, search, and mobile CRUD screens are missing.
- The current retry UI displays the raw exception; the rubric asks for a friendly server-unavailable state.

## Integration boundary

The billing API models invoices rather than the rubric's required products. Invoice code should enter this repository only after the product flow is complete. Do not import both Spring Boot applications as two overlapping backends without a defined contract.
