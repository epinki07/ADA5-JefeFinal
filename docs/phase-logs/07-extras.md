# Phase 07 — optional extra credit

## Status and scope

- Status: in progress
- Starting commit: `c0484a4`
- Rubric items: catalog-aware assistant (+6), voice search or visual scanner (+3), additional animation (+2)

## Planned changes and verification

- Voice search will feed recognized words into the existing catalog search. Verify permission denied, no speech, and a real spoken product name on mobile.
- Added `speech_to_text` 7.5.0, Android microphone/recognition declarations, iOS permission descriptions, and a catalog microphone control. Recognized words update the same search query as typed input. `dart analyze` and existing Flutter tests passed; device verification remains.
- The assistant requires the owner's chosen API provider and credentials. Keep its key server-side; do not claim the six points until it uses the live catalog and passes API failure checks.
- The extra animation must be distinct from the existing login bear and visible in a meaningful flow. Verify that it does not block use.

## Exit gate

- [ ] Assistant works with a live catalog and a real provider API
- [ ] Voice or scanner works on a mobile device
- [ ] New animation works on a mobile device

Reference for the speech plugin and permissions: https://pub.dev/packages/speech_to_text
