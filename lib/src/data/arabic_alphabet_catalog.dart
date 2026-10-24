// @trace spec:arabiya, spec:character-canon, spec:curriculum-and-comics
import 'dart:ui';

import '../models/comic_models.dart';

/// All 28 letters of the Arabic Abjad grouped across the 6 pedagogical stages:
/// - Stage 1: Long Vowels & The Boat Family (ا و ي ب ت ث)
/// - Stage 2: The Non-Connector Sisters (د ذ ر ز)
/// - Stage 3: Everyday Connectors (ن م ل ك ه)
/// - Stage 4: The Belly Trio & Sibilant Sisters (ج ح خ س ش)
/// - Stage 5: Loops & The Deep Throat Pair (ف ق ع غ)
/// - Stage 6: The 4 Emphatic Letters (ص ض ط ظ)
final List<ArabicLetterLesson> kFullArabicAbjad = const [
  // ===========================================================================
  // STAGE 1: Long Vowels & The Boat Family (6 letters)
  // ===========================================================================
  ArabicLetterLesson(
    letter: 'ا',
    nameArabic: 'أَلِف',
    nameTranslit: 'Alif',
    forms: {
      'isolated': 'ا',
      'initial': 'ا',
      'medial': 'ـا',
      'final': 'ـا',
    },
    isNonConnector: true,
    sunOrMoon: 'vowel',
    spanishPhoneticTip:
        'Vocal larga «ā» abierta como en «mar» (بَاب bāb = puerta). Con hamza (أ / إ) suena como inicio de vocal limpia («a / i / u»). No conecta hacia la izquierda.',
    englishPhoneticTip:
        'Long open vowel "ā" as in "father" (بَاب bāb = door), or a clean vowel seat with hamza (أ / إ). Non-connector to the left.',
    exampleArabic: 'بَاب / أَنَا',
    exampleTranslit: 'bāb / anā',
    exampleMeaningEsEn: 'puerta / yo • door / I',
    strokeWaypoints: [
      [
        Offset(0.50, 0.18),
        Offset(0.50, 0.48),
        Offset(0.50, 0.78),
      ],
    ],
  ),
  ArabicLetterLesson(
    letter: 'و',
    nameArabic: 'وَاو',
    nameTranslit: 'Wāw',
    forms: {
      'isolated': 'و',
      'initial': 'و',
      'medial': 'ـو',
      'final': 'ـو',
    },
    isNonConnector: true,
    sunOrMoon: 'moon',
    spanishPhoneticTip:
        'Como la «u» larga en «luna» (نُور nūr = luz) o «hu» en «hueso» (وَاحِد wāḥid = uno). Como palabra suelta «وَ» significa «y». No conecta a la izquierda.',
    englishPhoneticTip:
        'Consonant "w" as in "water" (وَاحِد wāḥid = one) or long vowel "ū" as in "moon" (نُور nūr = light). Non-connector to the left.',
    exampleArabic: 'نُور / تَوْت',
    exampleTranslit: 'nūr / tūt',
    exampleMeaningEsEn: 'luz / moras • light / berries',
    strokeWaypoints: [
      [
        Offset(0.58, 0.42),
        Offset(0.46, 0.30),
        Offset(0.38, 0.44),
        Offset(0.56, 0.56),
        Offset(0.42, 0.78),
        Offset(0.24, 0.82),
      ],
    ],
  ),
  ArabicLetterLesson(
    letter: 'ي',
    nameArabic: 'يَاء',
    nameTranslit: 'Yā’',
    forms: {
      'isolated': 'ي',
      'initial': 'يـ',
      'medial': 'ـيـ',
      'final': 'ـي',
    },
    isNonConnector: false,
    sunOrMoon: 'moon',
    spanishPhoneticTip:
        'Vocal larga «ī» como en «isla» o semiconsonante «y» suave como en «yate» (يَاسْمِين Yāsmīn). Dos puntos debajo cuando se une.',
    englishPhoneticTip:
        'Consonant "y" as in "yes" (يَاسْمِين Yāsmīn) or long vowel "ī" as in "see" (فِي fī = in). Two dots underneath in initial/medial forms.',
    exampleArabic: 'بَيْت / يَاسْمِين',
    exampleTranslit: 'bayt / Yāsmīn',
    exampleMeaningEsEn: 'casa / jazmín • house / jasmine',
    strokeWaypoints: [
      [
        Offset(0.68, 0.38),
        Offset(0.52, 0.50),
        Offset(0.66, 0.60),
        Offset(0.44, 0.76),
        Offset(0.24, 0.66),
      ],
    ],
    dotOffsets: [
      Offset(0.52, 0.86),
      Offset(0.42, 0.86),
    ],
  ),
  ArabicLetterLesson(
    letter: 'ب',
    nameArabic: 'بَاء',
    nameTranslit: 'Bā’',
    forms: {
      'isolated': 'ب',
      'initial': 'بـ',
      'medial': 'ـبـ',
      'final': 'ـب',
    },
    isNonConnector: false,
    sunOrMoon: 'moon',
    spanishPhoneticTip:
        'Idéntica a la «b» española en «barco» o «barrio» (الْبَرِّيّ). Es una barquita con 1 punto debajo (¡recuerda: «B» de Bajo!).',
    englishPhoneticTip:
        'Identical to English "b" in "boat". Shaped like a shallow boat with 1 dot underneath ("B" = Below!).',
    exampleArabic: 'بَاب / بَيْت',
    exampleTranslit: 'bāb / bayt',
    exampleMeaningEsEn: 'puerta / casa • door / house',
    strokeWaypoints: [
      [
        Offset(0.80, 0.46),
        Offset(0.74, 0.64),
        Offset(0.50, 0.66),
        Offset(0.26, 0.64),
        Offset(0.20, 0.46),
      ],
    ],
    dotOffsets: [
      Offset(0.50, 0.80),
    ],
  ),
  ArabicLetterLesson(
    letter: 'ت',
    nameArabic: 'تَاء',
    nameTranslit: 'Tā’',
    forms: {
      'isolated': 'ت',
      'initial': 'تـ',
      'medial': 'ـتـ',
      'final': 'ـت',
    },
    isNonConnector: false,
    sunOrMoon: 'sun',
    spanishPhoneticTip:
        'Como la «t» dental española en «taza» o «tarde». Misma barquita que ب pero con 2 puntos arriba («T» = Top / Techo). Letra Solar.',
    englishPhoneticTip:
        'Clean dental "t" as in "tea". Same boat hull as ب, with 2 dots on top ("T" = Two on Top!). Sun letter.',
    exampleArabic: 'تُوت / حَتَّى',
    exampleTranslit: 'tūt / ḥattā',
    exampleMeaningEsEn: 'moras / hasta • berries / until',
    strokeWaypoints: [
      [
        Offset(0.80, 0.50),
        Offset(0.74, 0.68),
        Offset(0.50, 0.70),
        Offset(0.26, 0.68),
        Offset(0.20, 0.50),
      ],
    ],
    dotOffsets: [
      Offset(0.55, 0.34),
      Offset(0.45, 0.34),
    ],
  ),
  ArabicLetterLesson(
    letter: 'ث',
    nameArabic: 'ثَاء',
    nameTranslit: 'Thā’',
    forms: {
      'isolated': 'ث',
      'initial': 'ثـ',
      'medial': 'ـثـ',
      'final': 'ـث',
    },
    isNonConnector: false,
    sunOrMoon: 'sun',
    spanishPhoneticTip:
        'Suena exactamente como la «z/c» del español de España en «zapato» o «cielo» (o «th» en inglés «think»). Barquita con 3 puntos en triángulo arriba.',
    englishPhoneticTip:
        'Unvoiced "th" as in "three" (and Spanish "z" in Madrid). Same boat shape with 3 dots in a triangle on top ("Th" = Three!).',
    exampleArabic: 'ثَلَاثَة / قِيثَارَة',
    exampleTranslit: 'thalātha / qīthāra',
    exampleMeaningEsEn: 'tres / guitarra • three / guitar',
    strokeWaypoints: [
      [
        Offset(0.80, 0.52),
        Offset(0.74, 0.70),
        Offset(0.50, 0.72),
        Offset(0.26, 0.70),
        Offset(0.20, 0.52),
      ],
    ],
    dotOffsets: [
      Offset(0.55, 0.36),
      Offset(0.45, 0.36),
      Offset(0.50, 0.26),
    ],
  ),

  // ===========================================================================
  // STAGE 2: The Non-Connector Sisters (4 letters; 6 total with ا & و)
  // ===========================================================================
  ArabicLetterLesson(
    letter: 'د',
    nameArabic: 'دَال',
    nameTranslit: 'Dāl',
    forms: {
      'isolated': 'د',
      'initial': 'د',
      'medial': 'ـد',
      'final': 'ـد',
    },
    isNonConnector: true,
    sunOrMoon: 'sun',
    spanishPhoneticTip:
        'Como la «d» inicial firme en «donde» o «Dubái». No conecta con la letra que sigue a su izquierda.',
    englishPhoneticTip:
        'Crisp dental "d" as in "door" or "Dubai". Non-connector to the left.',
    exampleArabic: 'دَار / دُبَيّ',
    exampleTranslit: 'dār / Dubayy',
    exampleMeaningEsEn: 'hogar / Dubái • home / Dubai',
    strokeWaypoints: [
      [
        Offset(0.62, 0.32),
        Offset(0.74, 0.52),
        Offset(0.56, 0.68),
        Offset(0.32, 0.68),
      ],
    ],
  ),
  ArabicLetterLesson(
    letter: 'ذ',
    nameArabic: 'ذَال',
    nameTranslit: 'Dhāl',
    forms: {
      'isolated': 'ذ',
      'initial': 'ذ',
      'medial': 'ـذ',
      'final': 'ـذ',
    },
    isNonConnector: true,
    sunOrMoon: 'sun',
    spanishPhoneticTip:
        '¡Puente directo con el español! Suena exactamente como la «d» suave intervocálica en «almohada», «nada» o «dedo». En El Cairo a veces suena como «z».',
    englishPhoneticTip:
        'Voiced "th" as in "this" or "brother" (and identical to soft Spanish "d" in "almohada"). Non-connector to the left.',
    exampleArabic: 'ذَهَب / مَاذَا',
    exampleTranslit: 'dhahab / mādhā',
    exampleMeaningEsEn: 'oro / ¿qué? • gold / what?',
    strokeWaypoints: [
      [
        Offset(0.62, 0.36),
        Offset(0.74, 0.56),
        Offset(0.56, 0.70),
        Offset(0.32, 0.70),
      ],
    ],
    dotOffsets: [
      Offset(0.58, 0.20),
    ],
  ),
  ArabicLetterLesson(
    letter: 'ر',
    nameArabic: 'رَاء',
    nameTranslit: 'Rā’',
    forms: {
      'isolated': 'ر',
      'initial': 'ر',
      'medial': 'ـر',
      'final': 'ـر',
    },
    isNonConnector: true,
    sunOrMoon: 'sun',
    spanishPhoneticTip:
        '¡Idéntica a la «r / rr» vibrante del español en «rosa» o «barrio»! Desciende en un tobogán elegante bajo el renglón.',
    englishPhoneticTip:
        'A tapped or rolled "r" just like Spanish "rosa" or "pero". Swoops gracefully below the baseline; non-connector to the left.',
    exampleArabic: 'نُور / سُكَّر',
    exampleTranslit: 'nūr / sukkar',
    exampleMeaningEsEn: 'luz / azúcar • light / sugar',
    strokeWaypoints: [
      [
        Offset(0.64, 0.38),
        Offset(0.62, 0.58),
        Offset(0.46, 0.76),
        Offset(0.28, 0.82),
      ],
    ],
  ),
  ArabicLetterLesson(
    letter: 'ز',
    nameArabic: 'زَاي',
    nameTranslit: 'Zāy',
    forms: {
      'isolated': 'ز',
      'initial': 'ز',
      'medial': 'ـز',
      'final': 'ـز',
    },
    isNonConnector: true,
    sunOrMoon: 'sun',
    spanishPhoneticTip:
        'Una «s» sonora con vibración de abeja («zzz»). Es la letra solar de الزَّيْت (az-zayt -> ¡nuestra palabra «aceite»!).',
    englishPhoneticTip:
        'Buzzing "z" as in "zero" or "jazz". Twin of ر with 1 dot above; gives Spanish "aceite" from az-zayt (الزَّيْت).',
    exampleArabic: 'زَيْت / الزَّيْت',
    exampleTranslit: 'zayt / az-zayt',
    exampleMeaningEsEn: 'aceite • olive oil / oil',
    strokeWaypoints: [
      [
        Offset(0.64, 0.42),
        Offset(0.62, 0.60),
        Offset(0.46, 0.78),
        Offset(0.28, 0.84),
      ],
    ],
    dotOffsets: [
      Offset(0.60, 0.24),
    ],
  ),

  // ===========================================================================
  // STAGE 3: Everyday Connectors (5 letters)
  // ===========================================================================
  ArabicLetterLesson(
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
        'Como la «n» de «noche», «naranja» y «Nūr» (نُور). Cuenco profundo con 1 punto arriba en el centro.',
    englishPhoneticTip:
        'Like "n" in "noon" and "Nūr" (نُور). A deep bowl with 1 dot centered above.',
    exampleArabic: 'نُور / أَنَا',
    exampleTranslit: 'nūr / anā',
    exampleMeaningEsEn: 'luz / yo • light / I',
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
  ),
  ArabicLetterLesson(
    letter: 'م',
    nameArabic: 'مِيم',
    nameTranslit: 'Mīm',
    forms: {
      'isolated': 'م',
      'initial': 'مـ',
      'medial': 'ـمـ',
      'final': 'ـم',
    },
    isNonConnector: false,
    sunOrMoon: 'moon',
    spanishPhoneticTip:
        'Como la «m» en «mamá» o «almohada» (الْمِخَدَّة). Además, el prefijo مَـ (ma-) crea lugares: مَكْتَب (oficina), مَتْحَف (museo).',
    englishPhoneticTip:
        'Like "m" in "moon". Also acts as the place-prefix "ma-" in Arabic roots: مَكْتَب (maktab = office), مَتْحَف (matḥaf = museum).',
    exampleArabic: 'مَكْتَب / الْمِخَدَّة',
    exampleTranslit: 'maktab / al-mikhadda',
    exampleMeaningEsEn: 'oficina / almohada • office / pillow',
    strokeWaypoints: [
      [
        Offset(0.66, 0.42),
        Offset(0.54, 0.32),
        Offset(0.46, 0.46),
        Offset(0.62, 0.52),
        Offset(0.38, 0.54),
        Offset(0.38, 0.82),
      ],
    ],
  ),
  ArabicLetterLesson(
    letter: 'ل',
    nameArabic: 'لَام',
    nameTranslit: 'Lām',
    forms: {
      'isolated': 'ل',
      'initial': 'لـ',
      'medial': 'ـلـ',
      'final': 'ـل',
    },
    isNonConnector: false,
    sunOrMoon: 'sun',
    spanishPhoneticTip:
        'Como la «l» clara en «limón» (لَيْمُون) y «Laylā» (لَيْلَى). Con Alif forma el artículo «الـ» (al-) que dio al español cientos de palabras con «al-».',
    englishPhoneticTip:
        'Clear "l" as in "lemon" (لَيْمُون laymūn) and "Laylā" (لَيْلَى). Combines with Alif to form the definite article الـ (al-) and ligature لا (lā = no).',
    exampleArabic: 'لَيْلَى / لَيْمُون',
    exampleTranslit: 'Laylā / laymūn',
    exampleMeaningEsEn: 'Laylā (noche) / limón • Laylā / lemon',
    strokeWaypoints: [
      [
        Offset(0.64, 0.18),
        Offset(0.64, 0.62),
        Offset(0.46, 0.74),
        Offset(0.28, 0.58),
      ],
    ],
  ),
  ArabicLetterLesson(
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
        'Como «c» en «casa» o «k» en «kilo». Al final de una palabra significa «tu / te»: «ـَك» (-ak a un hombre) y «ـِك» (-ik a una mujer).',
    englishPhoneticTip:
        'Like "k" in "key". At the end of a word, it serves as the "you/your" suffix: "-ak" (masculine) and "-ik" (feminine).',
    exampleArabic: 'كِتَاب / كَيْفَ',
    exampleTranslit: 'kitāb / kayfa',
    exampleMeaningEsEn: 'libro / ¿cómo? • book / how?',
    strokeWaypoints: [
      [
        Offset(0.74, 0.22),
        Offset(0.74, 0.66),
        Offset(0.46, 0.68),
        Offset(0.24, 0.60),
      ],
    ],
  ),
  ArabicLetterLesson(
    letter: 'ه',
    nameArabic: 'هَاء (وَالتَّاء الْمَرْبُوطَة ة)',
    nameTranslit: 'Hā’ (and Tā’ Marbūṭa ة)',
    forms: {
      'isolated': 'ه (ة)',
      'initial': 'هـ',
      'medial': 'ـهـ',
      'final': 'ـه (ـة)',
    },
    isNonConnector: false,
    sunOrMoon: 'moon',
    spanishPhoneticTip:
        'Suave aspiración como la «h» inglesa en «hello» (o la «j» caribeña/andaluza muy suave). Con dos puntos arriba al final es «ة» (tā’ marbūṭa), la terminación femenina «-a» como en قَهْوَة (qahwa).',
    englishPhoneticTip:
        'Soft breathy "h" as in "hello" (هُنَا hunā = here). With two dots at the end of a noun, it becomes ة (tā’ marbūṭa), marking feminine words ending in "-a" like قَهْوَة (qahwa).',
    exampleArabic: 'هُنَا / قَهْوَة',
    exampleTranslit: 'hunā / qahwa',
    exampleMeaningEsEn: 'aquí / café • here / coffee',
    strokeWaypoints: [
      [
        Offset(0.56, 0.34),
        Offset(0.72, 0.56),
        Offset(0.48, 0.68),
        Offset(0.32, 0.52),
        Offset(0.56, 0.34),
      ],
    ],
  ),

  // ===========================================================================
  // STAGE 4: The Belly Trio & Sibilant Sisters (5 letters)
  // ===========================================================================
  ArabicLetterLesson(
    letter: 'ج',
    nameArabic: 'جِيم',
    nameTranslit: 'Jīm / Gīm (Cairo)',
    forms: {
      'isolated': 'ج',
      'initial': 'جـ',
      'medial': 'ـجـ',
      'final': 'ـج',
    },
    isNonConnector: false,
    sunOrMoon: 'moon',
    spanishPhoneticTip:
        'En árabe estándar y Dubái suena como «j» inglesa en «jam»; en Beirut como «j» francesa suave; ¡y en El Cairo suena como «g» de «gato» (جَمِيل gamīl)! Tiene 1 punto en la barriga.',
    englishPhoneticTip:
        'Pronounced like "j" in "jam" (MSA/Gulf), soft "zh" in "measure" (Levant), and a hard "g" as in "gold" in Cairo (جَمِيل gamīl)! One dot inside the belly.',
    exampleArabic: 'جَمِيل / جَذْر',
    exampleTranslit: 'jamīl (gamīl) / jadhr',
    exampleMeaningEsEn: 'hermoso / raíz • beautiful / root',
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
  ),
  ArabicLetterLesson(
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
        'Un suspiro cálido y limpio desde el fondo de la garganta (como cuando empañas tus lentes con vaho), sin raspar. No lleva ningún punto. Dio origen a «hasta» (حَتَّى ḥattā).',
    englishPhoneticTip:
        'A warm, whispered breath from deep in the throat (like fogging up a mirror). Zero dots! Gives Spanish "hasta" from حَتَّى (ḥattā).',
    exampleArabic: 'حَتَّى / حِسَاب / مَرْحَبًا',
    exampleTranslit: 'ḥattā / ḥisāb / marḥaban',
    exampleMeaningEsEn: 'hasta / cuenta / hola • until / bill / welcome',
    strokeWaypoints: [
      [
        Offset(0.32, 0.34),
        Offset(0.68, 0.34),
        Offset(0.46, 0.54),
        Offset(0.62, 0.76),
        Offset(0.34, 0.78),
      ],
    ],
  ),
  ArabicLetterLesson(
    letter: 'خ',
    nameArabic: 'خَاء',
    nameTranslit: 'Khā’',
    forms: {
      'isolated': 'خ',
      'initial': 'خـ',
      'medial': 'ـخـ',
      'final': 'ـخ',
    },
    isNonConnector: false,
    sunOrMoon: 'moon',
    spanishPhoneticTip:
        '¡Idéntica a la «j» española en «jamón», «Jorge» o «México»! Lleva 1 punto arriba de la ceja. En الْـمِخَدَّة (al-mikhadda) pasó al español como «almohada».',
    englishPhoneticTip:
        'Exact match to the Spanish "j" in "jalapeño" or Scottish "ch" in "loch". One dot on top of the brow.',
    exampleArabic: 'خُبْز / الْأَخْبَار',
    exampleTranslit: 'khubz / al-akhbār',
    exampleMeaningEsEn: 'pan / las noticias • bread / the news',
    strokeWaypoints: [
      [
        Offset(0.32, 0.38),
        Offset(0.68, 0.38),
        Offset(0.46, 0.56),
        Offset(0.62, 0.78),
        Offset(0.34, 0.80),
      ],
    ],
    dotOffsets: [
      Offset(0.52, 0.22),
    ],
  ),
  ArabicLetterLesson(
    letter: 'س',
    nameArabic: 'سِين',
    nameTranslit: 'Sīn',
    forms: {
      'isolated': 'س',
      'initial': 'سـ',
      'medial': 'ـسـ',
      'final': 'ـس',
    },
    isNonConnector: false,
    sunOrMoon: 'sun',
    spanishPhoneticTip:
        'Como la «s» clara de «sol». Tres dientecitos sin puntos. Es Letra Solar: en السُّكَّر (as-sukkar) asimila la «l» y nos dio «azúcar» en español.',
    englishPhoneticTip:
        'Crisp "s" as in "sun". Three smooth ripples with no dots. Sun letter: السُّكَّر (as-sukkar) assimilates the "l" and gave us "azúcar / sugar"!',
    exampleArabic: 'سُكَّر / سُوق',
    exampleTranslit: 'sukkar / sūq',
    exampleMeaningEsEn: 'azúcar / mercado • sugar / market',
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
  ),
  ArabicLetterLesson(
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
        'Como «sh» en «show» o «shampoo». Hermana de س con 3 puntos arriba. En «إِنْ شَاءَ اللّٰه» (in shā’a Allāh) nos dio el español «¡ojalá!» y en شَرَاب nos dio «jarabe».',
    englishPhoneticTip:
        'Sounds like "sh" in "shine". Twin of س crowned with 3 dots. Appears in إِنْ شَاءَ اللّٰه (which became Spanish "ojalá!") and شُكْرًا (shukran).',
    exampleArabic: 'شُكْرًا / مَشْرُوب',
    exampleTranslit: 'shukran / mashrūb',
    exampleMeaningEsEn: 'gracias / bebida • thank you / beverage',
    strokeWaypoints: [
      [
        Offset(0.84, 0.52),
        Offset(0.76, 0.64),
        Offset(0.68, 0.52),
        Offset(0.60, 0.64),
        Offset(0.52, 0.52),
        Offset(0.42, 0.74),
        Offset(0.24, 0.72),
        Offset(0.18, 0.56),
      ],
    ],
    dotOffsets: [
      Offset(0.74, 0.32),
      Offset(0.66, 0.24),
      Offset(0.58, 0.32),
    ],
  ),

  // ===========================================================================
  // STAGE 5: Loops & The Deep Throat Pair (4 letters)
  // ===========================================================================
  ArabicLetterLesson(
    letter: 'ف',
    nameArabic: 'فَاء',
    nameTranslit: 'Fā’',
    forms: {
      'isolated': 'ف',
      'initial': 'فـ',
      'medial': 'ـفـ',
      'final': 'ـف',
    },
    isNonConnector: false,
    sunOrMoon: 'moon',
    spanishPhoneticTip:
        'Idéntica a la «f» en «faro» o «feluca» (فَلُوكَة). Lazo redondo sobre el renglón con 1 punto arriba.',
    englishPhoneticTip:
        'Identical to "f" in "felucca" (فَلُوكَة) and "fī" (فِي = in). A neat loop resting on the baseline with 1 dot above.',
    exampleArabic: 'فِي / فَلُوكَة',
    exampleTranslit: 'fī / falūka',
    exampleMeaningEsEn: 'en / faluca (velero del Nilo) • in / Nile felucca',
    strokeWaypoints: [
      [
        Offset(0.76, 0.46),
        Offset(0.66, 0.34),
        Offset(0.58, 0.48),
        Offset(0.72, 0.58),
        Offset(0.42, 0.60),
        Offset(0.22, 0.50),
      ],
    ],
    dotOffsets: [
      Offset(0.66, 0.22),
    ],
  ),
  ArabicLetterLesson(
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
        'Una «k» profunda pronunciada en la campanilla (MSA), que en Dubái suena «g» (gahwa) y en Beirut/El Cairo una pausa glotal (’ahwa). Dio origen a «alcalde» (الْقَاضِي), «camisa» (قَمِيص) y «guitarra» (قِيثَارَة).',
    englishPhoneticTip:
        'Deep uvular "q" in MSA; becomes warm "g" in Dubai (gahwa) and a glottal stop in Beirut & Cairo (’ahwa). Two dots above a deeper bowl.',
    exampleArabic: 'قَهْوَة / الْقَاضِي',
    exampleTranslit: 'qahwa / al-qāḍī',
    exampleMeaningEsEn: 'café / el juez (alcalde) • coffee / the judge (mayor)',
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
  ),
  ArabicLetterLesson(
    letter: 'ع',
    nameArabic: 'عَيْن',
    nameTranslit: '‘Ayn',
    forms: {
      'isolated': 'ع',
      'initial': 'عـ',
      'medial': 'ـعـ',
      'final': 'ـع',
    },
    isNonConnector: false,
    sunOrMoon: 'moon',
    spanishPhoneticTip:
        'La letra más emblemática de الْعَرَبِيَّة (al-‘Arabiyya): una resonancia cálida y profunda apretando suavemente la garganta al decir una vocal («‘a / ‘i / ‘u»).',
    englishPhoneticTip:
        'The signature voiced pharyngeal resonance of Arabic (الْعَرَبِيَّة al-‘Arabiyya): gently constrict the throat while voicing a warm vowel.',
    exampleArabic: 'عَرَبِيَّة / عَمَل / عَلَيَّا',
    exampleTranslit: '‘Arabiyya / ‘amal / ‘alayya',
    exampleMeaningEsEn: 'árabe / trabajo / yo invito • Arabic / work / on me',
    strokeWaypoints: [
      [
        Offset(0.42, 0.28),
        Offset(0.62, 0.36),
        Offset(0.44, 0.48),
        Offset(0.66, 0.68),
        Offset(0.36, 0.80),
      ],
    ],
  ),
  ArabicLetterLesson(
    letter: 'غ',
    nameArabic: 'غَيْن',
    nameTranslit: 'Ghayn',
    forms: {
      'isolated': 'غ',
      'initial': 'غـ',
      'medial': 'ـغـ',
      'final': 'ـغ',
    },
    isNonConnector: false,
    sunOrMoon: 'moon',
    spanishPhoneticTip:
        'Suena como la «g» suave intervocálica en «agua» o «lago» combinada con la «r» francesa de París (como al hacer gárgaras suaves). Hermana de ع con 1 punto arriba.',
    englishPhoneticTip:
        'A soft, purring French "r" or Spanish soft "g" in "agua". Twin of ع with 1 dot above; heard in Dubai’s أَبْغِي (abghī = I want).',
    exampleArabic: 'أَبْغِي / غُرُوب',
    exampleTranslit: 'abghī / ghurūb',
    exampleMeaningEsEn: 'quiero (Dubái) / atardecer • I want / sunset',
    strokeWaypoints: [
      [
        Offset(0.42, 0.32),
        Offset(0.62, 0.40),
        Offset(0.44, 0.52),
        Offset(0.66, 0.70),
        Offset(0.36, 0.82),
      ],
    ],
    dotOffsets: [
      Offset(0.52, 0.18),
    ],
  ),

  // ===========================================================================
  // STAGE 6: The 4 Emphatic Letters (4 letters — completes all 28!)
  // ===========================================================================
  ArabicLetterLesson(
    letter: 'ص',
    nameArabic: 'صَاد',
    nameTranslit: 'Ṣād',
    forms: {
      'isolated': 'ص',
      'initial': 'صـ',
      'medial': 'ـصـ',
      'final': 'ـص',
    },
    isNonConnector: false,
    sunOrMoon: 'sun',
    spanishPhoneticTip:
        'Una «s» grave y resonante con la lengua cóncava. Dio al español «cero» y «cifra» (de صِفْر ṣifr) y «camisa» (de قَمِيص qamīṣ).',
    englishPhoneticTip:
        'Deep, resonant emphatic "ṣ" (gives adjacent vowels a rich "aw/ah" resonance). Source of English "zero" & "cipher" from صِفْر (ṣifr)!',
    exampleArabic: 'صِفْر / قَمِيص',
    exampleTranslit: 'ṣifr / qamīṣ',
    exampleMeaningEsEn: 'cero (cifra) / camisa • zero (cipher) / shirt',
    strokeWaypoints: [
      [
        Offset(0.58, 0.50),
        Offset(0.78, 0.38),
        Offset(0.84, 0.52),
        Offset(0.58, 0.54),
        Offset(0.48, 0.72),
        Offset(0.24, 0.70),
        Offset(0.20, 0.54),
      ],
    ],
  ),
  ArabicLetterLesson(
    letter: 'ض',
    nameArabic: 'ضَاد',
    nameTranslit: 'Ḍād',
    forms: {
      'isolated': 'ض',
      'initial': 'ضـ',
      'medial': 'ـضـ',
      'final': 'ـض',
    },
    isNonConnector: false,
    sunOrMoon: 'sun',
    spanishPhoneticTip:
        'Una «d» enfática y profunda (al árabe se le llama «la lengua de la Ḍād»). En الْقَاضِي (al-qāḍī, el juez) pasó al español como la «ld» de «alcalde».',
    englishPhoneticTip:
        'Deep emphatic "ḍ" (Arabic is poetically called "the language of Ḍād"). In الْقَاضِي (al-qāḍī, judge), it evolved into Spanish "alcalde" (mayor).',
    exampleArabic: 'مِنْ فَضْلِك / الْقَاضِي',
    exampleTranslit: 'min faḍlik / al-qāḍī',
    exampleMeaningEsEn: 'por favor / el juez (alcalde) • please / the judge',
    strokeWaypoints: [
      [
        Offset(0.58, 0.52),
        Offset(0.78, 0.40),
        Offset(0.84, 0.54),
        Offset(0.58, 0.56),
        Offset(0.48, 0.74),
        Offset(0.24, 0.72),
        Offset(0.20, 0.56),
      ],
    ],
    dotOffsets: [
      Offset(0.70, 0.24),
    ],
  ),
  ArabicLetterLesson(
    letter: 'ط',
    nameArabic: 'طَاء',
    nameTranslit: 'Ṭā’',
    forms: {
      'isolated': 'ط',
      'initial': 'طـ',
      'medial': 'ـطـ',
      'final': 'ـط',
    },
    isNonConnector: false,
    sunOrMoon: 'sun',
    spanishPhoneticTip:
        'Una «t» rotunda y sin aire que resuena en el paladar. De طَاسَة (ṭāsa) viene nuestra palabra «taza», y la usamos en مَطَار (maṭār = aeropuerto) y مَبْسُوط (mabsūṭ = feliz).',
    englishPhoneticTip:
        'Deep, unaspirated emphatic "ṭ". Gives Spanish/English "taza / cup" from طَاسَة (ṭāsa), plus مَطَار (maṭār = airport) and مَبْسُوط (mabsūṭ = happy).',
    exampleArabic: 'طَاسَة / مَطَار / مَبْسُوط',
    exampleTranslit: 'ṭāsa / maṭār / mabsūṭ',
    exampleMeaningEsEn: 'taza / aeropuerto / feliz • cup / airport / happy',
    strokeWaypoints: [
      [
        Offset(0.52, 0.62),
        Offset(0.78, 0.46),
        Offset(0.82, 0.62),
        Offset(0.24, 0.62),
      ],
      [
        Offset(0.54, 0.20),
        Offset(0.54, 0.60),
      ],
    ],
  ),
  ArabicLetterLesson(
    letter: 'ظ',
    nameArabic: 'ظَاء',
    nameTranslit: 'Ẓā’',
    forms: {
      'isolated': 'ظ',
      'initial': 'ظـ',
      'medial': 'ـظـ',
      'final': 'ـظ',
    },
    isNonConnector: false,
    sunOrMoon: 'sun',
    spanishPhoneticTip:
        'Hermana enfática de ذ (con 1 punto junto al mástil de ط). En Egipto y el Levante suele pronunciarse como una «z» profunda (بِالظَّبْط bi-ẓ-ẓabṭ = ¡exactamente!).',
    englishPhoneticTip:
        'Emphatic voiced "ẓ / dh" with 1 dot beside the mast of ط. Heard constantly in Cairo & Beirut in بِالظَّبْط (bi-ẓ-ẓabṭ = "exactly!").',
    exampleArabic: 'حَظّ سَعِيد / بِالظَّبْط',
    exampleTranslit: 'ḥaẓẓ sa‘īd / bi-ẓ-ẓabṭ',
    exampleMeaningEsEn: 'buena suerte / ¡exactamente! • good luck / exactly!',
    strokeWaypoints: [
      [
        Offset(0.52, 0.64),
        Offset(0.78, 0.48),
        Offset(0.82, 0.64),
        Offset(0.24, 0.64),
      ],
      [
        Offset(0.54, 0.22),
        Offset(0.54, 0.62),
      ],
    ],
    dotOffsets: [
      Offset(0.70, 0.30),
    ],
  ),
];

/// 12 High-Impact Al-Andalus Spanish-Arabic Cognates that give Spanish & English
/// speakers an instant head start in Arabic vocabulary and Sun/Moon letter rules.
final List<ArabicWordToken> kSpanishArabicCognates = const [
  ArabicWordToken(
    arabic: 'السُّكَّر',
    unvocalized: 'السكر',
    transliteration: 'as-sukkar -> azúcar',
    spanishMeaning: 'azúcar',
    englishMeaning: 'sugar',
    spanishBridgeNote:
        '¡Secreto de las Letras Solares! La «س» (s) es Letra Solar: absorbe la «l» de «al-» (as-sukkar), por eso en español decimos «azúcar» sin «L».',
    rootLetters: 'س-ك-ر',
    dialectVariants: {
      'MSA': 'السُّكَّر (as-sukkar)',
      'Cairo': 'سُكَّر (sukkar)',
      'Beirut': 'سُكَّر (sukkar)',
      'Dubai': 'سُكَّر / شَكَر (sukkar / shakar)',
    },
  ),
  ArabicWordToken(
    arabic: 'الزَّيْت',
    unvocalized: 'الزيت',
    transliteration: 'az-zayt -> aceite',
    spanishMeaning: 'aceite',
    englishMeaning: 'oil / olive oil',
    spanishBridgeNote:
        '¡Otra Letra Solar! La «ز» (z) asimila la «l» de «al-» (az-zayt -> aceite), demostrando en tu propio idioma cómo funcionan las Letras Solares.',
    rootLetters: 'ز-ي-ت',
    dialectVariants: {
      'MSA': 'الزَّيْت (az-zayt)',
      'Cairo': 'زِيت (zēt)',
      'Beirut': 'زَيْت (zayt)',
      'Dubai': 'زَيْت (zayt)',
    },
  ),
  ArabicWordToken(
    arabic: 'الْمِخَدَّة',
    unvocalized: 'المخدة',
    transliteration: 'al-mikhadda -> almohada',
    spanishMeaning: 'almohada',
    englishMeaning: 'pillow / cushion',
    spanishBridgeNote:
        '¡Secreto de las Letras Lunares! La «م» (m) es Letra Lunar: conserva intacta la «l» de «al-», por eso en español decimos «al-mohada» con «L» sonora.',
    rootLetters: 'خ-د-د',
    dialectVariants: {
      'MSA': 'الْمِخَدَّة (al-mikhadda)',
      'Cairo': 'مَخَدَّة (makhadda)',
      'Beirut': 'مَخَدَّة (makhadde)',
    },
  ),
  ArabicWordToken(
    arabic: 'إِنْ شَاءَ اللّٰه',
    unvocalized: 'إن شاء الله',
    transliteration: 'in shā’a Allāh -> ¡ojalá!',
    spanishMeaning: '¡ojalá! / si Dios quiere (esperemos que sí)',
    englishMeaning: 'hopefully! / God willing',
    spanishBridgeNote:
        'La expresión cotidiana más famosa del mundo árabe vive en el corazón del español como «¡ojalá!».',
    rootLetters: 'ش-ي-أ',
    dialectVariants: {
      'MSA': 'إِنْ شَاءَ اللّٰه (in shā’a Allāh)',
      'Cairo': 'إِنْ شَاءَ اللّٰه (inshā’Allāh)',
      'Beirut': 'إِنْ شَاءَ اللّٰه (nshāllah)',
      'Dubai': 'إِنْ شَاءَ اللّٰه (inshāllah)',
    },
  ),
  ArabicWordToken(
    arabic: 'حَتَّى',
    unvocalized: 'حتى',
    transliteration: 'ḥattā -> hasta',
    spanishMeaning: 'hasta / incluso',
    englishMeaning: 'until / even',
    spanishBridgeNote:
        'La preposición árabe «حَتَّى» (ḥattā) pasó directamente al español medieval y moderno como «hasta».',
    dialectVariants: {
      'MSA': 'حَتَّى (ḥattā)',
      'Cairo': 'حَتَّى (ḥattā)',
      'Beirut': 'حَتَّى (ḥattā)',
      'Dubai': 'حَتَّى (ḥattā)',
    },
  ),
  ArabicWordToken(
    arabic: 'الْقَاضِي',
    unvocalized: 'القاضي',
    transliteration: 'al-qāḍī -> alcalde',
    spanishMeaning: 'el juez / el alcalde',
    englishMeaning: 'the judge / mayor (Spanish "alcalde")',
    spanishBridgeNote:
        'La «ق» (q) es Letra Lunar (conserva «al-») y la «ض» (ḍ) enfática evolucionó en romance a «ld»: al-qāḍī -> alcalde.',
    rootLetters: 'ق-ض-ي',
    dialectVariants: {
      'MSA': 'الْقَاضِي (al-qāḍī)',
      'Cairo': 'الْقَاضِي (el-’āḍī)',
    },
  ),
  ArabicWordToken(
    arabic: 'الْبَرِّيّ',
    unvocalized: 'البري',
    transliteration: 'al-barriyy -> barrio',
    spanishMeaning: 'barrio / vecindario exterior',
    englishMeaning: 'neighborhood / district (Spanish "barrio")',
    spanishBridgeNote:
        'Con la «ب» (b) y la «ر» vibrante con shadda (ّ), «بَرِّيّ» suena casi idéntico a nuestro «barrio».',
    rootLetters: 'ب-ر-ر',
  ),
  ArabicWordToken(
    arabic: 'قَمِيص',
    unvocalized: 'قميص',
    transliteration: 'qamīṣ -> camisa',
    spanishMeaning: 'camisa',
    englishMeaning: 'shirt',
    spanishBridgeNote:
        'Une la «ق» inicial, la «م» con vocal larga «ī» y la «ص» enfática final: ¡قَمِيص (qamīṣ) es «camisa»!',
    rootLetters: 'ق-م-ص',
    dialectVariants: {
      'MSA': 'قَمِيص (qamīṣ)',
      'Cairo': 'قَمِيص (’amīṣ)',
      'Beirut': 'قَمِيص (’amīṣ)',
    },
  ),
  ArabicWordToken(
    arabic: 'طَاسَة',
    unvocalized: 'طاسة',
    transliteration: 'ṭāsa -> taza',
    spanishMeaning: 'taza / cuenco',
    englishMeaning: 'cup / mug / bowl',
    spanishBridgeNote:
        'Del árabe «طَاسَة» (ṭāsa) nació el español «taza» (y el francés «tasse»).',
    rootLetters: 'ط-و-س',
  ),
  ArabicWordToken(
    arabic: 'لَيْمُون',
    unvocalized: 'ليمون',
    transliteration: 'laymūn -> limón',
    spanishMeaning: 'limón',
    englishMeaning: 'lemon / lime',
    spanishBridgeNote:
        'Todas sus consonantes (ل-ي-م-و-ن) son transparentes en español e inglés: «laymūn» -> «limón / lemon».',
    dialectVariants: {
      'MSA': 'لَيْمُون (laymūn)',
      'Cairo': 'لَمُون (lamūn)',
      'Beirut': 'لَيْمُون (laymūn)',
    },
  ),
  ArabicWordToken(
    arabic: 'صِفْر',
    unvocalized: 'صفر',
    transliteration: 'ṣifr -> cero / cifra',
    spanishMeaning: 'cero / cifra',
    englishMeaning: 'zero / cipher',
    spanishBridgeNote:
        'Los matemáticos árabes llamaron al vacío numérico «صِفْر» (ṣifr), que dio al mundo tanto «cifra» como «cero / zero».',
    rootLetters: 'ص-ف-ر',
    dialectVariants: {
      'MSA': 'صِفْر (ṣifr)',
      'Cairo': 'صِفْر (ṣifr)',
      'Beirut': 'صِفْر (ṣifir)',
      'Dubai': 'صِفْر (ṣifir)',
    },
  ),
  ArabicWordToken(
    arabic: 'قِيثَارَة',
    unvocalized: 'قيثارة',
    transliteration: 'qīthāra -> guitarra',
    spanishMeaning: 'guitarra',
    englishMeaning: 'guitar',
    spanishBridgeNote:
        'A través de la música de Al-Ándalus, «قِيثَارَة» (qīthāra) dio nombre a la «guitarra» española.',
  ),
];

/// The 10 high-frequency MSA Subtitle <-> Spoken Dialect Bridge Pairs that unlock
/// watching Arabic YouTube vlogs, cinema, and TV broadcasts with MSA subtitles.
final List<Map<String, String>> kSubtitleBridgePairs = const [
  {
    'msa': 'أُرِيدُ',
    'msaUnvocalized': 'أريد',
    'msaTranslit': 'urīdu',
    'spoken': 'بَدِّي / عَايِز / أَبْغِي',
    'spokenTranslit': 'baddī (LB) • ‘āyiz/‘āyza (EG) • abghī (AE)',
    'cairo': 'عَايِز / عَايْزَة (‘āyiz / ‘āyza)',
    'beirut': 'بَدِّي (baddī)',
    'dubai': 'أَبْغِي (abghī)',
    'meaningEs': 'Quiero / Me gustaría',
    'meaningEn': 'I want / I would like',
    'exampleMsa': 'أُرِيدُ قَهْوَةً الْآنَ',
    'exampleSpoken': 'بَدِّي قَهْوَة هَلَّق / عَايِز قَهْوَة دِلْوَقْتِي',
  },
  {
    'msa': 'مَاذَا',
    'msaUnvocalized': 'ماذا',
    'msaTranslit': 'mādhā',
    'spoken': 'شُو / إِيه',
    'spokenTranslit': 'shū (LB/AE) • ēh (EG)',
    'cairo': 'إِيه؟ (ēh?)',
    'beirut': 'شُو؟ (shū?)',
    'dubai': 'شُو / شِنُو؟ (shū / shinū?)',
    'meaningEs': '¿Qué?',
    'meaningEn': 'What?',
    'exampleMsa': 'مَاذَا تَشْرَبُ؟',
    'exampleSpoken': 'شُو بِتِشْرَب؟ / تِشْرَب إِيه؟',
  },
  {
    'msa': 'الْآنَ',
    'msaUnvocalized': 'الآن',
    'msaTranslit': 'al-āna',
    'spoken': 'هَلَّق / دِلْوَقْتِي / الْحِين',
    'spokenTranslit': 'halla’ (LB) • dilwa’tī (EG) • al-ḥīn (AE)',
    'cairo': 'دِلْوَقْتِي (dilwa’tī)',
    'beirut': 'هَلَّق (halla’)',
    'dubai': 'الْحِين (al-ḥīn)',
    'meaningEs': 'Ahora / En este momento',
    'meaningEn': 'Now / Right now',
    'exampleMsa': 'نَحْنُ فِي الْمَتْحَفِ الْآنَ',
    'exampleSpoken': 'إِحْنَا فِي الْمَتْحَف دِلْوَقْتِي / هَلَّق',
  },
  {
    'msa': 'هُنَا',
    'msaUnvocalized': 'هنا',
    'msaTranslit': 'hunā',
    'spoken': 'هُون / هِنَا',
    'spokenTranslit': 'hōn (LB) • hēna (EG) •ihnī (AE)',
    'cairo': 'هِنَا (hēna)',
    'beirut': 'هُون (hōn)',
    'dubai': 'اهْنِي / هِنَا (ihnī / hinā)',
    'meaningEs': 'Aquí',
    'meaningEn': 'Here',
    'exampleMsa': 'تَفَضَّلْ هُنَا مِنْ فَضْلِكَ',
    'exampleSpoken': 'عَلَى جَنَب هُون / اتْفَضَّل هِنَا',
  },
  {
    'msa': 'كَيْفَ',
    'msaUnvocalized': 'كيف',
    'msaTranslit': 'kayfa',
    'spoken': 'كِيف / إِزَّاي / شْلُون',
    'spokenTranslit': 'kīf (LB) • izzāy (EG) • shlōn (AE)',
    'cairo': 'إِزَّاي / إِزَّيِّك (izzāy / izzayyik)',
    'beirut': 'كِيف / كِيفِك (kīf / kīfik)',
    'dubai': 'شْلُون / شْلُونِك (shlōn / shlōnik)',
    'meaningEs': '¿Cómo?',
    'meaningEn': 'How?',
    'exampleMsa': 'كَيْفَ حَالُكِ الْيَوْمَ؟',
    'exampleSpoken': 'إِزَّيِّك النَّهَارْدَة؟ / كِيفِك الْيُوم؟ / شْلُونِك؟',
  },
  {
    'msa': 'أَيْنَ',
    'msaUnvocalized': 'أين',
    'msaTranslit': 'ayna',
    'spoken': 'وِين / فِين',
    'spokenTranslit': 'wēn (LB/AE) • fēn (EG)',
    'cairo': 'فِين؟ (fēn?)',
    'beirut': 'وِين؟ (wēn?)',
    'dubai': 'وِين؟ (wēn?)',
    'meaningEs': '¿Dónde?',
    'meaningEn': 'Where?',
    'exampleMsa': 'أَيْنَ السُّوقُ؟',
    'exampleSpoken': 'فِين السُّوق؟ / وِين السُّوق؟',
  },
  {
    'msa': 'لِمَاذَا',
    'msaUnvocalized': 'لماذا',
    'msaTranslit': 'limādhā',
    'spoken': 'لِيش / لِيه',
    'spokenTranslit': 'lēsh (LB/AE) • lēh (EG)',
    'cairo': 'لِيه؟ (lēh?)',
    'beirut': 'لِيش؟ (lēsh?)',
    'dubai': 'لِيش؟ (lēsh?)',
    'meaningEs': '¿Por qué?',
    'meaningEn': 'Why?',
    'exampleMsa': 'لِمَاذَا تَضْحَكُ؟',
    'exampleSpoken': 'بِتِضْحَك لِيه؟ / لِيش عَمْ تِضْحَك؟',
  },
  {
    'msa': 'كَثِيرًا / جِدًّا',
    'msaUnvocalized': 'كثيرا / جدا',
    'msaTranslit': 'kathīran / jiddan',
    'spoken': 'كْتِير / قَوِي / وَايِد',
    'spokenTranslit': 'ktīr (LB) • ’awī (EG) • wāyid (AE)',
    'cairo': 'قَوِي (’awī)',
    'beirut': 'كْتِير (ktīr)',
    'dubai': 'وَايِد (wāyid)',
    'meaningEs': 'Mucho / Muy',
    'meaningEn': 'Very / A lot',
    'exampleMsa': 'هٰذَا جَمِيلٌ جِدًّا!',
    'exampleSpoken': 'دَه جَمِيل قَوِي! / هَيْدَا حِلُو كْتِير! / زِين وَايِد!',
  },
  {
    'msa': 'أَذْهَبُ',
    'msaUnvocalized': 'أذهب',
    'msaTranslit': 'adhhabu',
    'spoken': 'بَرُوح / رَايِح',
    'spokenTranslit': 'b-arūḥ / rāyiḥ (EG/LB/AE)',
    'cairo': 'بَرُوح / رَايِح (barūḥ / rāyiḥ)',
    'beirut': 'بْرُوح / رَايِح (brūḥ / rāyiḥ)',
    'dubai': 'أَرُوح / سَايِر (arūḥ / sāyir)',
    'meaningEs': 'Voy / Estoy yendo',
    'meaningEn': 'I go / I am going',
    'exampleMsa': 'أَذْهَبُ إِلَى السِّينِمَا',
    'exampleSpoken': 'أَنَا رَايِح السِّينِمَا',
  },
  {
    'msa': 'لَيْسَ / لَا',
    'msaUnvocalized': 'ليس / لا',
    'msaTranslit': 'laysa / lā',
    'spoken': 'مِش / مُو / مَا ... ش',
    'spokenTranslit': 'mish (EG/LB) • mū (AE/LB) • mā ...-sh (EG)',
    'cairo': 'مِش / مَا ... ش (mish / mā ...-sh)',
    'beirut': 'مِش / مُو (mish / mū)',
    'dubai': 'مُو / مَا (mū / mā)',
    'meaningEs': 'No / No es',
    'meaningEn': 'Not / Is not',
    'exampleMsa': 'لَيْسَ بَعِيدًا مِنْ هُنَا',
    'exampleSpoken': 'مِش بَعِيد مِنْ هِنَا / مُو بَعِيد مِنْ هُون',
  },
];
