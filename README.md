# Arabiya (`arabiya.tlatoani.net`)

A zero-friction, playable trilingual comic adventure built with **OpenSpec + Flutter + Flame** where **Tlatoāni** (speaking Spanish), **Covi** (speaking English), and silent emoji-bubbling **mācron āi** travel across Dubai, the Levant, and Cairo—taking you from zero Arabic to reading the alphabet (*Abjad*), ordering coffee, charming **Nūr (`نُور`)**, **Yāsmīn (`يَاسْمِين`)**, and **Laylā (`لَيْلَى`)** in culturally authentic spoken Arabic, and watching Arabic TV, news, and YouTube with subtitles.

## Highlights

- **Trilingual Playable Comic Engine (Flutter + Flame):**
  - **Tlatoāni** (pink axolotl sage, single tail, no mustache, coral feathery gills that blush bright red) speaks in **Spanish**, unlocking Arabic through ~4,000 *Al-Andalus* cognates (*azúcar, aceite, almohada, ojalá, hasta, alcalde*).
  - **Covi** (white ambiguous apprentice figure) speaks in **English**, playfully teasing Tlatoāni whenever he blushes and asking the exact questions learners have.
  - **mācron āi** (toy-sized desktop robot with cyan `•ᴗ•` screen and modular right arm) hangs out silently in the background of every panel with **emoji-only speech bubbles** and procedural harmonic synth bloops.
  - **Three Regional Heroines & Dialects:**
    1. **Book I — Dubai with Nūr (`نُور`):** Arabic script shapes, *ḥarakāt*, non-connectors vs. connectors, Sun & Moon letters, Arabic coffee (`قهوة عربية`), and Emirati (*Khalījī*) warmth.
    2. **Book II — Beirut & Amman with Yāsmīn (`يَاسْمِين`):** Emphatic letters (completing all 28 letters!), numbers `٠–٩`, Tillandsias & jasmine gardens, Levantine (*Shāmī*) wit & courtship etiquette (*Adab*, *Tikram ‘aynak*, *Damik khafīf*, *‘Alayya!*).
    3. **Book III — Cairo with Laylā (`لَيْلَى`):** Triconsonantal roots (*Jadhr* `جذر`), the Cairo–Beirut–Dubai dialect switchboard, Nile *felucca* & indie cinema dates, and the **10 MSA-to-Dialect Subtitle Bridges** for watching Arabic YouTube & TV news.
- **Canonical Voice Engine & Regenerative Pipeline (`scripts/voice-pipeline.sh`):**
  - Spec-driven voice profiles in `assets/voices/voice-manifest.json` for **Tlatoāni**, **Covi**, **Nūr**, **Yāsmīn**, **Laylā**, and **mācron āi**, combining browser neural/Web Speech TTS with procedural Web Audio harmonic voice signatures.
- **Zero-Friction UX & Cloud Sync (`arabiya.tlatoani.net`):**
  - Returning players skip the landing screen and land directly in their active comic panel.
  - Backed by a **Cloudflare Worker + SQLite Durable Object (`ArabiyaState`)** configured in `wrangler.jsonc`—auto-provisioned on first deploy in the Free Tier, supporting both **1-Tap Cloud Passport** and **Google Sign-In (SSO)**.

## How This Project Is Organised

- `openspec/specs/`: OpenSpec specifications (`arabiya`, `character-canon`, `voice-canon`, `curriculum-and-comics`, `cloud-edge-sync`).
- `plan/roadmap.md`: Multi-session roadmap tracking remaining work.
- `assets/voices/voice-manifest.json` & `scripts/voice-pipeline.sh`: Canonical character voice definitions and code generator.
- `lib/`: Flutter + Flame playable comic engine, procedural character rigs, RTL Arabic calligraphy stroke tracer, 12-chapter story data, and audio/voice engine.
- `worker/index.mjs` & `wrangler.jsonc`: Cloudflare Worker + SQLite Durable Object backend for `arabiya.tlatoani.net`.
