// @trace spec:arabiya, spec:character-canon, spec:curriculum-and-comics
import 'dart:ui';

enum CharacterId { tlatoani, covi, nur, yasmin, layla, macron }

enum EmotionState {
  calm,
  happy,
  curious,
  thinking,
  blushing,
  teasing,
  excited,
  rewinding,
}

enum SceneBackdropType {
  dxbAirport,
  dubaiCreekAbra,
  alFahidiCafe,
  calligraphyMuseum,
  jasmineBookshop,
  levantBusStreet,
  rooftopLounge,
  nileFelucca,
  cairoCinema,
  mediaTerrace,
}

class ArabicWordToken {
  final String arabic;
  final String unvocalized;
  final String transliteration;
  final String spanishMeaning;
  final String englishMeaning;
  final String spanishBridgeNote;
  final String? rootLetters;
  final Map<String, String> dialectVariants;

  const ArabicWordToken({
    required this.arabic,
    required this.unvocalized,
    required this.transliteration,
    required this.spanishMeaning,
    required this.englishMeaning,
    required this.spanishBridgeNote,
    this.rootLetters,
    this.dialectVariants = const {},
  });
}

class ArabicLetterLesson {
  final String letter;
  final String nameArabic;
  final String nameTranslit;
  final Map<String, String> forms;
  final bool isNonConnector;
  final String sunOrMoon; // 'sun' | 'moon' | 'vowel'
  final String spanishPhoneticTip;
  final String englishPhoneticTip;
  final String exampleArabic;
  final String exampleTranslit;
  final String exampleMeaningEsEn;
  final List<List<Offset>> strokeWaypoints;
  final List<Offset> dotOffsets;

  const ArabicLetterLesson({
    required this.letter,
    required this.nameArabic,
    required this.nameTranslit,
    required this.forms,
    required this.isNonConnector,
    required this.sunOrMoon,
    required this.spanishPhoneticTip,
    required this.englishPhoneticTip,
    required this.exampleArabic,
    required this.exampleTranslit,
    required this.exampleMeaningEsEn,
    required this.strokeWaypoints,
    this.dotOffsets = const [],
  });
}

class ComicPanelData {
  final String id;
  final SceneBackdropType backdrop;
  final CharacterId speaker;
  final List<CharacterId> presentCharacters;
  final EmotionState speakerEmotion;
  final EmotionState tlatoaniEmotion;
  final EmotionState coviEmotion;
  final EmotionState heroineEmotion;
  final String dialogueText;
  final String dialogueTranslation;
  final String spokenAudioText;
  final String spokenLocale;
  final ArabicWordToken? arabicSpotlight;
  final String
  macronEmojis; // Emojis ONLY, never text (@trace spec:character-canon)
  final String macronProp;
  final String? culturalNote;

  const ComicPanelData({
    required this.id,
    required this.backdrop,
    required this.speaker,
    required this.presentCharacters,
    this.speakerEmotion = EmotionState.calm,
    this.tlatoaniEmotion = EmotionState.calm,
    this.coviEmotion = EmotionState.calm,
    this.heroineEmotion = EmotionState.calm,
    required this.dialogueText,
    required this.dialogueTranslation,
    required this.spokenAudioText,
    required this.spokenLocale,
    this.arabicSpotlight,
    required this.macronEmojis,
    this.macronProp = 'compass',
    this.culturalNote,
  });
}

class MasteryOption {
  final String arabic;
  final String transliteration;
  final String meaningEs;
  final String meaningEn;
  final bool isCorrect;
  final String feedbackEs;
  final String feedbackEn;

  const MasteryOption({
    required this.arabic,
    required this.transliteration,
    required this.meaningEs,
    required this.meaningEn,
    required this.isCorrect,
    required this.feedbackEs,
    required this.feedbackEn,
  });
}

class MasteryChallengeData {
  final String promptEs;
  final String promptEn;
  final String scenarioContext;
  final ArabicLetterLesson traceLetter;
  final List<MasteryOption> options;
  final int rewindPanelsOnFail;

  const MasteryChallengeData({
    required this.promptEs,
    required this.promptEn,
    required this.scenarioContext,
    required this.traceLetter,
    required this.options,
    this.rewindPanelsOnFail = 2,
  });
}

class ComicChapterData {
  final String id;
  final int number;
  final int bookNumber;
  final String bookTitle;
  final String regionName;
  final String dialectBadge;
  final CharacterId heroine;
  final String titleEs;
  final String titleEn;
  final String titleArabic;
  final String subtitle;
  final List<ArabicLetterLesson> lettersUnlocked;
  final List<ArabicWordToken> vocabularyUnlocked;
  final List<ComicPanelData> panels;
  final MasteryChallengeData challenge;
  final int xpReward;
  final int affinityReward;

  const ComicChapterData({
    required this.id,
    required this.number,
    required this.bookNumber,
    required this.bookTitle,
    required this.regionName,
    required this.dialectBadge,
    required this.heroine,
    required this.titleEs,
    required this.titleEn,
    required this.titleArabic,
    required this.subtitle,
    required this.lettersUnlocked,
    required this.vocabularyUnlocked,
    required this.panels,
    required this.challenge,
    this.xpReward = 150,
    this.affinityReward = 1,
  });
}

class PlayerProgressState {
  final String currentChapterId;
  final int currentPanelIndex;
  final int doorEpisodeBeat;
  final int highestChapterIndex;
  final int xp;
  final int streakDays;
  final List<String> completedChapters;
  final List<String> unlockedLetters;
  final List<String> masteredWords;
  final Map<String, int> affinities;
  final List<Map<String, dynamic>> writingEvidence;

  const PlayerProgressState({
    this.currentChapterId = 'ch1_dxb_touchdown',
    this.currentPanelIndex = 0,
    this.doorEpisodeBeat = 0,
    this.highestChapterIndex = 0,
    this.xp = 0,
    this.streakDays = 1,
    this.completedChapters = const [],
    this.unlockedLetters = const ['ا', 'ب', 'ت'],
    this.masteredWords = const [],
    this.affinities = const {'nur': 0, 'yasmin': 0, 'layla': 0},
    this.writingEvidence = const [],
  });

  PlayerProgressState copyWith({
    String? currentChapterId,
    int? currentPanelIndex,
    int? doorEpisodeBeat,
    int? highestChapterIndex,
    int? xp,
    int? streakDays,
    List<String>? completedChapters,
    List<String>? unlockedLetters,
    List<String>? masteredWords,
    Map<String, int>? affinities,
    List<Map<String, dynamic>>? writingEvidence,
  }) {
    return PlayerProgressState(
      currentChapterId: currentChapterId ?? this.currentChapterId,
      currentPanelIndex: currentPanelIndex ?? this.currentPanelIndex,
      doorEpisodeBeat: doorEpisodeBeat ?? this.doorEpisodeBeat,
      highestChapterIndex: highestChapterIndex ?? this.highestChapterIndex,
      xp: xp ?? this.xp,
      streakDays: streakDays ?? this.streakDays,
      completedChapters: completedChapters ?? this.completedChapters,
      unlockedLetters: unlockedLetters ?? this.unlockedLetters,
      masteredWords: masteredWords ?? this.masteredWords,
      affinities: affinities ?? this.affinities,
      writingEvidence: writingEvidence ?? this.writingEvidence,
    );
  }

  Map<String, dynamic> toJson() => {
    'currentChapterId': currentChapterId,
    'currentPanelIndex': currentPanelIndex,
    'doorEpisodeBeat': doorEpisodeBeat,
    'highestChapterIndex': highestChapterIndex,
    'xp': xp,
    'streakDays': streakDays,
    'completedChapters': completedChapters,
    'unlockedLetters': unlockedLetters,
    'masteredWords': masteredWords,
    'affinities': affinities,
    'writingEvidence': writingEvidence,
  };

  factory PlayerProgressState.fromJson(Map<String, dynamic> json) {
    final rawAff = (json['affinities'] as Map?) ?? const {};
    return PlayerProgressState(
      currentChapterId:
          (json['currentChapterId'] as String?) ?? 'ch1_dxb_touchdown',
      currentPanelIndex: (json['currentPanelIndex'] as num?)?.toInt() ?? 0,
      doorEpisodeBeat: ((json['doorEpisodeBeat'] as num?)?.toInt() ?? 0).clamp(
        0,
        7,
      ),
      highestChapterIndex: (json['highestChapterIndex'] as num?)?.toInt() ?? 0,
      xp: (json['xp'] as num?)?.toInt() ?? 0,
      streakDays: (json['streakDays'] as num?)?.toInt() ?? 1,
      completedChapters:
          (json['completedChapters'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      unlockedLetters:
          (json['unlockedLetters'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          const ['ا', 'ب', 'ت'],
      masteredWords:
          (json['masteredWords'] as List?)?.map((e) => e.toString()).toList() ??
          const [],
      writingEvidence:
          (json['writingEvidence'] as List?)
              ?.whereType<Map>()
              .where((event) => event['id'] is String)
              .take(96)
              .map((event) => Map<String, dynamic>.from(event))
              .toList() ??
          const [],
      affinities: {
        'nur': (rawAff['nur'] as num?)?.toInt() ?? 0,
        'yasmin': (rawAff['yasmin'] as num?)?.toInt() ?? 0,
        'layla': (rawAff['layla'] as num?)?.toInt() ?? 0,
      },
    );
  }
}
