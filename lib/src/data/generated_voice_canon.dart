// GENERATED FILE — DO NOT EDIT BY HAND.
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

const String kVoiceCanonHash = '780a34074bd901fb';

const Map<String, VoiceProfileCanon> kCharacterVoiceCanon = {
  'tlatoani': VoiceProfileCanon(
    id: 'tlatoani',
    displayName: 'Tlatoāni',
    primaryLocale: 'es-MX',
    fallbackLocales: ['es-ES', 'es-419', 'es'],
    pitch: 0.92,
    rate: 0.94,
    blushPitchDelta: 0.06,
    baseFreqHz: 220,
    timbreWave: 'triangle',
    harmonicCadenceHz: [220.0, 277.0, 330.0],
    pauseBeforeInsightMs: 120,
    canonDescription: 'Warm, unhurried Nahua-rooted Spanish sage voice; calm and observant, rising slightly with a gentle coral-gill flutter when blushing around Nūr, Yāsmīn, or Laylā.',
  ),
  'covi': VoiceProfileCanon(
    id: 'covi',
    displayName: 'Covi',
    primaryLocale: 'en-US',
    fallbackLocales: ['en-GB', 'en'],
    pitch: 1.08,
    rate: 1.03,
    blushPitchDelta: 0.04,
    baseFreqHz: 330,
    timbreWave: 'sine',
    harmonicCadenceHz: [330.0, 415.0, 494.0],
    pauseBeforeInsightMs: 60,
    canonDescription: 'Bright, curious, enthusiastic English apprentice voice with playful teasing inflection.',
  ),
  'nur': VoiceProfileCanon(
    id: 'nur',
    displayName: 'Nūr (نُور)',
    primaryLocale: 'ar-AE',
    fallbackLocales: ['ar-SA', 'ar-001', 'ar'],
    pitch: 1.04,
    rate: 0.88,
    blushPitchDelta: 0.03,
    baseFreqHz: 294,
    timbreWave: 'sine',
    harmonicCadenceHz: [294.0, 370.0, 440.0],
    pauseBeforeInsightMs: 90,
    canonDescription: 'Poised, crystal-clear vocalized Arabic voice from Dubai with warm Gulf hospitality and oud-inspired resonance.',
  ),
  'yasmin': VoiceProfileCanon(
    id: 'yasmin',
    displayName: 'Yāsmīn (يَاسْمِين)',
    primaryLocale: 'ar-LB',
    fallbackLocales: ['ar-JO', 'ar-SY', 'ar-001', 'ar'],
    pitch: 1.1,
    rate: 0.92,
    blushPitchDelta: 0.04,
    baseFreqHz: 349,
    timbreWave: 'sine',
    harmonicCadenceHz: [349.0, 440.0, 523.0],
    pauseBeforeInsightMs: 75,
    canonDescription: 'Musical, welcoming Levantine Arabic voice with melodic cadence and jasmine garden warmth.',
  ),
  'layla': VoiceProfileCanon(
    id: 'layla',
    displayName: 'Laylā (لَيْلَى)',
    primaryLocale: 'ar-EG',
    fallbackLocales: ['ar-001', 'ar'],
    pitch: 1,
    rate: 0.95,
    blushPitchDelta: 0.04,
    baseFreqHz: 262,
    timbreWave: 'triangle',
    harmonicCadenceHz: [262.0, 330.0, 392.0],
    pauseBeforeInsightMs: 80,
    canonDescription: 'Witty, expressive Cairene Arabic voice with cinematic timing and Nile sunset warmth.',
  ),
  'macron': VoiceProfileCanon(
    id: 'macron',
    displayName: 'mācron āi',
    primaryLocale: 'zxx',
    fallbackLocales: [],
    pitch: 1.35,
    rate: 1.2,
    blushPitchDelta: 0.1,
    baseFreqHz: 523.25,
    timbreWave: 'square',
    harmonicCadenceHz: [523.0, 659.0, 784.0, 1046.0],
    pauseBeforeInsightMs: 0,
    canonDescription: 'Silent in spoken words; communicates exclusively via emoji speech bubbles paired with procedural harmonic synth bloops.',
  ),
};
