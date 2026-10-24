// @trace spec:voice-canon
import '../data/generated_voice_canon.dart';

class PlatformVoiceSynthesizer {
  void speakPanelAsset({
    required String panelId,
    required String fallbackText,
    required CharacterVoiceProfile profile,
    required bool isBlushing,
  }) {}

  void speakWordAsset({
    required String? assetPath,
    required String text,
    required CharacterVoiceProfile profile,
  }) {}

  void playHarmonicCue({
    required CharacterVoiceProfile profile,
    required bool isBlushing,
    required bool isRewind,
    bool subtle = false,
  }) {}

  void stop() {}
}
