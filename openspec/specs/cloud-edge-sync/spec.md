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
