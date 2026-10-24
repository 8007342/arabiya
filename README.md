# Arabiya

A browser-first playable comic for learning to write Arabic, built with Flutter,
with a Cloudflare Worker and SQLite Durable Object for account progress.

## Playable now

- **The Door That Won’t Cooperate:** an eight-scene opening with visual reactions,
  a sliding-door interaction, a luggage-label writing task, a punchline, optional
  translations, scene replay, and saved episode position.
- **Play with a Stylus:** guided/copy/recall practice for ب ت ث ا, a free ink studio,
  and an unlockable broad-nib ribbon challenge. Pen, touch and mouse are supported;
  pressure and orientation affect ink when supplied by the device/browser.
- **Honest writing checks:** explicit submission, separate strokes/dots, body
  coverage and extra-ink rejection. These are experimental constrained-template
  checks, not general Arabic recognition or validated fluency/calligraphy grades.
- **Bundled neural dialogue:** all 41 legacy English/Spanish lines regenerated
  with Kokoro, plus the opening episode recordings. Audio content and file hashes
  are checked offline at build time. See [voice details](assets/voices/README.md).
- **Readability:** large live text, system text scaling, additional text enlargement,
  on-demand translations, reduced motion, keyboard navigation and labelled controls.
- **Story archive:** the twelve original draft chapters and their word notebook
  remain available. Reading a chapter or continuing with help does not award writing
  mastery or XP.
- **Progress:** local checkpoints, per-account writing evidence and cookie-based
  Google sign-in, pending-save preservation and protection against stale upload
  responses. Cloud sync requires a working authenticated backend.

The broader connected-writing curriculum, Arabic educator validation, physical
stylus trials and real Google sign-in/device synchronization tests remain work to
complete. [Forge diagnostics](FORGE_DIAGNOSTICS.md) records local hosting/identity
and deployment service requirements.

## Build and verify

```sh
npm ci
npm run check
npm run build
```

The normal build bundles the Worker and validates existing speech assets without
calling a speech provider, then builds Flutter web. `wrangler.jsonc` deploys the
static app, same-origin API and SQLite Durable Object migration together.

Source: `lib/src/widgets/comic_episode.dart` and `lib/src/data/door_episode.dart`
for storytelling, `lib/src/ink/` for input/rendering/assessment,
`lib/src/widgets/stylus_playground.dart` for games, and `worker/index.mjs` for the
backend. Multi-session plans and implementation limits live in `plan/`.

## Google sign-in setup and deployment

The app renders Google's official Identity Services button on the landing screen
and in the save/account panel. Play without signing in remains available.

Forge local preview requirements and current integration blockers are recorded in
[`FORGE_DIAGNOSTICS.md`](FORGE_DIAGNOSTICS.md). Host routing, HTTPS and mobile
preview services belong to the Forge, not to manual user setup.

Use an **app-specific Google OAuth Web application client**. Its JavaScript popup
callback sends the ID token to this app's same-origin `POST /api/auth/google`.
The endpoint, challenge, sessions, and progress API deploy together with the
existing Cloudflare Worker; no separate callback service or Google client secret
is needed. Sharing implementation code across apps is fine, but sharing login
sessions or a central callback is a separate SSO architecture.

One-time Google setup:

1. Create/select a Google Cloud project, configure Google Auth Platform branding,
   audience/test users as appropriate, and create an OAuth **Web application** client.
2. Add `https://arabiya.tlatoani.net` as an **Authorized JavaScript origin**.
   Register development origins separately if you need real local login. Origins
   contain scheme/host/port, never `/api/auth/google`.
3. Put the public client ID (`…apps.googleusercontent.com`) into
   `vars.GOOGLE_CLIENT_ID` in `wrangler.jsonc`. This value is not a secret.
4. Run `npm ci`, then `npm run deploy`. The existing build command builds Flutter;
   Wrangler deploys static assets, the Worker, its `/api/*` handlers, domain binding,
   configured client ID, and Durable Object migration together. The same process
   works in an already-configured Cloudflare Workers Builds pipeline.

This implementation uses popup mode, so it does **not** require an Authorized
Redirect URI. If a future implementation switches to redirect mode, register its
exact callback URI then. Google-side branding/client registration and domain
origins cannot be created by this project's Wrangler configuration.

The server verifies the signed token's audience, issuer, expiry and browser-bound
nonce before creating an expiring Secure/HttpOnly/SameSite session cookie. Google
IDs (`sub`) identify accounts; email changes do not create a new save. Google
credentials and session tokens are not stored in browser-readable preferences.
Legacy passport bearer sessions remain supported by the backend, but the UI no
longer offers the default-passcode passport flow.

With an empty client ID, sign-in stays unavailable and local play still works.
After configuration/deployment, verify real Google login, reload/session restore,
progress on a second device, logout, and expiry in the supported browsers. Local
unit/integration tests use signed fixture tokens and a stubbed Google client;
they do not establish that the production OAuth registration is correct.

Checks: `npm run test:worker`, `flutter analyze`, `flutter test`, and
`npm run deploy:check` (builds the app before checking deployment packaging).

Official references: [Google button](https://developers.google.com/identity/gsi/web/guides/display-button),
[client setup](https://developers.google.com/identity/gsi/web/guides/get-google-api-clientid),
[token verification](https://developers.google.com/identity/gsi/web/guides/verify-google-id-token).
