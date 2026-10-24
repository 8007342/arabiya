#!/usr/bin/env bash
# @trace spec:voice-canon
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."

node <<'NODE'
const fs = require('node:fs');
const path = require('node:path');
const crypto = require('node:crypto');

const manifestPath = path.resolve('assets/voices/voice-manifest.json');
const raw = fs.readFileSync(manifestPath, 'utf8');
const manifest = JSON.parse(raw);

if (!manifest.characters || typeof manifest.characters !== 'object') {
  throw new Error('voice-manifest.json missing characters map');
}

const requiredIds = ['tlatoani', 'covi', 'nur', 'yasmin', 'layla', 'macron'];
for (const id of requiredIds) {
  if (!manifest.characters[id]) {
    throw new Error(`voice-manifest.json missing required character: ${id}`);
  }
}

// Parse panels from chapter files
const bookFiles = [
  'lib/src/data/chapters_book1_dubai.dart',
  'lib/src/data/chapters_book2_levant.dart',
  'lib/src/data/chapters_book3_cairo.dart',
];

function cleanForTts(text) {
  return text
    .replace(/['’‘ʻʿʾ]/g, '')
    .replace(/ā/g, 'a').replace(/Ā/g, 'A')
    .replace(/ī/g, 'i').replace(/Ī/g, 'I')
    .replace(/ū/g, 'u').replace(/Ū/g, 'U')
    .replace(/ḥ/g, 'j').replace(/Ḥ/g, 'J')
    .replace(/ṣ/g, 's').replace(/Ṣ/g, 'S')
    .replace(/ḍ/g, 'd').replace(/Ḍ/g, 'D')
    .replace(/ṭ/g, 't').replace(/Ṭ/g, 'T')
    .replace(/ẓ/g, 'z').replace(/ﻈ/g, 'Z')
    .replace(/ē/g, 'e').replace(/ō/g, 'o')
    .replace(/\s+/g, ' ')
    .trim();
}

const panels = [];
const arabicWords = new Map();

for (const file of bookFiles) {
  if (!fs.existsSync(file)) continue;
  const content = fs.readFileSync(file, 'utf8');
  const panelBlocks = content.split('ComicPanelData(').slice(1);
  for (const block of panelBlocks) {
    const idMatch = block.match(/id:\s*'([^']+)'/);
    const speakerMatch = block.match(/speaker:\s*CharacterId\.(\w+)/);
    const spokenMatch = block.match(/spokenAudioText:\s*\n?\s*'((?:\\'|[^'])*)'/);
    const dialogueMatch = block.match(/dialogueText:\s*\n?\s*'((?:\\'|[^'])*)'/);
    const localeMatch = block.match(/spokenLocale:\s*'([^']+)'/);
    const spotArMatch = block.match(/arabicSpotlight:\s*ArabicWordToken\([\s\S]*?arabic:\s*'([^']+)'/);
    if (idMatch && speakerMatch && spokenMatch && localeMatch) {
      const id = idMatch[1];
      const speaker = speakerMatch[1];
      const spokenAudioText = spokenMatch[1].replace(/\\'/g, "'");
      const dialogueText = dialogueMatch ? dialogueMatch[1].replace(/\\'/g, "'") : spokenAudioText;
      const locale = localeMatch[1];
      const spotlightArabic = spotArMatch ? spotArMatch[1] : null;
      panels.push({ id, speaker, spokenAudioText, dialogueText, locale, spotlightArabic });
      if (spotlightArabic) {
        const key = crypto.createHash('md5').update(spotlightArabic).digest('hex').slice(0, 12);
        arabicWords.set(key, spotlightArabic);
      }
    }
  }
  // Also extract all ArabicWordToken arabic fields in vocabularyUnlocked and MasteryOption arabic fields
  const wordMatches = content.matchAll(/arabic:\s*'([^']+)'/g);
  for (const m of wordMatches) {
    const ar = m[1].trim();
    if (ar) {
      const key = crypto.createHash('md5').update(ar).digest('hex').slice(0, 12);
      arabicWords.set(key, ar);
    }
  }
}

// Also extract all 28 letters from arabic_alphabet_catalog.dart
const catalogFile = 'lib/src/data/arabic_alphabet_catalog.dart';
if (fs.existsSync(catalogFile)) {
  const catContent = fs.readFileSync(catalogFile, 'utf8');
  for (const m of catContent.matchAll(/nameArabic:\s*'([^']+)'/g)) {
    const ar = m[1].trim();
    const key = crypto.createHash('md5').update(ar).digest('hex').slice(0, 12);
    arabicWords.set(key, ar);
  }
  for (const m of catContent.matchAll(/exampleArabic:\s*'([^']+)'/g)) {
    const ar = m[1].trim();
    const key = crypto.createHash('md5').update(ar).digest('hex').slice(0, 12);
    arabicWords.set(key, ar);
  }
  for (const m of catContent.matchAll(/arabic:\s*'([^']+)'/g)) {
    const ar = m[1].trim();
    const key = crypto.createHash('md5').update(ar).digest('hex').slice(0, 12);
    arabicWords.set(key, ar);
  }
}

async function fetchTtsMp3(tl, text) {
  const trimmed = text.slice(0, 195);
  const url = `https://translate.googleapis.com/translate_tts?ie=UTF-8&client=tw-ob&tl=${encodeURIComponent(tl)}&q=${encodeURIComponent(trimmed)}`;
  const res = await fetch(url);
  if (!res.ok) {
    throw new Error(`TTS HTTP ${res.status} for ${tl}: ${trimmed}`);
  }
  return Buffer.from(await res.arrayBuffer());
}

async function generateAudioAssets() {
  const panelsDir = path.resolve('assets/audio/panels');
  const wordsDir = path.resolve('assets/audio/words');
  fs.mkdirSync(panelsDir, { recursive: true });
  fs.mkdirSync(wordsDir, { recursive: true });

  // 1. Generate panel voice files
  let generatedPanels = 0;
  const panelQueue = [...panels];
  const workers = Array.from({ length: 6 }, async () => {
    while (panelQueue.length > 0) {
      const p = panelQueue.shift();
      const outPath = path.join(panelsDir, `${p.id}.mp3`);
      if (fs.existsSync(outPath) && fs.statSync(outPath).size > 1000) {
        generatedPanels++;
        continue;
      }
      try {
        const buffers = [];
        if (p.speaker === 'tlatoani') {
          const cleanEs = cleanForTts(p.spokenAudioText);
          buffers.push(await fetchTtsMp3('es-MX', cleanEs));
          if (p.spotlightArabic) {
            buffers.push(await fetchTtsMp3('ar', p.spotlightArabic));
          }
        } else if (p.speaker === 'covi') {
          const cleanEn = cleanForTts(p.spokenAudioText);
          buffers.push(await fetchTtsMp3('en-US', cleanEn));
          if (p.spotlightArabic) {
            buffers.push(await fetchTtsMp3('ar', p.spotlightArabic));
          }
        } else {
          // Heroine (Nūr, Yāsmīn, Laylā): speak Arabic line first!
          buffers.push(await fetchTtsMp3('ar', p.spokenAudioText));
          // Extract conversational Spanish quote if present after '—'
          const dashParts = p.dialogueText.split('—');
          if (dashParts.length > 1) {
            const conversational = cleanForTts(
              dashParts[1].replace(/["«»]/g, '').replace(/[\u0600-\u06FF]+/g, '').replace(/\(\s*\)/g, '')
            );
            if (conversational.length > 4) {
              buffers.push(await fetchTtsMp3('es-MX', conversational));
            }
          }
        }
        fs.writeFileSync(outPath, Buffer.concat(buffers));
        generatedPanels++;
      } catch (err) {
        console.warn(`warn:tts-panel:${p.id}:${err.message}`);
      }
    }
  });
  await Promise.all(workers);

  // 2. Generate Arabic word & letter audio files
  const wordEntries = [...arabicWords.entries()];
  let generatedWords = 0;
  const wordWorkers = Array.from({ length: 8 }, async () => {
    while (wordEntries.length > 0) {
      const [key, arText] = wordEntries.shift();
      const outPath = path.join(wordsDir, `${key}.mp3`);
      if (fs.existsSync(outPath) && fs.statSync(outPath).size > 500) {
        generatedWords++;
        continue;
      }
      try {
        const buf = await fetchTtsMp3('ar', arText);
        fs.writeFileSync(outPath, buf);
        generatedWords++;
      } catch (err) {
        console.warn(`warn:tts-word:${key}:${err.message}`);
      }
    }
  });
  await Promise.all(wordWorkers);
  console.log(`ok:voice-audio:panels=${generatedPanels},words=${generatedWords}`);
}

generateAudioAssets().then(() => {
  const hash = crypto.createHash('sha256').update(raw).digest('hex').slice(0, 16);
  const outDir = path.resolve('lib/src/data');
  fs.mkdirSync(outDir, { recursive: true });

  const wordMapEntries = [...arabicWords.entries()]
    .map(([k, v]) => `  ${JSON.stringify(v)}: 'assets/audio/words/${k}.mp3',`)
    .join('\n');

  const entries = Object.entries(manifest.characters).map(([id, c]) => {
    const fallbacks = JSON.stringify(c.fallbackLocales || []);
    const cadence = JSON.stringify(c.harmonicCadenceHz || [262, 330, 392]);
    return `  '${id}': CharacterVoiceProfile(
    id: '${c.id}',
    displayName: ${JSON.stringify(c.displayName)},
    primaryLocale: '${c.primaryLocale}',
    fallbackLocales: ${fallbacks},
    pitch: ${Number(c.pitch).toFixed(2)},
    rate: ${Number(c.rate).toFixed(2)},
    blushPitchDelta: ${Number(c.blushPitchDelta).toFixed(2)},
    baseFreqHz: ${Number(c.baseFreqHz).toFixed(2)},
    timbreWave: '${c.timbreWave}',
    harmonicCadenceHz: ${cadence},
    pauseBeforeInsightMs: ${Number(c.pauseBeforeInsightMs)},
    canonDescription: ${JSON.stringify(c.canonDescription)},
  ),`;
  }).join('\n');

  const dartSource = `// GENERATED CODE - DO NOT MODIFY BY HAND
// Source: assets/voices/voice-manifest.json
// Pipeline: scripts/voice-pipeline.sh
// Voice Canon Hash: ${hash}
// @trace spec:voice-canon

class CharacterVoiceProfile {
  final String id;
  final String displayName;
  final String primaryLocale;
  final List<String> fallbackLocales;
  final double pitch;
  final double rate;
  final double blushPitchDelta;
  final double baseFreqHz;
  final String timbreWave;
  final List<int> harmonicCadenceHz;
  final int pauseBeforeInsightMs;
  final String canonDescription;

  const CharacterVoiceProfile({
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

const String kVoiceCanonSealHash = '${hash}';

const Map<String, CharacterVoiceProfile> kCharacterVoiceCanon = {
${entries}
};

const Map<String, String> kArabicWordAudioAssets = {
${wordMapEntries}
};
`;

  fs.writeFileSync(path.join(outDir, 'generated_voice_canon.dart'), dartSource, 'utf8');
  console.log(`ok:voice-pipeline:hash=${hash}`);
});
NODE
