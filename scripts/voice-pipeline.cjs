const fs = require('node:fs');
const path = require('node:path');
const crypto = require('node:crypto');
const {spawnSync} = require('node:child_process');

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

// Short authored episode lines are the sole spoken text (translations stay visual).
const episodePath = 'lib/src/data/door_episode.dart';
if (fs.existsSync(episodePath)) {
  for (const block of fs.readFileSync(episodePath, 'utf8').split('SceneBeat(').slice(1)) {
    const field = name => block.match(new RegExp(name + ":\\s*'((?:\\\\'|[^'])*)'"))?.[1]?.replace(/\\'/g, "'");
    const id = field('id');
    const text = field('line');
    const speaker = block.match(/speaker:\s*CharacterId\.(\w+)/)?.[1];
    if (id && text && speaker) panels.push({id, speaker, spokenAudioText: text, locale: field('locale') || 'en-US'});
  }
}
const recordingsPath = 'assets/voices/audio-manifest.json';
const sha = value => crypto.createHash('sha256').update(value).digest('hex');
const plan = panels.map(p => {
  const synthesis = manifest.characters[p.speaker].synthesis;
  if (!synthesis) throw new Error(`Missing synthesis profile: ${p.speaker}`);
  return {...p, synthesis, contentHash: sha(JSON.stringify({text:p.spokenAudioText, locale:p.locale, speaker:p.speaker, synthesis}))};
});
if (process.argv.includes('--plan')) { console.log(JSON.stringify({panels:plan, words:[...arabicWords]})); process.exit(0); }
if (process.argv.includes('--generate')) {
  const run = spawnSync(process.env.VOICE_PYTHON || 'python3', ['scripts/generate-neural-voices.py'], {input: JSON.stringify(plan), encoding:'utf8', stdio:['pipe','inherit','inherit']});
  if (run.status !== 0) process.exit(run.status || 1);
}
const current = JSON.parse(fs.readFileSync(recordingsPath, 'utf8'));
for (const p of plan) {
  const record = current.panels[p.id];
  const file = `assets/audio/panels/${p.id}.mp3`;
  if (!record || record.contentHash !== p.contentHash || !fs.existsSync(file) || sha(fs.readFileSync(file)) !== record.audioSha256) {
    throw new Error(`Stale or missing recording: ${p.id}. Run voice-pipeline.sh --generate with the neural generator dependencies installed. Arabic changes require an explicitly imported Arabic recording.`);
  }
}
for (const [key, text] of arabicWords) {
  const file = `assets/audio/words/${key}.mp3`;
  const record = current.words[key];
  if (!record || record.text !== text || !fs.existsSync(file) || sha(fs.readFileSync(file)) !== record.audioSha256) throw new Error(`Missing or changed Arabic word recording: ${text}`);
}
console.log(`ok:voice-audio:panels=${plan.length},words=${arabicWords.size}; verified content and audio hashes`);
{
  const hash = sha(raw + JSON.stringify(current)).slice(0, 16);
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

const Map<String, String> kPanelAudioAssetRevisions = {
${plan.map(p => `  '${p.id}': '${current.panels[p.id].audioSha256.slice(0, 16)}',`).join('\n')}
};

const Map<String, String> kArabicWordAudioAssets = {
${wordMapEntries}
};
`;

  fs.writeFileSync(path.join(outDir, 'generated_voice_canon.dart'), dartSource, 'utf8');
  console.log(`ok:voice-pipeline:hash=${hash}`);
}
