# Cloud Edge & Zero-Setup Auth (`@trace spec:cloud-edge-sync`)

## Purpose

Defines the Cloudflare Worker (`worker/index.mjs`), `wrangler.jsonc`, and SQLite-backed Durable Object (`ArabiyaState`) for `arabiya.tlatoani.net`, ensuring everything is auto-created on Cloudflare on the first deployment with zero manual database setup.

## Requirements

### Requirement: Auto-Provisioned SQLite Durable Object on Free Tier

The `wrangler.jsonc` configuration SHALL bind a SQLite-backed Durable Object (`new_sqlite_classes: ["ArabiyaState"]` under `migrations: [{ "tag": "v1" }]`) and serve `./build/web` via Cloudflare Workers Static Assets with `/api/*` routed to `worker/index.mjs`.

#### Scenario: First deployment to Cloudflare

- **WHEN** Cloudflare Workers Builds or `wrangler deploy` deploys the repository
- **THEN** the `arabiya` Worker, static assets, custom domain route `arabiya.tlatoani.net`, and the SQLite tables (`users`, `sessions`, `progress`, `letter_mastery`) inside `ArabiyaState` are created automatically without requiring any pre-created D1 database UUID

### Requirement: Zero-Config Cloud Passport + Optional Google OAuth SSO

Because external Google Cloud OAuth Client IDs cannot be minted inside `wrangler.jsonc`, the Worker SHALL support **two seamless authentication modes out of the box**:
1. **1-Tap Traveler Passport (`POST /api/auth/passport`):** Works immediately on first deployment with zero external secrets—players enter a handle/email (and optional passcode) to claim a persistent cloud profile backed by an `HttpOnly; Secure; SameSite=Lax` HMAC-SHA256 session cookie and bearer token.
2. **Google Identity Services ID Token Verification (`POST /api/auth/google`):** Verifies signed Google OAuth JWT credentials against Google's public JWKS (`https://www.googleapis.com/oauth2/v3/certs`) via Web Crypto whenever a `GOOGLE_CLIENT_ID` variable is present in `wrangler.jsonc` (or runtime `/api/config`), linking the Google account to the same `ArabiyaState` profile.

#### Scenario: Player signs in and syncs progress across devices

- **WHEN** a player signs in via Cloud Passport or Google SSO and calls `POST /api/progress`
- **THEN** the Worker merges their local progress with the cloud SQLite row using monotonic max/union semantics (`MAX(xp)`, `MAX(chapter_index)`, union of unlocked letters, chapters, and character affinity stars for Nūr, Yāsmīn, and Laylā) and returns the unified state

### Requirement: Official Google Button and App-Owned Popup Callback

- The web app SHALL render the official Google Identity Services button on the
  landing screen and in the save/account dialog, with local play available.
- Popup credentials SHALL be submitted as same-origin JSON to
  `POST /api/auth/google`, using a challenge from `GET /api/auth/google/challenge`.
- The Worker SHALL validate Google's RS256 signature, configured audience,
  issuer, expiry, subject and nonce before creating a Secure/HttpOnly/SameSite
  session. Account identity SHALL use `sub`, never email alone. Sessions SHALL
  expire after 30 days and be revocable by logout.
- The browser SHALL retain only a cookie-session marker, not Google credentials
  or Google-session bearer tokens, in preferences. Cached identity alone SHALL
  NOT imply a confirmed cloud session.
- Guest progress MAY be merged on first explicit Google sign-in. Progress owned
  by a previous account SHALL NOT be imported into another account.
- Sign-in SHALL fail closed with local play available when the public client ID
  is absent or validation fails. Save status SHALL distinguish local storage,
  pending/failing upload and acknowledged cloud synchronization.
- Wrangler SHALL deploy the callback in this project's Worker with `/api/*`.
  Google OAuth registration/authorized origins SHALL be configured separately.
  Popup mode SHALL NOT require a redirect URI or a client secret.

The earlier passport requirements describe the legacy backend. The current UI
uses Google identity rather than offering a shared-default-passcode cloud login.
Cookie sessions are opaque random tokens, not the earlier proposed HMAC format.
