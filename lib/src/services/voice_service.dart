// @trace spec:voice-canon
import '../data/generated_voice_canon.dart';
import '../models/comic_models.dart';
import 'voice_synth_stub.dart'
    if (dart.library.js_interop) 'voice_synth_web.dart';

class VoiceService {
  final PlatformVoiceSynthesizer _synth = PlatformVoiceSynthesizer();
  bool isMuted = false;

  VoiceProfileCanon profileFor(CharacterId character) {
    return kCharacterVoiceCanon[character.name] ??
        kCharacterVoiceCanon['tlatoani']!;
  }

  void speakPanel(ComicPanelData panel) {
    if (isMuted) return;
    final profile = profileFor(panel.speaker);
    final isBlushing = panel.speakerEmotion == EmotionState.blushing ||
        (panel.speaker == CharacterId.tlatoani &&
            panel.tlatoaniEmotion == EmotionState.blushing);
    _synth.speakText(
      text: panel.spokenAudioText,
      profile: profile,
      isBlushing: isBlushing,
    );
  }

  void speakArabicWord(
    String vocalizedArabic, {
    CharacterId heroine = CharacterId.nur,
  }) {
    if (isMuted) return;
    final profile = profileFor(heroine);
    _synth.speakText(
      text: vocalizedArabic,
      profile: profile,
      isBlushing: false,
    );
  }

  void playMacronEmojiBloop({bool isRewind = false}) {
    if (isMuted) return;
    final profile = profileFor(CharacterId.macron);
    _synth.playHarmonicCue(
      profile: profile,
      isBlushing: false,
      isRewind: isRewind,
    );
  }

  void stop() {
    _synth.stop();
  }
}
