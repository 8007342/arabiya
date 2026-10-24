# Roadmap

- [ ] Scaffold Flutter + Flame project, voice pipeline (`scripts/voice-pipeline.sh`), and Cloudflare Worker (`wrangler.jsonc` + `worker/index.mjs`) on the `comicbook` branch.
- [ ] Implement the 12-Chapter trilingual playable comic story data (Book I: Dubai with Nūr, Book II: Levant with Yāsmīn, Book III: Cairo with Laylā) with Spanish-Arabic cognates, dialect switchboard, and MSA subtitle bridges.
- [ ] Build the Flame animated comic stage (procedural character rigs for Tlatoāni, Covi, mācron āi, Nūr, Yāsmīn, and Laylā; emoji bubbles; camera transitions; RTL Arabic glyph tracer; and rewind mastery gates).
- [ ] Implement the Canonical Voice Engine & Web Audio synthesizer for all 6 characters.
- [ ] Implement Zero-Friction "Sign In to Resume" landing screen, Cloud Passport + Google SSO auth, and SQLite Durable Object progress sync, then verify, merge `comicbook` to `main`, push, and publish preview.
