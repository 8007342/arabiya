// @trace spec:arabiya, spec:character-canon, spec:voice-canon, spec:curriculum-and-comics, spec:cloud-edge-sync
import 'dart:math' as math;
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/all_chapters.dart';
import '../flame/arabiya_comic_game.dart';
import '../models/comic_models.dart';
import '../services/progress_sync_service.dart';
import '../services/voice_service.dart';
import 'arabic_glyph_tracer.dart';
import 'notebook_drawer_sheet.dart';

const List<String> kBundledFontFallbacks = [
  'NotoSansArabic',
  'Amiri',
  'NotoEmoji',
  'NotoSans',
];

class ArabiyaApp extends StatelessWidget {
  const ArabiyaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTheme = ThemeData(
      useMaterial3: true,
      fontFamily: 'NotoSans',
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF276D69),
        primary: const Color(0xFF123E42),
        secondary: const Color(0xFFEC6F7B),
        surface: const Color(0xFFFDF8EE),
      ),
    );

    return MaterialApp(
      title: 'Arabiya • Tlatoāni & Covi',
      debugShowCheckedModeBanner: false,
      theme: baseTheme.copyWith(
        textTheme: baseTheme.textTheme.apply(
          fontFamily: 'NotoSans',
          fontFamilyFallback: kBundledFontFallbacks,
        ),
      ),
      home: const ArabiyaComicScreen(),
    );
  }
}

class ArabiyaComicScreen extends StatefulWidget {
  const ArabiyaComicScreen({super.key});

  @override
  State<ArabiyaComicScreen> createState() => _ArabiyaComicScreenState();
}

class _ArabiyaComicScreenState extends State<ArabiyaComicScreen>
    with SingleTickerProviderStateMixin {
  final ProgressSyncService _syncService = ProgressSyncService();
  final VoiceService _voiceService = VoiceService();
  final FocusNode _keyboardFocus = FocusNode();

  late ArabiyaComicGame _comicGame;
  late AnimationController _breathController;

  PlayerProgressState _progress = const PlayerProgressState();
  bool _isLoading = true;
  bool _showCoverOverlay = true;

  int _chapterIndex = 0;
  int _panelIndex = 0;

  bool _showPeekTranslation = false;
  bool _showExpandedBridgeNote = false;
  bool _showTracerOverlay = false;
  String? _rewindBannerMessage;
  String? _masterySuccessMessage;

  ComicChapterData get _currentChapter => kAllArabiyaChapters[_chapterIndex];

  bool get _isAtMasteryGate => _panelIndex >= _currentChapter.panels.length;

  ComicPanelData get _activePanel {
    if (_isAtMasteryGate) {
      return _currentChapter.panels.last;
    }
    return _currentChapter.panels[_panelIndex];
  }

  @override
  void initState() {
    super.initState();
    _comicGame = ArabiyaComicGame(
      currentPanel: kAllArabiyaChapters.first.panels.first,
      onCharacterTapped: () => _voiceService.speakPanel(_activePanel),
    );
    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat(reverse: true);
    _bootstrapState();
  }

  @override
  void dispose() {
    _breathController.dispose();
    _keyboardFocus.dispose();
    _voiceService.stop();
    super.dispose();
  }

  Future<void> _bootstrapState() async {
    await _syncService.initialize();
    if (!mounted) return;
    final loaded = _syncService.progress;
    final foundIdx = kAllArabiyaChapters.indexWhere(
      (c) => c.id == loaded.currentChapterId,
    );
    final chIdx = foundIdx >= 0 ? foundIdx : 0;
    final chapter = kAllArabiyaChapters[chIdx];
    final pIdx = loaded.currentPanelIndex.clamp(0, chapter.panels.length - 1);

    setState(() {
      _progress = loaded;
      _chapterIndex = chIdx;
      _panelIndex = pIdx;
      _showCoverOverlay = !_syncService.shouldSkipLanding;
      _isLoading = false;
    });
    _comicGame.updatePanel(_activePanel);
    if (!_showCoverOverlay && _voiceService.autoPlayEnabled) {
      _voiceService.speakPanel(_activePanel);
    }
  }

  Future<void> _persistCheckpoint() async {
    final next = _progress.copyWith(
      currentChapterId: _currentChapter.id,
      currentPanelIndex: _panelIndex,
      highestChapterIndex: math.max(_progress.highestChapterIndex, _chapterIndex),
    );
    setState(() {
      _progress = next;
    });
    await _syncService.saveProgress(next);
  }

  void _enterComicAndPlay() {
    _syncService.markJourneyStarted();
    setState(() {
      _showCoverOverlay = false;
    });
    _comicGame.updatePanel(_activePanel);
    _voiceService.speakPanel(_activePanel);
  }

  void _goToPanel(int newPanelIdx, {bool isRewind = false}) {
    setState(() {
      _panelIndex = newPanelIdx.clamp(0, _currentChapter.panels.length);
      _showPeekTranslation = false;
      _showExpandedBridgeNote = false;
      if (!isRewind) {
        _rewindBannerMessage = null;
      }
      _masterySuccessMessage = null;
    });
    _comicGame.updatePanel(_activePanel, isRewind: isRewind);
    if (!_isAtMasteryGate && _voiceService.autoPlayEnabled) {
      _voiceService.speakPanel(_activePanel);
    } else if (_isAtMasteryGate) {
      final firstCorrect = _currentChapter.challenge.options.firstWhere(
        (o) => o.isCorrect,
        orElse: () => _currentChapter.challenge.options.first,
      );
      _voiceService.speakArabicWord(
        firstCorrect.arabic,
        heroine: _currentChapter.heroine,
      );
    }
    _persistCheckpoint();
  }

  void _selectChapter(int index) {
    final clamped = index.clamp(0, kAllArabiyaChapters.length - 1);
    setState(() {
      _chapterIndex = clamped;
      _panelIndex = 0;
      _showPeekTranslation = false;
      _showExpandedBridgeNote = false;
      _rewindBannerMessage = null;
      _masterySuccessMessage = null;
    });
    _comicGame.updatePanel(_activePanel);
    if (_voiceService.autoPlayEnabled) {
      _voiceService.speakPanel(_activePanel);
    }
    _persistCheckpoint();
  }

  void _handleMasteryOptionSelected(MasteryOption option) {
    _voiceService.speakArabicWord(
      option.arabic,
      heroine: _currentChapter.heroine,
    );
    if (option.isCorrect) {
      final newLetters = <String>{
        ..._progress.unlockedLetters,
        ..._currentChapter.lettersUnlocked.map((l) => l.letter),
      }.toList();
      final newWords = <String>{
        ..._progress.masteredWords,
        ..._currentChapter.vocabularyUnlocked.map((w) => w.arabic),
        option.arabic,
      }.toList();
      final newChapters = <String>{
        ..._progress.completedChapters,
        _currentChapter.id,
      }.toList();
      final heroineKey = _currentChapter.heroine.name;
      final updatedAffinity = Map<String, int>.from(_progress.affinities);
      updatedAffinity[heroineKey] =
          (updatedAffinity[heroineKey] ?? 0) + _currentChapter.affinityReward;

      setState(() {
        _progress = _progress.copyWith(
          xp: _progress.xp + _currentChapter.xpReward,
          unlockedLetters: newLetters,
          masteredWords: newWords,
          completedChapters: newChapters,
          affinities: updatedAffinity,
        );
        _masterySuccessMessage = option.feedbackEs;
        _rewindBannerMessage = null;
      });
      _syncService.saveProgress(_progress);
    } else {
      // Rewind 2 panels so the story reinforces the lesson!
      _voiceService.playMacronEmojiBloop(isRewind: true);
      final rewindSteps = _currentChapter.challenge.rewindPanelsOnFail;
      final targetPanel = (_currentChapter.panels.length - rewindSteps).clamp(
        0,
        _currentChapter.panels.length - 1,
      );
      setState(() {
        _rewindBannerMessage = '⏪ ${option.feedbackEs}';
      });
      _goToPanel(targetPanel, isRewind: true);
    }
  }

  String _backdropAssetFor(SceneBackdropType backdrop) {
    return switch (backdrop) {
      SceneBackdropType.dxbAirport => 'assets/art/backdrops/dxb_airport.jpg',
      SceneBackdropType.dubaiCreekAbra =>
        'assets/art/backdrops/dubai_creek_abra.jpg',
      SceneBackdropType.alFahidiCafe =>
        'assets/art/backdrops/alfahidi_cafe.jpg',
      SceneBackdropType.calligraphyMuseum =>
        'assets/art/backdrops/calligraphy_museum.jpg',
      SceneBackdropType.jasmineBookshop =>
        'assets/art/backdrops/beirut_jasmine_cafe.jpg',
      SceneBackdropType.levantBusStreet =>
        'assets/art/backdrops/byblos_ruins.jpg',
      SceneBackdropType.rooftopLounge =>
        'assets/art/backdrops/amman_rooftop.jpg',
      SceneBackdropType.nileFelucca =>
        'assets/art/backdrops/cairo_nile_felucca.png',
      SceneBackdropType.cairoCinema =>
        'assets/art/backdrops/khan_el_khalili_cinema.jpg',
      SceneBackdropType.mediaTerrace =>
        'assets/art/backdrops/cairo_rooftop_watch_party.jpg',
    };
  }

  String _characterAssetFor(CharacterId id, {required bool isBlushing}) {
    return switch (id) {
      CharacterId.tlatoani => isBlushing
          ? 'assets/art/characters/tlatoani_blushing.png'
          : 'assets/art/characters/tlatoani.png',
      CharacterId.covi => 'assets/art/characters/covi.png',
      CharacterId.nur => 'assets/art/characters/nur.png',
      CharacterId.yasmin => 'assets/art/characters/yasmin.png',
      CharacterId.layla => 'assets/art/characters/layla.png',
      CharacterId.macron => 'assets/art/characters/macron.png',
    };
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (_showCoverOverlay) {
      if (event.logicalKey == LogicalKeyboardKey.enter ||
          event.logicalKey == LogicalKeyboardKey.space) {
        _enterComicAndPlay();
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowRight ||
        event.logicalKey == LogicalKeyboardKey.space) {
      if (!_isAtMasteryGate) {
        _goToPanel(_panelIndex + 1);
      }
      return KeyEventResult.handled;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      if (_panelIndex > 0) {
        _goToPanel(_panelIndex - 1);
      }
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF0E2A2F),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFFFD166)),
        ),
      );
    }

    final panel = _activePanel;
    final chapter = _currentChapter;

    return Focus(
      focusNode: _keyboardFocus,
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: Scaffold(
        backgroundColor: const Color(0xFF0B1D21),
        body: Stack(
          fit: StackFit.expand,
          children: [
            // 1. FULL-SCREEN COMPOSED ARTWORK BACKDROP LAYER (100vw x 100vh)
            _buildFullScreenBackdropLayer(panel),

            // 2. FULL-SCREEN FLAME ATMOSPHERIC STAGE (Sunbeams, RTL particles, Tillandsias)
            Positioned.fill(
              child: IgnorePointer(
                child: GameWidget(game: _comicGame),
              ),
            ),

            // 3. FULL-SCREEN COMPOSED CHARACTER CUTOUTS LAYER
            _buildComposedCharactersLayer(panel, chapter),

            // 4. MĀCRON ĀI EMOJI-ONLY SPEECH BUBBLE (Bottom-Right above mācron āi)
            _buildMacronEmojiBubble(panel),

            // 5. DIALOGUE SPEECH BUBBLE OR IN-SCENE STORY CHOICE MASTERY PANEL
            if (!_showCoverOverlay)
              if (_isAtMasteryGate)
                _buildInSceneMasteryOverlay(chapter)
              else
                _buildCharacterSpeechBubbleLayer(panel, chapter),

            // 6. OPTIONAL FLOATING CALLIGRAPHY TRACER SKETCHPAD INSET
            if (_showTracerOverlay &&
                !_showCoverOverlay &&
                chapter.lettersUnlocked.isNotEmpty)
              _buildFloatingTracerInset(chapter.lettersUnlocked.first),

            // 7. REWIND NOTIFICATION BANNER (when comic rewinds 2 panels)
            if (_rewindBannerMessage != null && !_showCoverOverlay)
              Positioned(
                top: 66,
                left: 20,
                right: 20,
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 680),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A1525).withValues(alpha: 0.94),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFFFB703),
                        width: 2,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black54,
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      _rewindBannerMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFFFFF8E7),
                        fontWeight: FontWeight.bold,
                        fontSize: 13.5,
                      ),
                    ),
                  ),
                ),
              ),

            // 8. MINIMAL TOP COMIC ISSUE HEADER & FLOATING PAGE TURN CORNERS
            if (!_showCoverOverlay) ...[
              _buildMinimalTopComicBar(chapter),
              if (!_isAtMasteryGate) _buildComicPageTurnControls(chapter),
            ],

            // 9. CINEMATIC COMIC COVER OVERLAY ON FIRST VISIT (Unlocks Web Audio on 1st click)
            if (_showCoverOverlay) _buildComicCoverSplash(chapter),
          ],
        ),
      ),
    );
  }

  Widget _buildFullScreenBackdropLayer(ComicPanelData panel) {
    final assetPath = _backdropAssetFor(panel.backdrop);
    final alignX = switch (panel.speaker) {
      CharacterId.tlatoani => -0.25,
      CharacterId.covi => -0.05,
      _ => 0.25,
    };

    return Positioned.fill(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 550),
        child: Container(
          key: ValueKey<String>(assetPath),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF102A32), Color(0xFF1E3C40), Color(0xFF0E1D21)],
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              AnimatedAlign(
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeOutCubic,
                alignment: Alignment(alignX, 0.0),
                child: Transform.scale(
                  scale: 1.05,
                  child: Image.asset(
                    assetPath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (_, _, _) => const SizedBox.expand(),
                  ),
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 0.95,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.42),
                    ],
                  ),
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.35),
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.55),
                    ],
                    stops: const [0.0, 0.16, 0.68, 1.0],
                  ),
                ),
              ),
              IgnorePointer(
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFFFFF8E7).withValues(alpha: 0.35),
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildComposedCharactersLayer(
    ComicPanelData panel,
    ComicChapterData chapter,
  ) {
    final isTlatoaniBlushing =
        panel.tlatoaniEmotion == EmotionState.blushing ||
            (panel.speaker == CharacterId.tlatoani &&
                panel.speakerEmotion == EmotionState.blushing);
    final hasHeroine = panel.presentCharacters.contains(chapter.heroine);

    return Positioned.fill(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final h = constraints.maxHeight;
          final charHeight = (h * 0.50).clamp(210.0, 440.0);
          final macronHeight = (h * 0.25).clamp(110.0, 210.0);

          return AnimatedBuilder(
            animation: _breathController,
            builder: (context, _) {
              final breath = math.sin(_breathController.value * math.pi);

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  // 1. TLATOĀNI (Left Stage — CDMX/Guadalajara/SoCal Pink Axolotl Sage)
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 450),
                    curve: Curves.easeOutBack,
                    left: w * 0.02,
                    bottom: -14 + breath * 5.0,
                    child: _buildCharacterCutout(
                      character: CharacterId.tlatoani,
                      assetPath: _characterAssetFor(
                        CharacterId.tlatoani,
                        isBlushing: isTlatoaniBlushing,
                      ),
                      height: charHeight,
                      isActiveSpeaker: panel.speaker == CharacterId.tlatoani,
                      isTeasingTilt: false,
                      badgeText: isTlatoaniBlushing ? '😳✨' : null,
                      onTap: () => _voiceService.speakPanel(panel),
                    ),
                  ),

                  // 2. COVI (Center-Left Stage — Ambiguous Rounded White Friend)
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 450),
                    curve: Curves.easeOutBack,
                    left: hasHeroine ? w * 0.27 : w * 0.44,
                    bottom: -18 + (1.0 - breath) * 5.0,
                    child: _buildCharacterCutout(
                      character: CharacterId.covi,
                      assetPath: _characterAssetFor(
                        CharacterId.covi,
                        isBlushing: false,
                      ),
                      height: charHeight * 0.92,
                      isActiveSpeaker: panel.speaker == CharacterId.covi,
                      isTeasingTilt: panel.coviEmotion == EmotionState.teasing,
                      badgeText:
                          panel.coviEmotion == EmotionState.teasing ? '😏' : null,
                      onTap: () => _voiceService.speakPanel(panel),
                    ),
                  ),

                  // 3. REGIONAL ARAB AXOLOTL HEROINE: NŪR / YĀSMĪN / LAYLĀ (Right Stage)
                  if (hasHeroine)
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOutBack,
                      right: w * 0.08,
                      bottom: -14 + breath * 4.5,
                      child: _buildCharacterCutout(
                        character: chapter.heroine,
                        assetPath: _characterAssetFor(
                          chapter.heroine,
                          isBlushing: false,
                        ),
                        height: charHeight * 1.03,
                        isActiveSpeaker: panel.speaker == chapter.heroine,
                        isTeasingTilt: false,
                        badgeText: '✨',
                        onTap: () => _voiceService.speakPanel(panel),
                      ),
                    ),

                  // 4. MĀCRON ĀI (Bottom-Right Corner — Silent Robot Companion)
                  Positioned(
                    right: 12,
                    bottom: 8 + (1.0 - breath) * 4.0,
                    child: GestureDetector(
                      onTap: () => _voiceService.playMacronEmojiBloop(),
                      child: Image.asset(
                        _characterAssetFor(
                          CharacterId.macron,
                          isBlushing: false,
                        ),
                        height: macronHeight,
                        fit: BoxFit.contain,
                        errorBuilder: (_, _, _) => const SizedBox.shrink(),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildCharacterCutout({
    required CharacterId character,
    required String assetPath,
    required double height,
    required bool isActiveSpeaker,
    required bool isTeasingTilt,
    required VoidCallback onTap,
    String? badgeText,
  }) {
    final scale = isActiveSpeaker ? 1.06 : 0.94;
    final opacity = isActiveSpeaker ? 1.0 : 0.86;
    final tiltAngle = isTeasingTilt ? 0.05 : 0.0;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutBack,
        child: AnimatedOpacity(
          opacity: opacity,
          duration: const Duration(milliseconds: 300),
          child: Transform.rotate(
            angle: tiltAngle,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Image.asset(
                  assetPath,
                  height: height,
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => SizedBox(
                    width: height * 0.7,
                    height: height,
                  ),
                ),
                if (badgeText != null)
                  Positioned(
                    top: 12,
                    right: 18,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8E7),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF141E24),
                          width: 2,
                        ),
                      ),
                      child: Text(
                        badgeText,
                        style: const TextStyle(
                          fontFamily: 'NotoEmoji',
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMacronEmojiBubble(ComicPanelData panel) {
    return Positioned(
      right: 22,
      bottom: 185,
      child: GestureDetector(
        onTap: () => _voiceService.playMacronEmojiBloop(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xFF102B2E).withValues(alpha: 0.94),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF62D6D1), width: 2.2),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black45,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                panel.macronEmojis,
                style: const TextStyle(
                  fontFamily: 'NotoEmoji',
                  fontFamilyFallback: kBundledFontFallbacks,
                  fontSize: 19,
                  letterSpacing: 2,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 26),
              child: CustomPaint(
                size: const Size(16, 10),
                painter: _BubbleTailPainter(
                  fillColor: const Color(0xFF102B2E),
                  borderColor: const Color(0xFF62D6D1),
                  tailAlignX: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  (String?, String) _splitSpeakerDialogue(ComicPanelData panel) {
    final raw = panel.dialogueText.trim();
    if (raw.contains(' — ')) {
      final parts = raw.split(' — ');
      final arabicPart = parts.first.trim();
      final rest = parts.sublist(1).join(' — ').replaceAll('"', '').trim();
      return (arabicPart, rest);
    }
    final isHeroine = panel.speaker == CharacterId.nur ||
        panel.speaker == CharacterId.yasmin ||
        panel.speaker == CharacterId.layla;
    if (isHeroine && panel.dialogueTranslation.isNotEmpty) {
      return (raw, panel.dialogueTranslation);
    }
    return (null, raw);
  }

  Widget _buildCharacterSpeechBubbleLayer(
    ComicPanelData panel,
    ComicChapterData chapter,
  ) {
    final (arabicHeader, mainSpeech) = _splitSpeakerDialogue(panel);

    final (speakerLabel, speakerAccent, tailAlignX, bubbleAlign) =
        switch (panel.speaker) {
      CharacterId.tlatoani => (
          'TLATOĀNI 🇲🇽 (CDMX • GDL • SoCal)',
          const Color(0xFFEC6F7B),
          0.18,
          Alignment.topLeft,
        ),
      CharacterId.covi => (
          'COVI 🇺🇸',
          const Color(0xFF3A7CA5),
          0.42,
          Alignment.topCenter,
        ),
      CharacterId.nur => (
          'NŪR • نُور 🇦🇪 (Dubái)',
          const Color(0xFFD4AF37),
          0.78,
          Alignment.topRight,
        ),
      CharacterId.yasmin => (
          'YĀSMĪN • يَاسْمِين 🇱🇧🇯🇴 (Levante)',
          const Color(0xFF2E8B57),
          0.78,
          Alignment.topRight,
        ),
      CharacterId.layla => (
          'LAYLĀ • لَيْلَى 🇪🇬 (El Cairo)',
          const Color(0xFFC85A32),
          0.78,
          Alignment.topRight,
        ),
      CharacterId.macron => (
          'mācron āi 🤖',
          const Color(0xFF62D6D1),
          0.85,
          Alignment.topRight,
        ),
    };

    return Positioned(
      top: 64,
      left: 20,
      right: 20,
      child: Align(
        alignment: bubbleAlign,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 650),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // MAIN GRAPHIC-NOVEL SPEECH BALLOON
              GestureDetector(
                onTap: () => _voiceService.speakPanel(panel),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFDF7).withValues(alpha: 0.96),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: const Color(0xFF141E24),
                      width: 3.0,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x99000000),
                        blurRadius: 0,
                        offset: Offset(5, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: speakerAccent,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color(0xFF141E24),
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              speakerLabel,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 11.5,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () => _voiceService.speakPanel(panel),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFE0C4),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.volume_up_rounded,
                                    size: 16,
                                    color: Color(0xFF123E42),
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Voz',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF123E42),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                          if (arabicHeader == null &&
                              panel.dialogueTranslation.isNotEmpty)
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              tooltip:
                                  'Peek ES/EN translation (only if needed)',
                              onPressed: () {
                                setState(() {
                                  _showPeekTranslation = !_showPeekTranslation;
                                });
                              },
                              icon: Icon(
                                Icons.translate_rounded,
                                size: 17,
                                color: _showPeekTranslation
                                    ? const Color(0xFF276D69)
                                    : const Color(0xFF9E9488),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      if (arabicHeader != null) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6ECDC),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: const Color(0xFFD4AF37),
                              width: 1.5,
                            ),
                          ),
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: Text(
                              arabicHeader,
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontFamily: 'Amiri',
                                fontFamilyFallback: kBundledFontFallbacks,
                                fontSize: 27,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF123E42),
                                height: 1.35,
                              ),
                            ),
                          ),
                        ),
                      ],

                      Text(
                        mainSpeech,
                        style: const TextStyle(
                          fontFamily: 'NotoSans',
                          fontFamilyFallback: kBundledFontFallbacks,
                          fontSize: 16.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A2126),
                          height: 1.42,
                        ),
                      ),

                      if (_showPeekTranslation &&
                          arabicHeader == null &&
                          panel.dialogueTranslation.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            panel.dialogueTranslation,
                            style: const TextStyle(
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                              color: Color(0xFF5C5349),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // SPEECH BUBBLE POINTER TAIL AIMED AT THE SPEAKING CHARACTER
              SizedBox(
                height: 22,
                child: CustomPaint(
                  painter: _BubbleTailPainter(
                    fillColor: const Color(0xFFFFFDF7),
                    borderColor: const Color(0xFF141E24),
                    tailAlignX: tailAlignX,
                  ),
                ),
              ),

              if (panel.arabicSpotlight != null)
                _buildInteractiveArabicSpotlightSeal(
                  panel.arabicSpotlight!,
                  chapter.heroine,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInteractiveArabicSpotlightSeal(
    ArabicWordToken word,
    CharacterId heroine,
  ) {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () {
          _voiceService.speakArabicWord(word.arabic, heroine: heroine);
          setState(() {
            _showExpandedBridgeNote = !_showExpandedBridgeNote;
          });
        },
        child: Container(
          margin: const EdgeInsets.only(top: 4),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF123E42).withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFFFD166), width: 2.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.volume_up_rounded,
                    color: Color(0xFFFFD166),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(
                      word.arabic,
                      style: const TextStyle(
                        fontFamily: 'Amiri',
                        fontFamilyFallback: kBundledFontFallbacks,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFD166),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      '${word.transliteration}  •  ${word.spanishMeaning} / ${word.englishMeaning}',
                      style: const TextStyle(
                        color: Color(0xFFFFF8E7),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    _showExpandedBridgeNote
                        ? Icons.expand_less_rounded
                        : Icons.info_outline_rounded,
                    color: const Color(0xFF62D6D1),
                    size: 17,
                  ),
                ],
              ),
              if (_showExpandedBridgeNote && word.spanishBridgeNote.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    '💡 ${word.spanishBridgeNote}',
                    style: const TextStyle(
                      color: Color(0xFFE4D4B5),
                      fontSize: 12.5,
                      height: 1.35,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingTracerInset(ArabicLetterLesson lesson) {
    return Positioned(
      bottom: 84,
      left: 20,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 430),
        child: Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              ArabicGlyphTracer(
                lesson: lesson,
                onSpeakLetter: () => _voiceService.speakArabicWord(
                  lesson.exampleArabic,
                  heroine: _currentChapter.heroine,
                ),
                onTraceCompleted: () {
                  final updated = <String>{
                    ..._progress.unlockedLetters,
                    lesson.letter,
                  }.toList();
                  setState(() {
                    _progress = _progress.copyWith(
                      xp: _progress.xp + 15,
                      unlockedLetters: updated,
                    );
                  });
                  _syncService.saveProgress(_progress);
                },
              ),
              Positioned(
                top: 6,
                right: 6,
                child: IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () => setState(() => _showTracerOverlay = false),
                  icon: const Icon(Icons.close_rounded),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInSceneMasteryOverlay(ComicChapterData chapter) {
    final challenge = chapter.challenge;
    return Positioned(
      top: 62,
      left: 20,
      right: 20,
      bottom: 20,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFDF7).withValues(alpha: 0.96),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFF141E24), width: 3.0),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xAA000000),
                    blurRadius: 0,
                    offset: Offset(6, 7),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF123E42),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '🎯 Mastery Gate • Cap. ${chapter.number}',
                          style: const TextStyle(
                            color: Color(0xFFFFD166),
                            fontWeight: FontWeight.bold,
                            fontSize: 12.5,
                          ),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () =>
                            _goToPanel(chapter.panels.length - 1),
                        icon: const Icon(Icons.arrow_back_rounded, size: 16),
                        label: const Text('Escena'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    challenge.promptEs,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF123E42),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...challenge.options.map(
                    (opt) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: InkWell(
                        onTap: () => _handleMasteryOptionSelected(opt),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6ECDC),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFF123E42),
                              width: 2.0,
                            ),
                          ),
                          child: Row(
                            children: [
                              IconButton.filledTonal(
                                visualDensity: VisualDensity.compact,
                                onPressed: () => _voiceService.speakArabicWord(
                                  opt.arabic,
                                  heroine: chapter.heroine,
                                ),
                                icon: const Icon(
                                  Icons.volume_up_rounded,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      opt.transliteration,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Color(0xFF123E42),
                                      ),
                                    ),
                                    Text(
                                      '${opt.meaningEs} • ${opt.meaningEn}',
                                      style: const TextStyle(
                                        fontSize: 12.5,
                                        color: Color(0xFF4A3F35),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Directionality(
                                textDirection: TextDirection.rtl,
                                child: Text(
                                  opt.arabic,
                                  style: const TextStyle(
                                    fontFamily: 'Amiri',
                                    fontFamilyFallback: kBundledFontFallbacks,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF123E42),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 6),
                  ArabicGlyphTracer(
                    lesson: challenge.traceLetter,
                    onSpeakLetter: () => _voiceService.speakArabicWord(
                      challenge.traceLetter.exampleArabic,
                      heroine: chapter.heroine,
                    ),
                    onTraceCompleted: () {},
                  ),

                  if (_masterySuccessMessage != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD8F3DC),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF276D69),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            '🌟 $_masterySuccessMessage',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF123E42),
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (_chapterIndex < kAllArabiyaChapters.length - 1)
                            FilledButton.icon(
                              onPressed: () =>
                                  _selectChapter(_chapterIndex + 1),
                              icon: const Icon(Icons.auto_stories_rounded),
                              label: Text(
                                'Siguiente Capítulo (${_chapterIndex + 2}/12) ▸',
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMinimalTopComicBar(ComicChapterData chapter) {
    final panelLabel = _isAtMasteryGate
        ? 'Reto Final'
        : 'Panel ${_panelIndex + 1}/${chapter.panels.length}';

    return Positioned(
      top: 12,
      left: 16,
      right: 16,
      child: Row(
        children: [
          InkWell(
            onTap: () => _showChapterSelectorModal(context),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xFF102B2E).withValues(alpha: 0.90),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFFFD166), width: 1.8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '📖 Cap. ${chapter.number}/12 · ${chapter.regionName} · $panelLabel',
                    style: const TextStyle(
                      color: Color(0xFFFFF8E7),
                      fontWeight: FontWeight.bold,
                      fontSize: 12.5,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Color(0xFFFFD166),
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),

          if (chapter.lettersUnlocked.isNotEmpty && !_isAtMasteryGate)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton.filledTonal(
                tooltip: 'Practicar trazo de caligrafía árabe (← RTL)',
                style: IconButton.styleFrom(
                  backgroundColor: _showTracerOverlay
                      ? const Color(0xFFFFD166)
                      : const Color(0xFF102B2E).withValues(alpha: 0.88),
                  foregroundColor: _showTracerOverlay
                      ? const Color(0xFF102B2E)
                      : const Color(0xFFFFF8E7),
                ),
                onPressed: () =>
                    setState(() => _showTracerOverlay = !_showTracerOverlay),
                icon: const Icon(Icons.gesture_rounded, size: 19),
              ),
            ),

          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () {
                setState(() {
                  _voiceService.isMuted = !_voiceService.isMuted;
                });
                if (!_voiceService.isMuted) {
                  _voiceService.speakPanel(_activePanel);
                } else {
                  _voiceService.stop();
                }
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF102B2E).withValues(alpha: 0.90),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _voiceService.isMuted
                        ? const Color(0xFFEC6F7B)
                        : const Color(0xFF62D6D1),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _voiceService.isMuted
                          ? Icons.volume_off_rounded
                          : Icons.volume_up_rounded,
                      color: const Color(0xFFFFD166),
                      size: 17,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      _voiceService.isMuted ? 'Silencio' : 'Auto-Voz',
                      style: const TextStyle(
                        color: Color(0xFFFFF8E7),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton.filledTonal(
              tooltip: 'Cuaderno de Tlatoāni (Abjad 28, Cognados, Voces)',
              style: IconButton.styleFrom(
                backgroundColor:
                    const Color(0xFF102B2E).withValues(alpha: 0.90),
                foregroundColor: const Color(0xFFFFD166),
              ),
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => TlatoaniNotebookSheet(
                    progress: _progress,
                    voiceService: _voiceService,
                  ),
                );
              },
              icon: const Icon(Icons.menu_book_rounded, size: 19),
            ),
          ),

          InkWell(
            onTap: () => _showCloudPassportDialog(context),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xFF102B2E).withValues(alpha: 0.90),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFF5FA88A),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.cloud_done_rounded,
                    color: Color(0xFF62D6D1),
                    size: 16,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${_progress.xp} XP',
                    style: const TextStyle(
                      color: Color(0xFFFFD166),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComicPageTurnControls(ComicChapterData chapter) {
    final isLastPanel = _panelIndex >= chapter.panels.length - 1;
    final nextLabel = isLastPanel ? 'Mastery Check ▸' : 'Siguiente / Next ▸';

    return Positioned(
      bottom: 16,
      left: 20,
      right: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_panelIndex > 0)
            FilledButton.tonalIcon(
              style: FilledButton.styleFrom(
                backgroundColor:
                    const Color(0xFF102B2E).withValues(alpha: 0.90),
                foregroundColor: const Color(0xFFFFF8E7),
                side: const BorderSide(color: Color(0xFF62D6D1), width: 1.5),
              ),
              onPressed: () => _goToPanel(_panelIndex - 1),
              icon: const Icon(Icons.chevron_left_rounded),
              label: const Text('Anterior'),
            )
          else
            const SizedBox(width: 10),

          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFFFD166),
              foregroundColor: const Color(0xFF102B2E),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              side: const BorderSide(color: Color(0xFF141E24), width: 2.2),
              elevation: 6,
            ),
            onPressed: () => _goToPanel(_panelIndex + 1),
            icon: const Icon(Icons.auto_stories_rounded, size: 18),
            label: Text(
              nextLabel,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComicCoverSplash(ComicChapterData chapter) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: _enterComicAndPlay,
        child: Container(
          color: const Color(0xFF0A1B20).withValues(alpha: 0.72),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Container(
              padding: const EdgeInsets.all(26),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFDF7),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: const Color(0xFF141E24), width: 3.5),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black87,
                    blurRadius: 0,
                    offset: Offset(8, 9),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF123E42),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'CÓMIC INTERACTIVO CON VOCES • ISSUE #1–#12',
                        style: TextStyle(
                          color: Color(0xFFFFD166),
                          fontWeight: FontWeight.bold,
                          fontSize: 11.5,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                        'العَرَبِيَّة مَعَ تْلَاتُوَانِي وَكُوفِي',
                        style: TextStyle(
                          fontFamily: 'Amiri',
                          fontFamilyFallback: kBundledFontFallbacks,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF123E42),
                        ),
                      ),
                    ),
                    const Text(
                      'ARABIYA',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF141E24),
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Acompaña a Tlatoāni (de CDMX y Guadalajara al sur de California 🇲🇽), Covi (🇺🇸) y mācron āi (🤖) por Dubái, Beirut, Amán y El Cairo junto a Nūr, Yāsmīn y Laylā.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.5,
                        color: Color(0xFF333B40),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFEC6F7B),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(
                            color: Color(0xFF141E24),
                            width: 2.5,
                          ),
                        ),
                        onPressed: _enterComicAndPlay,
                        icon: const Icon(Icons.volume_up_rounded),
                        label: const Text(
                          'Start Reading Now / Abrir Cómic con Voz ▸',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showChapterSelectorModal(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFFFDF8EE),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: kAllArabiyaChapters.length,
          itemBuilder: (ctx, idx) {
            final ch = kAllArabiyaChapters[idx];
            final isDone = _progress.completedChapters.contains(ch.id);
            final isCurrent = idx == _chapterIndex;
            return Card(
              color: isCurrent ? const Color(0xFFEFE0C4) : Colors.white,
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                onTap: () {
                  Navigator.of(ctx).pop();
                  _selectChapter(idx);
                },
                leading: CircleAvatar(
                  backgroundColor: isDone
                      ? const Color(0xFF276D69)
                      : const Color(0xFF123E42),
                  child: Text(
                    '${ch.number}',
                    style: const TextStyle(
                      color: Color(0xFFFFD166),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  '${ch.regionName} • ${ch.titleEs}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${ch.titleArabic} — ${ch.subtitle}',
                  style: const TextStyle(
                    fontFamily: 'NotoSans',
                    fontFamilyFallback: kBundledFontFallbacks,
                    fontSize: 12.5,
                  ),
                ),
                trailing: isDone
                    ? const Icon(
                        Icons.verified_rounded,
                        color: Color(0xFF276D69),
                      )
                    : const Icon(Icons.chevron_right_rounded),
              ),
            );
          },
        );
      },
    );
  }

  void _showCloudPassportDialog(BuildContext context) {
    final emailCtrl = TextEditingController(
      text: _syncService.user?.email ?? 'tlatoani@tlatoani.net',
    );
    final nameCtrl = TextEditingController(
      text: _syncService.user?.displayName ?? 'Tlatoāni',
    );
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFFFDF8EE),
        title: const Text('☁️ Pasaporte en la Nube (arabiya.tlatoani.net)'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Guarda tu progreso, capítulos y afinidad con Nūr, Yāsmīn y Laylā en Cloudflare Durable Objects:',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(
                labelText: 'Email / Pasaporte',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cerrar'),
          ),
          FilledButton(
            onPressed: () async {
              await _syncService.signInWithPassport(
                handle: emailCtrl.text.trim(),
                displayName: nameCtrl.text.trim(),
              );
              if (mounted) {
                setState(() => _progress = _syncService.progress);
                if (ctx.mounted) Navigator.of(ctx).pop();
              }
            },
            child: const Text('Sincronizar en la Nube'),
          ),
        ],
      ),
    );
  }
}

class _BubbleTailPainter extends CustomPainter {
  final Color fillColor;
  final Color borderColor;
  final double tailAlignX;

  _BubbleTailPainter({
    required this.fillColor,
    required this.borderColor,
    required this.tailAlignX,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final halfBase = math.min(14.0, size.width * 0.35);
    final maxTip = math.max(halfBase, size.width - halfBase);
    final tipX = (size.width * tailAlignX).clamp(halfBase, maxTip);
    final baseLeft = math.max(0.0, tipX - halfBase);
    final baseRight = math.min(size.width, tipX + halfBase);

    final path = Path()
      ..moveTo(baseLeft, 0)
      ..lineTo(tipX, size.height)
      ..lineTo(baseRight, 0)
      ..close();

    canvas.drawPath(path, Paint()..color = fillColor);

    final borderPath = Path()
      ..moveTo(baseLeft, 0)
      ..lineTo(tipX, size.height)
      ..lineTo(baseRight, 0);
    canvas.drawPath(
      borderPath,
      Paint()
        ..color = borderColor
        ..strokeWidth = 3.0
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant _BubbleTailPainter oldDelegate) {
    return oldDelegate.tailAlignX != tailAlignX ||
        oldDelegate.fillColor != fillColor;
  }
}
