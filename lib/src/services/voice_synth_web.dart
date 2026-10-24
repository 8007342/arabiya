// @trace spec:voice-canon
import 'dart:js_interop';

import 'package:web/web.dart' as web;

import '../data/generated_voice_canon.dart';

class PlatformVoiceSynthesizer {
  web.HTMLAudioElement? _player;
  web.AudioContext? _audioCtx;
  String? _pendingAssetUrl;
  double _pendingRate = 1.0;
  bool _unlockListenerAttached = false;

  void _ensureUnlockListeners() {
    if (_unlockListenerAttached) return;
    _unlockListenerAttached = true;

    void onUserGesture(web.Event _) {
      try {
        if (_audioCtx != null && _audioCtx!.state == 'suspended') {
          _audioCtx!.resume();
        }
        if (_pendingAssetUrl != null) {
          final url = _pendingAssetUrl!;
          final rate = _pendingRate;
          _pendingAssetUrl = null;
          _playUrl(url, playbackRate: rate);
        }
      } catch (_) {}
    }

    web.window.addEventListener('pointerdown', onUserGesture.toJS);
    web.window.addEventListener('keydown', onUserGesture.toJS);
  }

  void _playUrl(String url, {double playbackRate = 1.0}) {
    _ensureUnlockListeners();
    _pendingAssetUrl = null;
    try {
      _player?.pause();
      final audio = web.HTMLAudioElement();
      audio.src = url;
      audio.volume = 1.0;
      audio.playbackRate = playbackRate.clamp(0.75, 1.35);
      _player = audio;
      audio.play().toDart.catchError((Object error) {
        // Only autoplay blocking is retried; missing audio must not loop on every tap.
        if (identical(_player, audio) &&
            error.toString().contains('NotAllowedError')) {
          _pendingAssetUrl = url;
          _pendingRate = playbackRate;
        }
        return null;
      });
    } catch (_) {}
  }

  void speakPanelAsset({
    required String panelId,
    required String fallbackText,
    required CharacterVoiceProfile profile,
    required bool isBlushing,
  }) {
    final revision = kPanelAudioAssetRevisions[panelId];
    if (revision == null) return;
    // Timing and expression are authored in the recording; play at its natural rate.
    _playUrl('assets/assets/audio/panels/$panelId.mp3?v=$revision');
  }

  void speakWordAsset({
    required String? assetPath,
    required String text,
    required CharacterVoiceProfile profile,
  }) {
    if (assetPath != null && assetPath.isNotEmpty) {
      _playUrl('assets/$assetPath?v=$kVoiceCanonSealHash');
      return;
    }
    // Fallback to browser SpeechSynthesis if word wasn't in pre-baked manifest
    try {
      final synth = web.window.speechSynthesis;
      synth.cancel();
      final utterance = web.SpeechSynthesisUtterance(text);
      utterance.lang = profile.primaryLocale;
      utterance.pitch = profile.pitch;
      utterance.rate = profile.rate;
      synth.speak(utterance);
    } catch (_) {}
  }

  void playHarmonicCue({
    required CharacterVoiceProfile profile,
    required bool isBlushing,
    required bool isRewind,
    bool subtle = false,
  }) {
    _ensureUnlockListeners();
    try {
      _audioCtx ??= web.AudioContext();
      final ctx = _audioCtx!;
      if (ctx.state == 'suspended') {
        ctx.resume();
      }
      final notes = isRewind
          ? const <num>[659.25, 523.25, 392.0]
          : profile.harmonicCadenceHz;
      if (notes.isEmpty) return;
      final shift = isBlushing ? 1.06 : 1.0;
      final stepSec = profile.id == 'macron' ? 0.09 : 0.07;
      final peakGain = subtle ? 0.045 : (profile.id == 'macron' ? 0.14 : 0.09);
      final now = ctx.currentTime;

      for (var i = 0; i < notes.length; i++) {
        final freq = notes[i].toDouble() * shift;
        final start = now + i * stepSec;
        final stop = start + stepSec + 0.05;

        final osc = ctx.createOscillator();
        final gain = ctx.createGain();
        osc.type = profile.timbreWave;
        osc.frequency.setValueAtTime(freq, start);

        gain.gain.setValueAtTime(0.0001, start);
        gain.gain.exponentialRampToValueAtTime(peakGain, start + 0.015);
        gain.gain.exponentialRampToValueAtTime(0.0001, stop);

        osc.connect(gain);
        gain.connect(ctx.destination);
        osc.start(start);
        osc.stop(stop + 0.01);
      }
    } catch (_) {}
  }

  void stop() {
    _pendingAssetUrl = null;
    try {
      _player?.pause();
      _player = null;
      web.window.speechSynthesis.cancel();
    } catch (_) {}
  }
}
