# Decisions and open questions

## Confirmed decisions

1. Use the existing Flutter app and market backend as the compatible baseline.
2. Keep the original repositories unchanged in `ADA5/sources/`.
3. Maintain one new integration repository under `ADA5/ADA5-JefeFinal/`.
4. Record integration changes in English and use the owner's local Git identity; do not add collaborators.
5. Defer invoice integration until the required product flow is complete.
6. The owner selected the existing market backend as the database and product-model baseline. Its PostgreSQL path will be used for the submission; H2 remains a local test configuration until PostgreSQL is wired and verified.

## Questions requiring the owner's answer

1. What final project/repository name should replace the working name `ADA5-JefeFinal`?
2. Should Google Sign-In admit any Google account or only institutional accounts? The assignment does not state this.
3. Are invoices an extra feature after the required catalog, or must they be part of the primary demonstration? This affects scope and data ownership.

## Technical decisions to resolve with evidence

- Choose a PostgreSQL local setup and migration strategy before replacing the H2 development default.
- Define backend authorization for product mutations before exposing the API outside the local classroom environment.
- Keep third-party assistant API keys server-side if the six-point extra is implemented.
- The rubric still requests the previous semester's theme. The owner does not recall it and explicitly chose the compatible market data model. Record this as a grading risk without blocking implementation.
