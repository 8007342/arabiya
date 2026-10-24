# Arabiya — Tillandsias / Forge field report

Date: 2026-10-24. Audience: Forge maintainers. This report includes successes,
workarounds and failures, not only feature requests.

## User's infrastructure contract

The Forge should provide local test serving, routing, HTTPS, state persistence,
identity testing and GitHub-connected Cloudflare deployment as services. Do not
ask the user to edit hosts files, install certificates, create ad-hoc tunnels,
copy API tokens into an agent terminal or manually recreate infrastructure.

The user already ran `tillandsias --cloudflare-login` on the host. The desired
production workflow is the dashboard's **Create Worker → select GitHub repo →
configure build → deploy**, exposed through the Forge. Repo: `8007342/arabiya`;
production branch: `main`; Worker: `arabiya`; domain: `arabiya.tlatoani.net`.
The user has limited cloud build minutes: finish checks locally, push once, trigger
one necessary build, and observe it. Do not create repeated speculative deployments.

## What worked out of the box

- Workspace/source access and concurrent Astra agents worked. Shared files were
  visible immediately; assigning ownership avoided conflicting edits. A separate
  review caught a duplicate-dot grading bug before release.
- Git fetch and repository discovery worked through the enclave mirror. Startup
  advertised `push_state=can-push`; discipline tools correctly reported level 0.
  GitHub connector resolved `8007342/arabiya` with push/admin metadata. Push outcome
  is recorded separately when the final source commit is published.
- Shell tools, npm/locked dependencies, Node WebCrypto/SQLite test harnesses, and
  the Flutter wrapper worked. Flutter 3.47.7 release builds and static analysis
  succeeded. No manual SDK installation by the user was needed.
- The outbound proxy supported package/model downloads. Local Kokoro neural TTS
  generation produced all 41 replacement English/Spanish lines and new episode
  recordings without a paid speech account or a runtime cloud TTS dependency.
  Normal app builds now validate bundled speech fully offline.
- Host browser tools provided a trusted-HTTPS preview, screenshots, CDP interaction
  and iPhone 17 Pro Max viewport/touch emulation. This is useful device emulation,
  not evidence that a physical iPhone or Lenovo pen has been tested.
- The managed preview preserved the previous serving generation when a replacement
  failed. This kept a usable static preview available during Worker diagnosis.
- The Cloudflare connector's scope probe and Worker-list reads worked and made the
  difference between host authentication and deployment permission visible.

## What needed investigation or an app-side fix

### Worker dependency visibility — fixed

Managed Wrangler could not resolve `jose` from this checkout's node_modules.
The app now explicitly bundles its Worker/dependencies into
`build/worker/index.mjs` with `scripts/build-worker.sh`; the regular app build
invokes it, and `esbuild` is locked as a development dependency. Publishing this
bundle succeeded. The host no longer needs to resolve app runtime npm imports.

Forge requirement: define a fresh-checkout build/dependency contract, build with
locked project tools, and serve matching Worker/assets generations. Do not rely
on ignored files left over from an earlier agent session. Rebuild source changes
before reporting a newly served generation as ready.

### Runtime/version diagnostics — partly useful

Host logs identified Wrangler **4.42.0**, whereas the project pins **4.151.2**.
The bundle starts, but the version difference required investigation. Report
runtime drift explicitly or provide a documented compatibility contract.

The host logs DNS failure for `workers.cloudflare.com` and falls back to placeholder
`Request.cf`; the server still starts. Clearly separate this nonfatal warning from
actual health failures. Do not report that all external networking is broken:
other outbound package/model downloads succeeded.

### Local app and API — running

`publish_local({category:"WEB", runtime:"wrangler"})` succeeds. Current URL:
`https://www.arabiya.localhost:18443`. The app, `/api/config`,
`/api/auth/google/challenge` and `/api/auth/session` return 200. Google is configured,
a nonce is produced, and a fresh session correctly reports unauthenticated.

Browser smoke test: opened the ink playground, drew alif using browser mouse input,
submitted it, and verified a saved guided evidence event (coverage 1, no extra ink,
XP 0). This proves this local UI/capture/assessment/storage path for that sample.
It does not prove authenticated Durable Object persistence or physical pen support.

## What did not work / outstanding services

### Same-origin authenticated mutations — blocked

From `https://www.arabiya.localhost:18443`, real browser JSON POSTs to
`/api/auth/google` and `/api/auth/passport` returned **403**:
`{"error":"Same-origin request required"}`. Requests used same-origin credentials.
The app compares the browser Origin to `new URL(request.url).origin`.

Forge requirement: preserve external scheme/hostname/port and Origin through the
proxy/runtime path, or provide a defined authenticated public-origin adapter.
Diagnose both values in Forge-owned logs to distinguish host/scheme/port rewriting.
Do not bypass CSRF validation or trust arbitrary client-supplied forwarded headers.
Preserve Secure/HttpOnly/SameSite cookies and multiple Set-Cookie headers.

One first POST also returned `503 Your worker restarted mid-request`; a stable
retry reproduced 403. Provide readiness/generation information to distinguish
transient replacement failures from application errors.

### Real Google browsing and stable OAuth origin — blocked/unverified

Browser fetch probes to `https://accounts.google.com/gsi/client` and
`https://www.googleapis.com/oauth2/v3/certs` failed with `TypeError: Failed to fetch`.
Browser fetch alone cannot distinguish CORS from egress policy. The browser tool
contract restricts windows to project routes; it provides no supported external
Google account authentication workflow. Worker-side JWKS egress remains unverified.

Forge requirements:

- Provision a stable Google-compatible hostname under a real registered domain,
  trusted HTTPS and routing automatically. Proposed test name:
  `test.arabiya.tlatoani.net` (the user's earlier `tlatiani.net` was a different
  spelling, not evidence of a configured domain).
- Publish the exact origin as machine-readable configuration. Manage authorized
  OAuth origins where delegated Google administration exists; otherwise report the
  exact external registration prerequisite once. Wrangler cannot create it.
- Provide a scoped external-identity browser policy supporting the official Google
  SDK, popup/FedCM/frames and relevant network requests, plus Worker JWKS egress.
- Provide a user-visible login handoff where the user enters credentials/MFA
  privately; agents inspect app results without reading passwords or token values.
- Make the preview reachable from a physical phone through Forge-managed routing
  and trusted HTTPS. Host CA trust alone does not establish iPhone trust.

The app uses an ID-token popup: it does not require a Google client secret.
Real Google login and two-device sync are not claimed as verified.

### Persistent local backend state — not yet verified

Authentication POSTs prevented a genuine write/restart/read probe. Provide project/
environment/lane-scoped Durable Object persistence outside disposable runtimes,
with stable identity/lifetime across reloads and rebuilds, and explicit reset and
snapshot/restore operations. Never attach production storage as a workaround.

### Failed-candidate logs — insufficient

After a failed replacement, `service_status` exposed the failure but `service_logs`
returned the previous static server's logs. Preserve and address logs by candidate/
generation so a running fallback does not conceal the startup failure.

### GitHub-connected Worker creation / deployment — unavailable to agent

Both before and after host `tillandsias --cloudflare-login`, the scope probe exposed
read-only account, Workers and Builds tools. There is no tool to create a Worker,
connect the installed GitHub repository, configure a production build trigger or
request a deployment. The inspected account's Worker list did not contain arabiya.
Local `wrangler whoami` still reported unauthenticated after host login.

An earlier `npm run deploy` built successfully, then exited 1 because noninteractive
Wrangler requires a deployment credential. No production resources were created by
that failed attempt. After the user clarified the preferred GitHub workflow and
cloud-minute limit, no more direct deployment attempts were made.

Required Forge operation: an idempotent **ensure GitHub-connected Worker** service:

1. Use the host's Cloudflare session and installed GitHub integration internally.
2. Resolve repo `8007342/arabiya`, branch `main`, root directory `/`.
3. Create/find Worker `arabiya`; connect repository/production trigger; use the
   existing `wrangler.jsonc` for assets, domain and SQLite Durable Object migration.
4. Set an explicit Flutter build command (`npm run build`) and deploy command
   (`npx wrangler deploy`), confirming the pipeline builds once rather than twice.
   Workers Builds settings must be managed as well as checked-in Wrangler config.
5. Trigger only the requested final revision, deduplicate requests by commit, and
   expose build/deployment IDs, logs, status and consumed build minutes.
6. Keep authentication on the host. Do not expose a broad Cloudflare token to the
   agent, force manual dashboard setup, or use an unrelated temporary account.

Git push, Worker creation, repository connection and successful deployment are
separate results; a successful push must not be reported as a live deployment.

## Acceptance checks for maintainers

- One publish call from a fresh checkout builds and serves the complete app/API.
- Same-origin POST succeeds through the actual proxy; foreign-origin POST fails.
- Official Google login succeeds in a supported user-visible browser, with no
  credential/token leakage into agent logs.
- Save a checkpoint, reload, restart the Forge runtime, then use a clean browser
  profile with the same Google account: progress returns from the local backend.
- Another account gets separate progress; logout revokes the session; offline
  changes survive reload and upload on reconnect.
- A physical iPhone and Lenovo stylus can reach/use the test service.
- The host's GitHub-connected deployment operation provisions this project's
  resources once and observes a single requested build without repeat cloud spend.

## Current app verification and limits

`npm run check`: **33 Flutter tests**, **9 Node backend/bridge tests**, and **5 voice
integrity cases** passed; analyzer clean. Tests include adversarial ink/dots,
cancel/clear/target-change/stylus takeover, late-save replies, account isolation,
scene replay/resume, and phone layouts at 200% text. Release web builds succeeded.
The 218 bundled MP3s were hash-checked and decoded to finite non-silent audio.

The app now has an eight-shot comic, integrated label writing, stylus activities,
per-account evidence, saved scene position, enlarged notebook/archive and actual
neural English/Spanish recordings. Formation grading covers four constrained
letters and remains experimental; broader connected writing, native educator
review, physical pen verification and real cloud SSO are still outstanding.

## Follow-up: writing gestures and check feedback

The user reported finger/stylus strokes scrolling the page and invisible check
feedback. These were application interaction defects, not failures of Forge routing.
The prior pan recognizer competed with parent scrolling; results were rendered
below the fold. Flutter browser elements also reported native `touch-action:auto`.

Fix: all writing activities now open a shared fixed desk, own their gesture
sequence immediately, and suppress browser-native pan/overscroll only for the
lifetime of that desk. Controls stay docked; check feedback opens an immediate,
large result panel. Instructions/palettes scroll separately. Browser gesture
styles are restored when leaving the desk; normal reading still scrolls.

What worked: the Forge's iPhone 17 Pro Max emulation plus CDP touch input reproduced
real browser finger events. A complete ba body and separate dot produced accepted
`touch` evidence with coverage 1, page scrollY stayed 0, and the visible result was
confirmed by screenshot. On leaving the desk, computed touch-action returned to
`auto` and overflow to `visible`. Native widget regressions cover both touch and
stylus ownership inside a scrollable parent, fixed controls/result geometry at
200% phone text, and free-ink/ribbon desk navigation. This is emulation, not a claim
of testing the user's physical Lenovo stylus or iPhone. No cloud build/deployment
was requested for this follow-up; changes are served through the local preview.
