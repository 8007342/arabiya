# A playable comic about learning to write Arabic

Research and proposed direction, 2026-10-24. This is a planning document, not a claim that the current app implements these features. Device, voice budget, and Arabic register remain open for discussion. The user explicitly authorizes extending, refining, and departing from the existing storyline, adding chapters and non-lesson scenes, and experimenting with abundant generated assets.

### Confirmed direction after discussion

- Browser-first: Chrome on Yoga 2-in-1 laptops with Lenovo stylus, on Fedora Silverblue and Windows; mobile touch on iPhone 17 Pro Max is also a primary validation target. Design for broader mobile reach, not just this high-end phone.
- Everyday handwriting is the base game. Calligraphy exercises are bonus mini-games unlocked through gameplay, with progressively combined forms and compositions.
- Separate everyday legibility from calligraphic precision. Calligraphy rubrics must be specific to an explicitly taught style and exemplar, with educator-reviewed proportions, rhythm, joins and stroke sequence. Do not penalize valid everyday variants using an artistic rubric.
- Optional nondominant-hand play is an experiment, not a prerequisite or a promised cognitive enhancement. Keep its performance history separate so it does not mislead difficulty adaptation.

### Browser engine feasibility follow-up

No custom neural training is necessary to begin guided formation/copying with template and geometry assessment. A fixed exercise already knows the requested target; it needs to detect malformed attempts and provide useful corrections, not decode arbitrary prose. This remains distinct from reliable open-ended recognition.

| Option | Useful role | Limitation |
| --- | --- | --- |
| Local JS/Dart geometry and reviewed exemplars | Offline shape, coverage, components, dots, joins, and explicitly taught sequence checks | We implement and validate the teaching rubric; it is not general Arabic transcription |
| [$P+ JavaScript gesture recognizer](https://depts.washington.edu/acelab/proj/dollar/pdollarplus.html) | BSD-licensed experimental shape-matching baseline | Generic gesture matching, not Arabic recognition or an adequate stroke-order grader |
| [ONNX Runtime Web](https://onnxruntime.ai/docs/get-started/with-javascript/web.html) | Run a suitable future model locally through WASM | Runtime supplies no Arabic model or grading knowledge; model licensing/accuracy/download size remain separate |
| [MyScript web services](https://developer-support.myscript.com/support/discussions/topics/16000033357) | Benchmark Arabic transcription via supported REST/offscreen modes | Cloud integration, service terms/costs and mode restrictions; not a local WASM engine or pedagogical grader |
| [ML Kit digital ink](https://developers.google.com/ml-kit/vision/digital-ink-recognition/) | Offline Arabic recognition if native iOS/Android builds become worthwhile | No browser SDK |

Use WASM CPU as the prospective inference baseline; ONNX's current compatibility table lists it for iOS browsers, while its WebGPU backend is not supported there. Benchmark actual Fedora Chrome and iPhone performance; desktop compatibility alone is insufficient. Run heavy processing outside the animation path.

Capture pen/finger input with timestamps and pen-up boundaries. Pressure/tilt are optional enhancements, never required for a phone player to succeed. Browser [Pointer Events](https://www.w3.org/TR/pointerevents/) expose device type and optional expressive input, but actual hardware/driver/browser capabilities need measurement. Test pen detection, palm touches, accidental scrolling, cancellation, coordinate scaling, zoom, and orientation changes. Coalesced events can improve fidelity where available; feature-detect them and retain a basic event fallback.

Next concrete technical experiment: a diagnostic ink playground with huge text, raw capture/replay, a small teacher-reviewed letter family, interpretable feedback, and an adversarial test set (tap, stationary samples, scribble, missing/wrong dots, extra ink, partial shape). Collect samples on both Yoga systems and the iPhone. Measure acceptance errors before choosing a recognizer or training a model. This experiment is proposed, not implemented.

## North star

Players learn to write increasingly useful Arabic independently, legibly, and comfortably. Writing makes things happen in an entertaining comic world. Reading, listening, and conversation support that goal. Chapter completion, tracing completion, recognition confidence, and XP are not evidence of fluent writing.

Track separate outcomes: formation, dot distinctions, contextual forms, joins/non-joins, word spacing, recall, spelling, meaningful composition, and eventually comfortable speed. Test transfer to unfamiliar words and a blank surface. Do not penalize slow reading or motor differences.

## What the draft actually provides

- Reusable Flutter/Flame shell, bundled character/background art and fonts, 12 authored chapters, audio assets, local progress and cloud sync.
- `ComicPanelData` in `lib/src/models/comic_models.dart` centers on dialogue records. It needs a richer scene model for authored action, shot changes, silent beats, reveals, and consequences.
- Current progression is panels, one tracing exercise, and a multiple-choice challenge. This is a useful prototype, not a complete writing curriculum.
- `lib/src/widgets/arabiya_app.dart` contains many 11–16 px labels and repeated fixed dialogue presentation. Typography must change with layout and content density.
- `scripts/voice-pipeline.sh` uses generic translation TTS, truncates strings to 195 characters, and caches by panel ID/file size. Character voice profiles do not determine those recordings. Script or voice changes can leave stale audio.
- `lib/src/widgets/arabic_glyph_tracer.dart` rewards pointer sample count and endpoint proximity rather than reliable letter formation. A short scribble can pass. Do not build the new assessment around its score.
- Existing tests cover content invariants and the current chapter flow, not handwriting validity or learning. Static analysis and the worker test pass at this audit.
- The chapter gate speaks the correct answer on entry, awards whole-chapter mastery from one choice, does not require the handwriting callback, and lacks a repeated-reward guard. Fix these before trusting progression metrics.
- The existing specs are aspirations and source material; inventory, validate, and amend them before treating features or linguistic claims as complete.

## Evidence and design implications

1. Neil Cohn separates visual narrative structure, layout, and attentional framing. Use establishment, initiating action, peak, and release; vary close-ups, insets, and silent reaction shots. Clear navigation still matters. This does not prove that comics alone improve language learning. [Primary paper](https://pmc.ncbi.nlm.nih.gov/articles/PMC4076615/).
2. GameFlow is Sweetser and Wyeth's framework: concentration, challenge, skills, control, clear goals, feedback, immersion, and social interaction. Its original evaluation is not an educational efficacy trial. Use it to critique experiences, alongside independent learning measures. [Original publication](https://doi.org/10.1145/1077246.1077253).
3. Valve's Left 4 Dead Director provides a complementary pressure/recovery model. Our design inference is discovery → supported attempt → independent attempt → comic relief, with difficulty changing from demonstrated skill rather than reading speed. [Valve presentation](https://cdn.fastly.steamstatic.com/apps/valve/2009/ai_systems_of_l4d_mike_booth.pdf).
4. Wiley and Rapp's adult Arabic-letter learning study found advantages for handwriting training and transfer beyond the trained task. It supports meaningful handwriting practice, not a claim that any tracing game produces fluency. [Primary paper](https://pmc.ncbi.nlm.nih.gov/articles/PMC8641140/).
5. W3C requires text enlargement without content/function loss and defines reflow and target-size criteria. Keep lettering as live accessible text. [WCAG 2.2](https://www.w3.org/TR/WCAG22/).
6. Google ML Kit supports offline Arabic digital ink on Android/iOS; it is not a drop-in web solution. Recognizing a word is not grading the quality of its handwriting. [Official documentation](https://developers.google.com/ml-kit/vision/digital-ink-recognition/).

The following proposals are hypotheses to prototype and test, not established research results.

## Readability is a release requirement

- Start with Latin dialogue at 32–40 Flutter logical px, Arabic learning words at 48–64, and letter demonstrations at 96–160. Essential control text starts at 24. Tune on the user's actual device; these are proposed design values, not WCAG minimum font sizes.
- Support system scaling and an obvious persistent text-size preference, including at least 200% enlargement without losing content or controls. Reflow, split a beat, or offer a readable dialogue view when necessary. Never reduce type to fit the art.
- One short utterance per beat; translation and transliteration available on demand. Do not force three parallel language paragraphs onto every frame.
- Keep important text at least 4.5:1 contrast, on stable opaque backgrounds. Leave generous vertical room for Arabic marks; avoid clipping and artificial Arabic letter spacing.
- Aim for 56 logical px touch targets, with keyboard/screen-reader alternatives. Preserve sensible semantic order, correct RTL shaping, replayable audio, pause, and reduced motion.
- Full-screen scenes must remain readable without audio, timed reactions, drag precision, or automatic advancement. Provide an accessible alternative to any motor task while distinguishing it from demonstrated handwriting mastery.
- Verify narrow phone, tablet, desktop, large system text, diacritics, and screen readers. Comfort feedback from the user is essential; nominal standards alone are insufficient.

## Comic direction

Every short episode needs a desire, obstacle, Arabic action, visible consequence, and payoff. Use scene-wide art, deliberate framing, page-turn reveals, cutaways, sound effects, and silent humor. Avoid introductory essays and a permanent dashboard framing every scene.

Extend the content model with a `SceneBeat`: dramatic role, shot/framing, actor poses, action, text/audio cues, interaction, outcomes, transition, and accessible description. Provide a linear readable sequence alongside interactive staging. Reuse Flutter for accessible overlays and Flame for scene action; keep the renderer separate from learning assessment.

Prototype: **The Door That Won't Cooperate**

1. Full-screen airport arrival: the robot wrestles with an enormous suitcase. No welcome essay.
2. Close-up of a large باب sign; hear it on tap. One brief character line.
3. A silent misunderstanding and reaction inset establish the joke.
4. Write ب on the robot's reusable luggage label with a demonstration and guide.
5. Copy it onto another label, then recall it with less help. Give one useful hint after an error.
6. Assemble/write باب with appropriate support; a doorway is revealed. The robot was pushing a sliding door.
7. Revisit the word in a different scene without the original visual cue.

Language and stroke demonstrations need Arabic educator review before authoring final art or audio. Humor should target character choices, not Arabic or cultural stereotypes. Existing plots and chapter count are flexible; preserve the cast where useful and develop richer arcs rather than treating the draft as a fixed script.

### Story scenes and layered replay

Not every scene needs an exercise or an explicit lesson. Include transitional dialogue, relationship scenes, silent travel montages, incidental exchanges, callbacks, background gags, and cutscenes that exist for dramatic pleasure. Distinguish a line's narrative purpose from any optional curriculum tags; a scene may have no assessed learning objective.

On a first viewing, expressions, staging, sound, and optional translation should communicate enough to enjoy the scene. On replay, increased Arabic understanding can reveal wordplay, a character's earlier misunderstanding, or a background conversation. This is a design hypothesis about replay value, not a promise that passive exposure guarantees acquisition. Never make an essential objective depend on understanding untaught incidental speech.

Support voluntary scene replay with immediate playback, language/support controls, and no forced quiz. Preserve original scenes so familiar material can become newly comprehensible. Optional alternate exchanges and branches can add variety, but avoid replacing every familiar line randomly or hiding useful practice behind rare chance events. Record exposure separately from demonstrated mastery.

Use inexpensive generated assets generously for expression sheets, camera variants, inserts, props, background characters, transition strips, visual punchlines, and optional side stories. Maintain character/setting references, asset provenance and review, predictable loading, and coherent visual continuity. Keep text live and editable; avoid embedded generated lettering. Author the intended cause-and-effect and joke timing even when assets are generated. Prototype authoring templates and then expand beyond twelve chapters as the story benefits.

## A shared writing system underneath many games

Capture strokes as coordinates, timestamps, pointer type, and optional pressure, retaining pen lifts and stroke order. Normalize position/scale carefully without erasing meaningful proportions or direction.

Separate three questions:

- What did the player intend to write? Recognition or a constrained target vocabulary can help.
- Is it legible and appropriately formed? Evaluate coverage, geometry, topology, dots, baseline, joins, spacing, and extra marks using educator-reviewed acceptable variants.
- Can the player retrieve and use it independently? Assess unprompted recall, spelling, later retention, and meaningful use separately.

Start with transparent geometric checks on a small reviewed set: adequate path coverage, limited deviation/extra ink, required components, and dot placement. Reject a start-point tap, repeated stationary samples, missing dots, wrong dots, partial paths, and unrelated scribbles. Allow legitimate variants and delayed dot placement. Do not impose one rigid stroke order as the sole definition of correctness.

Feedback should identify a concrete next action (for example, one missing dot below), express uncertainty when appropriate, and offer retry or demonstration. Never invent a precise quality score from weak evidence.

Progression: motor familiarization → guided formation → copying → recall → contextual joins → words from audio/meaning → short messages → unfamiliar meaningful composition. Return to earlier skills through spaced, varied encounters. Story access and writing mastery should be recorded separately; assistance is welcome and visible.

Mini-game families can share this system: repair signs; sort/write parcel labels; restore missing dots; connect/disconnect train-car letters; take a café order; write a postcard; annotate a map; caption a comic; exchange short notes. Add time pressure only as an optional later challenge. Introduce one family well before multiplying modes.

### Do we need local model training?

Not yet established. First build a benchmark of real finger/stylus samples, both acceptable variants and deliberate failure cases, labeled by educators. Split evaluation by writer, device, and session to avoid leakage. Measure false acceptance and false rejection, plus component-specific errors and latency.

Compare geometric checks, available recognizers, and then a small local model. Web deployment, model size, privacy, licenses, and native-platform differences matter. Use training only when measured errors justify it. Recognition can complement geometric feedback but cannot replace pedagogical assessment.

Atrapa's current main branch appears to contain a snake-game AI, not the referenced handwriting experiment. Confirm the intended repository, branch, or revision before estimating reuse. [Repository](https://github.com/8007342/atrapa).

Any sample collection should be opt-in, purpose-limited, and deletable; avoid collecting raw handwriting merely to unlock practice. Check dataset/model licenses before use.

## Voice direction

Use consistent, reviewed character performances across all three languages. Audition identical short emotional lines before choosing a provider. Prefer generating and bundling authored dialogue so playback need not incur a live generation request. Keep secrets server-side.

Store provider/model/voice/locale, direction, text, and output settings in the asset manifest; regenerate on a content hash, not a panel filename. Record pronunciation approvals and provide clear fallback behavior. Verify that the bundled Arabic matches the intended text, register, and regional pronunciation with a native reviewer. Natural sound alone does not establish correctness.

Choose online generation, offline packs, or a hybrid after learning the user's budget/offline needs. Do not promise equal browser-provided voice quality across devices.

## Next work, in order

1. **Agree on the target experience:** primary device, everyday handwriting versus calligraphy, script/register anchor, audio/offline constraints. Story expansion and experimentation are authorized. Define a small measurable first learning outcome.
2. **Readability prototype:** huge live text, spacious framing, scalable controls, a silent beat and a shot transition. Validate comfort before polishing art.
3. **Writing assessment spike:** one small reviewed letter family, real ink capture, explicit rejection cases, feedback, and guided-to-recall progression. Benchmark before considering training.
4. **One complete comic episode:** integrate the writing mechanic with actions and a payoff, plus a non-lesson transition/cutscene with layered replay value; audition Spanish/English/Arabic voice samples. Preserve existing saves through a versioned migration.
5. **Playtest separately for enjoyment and learning:** reading comfort, navigation, narrative comprehension, false acceptance/rejection, independent writing, delayed recall, and transfer. Set numerical acceptance thresholds after measuring a baseline.
6. **Scale only after the slice works:** an authoring schema, reusable mini-games, spaced practice, curriculum review, additional scenes and regions. Revise older specs to match validated behavior.

Do not prioritize another regional book, a huge mini-game catalog, or custom training ahead of this slice.
