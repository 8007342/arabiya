// @trace spec:arabiya, spec:character-canon, spec:curriculum-and-comics
import 'dart:ui';

import '../models/comic_models.dart';

const ArabicLetterLesson _kRootLetterShin = ArabicLetterLesson(
  letter: 'ش',
  nameArabic: 'شِين',
  nameTranslit: 'Shīn',
  forms: {
    'isolated': 'ش',
    'initial': 'شـ',
    'medial': 'ـشـ',
    'final': 'ـش',
  },
  isNonConnector: false,
  sunOrMoon: 'sun',
  spanishPhoneticTip:
      'Suena como "sh" suave (como en "show" o el andaluz "muchacho"). Letra Solar: asimila la L de al- (ash-shams).',
  englishPhoneticTip:
      'Sounds like "sh" in "shine". Sun letter: assimilates the "l" of al- into ash-.',
  exampleArabic: 'شَرِبَ / مَشْرُوب',
  exampleTranslit: 'shariba / mashrūb',
  exampleMeaningEsEn: 'beber / bebida • to drink / beverage',
  strokeWaypoints: [
    [
      Offset(0.84, 0.50),
      Offset(0.76, 0.62),
      Offset(0.68, 0.50),
      Offset(0.60, 0.62),
      Offset(0.52, 0.50),
      Offset(0.42, 0.72),
      Offset(0.24, 0.70),
      Offset(0.18, 0.54),
    ],
  ],
  dotOffsets: [
    Offset(0.74, 0.30),
    Offset(0.66, 0.24),
    Offset(0.58, 0.30),
  ],
);

const ArabicLetterLesson _kRootLetterKaf = ArabicLetterLesson(
  letter: 'ك',
  nameArabic: 'كَاف',
  nameTranslit: 'Kāf',
  forms: {
    'isolated': 'ك',
    'initial': 'كـ',
    'medial': 'ـكـ',
    'final': 'ـك',
  },
  isNonConnector: false,
  sunOrMoon: 'moon',
  spanishPhoneticTip:
      'Como la "c" en "casa" o "k" en "kilo". Letra Lunar: conserva el sonido L en al-kitāb.',
  englishPhoneticTip:
      'Like "k" in "kite". Moon letter: keeps the "l" sound in al-kitāb.',
  exampleArabic: 'كِتَاب / مَكْتَب',
  exampleTranslit: 'kitāb / maktab',
  exampleMeaningEsEn: 'libro / oficina • book / office',
  strokeWaypoints: [
    [
      Offset(0.75, 0.22),
      Offset(0.75, 0.66),
      Offset(0.45, 0.68),
      Offset(0.24, 0.62),
    ],
  ],
);

const ArabicLetterLesson _kCairoLetterJim = ArabicLetterLesson(
  letter: 'ج',
  nameArabic: 'جِيم',
  nameTranslit: 'Jīm / Gīm (Maṣrī)',
  forms: {
    'isolated': 'ج',
    'initial': 'جـ',
    'medial': 'ـجـ',
    'final': 'ـج',
  },
  isNonConnector: false,
  sunOrMoon: 'moon',
  spanishPhoneticTip:
      'En árabe estándar y Levante suena como "y/ll" o "j" inglesa, ¡pero en El Cairo suena como la "g" suave de "gato" (gamīl)!',
  englishPhoneticTip:
      'Standard Arabic pronounces it like "j" in "jam", but in Cairo & Egypt it becomes a hard "g" as in "gold" (gamīl)!',
  exampleArabic: 'جَمِيل',
  exampleTranslit: 'gamīl (Maṣrī) / jamīl (MSA)',
  exampleMeaningEsEn: 'hermoso / bello • beautiful / lovely',
  strokeWaypoints: [
    [
      Offset(0.32, 0.34),
      Offset(0.68, 0.34),
      Offset(0.46, 0.54),
      Offset(0.62, 0.76),
      Offset(0.34, 0.78),
    ],
  ],
  dotOffsets: [
    Offset(0.50, 0.64),
  ],
);

const ArabicLetterLesson _kCairoLetterQaf = ArabicLetterLesson(
  letter: 'ق',
  nameArabic: 'قَاف',
  nameTranslit: 'Qāf',
  forms: {
    'isolated': 'ق',
    'initial': 'قـ',
    'medial': 'ـقـ',
    'final': 'ـق',
  },
  isNonConnector: false,
  sunOrMoon: 'moon',
  spanishPhoneticTip:
      'En MSA es una "k" profunda desde la úvula; en El Cairo y Beirut se convierte en una pausa glotal suave (’ahwa), y en Dubái suena como "g" (gahwa).',
  englishPhoneticTip:
      'Deep uvular "q" in MSA; becomes a crisp glottal catch in Cairo/Beirut (’ahwa) and a warm "g" in Dubai (gahwa).',
  exampleArabic: 'قَهْوَة / دِلْوَقْتِي',
  exampleTranslit: 'qahwa / ’ahwa / dilwa’tī',
  exampleMeaningEsEn: 'café / ahora mismo • coffee / right now',
  strokeWaypoints: [
    [
      Offset(0.72, 0.46),
      Offset(0.62, 0.34),
      Offset(0.52, 0.48),
      Offset(0.64, 0.68),
      Offset(0.38, 0.72),
      Offset(0.24, 0.56),
    ],
  ],
  dotOffsets: [
    Offset(0.66, 0.22),
    Offset(0.56, 0.22),
  ],
);

const ArabicLetterLesson _kCinemaLetterHa = ArabicLetterLesson(
  letter: 'ح',
  nameArabic: 'حَاء',
  nameTranslit: 'Ḥā’',
  forms: {
    'isolated': 'ح',
    'initial': 'حـ',
    'medial': 'ـحـ',
    'final': 'ـح',
  },
  isNonConnector: false,
  sunOrMoon: 'moon',
  spanishPhoneticTip:
      'Suspiro cálido desde la garganta (como al empañar un espejo), sin raspar como la "j". Es la raíz de "ḥubb" (amor) y "tiḥibbī".',
  englishPhoneticTip:
      'A warm, breathy whisper from the throat (like fogging up glasses). Anchors words of warmth like "tiḥibbī" (would you like) and "ḥisāb".',
  exampleArabic: 'تِحِبِّي / حَاجَة',
  exampleTranslit: 'tiḥibbī / ḥāga',
  exampleMeaningEsEn: '¿te gustaría? / algo • would you like? / something',
  strokeWaypoints: [
    [
      Offset(0.32, 0.34),
      Offset(0.68, 0.34),
      Offset(0.46, 0.54),
      Offset(0.62, 0.76),
      Offset(0.34, 0.78),
    ],
  ],
);

const ArabicLetterLesson _kFinaleLetterNun = ArabicLetterLesson(
  letter: 'ن',
  nameArabic: 'نُون',
  nameTranslit: 'Nūn',
  forms: {
    'isolated': 'ن',
    'initial': 'نـ',
    'medial': 'ـنـ',
    'final': 'ـن',
  },
  isNonConnector: false,
  sunOrMoon: 'sun',
  spanishPhoneticTip:
      'Idéntica a la "n" española en "noche" o "Nūr". Letra Solar: une las voces en "naḥnu" (nosotros) y "nashra" (boletín).',
  englishPhoneticTip:
      'Just like English "n" in "noon". Sun letter: connects "Nūr", "naḥnu" (we), and "nashrat al-akhbār" (news broadcast).',
  exampleArabic: 'نَحْنُ / نُور',
  exampleTranslit: 'naḥnu / nūr',
  exampleMeaningEsEn: 'nosotros / luz • we / light',
  strokeWaypoints: [
    [
      Offset(0.74, 0.46),
      Offset(0.68, 0.70),
      Offset(0.46, 0.74),
      Offset(0.28, 0.50),
    ],
  ],
  dotOffsets: [
    Offset(0.52, 0.32),
  ],
);

final List<ComicChapterData> kBook3CairoChapters = [
  // ===========================================================================
  // CHAPTER 9: Sunset Felucca with Laylā — The Triconsonantal Root System
  // ===========================================================================
  ComicChapterData(
    id: 'ch9_nile_felucca',
    number: 9,
    bookNumber: 3,
    bookTitle: 'Book III — Cairo & Laylā: Roots, Switchboard & Media',
    regionName: 'Cairo, Egypt 🇪🇬',
    dialectBadge: 'Maṣrī (مَصْرِي) + MSA',
    heroine: CharacterId.layla,
    titleEs: 'Faluca al Atardecer y el Secreto de las Raíces',
    titleEn: 'Sunset Felucca & The Triconsonantal Root System',
    titleArabic: 'فَلُوكَة النِّيل وَسِرُّ الْجُذُور',
    subtitle:
        'Unlocking Arabic’s 3-consonant DNA (Jadhr جذر): ش-ر-ب • ك-ت-ب • ح-س-ب • ع-م-ل',
    lettersUnlocked: const [
      _kRootLetterShin,
      _kRootLetterKaf,
    ],
    vocabularyUnlocked: const [
      ArabicWordToken(
        arabic: 'جَذْر',
        unvocalized: 'جذر',
        transliteration: 'jadhr / gazr',
        spanishMeaning: 'raíz (el ADN de 3 consonantes)',
        englishMeaning: 'root (the 3-consonant word DNA)',
        spanishBridgeNote:
            'Casi toda palabra árabe nace de un esqueleto de 3 consonantes. ¡Si conoces la raíz, multiplicas tu vocabulario por diez!',
        rootLetters: 'ج-ذ-ر',
        dialectVariants: {
          'MSA': 'جَذْر (jadhr)',
          'Cairo': 'جَزْر (gazr)',
        },
      ),
      ArabicWordToken(
        arabic: 'شَرِبَ / أَشْرَب / مَشْرُوب',
        unvocalized: 'شرب / أشرب / مشروب',
        transliteration: 'shariba / ashrab / mashrūb',
        spanishMeaning: 'beber / yo bebo / bebida',
        englishMeaning: 'drank / I drink / beverage',
        spanishBridgeNote:
            'De la raíz ش-ر-ب (sh-r-b) viene también el español "jarabe" y "sorbete" (¡de sharāb!).',
        rootLetters: 'ش-ر-ب',
        dialectVariants: {
          'MSA': 'أَشْرَبُ (ashrabu)',
          'Cairo': 'بَشْرَب (bashrab)',
          'Beirut': 'بِشْرَب (bishrab)',
          'Dubai': 'أَشْرَب (ashrab)',
        },
      ),
      ArabicWordToken(
        arabic: 'كِتَاب / مَكْتَب / كَاتِب',
        unvocalized: 'كتاب / مكتب / كاتب',
        transliteration: 'kitāb / maktab / kātib',
        spanishMeaning: 'libro / oficina o escritorio / escritor',
        englishMeaning: 'book / office or desk / writer',
        spanishBridgeNote:
            'El prefijo "ma-" (مَـ) indica el lugar de la acción: ك-ت-ب (escribir) -> مَكْتَب (maktab = lugar donde se escribe / oficina).',
        rootLetters: 'ك-ت-ب',
        dialectVariants: {
          'MSA': 'كِتَاب / مَكْتَب / كَاتِب',
          'Cairo': 'كِتَاب / مَكْتَب / كَاتِب',
        },
      ),
      ArabicWordToken(
        arabic: 'حِسَاب',
        unvocalized: 'حساب',
        transliteration: 'ḥisāb',
        spanishMeaning: 'cuenta / cálculo',
        englishMeaning: 'bill / check / calculation',
        spanishBridgeNote:
            'De la raíz ح-س-ب (ḥ-s-b: contar/calcular); su primo con مَـ es مُحَاسِب (muḥāsib = contador).',
        rootLetters: 'ح-س-ب',
        dialectVariants: {
          'MSA': 'الْحِسَاب (al-ḥisāb)',
          'Cairo': 'الْحِسَاب (el-ḥisāb)',
        },
      ),
      ArabicWordToken(
        arabic: 'عَمَل / مَعْمَل',
        unvocalized: 'عمل / معمل',
        transliteration: '‘amal / ma‘mal',
        spanishMeaning: 'trabajo o acción / taller o estudio',
        englishMeaning: 'work or action / studio or lab',
        spanishBridgeNote:
            'Raíz ع-م-ل (‘-m-l: hacer/trabajar). Con el patrón de agente obtenemos عَامِل (‘āmil = trabajador).',
        rootLetters: 'ع-م-ل',
        dialectVariants: {
          'MSA': 'عَمَل (‘amal)',
          'Cairo': 'عَمَل / شُغْل (‘amal / shughl)',
        },
      ),
    ],
    panels: const [
      ComicPanelData(
        id: 'ch9_p1',
        backdrop: SceneBackdropType.nileFelucca,
        speaker: CharacterId.layla,
        presentCharacters: [
          CharacterId.layla,
          CharacterId.tlatoani,
          CharacterId.covi,
          CharacterId.macron,
        ],
        speakerEmotion: EmotionState.happy,
        tlatoaniEmotion: EmotionState.curious,
        coviEmotion: EmotionState.excited,
        heroineEmotion: EmotionState.happy,
        dialogueText:
            'يَا أَهْلًا بِيْكُمْ فِي الْقَاهِرَة! أَنَا لَيْلَى. النِّيل وَقْت الْغُرُوب هُوَ أَجْمَل مَكْتَب وَأَجْمَل سِينِمَا فِي الدُّنْيَا!',
        dialogueTranslation:
            'Welcome to Cairo! I’m Laylā. The Nile at sunset is the loveliest office and cinema in the world! • ¡Bienvenidos a El Cairo! Soy Laylā. ¡El Nilo al atardecer es la oficina y el cine más bellos del mundo!',
        spokenAudioText:
            'يَا أَهْلًا بِيْكُمْ فِي الْقَاهِرَة! أَنَا لَيْلَى. النِّيل وَقْت الْغُرُوب هُوَ أَجْمَل مَكْتَب وَأَجْمَل سِينِمَا فِي الدُّنْيَا!',
        spokenLocale: 'ar-EG',
        arabicSpotlight: ArabicWordToken(
          arabic: 'مَكْتَب',
          unvocalized: 'مكتب',
          transliteration: 'maktab',
          spanishMeaning: 'oficina / estudio / escritorio',
          englishMeaning: 'office / study / desk',
          spanishBridgeNote:
              'Viene de la raíz ك-ت-ب (k-t-b, escribir) + el prefijo de lugar مَـ (ma-).',
          rootLetters: 'ك-ت-ب',
        ),
        macronEmojis: '⛵🌅🎬✨',
        macronProp: 'clapboard',
        culturalNote:
            'A Nile felucca (فَلُوكَة) is a traditional wooden sailboat propelled by a tall lateen sail, catching the evening breeze through central Cairo.',
      ),
      ComicPanelData(
        id: 'ch9_p2',
        backdrop: SceneBackdropType.nileFelucca,
        speaker: CharacterId.tlatoani,
        presentCharacters: [
          CharacterId.tlatoani,
          CharacterId.layla,
          CharacterId.covi,
          CharacterId.macron,
        ],
        speakerEmotion: EmotionState.curious,
        tlatoaniEmotion: EmotionState.curious,
        coviEmotion: EmotionState.calm,
        heroineEmotion: EmotionState.happy,
        dialogueText:
            '¡Mucho gusto, Laylā! Escuché que dijiste «maktab» para oficina, y suena igualito a las consonantes de «kitāb» (كِتَاب, libro). ¿Es el mismo origen?',
        dialogueTranslation:
            'Lovely to meet you, Laylā! I heard you say "maktab" for office, and it shares the exact same consonants as "kitāb" (book). Do they come from the same root?',
        spokenAudioText:
            'Mucho gusto, Layla. Escuché que dijiste maktab para oficina, y suena igualito a las consonantes de kitab. ¿Es el mismo origen?',
        spokenLocale: 'es-MX',
        arabicSpotlight: ArabicWordToken(
          arabic: 'كِتَاب / مَكْتَب / كَاتِب',
          unvocalized: 'كتاب / مكتب / كاتب',
          transliteration: 'kitāb / maktab / kātib',
          spanishMeaning: 'libro / oficina / escritor (raíz ك-ت-ب)',
          englishMeaning: 'book / office / writer (root k-t-b)',
          spanishBridgeNote:
              '¡Exacto! Las 3 consonantes ك-ت-ب son el جَذْر (jadhr, raíz): كِتَاب (libro), مَكْتَب (oficina), كَاتِب (escritor/guionista).',
          rootLetters: 'ك-ت-ب',
        ),
        macronEmojis: '📖✍️🏛️💡',
        macronProp: 'magnifying_glass',
        culturalNote:
            'Arabic is built on the Triconsonantal Root System (الْجَذْر الثُّلَاثِي): three root consonants carry the core concept while vowel patterns (وَزْن wazn) create whole families of words.',
      ),
      ComicPanelData(
        id: 'ch9_p3',
        backdrop: SceneBackdropType.nileFelucca,
        speaker: CharacterId.layla,
        presentCharacters: [
          CharacterId.layla,
          CharacterId.tlatoani,
          CharacterId.covi,
          CharacterId.macron,
        ],
        speakerEmotion: EmotionState.excited,
        tlatoaniEmotion: EmotionState.happy,
        coviEmotion: EmotionState.curious,
        heroineEmotion: EmotionState.excited,
        dialogueText:
            'عَلَيْك نُور يَا تْلَاتُوَانِي! دَه سِرُّ الْجَذْر (ج-ذ-ر). خُذْ مَثَلًا جَذْر ش-ر-ب: شَرِبَ، أَشْرَب، وَمَشْرُوب!',
        dialogueTranslation:
            'Spot on, Tlatoāni! ("Light upon you!") That’s the secret of the Root (jadhr). Take the root ش-ر-ب (sh-r-b): shariba (drank), ashrab (I drink), and mashrūb (a drink/beverage)!',
        spokenAudioText:
            'عَلَيْك نُور يَا تْلَاتُوَانِي! دَه سِرُّ الْجَذْر. خُذْ مَثَلًا جَذْر شِين رَاء بَاء: شَرِبَ، أَشْرَب، وَمَشْرُوب!',
        spokenLocale: 'ar-EG',
        arabicSpotlight: ArabicWordToken(
          arabic: 'شَرِبَ / أَشْرَب / مَشْرُوب',
          unvocalized: 'شرب / أشرب / مشروب',
          transliteration: 'shariba / ashrab / mashrūb',
          spanishMeaning: 'bebió / yo bebo / bebida (raíz ش-ر-ب)',
          englishMeaning: 'drank / I drink / beverage (root sh-r-b)',
          spanishBridgeNote:
              'Del árabe شَرَاب (sharāb, bebida dulce) nació nuestra palabra en español «jarabe» y «sorbete».',
          rootLetters: 'ش-ر-ب',
        ),
        macronEmojis: '🍹🧬🌱✨',
        macronProp: 'teacup',
        culturalNote:
            'In Egyptian Arabic, "‘Alayk nūr!" (عَلَيْك نُور — literally "Light upon you!") is an affectionate, enthusiastic way to say "Bingo! You nailed it!"',
      ),
      ComicPanelData(
        id: 'ch9_p4',
        backdrop: SceneBackdropType.nileFelucca,
        speaker: CharacterId.covi,
        presentCharacters: [
          CharacterId.covi,
          CharacterId.layla,
          CharacterId.tlatoani,
          CharacterId.macron,
        ],
        speakerEmotion: EmotionState.excited,
        tlatoaniEmotion: EmotionState.happy,
        coviEmotion: EmotionState.excited,
        heroineEmotion: EmotionState.happy,
        dialogueText:
            'Whoa, it’s like a secret decoder ring! So "ḥisāb" (حِسَاب, bill) comes from ḥ-s-b (ح-س-ب, to count), and "‘amal" (عَمَل, work/film production) comes from ‘-m-l (ع-م-ل, to do)!',
        dialogueTranslation:
            '¡Guau, es como un anillo decodificador secreto! Así que «ḥisāb» (حِسَاب, cuenta) viene de ح-س-ب (contar), ¡y «‘amal» (عَمَل, trabajo/obra) viene de ع-م-ل (hacer)!',
        spokenAudioText:
            'Whoa, it is like a secret decoder ring! So hisab comes from ha-sin-ba, to count, and amal comes from ayn-mim-lam, to do!',
        spokenLocale: 'en-US',
        arabicSpotlight: ArabicWordToken(
          arabic: 'حِسَاب • عَمَل',
          unvocalized: 'حساب • عمل',
          transliteration: 'ḥisāb (ḥ-s-b) • ‘amal (‘-m-l)',
          spanishMeaning: 'cuenta (ح-س-ب) • trabajo/hacer (ع-م-ل)',
          englishMeaning: 'bill/calculation (ḥ-s-b) • work/action (‘-m-l)',
          spanishBridgeNote:
              'Cuando ves subtítulos sin vocales como عمل o حساب, reconocer las 3 consonantes raíz te revela el significado al instante.',
          rootLetters: 'ح-س-ب / ع-م-ل',
        ),
        macronEmojis: '🧾🧮🎬🔓',
        macronProp: 'abacus',
        culturalNote:
            'Understanding roots lets you read unvocalized Arabic media: even without short vowels, the 3 root letters + prefix/suffix pattern make the meaning unmistakable.',
      ),
      ComicPanelData(
        id: 'ch9_p5',
        backdrop: SceneBackdropType.nileFelucca,
        speaker: CharacterId.tlatoani,
        presentCharacters: [
          CharacterId.tlatoani,
          CharacterId.layla,
          CharacterId.covi,
          CharacterId.macron,
        ],
        speakerEmotion: EmotionState.blushing,
        tlatoaniEmotion: EmotionState.blushing,
        coviEmotion: EmotionState.teasing,
        heroineEmotion: EmotionState.happy,
        dialogueText:
            'Con razón el árabe es tan poético, Laylā... En español decimos «jarabe» gracias a la raíz ش-ر-ب, y ver cómo explicas cada «جَذْر» bajo las velas del Nilo es una obra de arte.',
        dialogueTranslation:
            'No wonder Arabic is so poetic, Laylā... In Spanish we say "jarabe" thanks to the root sh-r-b, and watching you explain every "jadhr" beneath the Nile sails is a work of art.',
        spokenAudioText:
            'Con razón el árabe es tan poético, Layla. En español decimos jarabe gracias a la raíz shin-ra-ba, y ver cómo explicas cada jadhr bajo las velas del Nilo es una obra de arte.',
        spokenLocale: 'es-MX',
        arabicSpotlight: ArabicWordToken(
          arabic: 'عَلَيْك نُور',
          unvocalized: 'عليك نور',
          transliteration: '‘alayk nūr',
          spanishMeaning: '¡brillante! / ¡diste en el clavo! (lit. luz sobre ti)',
          englishMeaning: 'spot on! / brilliant! (lit. light upon you)',
          spanishBridgeNote:
              'Un cumplido egipcio lleno de calidez para celebrar el ingenio de alguien.',
          rootLetters: 'ن-و-ر',
        ),
        macronEmojis: '😳🌸⛵🌅',
        macronProp: 'compass',
        culturalNote:
            'Tlatoāni’s feathery coral gills flush rose-pink whenever Laylā smiles and adjusts her terracotta-and-gold Cairene scarf.',
      ),
    ],
    challenge: const MasteryChallengeData(
      promptEs:
          'Laylā señala tres palabras en su libreta de rodaje: «شَرِبَ» (bebió), «أَشْرَب» (bebo) y «مَشْرُوب» (bebida). ¿Cuál es la raíz triconsonántica (جَذْر) que comparten y qué palabra significa «bebida»?',
      promptEn:
          'Laylā points to three words in her film notebook: "shariba" (drank), "ashrab" (I drink), and "mashrūb" (beverage). Which 3-consonant root (jadhr) do they share, and which word means "beverage"?',
      scenarioContext:
          'Trace the letter Shīn (ش) from right to left, then unlock the Triconsonantal Root on the Nile felucca.',
      traceLetter: _kRootLetterShin,
      options: [
        MasteryOption(
          arabic: 'جَذْر: ش-ر-ب • مَشْرُوب (mashrūb)',
          transliteration: 'Jadhr: sh-r-b • mashrūb',
          meaningEs: 'Raíz ش-ر-ب (beber; origen de «jarabe») -> مَشْرُوب (bebida)',
          meaningEn: 'Root sh-r-b (to drink; origin of "syrup/sherbet") -> mashrūb (beverage)',
          isCorrect: true,
          feedbackEs:
              '¡عَلَيْك نُور (‘Alayk nūr)! Las consonantes ش-ر-ب forman la raíz de beber, y el patrón مَفْعُول (mashrūb) nombra la bebida.',
          feedbackEn:
              '‘Alayk nūr! The consonants sh-r-b form the drinking root, and the pattern maf‘ūl gives us mashrūb (beverage)!',
        ),
        MasteryOption(
          arabic: 'جَذْر: ك-ت-ب • مَكْتَب (maktab)',
          transliteration: 'Jadhr: k-t-b • maktab',
          meaningEs: 'Raíz ك-ت-ب (escribir) -> مَكْتَب (oficina)',
          meaningEn: 'Root k-t-b (to write) -> maktab (office)',
          isCorrect: false,
          feedbackEs:
              'ك-ت-ب es la raíz de escribir (كِتَاب libro, مَكْتَب oficina). ¡Busca la raíz con ش-ر-ب!',
          feedbackEn:
              'k-t-b is the root for writing (kitāb book, maktab office). Look for the root with sh-r-b!',
        ),
        MasteryOption(
          arabic: 'جَذْر: ح-س-ب • حِسَاب (ḥisāb)',
          transliteration: 'Jadhr: ḥ-s-b • ḥisāb',
          meaningEs: 'Raíz ح-س-ب (calcular) -> حِسَاب (la cuenta)',
          meaningEn: 'Root ḥ-s-b (to calculate) -> ḥisāb (the bill)',
          isCorrect: false,
          feedbackEs:
              'ح-س-ب es la raíz de contar y pedir la cuenta (حِسَاب). ¡Revisa las consonantes de مَشْرُوب!',
          feedbackEn:
              'ḥ-s-b is the root for counting and the café bill (ḥisāb). Check the consonants in mashrūb!',
        ),
      ],
    ),
    xpReward: 200,
    affinityReward: 1,
  ),

  // ===========================================================================
  // CHAPTER 10: The Dialect Switchboard (Dubai • Beirut • Cairo)
  // ===========================================================================
  ComicChapterData(
    id: 'ch10_dialect_switchboard',
    number: 10,
    bookNumber: 3,
    bookTitle: 'Book III — Cairo & Laylā: Roots, Switchboard & Media',
    regionName: 'Cairo, Egypt 🇪🇬',
    dialectBadge: 'Maṣrī • Shāmī • Khalījī',
    heroine: CharacterId.layla,
    titleEs: 'El Conmutador de Dialectos: El Cairo, Beirut y Dubái',
    titleEn: 'The Dialect Switchboard: Cairo, Beirut & Dubai',
    titleArabic: 'لَوْحَة تَحْوِيل اللَّهَجَات: مَصْر وَالشَّام وَالْخَلِيج',
    subtitle:
        'Tuning your ear to Egyptian /g/ (جَمِيل gamīl), glottal ق (’ahwa), and comparing Dubai, Beirut & Cairo',
    lettersUnlocked: const [
      _kCairoLetterJim,
      _kCairoLetterQaf,
    ],
    vocabularyUnlocked: const [
      ArabicWordToken(
        arabic: 'جَمِيل',
        unvocalized: 'جميل',
        transliteration: 'gamīl (Cairo) / jamīl (MSA & Beirut)',
        spanishMeaning: 'hermoso / bello / genial',
        englishMeaning: 'beautiful / lovely / great',
        spanishBridgeNote:
            'En El Cairo, la letra ج (Jīm) siempre suena como la «g» suave de «gato» (Gīm): ¡جَمِيل se dice «gamīl»!',
        rootLetters: 'ج-م-ل',
        dialectVariants: {
          'MSA': 'جَمِيل (jamīl)',
          'Cairo': 'جَمِيل (gamīl — hard /g/)',
          'Beirut': 'جَمِيل / حِلُو (jamīl / ḥilū)',
          'Dubai': 'جَمِيل / زِين (jamīl / zēn)',
        },
      ),
      ArabicWordToken(
        arabic: 'قَهْوَة',
        unvocalized: 'قهوة',
        transliteration: '’ahwa (Cairo/Beirut) / gahwa (Dubai) / qahwa (MSA)',
        spanishMeaning: 'café',
        englishMeaning: 'coffee',
        spanishBridgeNote:
            'Una sola palabra escrita (قَهْوَة) te revela las 3 regiones al oído: «qahwa» (MSA), «gahwa» (Dubái con Nūr) y «’ahwa» (Beirut con Yāsmīn y El Cairo con Laylā).',
        rootLetters: 'ق-ه-و',
        dialectVariants: {
          'MSA': 'قَهْوَة (qahwa)',
          'Dubai': 'قَهْوَة (gahwa)',
          'Beirut': 'قَهْوَة (’ahwa)',
          'Cairo': 'قَهْوَة (’ahwa)',
        },
      ),
      ArabicWordToken(
        arabic: 'إِزَّيِّك / كِيفِك / شْلُونِج',
        unvocalized: 'إزيك / كيفك / شلونج',
        transliteration: 'Izzayyik (EG) / Kīfik (LB) / Shlōnik (AE)',
        spanishMeaning: '¿cómo estás? (a una mujer)',
        englishMeaning: 'how are you? (to a woman)',
        spanishBridgeNote:
            'Para hablar con un hombre cambia la vocal final a «-ak»: Izzayyak (مَصْرِي), Kīfak (شَامِي), Shlōnak (خَلِيجِي).',
        dialectVariants: {
          'MSA': 'كَيْفَ حَالُكِ؟ (Kayfa ḥāluki?)',
          'Cairo': 'إِزَّيِّك؟ (Izzayyik?)',
          'Beirut': 'كِيفِك؟ (Kīfik?)',
          'Dubai': 'شْلُونِك / شْلُونِج؟ (Shlōnik / Shlōnij?)',
        },
      ),
      ArabicWordToken(
        arabic: 'عَايْزَة / بَدِّي / أَبْغِي',
        unvocalized: 'عايزة / بدي / أبغي',
        transliteration: '‘Āyza (EG) / Baddī (LB) / Abghī (AE)',
        spanishMeaning: 'quiero / me gustaría',
        englishMeaning: 'I want / I would like',
        spanishBridgeNote:
            'En egipcio, un hombre dice «‘āyiz» (عَايِز) y una mujer dice «‘āyza» (عَايْزَة). En los subtítulos MSA siempre verás «أُرِيدُ» (urīdu).',
        rootLetters: 'ع-و-ز / ر-و-د',
        dialectVariants: {
          'MSA': 'أُرِيدُ (urīdu)',
          'Cairo': 'عَايِز / عَايْزَة (‘āyiz / ‘āyza)',
          'Beirut': 'بَدِّي (baddī)',
          'Dubai': 'أَبْغِي (abghī)',
        },
      ),
      ArabicWordToken(
        arabic: 'إِيه؟ / شُو؟ / مَاذَا؟',
        unvocalized: 'إيه / شو / ماذا',
        transliteration: 'Ēh? (EG) / Shū? (LB/AE) / Mādhā? (MSA)',
        spanishMeaning: '¿qué?',
        englishMeaning: 'what?',
        spanishBridgeNote:
            'En El Cairo «إِيه؟» (ēh?) suele ir al final de la frase: «تِشْرَب إِيه؟» (¿qué tomas?).',
        dialectVariants: {
          'MSA': 'مَاذَا؟ (mādhā?)',
          'Cairo': 'إِيه؟ (ēh?)',
          'Beirut': 'شُو؟ (shū?)',
          'Dubai': 'شُو / شِنُو؟ (shū / shinū?)',
        },
      ),
    ],
    panels: const [
      ComicPanelData(
        id: 'ch10_p1',
        backdrop: SceneBackdropType.nileFelucca,
        speaker: CharacterId.layla,
        presentCharacters: [
          CharacterId.layla,
          CharacterId.tlatoani,
          CharacterId.covi,
          CharacterId.macron,
        ],
        speakerEmotion: EmotionState.happy,
        tlatoaniEmotion: EmotionState.curious,
        coviEmotion: EmotionState.curious,
        heroineEmotion: EmotionState.happy,
        dialogueText:
            'إِزَّيُّكُمْ يَا شَبَاب! سَمِعْت إِنُّكُمْ زُرْتُوا نُور فِي دُبَيّ وَيَاسْمِين فِي بَيْرُوت. تَعَالُوا نِفْتَح «لَوْحَة تَحْوِيل اللَّهَجَات» المَصْرِيَّة!',
        dialogueTranslation:
            'How are you doing, guys! I heard you visited Nūr in Dubai and Yāsmīn in Beirut. Come on, let’s open the Egyptian "Dialect Switchboard"! • ¡¿Cómo están, chicos?! Escuché que visitaron a Nūr en Dubái y a Yāsmīn en Beirut.',
        spokenAudioText:
            'إِزَّيُّكُمْ يَا شَبَاب! سَمِعْت إِنُّكُمْ زُرْتُوا نُور فِي دُبَيّ وَيَاسْمِين فِي بَيْرُوت. تَعَالُوا نِفْتَح لَوْحَة تَحْوِيل اللَّهَجَات المَصْرِيَّة!',
        spokenLocale: 'ar-EG',
        arabicSpotlight: ArabicWordToken(
          arabic: 'إِزَّيِّك / إِزَّيَّك',
          unvocalized: 'إزيك',
          transliteration: 'izzayyik (f) / izzayyak (m)',
          spanishMeaning: '¿cómo estás? (en árabe egipcio)',
          englishMeaning: 'how are you? (in Egyptian Arabic)',
          spanishBridgeNote:
              'Equivale al «Shlōnik» de Nūr en Dubái y al «Kīfik» de Yāsmīn en Beirut.',
        ),
        macronEmojis: '🎛️🇪🇬🇱🇧🇦🇪',
        macronProp: 'radio_tuner',
        culturalNote:
            'Because Cairo has been the heart of Arab cinema and music for a century, nearly every Arabic speaker from Casablanca to Dubai understands Egyptian Arabic (Maṣrī) effortlessly.',
      ),
      ComicPanelData(
        id: 'ch10_p2',
        backdrop: SceneBackdropType.nileFelucca,
        speaker: CharacterId.covi,
        presentCharacters: [
          CharacterId.covi,
          CharacterId.layla,
          CharacterId.tlatoani,
          CharacterId.macron,
        ],
        speakerEmotion: EmotionState.curious,
        tlatoaniEmotion: EmotionState.thinking,
        coviEmotion: EmotionState.curious,
        heroineEmotion: EmotionState.happy,
        dialogueText:
            'Wait—my ears just picked up two cosmic plot twists! In Cairo, you pronounce ج (Jīm) like a hard "g" in "gold" so جَمِيل is "gamīl", and ق (Qāf) in قَهْوَة becomes a glottal stop "’ahwa"!',
        dialogueTranslation:
            '¡Espera, mis oídos acaban de captar dos giros cósmicos! En El Cairo pronuncian la ج (Jīm) como «g» suave de «gato» («gamīl»), ¡y la ق (Qāf) en قَهْوَة se vuelve una pausa glotal «’ahwa»!',
        spokenAudioText:
            'Wait—my ears just picked up two cosmic plot twists! In Cairo, you pronounce Jim like a hard g in gold so jamil is gamil, and Qaf in qahwa becomes a glottal stop ahwa!',
        spokenLocale: 'en-US',
        arabicSpotlight: ArabicWordToken(
          arabic: 'جَمِيل • قَهْوَة',
          unvocalized: 'جميل • قهوة',
          transliteration: 'gamīl (hard /g/) • ’ahwa (glottal ق)',
          spanishMeaning: 'hermoso (gamīl) • café (’ahwa)',
          englishMeaning: 'beautiful (gamīl) • coffee (’ahwa)',
          spanishBridgeNote:
              'La misma palabra escrita قَهْوَة suena «gahwa» en Dubái, «’ahwa» en Beirut/El Cairo y «qahwa» en noticias MSA.',
          rootLetters: 'ج-م-ل / ق-ه-و',
        ),
        macronEmojis: '👂☕🎶✨',
        macronProp: 'headphones',
        culturalNote:
            'The Cairene Gīm (ج = /g/) is the single most recognizable hallmark of Egyptian Arabic. When you hear "gamīl" (beautiful) or "gāmi‘a" (university), you know immediately you’re listening to Egypt.',
      ),
      ComicPanelData(
        id: 'ch10_p3',
        backdrop: SceneBackdropType.nileFelucca,
        speaker: CharacterId.layla,
        presentCharacters: [
          CharacterId.layla,
          CharacterId.tlatoani,
          CharacterId.covi,
          CharacterId.macron,
        ],
        speakerEmotion: EmotionState.excited,
        tlatoaniEmotion: EmotionState.happy,
        coviEmotion: EmotionState.happy,
        heroineEmotion: EmotionState.excited,
        dialogueText:
            'بِالظَّبْط يَا كُوفِي! فِي دُبَيّ نُور بِتْقُول «أَبْغِي قَهْوَة وَشْلُونِك؟»، وَفِي بَيْرُوت يَاسْمِين بِتْقُول «بَدِّي قَهْوَة، كِيفِك وَشُو؟»، وَفِي الْقَاهِرَة أَنَا بَقُول «عَايْزَة قَهْوَة، إِزَّيَّك وَإِيه؟»!',
        dialogueTranslation:
            'Exactly, Covi! In Dubai Nūr says "Abghī gahwa & Shlōnik?", in Beirut Yāsmīn says "Baddī ’ahwa, Kīfik & Shū?", and here in Cairo I say "‘Āyza ’ahwa, Izzayyak & Ēh?"!',
        spokenAudioText:
            'بِالظَّبْط يَا كُوفِي! فِي دُبَيّ نُور بِتْقُول أَبْغِي قَهْوَة وَشْلُونِك، وَفِي بَيْرُوت يَاسْمِين بِتْقُول بَدِّي قَهْوَة، كِيفِك وَشُو، وَفِي الْقَاهِرَة أَنَا بَقُول عَايْزَة قَهْوَة، إِزَّيَّك وَإِيه!',
        spokenLocale: 'ar-EG',
        arabicSpotlight: ArabicWordToken(
          arabic: 'عَايْزَة / بَدِّي / أَبْغِي',
          unvocalized: 'عايزة / بدي / أبغي',
          transliteration: '‘Āyza (Cairo) • Baddī (Beirut) • Abghī (Dubai)',
          spanishMeaning: 'Yo quiero (El Cairo / Beirut / Dubái)',
          englishMeaning: 'I want (Cairo / Beirut / Dubai)',
          spanishBridgeNote:
              'Tres dialectos hermanos, una misma hospitalidad. Y un hablante masculino en El Cairo dice «عَايِز» (‘āyiz).',
        ),
        macronEmojis: '🗺️🔄☕🌟',
        macronProp: 'compass',
        culturalNote:
            'Notice how Egyptian puts question words like إِيه (ēh — what?) at the end of the phrase: "Tishrab ēh?" (What would you like to drink?).',
      ),
      ComicPanelData(
        id: 'ch10_p4',
        backdrop: SceneBackdropType.nileFelucca,
        speaker: CharacterId.tlatoani,
        presentCharacters: [
          CharacterId.tlatoani,
          CharacterId.layla,
          CharacterId.covi,
          CharacterId.macron,
        ],
        speakerEmotion: EmotionState.happy,
        tlatoaniEmotion: EmotionState.happy,
        coviEmotion: EmotionState.calm,
        heroineEmotion: EmotionState.happy,
        dialogueText:
            '¡Es como escuchar el español de Ciudad de México, Madrid y Buenos Aires! La escritura nos une y cada acento tiene su encanto... Entonces yo, como chico, digo «أَنَا عَايِز قَهْوَة، إِزَّيِّك يَا لَيْلَى؟».',
        dialogueTranslation:
            'It’s just like hearing Spanish across Mexico City, Madrid, and Buenos Aires! The script unites everyone while each accent brings its own charm... So as a guy, I say: "Ana ‘āyiz ’ahwa, izzayyik yā Laylā?"',
        spokenAudioText:
            'Es como escuchar el español de Ciudad de México, Madrid y Buenos Aires. La escritura nos une y cada acento tiene su encanto. Entonces yo digo: Ana ayiz ahwa, izzayyik ya Layla.',
        spokenLocale: 'es-MX',
        arabicSpotlight: ArabicWordToken(
          arabic: 'أَنَا عَايِز قَهْوَة، إِزَّيِّك يَا لَيْلَى؟',
          unvocalized: 'أنا عايز قهوة، إزيك يا ليلى؟',
          transliteration: 'Ana ‘āyiz ’ahwa, izzayyik yā Laylā?',
          spanishMeaning: 'Quiero un café, ¿cómo estás, Laylā?',
          englishMeaning: 'I’d like a coffee, how are you, Laylā?',
          spanishBridgeNote:
              'عَايِز (‘āyiz, masculino) vs عَايْزَة (‘āyza, femenino); إِزَّيِّك (izzayyik, a una mujer).',
        ),
        macronEmojis: '🇲🇽🇪🇸🇦🇷🤝',
        macronProp: 'microphone',
        culturalNote:
            'Comparing Arabic dialect variation to Spanish across Mexico, Spain, and Argentina demystifies diglossia immediately for Spanish/English learners.',
      ),
      ComicPanelData(
        id: 'ch10_p5',
        backdrop: SceneBackdropType.nileFelucca,
        speaker: CharacterId.covi,
        presentCharacters: [
          CharacterId.covi,
          CharacterId.tlatoani,
          CharacterId.layla,
          CharacterId.macron,
        ],
        speakerEmotion: EmotionState.teasing,
        tlatoaniEmotion: EmotionState.blushing,
        coviEmotion: EmotionState.teasing,
        heroineEmotion: EmotionState.happy,
        dialogueText:
            'Hehehe, look at Tlatoāni switching effortlessly from Dubai "Shlōnik" to Beirut "Kīfik" to Cairo "Izzayyik" while his gills turn sunset-coral in every time zone!',
        dialogueTranslation:
            '¡Jejeje, miren a Tlatoāni cambiando sin esfuerzo del «Shlōnik» de Dubái al «Kīfik» de Beirut y al «Izzayyik» de El Cairo mientras sus branquias se ponen color coral en cada huso horario!',
        spokenAudioText:
            'Hehehe, look at Tlatoani switching effortlessly from Dubai Shlonik to Beirut Kifik to Cairo Izzayyik while his gills turn sunset-coral in every time zone!',
        spokenLocale: 'en-US',
        arabicSpotlight: ArabicWordToken(
          arabic: 'جَمِيل قَوِي!',
          unvocalized: 'جميل قوي!',
          transliteration: 'Gamīl ’awī!',
          spanishMeaning: '¡Muy hermoso! / ¡Increíblemente lindo! (en egipcio)',
          englishMeaning: 'So lovely! / Very beautiful! (in Egyptian)',
          spanishBridgeNote:
              'En El Cairo, «قَوِي» (’awī) significa «muy / muchísimo».',
          rootLetters: 'ج-م-ل',
        ),
        macronEmojis: '😏🌸📡💖',
        macronProp: 'camera',
        culturalNote:
            'In Egyptian Arabic, قَوِي (pronounced ’awī with a glottal stop) is the everyday word for "very" — so "Gamīl ’awī!" means "So beautiful!"',
      ),
    ],
    challenge: const MasteryChallengeData(
      promptEs:
          '¡Activa el Conmutador de Dialectos! ¿Cómo se pronuncia «جَمِيل» en El Cairo y cómo dice Laylā «¿Cómo estás? / Yo quiero / ¿Qué?» en árabe egipcio (Maṣrī)?',
      promptEn:
          'Activate the Dialect Switchboard! How is "جميل" pronounced in Cairo, and how does Laylā say "How are you? / I want / What?" in Egyptian Arabic (Maṣrī)?',
      scenarioContext:
          'Trace the letter Jīm/Gīm (ج) from right to left, then select the Cairo (Maṣrī) dialect switchboard combination.',
      traceLetter: _kCairoLetterJim,
      options: [
        MasteryOption(
          arabic: 'جَمِيل (gamīl) • إِزَّيِّك / عَايْزَة / إِيه؟',
          transliteration: 'gamīl (/g/) • Izzayyik / ‘Āyza / Ēh?',
          meaningEs: 'El Cairo (Maṣrī): /g/ en gamīl • Izzayyik • ‘Āyza • Ēh?',
          meaningEn: 'Cairo (Maṣrī): hard /g/ in gamīl • Izzayyik • ‘Āyza • Ēh?',
          isCorrect: true,
          feedbackEs:
              '¡Gamīl ’awī! En El Cairo la ج suena /g/ (gamīl) y decimos «Izzayyik / ‘Āyiz–‘Āyza / Ēh?».',
          feedbackEn:
              'Gamīl ’awī! In Cairo ج is pronounced with a hard /g/ (gamīl) and we say "Izzayyik / ‘Āyiz–‘Āyza / Ēh?".',
        ),
        MasteryOption(
          arabic: 'جَمِيل (jamīl) • كِيفِك / بَدِّي / شُو؟',
          transliteration: 'jamīl • Kīfik / Baddī / Shū?',
          meaningEs: 'Beirut (Shāmī): Kīfik • Baddī • Shū?',
          meaningEn: 'Beirut (Shāmī): Kīfik • Baddī • Shū?',
          isCorrect: false,
          feedbackEs:
              '¡Ese es el encantador dialecto levantino (Shāmī) de Yāsmīn en Beirut! Busca la opción de El Cairo (Maṣrī).',
          feedbackEn:
              'That’s Yāsmīn’s charming Levantine (Shāmī) dialect from Beirut! Pick the Cairo (Maṣrī) switchboard option.',
        ),
        MasteryOption(
          arabic: 'جَمِيل (jamīl) • شْلُونِك / أَبْغِي / شُو؟',
          transliteration: 'jamīl • Shlōnik / Abghī / Shū?',
          meaningEs: 'Dubái (Khalījī): Shlōnik • Abghī • Gahwa',
          meaningEn: 'Dubai (Khalījī): Shlōnik • Abghī • Gahwa',
          isCorrect: false,
          feedbackEs:
              '¡Ese es el elegante dialecto del Golfo (Khalījī) de Nūr en Dubái! Elige la fila egipcia de Laylā.',
          feedbackEn:
              'That’s Nūr’s poised Gulf (Khalījī) dialect from Dubai! Choose Laylā’s Egyptian row.',
        ),
      ],
    ),
    xpReward: 220,
    affinityReward: 1,
  ),

  // ===========================================================================
  // CHAPTER 11: Karkadēh & Indie Cinema Date in Zamalek + Subtitle Bridges
  // ===========================================================================
  ComicChapterData(
    id: 'ch11_cairo_cinema_date',
    number: 11,
    bookNumber: 3,
    bookTitle: 'Book III — Cairo & Laylā: Roots, Switchboard & Media',
    regionName: 'Zamalek, Cairo 🇪🇬',
    dialectBadge: 'Maṣrī Courtship + MSA Subtitles',
    heroine: CharacterId.layla,
    titleEs: 'Karkadēh, Cine Independiente en Zamalek y Subtítulos',
    titleEn: 'Karkadēh, Indie Cinema in Zamalek & Subtitle Bridges',
    titleArabic: 'كَرْكَدِيه وَسِينِمَا الزَّمَالِك وَجُسُور التَّرْجَمَة',
    subtitle:
        'Inviting Laylā out ("Tiḥibbī nishrab ḥāga sawa?") & mastering MSA-to-Dialect Subtitle Bridges',
    lettersUnlocked: const [
      _kCinemaLetterHa,
    ],
    vocabularyUnlocked: const [
      ArabicWordToken(
        arabic: 'كَرْكَدِيه',
        unvocalized: 'كركديه',
        transliteration: 'karkadēh',
        spanishMeaning: 'flor de jamaica / té de hibisco rubí',
        englishMeaning: 'hibiscus flower tea (chilled or hot)',
        spanishBridgeNote:
            '¡En México lo llamamos «agua de jamaica» y en Egipto «karkadēh»! Un puente cultural directo entre Tlatoāni y Laylā.',
        dialectVariants: {
          'MSA': 'كَرْكَدِيه (karkadēh)',
          'Cairo': 'كَرْكَدِيه سَاقِع (chilled karkadēh)',
        },
      ),
      ArabicWordToken(
        arabic: 'تِحِبِّي نِشْرَب حَاجَة سَوَا؟',
        unvocalized: 'تحبي نشرب حاجة سوا؟',
        transliteration: 'Tiḥibbī nishrab ḥāga sawa?',
        spanishMeaning: '¿Te gustaría que tomemos algo juntos?',
        englishMeaning: 'Would you like to grab a drink together?',
        spanishBridgeNote:
            'La invitación más cálida y natural en El Cairo: تِحِبِّي (¿te gustaría?), نِشْرَب (tomamos, raíz ش-ر-ب), حَاجَة (algo), سَوَا (juntos).',
        rootLetters: 'ح-ب-ب / ش-ر-ب',
        dialectVariants: {
          'MSA': 'هَلْ تُحِبِّينَ أَنْ نَشْرَبَ شَيْئًا مَعًا؟',
          'Cairo': 'تِحِبِّي نِشْرَب حَاجَة سَوَا؟ (Tiḥibbī nishrab ḥāga sawa?)',
          'Beirut': 'حَابِّة نِشْرَب شِي سَوَا؟ (Ḥābbe nishrab shī sawa?)',
        },
      ),
      ArabicWordToken(
        arabic: 'مَبْسُوط إِنِّي شُفْتِك الْيُوم',
        unvocalized: 'مبسوط إني شفتك اليوم',
        transliteration: 'Mabsūṭ innī shuftik el-yōm',
        spanishMeaning: 'Estoy muy feliz de haberte visto hoy',
        englishMeaning: 'I’m really happy I saw you today',
        spanishBridgeNote:
            'مَبْسُوط (mabsūṭ = feliz/contento, o مَبْسُوطَة mabsūṭa si habla una mujer); شُفْتِك (shuftik = te vi).',
        rootLetters: 'ب-س-ط / ش-و-ف',
        dialectVariants: {
          'MSA': 'أَنَا سَعِيدٌ بِرُؤْيَتِكِ الْيَوْمَ',
          'Cairo': 'مَبْسُوط إِنِّي شُفْتِك النَّهَارْدَة / الْيُوم',
        },
      ),
      ArabicWordToken(
        arabic: 'أُرِيدُ ↔ بَدِّي / عَايِز / أَبْغِي',
        unvocalized: 'أريد ↔ بدي / عايز / أبغي',
        transliteration: 'urīdu (MSA) <-> baddī / ‘āyiz / abghī',
        spanishMeaning: 'quiero (Puente de Subtítulos MSA <-> Hablado)',
        englishMeaning: 'I want (MSA Subtitle <-> Spoken Dialect Bridge)',
        spanishBridgeNote:
            'En el cine y YouTube, el actor dice «‘āyiz» o «baddī», pero el subtítulo árabe escribe siempre «أُرِيدُ» (urīdu).',
        rootLetters: 'ر-و-د',
      ),
      ArabicWordToken(
        arabic: 'مَاذَا ↔ شُو / إِيه • الْآنَ ↔ هَلَّق / دِلْوَقْتِي / الْحِين • هُنَا ↔ هُون / هِنَا',
        unvocalized: 'ماذا ↔ شو / إيه • الآن ↔ هلق / دلوقتي / الحين • هنا ↔ هون / هنا',
        transliteration:
            'mādhā <-> shū/ēh • al-āna <-> halla’/dilwa’tī/al-ḥīn • hunā <-> hōn/hēna',
        spanishMeaning: 'qué • ahora • aquí (Puentes de Subtítulos)',
        englishMeaning: 'what • now • here (Subtitle Bridges)',
        spanishBridgeNote:
            'Dominar estos 4 puentes (أريد، ماذا، الآن، هنا) te permite seguir cualquier película árabe con subtítulos MSA.',
      ),
    ],
    panels: const [
      ComicPanelData(
        id: 'ch11_p1',
        backdrop: SceneBackdropType.cairoCinema,
        speaker: CharacterId.tlatoani,
        presentCharacters: [
          CharacterId.tlatoani,
          CharacterId.layla,
          CharacterId.covi,
          CharacterId.macron,
        ],
        speakerEmotion: EmotionState.blushing,
        tlatoaniEmotion: EmotionState.blushing,
        coviEmotion: EmotionState.teasing,
        heroineEmotion: EmotionState.happy,
        dialogueText:
            'Laylā, este cine de arte en Zamalek se ve increíble... Quería preguntarte en tu dialecto: «تِحِبِّي نِشْرَب حَاجَة سَوَا؟» ¿Tomamos un karkadēh frío antes de tu proyección?',
        dialogueTranslation:
            'Laylā, this indie art cinema in Zamalek looks incredible... I wanted to ask you in your dialect: "Tiḥibbī nishrab ḥāga sawa?" Shall we grab a chilled karkadēh hibiscus drink before your screening?',
        spokenAudioText:
            'Layla, este cine de arte en Zamalek se ve increíble. Quería preguntarte en tu dialecto: Tihibbi nishrab haga sawa? ¿Tomamos un karkadeh frío antes de tu proyección?',
        spokenLocale: 'es-MX',
        arabicSpotlight: ArabicWordToken(
          arabic: 'تِحِبِّي نِشْرَب حَاجَة سَوَا؟',
          unvocalized: 'تحبي نشرب حاجة سوا؟',
          transliteration: 'Tiḥibbī nishrab ḥāga sawa?',
          spanishMeaning: '¿Te gustaría que tomemos algo juntos?',
          englishMeaning: 'Would you like to grab a drink together?',
          spanishBridgeNote:
              'En México bebemos agua de jamaica y en El Cairo «كَرْكَدِيه» (karkadēh): la misma flor de hibisco rubí.',
          rootLetters: 'ح-ب-ب / ش-ر-ب',
        ),
        macronEmojis: '🌺🍹🎟️😳',
        macronProp: 'rose_hibiscus',
        culturalNote:
            'Zamalek (الزَّمَالِك) is a leafy island neighborhood in the Nile famous for its Art Deco architecture, indie cinemas, bookshops, and garden cafés serving chilled ruby-red karkadēh (hibiscus tea).',
      ),
      ComicPanelData(
        id: 'ch11_p2',
        backdrop: SceneBackdropType.cairoCinema,
        speaker: CharacterId.layla,
        presentCharacters: [
          CharacterId.layla,
          CharacterId.tlatoani,
          CharacterId.covi,
          CharacterId.macron,
        ],
        speakerEmotion: EmotionState.happy,
        tlatoaniEmotion: EmotionState.blushing,
        coviEmotion: EmotionState.happy,
        heroineEmotion: EmotionState.happy,
        dialogueText:
            'يَا سَلَام! طَبْعًا أَحِبّ يَا تْلَاتُوَانِي، الكَرْكَدِيه السَّاقِع هِنَا تُحْفَة! وَتَعَالُوا أَوَرِّيكُمْ سِرّ التَّرْجَمَة عَلَى شَاشَة السِّينِمَا قَبْل الفِيلْم.',
        dialogueTranslation:
            'Oh wonderful! Of course I’d love to, Tlatoāni—the chilled karkadēh here is a masterpiece! And come let me show you the secret of cinema subtitles on the screen before the film starts.',
        spokenAudioText:
            'يَا سَلَام! طَبْعًا أَحِبّ يَا تْلَاتُوَانِي، الكَرْكَدِيه السَّاقِع هِنَا تُحْفَة! وَتَعَالُوا أَوَرِّيكُمْ سِرّ التَّرْجَمَة عَلَى شَاشَة السِّينِمَا قَبْل الفِيلْم.',
        spokenLocale: 'ar-EG',
        arabicSpotlight: ArabicWordToken(
          arabic: 'كَرْكَدِيه • تُحْفَة',
          unvocalized: 'كركديه • تحفة',
          transliteration: 'karkadēh • tuḥfa',
          spanishMeaning: 'té de hibisco (jamaica) • una joya / obra maestra',
          englishMeaning: 'hibiscus tea • a gem / masterpiece',
          spanishBridgeNote:
              '«تُحْفَة!» (tuḥfa!) es la exclamación favorita en Egipto para decir que algo es exquisito o digno de museo.',
        ),
        macronEmojis: '🎬🍹💎✨',
        macronProp: 'projector',
        culturalNote:
            'Calling something "Tuḥfa!" (تُحْفَة — literally a museum artifact or masterpiece) is a beloved Cairene compliment for great food, art, or company.',
      ),
      ComicPanelData(
        id: 'ch11_p3',
        backdrop: SceneBackdropType.cairoCinema,
        speaker: CharacterId.layla,
        presentCharacters: [
          CharacterId.layla,
          CharacterId.tlatoani,
          CharacterId.covi,
          CharacterId.macron,
        ],
        speakerEmotion: EmotionState.excited,
        tlatoaniEmotion: EmotionState.curious,
        coviEmotion: EmotionState.curious,
        heroineEmotion: EmotionState.excited,
        dialogueText:
            'فِي السِّينِمَا وَاليُوتْيُوب، المُمَثِّل بِيِتْكَلِّم عَامِّيَّة بَسّ السَّبْتَايْتِل مَكْتُوب بِالفُصْحَى: «أُرِيدُ» هِيَ بَدِّي وَعَايِز وَأَبْغِي، وَ«مَاذَا» هِيَ شُو وَإِيه، وَ«الْآنَ» هِيَ هَلَّق وَدِلْوَقْتِي وَالْحِين، وَ«هُنَا» هِيَ هُون وَهِنَا!',
        dialogueTranslation:
            'In cinema and YouTube, actors speak in dialect while the subtitles are written in MSA: "Urīdu" (أريد) is baddī/‘āyiz/abghī, "Mādhā" (ماذا) is shū/ēh, "Al-āna" (الآن) is halla’/dilwa’tī/al-ḥīn, and "Hunā" (هنا) is hōn/hēna!',
        spokenAudioText:
            'فِي السِّينِمَا وَاليُوتْيُوب، المُمَثِّل بِيِتْكَلِّم عَامِّيَّة بَسّ السَّبْتَايْتِل مَكْتُوب بِالفُصْحَى: أُرِيدُ هِيَ بَدِّي وَعَايِز وَأَبْغِي، وَمَاذَا هِيَ شُو وَإِيه، وَالْآنَ هِيَ هَلَّق وَدِلْوَقْتِي وَالْحِين، وَهُنَا هِيَ هُون وَهِنَا!',
        spokenLocale: 'ar-EG',
        arabicSpotlight: ArabicWordToken(
          arabic: 'أُرِيدُ • مَاذَا • الْآنَ • هُنَا',
          unvocalized: 'أريد • ماذا • الآن • هنا',
          transliteration: 'urīdu • mādhā • al-āna • hunā',
          spanishMeaning:
              'أريد (baddī/‘āyiz/abghī) • ماذا (shū/ēh) • الآن (halla’/dilwa’tī/al-ḥīn) • هنا (hōn/hēna)',
          englishMeaning:
              'I want (baddī/‘āyiz/abghī) • what (shū/ēh) • now (halla’/dilwa’tī/al-ḥīn) • here (hōn/hēna)',
          spanishBridgeNote:
              '¡El puente definitivo! Tus ojos leen الفُصْحَى (MSA) en el subtítulo mientras tus oídos disfrutan el dialecto vivo.',
        ),
        macronEmojis: '📺💬🌉🔓',
        macronProp: 'film_slate',
        culturalNote:
            'Across the Arab world, television, Netflix, and YouTube caption spoken dialect audio using clean Modern Standard Arabic (MSA) subtitles. Knowing these bridge pairs makes spoken media transparent.',
      ),
      ComicPanelData(
        id: 'ch11_p4',
        backdrop: SceneBackdropType.cairoCinema,
        speaker: CharacterId.covi,
        presentCharacters: [
          CharacterId.covi,
          CharacterId.tlatoani,
          CharacterId.layla,
          CharacterId.macron,
        ],
        speakerEmotion: EmotionState.teasing,
        tlatoaniEmotion: EmotionState.blushing,
        coviEmotion: EmotionState.teasing,
        heroineEmotion: EmotionState.happy,
        dialogueText:
            'Aha! So when Tlatoāni whispers "Mabsūṭ innī shuftik el-yōm" over his hibiscus tea and his gills glow neon-rose, the cinema subtitle underneath him reads: "Smooth axolotl is overjoyed to see Laylā today"!',
        dialogueTranslation:
            '¡Ajá! Así que cuando Tlatoāni susurra «Mabsūṭ innī shuftik el-yōm» sobre su té de jamaica y sus branquias brillan rosa neón, ¡el subtítulo del cine debajo de él dice: «Ajolote galán está feliz de ver a Laylā hoy»!',
        spokenAudioText:
            'Aha! So when Tlatoani whispers Mabsut inni shuftik el-yom over his hibiscus tea and his gills glow neon-rose, the cinema subtitle underneath him reads: Smooth axolotl is overjoyed to see Layla today!',
        spokenLocale: 'en-US',
        arabicSpotlight: ArabicWordToken(
          arabic: 'مَبْسُوط إِنِّي شُفْتِك الْيُوم',
          unvocalized: 'مبسوط إني شفتك اليوم',
          transliteration: 'Mabsūṭ innī shuftik el-yōm',
          spanishMeaning: 'Estoy muy contento de haberte visto hoy',
          englishMeaning: 'I’m so happy I saw you today',
          spanishBridgeNote:
              'Una expresión sincera, respetuosa y llena de calidez que sirve tanto en El Cairo como en Beirut.',
          rootLetters: 'ب-س-ط / ش-و-ف',
        ),
        macronEmojis: '🤭🌸🍿💘',
        macronProp: 'popcorn',
        culturalNote:
            '"Mabsūṭ innī shuftik el-yōm" (مَبْسُوط إِنِّي شُفْتِك الْيُوم) is warm, gracious, and culturally respectful—expressing genuine delight in someone’s company.',
      ),
      ComicPanelData(
        id: 'ch11_p5',
        backdrop: SceneBackdropType.cairoCinema,
        speaker: CharacterId.tlatoani,
        presentCharacters: [
          CharacterId.tlatoani,
          CharacterId.layla,
          CharacterId.covi,
          CharacterId.macron,
        ],
        speakerEmotion: EmotionState.blushing,
        tlatoaniEmotion: EmotionState.blushing,
        coviEmotion: EmotionState.happy,
        heroineEmotion: EmotionState.blushing,
        dialogueText:
            '¡Covi, silencio que ya empieza el cortometraje! Pero sí, Laylā... «أَنَا مَبْسُوط قَوِي إِنِّي شُفْتِك الْيُوم»، y el karkadēh va por mi cuenta: ¡عَلَيَّا أَنَا!',
        dialogueTranslation:
            'Covi, hush, the short film is starting! But yes, Laylā... "Ana mabsūṭ ’awī innī shuftik el-yōm", and the karkadēh is on me: "‘Alayya ana!"',
        spokenAudioText:
            'Covi, silencio que ya empieza el cortometraje. Pero sí, Layla: Ana mabsut awi inni shuftik el-yom, y el karkadeh va por mi cuenta: Alayya ana!',
        spokenLocale: 'es-MX',
        arabicSpotlight: ArabicWordToken(
          arabic: 'عَلَيَّا أَنَا!',
          unvocalized: 'عليا أنا!',
          transliteration: '‘Alayya ana!',
          spanishMeaning: '¡Va por mi cuenta! / ¡Yo invito!',
          englishMeaning: 'It’s on me! / My treat!',
          spanishBridgeNote:
              'La generosidad (كَرَم karam) es sagrada desde Dubái y Beirut hasta El Cairo.',
        ),
        macronEmojis: '🎟️🌺😊✨',
        macronProp: 'clapboard',
        culturalNote:
            'Insisting on covering the café tab ("‘Alayya ana!" / "Khallīhā ‘alayya!") is a universal gesture of Arab karam (hospitality and chivalry).',
      ),
    ],
    challenge: const MasteryChallengeData(
      promptEs:
          'En la pantalla del cine de Zamalek aparecen los subtítulos en árabe estándar (MSA): «أُرِيدُ • مَاذَا • الْآنَ • هُنَا». ¿Con qué palabras habladas del dialecto egipcio/levantino/del Golfo se conectan y cómo invitas a Laylā a tomar algo juntos?',
      promptEn:
          'On the Zamalek cinema screen, the MSA subtitles read: "أُرِيدُ • مَاذَا • الْآنَ • هُنَا". Which spoken dialect words do they bridge to, and how do you invite Laylā for a drink together?',
      scenarioContext:
          'Trace the letter Ḥā’ (ح) from right to left, then match the MSA-to-Dialect Subtitle Bridges and cinema invitation.',
      traceLetter: _kCinemaLetterHa,
      options: [
        MasteryOption(
          arabic: 'تِحِبِّي نِشْرَب حَاجَة سَوَا؟ • أُرِيدُ↔عَايِز/بَدِّي/أَبْغِي • الْآنَ↔دِلْوَقْتِي/هَلَّق/الْحِين',
          transliteration:
              'Tiḥibbī nishrab ḥāga sawa? • urīdu<->‘āyiz/baddī/abghī • al-āna<->dilwa’tī/halla’/al-ḥīn',
          meaningEs:
              '¿Tomamos algo juntos? + Puentes: أريد (quiero), ماذا (shū/ēh), الآن (ahora), هنا (hōn/hēna)',
          meaningEn:
              'Shall we grab a drink together? + Bridges: urīdu (want), mādhā (what), al-āna (now), hunā (here)',
          isCorrect: true,
          feedbackEs:
              '¡تُحْفَة (Tuḥfa)! Dominaste tanto la invitación en Zamalek como los puentes entre subtítulos MSA y el árabe hablado.',
          feedbackEn:
              'Tuḥfa! You mastered both the Zamalek invitation and the bridges connecting MSA subtitles to spoken Arabic!',
        ),
        MasteryOption(
          arabic: 'الْحِسَاب مِنْ فَضْلَك • أُرِيدُ↔كِتَاب • الْآنَ↔مَطَار',
          transliteration: 'El-ḥisāb min faḍlak • urīdu<->kitāb • al-āna<->maṭār',
          meaningEs: 'La cuenta por favor + أريد significa libro y الآن significa aeropuerto',
          meaningEn: 'The bill please + urīdu means book and al-āna means airport',
          isCorrect: false,
          feedbackEs:
              'كِتَاب es libro y مَطَار es aeropuerto. Recuerda: «أُرِيدُ» es «quiero» (baddī/‘āyiz/abghī) y «الْآنَ» es «ahora» (halla’/dilwa’tī/al-ḥīn).',
          feedbackEn:
              'Kitāb is book and maṭār is airport. Remember: "urīdu" means "I want" (baddī/‘āyiz/abghī) and "al-āna" means "now" (halla’/dilwa’tī/al-ḥīn).',
        ),
        MasteryOption(
          arabic: 'عَلَى جَنَب هُون! • مَاذَا↔سُوق • هُنَا↔قَهْوَة',
          transliteration: '‘Ala janab hōn! • mādhā<->sūq • hunā<->qahwa',
          meaningEs: '¡Déjame en la esquina! + ماذا significa mercado y هنا significa café',
          meaningEn: 'Pull over here! + mādhā means market and hunā means coffee',
          isCorrect: false,
          feedbackEs:
              '«مَاذَا» (mādhā) significa «¿qué?» (shū / ēh) y «هُنَا» (hunā) significa «aquí» (hōn / hēna). ¡Inténtalo de nuevo!',
          feedbackEn:
              '"Mādhā" means "what?" (shū / ēh) and "hunā" means "here" (hōn / hēna). Give it another shot!',
        ),
      ],
    ),
    xpReward: 250,
    affinityReward: 2,
  ),

  // ===========================================================================
  // CHAPTER 12: Grand Finale — Rooftop Media Watch Party (Zero to One!)
  // ===========================================================================
  ComicChapterData(
    id: 'ch12_media_watch_party',
    number: 12,
    bookNumber: 3,
    bookTitle: 'Book III — Cairo & Laylā: Roots, Switchboard & Media',
    regionName: 'Nile Rooftop Terrace, Cairo 🇪🇬🇦🇪🇱🇧',
    dialectBadge: 'Grand Finale: MSA Media + All 3 Dialects',
    heroine: CharacterId.layla,
    titleEs: 'De Cero a Uno: Fiesta de Medios en la Azotea del Nilo',
    titleEn: 'Zero to One: The Grand Finale Rooftop Media Watch Party',
    titleArabic: 'مِنَ الصِّفْر إِلَى الْوَاحِد: سَهْرَةُ الْإِعْلَامِ عَلَى السَّطْح',
    subtitle:
        'Nūr, Yāsmīn & Laylā reunite with Tlatoāni, Covi & mācron āi to watch Arabic TV news and YouTube vlogs with real MSA subtitles!',
    lettersUnlocked: const [
      _kFinaleLetterNun,
    ],
    vocabularyUnlocked: const [
      ArabicWordToken(
        arabic: 'نَشْرَةُ الْأَخْبَارِ',
        unvocalized: 'نشرة الأخبار',
        transliteration: 'nashrat al-akhbār',
        spanishMeaning: 'boletín de noticias / telediario',
        englishMeaning: 'news broadcast / news bulletin',
        spanishBridgeNote:
            'الْأَخْبَار (al-akhbār, las noticias) comparte raíz خ-ب-ر con «شُو الْأَخْبَار؟» (¿qué tal / qué hay de nuevo?).',
        rootLetters: 'خ-ب-ر',
        dialectVariants: {
          'MSA': 'نَشْرَةُ الْأَخْبَارِ (nashrat al-akhbār)',
          'Cairo': 'الأَخْبَار (el-akhbār)',
          'Beirut': 'شُو الأَخْبَار؟ (shū el-akhbār?)',
        },
      ),
      ArabicWordToken(
        arabic: 'مِنَ الصِّفْرِ إِلَى الْوَاحِدِ',
        unvocalized: 'من الصفر إلى الواحد',
        transliteration: 'mina aṣ-ṣifri ilā al-wāḥid',
        spanishMeaning: 'de Cero a Uno (de صِفْر = cifra/cero a وَاحِد = uno)',
        englishMeaning: 'from Zero to One (from ṣifr = zero/cipher to wāḥid = one)',
        spanishBridgeNote:
            '¡Nuestro viaje completo! Empezamos con صِفْر (origen del español «cero» y «cifra») y llegamos a الْوَاحِد (el Uno).',
        rootLetters: 'ص-ف-ر / و-ح-د',
      ),
      ArabicWordToken(
        arabic: 'مُشَاهِدِينَا أَهْلًا بِكُمْ الْآنَ هُنَا فِي الْقَاهِرَةِ',
        unvocalized: 'مشاهدينا أهلا بكم الآن هنا في القاهرة',
        transliteration: 'Mushāhidīnā ahlan bikum al-āna hunā fī al-Qāhira',
        spanishMeaning:
            'Nuestros espectadores, bienvenidos ahora aquí en El Cairo (Subtítulo MSA)',
        englishMeaning:
            'Our viewers, welcome right now here in Cairo (MSA Subtitle)',
        spanishBridgeNote:
            'Cada palabra de este titular real de TV usa las raíces, letras solares/lunares y puentes que ya dominas.',
        rootLetters: 'ش-ه-د / أ-ه-ل / ق-ه-ر',
      ),
      ArabicWordToken(
        arabic: 'نَحْنُ نَتَكَلَّمُ الْعَرَبِيَّةَ!',
        unvocalized: 'نحن نتكلم العربية!',
        transliteration: 'Naḥnu natakallamu al-‘Arabiyya!',
        spanishMeaning: '¡Nosotros hablamos árabe!',
        englishMeaning: 'We speak Arabic!',
        spanishBridgeNote:
            'La raíz ك-ل-م (k-l-m, hablar/palabra) + el prefijo نَـ (na- de نَحْنُ, nosotros) = نَتَكَلَّمُ (hablamos).',
        rootLetters: 'ك-ل-م / ع-ر-ب',
        dialectVariants: {
          'MSA': 'نَحْنُ نَتَكَلَّمُ الْعَرَبِيَّةَ',
          'Cairo': 'إِحْنَا بْنِتْكَلِّم عَرَبِي (Iḥnā bnitkallim ‘Arabī)',
          'Beirut': 'نِحْنَا مْنِحْكِي عَرَبِي (Niḥnā mniḥkī ‘Arabī)',
          'Dubai': 'نِحْن نِتْكَلَّم عَرَبِي (Niḥn nitkallam ‘Arabī)',
        },
      ),
    ],
    panels: const [
      ComicPanelData(
        id: 'ch12_p1',
        backdrop: SceneBackdropType.mediaTerrace,
        speaker: CharacterId.layla,
        presentCharacters: [
          CharacterId.layla,
          CharacterId.nur,
          CharacterId.yasmin,
          CharacterId.tlatoani,
          CharacterId.covi,
          CharacterId.macron,
        ],
        speakerEmotion: EmotionState.excited,
        tlatoaniEmotion: EmotionState.excited,
        coviEmotion: EmotionState.excited,
        heroineEmotion: EmotionState.excited,
        dialogueText:
            'مُفَاجْأَة عَلَى سَطْح النِّيل! نُور جَتْ مِنْ دُبَيّ وَيَاسْمِين جَتْ مِنْ بَيْرُوت عَشَان نِتْفَرَّج سَوَا عَلَى البَثّ المُبَاشِر وَنِحْتِفِل بِرِحْلِتْكُمْ!',
        dialogueTranslation:
            'Surprise on the Nile rooftop! Nūr flew in from Dubai and Yāsmīn arrived from Beirut so we can watch the live broadcast together and celebrate your journey!',
        spokenAudioText:
            'مُفَاجْأَة عَلَى سَطْح النِّيل! نُور جَتْ مِنْ دُبَيّ وَيَاسْمِين جَتْ مِنْ بَيْرُوت عَشَان نِتْفَرَّج سَوَا عَلَى البَثّ المُبَاشِر وَنِحْتِفِل بِرِحْلِتْكُمْ!',
        spokenLocale: 'ar-EG',
        arabicSpotlight: ArabicWordToken(
          arabic: 'نُور • يَاسْمِين • لَيْلَى',
          unvocalized: 'نور • ياسمين • ليلى',
          transliteration: 'Nūr (🇦🇪) • Yāsmīn (🇱🇧) • Laylā (🇪🇬)',
          spanishMeaning: 'Luz (Dubái) • Jazmín (Beirut) • Noche (El Cairo)',
          englishMeaning: 'Light (Dubai) • Jasmine (Beirut) • Night (Cairo)',
          spanishBridgeNote:
              'Las tres anfitrionas reunidas bajo las estrellas del Nilo: caligrafía, botánica de Tillandsias y cine.',
        ),
        macronEmojis: '🎉🇦🇪🇱🇧🇪🇬',
        macronProp: 'party_lantern',
        culturalNote:
            'Cairo rooftop terraces overlooking the Nile bring friends together over Arabic coffee (gahwa), Levantine mint tea, and chilled Egyptian karkadēh.',
      ),
      ComicPanelData(
        id: 'ch12_p2',
        backdrop: SceneBackdropType.mediaTerrace,
        speaker: CharacterId.nur,
        presentCharacters: [
          CharacterId.nur,
          CharacterId.yasmin,
          CharacterId.layla,
          CharacterId.tlatoani,
          CharacterId.covi,
          CharacterId.macron,
        ],
        speakerEmotion: EmotionState.happy,
        tlatoaniEmotion: EmotionState.happy,
        coviEmotion: EmotionState.happy,
        heroineEmotion: EmotionState.happy,
        dialogueText:
            'مَرْحَبَا السَّاع يَا تْلَاتُوَانِي وَيَا كُوفِي! شُوفُوا شَاشَة التِّلِفِزْيُون: «مُشَاهِدِينَا أَهْلًا بِكُمْ الْآنَ هُنَا فِي الْقَاهِرَةِ — نَشْرَةُ الْأَخْبَارِ وَمَهْرَجَانُ السِّينِمَا».',
        dialogueTranslation:
            'Warmest Dubai greetings, Tlatoāni and Covi! Look at the TV news banner: "Mushāhidīnā ahlan bikum al-āna hunā fī al-Qāhira — Nashrat al-Akhbār & the Cinema Festival."',
        spokenAudioText:
            'مَرْحَبَا السَّاع يَا تْلَاتُوَانِي وَيَا كُوفِي! شُوفُوا شَاشَة التِّلِفِزْيُون: مُشَاهِدِينَا أَهْلًا بِكُمْ الْآنَ هُنَا فِي الْقَاهِرَةِ، نَشْرَةُ الْأَخْبَارِ وَمَهْرَجَانُ السِّينِمَا.',
        spokenLocale: 'ar-AE',
        arabicSpotlight: ArabicWordToken(
          arabic: 'نَشْرَةُ الْأَخْبَارِ • الْآنَ هُنَا فِي الْقَاهِرَةِ',
          unvocalized: 'نشرة الأخبار • الآن هنا في القاهرة',
          transliteration: 'Nashrat al-akhbār • al-āna hunā fī al-Qāhira',
          spanishMeaning: 'Boletín de noticias • Ahora aquí en El Cairo',
          englishMeaning: 'News broadcast • Right now here in Cairo',
          spanishBridgeNote:
              '¡Mira cómo puedes leer el cintillo sin vocales «نشرة الأخبار الآن هنا في القاهرة» de derecha a izquierda sin dudar!',
          rootLetters: 'خ-ب-ر / ق-ه-ر',
        ),
        macronEmojis: '📺📰🌟👏',
        macronProp: 'antenna_dish',
        culturalNote:
            'News chyrons on Al Jazeera, Al Arabiya, Sky News Arabia, and BBC Arabic use unvocalized MSA. Once you recognize common roots and function words (الآن، هنا، في), headlines unlock immediately.',
      ),
      ComicPanelData(
        id: 'ch12_p3',
        backdrop: SceneBackdropType.mediaTerrace,
        speaker: CharacterId.yasmin,
        presentCharacters: [
          CharacterId.yasmin,
          CharacterId.nur,
          CharacterId.layla,
          CharacterId.tlatoani,
          CharacterId.covi,
          CharacterId.macron,
        ],
        speakerEmotion: EmotionState.excited,
        tlatoaniEmotion: EmotionState.happy,
        coviEmotion: EmotionState.excited,
        heroineEmotion: EmotionState.excited,
        dialogueText:
            'وَهَلَّق عَلَى اليُوتْيُوب، الفْلُوغَر بِيْقُول بِالعَامِّيَّة: «بَدِّي وَعَايِز أَوَرِّيكُمْ المَتْحَف وَالسُّوق دِلْوَقْتِي!» وَالسَّبْتَايْتِل تَحْتُه مَكْتُوب: «أُرِيدُ أَنْ أُرِيَكُمُ الْمَتْحَفَ وَالسُّوقَ الْآنَ!».',
        dialogueTranslation:
            'And right now on YouTube, the vlogger says in dialect: "Baddī & ‘āyiz show you the museum and the souk dilwa’tī!" while the subtitle underneath reads: "Urīdu an uriyakum al-matḥaf wa as-sūq al-āna!"',
        spokenAudioText:
            'وَهَلَّق عَلَى اليُوتْيُوب، الفْلُوغَر بِيْقُول بِالعَامِّيَّة: بَدِّي وَعَايِز أَوَرِّيكُمْ المَتْحَف وَالسُّوق دِلْوَقْتِي! وَالسَّبْتَايْتِل تَحْتُه مَكْتُوب: أُرِيدُ أَنْ أُرِيَكُمُ الْمَتْحَفَ وَالسُّوقَ الْآنَ!',
        spokenLocale: 'ar-LB',
        arabicSpotlight: ArabicWordToken(
          arabic: 'أُرِيدُ أنْ أُرِيَكُمُ الْمَتْحَفَ وَالسُّوقَ الْآنَ',
          unvocalized: 'أريد أن أريكم المتحف والسوق الآن',
          transliteration: 'Urīdu an uriyakum al-matḥaf wa-s-sūq al-āna',
          spanishMeaning: 'Quiero mostrarles el museo y el mercado ahora',
          englishMeaning: 'I want to show you the museum and the market now',
          spanishBridgeNote:
              'الْمَتْحَف (letra lunar م -> al-matḥaf) y السُّوق (letra solar س -> as-sūq, como en «azúcar»).',
          rootLetters: 'ر-و-د / ت-ح-ف / س-و-ق',
        ),
        macronEmojis: '▶️🏛️🛍️🌿',
        macronProp: 'tillandsia_pot',
        culturalNote:
            'Notice how Moon letter م in الْمَتْحَف (al-matḥaf) keeps the L sound (like almohada), while Sun letter س in السُّوق (as-sūq) assimilates it (like azúcar)!',
      ),
      ComicPanelData(
        id: 'ch12_p4',
        backdrop: SceneBackdropType.mediaTerrace,
        speaker: CharacterId.covi,
        presentCharacters: [
          CharacterId.covi,
          CharacterId.tlatoani,
          CharacterId.layla,
          CharacterId.nur,
          CharacterId.yasmin,
          CharacterId.macron,
        ],
        speakerEmotion: EmotionState.excited,
        tlatoaniEmotion: EmotionState.blushing,
        coviEmotion: EmotionState.excited,
        heroineEmotion: EmotionState.happy,
        dialogueText:
            'We actually did it! We can read every single word on that screen from right to left AND understand all three dialects! Also, Tlatoāni is surrounded by Nūr, Yāsmīn, and Laylā at once—his gills have achieved maximum coral luminosity!',
        dialogueTranslation:
            '¡Realmente lo logramos! ¡Podemos leer cada palabra de esa pantalla de derecha a izquierda Y entender los tres dialectos! Además, Tlatoāni está rodeado por Nūr, Yāsmīn y Laylā a la vez: ¡sus branquias alcanzaron la luminosidad coral máxima!',
        spokenAudioText:
            'We actually did it! We can read every single word on that screen from right to left AND understand all three dialects! Also, Tlatoani is surrounded by Nur, Yasmin, and Layla at once—his gills have achieved maximum coral luminosity!',
        spokenLocale: 'en-US',
        arabicSpotlight: ArabicWordToken(
          arabic: 'مِنَ الصِّفْرِ إِلَى الْوَاحِدِ',
          unvocalized: 'من الصفر إلى الواحد',
          transliteration: 'Mina aṣ-ṣifri ilā al-wāḥid',
          spanishMeaning: 'De Cero (صِفْر) a Uno (وَاحِد)',
          englishMeaning: 'From Zero (ṣifr) to One (wāḥid)',
          spanishBridgeNote:
              'Empezamos sin conocer ni una letra y ahora leemos el alfabeto completo, raíces y subtítulos reales.',
          rootLetters: 'ص-ف-ر / و-ح-د',
        ),
        macronEmojis: '🚀🌟🎓🏆',
        macronProp: 'trophy_star',
        culturalNote:
            'The Arabic word صِفْر (ṣifr) gave both Spanish ("cero" & "cifra") and English ("zero" & "cipher") the very concept of zero—making "From Ṣifr to Wāḥid" the ultimate linguistic full circle.',
      ),
      ComicPanelData(
        id: 'ch12_p5',
        backdrop: SceneBackdropType.mediaTerrace,
        speaker: CharacterId.tlatoani,
        presentCharacters: [
          CharacterId.tlatoani,
          CharacterId.covi,
          CharacterId.layla,
          CharacterId.nur,
          CharacterId.yasmin,
          CharacterId.macron,
        ],
        speakerEmotion: EmotionState.happy,
        tlatoaniEmotion: EmotionState.blushing,
        coviEmotion: EmotionState.happy,
        heroineEmotion: EmotionState.happy,
        dialogueText:
            '¡شُكْرًا جَزِيلًا، نُور، يَاسْمِين وَلَيْلَى! Del español de Al-Ándalus a las 28 letras del Abjad, y de Dubái y Beirut hasta El Cairo: ¡مِنَ الصِّفْرِ إِلَى الْوَاحِدِ، نَحْنُ نَتَكَلَّمُ الْعَرَبِيَّةَ!',
        dialogueTranslation:
            'Shukran jazīlan, Nūr, Yāsmīn, and Laylā! From the Spanish cognates of Al-Andalus to all 28 letters of the Abjad, and from Dubai and Beirut to Cairo: "Mina aṣ-ṣifri ilā al-wāḥid, naḥnu natakallamu al-‘Arabiyya!" (From Zero to One, we speak Arabic!)',
        spokenAudioText:
            'Shukran jazilan, Nur, Yasmin y Layla! Del español de Al-Ándalus a las veintiocho letras del Abjad, y de Dubái y Beirut hasta El Cairo: Mina as-sifri ila al-wahid, nahnu natakallamu al-Arabiyya!',
        spokenLocale: 'es-MX',
        arabicSpotlight: ArabicWordToken(
          arabic: 'نَحْنُ نَتَكَلَّمُ الْعَرَبِيَّةَ!',
          unvocalized: 'نحن نتكلم العربية!',
          transliteration: 'Naḥnu natakallamu al-‘Arabiyya!',
          spanishMeaning: '¡Nosotros hablamos árabe!',
          englishMeaning: 'We speak Arabic!',
          spanishBridgeNote:
              '¡Felicidades! Has completado los 3 Libros y 12 Capítulos de Arabiya.',
          rootLetters: 'ك-ل-م / ع-ر-ب',
        ),
        macronEmojis: '🌟🎓💖🎆',
        macronProp: 'fireworks_lantern',
        culturalNote:
            'Mabrūk! (مَبْرُوك — Congratulations!) You have journeyed from your very first letter at Dubai International Airport to reading live Arabic media subtitles on a Nile rooftop in Cairo.',
      ),
    ],
    challenge: const MasteryChallengeData(
      promptEs:
          '¡Gran Final en la Azotea del Nilo! El subtítulo de la transmisión en vivo dice: «أُرِيدُ أَنْ أُرِيَكُمُ الْمَتْحَفَ وَالسُّوقَ الْآنَ هُنَا فِي الْقَاهِرَةِ». ¿Qué significa esta frase completa y cómo celebramos ir de Cero a Uno?',
      promptEn:
          'Grand Finale on the Nile Rooftop! The live broadcast subtitle reads: "أُرِيدُ أَنْ أُرِيَكُمُ الْمَتْحَفَ وَالسُّوقَ الْآنَ هُنَا فِي الْقَاهِرَةِ". What does this full broadcast line mean, and how do we celebrate going from Zero to One?',
      scenarioContext:
          'Trace the letter Nūn (ن) of "Naḥnu" (نَحْنُ — We) from right to left, then decode the live broadcast subtitle to complete Book III!',
      traceLetter: _kFinaleLetterNun,
      options: [
        MasteryOption(
          arabic: 'مِنَ الصِّفْرِ إِلَى الْوَاحِدِ، نَحْنُ نَتَكَلَّمُ الْعَرَبِيَّةَ!',
          transliteration:
              'Mina aṣ-ṣifri ilā al-wāḥid, naḥnu natakallamu al-‘Arabiyya!',
          meaningEs:
              '«Quiero mostrarles el museo y el mercado ahora aquí en El Cairo» • ¡De Cero a Uno, hablamos árabe!',
          meaningEn:
              '"I want to show you the museum and the market right now here in Cairo" • From Zero to One, we speak Arabic!',
          isCorrect: true,
          feedbackEs:
              '¡مَبْرُوك (Mabrūk)! Decodificaste el subtítulo completo en الفُصْحَى junto a Nūr, Yāsmīn, Laylā, Tlatoāni, Covi y mācron āi. ¡De Cero a Uno!',
          feedbackEn:
              'Mabrūk! You decoded the complete MSA broadcast subtitle alongside Nūr, Yāsmīn, Laylā, Tlatoāni, Covi, and mācron āi. From Zero to One!',
        ),
        MasteryOption(
          arabic: 'أَيْنَ بَوَّابَةُ الْمَطَارِ يَا أُسْتَاذ؟',
          transliteration: 'Ayna bawwābat al-maṭār yā ustādh?',
          meaningEs: '«¿Dónde está la puerta del aeropuerto, profesor?»',
          meaningEn: '"Where is the airport gate, professor?"',
          isCorrect: false,
          feedbackEs:
              '¡Eso fue cuando aterrizamos en el Capítulo 1! Fíjate en «الْمَتْحَفَ وَالسُّوقَ الْآنَ هُنَا فِي الْقَاهِرَةِ» (el museo y el mercado ahora aquí en El Cairo).',
          feedbackEn:
              'That was back when we landed in Chapter 1! Look closely at "al-matḥaf wa-s-sūq al-āna hunā fī al-Qāhira" (the museum and market right now here in Cairo).',
        ),
        MasteryOption(
          arabic: 'الْحِسَابُ مِنْ فَضْلِكَ، لَا أَتَكَلَّمُ الْعَرَبِيَّةَ',
          transliteration: 'Al-ḥisāb min faḍlika, lā atakallamu al-‘Arabiyya',
          meaningEs: '«La cuenta por favor, no hablo árabe»',
          meaningEn: '"The bill please, I do not speak Arabic"',
          isCorrect: false,
          feedbackEs:
              '¡Ahora sí hablas y lees árabe! Elige «مِنَ الصِّفْرِ إِلَى الْوَاحِدِ، نَحْنُ نَتَكَلَّمُ الْعَرَبِيَّةَ!».',
          feedbackEn:
              'Now you DO speak and read Arabic! Choose "Mina aṣ-ṣifri ilā al-wāḥid, naḥnu natakallamu al-‘Arabiyya!".',
        ),
      ],
    ),
    xpReward: 350,
    affinityReward: 2,
  ),
];
