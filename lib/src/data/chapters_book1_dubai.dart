// @trace spec:character-canon, spec:curriculum-and-comics
import 'dart:ui';
import '../models/comic_models.dart';

const ArabicLetterLesson _letterAlif = ArabicLetterLesson(
  letter: 'ا',
  nameArabic: 'أَلِف',
  nameTranslit: '’Alif',
  forms: {'isolated': 'ا', 'initial': 'ا', 'medial': 'ـا', 'final': 'ـا'},
  isNonConnector: true,
  sunOrMoon: 'moon',
  spanishPhoneticTip:
      'Vocal larga "ā" clara como en "mamá" y conector de una sola vía (no se une a la izquierda).',
  englishPhoneticTip:
      'Long vowel "ā" as in "father"; a one-way non-connector that creates a clean break on its left.',
  exampleArabic: 'بَاب',
  exampleTranslit: 'bāb',
  exampleMeaningEsEn: 'puerta / door',
  strokeWaypoints: [
    [Offset(0.50, 0.18), Offset(0.50, 0.50), Offset(0.50, 0.80)],
  ],
);

const ArabicLetterLesson _letterBa = ArabicLetterLesson(
  letter: 'ب',
  nameArabic: 'بَاء',
  nameTranslit: 'Bā’',
  forms: {'isolated': 'ب', 'initial': 'بـ', 'medial': 'ـبـ', 'final': 'ـب'},
  isNonConnector: false,
  sunOrMoon: 'moon',
  spanishPhoneticTip:
      'Sonido "b" suave como en "barco". Forma de barquito con UN punto debajo.',
  englishPhoneticTip:
      'Sound "b" as in "boat". A boat-shaped curve with ONE dot underneath.',
  exampleArabic: 'بَاب',
  exampleTranslit: 'bāb',
  exampleMeaningEsEn: 'puerta / door',
  strokeWaypoints: [
    [
      Offset(0.78, 0.42),
      Offset(0.72, 0.62),
      Offset(0.50, 0.66),
      Offset(0.28, 0.62),
      Offset(0.22, 0.42),
    ],
  ],
  dotOffsets: [Offset(0.50, 0.80)],
);

const ArabicLetterLesson _letterDal = ArabicLetterLesson(
  letter: 'د',
  nameArabic: 'دَال',
  nameTranslit: 'Dāl',
  forms: {'isolated': 'د', 'initial': 'د', 'medial': 'ـد', 'final': 'ـد'},
  isNonConnector: true,
  sunOrMoon: 'sun',
  spanishPhoneticTip:
      'Sonido "d" dental como al inicio de "dar". Es no-conectora hacia la izquierda.',
  englishPhoneticTip:
      'Crisp "d" as in "door". One of the 6 non-connectors that never joins to the left.',
  exampleArabic: 'دَار',
  exampleTranslit: 'dār',
  exampleMeaningEsEn: 'casa, hogar / home',
  strokeWaypoints: [
    [Offset(0.66, 0.30), Offset(0.72, 0.58), Offset(0.32, 0.64)],
  ],
);

const ArabicLetterLesson _letterZay = ArabicLetterLesson(
  letter: 'ز',
  nameArabic: 'زَاي',
  nameTranslit: 'Zāy',
  forms: {'isolated': 'ز', 'initial': 'ز', 'medial': 'ـز', 'final': 'ـز'},
  isNonConnector: true,
  sunOrMoon: 'sun',
  spanishPhoneticTip:
      'Zumbido suave /z/; letra solar que en español fusionó "az-zayt" en "¡aceite!".',
  englishPhoneticTip:
      'Voiced "z" as in "zoo"; a Sun letter that assimilates the "l" of "al-".',
  exampleArabic: 'زَيْت',
  exampleTranslit: 'zayt',
  exampleMeaningEsEn: 'aceite / olive oil',
  strokeWaypoints: [
    [Offset(0.64, 0.34), Offset(0.58, 0.58), Offset(0.30, 0.78)],
  ],
  dotOffsets: [Offset(0.62, 0.20)],
);

const ArabicLetterLesson _letterNun = ArabicLetterLesson(
  letter: 'ن',
  nameArabic: 'نُون',
  nameTranslit: 'Nūn',
  forms: {'isolated': 'ن', 'initial': 'نـ', 'medial': 'ـنـ', 'final': 'ـن'},
  isNonConnector: false,
  sunOrMoon: 'sun',
  spanishPhoneticTip:
      'Sonido "n" como en "noche" y primera letra de Nūr (نُور = luz). Pierde su cola al inicio: نـ.',
  englishPhoneticTip:
      'Sound "n" as in "noon" and the first letter of Nūr (نُور = light). Drops its bowl in initial form: نـ.',
  exampleArabic: 'نُور',
  exampleTranslit: 'nūr',
  exampleMeaningEsEn: 'luz / light (Nūr)',
  strokeWaypoints: [
    [
      Offset(0.74, 0.40),
      Offset(0.68, 0.70),
      Offset(0.50, 0.74),
      Offset(0.32, 0.70),
      Offset(0.26, 0.42),
    ],
  ],
  dotOffsets: [Offset(0.50, 0.28)],
);

const ArabicLetterLesson _letterKha = ArabicLetterLesson(
  letter: 'خ',
  nameArabic: 'خَاء',
  nameTranslit: 'Khā’',
  forms: {'isolated': 'خ', 'initial': 'خـ', 'medial': 'ـخـ', 'final': 'ـخ'},
  isNonConnector: false,
  sunOrMoon: 'moon',
  spanishPhoneticTip:
      '¡Tu superpoder hispano! Suena idéntica a la "j" española en "jamón" o "Jorge" (/x/).',
  englishPhoneticTip:
      'Voiceless uvular fricative like Scottish "loch" or Spanish "j" in "jamón".',
  exampleArabic: 'خُبْز',
  exampleTranslit: 'khubz',
  exampleMeaningEsEn: 'pan / bread',
  strokeWaypoints: [
    [
      Offset(0.34, 0.34),
      Offset(0.68, 0.34),
      Offset(0.42, 0.56),
      Offset(0.62, 0.78),
    ],
  ],
  dotOffsets: [Offset(0.52, 0.20)],
);

const ArabicLetterLesson _letterQaf = ArabicLetterLesson(
  letter: 'ق',
  nameArabic: 'قَاف',
  nameTranslit: 'Qāf',
  forms: {'isolated': 'ق', 'initial': 'قـ', 'medial': 'ـقـ', 'final': 'ـق'},
  isNonConnector: false,
  sunOrMoon: 'moon',
  spanishPhoneticTip:
      'En árabe clásico es una "k" profunda en la úvula (/q/), y en Dubái suena como una "g" cálida en "gahwa" (café).',
  englishPhoneticTip:
      'Deep uvular "q" in MSA ("qahwa"), pronounced as a warm "g" ("gahwa") in Dubai Gulf Arabic.',
  exampleArabic: 'قَهْوَة',
  exampleTranslit: 'qahwa / gahwa',
  exampleMeaningEsEn: 'café / coffee',
  strokeWaypoints: [
    [
      Offset(0.72, 0.42),
      Offset(0.64, 0.32),
      Offset(0.68, 0.66),
      Offset(0.46, 0.74),
      Offset(0.28, 0.54),
    ],
  ],
  dotOffsets: [Offset(0.62, 0.20), Offset(0.70, 0.20)],
);

final List<ComicChapterData> kBook1DubaiChapters = [
  // =========================================================================
  // CHAPTER 1: Touchdown at DXB & First Sight of Nūr
  // =========================================================================
  ComicChapterData(
    id: 'ch1_dxb_touchdown',
    number: 1,
    bookNumber: 1,
    bookTitle: 'Libro I: Dubái y la Luz de Nūr',
    regionName: 'Dubai, UAE 🇦🇪',
    dialectBadge: 'Khalījī + Fuṣḥā',
    heroine: CharacterId.nur,
    titleEs: 'Aterrizaje en Dubái: El Barquito y la Puerta',
    titleEn: 'Touchdown in Dubai: The Boat & The Door',
    titleArabic: 'الوُصُول إِلَى دُبَيّ',
    subtitle: 'Vocales largas (ا و ي), familia del barquito (ب ت ث) y Harakāt',
    lettersUnlocked: const [_letterAlif, _letterBa],
    vocabularyUnlocked: const [
      ArabicWordToken(
        arabic: 'بَاب',
        unvocalized: 'باب',
        transliteration: 'bāb',
        spanishMeaning: 'puerta',
        englishMeaning: 'door / gate',
        spanishBridgeNote:
            'Se lee de derecha a izquierda: ب (b) + ا (ā larga) + ب (b) = بَاب (bāb). ¡Con dos letras ya lees tu primer letrero del aeropuerto!',
      ),
      ArabicWordToken(
        arabic: 'إِنْ شَاءَ اللّٰه',
        unvocalized: 'إن شاء الله',
        transliteration: '’in shā’a llāh',
        spanishMeaning: 'ojalá / si Dios quiere',
        englishMeaning: 'hopefully / God willing',
        spanishBridgeNote:
            '¡El "ojalá" del español viene directamente del árabe andalusí "law šá lláh" / "in shā’a llāh"!',
      ),
    ],
    panels: const [
      ComicPanelData(
        id: 'ch1_p1',
        backdrop: SceneBackdropType.dxbAirport,
        speaker: CharacterId.tlatoani,
        presentCharacters: [CharacterId.tlatoani, CharacterId.covi, CharacterId.macron],
        tlatoaniEmotion: EmotionState.happy,
        coviEmotion: EmotionState.excited,
        dialogueText:
            '¡Órale, Covi! Por fin aterrizamos en Dubái después del vuelo desde el sur de California. ¡Mira qué chido está ese letrero sobre la puerta: tiene dos barquitos con un punto abajo (ب) y una columna en medio (ا)!',
        dialogueTranslation:
            'Whoa, Covi! We finally landed in Dubai after our flight from Southern California. Look how cool that sign above the gate is: it has two little boats with one dot underneath (ب) and a pillar in the middle (ا)!',
        spokenAudioText:
            '¡Órale, Covi! Por fin aterrizamos en Dubái desde el sur de California. Mira qué chido está ese letrero sobre la puerta: dice bāb.',
        spokenLocale: 'es-MX',
        arabicSpotlight: ArabicWordToken(
          arabic: 'بَاب',
          unvocalized: 'باب',
          transliteration: 'bāb',
          spanishMeaning: 'puerta',
          englishMeaning: 'door / gate',
          spanishBridgeNote:
              'De derecha a izquierda: بـ (b inicial pierde la cola izquierda) + ـا (vocal larga ā) + ب (b final completa) = بَاب.',
        ),
        macronEmojis: '✈️🌴🚪',
        macronProp: 'compass',
      ),
      ComicPanelData(
        id: 'ch1_p2',
        backdrop: SceneBackdropType.dxbAirport,
        speaker: CharacterId.covi,
        presentCharacters: [CharacterId.tlatoani, CharacterId.covi, CharacterId.macron],
        tlatoaniEmotion: EmotionState.calm,
        coviEmotion: EmotionState.curious,
        dialogueText:
            'Wait a second—so if we read from right to left, a boat with one dot below is "B" (ب), and the tall line is a long "Ā" (ا)... does that spell "Bāb" (بَاب)?',
        dialogueTranslation:
            'Espera un segundo: si leemos de derecha a izquierda, un barquito con un punto abajo es "B" (ب) y la línea alta es "Ā" (ا)... ¿eso dice "Bāb" (بَاب)?',
        spokenAudioText:
            'Wait a second! A boat with one dot below is B, and the tall line is A. That spells Bāb!',
        spokenLocale: 'en-US',
        macronEmojis: '⛵1️⃣✨',
        macronProp: 'compass',
      ),
      ComicPanelData(
        id: 'ch1_p3',
        backdrop: SceneBackdropType.dxbAirport,
        speaker: CharacterId.nur,
        presentCharacters: [
          CharacterId.tlatoani,
          CharacterId.covi,
          CharacterId.nur,
          CharacterId.macron,
        ],
        tlatoaniEmotion: EmotionState.blushing,
        coviEmotion: EmotionState.happy,
        heroineEmotion: EmotionState.happy,
        dialogueText:
            'مَرْحَباً! أَهْلاً بِكُمْ فِي دُبَيّ! — "¡Marḥaban! ¡Bienvenidos a Dubái! Los escuché descifrar بَاب (bāb) a la primera. Soy Nūr (نُور), arquitecta y calígrafa."',
        dialogueTranslation:
            'Marḥaban! Welcome to Dubai! I overheard you decoding بَاب (bāb) on your first try. I am Nūr (نُور), an architect and calligrapher.',
        spokenAudioText: 'مَرْحَباً! أَهْلاً بِكُمْ فِي دُبَيّ!',
        spokenLocale: 'ar-AE',
        arabicSpotlight: ArabicWordToken(
          arabic: 'مَرْحَباً',
          unvocalized: 'مرحبا',
          transliteration: 'Marḥaban',
          spanishMeaning: '¡Hola! / ¡Bienvenidos!',
          englishMeaning: 'Hello! / Welcome!',
          spanishBridgeNote:
              'Viene de la raíz ر-ح-ب (amplitud, recibir con espacio abierto en el corazón). Funciona en todo el mundo árabe.',
        ),
        macronEmojis: '😍🌸✨',
        macronProp: 'paintbrush',
        culturalNote:
            'En la cultura del Golfo (Khalījī), dar la bienvenida al viajero con calidez ("Marḥaban" o "Ahlan") es un pilar del Karam (hospitalidad generosa).',
      ),
      ComicPanelData(
        id: 'ch1_p4',
        backdrop: SceneBackdropType.dxbAirport,
        speaker: CharacterId.tlatoani,
        presentCharacters: [
          CharacterId.tlatoani,
          CharacterId.covi,
          CharacterId.nur,
          CharacterId.macron,
        ],
        tlatoaniEmotion: EmotionState.blushing,
        coviEmotion: EmotionState.teasing,
        heroineEmotion: EmotionState.happy,
        dialogueText:
            '¡M-Marḥaban, Nūr! Qué padre conocerte... Yo nací en la Ciudad de México, crecí en Guadalajara y vivo en el sur de California, ¡y ojalá —digo, إِنْ شَاءَ اللّٰه (’in shā’a llāh)— podamos ver tu caligrafía ahorita!',
        dialogueTranslation:
            'M-Marḥaban, Nūr! So great to meet you... I was born in Mexico City, grew up in Guadalajara, and live in Southern California, and ojalá—I mean, إِنْ شَاءَ اللّٰه (’in shā’a llāh)—we can see your calligraphy right now!',
        spokenAudioText:
            '¡Marḥaban, Nūr! Qué padre conocerte. ¡Ojalá, in shā’a llāh, podamos ver tu caligrafía ahorita!',
        spokenLocale: 'es-MX',
        arabicSpotlight: ArabicWordToken(
          arabic: 'إِنْ شَاءَ اللّٰه',
          unvocalized: 'إن شاء الله',
          transliteration: '’in shā’a llāh',
          spanishMeaning: 'ojalá (si Dios quiere)',
          englishMeaning: 'hopefully / God willing',
          spanishBridgeNote:
              'Cuando dices "¡ojalá!" en español, ya estás hablando árabe andalusí.',
        ),
        macronEmojis: '😳💓🌺',
        macronProp: 'compass',
      ),
      ComicPanelData(
        id: 'ch1_p5',
        backdrop: SceneBackdropType.dxbAirport,
        speaker: CharacterId.covi,
        presentCharacters: [
          CharacterId.tlatoani,
          CharacterId.covi,
          CharacterId.nur,
          CharacterId.macron,
        ],
        tlatoaniEmotion: EmotionState.blushing,
        coviEmotion: EmotionState.teasing,
        heroineEmotion: EmotionState.happy,
        dialogueText:
            'Whoa, Tlatoāni, are your feathery gills turning bright coral because of the desert sun, or because Nūr just smiled at you? Quick, let\'s trace our first letter before you melt!',
        dialogueTranslation:
            '¡Vaya, Tlatoāni! ¿Tus branquias se pusieron color coral brillante por el sol del desierto o porque Nūr te acaba de sonreír? ¡Rápido, tracemos nuestra primera letra!',
        spokenAudioText:
            'Whoa Tlatoāni, are your gills turning bright coral because Nūr smiled at you?',
        spokenLocale: 'en-US',
        macronEmojis: '🤭🦎💘',
        macronProp: 'paintbrush',
      ),
    ],
    challenge: const MasteryChallengeData(
      promptEs:
          'Nūr nos señala la puerta de salida hacia el Creek de Dubái. ¿Cómo se escribe y lee "puerta" (con la letra ب Bā’ y la vocal larga ا ’Alif)?',
      promptEn:
          'Nūr points us toward the exit door to Dubai Creek. How do we read and say "door" using ب (Bā’) and ا (’Alif)?',
      scenarioContext:
          'Saliendo de la terminal DXB junto a Nūr mientras mācron āi señala el letrero.',
      traceLetter: _letterBa,
      options: [
        MasteryOption(
          arabic: 'بَاب',
          transliteration: 'bāb',
          meaningEs: 'puerta (ب + ا + ب)',
          meaningEn: 'door (b + ā + b)',
          isCorrect: true,
          feedbackEs:
              '¡Exacto! بَاب (bāb) combina dos barquitos ب (un punto abajo) con la vocal larga ا en medio.',
          feedbackEn:
              'Spot on! بَاب (bāb) joins two ب boat letters (one dot below) with the long vowel ا in the middle.',
        ),
        MasteryOption(
          arabic: 'تُوت',
          transliteration: 'tūt',
          meaningEs: 'moras / bayas (ت tiene 2 puntos arriba)',
          meaningEn: 'berries (ت has 2 dots above)',
          isCorrect: false,
          feedbackEs:
              '¡Casi! تُوت usa ت (dos puntos arriba = T). Para "puerta" buscamos un punto abajo (ب = B). ¡Rebobinemos dos viñetas!',
          feedbackEn:
              'Close! تُوت uses ت (two dots on top = T). For "door" we want one dot below (ب = B). Let\'s rewind 2 panels!',
        ),
        MasteryOption(
          arabic: 'ثَوْب',
          transliteration: 'thawb',
          meaningEs: 'túnica (ث tiene 3 puntos arriba)',
          meaningEn: 'robe (ث has 3 dots above)',
          isCorrect: false,
          feedbackEs:
              'Esa empieza con ث (tres puntos arriba, como la "z" española). ¡Volvamos 2 paneles para revisar el cartel con Nūr!',
          feedbackEn:
              'That starts with ث (three dots on top). Let\'s rewind 2 panels to check the sign with Nūr!',
        ),
      ],
    ),
  ),

  // =========================================================================
  // CHAPTER 2: Crossing Dubai Creek by Abra & The 6 Non-Connectors
  // =========================================================================
  ComicChapterData(
    id: 'ch2_creek_abra',
    number: 2,
    bookNumber: 1,
    bookTitle: 'Libro I: Dubái y la Luz de Nūr',
    regionName: 'Dubai, UAE 🇦🇪',
    dialectBadge: 'Khalījī + Fuṣḥā',
    heroine: CharacterId.nur,
    titleEs: 'En Abra por el Creek: Las 6 Rebeldes y el Aceite',
    titleEn: 'Abra Across the Creek: The 6 Non-Connectors & Olive Oil',
    titleArabic: 'عَبْرَة الخُور',
    subtitle: 'Las 6 letras de una vía (ا د ذ ر ز و) y los puentes fonéticos del español',
    lettersUnlocked: const [_letterDal, _letterZay],
    vocabularyUnlocked: const [
      ArabicWordToken(
        arabic: 'دَار',
        unvocalized: 'دار',
        transliteration: 'dār',
        spanishMeaning: 'casa / hogar',
        englishMeaning: 'house / home',
        spanishBridgeNote:
            'Tanto د (d), como ا (ā), como ر (r) son del grupo de las 6 no-conectoras: ¡por eso ninguna se une hacia la izquierda en دَار!',
      ),
      ArabicWordToken(
        arabic: 'زَيْت',
        unvocalized: 'زيت',
        transliteration: 'zayt',
        spanishMeaning: 'aceite',
        englishMeaning: 'oil (olive oil)',
        spanishBridgeNote:
            '¡"Zayt" con el artículo "al-" se pronuncia "az-zayt", que dio origen directo a la palabra española "aceite"!',
      ),
    ],
    panels: const [
      ComicPanelData(
        id: 'ch2_p1',
        backdrop: SceneBackdropType.dubaiCreekAbra,
        speaker: CharacterId.nur,
        presentCharacters: [
          CharacterId.tlatoani,
          CharacterId.covi,
          CharacterId.nur,
          CharacterId.macron,
        ],
        tlatoaniEmotion: EmotionState.calm,
        coviEmotion: EmotionState.happy,
        heroineEmotion: EmotionState.happy,
        dialogueText:
            'تَفَضَّلُوا فِي العَبْرَة! — "¡Tafaḍḍalū! Suban a la barca abra. Miren la casa antigua en la orilla: se escribe دَار (dār). ¿Notan que sus tres letras no se tocan?"',
        dialogueTranslation:
            'Tafaḍḍalū! Step aboard the abra water taxi. Look at the historic house on the bank: it is written دَار (dār). Notice how its three letters don\'t touch?',
        spokenAudioText: 'تَفَضَّلُوا! هٰذِهِ دَار جَمِيلَة.',
        spokenLocale: 'ar-AE',
        arabicSpotlight: ArabicWordToken(
          arabic: 'دَار',
          unvocalized: 'دار',
          transliteration: 'dār',
          spanishMeaning: 'casa / morada',
          englishMeaning: 'house / home',
          spanishBridgeNote:
              'Hay exactamente 6 letras que se conectan por la derecha pero NUNCA dan la mano a la izquierda: ا، د، ذ، ر، ز، و.',
        ),
        macronEmojis: '⛵🌊🏠',
        macronProp: 'compass',
      ),
      ComicPanelData(
        id: 'ch2_p2',
        backdrop: SceneBackdropType.dubaiCreekAbra,
        speaker: CharacterId.tlatoani,
        presentCharacters: [
          CharacterId.tlatoani,
          CharacterId.covi,
          CharacterId.nur,
          CharacterId.macron,
        ],
        tlatoaniEmotion: EmotionState.happy,
        coviEmotion: EmotionState.curious,
        dialogueText:
            '¡Qué elegancia de sistema! Esas 6 letras (ا د ذ ر ز و) son fronteras naturales: cortan las palabras largas en bloques fáciles de leer. ¡Y además en español ya tenemos sus sonidos!',
        dialogueTranslation:
            'What an elegant system! Those 6 letters (ا د ذ ر ز و) are natural boundaries: they break long words into easy-to-read chunks. And in Spanish we already have their sounds!',
        spokenAudioText:
            '¡Qué elegancia de sistema! Esas seis letras cortan las palabras largas en bloques fáciles de leer.',
        spokenLocale: 'es-MX',
        macronEmojis: '🧩✂️💡',
        macronProp: 'lantern',
      ),
      ComicPanelData(
        id: 'ch2_p3',
        backdrop: SceneBackdropType.dubaiCreekAbra,
        speaker: CharacterId.covi,
        presentCharacters: [
          CharacterId.tlatoani,
          CharacterId.covi,
          CharacterId.nur,
          CharacterId.macron,
        ],
        tlatoaniEmotion: EmotionState.calm,
        coviEmotion: EmotionState.curious,
        dialogueText:
            'Wait, look at the cargo jars on the dock: زَيْت (zayt). Because ز (zāy) is one of the 6 non-connectors, it leaves a tiny gap before يـت (yt)!',
        dialogueTranslation:
            'Espera, mira las tinajas del muelle: زَيْت (zayt). ¡Como la ز (zāy) es una de las 6 no-conectoras, deja un pequeño espacio antes de يـت (yt)!',
        spokenAudioText:
            'Look at the jars on the dock: zayt! Because zāy is a non-connector, it leaves a gap before yā and tā.',
        spokenLocale: 'en-US',
        arabicSpotlight: ArabicWordToken(
          arabic: 'زَيْت',
          unvocalized: 'زيت',
          transliteration: 'zayt',
          spanishMeaning: 'aceite',
          englishMeaning: 'oil / olive oil',
          spanishBridgeNote:
              'Del árabe الزَّيْت (az-zayt) nació directamente "aceite" en español.',
        ),
        macronEmojis: '🫒🏺✨',
        macronProp: 'lantern',
      ),
      ComicPanelData(
        id: 'ch2_p4',
        backdrop: SceneBackdropType.dubaiCreekAbra,
        speaker: CharacterId.tlatoani,
        presentCharacters: [
          CharacterId.tlatoani,
          CharacterId.covi,
          CharacterId.nur,
          CharacterId.macron,
        ],
        tlatoaniEmotion: EmotionState.blushing,
        coviEmotion: EmotionState.teasing,
        heroineEmotion: EmotionState.happy,
        dialogueText:
            '¡Claro! الزَّيْت (az-zayt) es literalmente nuestro "aceite". Y la ذ (dhāl) suena suavecita como la "d" de "almohada". Nūr, tu idioma se siente como reencontrar a un viejo amigo...',
        dialogueTranslation:
            'Of course! الزَّيْت (az-zayt) is literally our Spanish word "aceite". And ذ (dhāl) sounds soft like the "d" in "almohada". Nūr, your language feels like reuniting with an old friend...',
        spokenAudioText:
            'Claro, az-zayt es nuestro aceite. Nūr, tu idioma se siente como reencontrar a un viejo amigo.',
        spokenLocale: 'es-MX',
        macronEmojis: '😳🌅💞',
        macronProp: 'dallah',
      ),
      ComicPanelData(
        id: 'ch2_p5',
        backdrop: SceneBackdropType.dubaiCreekAbra,
        speaker: CharacterId.nur,
        presentCharacters: [
          CharacterId.tlatoani,
          CharacterId.covi,
          CharacterId.nur,
          CharacterId.macron,
        ],
        tlatoaniEmotion: EmotionState.blushing,
        coviEmotion: EmotionState.teasing,
        heroineEmotion: EmotionState.happy,
        dialogueText:
            'يَا سَلَام يَا تْلَاتُوَانِي! كَلَامُكَ جَمِيل. — "¡Yā salām, Tlatoāni! Tus palabras son hermosas. En Al-Fahidi te invitaré un café árabe para celebrar."',
        dialogueTranslation:
            'Yā salām, Tlatoāni! Your words are lovely. In Al-Fahidi I will treat you to Arabic coffee to celebrate.',
        spokenAudioText: 'يَا سَلَام! كَلَامُكَ جَمِيل جِدّاً.',
        spokenLocale: 'ar-AE',
        macronEmojis: '☕🌸🎉',
        macronProp: 'dallah',
        culturalNote:
            'Elogiar la belleza de la lengua y la historia compartida (como Al-Ándalus) es una forma sumamente apreciada y respetuosa de crear cercanía en el mundo árabe.',
      ),
    ],
    challenge: const MasteryChallengeData(
      promptEs:
          'Al bajar de la barca abra, Nūr nos señala una tinaja artesanal que inspiró la palabra española "aceite". ¿Cuál es la palabra árabe?',
      promptEn:
          'Stepping off the abra boat, Nūr points to a traditional jar labeled with the Arabic ancestor of the Spanish word "aceite". Which word is it?',
      scenarioContext: 'En el muelle histórico de Bur Dubai junto a Nūr.',
      traceLetter: _letterZay,
      options: [
        MasteryOption(
          arabic: 'زَيْت',
          transliteration: 'zayt',
          meaningEs: 'aceite (de az-zayt)',
          meaningEn: 'oil / olive oil (ancestor of Spanish "aceite")',
          isCorrect: true,
          feedbackEs:
              '¡Brillante! زَيْت (zayt) comienza con la no-conectora ز (zāy) y dio origen a "aceite".',
          feedbackEn:
              'Brilliant! زَيْت (zayt) starts with the non-connector ز (zāy) and gave Spanish the word "aceite".',
        ),
        MasteryOption(
          arabic: 'دَار',
          transliteration: 'dār',
          meaningEs: 'casa / hogar',
          meaningEn: 'house / home',
          isCorrect: false,
          feedbackEs:
              'دَار significa "casa". Busca la palabra que empieza con ز (con un punto arriba) y suena a "aceite". ¡Rebobinemos 2 paneles!',
          feedbackEn:
              'دَار means "house". Look for the word starting with ز (dot on top) that sounds like "aceite". Rewinding 2 panels!',
        ),
        MasteryOption(
          arabic: 'بَاب',
          transliteration: 'bāb',
          meaningEs: 'puerta',
          meaningEn: 'door',
          isCorrect: false,
          feedbackEs:
              'بَاب es "puerta" del Capítulo 1. ¡Volvamos dos viñetas para ver las tinajas del muelle con Covi!',
          feedbackEn:
              'بَاب is "door" from Chapter 1. Let\'s rewind two panels to check the dock jars with Covi!',
        ),
      ],
    ),
  ),

  // =========================================================================
  // CHAPTER 3: Qahwa & Calligraphy with Nūr in Al-Fahidi
  // =========================================================================
  ComicChapterData(
    id: 'ch3_alfahidi_cafe',
    number: 3,
    bookNumber: 1,
    bookTitle: 'Libro I: Dubái y la Luz de Nūr',
    regionName: 'Dubai, UAE 🇦🇪',
    dialectBadge: 'Khalījī + Fuṣḥā',
    heroine: CharacterId.nur,
    titleEs: 'Café, Azúcar y el Nombre de Nūr',
    titleEn: 'Coffee, Sugar & Writing Nūr’s Name',
    titleArabic: 'قَهْوَة وَخَطّ فِي الفَهِيدِي',
    subtitle: 'Letras conectoras (ن م ل ك ه ج ح خ س ش), Shadda (ّ) y Tanwīn (ـاً)',
    lettersUnlocked: const [_letterNun, _letterKha],
    vocabularyUnlocked: const [
      ArabicWordToken(
        arabic: 'نُور',
        unvocalized: 'نور',
        transliteration: 'Nūr',
        spanishMeaning: 'Luz (nombre de Nūr)',
        englishMeaning: 'Light (Nūr’s name)',
        spanishBridgeNote:
            'نـ (n inicial suelta su curva final para abrazar a la siguiente letra) + و (ū larga) + ر (r) = نُور.',
      ),
      ArabicWordToken(
        arabic: 'سُكَّر',
        unvocalized: 'سكر',
        transliteration: 'sukkar',
        spanishMeaning: 'azúcar',
        englishMeaning: 'sugar',
        spanishBridgeNote:
            'La shadda (ّ) sobre la ك duplica la consonante (suk-kar). Con el artículo "al-" se vuelve "as-sukkar" → ¡azúcar!',
      ),
      ArabicWordToken(
        arabic: 'شُكْراً',
        unvocalized: 'شكرا',
        transliteration: 'shukran',
        spanishMeaning: '¡gracias!',
        englishMeaning: 'thank you!',
        spanishBridgeNote:
            'Las dos rayitas finales (ـاً) se llaman Tanwīn y añaden el sonido "-an" al final: shuk-ran.',
      ),
    ],
    panels: const [
      ComicPanelData(
        id: 'ch3_p1',
        backdrop: SceneBackdropType.alFahidiCafe,
        speaker: CharacterId.nur,
        presentCharacters: [
          CharacterId.tlatoani,
          CharacterId.covi,
          CharacterId.nur,
          CharacterId.macron,
        ],
        tlatoaniEmotion: EmotionState.happy,
        coviEmotion: EmotionState.curious,
        heroineEmotion: EmotionState.happy,
        dialogueText:
            'أَهْلاً وَسَهْلاً! — "Bienvenidos a mi patio favorito en Al-Fahidi. Mira cómo escribo mi nombre, نُور (Nūr = Luz): la ن (nūn) deja caer su cola final (نـ) para darle la mano a la و."',
        dialogueTranslation:
            'Ahlan wa sahlan! Welcome to my favorite courtyard in Al-Fahidi. Watch how I write my name, نُور (Nūr = Light): the ن (nūn) drops its final tail (نـ) to hold hands with و.',
        spokenAudioText: 'أَهْلاً وَسَهْلاً! اِسْمِي نُور، وَمَعْنَاهُ النُّور.',
        spokenLocale: 'ar-AE',
        arabicSpotlight: ArabicWordToken(
          arabic: 'نُور',
          unvocalized: 'نور',
          transliteration: 'Nūr',
          spanishMeaning: 'Luz',
          englishMeaning: 'Light',
          spanishBridgeNote:
              'Regla de oro de las letras conectoras: al inicio o en medio de palabra, simplemente sueltan su cola final para estirarse hacia la izquierda.',
        ),
        macronEmojis: '🖌️✨💡',
        macronProp: 'paintbrush',
      ),
      ComicPanelData(
        id: 'ch3_p2',
        backdrop: SceneBackdropType.alFahidiCafe,
        speaker: CharacterId.tlatoani,
        presentCharacters: [
          CharacterId.tlatoani,
          CharacterId.covi,
          CharacterId.nur,
          CharacterId.macron,
        ],
        tlatoaniEmotion: EmotionState.blushing,
        coviEmotion: EmotionState.teasing,
        heroineEmotion: EmotionState.happy,
        dialogueText:
            'نُور... "Luz". Te queda perfecto el nombre, Nūr. ¡Y mira la carta del café: خُبْز (khubz = pan) lleva خ, que suena idéntica a nuestra "j" en español, y سُكَّر (sukkar) es nuestro "azúcar"!',
        dialogueTranslation:
            'نُور... "Light". The name suits you perfectly, Nūr. And look at the café menu: خُبْز (khubz = bread) has خ, which sounds identical to our Spanish "j", and سُكَّر (sukkar) is our "azúcar"!',
        spokenAudioText:
            'Nūr significa Luz, te queda perfecto. Y mira, sukkar es nuestro azúcar.',
        spokenLocale: 'es-MX',
        arabicSpotlight: ArabicWordToken(
          arabic: 'سُكَّر',
          unvocalized: 'سكر',
          transliteration: 'sukkar',
          spanishMeaning: 'azúcar',
          englishMeaning: 'sugar',
          spanishBridgeNote:
              'سـ (s inicial de 3 dientecitos) + ـكّـ (k medial doble con shadda ّ) + ـر (r final) = سُكَّر.',
        ),
        macronEmojis: '🍬☕😳',
        macronProp: 'dallah',
      ),
      ComicPanelData(
        id: 'ch3_p3',
        backdrop: SceneBackdropType.alFahidiCafe,
        speaker: CharacterId.covi,
        presentCharacters: [
          CharacterId.tlatoani,
          CharacterId.covi,
          CharacterId.nur,
          CharacterId.macron,
        ],
        tlatoaniEmotion: EmotionState.blushing,
        coviEmotion: EmotionState.teasing,
        heroineEmotion: EmotionState.happy,
        dialogueText:
            'Haha, Tlatoāni doesn\'t even need سُكَّر (sukkar) in his tea when he\'s talking that sweetly to Nūr! So how do we thank the waiter in Arabic?',
        dialogueTranslation:
            '¡Jaja, Tlatoāni ni siquiera necesita سُكَّر (sukkar) en su té cuando le habla tan dulce a Nūr! ¿Y cómo le damos las gracias al mesero en árabe?',
        spokenAudioText:
            'Haha, Tlatoāni does not even need sukkar in his tea when talking to Nūr! How do we say thank you?',
        spokenLocale: 'en-US',
        macronEmojis: '🍯🤭🫖',
        macronProp: 'teacup',
      ),
      ComicPanelData(
        id: 'ch3_p4',
        backdrop: SceneBackdropType.alFahidiCafe,
        speaker: CharacterId.nur,
        presentCharacters: [
          CharacterId.tlatoani,
          CharacterId.covi,
          CharacterId.nur,
          CharacterId.macron,
        ],
        tlatoaniEmotion: EmotionState.calm,
        coviEmotion: EmotionState.happy,
        heroineEmotion: EmotionState.happy,
        dialogueText:
            'نَقُولُ: شُكْراً! — "Decimos: ¡Shukran! (شُكْراً). Empieza con ش (shīn, como س pero con tres puntos arriba) y termina con Tanwīn (ـاً), que suena -an."',
        dialogueTranslation:
            'We say: Shukran! (شُكْراً). It starts with ش (shīn, like س but with three dots above) and ends with Tanwīn (ـاً), which sounds like "-an".',
        spokenAudioText: 'شُكْراً جَزِيلاً! تَفَضَّل القَهْوَة العَرَبِيَّة.',
        spokenLocale: 'ar-AE',
        arabicSpotlight: ArabicWordToken(
          arabic: 'شُكْراً',
          unvocalized: 'شكرا',
          transliteration: 'shukran',
          spanishMeaning: 'gracias',
          englishMeaning: 'thank you',
          spanishBridgeNote:
              'Raíz ش-ك-ر (agradecer). Las dos rayitas sobre la alif final (ـاً) siempre se leen "-an".',
        ),
        macronEmojis: '🙏✨☕',
        macronProp: 'dallah',
        culturalNote:
            'En los Emiratos, el café árabe (Gahwa) se sirve con cardamomo en una tacita sin asas (finjan) hasta la mitad, acompañado de dátiles dulces en lugar de azúcar.',
      ),
      ComicPanelData(
        id: 'ch3_p5',
        backdrop: SceneBackdropType.alFahidiCafe,
        speaker: CharacterId.tlatoani,
        presentCharacters: [
          CharacterId.tlatoani,
          CharacterId.covi,
          CharacterId.nur,
          CharacterId.macron,
        ],
        tlatoaniEmotion: EmotionState.blushing,
        coviEmotion: EmotionState.happy,
        heroineEmotion: EmotionState.happy,
        dialogueText:
            'شُكْراً يَا نُور! (¡Shukran yā Nūr!). Voy a anotar en mi cuaderno cómo se unen las letras conectoras antes de que Covi me siga haciendo burla.',
        dialogueTranslation:
            'Shukran yā Nūr! (Thank you, O Nūr!). I\'m going to write down in my notebook how connecting letters join before Covi teases me any further.',
        spokenAudioText: '¡Shukran yā Nūr! El café con cardamomo está delicioso.',
        spokenLocale: 'es-MX',
        macronEmojis: '📓✍️💖',
        macronProp: 'paintbrush',
      ),
    ],
    challenge: const MasteryChallengeData(
      promptEs:
          'Nūr nos acaba de servir café árabe con dátiles en el patio de Al-Fahidi. ¿Cómo le decimos "¡Muchas gracias, Nūr!" usando Tanwīn (ـاً) y su nombre (نُور)?',
      promptEn:
          'Nūr just poured us Arabic coffee with dates in the Al-Fahidi courtyard. How do we say "Thank you, Nūr!" using شُكْراً and نُور?',
      scenarioContext: 'Brindando con tacitas finjan de café en Al-Fahidi.',
      traceLetter: _letterNun,
      options: [
        MasteryOption(
          arabic: 'شُكْراً يَا نُور',
          transliteration: 'Shukran yā Nūr',
          meaningEs: '¡Gracias, Nūr! (Luz)',
          meaningEn: 'Thank you, Nūr! (Light)',
          isCorrect: true,
          feedbackEs:
              '¡Perfecto! شُكْراً يَا نُور usa el Tanwīn (-an) y une la نـ inicial con و y ر.',
          feedbackEn:
              'Perfect! شُكْراً يَا نُور uses Tanwīn (-an) and connects initial نـ to و and ر.',
        ),
        MasteryOption(
          arabic: 'سُكَّر وَزَيْت',
          transliteration: 'Sukkar wa zayt',
          meaningEs: 'Azúcar y aceite',
          meaningEn: 'Sugar and oil',
          isCorrect: false,
          feedbackEs:
              '¡Jaja! Le acabas de decir "azúcar y aceite" en vez de gracias. ¡Rebobinemos dos paneles para escuchar a Nūr!',
          feedbackEn:
              'Haha! You just said "sugar and oil" instead of thank you. Let\'s rewind 2 panels to hear Nūr again!',
        ),
        MasteryOption(
          arabic: 'بَاب الدَّار',
          transliteration: 'Bāb ad-dār',
          meaningEs: 'La puerta de la casa',
          meaningEn: 'The door of the house',
          isCorrect: false,
          feedbackEs:
              'Eso significa "la puerta de la casa". ¡Volvamos 2 paneles para repasar شُكْراً (shukran)!',
          feedbackEn:
              'That means "the door of the house". Let\'s rewind 2 panels to review شُكْراً (shukran)!',
        ),
      ],
    ),
  ),

  // =========================================================================
  // CHAPTER 4: Sun & Moon Letters at the Calligraphy Gallery + Emirati Charm
  // =========================================================================
  ComicChapterData(
    id: 'ch4_sun_moon_museum',
    number: 4,
    bookNumber: 1,
    bookTitle: 'Libro I: Dubái y la Luz de Nūr',
    regionName: 'Dubai, UAE 🇦🇪',
    dialectBadge: 'Khalījī + Fuṣḥā',
    heroine: CharacterId.nur,
    titleEs: 'El Secreto del Sol y la Luna: Almohada vs. Azúcar',
    titleEn: 'The Sun & Moon Secret: Almohada vs. Azúcar',
    titleArabic: 'الشَّمْس وَالقَمَر فِي المَتْحَف',
    subtitle: 'Letras الف ق ع غ, el artículo الـ (Solares vs. Lunares) y dialecto emiratí',
    lettersUnlocked: const [_letterQaf],
    vocabularyUnlocked: const [
      ArabicWordToken(
        arabic: 'المِخَدَّة',
        unvocalized: 'المخدة',
        transliteration: 'al-mikhadda',
        spanishMeaning: 'la almohada',
        englishMeaning: 'the pillow',
        spanishBridgeNote:
            '¡Letra Lunar (🌙)! La م (mīm) se pronuncia con los labios, lejos de la punta de la lengua, así que la "L" de "al-" se conserva intacta: al-mikhadda → ¡almohada!',
      ),
      ArabicWordToken(
        arabic: 'الشَّمْس',
        unvocalized: 'الشمس',
        transliteration: 'ash-shams',
        spanishMeaning: 'el sol',
        englishMeaning: 'the sun',
        spanishBridgeNote:
            '¡Letra Solar (☀️)! La ش se hace con la punta de la lengua igual que la ل, así que la ل se escribe pero se asimila: al-shams → ash-shams (igual que al-sukkar → as-sukkar → azúcar sin L).',
      ),
      ArabicWordToken(
        arabic: 'أَبْغِي قَهْوَة',
        unvocalized: 'أبغي قهوة',
        transliteration: 'Abghī gahwa',
        spanishMeaning: 'Quisiera un café (en árabe emiratí / Khalījī)',
        englishMeaning: 'I would like a coffee (in Emirati / Gulf Arabic)',
        spanishBridgeNote:
            'En el Golfo (Dubái), "quiero" se dice أَبْغِي (abghī) y la غ (ghayn) suena como la "g" suave española en "agua".',
        dialectVariants: {
          'msa': 'أُرِيدُ قَهْوَة (’urīdu qahwa)',
          'khaliji': 'أَبْغِي قَهْوَة (abghī gahwa)',
          'shami': 'بَدِّي قَهْوَة (baddī ’ahwe)',
          'masri': 'عَايِز قَهْوَة (‘āyiz ’ahwa)',
        },
      ),
    ],
    panels: const [
      ComicPanelData(
        id: 'ch4_p1',
        backdrop: SceneBackdropType.calligraphyMuseum,
        speaker: CharacterId.tlatoani,
        presentCharacters: [
          CharacterId.tlatoani,
          CharacterId.covi,
          CharacterId.nur,
          CharacterId.macron,
        ],
        tlatoaniEmotion: EmotionState.thinking,
        coviEmotion: EmotionState.curious,
        heroineEmotion: EmotionState.calm,
        dialogueText:
            '¡Nūr, acabo de resolver un misterio que me intrigaba desde niño! ¿Por qué en español decimos "AL-mohada" y "AL-calde" con L, pero "A-zúcar" y "A-ceite" sin L si todas vienen del artículo árabe الـ (al-)?',
        dialogueTranslation:
            'Nūr, I just solved a mystery that puzzled me since childhood! Why does Spanish say "AL-mohada" and "AL-calde" with an L, but "A-zúcar" and "A-ceite" without an L when they all come from the Arabic article الـ (al-)?',
        spokenAudioText:
            '¡Nūr, acabo de resolver por qué decimos almohada con L, pero azúcar y aceite sin L!',
        spokenLocale: 'es-MX',
        arabicSpotlight: ArabicWordToken(
          arabic: 'المِخَدَّة',
          unvocalized: 'المخدة',
          transliteration: 'al-mikhadda',
          spanishMeaning: 'la almohada',
          englishMeaning: 'the pillow',
          spanishBridgeNote:
              '🌙 Letras Lunares (como م en almohada o ق en alcalde / al-qāḍī) conservan el sonido "al-". ☀️ Letras Solares (como س en azúcar o ز en aceite) absorben la L.',
        ),
        macronEmojis: '🌞🌙🔑',
        macronProp: 'lantern',
      ),
      ComicPanelData(
        id: 'ch4_p2',
        backdrop: SceneBackdropType.calligraphyMuseum,
        speaker: CharacterId.nur,
        presentCharacters: [
          CharacterId.tlatoani,
          CharacterId.covi,
          CharacterId.nur,
          CharacterId.macron,
        ],
        tlatoaniEmotion: EmotionState.happy,
        coviEmotion: EmotionState.excited,
        heroineEmotion: EmotionState.happy,
        dialogueText:
            'مَا شَاءَ اللّٰه يَا تْلَاتُوَانِي! — "¡Mā shā’a llāh, qué observador! En árabe las llamamos Letras Lunares (القَمَر al-qamar) y Letras Solares (الشَّمْس ash-shams). ¡El español guardó esa regla fonética intacta durante ocho siglos!"',
        dialogueTranslation:
            'Mā shā’a llāh, how observant! In Arabic we call them Moon Letters (القَمَر al-qamar) and Sun Letters (الشَّمْس ash-shams). Spanish preserved that phonetic rule intact for eight centuries!',
        spokenAudioText: 'مَا شَاءَ اللّٰه! القَمَر وَالشَّمْس.',
        spokenLocale: 'ar-AE',
        arabicSpotlight: ArabicWordToken(
          arabic: 'الشَّمْس وَالقَمَر',
          unvocalized: 'الشمس والقمر',
          transliteration: 'ash-shams wa-l-qamar',
          spanishMeaning: 'el sol y la luna',
          englishMeaning: 'the sun and the moon',
          spanishBridgeNote:
              'Si la letra tras الـ usa la punta de la lengua (ت ث د ذ ر ز س ش ص ض ط ظ ل ن), es Solar ☀️ y duplica su sonido sin pronunciar la L.',
        ),
        macronEmojis: '☀️🌙🤯',
        macronProp: 'paintbrush',
      ),
      ComicPanelData(
        id: 'ch4_p3',
        backdrop: SceneBackdropType.calligraphyMuseum,
        speaker: CharacterId.covi,
        presentCharacters: [
          CharacterId.tlatoani,
          CharacterId.covi,
          CharacterId.nur,
          CharacterId.macron,
        ],
        tlatoaniEmotion: EmotionState.calm,
        coviEmotion: EmotionState.happy,
        dialogueText:
            'That is the coolest memory trick ever! If Spanish kept "al-" (like almohada), it\'s a Moon path; if Spanish dropped the L (like azúcar & aceite), it\'s a Sun letter!',
        dialogueTranslation:
            '¡Ese es el mejor truco de memoria del mundo! Si el español conservó "al-" (como almohada), es letra Lunar; si perdió la L (como azúcar y aceite), ¡es letra Solar!',
        spokenAudioText:
            'That is the coolest memory trick ever! Almohada is Moon, and azúcar is Sun!',
        spokenLocale: 'en-US',
        macronEmojis: '🧠⚡🏆',
        macronProp: 'compass',
      ),
      ComicPanelData(
        id: 'ch4_p4',
        backdrop: SceneBackdropType.calligraphyMuseum,
        speaker: CharacterId.nur,
        presentCharacters: [
          CharacterId.tlatoani,
          CharacterId.covi,
          CharacterId.nur,
          CharacterId.macron,
        ],
        tlatoaniEmotion: EmotionState.blushing,
        coviEmotion: EmotionState.teasing,
        heroineEmotion: EmotionState.happy,
        dialogueText:
            'شْلُونَك يَا تْلَاتُوَانِي؟ — "Ahora que ya lees nuestras letras, antes de que viajen al Levante a ver a mi amiga Yāsmīn, pídeme un café al estilo de Dubái: أَبْغِي قَهْوَة، مَا عَلَيْك أَمْر (Abghī gahwa, mā ‘alēk amr)."',
        dialogueTranslation:
            'Shlōnak yā Tlatoāni? Now that you read our script, before you travel to the Levant to meet my friend Yāsmīn, ask me for a coffee Dubai-style: أَبْغِي قَهْوَة، مَا عَلَيْك أَمْر (Abghī gahwa, mā ‘alēk amr).',
        spokenAudioText: 'شْلُونَك؟ أَبْغِي قَهْوَة، مَا عَلَيْك أَمْر.',
        spokenLocale: 'ar-AE',
        arabicSpotlight: ArabicWordToken(
          arabic: 'أَبْغِي قَهْوَة',
          unvocalized: 'أبغي قهوة',
          transliteration: 'Abghī gahwa',
          spanishMeaning: 'Quisiera un café (dialecto del Golfo)',
          englishMeaning: 'I’d like a coffee (Gulf / Dubai dialect)',
          spanishBridgeNote:
              'La غ en أَبْغِي suena como la "g" suave de "agua", y قَهْوَة en Dubái se pronuncia "gahwa".',
        ),
        macronEmojis: '🇦🇪☕💫',
        macronProp: 'dallah',
        culturalNote:
            'Añadir "mā ‘alēk amr" (sin que sea una orden / por favor con toda cortesía) en los Emiratos muestra elegancia y respeto.',
      ),
      ComicPanelData(
        id: 'ch4_p5',
        backdrop: SceneBackdropType.calligraphyMuseum,
        speaker: CharacterId.tlatoani,
        presentCharacters: [
          CharacterId.tlatoani,
          CharacterId.covi,
          CharacterId.nur,
          CharacterId.macron,
        ],
        tlatoaniEmotion: EmotionState.blushing,
        coviEmotion: EmotionState.teasing,
        heroineEmotion: EmotionState.happy,
        dialogueText:
            'أَبْغِي قَهْوَة مَعَكِ يَا نُور... "¡Quisiera tomar un café contigo, Nūr, antes de nuestro vuelo a Beirut!" (Covi, ni una palabra, que estoy practicando mi pronunciación del Golfo).',
        dialogueTranslation:
            'Abghī gahwa ma‘aki yā Nūr... "I\'d like to have a coffee with you, Nūr, before our flight to Beirut!" (Covi, not a word, I am practicing my Gulf pronunciation).',
        spokenAudioText:
            'Abghī gahwa ma‘aki yā Nūr. ¡Quisiera tomar un café contigo antes de nuestro vuelo!',
        spokenLocale: 'es-MX',
        macronEmojis: '🥰☕✈️',
        macronProp: 'teacup',
      ),
    ],
    challenge: const MasteryChallengeData(
      promptEs:
          'Antes de despedirnos de Nūr en la galería de Dubái, invítala a un último café usando la expresión auténtica emiratí (Khalījī) que nos acaba de enseñar:',
      promptEn:
          'Before saying farewell to Nūr at the Dubai gallery, ask for one more coffee together using the authentic Emirati (Khalījī) phrase she just taught us:',
      scenarioContext: 'En la terraza del Museo de Caligrafía de Dubái con Nūr.',
      traceLetter: _letterQaf,
      options: [
        MasteryOption(
          arabic: 'أَبْغِي قَهْوَة، مَا عَلَيْك أَمْر',
          transliteration: 'Abghī gahwa, mā ‘alēk amr',
          meaningEs: 'Quisiera un café, si eres tan amable (Dubái / Khalījī)',
          meaningEn: 'I’d like a coffee, if you don’t mind (Dubai / Khalījī)',
          isCorrect: true,
          feedbackEs:
              '¡Excelente! Nūr sonríe encantada: pronunciaste "Abghī gahwa" como todo un local de Dubái y completaste el Libro I.',
          feedbackEn:
              'Excellent! Nūr beams with delight: you pronounced "Abghī gahwa" like a true Dubai local and completed Book I!',
        ),
        MasteryOption(
          arabic: 'بَاب المَتْحَف كَبِير',
          transliteration: 'Bāb al-matḥaf kabīr',
          meaningEs: 'La puerta del museo es grande',
          meaningEn: 'The museum door is big',
          isCorrect: false,
          feedbackEs:
              'Eso dice "la puerta del museo es grande". ¡Rebobinemos 2 paneles para recordar cómo se pide café en Dubái (أَبْغِي قَهْوَة)!',
          feedbackEn:
              'That says "the museum door is big". Let\'s rewind 2 panels to review how to ask for coffee in Dubai (أَبْغِي قَهْوَة)!',
        ),
        MasteryOption(
          arabic: 'المِخَدَّة فِي الدَّار',
          transliteration: 'Al-mikhadda fī d-dār',
          meaningEs: 'La almohada está en la casa',
          meaningEn: 'The pillow is in the house',
          isCorrect: false,
          feedbackEs:
              '¡Le acabas de hablar de una almohada! Volvamos dos viñetas para repasar "Abghī gahwa" con Nūr.',
          feedbackEn:
              'You just talked about a pillow! Let\'s rewind two panels to practice "Abghī gahwa" with Nūr.',
        ),
      ],
    ),
  ),
];
