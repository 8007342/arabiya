// @trace spec:arabiya, spec:character-canon, spec:curriculum-and-comics
import '../models/comic_models.dart';

/// Authored visual storytelling, separate from any claim of learning mastery.
enum ComicShot { arrival, sign, push, reaction, label, slide, payoff, cafe }

class SceneBeat {
  final String id;
  final String title;
  final ComicShot shot;
  final String description;
  final String? line;
  final String? translation;
  final CharacterId speaker;
  final String locale;
  final String nextLabel;

  const SceneBeat({
    required this.id,
    required this.title,
    required this.shot,
    required this.description,
    this.line,
    this.translation,
    this.speaker = CharacterId.macron,
    this.locale = 'en-US',
    this.nextLabel = 'Next',
  });

  ComicPanelData? get audioPanel => line == null
      ? null
      : ComicPanelData(
          id: id,
          backdrop: shot == ComicShot.cafe
              ? SceneBackdropType.alFahidiCafe
              : SceneBackdropType.dxbAirport,
          speaker: speaker,
          presentCharacters: [speaker],
          dialogueText: line!,
          dialogueTranslation: translation ?? '',
          spokenAudioText: line!,
          spokenLocale: locale,
          macronEmojis: '🤖',
        );
}

const kDoorEpisode = <SceneBeat>[
  SceneBeat(
    id: 'door_arrival_covi',
    title: 'ONE SMALL SUITCASE',
    shot: ComicShot.arrival,
    description: 'At Dubai airport, mācron āi wrestles with a suitcase almost twice its size. Covi watches. A glass door stands in their way.',
    line: 'One small suitcase. That was the plan.',
    translation: 'Una maleta pequeña. Ese era el plan.',
    speaker: CharacterId.covi,
    nextLabel: 'Follow the robot',
  ),
  SceneBeat(
    id: 'door_sign_nur',
    title: 'A WORD ON THE DOOR',
    shot: ComicShot.sign,
    description: 'Close-up: Nūr points to the word بَاب on a glass door. The robot studies it. Tap the sign to hear the word.',
    line: 'بَاب',
    translation: 'Door · puerta · bāb',
    speaker: CharacterId.nur,
    locale: 'ar-AE',
    nextLabel: 'Try the door',
  ),
  SceneBeat(
    id: 'door_push_tlatoani',
    title: 'A VERY SERIOUS ATTEMPT',
    shot: ComicShot.push,
    description: 'The robot leans hard against the door. The door does not move. Its suitcase tilts precariously behind it.',
    line: 'Creo que la puerta no habla robot.',
    translation: 'I think the door doesn’t speak robot.',
    speaker: CharacterId.tlatoani,
    locale: 'es-MX',
    nextLabel: 'And then…',
  ),
  SceneBeat(
    id: 'door_silent_reaction',
    title: '…',
    shot: ComicShot.reaction,
    description: 'A silent reaction shot. The robot stares at the door. Nūr looks at the sliding track. The robot looks back at Nūr. An arrow points sideways.',
    nextLabel: 'Give it a clue',
  ),
  SceneBeat(
    id: 'door_label',
    title: 'A LITTLE INK MIGHT HELP',
    shot: ComicShot.label,
    description: 'An empty luggage label swings into view. A large ب sits next to it: the first letter of باب. You can open the writing playground or continue the story with help.',
    nextLabel: 'Leave a clue',
  ),
  SceneBeat(
    id: 'door_hint_nur',
    title: 'OH.',
    shot: ComicShot.slide,
    description: 'Nūr points sideways. The robot slides the door along its track. Light spills through the open doorway.',
    line: 'جَرِّبْ مِنَ الْجَانِبِ.',
    translation: 'Try sideways. · Prueba hacia un lado.',
    speaker: CharacterId.nur,
    locale: 'ar-AE',
    nextLabel: 'At last!',
  ),
  SceneBeat(
    id: 'door_payoff_covi',
    title: 'ONE SMALL PROBLEM',
    shot: ComicShot.payoff,
    description: 'The door is open, but the enormous suitcase is wedged in the doorway. The robot poses triumphantly. Covi raises an eyebrow.',
    line: 'Excellent. Now the suitcase is the door.',
    translation: 'Excelente. Ahora la maleta es la puerta.',
    speaker: CharacterId.covi,
    nextLabel: 'Meanwhile, at the café',
  ),
  SceneBeat(
    id: 'door_cafe_tlatoani',
    title: 'SOME DOORS CAN WAIT',
    shot: ComicShot.cafe,
    description: 'Later, outside a café, Tlatoāni and Covi sit down. The robot arrives with a tiny cup balanced on its enormous suitcase. Another door bears the familiar word باب.',
    line: 'Esta vez, primero el café.',
    translation: 'This time, coffee first.',
    speaker: CharacterId.tlatoani,
    locale: 'es-MX',
    nextLabel: 'Replay episode',
  ),
];
