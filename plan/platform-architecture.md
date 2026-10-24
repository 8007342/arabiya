# Browser-first platform proposal

2026-10-24. Architecture proposal. Update: the official web Google button, app-owned Worker login, cookie sessions, basic save status and pending-save preservation are now implemented locally; production OAuth configuration and live login verification remain outstanding. Audit notes below describe the pre-implementation baseline. The ink engine and transactional outbox remain proposals. Extends `comic-writing-direction.md` with the user's pressure-sensitive calligraphy and low-friction Google sign-in requirements.

## Decisions

The user also requests a **Play with a Stylus** mini-game collection using our own stack: pressure-responsive ink and nib-direction tools where supported, with finger-accessible alternatives. This remains planned work; Google identity is the current implementation slice.

Keep Flutter/Flame and the existing Cloudflare hosting foundation. Build a browser-first, local-first application. Everyday handwriting is the core; gameplay unlocks calligraphy. Huge readable text and mobile support are baseline requirements. A native build is an optional adapter for demonstrated platform limitations, not the starting architecture.

## Recognition dependencies: what is actually available

- [MyScript iinkTS](https://github.com/MyScript/iinkTS) is an Apache-2.0 client covering ink capture/rendering, editing, and cloud integration. Its README explicitly connects recognition to MyScript Cloud. It is useful source to study, not published recognition weights. No public open-source core recognizer was established by this research. [Commercial service pricing](https://developer.myscript.com/pricing/) distinguishes development allowances from production contracts.
- [Google ML Kit](https://developers.google.com/ml-kit/vision/digital-ink-recognition/) provides offline native Android/iOS recognition. It is not an ONNX package, model-training SDK, or browser engine. Its [terms](https://developers.google.com/ml-kit/terms) restrict extraction/reverse engineering of related software, including models. Do not plan to convert its model into a web asset. A future native adapter can invoke the supported API.
- [ONNX Runtime](https://onnxruntime.ai/docs/get-started/training-on-device.html) is an independent runtime/training option for a model we develop or appropriately license. Its [web deployment documentation](https://onnxruntime.ai/docs/tutorials/web/deploy.html) includes a training WASM binary, but browser training is not a free Arabic recognizer or grading system. Prefer offline model training followed by browser inference initially; evaluate local personalization only for a demonstrated need.

## Components and boundaries

1. **Comic player:** authored scene beats, readable live text, voice playback, prop interactions, replay and accessible transcript. Flutter/Flame remain responsible for presentation.
2. **Ink capture:** `InkAttempt` containing separate strokes, raw coordinates/times, available pressure/tilt, pointer kind, canvas transform, target and assistance. Preserve raw samples separately from display smoothing. Never grade predicted display points as measured input.
3. **Ink renderer:** responsive preview, round pen and broad-nib brushes, pressure curves, taper and optional texture. Render immediately; never wait for recognition or a network request to draw. Pressure affects width for round/brush tools. A broad-nib qalam also varies width with nib angle relative to stroke direction; pressure alone is not an adequate simulation. Provide a fixed virtual nib angle where hardware orientation is unavailable.
4. **Assessment:** deterministic geometry/component checks plus an optional recognizer adapter. Return evidence and concrete feedback, with rubric/version and uncertainty. Separate transcription from formation quality, and everyday legibility from style-specific calligraphy.
5. **Learning engine:** independent evidence for shape, dots, joins, spelling, recall, retention and composition; select the next exercise from observed needs. Assistance, device/tool and optional other-hand practice remain recorded. Model personalization must not gradually learn to accept malformed writing.
6. **Local persistence and sync:** transactional IndexedDB progress/event outbox, versioned migrations, retry and server acknowledgements. Keep model downloads and story/audio packs in separate versioned caches. Saving progress must not depend on signing in or network access.
7. **Cloud:** Google identity verification/session establishment, idempotent event ingestion, progress synchronization, and asset delivery using the existing Worker foundation. Partition state by user as scale requires rather than routing all users through the current global Durable Object. No cloud recognition is required for ordinary guided exercises.

Use interfaces for capture, recognition, rendering and assessment so a native adapter or a different recognizer can be added without rewriting lessons or save data. Start capture through Flutter's low-level pointer APIs; compare with raw DOM events on the actual devices and add a small JS bridge only if relevant data is lost.

## Stylus and performance strategy

[Browser Pointer Events](https://www.w3.org/TR/pointerevents/) expose pressure, tilt, twist, pen identification and optional coalesced samples when supported. Their existence does not prove that a particular Lenovo pen/driver/browser reports meaningful values. Constant default pressure must not be presented as a measured expressive signal.

Test Fedora Chrome and Windows Chrome for pen down/up, pressure range/variation, tilt, eraser/buttons, palm interaction, sampling gaps, cancellation, zoom and latency. Test iPhone touch input and narrow layouts separately. Finger input needs good fixed-width and virtual-nib tools; do not require hardware pressure to earn general progress.

Ordinary variable-width ink should not require ML, an NPU, or custom GPU compute. Use the existing rendering path first, profile, then consider a dedicated canvas/renderer if necessary. Heavy assessment/inference should run away from the drawing/animation path. ONNX WASM is the cross-device inference baseline; accelerated execution is optional and feature-detected.

Installing the PWA improves launch/offline packaging but does not itself grant additional stylus APIs. A native Flutter build may expose useful native input/recognition, subject to OS/drivers; GPU/NPU acceleration alone does not unlock pen data. Consider native only after a measured browser limitation warrants the additional distribution/support burden.

## Google identity and honest autosave

Current audit: `wrangler.jsonc` has an empty `GOOGLE_CLIENT_ID`; `web/index.html` does not load Google Identity Services; neither the Flutter service nor Worker implements Google login. `/api/config` advertises a possible mode but is not authentication. `cloud-edge-sync/spec.md` overstates the implementation. The UI shows a cloud-done icon independent of actual acknowledgement; sync errors are swallowed. Fix these gaps rather than adding a cosmetic button.

Proposed flow:

1. Landing has the official **Sign in with Google** button and an equally immediate play-with-local-save route. Returning players resume the story.
2. While signed out, a persistent accessible save badge says **Saved on this device** and offers **Sign in to sync**. Tapping it opens a small account/save sheet with the official Google button; do not imitate Google branding with an ambiguous custom logo.
3. Use [Google Identity Services](https://developers.google.com/identity/gsi/web/guides/display-button). Send its credential to our backend; validate signature, audience, issuer, expiry and the chosen flow's CSRF/nonce requirements using a suitable maintained JWT library. Identify users by Google's stable `sub`, not an email address. [Verification guidance](https://developers.google.com/identity/gsi/web/guides/verify-google-id-token).
4. Establish our own expiring/revocable secure HttpOnly cookie session; avoid long-lived bearer credentials in browser-readable preferences. Validate the session before showing an authenticated cloud state. Retire the default-passcode passport as the normal cloud account path; offline play is a local guest, not simulated authentication.
5. On first sign-in, attach only the current guest's pending progress deliberately and transactionally. Preserve cloud history. Account switches/sign-out must partition local records/outboxes so one person's attempts do not upload to another account.
6. Sync events with unique IDs and server acknowledgements. Retries must not duplicate XP, achievements or attempts. Derive learning summaries from evidence; max/union merging is insufficient for current scene position, settings, recency and retention. Give each field an explicit conflict rule, revisions and migration path. Preserve the local checkpoint if synchronization fails.

Save badge states: **Saved on this device**, **Saving to cloud**, **All changes synced**, **Offline — sync pending**, **Sign in to resume sync**, and **Sync failed — retry**. A small floppy-disk animation appears only while work is pending; reduced-motion mode uses a static symbol. Include accessible state text, and do not announce every pen sample. Mark cloud success only after server acknowledgement. Local saves happen first; avoid a blanket console-style warning that unnecessarily blocks leaving the scene.

Google setup requires an OAuth web client ID with configured authorized origins/branding. The [official setup](https://developers.google.com/identity/gsi/web/guides/get-google-api-clientid) is a deployment prerequisite; a public client ID is configuration, not a secret. Real login testing also needs a configured test origin/account. Do not claim production SSO works before this round-trip is tested.

## Deliverable sequence

1. Diagnostic ink playground with huge text, pressure visualization, round/broad-nib tools, raw capture/replay and capability reporting. Validate both Yogas and iPhone; keep raw sample export local by default.
2. Durable local saves, outbox and truthful save badge; implement official Google sign-in/backend sessions, then test failed/offline saves, session expiry, retries, account switching and two-device conflicts.
3. Teacher-reviewed small writing rubric and adversarial attempts; separate legibility/calligraphy criteria and demonstrate guided → copy → recall. Benchmark errors across devices and writers.
4. Integrate with one authored comic episode and replayable non-lesson scene; validate enjoyment and independent writing separately.
5. Add optional recognition adapters and train a model only if benchmark results justify it. Expand mini-games, visual assets and chapters using the shared engine.

Implementation status: Google identity/basic save integration has automated tests and a release build; the other deliverables remain planned. See README for OAuth configuration and deployment instructions.
