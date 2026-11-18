# ADA5 rubric trace

Statuses: **Present**, **Partial**, **Missing**, **Decision needed**. These describe source inspection, not a runtime acceptance test.

## Milestone 1 — 20 points, due November 24, 2026

| Requirement | Status | Evidence / next action |
| --- | --- | --- |
| Generic login error; retain bear animation, loading, and navigation | Partial | Animations and navigation exist; remove field-specific errors. |
| Registration with institutional email and password rules | Missing | Add a Flutter registration screen and Firebase account creation. |
| Password recovery | Missing | Add reset-email flow. |
| Sign-out | Present | `ProductsScreen` calls Firebase `signOut()`. Verify on device. |
| Previous semester theme and at least 10 products | Decision needed | Current seed has four grocery products; confirm required theme. |
| Show product category | Missing | Add category to the Flutter list. |
| Keep credentials out of GitHub | Partial | Ignore rules exist; audit tracked files and setup instructions before publication. |
| Mobile evidence and three commits on three different days | Missing | Produce evidence and record work over the required days. |

## Milestone 2 — 30 points, due December 1, 2026

| Requirement | Status | Evidence / next action |
| --- | --- | --- |
| `imageUrl` in entity, domain, mapper, database, and Flutter | Missing | Add schema and contract end to end. |
| Public Supabase product-image bucket | Missing | Requires project configuration and uploaded images. |
| Redesigned catalog with image, category, price, and stock | Missing | Implement in Flutter after API contract is stable. |
| Search by name and/or category filter | Missing | Add a working search or filter. |
| Product GET, POST, PUT, DELETE from Flutter | Partial | Backend has GET, POST, DELETE; PUT and Flutter write flows are missing. |
| Friendly network error with Retry | Partial | Retry exists; replace raw exception text. |
| Settings screen with user profile and sign-out | Missing | Add Firebase user profile view. |
| Google Sign-In on a mobile device | Missing | Add provider and platform configuration. |
| Mobile video, bucket evidence, four more commits across three later days | Missing | Complete after the app works on device. |

## Optional extra credit — up to 11 points

| Requirement | Points | Status |
| --- | ---: | --- |
| Catalog-aware shopping assistant | 6 | Missing |
| Voice search or visual scanner | 3 | Missing |
| Additional Rive or Lottie animation | 2 | Missing |

## Acceptance rule

Mark a requirement complete only after code review and a successful on-device demonstration. Screenshots, Git history, and Teams submissions are separate delivery artifacts.
