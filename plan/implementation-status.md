# Implemented comic and ink slice — 2026-10-24

- Eight authored opening beats, visual reaction sequence, door interaction, writing
  clue, payoff, optional translations, replay and persistent scene position.
- Twelve original chapters retained as a readable archive; notebook enlarged and
  reflowed. No multiple-choice completion is called handwriting mastery.
- Four constrained formation exercises (ب ت ث ا), explicit submission, guided/copy/
  recall support, distinct dots and excess-ink checks. Broad-nib ribbon activity
  unlocks through practice; free drawing supports pen/finger/mouse, available
  pressure/orientation, undo, replay and explicit raw-stroke export.
- Account progress stores bounded recent writing evidence and story checkpoint.
  Upload retries deduplicate attempts; stale acknowledgements cannot erase newer
  attempts. Raw handwriting is not automatically uploaded.
- All 41 legacy English/Spanish recordings replaced with local Kokoro neural MP3s;
  six opening speech assets added. Arabic assets retained/repaired as described in
  assets/voices/README.md. Builds validate all 218 audio files offline by hashes.
- Official Google identity flow and client ID implemented. Real login/cloud saves
  are not verified because of Forge routing/identity constraints; see diagnostics.

Validation: 33 Flutter tests, 9 Node tests and 5 voice integrity cases passed after
final visual polish. Tests cover pointer samples/stroke boundaries, taps/scribbles/
wrong/missing/overlapping dots, explicit submit, account evidence, late save replies,
scene replay/resume and 390px layouts at 200% system text. A browser smoke test drew
and submitted an alif successfully and confirmed saved guided evidence with no XP.

Limits: the four-letter rubric is experimental and constrained to a guide, not a
trained recognizer or educator-validated assessment of fluent Arabic. Calligraphy
currently teaches directional ink through a ribbon exercise, not formal script
quality. Physical Lenovo stylus/iPhone testing and native Arabic review remain.
Spanish em_alex is not verified as Mexican. Existing chapter content remains draft.

Production deployment was attempted before the user clarified the preferred GitHub connection flow; the build passed but Wrangler refused upload
because this lane has no Cloudflare deployment credential. The host connector is
read-only and the account's Worker list had no arabiya Worker. The existing Wrangler
config will provision the Worker, routes and SQLite Durable Object migration when
a scoped Forge deployment service can execute it. No Google client secret is needed.

The requested Forge GitHub-connected Worker provisioning operation is documented
in FORGE_DIAGNOSTICS.md. Push is performed once after final local checks; no
repeated cloud builds are requested.
