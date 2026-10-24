# Arabiya Core Experience

## Purpose

Deliver a zero-friction, gamified playable comic that takes a Spanish/English speaker from zero knowledge of Arabic to reading the Arabic script (*Abjad*), speaking confident survival and social phrases across major dialects, and following Arabic media with subtitles.

## Requirements

### Requirement: Zero-Friction "Sign In to Resume" Landing & Auto-Resume

The app SHALL provide a single, menu-free entry flow that drops authenticated or returning players directly into their active comic panel, and lets new players either sign in (via Google SSO or 1-Tap Cloud Passport) or start playing immediately with automatic local checkpointing.

#### Scenario: Returning authenticated user opens the app

- **WHEN** a user with an active session or saved local checkpoint opens `arabiya.tlatoani.net`
- **THEN** the app skips the landing screen and resumes directly at their current chapter and comic panel with their unlocked Arabic notebook and score intact

#### Scenario: First-time visitor opens the app

- **WHEN** a first-time visitor opens the app without an existing session
- **THEN** a warm animated vignette of **Tlatoāni**, **Covi**, and **mācron āi** appears with a **"Sign In to Resume / Save to Cloud"** action and an instant **"Start the Journey"** action, with no nested settings menus

### Requirement: Full-Screen Composed Playable Comic with Auto-Play Voices

Each chapter SHALL be presented as a **100% full-screen playable comic (`100vw × 100vh`)** — never a form or card layout — composed of layered artwork assets (parallax Middle Eastern backdrops, midground architecture, high-resolution character sprite layers with breathing, gill-fluttering, and blushing poses, and foreground props). Dialogues SHALL be rendered inside **comic speech bubbles pointing directly to the speaking character**, with **auto-play voice narration** on every panel:
- **Tlatoāni** speaks naturally in **Mexican Spanish (`es-MX`)** without redundant English translation subtitles.
- **Covi** speaks naturally in **American English (`en-US`)** without redundant Spanish translation subtitles.
- **mācron āi** reacts silently in the background with **emoji-only speech bubbles**.
- **Nūr**, **Yāsmīn**, and **Laylā** speak vocalized Arabic (`ar`) with inline interactive Arabic word tokens and bundled calligraphic fonts (`NotoSansArabic`, `Amiri`, `NotoSans`, `NotoEmoji`) so Arabic glyphs and emojis never render as missing-glyph boxes (`☒`).

#### Scenario: Advancing through a full-screen comic scene

- **WHEN** the player enters or taps a comic panel
- **THEN** the full-screen camera and layered artwork transition smoothly, the active speaker's speech bubble appears with a tail pointing to them, their voice line auto-plays immediately, Arabic script words are highlighted inside the bubble for tap-to-hear *tashkīl* phonetics, and **mācron āi** pops contextual emoji bubbles in the background

### Requirement: Interactive Arabic Glyph Tracing & Mastery Gates with Rewind

Every chapter SHALL validate learning through embedded interactive challenges (Right-to-Left letter stroke tracing, cognate/script decoding, and culturally appropriate spoken dialogue choices). Passing advances the story and syncs cloud progress; failing rewinds the comic 2–3 panels so the characters naturally reinforce the concept before retrying.

#### Scenario: Failing a chapter mastery check

- **WHEN** the player misses the validation check at the end of a comic sequence
- **THEN** the story playfully rewinds 2–3 panels with a supportive reaction from **Tlatoāni**, **Covi**, and **mācron āi** (`🔄📖✨`) so the learner reviews the target letters or phrases in context before trying again

#### Scenario: Passing a chapter mastery check

- **WHEN** the player completes the letter tracing and dialogue validation check
- **THEN** the chapter unlocks its Arabic letters/roots in Tlatoāni's Notebook, awards XP and affinity stars, advances to the next chapter, and syncs state to the Cloudflare SQLite Durable Object
