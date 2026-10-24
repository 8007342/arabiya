#!/usr/bin/env bash
# @trace spec:voice-canon
# Deterministic voice pipeline: validates assets/voices/voice-manifest.json
# and emits lib/src/data/generated_voice_canon.dart with a SHA-256 content seal.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."

mkdir -p lib/src/data

node <<'NODE'
const fs = require('node:fs');
const crypto = require('node:crypto');

const manifestPath = 'assets/voices/voice-manifest.json';
const raw = fs.readFileSync(manifestPath, 'utf8');
const manifest = JSON.parse(raw);

const requiredCharacters = ['tlatoani', 'covi', 'nur', 'yasmin', 'layla', 'macron'];
for (const id of requiredCharacters) {
  const c = manifest.characters?.[id];
  if (!c) {
    console.error(`ERROR: missing required character '${id}' in ${manifestPath}`);
    process.exit(1);
  }
  if (typeof c.pitch !== 'number' || typeof c.rate !== 'number' || typeof c.baseFreqHz !== 'number') {
    console.error(`ERROR: invalid acoustic parameters for '${id}'`);
    process.exit(1);
  }
}

const hash = crypto.createHash('sha256').update(raw).digest('hex').slice(0, 16);

const entries = Object.entries(manifest.characters).map(([key, c]) => {
  const fallbacks = (c.fallbackLocales || []).map(l => `'${l}'`).join(', ');
  const cadence = (c.harmonicCadenceHz || []).map(n => `${n}.0`).join(', ');
  const desc = String(c.canonDescription || '').replace(/'/g, "\\'");
  const dName = String(c.displayName || key).replace(/'/g, "\\'");
  return `  '${key}': VoiceProfileCanon(
    id: '${c.id}',
    displayName: '${dName}',
    primaryLocale: '${c.primaryLocale}',
    fallbackLocales: [${fallbacks}],
    pitch: ${c.pitch},
    rate: ${c.rate},
    blushPitchDelta: ${c.blushPitchDelta},
    baseFreqHz: ${c.baseFreqHz},
    timbreWave: '${c.timbreWave}',
    harmonicCadenceHz: [${cadence}],
    pauseBeforeInsightMs: ${c.pauseBeforeInsightMs},
    canonDescription: '${desc}',
  ),`;
}).join('\n');

const dartOut = `// GENERATED FILE — DO NOT EDIT BY HAND.
// Regenerate via: bash scripts/voice-pipeline.sh
// Source: assets/voices/voice-manifest.json
// @trace spec:voice-canon

class VoiceProfileCanon {
  final String id;
  final String displayName;
  final String primaryLocale;
  final List<String> fallbackLocales;
  final double pitch;
  final double rate;
  final double blushPitchDelta;
  final double baseFreqHz;
  final String timbreWave;
  final List<double> harmonicCadenceHz;
  final int pauseBeforeInsightMs;
  final String canonDescription;

  const VoiceProfileCanon({
    required this.id,
    required this.displayName,
    required this.primaryLocale,
    required this.fallbackLocales,
    required this.pitch,
    required this.rate,
    required this.blushPitchDelta,
    required this.baseFreqHz,
    required this.timbreWave,
    required this.harmonicCadenceHz,
    required this.pauseBeforeInsightMs,
    required this.canonDescription,
  });
}

const String kVoiceCanonHash = '${hash}';

const Map<String, VoiceProfileCanon> kCharacterVoiceCanon = {
${entries}
};
`;

fs.writeFileSync('lib/src/data/generated_voice_canon.dart', dartOut, 'utf8');
console.log(`ok:voice-pipeline:hash=${hash}`);
NODE
