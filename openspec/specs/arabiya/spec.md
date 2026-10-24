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

### Requirement: Animated Multi-Panel Playable Comic

Each chapter SHALL be presented as an interactive comic strip with expressive character animations (breathing, blinking, gill-fluttering, blushing, tail movement, camera transitions, and parallax depth) where **Tlatoāni** speaks in Spanish, **Covi** speaks in English, **mācron āi** reacts silently in the background with emoji-only speech bubbles, and local characters (**Nūr**, **Yāsmīn**, **Laylā**) speak vocalized Arabic.

#### Scenario: Advancing through a comic scene

- **WHEN** the player taps or interacts with a comic panel
- **THEN** the camera transitions smoothly, the active speaker animates and voices their line, Arabic script words are highlighted with tap-to-hear *tashkīl* phonetics and Spanish/English cognate bridges, and **mācron āi** pops contextual emoji bubbles in the background

### Requirement: Interactive Arabic Glyph Tracing & Mastery Gates with Rewind

Every chapter SHALL validate learning through embedded interactive challenges (Right-to-Left letter stroke tracing, cognate/script decoding, and culturally appropriate spoken dialogue choices). Passing advances the story and syncs cloud progress; failing rewinds the comic 2–3 panels so the characters naturally reinforce the concept before retrying.

#### Scenario: Failing a chapter mastery check

- **WHEN** the player misses the validation check at the end of a comic sequence
- **THEN** the story playfully rewinds 2–3 panels with a supportive reaction from **Tlatoāni**, **Covi**, and **mācron āi** (`🔄📖✨`) so the learner reviews the target letters or phrases in context before trying again

#### Scenario: Passing a chapter mastery check

- **WHEN** the player completes the letter tracing and dialogue validation check
- **THEN** the chapter unlocks its Arabic letters/roots in Tlatoāni's Notebook, awards XP and affinity stars, advances to the next chapter, and syncs state to the Cloudflare SQLite Durable Object
