# Decisions and open questions

## Confirmed decisions

1. Use the existing Flutter app and market backend as the compatible baseline.
2. Keep the original repositories unchanged in `ADA5/sources/`.
3. Maintain one new integration repository under `ADA5/ADA5-JefeFinal/`.
4. Record integration changes in English and use the owner's local Git identity; do not add collaborators.
5. Defer invoice integration until the required product flow and data theme are defined.

## Questions requiring the owner's answer

1. What was the exact PostgreSQL theme from the previous semester? The rubric requires that same theme.
2. What final project/repository name should replace the working name `ADA5-JefeFinal`?
3. Should Google Sign-In admit any Google account or only institutional accounts? The assignment does not state this.
4. Are invoices an extra feature after the required catalog, or must they be part of the primary demonstration? This affects scope and data ownership.

## Technical decisions to resolve with evidence

- Choose a PostgreSQL local setup and migration strategy before replacing the H2 development default.
- Define backend authorization for product mutations before exposing the API outside the local classroom environment.
- Keep third-party assistant API keys server-side if the six-point extra is implemented.
