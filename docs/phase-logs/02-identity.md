# Phase 02 — Hito 1 identity

## Status and scope

- Status: in progress
- Starting commit: `98fb20e` plus Phase 1 working changes
- Rubric items: generic login, institutional registration, password recovery, sign-out
- Expected behavior: users can complete account flows on a mobile device while the Rive bear flow remains intact.

## Source movement and changes

| Source | Destination | Change | Reason |
| --- | --- | --- | --- |
| Existing Flutter login | `app/lib/screens/login_screen.dart` | Generic login failure was completed earlier; registration and recovery entry points remain | Meet Hito 1 identity flow |
| New Flutter screen | `app/lib/screens/signup_screen.dart` | Added institutional registration, password confirmation, Firebase account creation, and sign-out before returning to Login | Meet Hito 1 registration flow |
| New Flutter screen | `app/lib/screens/password_reset_screen.dart` | Added an email recovery form with a neutral completion message | Meet Hito 1 recovery flow |

## Verification

| Check | Actual | Next action |
| --- | --- | --- |
| `dart analyze lib/screens/login_screen.dart` | Passed after the generic-error refactor | Re-run after adding navigation |
| Firebase device flow | Not run; local Firebase options are absent | Configure owner's project and Android emulator |
| Targeted static analysis | All three identity screens passed | Verify on device |
| Flutter tests | Two existing validation tests passed | Add integration/device evidence when configured |

## Failure and exit gate

- Keep specific Firebase errors out of the login UI and preserve the Rive triggers.
- [ ] Registration, recovery, and sign-out verified on a mobile device
- [ ] Flutter static analysis and tests pass
- [ ] Change log and rubric trace updated
