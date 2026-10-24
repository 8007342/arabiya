# Arabiya (`arabiya.tlatoani.net`)

A zero-friction, playable trilingual comic adventure built with **Flutter + Flame** where **Tlatoāni** (speaking Spanish), **Covi** (speaking English), and silent emoji-bubbling **mācron āi** travel across Dubai, the Levant, and Cairo—taking learners from zero Arabic to reading the alphabet, ordering coffee, charming local Axolotls (**Nūr**, **Yāsmīn**, and **Laylā**) in culturally authentic spoken Arabic, and watching Arabic TV/YouTube with subtitles.

## Stack

- **Frontend Engine:** Flutter Web (`CanvasKit`/`Skwasm` with HarfBuzz RTL Arabic shaping) + **Flame Engine** (`FlameGame`, procedural character animations, camera pan/zoom comic panels, interactive RTL Arabic glyph stroke tracer, and emoji speech bubbles).
- **Voice & Audio:** Canonical Character Voice Engine + Regenerative Voice Pipeline (`scripts/voice-pipeline.sh` + `assets/voices/voice-manifest.json`) supporting Spanish (`Tlatoāni`), English (`Covi`), vocalized Arabic (`Nūr`, `Yāsmīn`, `Laylā`), and procedural Web Audio harmonic synth bloops (`mācron āi`).
- **Cloud Edge & Auth:** Cloudflare Workers with Static Assets + **SQLite-backed Durable Objects** (`ArabiyaState`) on `arabiya.tlatoani.net`—auto-provisioned from `wrangler.jsonc` on first deployment with zero external database setup, supporting both **Google Identity Services (SSO)** and **1-Tap Cloud Passport** sync.
