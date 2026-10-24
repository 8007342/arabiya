# Bundled voices

English and Spanish speech is generated locally with [Kokoro-82M v1.0](https://huggingface.co/hexgrad/Kokoro-82M), an Apache-2.0 neural speech model, using [kokoro-onnx](https://github.com/thewh1teagle/kokoro-onnx). Tlatoāni uses `em_alex` (Spanish, speed 0.96); Covi uses `af_heart` (American English, speed 1.0). A specifically Mexican accent has **not** been verified for `em_alex`.

`audio-manifest.json` records the exact spoken text, provider, voice, model checksums, audio checksums, and content hashes. Arabic word assets retain the existing Arabic recordings. Arabic panel audio contains only the spoken Arabic line; Spanish translations are displayed visually. Regional Arabic accents have not been verified. The three previously truncated Arabic lines were repaired with the same Arabic provider, and the new short Arabic hint uses that provider too.

Normal builds run `bash scripts/voice-pipeline.sh` entirely offline. This verifies every recording against the current script and profile, then emits the Dart word map and cache revisions. A missing or stale recording fails the build. The runtime plays bundled MP3s at their natural speed. Auditions play the same speech files as the episode. Only mācron āi uses oscillator sound effects.

To author changed English/Spanish lines, install Python 3.12+, `kokoro-onnx==0.6.1`, and `soundfile==0.14.0` in a virtual environment. Download `kokoro-v1.0.onnx` and `voices-v1.0.bin` from the `downloadBase` in the audio manifest into a local directory. The generator checks both SHA-256 values before inference.

```sh
VOICE_PYTHON=/path/to/venv/bin/python \
KOKORO_MODEL_DIR=/path/to/models \
bash scripts/voice-pipeline.sh --generate
```

All text is synthesized; long lines are split by the neural runtime instead of truncated. Model files and Python dependencies are authoring tools and are not shipped to the browser. Arabic changes require an explicitly imported Arabic recording and matching manifest entry. There is no automatic fallback to a different provider during a build.

The offline word mapping remains keyed by the original vocalized Arabic spelling and its historical filename. Browser speech synthesis is used only for an Arabic word absent from that mapping; all shipped lesson words are verified bundled assets.
