// @trace spec:voice-canon
import '../data/generated_voice_canon.dart';
import '../models/comic_models.dart';
import 'voice_synth_stub.dart'
    if (dart.library.js_interop) 'voice_synth_web.dart';

class VoiceService {
  final PlatformVoiceSynthesizer _synth = PlatformVoiceSynthesizer();
  bool isMuted = false;
  bool autoPlayEnabled = true;

  CharacterVoiceProfile profileFor(CharacterId character) {
    return kCharacterVoiceCanon[character.name] ??
        kCharacterVoiceCanon['tlatoani']!;
  }

  void speakPanel(ComicPanelData panel) {
    if (isMuted) return;
    final profile = profileFor(panel.speaker);
    final isBlushing = panel.speakerEmotion == EmotionState.blushing ||
        (panel.speaker == CharacterId.tlatoani &&
            panel.tlatoaniEmotion == EmotionState.blushing);
    _synth.speakPanelAsset(
      panelId: panel.id,
      fallbackText: panel.spokenAudioText,
      profile: profile,
      isBlushing: isBlushing,
    );
  }

  void speakArabicWord(
    String vocalizedArabic, {
    CharacterId heroine = CharacterId.nur,
  }) {
    if (isMuted) return;
    final trimmed = vocalizedArabic.trim();
    final profile = profileFor(heroine);
    final assetPath = kArabicWordAudioAssets[trimmed];
    _synth.speakWordAsset(
      assetPath: assetPath,
      text: trimmed,
      profile: profile,
    );
  }

  void playCharacterAudition(CharacterId character) {
    if (isMuted) return;
    final profile = profileFor(character);
    if (character == CharacterId.macron) {
      playMacronEmojiBloop();
      return;
    }
    const samplePanelByChar = <CharacterId, String>{
      CharacterId.tlatoani: 'ch1_p1',
      CharacterId.covi: 'ch1_p2',
      CharacterId.nur: 'ch1_p3',
      CharacterId.yasmin: 'ch5_p1',
      CharacterId.layla: 'ch9_p1',
    };
    final panelId = samplePanelByChar[character] ?? 'ch1_p1';
    _synth.speakPanelAsset(
      panelId: panelId,
      fallbackText: profile.displayName,
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
