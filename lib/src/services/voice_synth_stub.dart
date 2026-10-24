// @trace spec:voice-canon
import '../data/generated_voice_canon.dart';

class PlatformVoiceSynthesizer {
  void speakText({
    required String text,
    required VoiceProfileCanon profile,
    required bool isBlushing,
  }) {
    // No-op in headless/non-web widget tests.
  }

  void playHarmonicCue({
    required VoiceProfileCanon profile,
    required bool isBlushing,
    required bool isRewind,
  }) {
    // No-op in headless/non-web widget tests.
  }

  void stop() {}
}
