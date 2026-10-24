// @trace spec:character-canon, spec:curriculum-and-comics
import 'dart:ui';
import '../models/comic_models.dart';

const ArabicLetterLesson _letterTaEmphatic = ArabicLetterLesson(
  letter: 'ط',
  nameArabic: 'طَاء',
  nameTranslit: 'Ṭā’',
  forms: {'isolated': 'ط', 'initial': 'طـ', 'medial': 'ـطـ', 'final': 'ـط'},
  isNonConnector: false,
  sunOrMoon: 'sun',
  spanishPhoneticTip:
      'Una "T" enfática y profunda (bajando el dorso de la lengua); dio origen a la palabra española "taza" (طَاسَة ṭāsa).',
  englishPhoneticTip:
      'Emphatic, resonant "T" pronounced with a lowered tongue root; deepens adjacent vowels.',
  exampleArabic: 'طَاسَة',
  exampleTranslit: 'ṭāsa',
  exampleMeaningEsEn: 'taza, cuenco / cup, bowl',
  strokeWaypoints: [
    [
      Offset(0.32, 0.64),
      Offset(0.56, 0.44),
      Offset(0.76, 0.56),
      Offset(0.70, 0.66),
      Offset(0.24, 0.66),
    ],
    [Offset(0.38, 0.20), Offset(0.38, 0.62)],
  ],
);

const ArabicLetterLesson _letterSad = ArabicLetterLesson(
  letter: 'ص',
  nameArabic: 'صَاد',
  nameTranslit: 'Ṣād',
  forms: {'isolated': 'ص', 'initial': 'صـ', 'medial': 'ـصـ', 'final': 'ـص'},
  isNonConnector: false,
  sunOrMoon: 'sun',
  spanishPhoneticTip:
      'Una "S" enfática y grave; de صِفْر (ṣifr) nacieron nuestras palabras "cero" y "cifra", y de قَمِيص (qamīṣ) nuestra "camisa".',
  englishPhoneticTip:
      'Emphatic, deep "S" sound; ancestor of "zero/cipher" (صِفْر ṣifr).',
  exampleArabic: 'صِفْر',
  exampleTranslit: 'ṣifr',
  exampleMeaningEsEn: 'cero, cifra / zero, cipher',
  strokeWaypoints: [
    [
      Offset(0.80, 0.52),
      Offset(0.64, 0.36),
      Offset(0.52, 0.52),
      Offset(0.40, 0.74),
      Offset(0.22, 0.56),
    ],
  ],
);

const ArabicLetterLesson _letterShin = ArabicLetterLesson(
  letter: 'ش',
  nameArabic: 'شِين',
  nameTranslit: 'Shīn',
  forms: {'isolated': 'ش', 'initial': 'شـ', 'medial': 'ـشـ', 'final': 'ـش'},
  isNonConnector: false,
  sunOrMoon: 'sun',
  spanishPhoneticTip:
      'Sonido "sh" suave (como en "show" o el andaluz/chihuahuense "sh"). Tres dientecitos con tres puntos arriba.',
  englishPhoneticTip:
      'Sound "sh" as in "shine". Three teeth topped by three dots.',
  exampleArabic: 'شَاي',
  exampleTranslit: 'shāy',
  exampleMeaningEsEn: 'té / tea',
  strokeWaypoints: [
    [
      Offset(0.80, 0.46),
      Offset(0.68, 0.56),
      Offset(0.56, 0.46),
      Offset(0.42, 0.74),
      Offset(0.24, 0.52),
    ],
  ],
  dotOffsets: [Offset(0.64, 0.28), Offset(0.58, 0.20), Offset(0.52, 0.28)],
);

const ArabicLetterLesson _letterAyn = ArabicLetterLesson(
  letter: 'ع',
  nameArabic: 'عَيْن',
  nameTranslit: '‘Ayn',
  forms: {'isolated': 'ع', 'initial': 'عـ', 'medial': 'ـعـ', 'final': 'ـع'},
  isNonConnector: false,
  sunOrMoon: 'moon',
  spanishPhoneticTip:
      'La joya del árabe: una resonancia cálida en la garganta al pronunciar una vocal. ¡Es la primera letra de العَرَبِيَّة (al-‘Arabiyya) y de عَلَيَّ (‘alayya = "¡yo invito!")!',
  englishPhoneticTip:
      'Voiced pharyngeal approximant—a warm, resonant tightening of the throat; starts العَرَبِيَّة (al-‘Arabiyya).',
  exampleArabic: 'عَلَيَّ',
  exampleTranslit: '‘alayya',
  exampleMeaningEsEn: '¡corre por mi cuenta! / it is on me!',
  strokeWaypoints: [
    [
      Offset(0.66, 0.28),
      Offset(0.46, 0.36),
      Offset(0.64, 0.48),
      Offset(0.36, 0.68),
      Offset(0.66, 0.82),
    ],
  ],
);

final List<ComicChapterData> kBook2LevantChapters = [
  // =========================================================================
  // CHAPTER 5: The Jasmine & Tillandsia Bookshop in Beirut/Amman with Yāsmīn
  // =========================================================================
  ComicChapterData(
    id: 'ch5_jasmine_bookshop',
    number: 5,
    bookNumber: 2,
    bookTitle: 'Libro II: El Levante y el Jardín de Yāsmīn',
    regionName: 'Beirut & Amman 🇱🇧🇯🇴',
    dialectBadge: 'Shāmī + Fuṣḥā',
    heroine: CharacterId.yasmin,
    titleEs: 'Jazmines, Tillandsias y las 4 Enfáticas',
    titleEn: 'Jasmines, Tillandsias & The 4 Emphatics',
    titleArabic: 'مَكْتَبَة اليَاسْمِين',
    subtitle: 'Las 4 enfáticas (ص ض ط ظ — ¡Abjad completo!) y cognados hispanos',
    lettersUnlocked: const [_letterTaEmphatic, _letterSad],
    vocabularyUnlocked: const [
      ArabicWordToken(
        arabic: 'يَاسْمِين',
        unvocalized: 'ياسمين',
        transliteration: 'Yāsmīn',
        spanishMeaning: 'Jazmín (nombre de Yāsmīn)',
        englishMeaning: 'Jasmine (Yāsmīn’s name)',
        spanishBridgeNote:
            '¡Nuestro "jazmín" en español viene directo de يَاسْمِين (yāsmīn)!',
      ),
      ArabicWordToken(
        arabic: 'طَاسَة وَقَمِيص',
        unvocalized: 'طاسة وقميص',
        transliteration: 'ṭāsa wa qamīṣ',
        spanishMeaning: 'taza y camisa',
        englishMeaning: 'cup and shirt',
        spanishBridgeNote:
            'طَاسَة dio "taza" y قَمِيص dio "camisa", enseñándote las enfáticas ط (ṭ) y ص (ṣ).',
      ),
      ArabicWordToken(
        arabic: 'حَتَّى',
        unvocalized: 'حتى',
        transliteration: 'ḥattā',
        spanishMeaning: 'hasta / incluso',
        englishMeaning: 'until / even',
        spanishBridgeNote:
            '¡Incluso la preposición española "hasta" fue tomada directamente del árabe حَتَّى (ḥattā)!',
      ),
    ],
    panels: const [
      ComicPanelData(
        id: 'ch5_p1',
        backdrop: SceneBackdropType.jasmineBookshop,
        speaker: CharacterId.yasmin,
        presentCharacters: [
          CharacterId.tlatoani,
          CharacterId.covi,
          CharacterId.yasmin,
          CharacterId.macron,
        ],
        tlatoaniEmotion: EmotionState.happy,
        coviEmotion: EmotionState.excited,
        heroineEmotion: EmotionState.happy,
        dialogueText:
            'أَهْلَا وَسَهْلَا! نَوَّرْتُوا المَكْتَبَة! — "¡Ahla w sahla! ¡Iluminaron la librería-jardín! Soy Yāsmīn (يَاسْمِين). Nūr me contó que aman las Tillandsias tanto como yo."',
        dialogueTranslation:
            'Ahla w sahla! You lit up the garden bookshop! I am Yāsmīn (يَاسْمِين). Nūr told me you love Tillandsias just as much as I do.',
        spokenAudioText: 'أَهْلَا وَسَهْلَا! نَوَّرْتُوا المَكْتَبَة! أَنَا يَاسْمِين.',
        spokenLocale: 'ar-LB',
        arabicSpotlight: ArabicWordToken(
          arabic: 'أَهْلَا وَسَهْلَا',
          unvocalized: 'أهلا وسهلا',
          transliteration: 'Ahla w sahla',
          spanishMeaning: '¡Bienvenidos! (literalmente: llegaste a familia y tierra llana)',
          englishMeaning: 'Welcome! (lit. you have found family and smooth ground)',
          spanishBridgeNote:
              'En el Levante (Líbano, Jordania, Siria, Palestina), "Ahla w sahla" es el saludo más cálido y musical.',
        ),
        macronEmojis: '🌿🌼🤖',
        macronProp: 'tillandsia',
      ),
      ComicPanelData(
        id: 'ch5_p2',
        backdrop: SceneBackdropType.jasmineBookshop,
        speaker: CharacterId.tlatoani,
        presentCharacters: [
          CharacterId.tlatoani,
          CharacterId.covi,
          CharacterId.yasmin,
          CharacterId.macron,
        ],
        tlatoaniEmotion: EmotionState.blushing,
        coviEmotion: EmotionState.teasing,
        heroineEmotion: EmotionState.happy,
        dialogueText:
            '¡No manches, Yāsmīn! Tu nombre es literalmente nuestro "jazmín" (يَاسْمِين)... Me recuerda muchísimo a los patios de Guadalajara donde crecí, ¡y mira a mācron āi bien a gusto entre tus Tillandsias! Hasta la palabra "hasta" viene del árabe حَتَّى (ḥattā).',
        dialogueTranslation:
            'No way, Yāsmīn! Your name is literally our Spanish word "jazmín" (يَاسْمِين)... It reminds me so much of the courtyards in Guadalajara where I grew up, and look at mācron āi hanging happily among your Tillandsias! Even "hasta" comes from Arabic حَتَّى (ḥattā).',
        spokenAudioText:
            '¡No manches, Yāsmīn! Tu nombre es nuestro jazmín, como en los patios de Guadalajara donde crecí. Y hasta viene de ḥattā.',
        spokenLocale: 'es-MX',
        arabicSpotlight: ArabicWordToken(
          arabic: 'حَتَّى',
          unvocalized: 'حتى',
          transliteration: 'ḥattā',
          spanishMeaning: 'hasta',
          englishMeaning: 'until / even',
          spanishBridgeNote:
              'Pocas lenguas prestan preposiciones: el español adoptó حَتَّى (ḥattā) como "hasta" con el mismo uso exacto.',
        ),
        macronEmojis: '🪴😍🌸',
        macronProp: 'tillandsia',
      ),
      ComicPanelData(
        id: 'ch5_p3',
        backdrop: SceneBackdropType.jasmineBookshop,
        speaker: CharacterId.yasmin,
        presentCharacters: [
          CharacterId.tlatoani,
          CharacterId.covi,
          CharacterId.yasmin,
          CharacterId.macron,
        ],
        tlatoaniEmotion: EmotionState.calm,
        coviEmotion: EmotionState.curious,
        heroineEmotion: EmotionState.happy,
        dialogueText:
            'شُو حِلُو! — "¡Shū ḥilw! (¡Qué lindo!). Para completar las 28 letras del Abjad sólo les faltan las 4 Enfáticas: ص (ṣ), ض (ḍ), ط (ṭ) y ظ (ẓ). ¡Suenan más profundas y graves, como en طَاسَة (taza) y قَمِيص (camisa)!"',
        dialogueTranslation:
            'Shū ḥilw! (How sweet!). To complete all 28 letters of the Abjad you only need the 4 Emphatics: ص (ṣ), ض (ḍ), ط (ṭ), and ظ (ẓ). They sound deeper and fuller, like in طَاسَة (taza/cup) and قَمِيص (camisa/shirt)!',
        spokenAudioText: 'شُو حِلُو! طَاسَة، قَمِيص، وَصِفْر.',
        spokenLocale: 'ar-LB',
        arabicSpotlight: ArabicWordToken(
          arabic: 'طَاسَة وَقَمِيص',
          unvocalized: 'طاسة وقميص',
          transliteration: 'ṭāsa wa qamīṣ',
          spanishMeaning: 'taza y camisa',
          englishMeaning: 'cup and shirt',
          spanishBridgeNote:
              'Con ص ض ط ظ completas el 100% de las 28 letras del alfabeto árabe.',
        ),
        macronEmojis: '🍵👕🎓',
        macronProp: 'teacup',
      ),
      ComicPanelData(
        id: 'ch5_p4',
        backdrop: SceneBackdropType.jasmineBookshop,
        speaker: CharacterId.covi,
        presentCharacters: [
          CharacterId.tlatoani,
          CharacterId.covi,
          CharacterId.yasmin,
          CharacterId.macron,
        ],
        tlatoaniEmotion: EmotionState.blushing,
        coviEmotion: EmotionState.teasing,
        heroineEmotion: EmotionState.happy,
        dialogueText:
            'Wait—we officially know all 28 letters of the Arabic alphabet now?! And look at Tlatoāni adjusting his tunic collar because Yāsmīn said "Shū ḥilw"!',
        dialogueTranslation:
            '¡Espera! ¿Ya conocemos oficialmente las 28 letras del alfabeto árabe? ¡Y mira a Tlatoāni acomodándose el cuello de la túnica porque Yāsmīn dijo "Shū ḥilw"!',
        spokenAudioText:
            'We officially know all twenty-eight letters of the Arabic alphabet now!',
        spokenLocale: 'en-US',
        macronEmojis: '🎉2️⃣8️⃣',
        macronProp: 'tillandsia',
      ),
      ComicPanelData(
        id: 'ch5_p5',
        backdrop: SceneBackdropType.jasmineBookshop,
        speaker: CharacterId.tlatoani,
        presentCharacters: [
          CharacterId.tlatoani,
          CharacterId.covi,
          CharacterId.yasmin,
          CharacterId.macron,
        ],
        tlatoaniEmotion: EmotionState.happy,
        coviEmotion: EmotionState.happy,
        heroineEmotion: EmotionState.happy,
        dialogueText:
            '¡Las 28 letras desbloqueadas! Desde صِفْر (ṣifr = cero) hasta la unidad: de cero a uno, tal como prometimos.',
        dialogueTranslation:
            'All 28 letters unlocked! From صِفْر (ṣifr = zero) to one: from zero to one, just as we promised.',
        spokenAudioText:
            '¡Las veintiocho letras desbloqueadas! Desde ṣifr, cero, hasta uno.',
        spokenLocale: 'es-MX',
        macronEmojis: '0️⃣➡️1️⃣',
        macronProp: 'compass',
      ),
    ],
    challenge: const MasteryChallengeData(
      promptEs:
          'Yāsmīn nos sirve té de jazmín en una taza artesanal de cerámica. ¿Qué palabra árabe con la letra enfática ط (Ṭā’) dio origen a nuestra palabra "taza"?',
      promptEn:
          'Yāsmīn pours us jasmine tea in a handcrafted ceramic cup. Which Arabic word starting with the emphatic letter ط (Ṭā’) gave Spanish the word "taza"?',
      scenarioContext: 'En la librería-jardín de Yāsmīn rodeados de Tillandsias.',
      traceLetter: _letterTaEmphatic,
      options: [
        MasteryOption(
          arabic: 'طَاسَة',
          transliteration: 'ṭāsa',
          meaningEs: 'taza / cuenco (con ط enfática)',
          meaningEn: 'cup / bowl (with emphatic ط)',
          isCorrect: true,
          feedbackEs:
              '¡Exacto! طَاسَة (ṭāsa) empieza con la enfática ط y pasó directamente al español como "taza".',
          feedbackEn:
              'Exact! طَاسَة (ṭāsa) starts with the emphatic ط and passed directly into Spanish as "taza".',
        ),
        MasteryOption(
          arabic: 'خُبْز',
          transliteration: 'khubz',
          meaningEs: 'pan',
          meaningEn: 'bread',
          isCorrect: false,
          feedbackEs:
              'خُبْز es "pan". Buscamos la palabra con ط que suena igual a "taza". ¡Rebobinemos dos paneles!',
          feedbackEn:
              'خُبْز is "bread". We want the word starting with ط that sounds like "taza". Rewinding 2 panels!',
        ),
        MasteryOption(
          arabic: 'بَاب',
          transliteration: 'bāb',
          meaningEs: 'puerta',
          meaningEn: 'door',
          isCorrect: false,
          feedbackEs:
              'بَاب es "puerta". ¡Volvamos 2 paneles con Yāsmīn para repasar las 4 letras enfáticas!',
          feedbackEn:
              'بَاب is "door". Let\'s rewind 2 panels with Yāsmīn to review the 4 emphatic letters!',
        ),
      ],
    ),
  ),

  // =========================================================================
  // CHAPTER 6: Bus Route, Numbers 0-9 & Reading the Street with Yāsmīn
  // =========================================================================
  ComicChapterData(
    id: 'ch6_bus_and_souk',
    number: 6,
    bookNumber: 2,
    bookTitle: 'Libro II: El Levante y el Jardín de Yāsmīn',
    regionName: 'Beirut & Amman 🇱🇧🇯🇴',
    dialectBadge: 'Shāmī + Fuṣḥā',
    heroine: CharacterId.yasmin,
    titleEs: 'En Autobús por el Zoco: Números y Direcciones',
    titleEn: 'By Bus Through the Souk: Numbers & Directions',
    titleArabic: 'البَاص وَالسُّوق',
    subtitle: 'Números (٠–٩), pedir parada (عَلَى جَنَب!) y preguntar el precio (قَدِّيش؟)',
    lettersUnlocked: const [_letterSad, _letterShin],
    vocabularyUnlocked: const [
      ArabicWordToken(
        arabic: 'عَلَى جَنَب هُون!',
        unvocalized: 'على جنب هون',
        transliteration: '‘Ala janab hōn!',
        spanishMeaning: '¡A un lado aquí! (para bajar del autobús o taxi)',
        englishMeaning: 'Pull over on the side here! (for bus/taxi)',
        spanishBridgeNote:
            'Frase indispensable de supervivencia en transporte público por todo el Levante y Egipto.',
      ),
      ArabicWordToken(
        arabic: 'قَدِّيش الحِسَاب؟',
        unvocalized: 'قديش الحساب',
        transliteration: '’Addēsh el-ḥisāb?',
        spanishMeaning: '¿Cuánto es la cuenta / el pasaje? (Levante)',
        englishMeaning: 'How much is the fare / bill? (Levantine)',
        spanishBridgeNote:
            'En el Levante la ق se pronuncia como una pausa glotal suave (’addēsh), mientras que الحِسَاب viene de la raíz ح-س-ب (calcular).',
        dialectVariants: {
          'msa': 'بِكَمِ الحِسَاب؟ (Bikam al-ḥisāb?)',
          'khaliji': 'بِكَم هٰذَا؟ (Bikam hādha?)',
          'shami': 'قَدِّيش الحِسَاب؟ (’Addēsh el-ḥisāb?)',
          'masri': 'بِكَام الحِسَاب؟ (Bikām el-ḥisāb?)',
        },
      ),
    ],
    panels: const [
      ComicPanelData(
        id: 'ch6_p1',
        backdrop: SceneBackdropType.levantBusStreet,
        speaker: CharacterId.yasmin,
        presentCharacters: [
          CharacterId.tlatoani,
          CharacterId.covi,
          CharacterId.yasmin,
          CharacterId.macron,
        ],
        tlatoaniEmotion: EmotionState.calm,
        coviEmotion: EmotionState.curious,
        heroineEmotion: EmotionState.happy,
        dialogueText:
            'يَلَّا نِرْكَب البَاص! — "¡Yallā, subamos al autobús hacia el zoco antiguo (السُّوق as-sūq)! Mira el número de ruta: ١ ٢ ٣ (1, 2, 3). ¡En árabe los números se leen de izquierda a derecha, igual que en español e inglés!"',
        dialogueTranslation:
            'Yallā, let\'s hop on the bus to the old souk (السُّوق as-sūq)! Look at the route number: ١ ٢ ٣ (1, 2, 3). In Arabic, numbers are read from left to right, just like in Spanish and English!',
        spokenAudioText: 'يَلَّا نِرْكَب البَاص إِلَى السُّوق!',
        spokenLocale: 'ar-LB',
        arabicSpotlight: ArabicWordToken(
          arabic: '٠ ١ ٢ ٣ ٤ ٥ ٦ ٧ ٨ ٩',
          unvocalized: '٠١٢٣٤٥٦٧٨٩',
          transliteration: '0 1 2 3 4 5 6 7 8 9',
          spanishMeaning: 'Las cifras indo-arábigas (de صِفْر ṣifr = cero/cifra)',
          englishMeaning: 'Eastern Arabic numerals (from صِفْر ṣifr = zero/cipher)',
          spanishBridgeNote:
              'Aunque las palabras se leen de derecha a izquierda, los números compuestos (como ٢٥ = 25) se leen de izquierda a derecha.',
        ),
        macronEmojis: '🚌🔢🗺️',
        macronProp: 'compass',
      ),
      ComicPanelData(
        id: 'ch6_p2',
        backdrop: SceneBackdropType.levantBusStreet,
        speaker: CharacterId.tlatoani,
        presentCharacters: [
          CharacterId.tlatoani,
          CharacterId.covi,
          CharacterId.yasmin,
          CharacterId.macron,
        ],
        tlatoaniEmotion: EmotionState.happy,
        coviEmotion: EmotionState.happy,
        dialogueText:
            '¡Y السُّوق (as-sūq) es literalmente nuestro "zoco" o mercado tradicional en español! Chofer, por favor: وَدِّينِي عَلَى السُّوق (Waddīnī ‘as-sūq — llévame al zoco).',
        dialogueTranslation:
            'And السُّوق (as-sūq) is literally our Spanish word "zoco" (traditional market)! Driver, please: وَدِّينِي عَلَى السُّوق (Waddīnī ‘as-sūq — take me to the souk).',
        spokenAudioText:
            '¡Y as-sūq es literalmente nuestro zoco en español! Waddīnī ‘as-sūq.',
        spokenLocale: 'es-MX',
        macronEmojis: '🛍️🏛️✨',
        macronProp: 'compass',
      ),
      ComicPanelData(
        id: 'ch6_p3',
        backdrop: SceneBackdropType.levantBusStreet,
        speaker: CharacterId.covi,
        presentCharacters: [
          CharacterId.tlatoani,
          CharacterId.covi,
          CharacterId.yasmin,
          CharacterId.macron,
        ],
        tlatoaniEmotion: EmotionState.calm,
        coviEmotion: EmotionState.excited,
        dialogueText:
            'Look, there\'s the rooftop café terrace right next to the archway! How do we tell the bus driver how much the fare is and ask to hop off right here?',
        dialogueTranslation:
            '¡Mira, ahí está la terraza del café justo al lado del arco! ¿Cómo le preguntamos al chofer cuánto es el pasaje y le pedimos bajar aquí mismo?',
        spokenAudioText:
            'There is the café terrace! How do we ask the driver how much it is and hop off right here?',
        spokenLocale: 'en-US',
        macronEmojis: '🛑🚌🪙',
        macronProp: 'lantern',
      ),
      ComicPanelData(
        id: 'ch6_p4',
        backdrop: SceneBackdropType.levantBusStreet,
        speaker: CharacterId.yasmin,
        presentCharacters: [
          CharacterId.tlatoani,
          CharacterId.covi,
          CharacterId.yasmin,
          CharacterId.macron,
        ],
        tlatoaniEmotion: EmotionState.calm,
        coviEmotion: EmotionState.happy,
        heroineEmotion: EmotionState.happy,
        dialogueText:
            'قُولُوا: عَلَى جَنَب هُون! وَقَدِّيش الحِسَاب؟ — "Digan: ¡‘Ala janab hōn! (¡A un lado aquí!) y ¿’Addēsh el-ḥisāb? (¿Cuánto es la cuenta?)."',
        dialogueTranslation:
            'Say: ‘Ala janab hōn! (On the side here!) and ’Addēsh el-ḥisāb? (How much is the fare/bill?).',
        spokenAudioText: 'عَلَى جَنَب هُون، مْنْ فَضْلَك! قَدِّيش الحِسَاب؟',
        spokenLocale: 'ar-LB',
        arabicSpotlight: ArabicWordToken(
          arabic: 'عَلَى جَنَب هُون!',
          unvocalized: 'على جنب هون',
          transliteration: '‘Ala janab hōn!',
          spanishMeaning: '¡A un lado aquí! (Parada aquí, por favor)',
          englishMeaning: 'Pull over on the side here!',
          spanishBridgeNote:
              'هُون (hōn) significa "aquí" en el Levante (en MSA es هُنَا hunā).',
        ),
        macronEmojis: '🚏👋😊',
        macronProp: 'compass',
      ),
      ComicPanelData(
        id: 'ch6_p5',
        backdrop: SceneBackdropType.levantBusStreet,
        speaker: CharacterId.tlatoani,
        presentCharacters: [
          CharacterId.tlatoani,
          CharacterId.covi,
          CharacterId.yasmin,
          CharacterId.macron,
        ],
        tlatoaniEmotion: EmotionState.blushing,
        coviEmotion: EmotionState.teasing,
        heroineEmotion: EmotionState.happy,
        dialogueText:
            'عَلَى جَنَب هُون! ¡Yo pago los tres pasajes, Yāsmīn! En mi tierra y en la tuya, la hospitalidad es sagrada.',
        dialogueTranslation:
            '‘Ala janab hōn! I\'m paying all three fares, Yāsmīn! In my homeland and in yours, hospitality is sacred.',
        spokenAudioText:
            '‘Ala janab hōn! Yo pago los tres pasajes, Yāsmīn.',
        spokenLocale: 'es-MX',
        macronEmojis: '🎩🦎💝',
        macronProp: 'teacup',
      ),
    ],
    challenge: const MasteryChallengeData(
      promptEs:
          'El autobús está llegando frente al zoco donde está la terraza de Yāsmīn. ¿Qué le dices al conductor para pedir bajar aquí mismo?',
      promptEn:
          'The bus is approaching the souk entrance by Yāsmīn’s terrace. What do you say to the driver to ask to pull over right here?',
      scenarioContext: 'A bordo del autobús en Beirut/Ammán junto a Yāsmīn y Covi.',
      traceLetter: _letterSad,
      options: [
        MasteryOption(
          arabic: 'عَلَى جَنَب هُون، مْنْ فَضْلَك!',
          transliteration: '‘Ala janab hōn, min faḍlak!',
          meaningEs: '¡A un lado aquí, por favor!',
          meaningEn: 'On the side here, please!',
          isCorrect: true,
          feedbackEs:
              '¡Exacto! El chofer frena con una sonrisa: "¡Ahla w sahla!".',
          feedbackEn:
              'Exact! The driver pulls over with a warm smile: "Ahla w sahla!".',
        ),
        MasteryOption(
          arabic: 'أَنَا فِي المَطَار',
          transliteration: 'Anā fī l-maṭār',
          meaningEs: 'Estoy en el aeropuerto',
          meaningEn: 'I am at the airport',
          isCorrect: false,
          feedbackEs:
              'Eso dice "estoy en el aeropuerto". ¡Rebobinemos dos paneles para recordar cómo pedir parada en el autobús (عَلَى جَنَب هُون)!',
          feedbackEn:
              'That says "I am at the airport". Let\'s rewind 2 panels to review how to ask the bus to pull over (عَلَى جَنَب هُون)!',
        ),
        MasteryOption(
          arabic: 'سُكَّر وَحَلِيب',
          transliteration: 'Sukkar wa ḥalīb',
          meaningEs: 'Azúcar y leche',
          meaningEn: 'Sugar and milk',
          isCorrect: false,
          feedbackEs:
              '¡Le pediste azúcar y leche al chofer! Volvamos dos paneles para escuchar a Yāsmīn.',
          feedbackEn:
              'You just asked the bus driver for sugar and milk! Let\'s rewind two panels to listen to Yāsmīn.',
        ),
      ],
    ),
  ),

  // =========================================================================
  // CHAPTER 7: Levantine Wit & Culturally Respectful Courtship (Adab & Ghazal)
  // =========================================================================
  ComicChapterData(
    id: 'ch7_levantine_adab',
    number: 7,
    bookNumber: 2,
    bookTitle: 'Libro II: El Levante y el Jardín de Yāsmīn',
    regionName: 'Beirut & Amman 🇱🇧🇯🇴',
    dialectBadge: 'Shāmī + Fuṣḥā',
    heroine: CharacterId.yasmin,
    titleEs: 'Cortesía Levantina: "Iluminaste el Lugar"',
    titleEn: 'Levantine Grace: "You Lit Up the Place"',
    titleArabic: 'لُطْف الشَّام وَالكَلَام الحِلُو',
    subtitle: 'Cumplidos culturales respetuosos (دَمِّك خَفِيف، نَوَّرْتِي المَكَان، تِكْرَم عَيْنَك)',
    lettersUnlocked: const [_letterShin, _letterAyn],
    vocabularyUnlocked: const [
      ArabicWordToken(
        arabic: 'نَوَّرْتِي المَكَان',
        unvocalized: 'نورتي المكان',
        transliteration: 'Nawaritī el-makān',
        spanishMeaning: 'Iluminaste el lugar (cumplido elegante a una mujer)',
        englishMeaning: 'You lit up the place (elegant compliment to a woman)',
        spanishBridgeNote:
            'Comparte la misma raíz ن-و-ر (luz) del nombre de Nūr. En el mundo árabe, elogiar la luz y presencia de alguien es el cumplido más fino y respetuoso.',
      ),
      ArabicWordToken(
        arabic: 'دَمِّك خَفِيف!',
        unvocalized: 'دمك خفيف',
        transliteration: 'Damik khafīf!',
        spanishMeaning: '¡Qué simpática / encantadora eres! (lit. tu sangre es ligera)',
        englishMeaning: 'You are so charming / witty! (lit. your blood is light)',
        spanishBridgeNote:
            'Hacia un hombre se pronuncia "Damak khafīf" (-ak) y hacia una mujer "Damik khafīf" (-ik).',
      ),
      ArabicWordToken(
        arabic: 'تِكْرَم عَيْنَك',
        unvocalized: 'تكرم عينك',
        transliteration: 'Tikram ‘aynak / ‘aynik',
        spanishMeaning: '¡Con todo gusto! (lit. que tu ojo sea honrado)',
        englishMeaning: 'With pleasure! (lit. may your eye be honored)',
        spanishBridgeNote:
            'Muestra la raíz ك-ر-م (Karam = generosidad noble) y عَيْن (‘ayn = ojo / manantial).',
      ),
    ],
    panels: const [
      ComicPanelData(
        id: 'ch7_p1',
        backdrop: SceneBackdropType.jasmineBookshop,
        speaker: CharacterId.covi,
        presentCharacters: [
          CharacterId.tlatoani,
          CharacterId.covi,
          CharacterId.yasmin,
          CharacterId.macron,
        ],
        tlatoaniEmotion: EmotionState.blushing,
        coviEmotion: EmotionState.curious,
        heroineEmotion: EmotionState.happy,
        dialogueText:
            'Yāsmīn, Tlatoāni wants to be super charming and invite you for mint tea on the terrace, but he wants to make sure he does it with authentic Arab etiquette, not cheesy tourist lines!',
        dialogueTranslation:
            'Yāsmīn, Tlatoāni quiere ser súper encantador e invitarte a un té de menta en la terraza, ¡pero quiere hacerlo con auténtica cortesía árabe, sin frases clichés de turista!',
        spokenAudioText:
            'Yāsmīn, Tlatoāni wants to invite you for mint tea with authentic Arab etiquette!',
        spokenLocale: 'en-US',
        macronEmojis: '🍵🌸😳',
        macronProp: 'tillandsia',
      ),
      ComicPanelData(
        id: 'ch7_p2',
        backdrop: SceneBackdropType.jasmineBookshop,
        speaker: CharacterId.yasmin,
        presentCharacters: [
          CharacterId.tlatoani,
          CharacterId.covi,
          CharacterId.yasmin,
          CharacterId.macron,
        ],
        tlatoaniEmotion: EmotionState.calm,
        coviEmotion: EmotionState.happy,
        heroineEmotion: EmotionState.happy,
        dialogueText:
            'يَا عَيْنِي عَلَى الذُّوق! — "¡Qué delicadeza! En nuestra cultura, el coqueteo bonito (لُطْف luṭf) nunca es brusco: celebra el ingenio, la luz y la alegría de conversar. Por ejemplo, decir نَوَّرْتِي المَكَان (Nawaritī el-makān = iluminaste el lugar)."',
        dialogueTranslation:
            'How thoughtful! In our culture, graceful charm (لُطْف luṭf) is never pushy: it celebrates wit, light, and the joy of conversation. For instance, saying نَوَّرْتِي المَكَان (Nawaritī el-makān = you lit up the place).',
        spokenAudioText: 'نَوَّرْتِي المَكَان! وَدَمِّك خَفِيف كْتِير.',
        spokenLocale: 'ar-LB',
        arabicSpotlight: ArabicWordToken(
          arabic: 'نَوَّرْتِي المَكَان',
          unvocalized: 'نورتي المكان',
          transliteration: 'Nawaritī el-makān',
          spanishMeaning: 'Iluminaste el lugar (a una mujer; a un hombre: Nawart el-makān)',
          englishMeaning: 'You lit up the place',
          spanishBridgeNote:
              'Observa el sufijo femenino "-tī" / "-ik" al hablarle a una mujer, frente a "-t" / "-ak" al hablarle a un hombre.',
        ),
        macronEmojis: '✨🏛️🕯️',
        macronProp: 'lantern',
        culturalNote:
            'En el mundo árabe, la cortesía (Adab) valora la poesía cotidiana y el respeto: elogiar el sentido del humor ("Damik khafīf") o decir "Nawaritī el-makān" abre todas las puertas con elegancia.',
      ),
      ComicPanelData(
        id: 'ch7_p3',
        backdrop: SceneBackdropType.jasmineBookshop,
        speaker: CharacterId.yasmin,
        presentCharacters: [
          CharacterId.tlatoani,
          CharacterId.covi,
          CharacterId.yasmin,
          CharacterId.macron,
        ],
        tlatoaniEmotion: EmotionState.happy,
        coviEmotion: EmotionState.happy,
        heroineEmotion: EmotionState.happy,
        dialogueText:
            'وَإِذَا ضِحِكْتُوا سَوَا، قُول: دَمِّك خَفِيف! — "Y cuando alguien te hace reír con chispa e inteligencia, le dices: ¡Damik khafīf! (literalmente: tu sangre es ligera = eres encantadora y muy simpática)."',
        dialogueTranslation:
            'And when someone makes you laugh with wit and warmth, you tell her: Damik khafīf! (literally: your blood is light = you are so charming and witty).',
        spokenAudioText: 'دَمِّك خَفِيف! وَتِكْرَم عَيْنَك.',
        spokenLocale: 'ar-LB',
        arabicSpotlight: ArabicWordToken(
          arabic: 'دَمِّك خَفِيف!',
          unvocalized: 'دمك خفيف',
          transliteration: 'Damik khafīf!',
          spanishMeaning: '¡Qué simpática y encantadora eres!',
          englishMeaning: 'You are so charming and witty!',
          spanishBridgeNote:
              'En español decimos "caer liviano / tener ángel"; en árabe se dice "tener la sangre ligera" (خَفِيف khafīf).',
        ),
        macronEmojis: '😊💫🎭',
        macronProp: 'teacup',
      ),
      ComicPanelData(
        id: 'ch7_p4',
        backdrop: SceneBackdropType.jasmineBookshop,
        speaker: CharacterId.tlatoani,
        presentCharacters: [
          CharacterId.tlatoani,
          CharacterId.covi,
          CharacterId.yasmin,
          CharacterId.macron,
        ],
        tlatoaniEmotion: EmotionState.blushing,
        coviEmotion: EmotionState.teasing,
        heroineEmotion: EmotionState.happy,
        dialogueText:
            'يَا يَاسْمِين، نَوَّرْتِي المَكَان... وَدَمِّك خَفِيف كْتِير! (¡Yāsmīn, iluminaste el lugar... y tienes un encanto maravilloso!).',
        dialogueTranslation:
            'Yā Yāsmīn, nawaritī el-makān... wa damik khafīf ktīr! (Yāsmīn, you lit up the place... and you are wonderfully charming!).',
        spokenAudioText:
            'Yā Yāsmīn, nawaritī el-makān, wa damik khafīf ktīr!',
        spokenLocale: 'es-MX',
        macronEmojis: '🦎🌺💘',
        macronProp: 'tillandsia',
      ),
      ComicPanelData(
        id: 'ch7_p5',
        backdrop: SceneBackdropType.jasmineBookshop,
        speaker: CharacterId.covi,
        presentCharacters: [
          CharacterId.tlatoani,
          CharacterId.covi,
          CharacterId.yasmin,
          CharacterId.macron,
        ],
        tlatoaniEmotion: EmotionState.blushing,
        coviEmotion: EmotionState.teasing,
        heroineEmotion: EmotionState.happy,
        dialogueText:
            'Smooth, Tlatoāni, very smooth! Even mācron āi is fanning your coral gills with a Tillandsia leaf!',
        dialogueTranslation:
            '¡Qué galán, Tlatoāni, qué clase! ¡Hasta mācron āi te está abanicando las branquias color coral con una hoja de Tillandsia!',
        spokenAudioText:
            'Smooth, Tlatoāni, very smooth! Even mācron is fanning your coral gills!',
        spokenLocale: 'en-US',
        macronEmojis: '🌿🪭😉',
        macronProp: 'tillandsia',
      ),
    ],
    challenge: const MasteryChallengeData(
      promptEs:
          'Yāsmīn te cuenta una anécdota ingeniosa sobre sus plantas y todo el café ríe con ternura. ¿Qué cumplido culturalmente auténtico le dices para elogiar su gracia y simpatía?',
      promptEn:
          'Yāsmīn shares a witty story about her plants and the whole café smiles warmly. Which culturally authentic compliment do you use to praise her charm and wit?',
      scenarioContext: 'Conversando entre risas con Yāsmīn en su librería.',
      traceLetter: _letterShin,
      options: [
        MasteryOption(
          arabic: 'دَمِّك خَفِيف وَنَوَّرْتِي المَكَان!',
          transliteration: 'Damik khafīf wa nawaritī el-makān!',
          meaningEs: '¡Qué encantadora eres e iluminaste el lugar!',
          meaningEn: 'You are so charming/witty and you lit up the place!',
          isCorrect: true,
          feedbackEs:
              '¡Maravilloso! Usaste el femenino (-ik / -tī) y el elogio más querido del mundo árabe.',
          feedbackEn:
              'Wonderful! You used the feminine form (-ik / -tī) and the most beloved compliment in the Arab world.',
        ),
        MasteryOption(
          arabic: 'عَلَى جَنَب هُون!',
          transliteration: '‘Ala janab hōn!',
          meaningEs: '¡Estaciónese a un lado aquí!',
          meaningEn: 'Pull over on the side here!',
          isCorrect: false,
          feedbackEs:
              '¡Jaja! ¡Le acabas de pedir a Yāsmīn que se estacione como un autobús! Rebobinemos 2 paneles.',
          feedbackEn:
              'Haha! You just asked Yāsmīn to pull over like a bus! Let\'s rewind 2 panels.',
        ),
        MasteryOption(
          arabic: 'قَدِّيش الحِسَاب؟',
          transliteration: '’Addēsh el-ḥisāb?',
          meaningEs: '¿Cuánto es la cuenta?',
          meaningEn: 'How much is the bill?',
          isCorrect: false,
          feedbackEs:
              'Eso es para pedir la cuenta. ¡Volvamos 2 paneles para repasar "Damik khafīf" y "Nawaritī el-makān"!',
          feedbackEn:
              'That asks for the check. Let\'s rewind 2 panels to review "Damik khafīf" and "Nawaritī el-makān"!',
        ),
      ],
    ),
  ),

  // =========================================================================
  // CHAPTER 8: The Rooftop Invitation — Inviting Yāsmīn Out with Confidence!
  // =========================================================================
  ComicChapterData(
    id: 'ch8_rooftop_invite',
    number: 8,
    bookNumber: 2,
    bookTitle: 'Libro II: El Levante y el Jardín de Yāsmīn',
    regionName: 'Beirut & Amman 🇱🇧🇯🇴',
    dialectBadge: 'Shāmī + Fuṣḥā',
    heroine: CharacterId.yasmin,
    titleEs: 'La Invitación en la Terraza: "¿Tomamos Algo Juntos?"',
    titleEn: 'The Rooftop Invitation: "Shall We Grab a Drink Together?"',
    titleArabic: 'سَهْرَة عَلَى السَّطْح',
    subtitle: 'Invitar a salir con confianza (حَابَّة نِشْرَب شِي سَوَا؟) y la generosidad de عَلَيَّ!',
    lettersUnlocked: const [_letterAyn, _letterTaEmphatic],
    vocabularyUnlocked: const [
      ArabicWordToken(
        arabic: 'حَابَّة نِشْرَب شِي سَوَا؟',
        unvocalized: 'حابة نشرب شي سوا',
        transliteration: 'Ḥābbe nishrab shī sawa?',
        spanishMeaning: '¿Te gustaría que tomemos algo juntos? (a una mujer)',
        englishMeaning: 'Would you like us to grab a drink together? (to a woman)',
        spanishBridgeNote:
            'حَابَّة (ḥābbe = te apetece, fem.) + نِشْرَب (nishrab = bebemos/tomamos, raíz ش-ر-ب de donde viene nuestro "¡jarabe!" y "sorbete") + شِي (shī = algo) + سَوَا (sawa = juntos).',
        rootLetters: 'ش-ر-ب',
      ),
      ArabicWordToken(
        arabic: 'عَلَيَّ! الحِسَاب عِنْدِي',
        unvocalized: 'علي الحساب عندي',
        transliteration: '‘Alayya! El-ḥisāb ‘indī',
        spanishMeaning: '¡Corre por mi cuenta! La invitación es mía',
        englishMeaning: 'It’s on me! The check is with me',
        spanishBridgeNote:
            'En la cultura árabe, quien invita insiste con alegría diciendo "¡‘Alayya!" (sobre mí / yo invito).',
      ),
    ],
    panels: const [
      ComicPanelData(
        id: 'ch8_p1',
        backdrop: SceneBackdropType.rooftopLounge,
        speaker: CharacterId.tlatoani,
        presentCharacters: [
          CharacterId.tlatoani,
          CharacterId.covi,
          CharacterId.yasmin,
          CharacterId.macron,
        ],
        tlatoaniEmotion: EmotionState.happy,
        coviEmotion: EmotionState.excited,
        heroineEmotion: EmotionState.calm,
        dialogueText:
            '¡Llegó el momento de la verdad, Covi! Yāsmīn está cerrando la librería al atardecer. Y fíjate: el verbo "beber/tomar" (نِشْرَب nishrab) viene de la misma raíz árabe que nuestras palabras españolas "jarabe" y "sorbete" (ش-ر-ب).',
        dialogueTranslation:
            'The moment of truth has arrived, Covi! Yāsmīn is closing the bookshop at sunset. And notice: the verb "to drink" (نِشْرَب nishrab) comes from the exact same Arabic root as our Spanish words "jarabe" and "sorbete" (ش-ر-ب / sherbet)!',
        spokenAudioText:
            '¡Llegó el momento de la verdad! El verbo nishrab viene de la misma raíz que jarabe y sorbete.',
        spokenLocale: 'es-MX',
        arabicSpotlight: ArabicWordToken(
          arabic: 'نِشْرَب',
          unvocalized: 'نشرب',
          transliteration: 'nishrab',
          spanishMeaning: 'tomamos / bebemos (raíz de "jarabe" y "sorbete")',
          englishMeaning: 'we drink / grab a drink (root of "sherbet/syrup")',
          spanishBridgeNote:
              'Raíz ش-ر-ب (sh-r-b). شَرَاب (sharāb = bebida) dio en español "jarabe" y en inglés "syrup / sherbet".',
          rootLetters: 'ش-ر-ب',
        ),
        macronEmojis: '🍹🌆💡',
        macronProp: 'teacup',
      ),
      ComicPanelData(
        id: 'ch8_p2',
        backdrop: SceneBackdropType.rooftopLounge,
        speaker: CharacterId.covi,
        presentCharacters: [
          CharacterId.tlatoani,
          CharacterId.covi,
          CharacterId.yasmin,
          CharacterId.macron,
        ],
        tlatoaniEmotion: EmotionState.blushing,
        coviEmotion: EmotionState.teasing,
        heroineEmotion: EmotionState.calm,
        dialogueText:
            'You\'ve got this, Tlatoāni! Deep breath, single tail poised, coral gills ready—go ask Yāsmīn out for an evening drink on the rooftop terrace!',
        dialogueTranslation:
            '¡Tú puedes, Tlatoāni! Respira hondo, cola lista, branquias coral radiantes: ¡ve a invitar a Yāsmīn a tomar algo en la terraza al atardecer!',
        spokenAudioText:
            'You have got this, Tlatoāni! Go ask Yāsmīn out for an evening drink on the terrace!',
        spokenLocale: 'en-US',
        macronEmojis: '📣🦎💐',
        macronProp: 'lantern',
      ),
      ComicPanelData(
        id: 'ch8_p3',
        backdrop: SceneBackdropType.rooftopLounge,
        speaker: CharacterId.tlatoani,
        presentCharacters: [
          CharacterId.tlatoani,
          CharacterId.covi,
          CharacterId.yasmin,
          CharacterId.macron,
        ],
        tlatoaniEmotion: EmotionState.blushing,
        coviEmotion: EmotionState.happy,
        heroineEmotion: EmotionState.happy,
        dialogueText:
            'يَا يَاسْمِين، الجَوّ حِلُو كْتِير اللَّيْلَة... حَابَّة نِشْرَب شِي سَوَا عَلَى السَّطْح؟ — "Yāsmīn, la tarde está preciosa hoy... ¿te gustaría que tomemos algo juntos en la terraza?"',
        dialogueTranslation:
            'Yā Yāsmīn, el-jaww ḥilw ktīr el-layle... Ḥābbe nishrab shī sawa ‘ala s-saṭḥ? — "Yāsmīn, the evening weather is lovely tonight... would you like us to grab a drink together on the rooftop?"',
        spokenAudioText:
            'Yā Yāsmīn, ḥābbe nishrab shī sawa ‘ala s-saṭḥ?',
        spokenLocale: 'es-MX',
        arabicSpotlight: ArabicWordToken(
          arabic: 'حَابَّة نِشْرَب شِي سَوَا؟',
          unvocalized: 'حابة نشرب شي سوا',
          transliteration: 'Ḥābbe nishrab shī sawa?',
          spanishMeaning: '¿Te gustaría que tomemos algo juntos?',
          englishMeaning: 'Would you like us to grab a drink together?',
          spanishBridgeNote:
              'Natural, cálido y respetuoso: funciona para invitar a café, té con menta, jugo fresco o una velada en terraza.',
          rootLetters: 'ش-ر-ب',
        ),
        macronEmojis: '🥰🍵🌟',
        macronProp: 'teacup',
      ),
      ComicPanelData(
        id: 'ch8_p4',
        backdrop: SceneBackdropType.rooftopLounge,
        speaker: CharacterId.yasmin,
        presentCharacters: [
          CharacterId.tlatoani,
          CharacterId.covi,
          CharacterId.yasmin,
          CharacterId.macron,
        ],
        tlatoaniEmotion: EmotionState.happy,
        coviEmotion: EmotionState.excited,
        heroineEmotion: EmotionState.happy,
        dialogueText:
            'أَكِيد! بِكُلّ سُرُور يَا تْلَاتُوَانِي! — "¡Akīd! ¡Con muchísimo gusto, Tlatoāni! Vamos por un té con menta fresca y limonada con azahar."',
        dialogueTranslation:
            'Akīd! With great pleasure, Tlatoāni! Let\'s go have fresh mint tea and orange-blossom lemonade.',
        spokenAudioText: 'أَكِيد! بِكُلّ سُرُور يَا تْلَاتُوَانِي! يَلَّا نِشْرَب شَاي بِالنَّعْنَاع.',
        spokenLocale: 'ar-LB',
        macronEmojis: '🥳🍋🌿',
        macronProp: 'teacup',
      ),
      ComicPanelData(
        id: 'ch8_p5',
        backdrop: SceneBackdropType.rooftopLounge,
        speaker: CharacterId.tlatoani,
        presentCharacters: [
          CharacterId.tlatoani,
          CharacterId.covi,
          CharacterId.yasmin,
          CharacterId.macron,
        ],
        tlatoaniEmotion: EmotionState.happy,
        coviEmotion: EmotionState.happy,
        heroineEmotion: EmotionState.happy,
        dialogueText:
            'وَالحِسَاب عَلَيَّ! (¡Y la cuenta corre por mi cuenta: ‘Alayya!). Próxima parada de nuestra aventura: ¡El Cairo con Laylā!',
        dialogueTranslation:
            'Wa l-ḥisāb ‘alayya! (And the tab is on me: ‘Alayya!). Next stop on our adventure: Cairo with Laylā!',
        spokenAudioText:
            '¡Wa l-ḥisāb ‘alayya! La invitación corre por mi cuenta.',
        spokenLocale: 'es-MX',
        arabicSpotlight: ArabicWordToken(
          arabic: 'عَلَيَّ!',
          unvocalized: 'علي',
          transliteration: '‘Alayya!',
          spanishMeaning: '¡Corre por mi cuenta! / ¡Yo invito!',
          englishMeaning: 'It’s on me!',
          spanishBridgeNote:
              'Un gesto esencial de cortesía árabe al invitar a alguien a salir.',
        ),
        macronEmojis: '✨🥂🌙',
        macronProp: 'lantern',
        culturalNote:
            'Decir "¡‘Alayya!" (corre por mi cuenta) con una sonrisa sincera al invitar un café o bebida es una muestra clásica de generosidad (Karam) en todo Medio Oriente.',
      ),
    ],
    challenge: const MasteryChallengeData(
      promptEs:
          'Estás en la terraza iluminada de Beirut con Yāsmīn. ¿Cómo la invitas con confianza y respeto a tomar algo juntos y dices que tú invitas?',
      promptEn:
          'You are on the starlit Beirut rooftop with Yāsmīn. How do you confidently and politely invite her to grab a drink together and say it is on you?',
      scenarioContext: 'Atardecer bajo las luces de la terraza con Yāsmīn.',
      traceLetter: _letterAyn,
      options: [
        MasteryOption(
          arabic: 'حَابَّة نِشْرَب شِي سَوَا؟ الحِسَاب عَلَيَّ!',
          transliteration: 'Ḥābbe nishrab shī sawa? El-ḥisāb ‘alayya!',
          meaningEs: '¿Te gustaría que tomemos algo juntos? ¡La cuenta va por mi cuenta!',
          meaningEn: 'Would you like us to grab a drink together? The bill is on me!',
          isCorrect: true,
          feedbackEs:
              '¡Increíble! Invitaste a Yāsmīn con un árabe natural, cálido y lleno de estilo. ¡Libro II completado!',
          feedbackEn:
              'Incredible! You invited Yāsmīn out in natural, warm, stylish Arabic. Book II completed!',
        ),
        MasteryOption(
          arabic: 'أَيْنَ مَحَطَّة الحَافِلَات؟',
          transliteration: 'Ayna maḥaṭṭat al-ḥāfilāt?',
          meaningEs: '¿Dónde está la estación de autobuses?',
          meaningEn: 'Where is the bus station?',
          isCorrect: false,
          feedbackEs:
              '¡Eso pregunta por la estación de autobuses en plena cita! Rebobinemos 2 paneles para recordar "Ḥābbe nishrab shī sawa?".',
          feedbackEn:
              'That asks where the bus station is in the middle of your date! Let\'s rewind 2 panels to review "Ḥābbe nishrab shī sawa?".',
        ),
        MasteryOption(
          arabic: 'المِخَدَّة وَالسُّكَّر',
          transliteration: 'Al-mikhadda wa s-sukkar',
          meaningEs: 'La almohada y el azúcar',
          meaningEn: 'The pillow and the sugar',
          isCorrect: false,
          feedbackEs:
              'Eso dice "la almohada y el azúcar". ¡Volvamos 2 paneles para practicar la invitación con Tlatoāni!',
          feedbackEn:
              'That says "the pillow and the sugar". Let\'s rewind 2 panels to practice the invitation with Tlatoāni!',
        ),
      ],
    ),
  ),
];
