// @trace spec:voice-canon
import 'dart:js_interop';
import 'package:web/web.dart' as web;
import '../data/generated_voice_canon.dart';

@JS(' eval')
external JSAny? _jsEval(JSString code);

class PlatformVoiceSynthesizer {
  void speakText({
    required String text,
    required VoiceProfileCanon profile,
    required bool isBlushing,
  }) {
    playHarmonicCue(
      profile: profile,
      isBlushing: isBlushing,
      isRewind: false,
    );
    if (profile.id == 'macron' || text.trim().isEmpty) {
      return;
    }
    try {
      final synth = web.window.speechSynthesis;
      synth.cancel();
      final utterance = web.SpeechSynthesisUtterance(text);
      utterance.lang = profile.primaryLocale;
      final pitch = (profile.pitch + (isBlushing ? profile.blushPitchDelta : 0.0))
          .clamp(0.5, 1.8);
      utterance.pitch = pitch;
      utterance.rate = profile.rate.clamp(0.6, 1.5);

      final voices = synth.getVoices().toDart;
      final candidates = <String>[
        profile.primaryLocale.toLowerCase(),
        ...profile.fallbackLocales.map((l) => l.toLowerCase()),
      ];
      for (final target in candidates) {
        final match = voices.where((v) {
          final vLang = v.lang.replaceAll('_', '-').toLowerCase();
          return vLang == target || vLang.startsWith('$target-');
        });
        if (match.isNotEmpty) {
          utterance.voice = match.first;
          utterance.lang = match.first.lang;
          break;
        }
      }
      synth.speak(utterance);
    } catch (_) {
      // Fallback gracefully if speechSynthesis is restricted by browser autoplay policy.
    }
  }

  void playHarmonicCue({
    required VoiceProfileCanon profile,
    required bool isBlushing,
    required bool isRewind,
  }) {
    try {
      final notes = isRewind
          ? const [659.25, 523.25, 392.0]
          : profile.harmonicCadenceHz;
      if (notes.isEmpty) return;
      final shift = isBlushing ? 1.06 : 1.0;
      final freqsJs = notes.map((f) => (f * shift).toStringAsFixed(1)).join(',');
      final wave = profile.timbreWave;
      final durationStep = profile.id == 'macron' ? 0.085 : 0.065;
      final gainPeak = profile.id == 'macron' ? 0.07 : 0.04;
      final script = '''
(function() {
  try {
    const Ctx = window.AudioContext || window.webkitAudioContext;
    if (!Ctx) return;
    if (!window.__arabiyaAudioCtx) {
      window.__arabiyaAudioCtx = new Ctx();
    }
    const ctx = window.__arabiyaAudioCtx;
    if (ctx.state === 'suspended') { ctx.resume(); }
    const freqs = [$freqsJs];
    const now = ctx.currentTime;
    freqs.forEach((f, idx) => {
      const osc = ctx.createOscillator();
      const gain = ctx.createGain();
      osc.type = '$wave';
      osc.frequency.setValueAtTime(f, now + idx * $durationStep);
      gain.gain.setValueAtTime(0.0001, now + idx * $durationStep);
      gain.gain.exponentialRampToValueAtTime($gainPeak, now + idx * $durationStep + 0.015);
      gain.gain.exponentialRampToValueAtTime(0.0001, now + (idx + 1) * $durationStep + 0.04);
      osc.connect(gain);
      gain.connect(ctx.destination);
      osc.start(now + idx * $durationStep);
      osc.stop(now + (idx + 1) * $durationStep + 0.05);
    });
  } catch (_) {}
})();
''';
      _jsEval(script.toJS);
    } catch (_) {}
  }

  void stop() {
    try {
      web.window.speechSynthesis.cancel();
    } catch (_) {}
  }
}
