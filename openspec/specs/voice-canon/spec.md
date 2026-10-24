# Voice Canon & Regenerative Pipeline (`@trace spec:voice-canon`)

## Purpose

Defines the canonical voice personalities for **Tlatoāni**, **Covi**, **Nūr**, **Yāsmīn**, **Laylā**, and **mācron āi**, along with a deterministic, spec-driven pipeline (`scripts/voice-pipeline.sh` + `assets/voices/voice-manifest.json`) so refining any character's voice guidelines updates the entire application cleanly.

## Requirements

### Requirement: Character Voice Personalities

Each character SHALL have a distinct, canonical voice profile stored in `assets/voices/voice-manifest.json` and enforced by the runtime audio synthesizer:

1. **Tlatoāni (`tlatoani` — Spanish `es-MX` / `es-ES`):**
   - **Personality:** Calm, wise, warm, quietly mischievous engineer-philosopher.
   - **Acoustic Profile:** Mellow baritone-tenor (`pitch: 0.92`, `rate: 0.94`), warm low-mid resonance (`240 Hz` formant warmth), deliberate 120 ms micro-pause before insights, plus a subtle warm marimba/woodwind timbre cue when speaking. When blushing (`emotion: blushing`), pitch rises slightly (`+0.05`) with a gentle flutter.
2. **Covi (`covi` — English `en-US` / `en-GB`):**
   - **Personality:** Enthusiastic, curious, upbeat apprentice and supportive friend.
   - **Acoustic Profile:** Bright, clear voice (`pitch: 1.08`, `rate: 1.03`), lively inflection, accompanied by a soft plucked synth cue.
3. **Nūr (`nur` — Arabic `ar-AE` / `ar-001`):**
   - **Personality:** Poised, warm Emirati calligrapher; crystal-clear articulation of every *ḥarakah* (short vowel) for beginner comprehension.
   - **Acoustic Profile:** Graceful alto-soprano (`pitch: 1.04`, `rate: 0.88` for crystal-clear beginner phonetics), warm oud-inspired harmonic cue.
4. **Yāsmīn (`yasmin` — Arabic `ar-LB` / `ar-JO` / `ar-001`):**
   - **Personality:** Musical, expressive Levantine botanist.
   - **Acoustic Profile:** Melodic soprano (`pitch: 1.10`, `rate: 0.92`), bright qanun-inspired shimmer cue.
5. **Laylā (`layla` — Arabic `ar-EG` / `ar-001`):**
   - **Personality:** Witty, expressive Cairene filmmaker.
   - **Acoustic Profile:** Warm, rhythmic alto (`pitch: 1.00`, `rate: 0.95`), subtle ney-flute harmonic cue.
6. **mācron āi (`macron` — Non-Verbal Emoji Synth):**
   - **Personality:** Eager, literal, adorable toy-sized desktop robot.
   - **Acoustic Profile:** Never speaks words; emits procedural Web Audio / PCM harmonic arpeggios and FM bloops mapped to its active emoji bubble (`happy: [523, 659, 784] Hz`, `curious: [440, 587] Hz`, `blush: [587, 740, 880] Hz`, `rewind: [659, 523, 392] Hz`).

#### Scenario: Playing a comic dialogue line or tapping an Arabic word

- **WHEN** a character speaks in a panel or the learner taps an Arabic word/letter
- **THEN** the Voice Engine synthesizes the line using that character's canonical `voice-manifest.json` profile (combining Web Speech / neural TTS voice selection with procedural Web Audio harmonic voice signatures so audio works 100% reliably across all browsers even offline)

### Requirement: Regenerative Voice Pipeline (`scripts/voice-pipeline.sh`)

The repository SHALL include `scripts/voice-pipeline.sh` which reads `assets/voices/voice-manifest.json`, validates all character acoustic parameters and vocalized Arabic phoneme tables, computes a deterministic SHA-256 `voice_canon_hash`, and emits `lib/src/data/generated_voice_canon.dart` so code and voice specs stay monotonically converged.

#### Scenario: Updating Tlatoāni's voice style

- **WHEN** an author or agent refines Tlatoāni's pitch, cadence, or formant parameters in `assets/voices/voice-manifest.json` and runs `bash scripts/voice-pipeline.sh`
- **THEN** `lib/src/data/generated_voice_canon.dart` is regenerated with a new `voice_canon_hash` and the runtime voice engine immediately adopts the updated profile
