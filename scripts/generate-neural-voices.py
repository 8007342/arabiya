#!/usr/bin/env python3
"""Author bundled speech; normal builds only verify the committed recordings.

Install kokoro-onnx==0.6.1 and soundfile==0.14.0. Set
KOKORO_MODEL_DIR to the directory containing the pinned model and voice files.
The model is never shipped to the browser, and no text is truncated.
"""
import hashlib
import json
import os
from pathlib import Path
import sys
import tempfile


def sha(data):
    return hashlib.sha256(data).hexdigest()


plan = json.load(sys.stdin)
manifest_path = Path('assets/voices/audio-manifest.json')
manifest = json.loads(manifest_path.read_text())
engine = None
for panel in plan:
    destination = Path(f"assets/audio/panels/{panel['id']}.mp3")
    previous = manifest['panels'].get(panel['id'], {})
    if (previous.get('contentHash') == panel['contentHash'] and destination.exists()
            and previous.get('audioSha256') == sha(destination.read_bytes())):
        continue
    profile = panel['synthesis']
    if profile['provider'] != 'kokoro-onnx':
        raise SystemExit(f"Import a reviewed Arabic recording for {panel['id']}; existing Arabic is preserved, never silently synthesized with a different voice.")
    if engine is None:
        import onnxruntime as ort
        from kokoro_onnx import Kokoro
        import soundfile as sf
        model_dir = Path(os.environ['KOKORO_MODEL_DIR'])
        for name, expected in manifest['neuralModel']['files'].items():
            if sha((model_dir / name).read_bytes()) != expected:
                raise SystemExit(f'Unexpected model checksum: {name}')
        options = ort.SessionOptions()
        options.intra_op_num_threads = 2
        options.inter_op_num_threads = 2
        session = ort.InferenceSession(str(model_dir / 'kokoro-v1.0.onnx'), sess_options=options)
        engine = Kokoro.from_session(session, str(model_dir / 'voices-v1.0.bin'))
    samples, sample_rate = engine.create(panel['spokenAudioText'], voice=profile['voice'], speed=profile['speed'], lang=profile['language'])
    if len(samples) < sample_rate // 4:
        raise SystemExit(f"Empty/short synthesis for {panel['id']}")
    with tempfile.TemporaryDirectory(prefix='arabiya-voice-') as temporary:
        mp3 = Path(temporary) / 'speech.mp3'
        sf.write(mp3, samples, sample_rate, format='MP3')
        destination.write_bytes(mp3.read_bytes())
    manifest['panels'][panel['id']] = {
        'text': panel['spokenAudioText'], 'locale': panel['locale'],
        'speaker': panel['speaker'], 'provider': profile['provider'],
        'model': profile['model'], 'voice': profile['voice'],
        'contentHash': panel['contentHash'], 'audioSha256': sha(destination.read_bytes()),
        'durationSeconds': round(len(samples) / sample_rate, 3),
        'sampleRateHz': sample_rate,
    }
    # Checkpoint only successful recordings; a partial run cannot pass validation.
    manifest_path.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    print(f"generated:{panel['id']}:{profile['voice']}:{len(samples) / sample_rate:.2f}s", flush=True)
