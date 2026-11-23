# Phase 08 — invoice integration

## Status and scope

- Status: internal receipt flow verified on Android and PostgreSQL
- Starting commit: `9a4c48e`
- Source: `ADA5/sources/SistemaFacturacion` at `67219dd43a1451584d4f63024c5ad278f8278920`
- Rubric impact: invoices are an owner-requested integration beyond the ADA5 product rubric.

## Source audit

- `Factura` is a master record with folio, client display name, date, subtotal, total, and tax totals. `DetalleFactura` stores line description, quantity, unit price, amount, and a tax-object code. `ImpuestoDetalleFactura` stores tax data per line.
- `FacturaService` validates that an invoice has details and can recalculate totals after a tax patch. Its create path accepts subtotal and total from the caller; it does not derive them from the market product catalog.
- The source README describes invoice receipts and explicitly says taxes make the model closer to a real invoice. The code and README do not show a stamping/PAC workflow. Do not claim SAT CFDI issuance from this source.
- The billing API uses its own Spring Boot app and H2 memory database. Importing that bootstrap or its seed would create a second runtime and duplicate client/product ownership. The combined app should use the existing Spring Boot backend and PostgreSQL profile.

## Proposed integration boundary

1. Keep `Producto` as the only product price/stock source. An invoice line selects a product ID and stores a name/price snapshot when created, so later catalog edits do not alter historical totals.
2. Compute line amount and subtotal on the server using decimal arithmetic; reject invalid quantities, missing/inactive products, and inconsistent tax data. Never trust client-supplied totals.
3. Store invoice header and lines in new PostgreSQL tables in the current backend, separate from `compras` so existing purchase endpoints and product data remain intact.
4. Expose invoice creation and history to Flutter only after the draft-versus-CFDI scope is confirmed. Do not assume a tax rate or represent an internal receipt as a stamped fiscal document.
5. Test calculation, persistence after restart, error paths, and product endpoint regressions. Add Firebase authorization before any public deployment.

## Implementation

Continue from `b931a1f` using the internal sales receipt supported by the reference model. The receipt records catalog price snapshots and MXN totals. Fiscal stamping requires a separately configured provider and confirmed fiscal requirements.

## Original clarification

The reference application models receipts, invoice details, and taxes. The integrated sales flow uses the same header and line-item structure with the current catalog in PostgreSQL. It records the catalog price as the final amount in MXN and produces an internal receipt. CFDI issuance would require a fiscal specification and a stamping service.

## Exit gate

- [x] Internal receipt scope and source reference documented
- [x] Decimal totals and data persistence verified against PostgreSQL
- [x] Mobile create/history flow verified on Android API 36
- [x] Existing catalog and authentication checks pass

## Verification

The Spring Boot suite verifies price and quantity validation, idempotent replay, historical product names and prices, and rollback of stock changes. A separate PostgreSQL database verifies two simultaneous requests against the same stock, with one sale and one conflict, plus receipt and stock persistence after an API restart.

Android recorded sale `V-00001` for MXN 29.00 using two bolillos and one concha. The create response, sales history, and receipt detail agreed. Product API responses confirmed stock reductions of two and one units. The receipt was reopened from the Android history.
