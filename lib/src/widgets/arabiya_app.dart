// @trace spec:arabiya, spec:character-canon, spec:voice-canon, spec:curriculum-and-comics, spec:cloud-edge-sync
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../data/all_chapters.dart';
import '../flame/arabiya_comic_game.dart';
import '../models/comic_models.dart';
import '../services/progress_sync_service.dart';
import '../services/voice_service.dart';
import 'arabic_glyph_tracer.dart';
import 'notebook_drawer_sheet.dart';

class ArabiyaApp extends StatefulWidget {
  final ProgressSyncService? syncService;
  final VoiceService? voiceService;

  const ArabiyaApp({
    super.key,
    this.syncService,
    this.voiceService,
  });

  @override
  State<ArabiyaApp> createState() => _ArabiyaAppState();
}

class _ArabiyaAppState extends State<ArabiyaApp> {
  late final ProgressSyncService _syncService;
  late final VoiceService _voiceService;
  late ArabiyaComicGame _comicGame;

  bool _initializing = true;
  bool _showLanding = true;
  int _chapterIndex = 0;
  int _panelIndex = 0;
  bool _inChallengeMode = false;
  bool _traceDoneInChallenge = false;
  String? _rewindBannerMessage;
  String? _challengeSuccessMessage;

  @override
  void initState() {
    super.initState();
    _syncService = widget.syncService ?? ProgressSyncService();
    _voiceService = widget.voiceService ?? VoiceService();
    _comicGame = ArabiyaComicGame(
      initialPanel: kAllArabiyaChapters.first.panels.first,
      onMacronTapped: () {
        _voiceService.playMacronEmojiBloop();
      },
      onSpotlightTapped: () {
        final spot = _currentPanel.arabicSpotlight;
        if (spot != null) {
          _voiceService.speakArabicWord(
            spot.arabic,
            heroine: _currentChapter.heroine,
          );
        }
      },
    );
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await _syncService.initialize();
    final saved = _syncService.progress;
    final foundIdx = kAllArabiyaChapters.indexWhere(
      (c) => c.id == saved.currentChapterId,
    );
    if (!mounted) return;
    setState(() {
      _chapterIndex = foundIdx >= 0 ? foundIdx : 0;
      final maxPanel = kAllArabiyaChapters[_chapterIndex].panels.length - 1;
      _panelIndex = saved.currentPanelIndex.clamp(0, maxPanel);
      _showLanding = !_syncService.shouldSkipLanding;
      _initializing = false;
      _comicGame.updatePanel(_currentPanel);
    });
  }

  ComicChapterData get _currentChapter => kAllArabiyaChapters[_chapterIndex];
  ComicPanelData get _currentPanel => _currentChapter.panels[_panelIndex];

  void _selectChapter(int newIndex) {
    final clamped = newIndex.clamp(0, kAllArabiyaChapters.length - 1);
    setState(() {
      _chapterIndex = clamped;
      _panelIndex = 0;
      _inChallengeMode = false;
      _traceDoneInChallenge = false;
      _rewindBannerMessage = null;
      _challengeSuccessMessage = null;
      _comicGame.updatePanel(_currentPanel);
    });
    _voiceService.speakPanel(_currentPanel);
    _persistCurrentPosition();
  }

  void _goToPanel(int nextPanelIdx, {bool isRewind = false}) {
    final panels = _currentChapter.panels;
    if (nextPanelIdx >= panels.length) {
      setState(() {
        _inChallengeMode = true;
        _traceDoneInChallenge = false;
        _challengeSuccessMessage = null;
      });
      _voiceService.speakArabicWord(
        _currentChapter.challenge.traceLetter.exampleArabic,
        heroine: _currentChapter.heroine,
      );
      return;
    }
    final clamped = nextPanelIdx.clamp(0, panels.length - 1);
    setState(() {
      _inChallengeMode = false;
      _panelIndex = clamped;
      if (!isRewind) {
        _rewindBannerMessage = null;
      }
      _comicGame.updatePanel(_currentPanel, isRewind: isRewind);
    });
    if (isRewind) {
      _voiceService.playMacronEmojiBloop(isRewind: true);
    } else {
      _voiceService.speakPanel(_currentPanel);
    }
    _persistCurrentPosition();
  }

  Future<void> _persistCurrentPosition() async {
    final cur = _syncService.progress;
    final next = cur.copyWith(
      currentChapterId: _currentChapter.id,
      currentPanelIndex: _panelIndex,
      highestChapterIndex: _chapterIndex > cur.highestChapterIndex
          ? _chapterIndex
          : cur.highestChapterIndex,
    );
    await _syncService.saveProgress(next);
  }

  Future<void> _handleOptionSelected(MasteryOption option) async {
    if (!option.isCorrect) {
      // Gamified Rewind: go back 2-3 panels so the story reinforces the learning!
      final rewindSteps = _currentChapter.challenge.rewindPanelsOnFail;
      final targetPanel = (_currentChapter.panels.length - rewindSteps)
          .clamp(0, _currentChapter.panels.length - 1);
      setState(() {
        _rewindBannerMessage =
            '⏪ ${option.feedbackEs}\n🇺🇸 ${option.feedbackEn}';
      });
      _goToPanel(targetPanel, isRewind: true);
      return;
    }

    // Correct answer! Unlock chapter letters, words, XP, and heroine affinity!
    _voiceService.speakArabicWord(
      option.arabic,
      heroine: _currentChapter.heroine,
    );
    final cur = _syncService.progress;
    final newLetters = <String>{
      ...cur.unlockedLetters,
      ..._currentChapter.lettersUnlocked.map((l) => l.letter),
    }.toList();
    final newWords = <String>{
      ...cur.masteredWords,
      ..._currentChapter.vocabularyUnlocked.map((w) => w.arabic),
    }.toList();
    final newCompleted = <String>{
      ...cur.completedChapters,
      _currentChapter.id,
    }.toList();
    final heroineKey = _currentChapter.heroine.name;
    final updatedAffinities = Map<String, int>.from(cur.affinities);
    updatedAffinities[heroineKey] =
        (updatedAffinities[heroineKey] ?? 0) + _currentChapter.affinityReward;

    final nextChapterIdx = (_chapterIndex + 1) < kAllArabiyaChapters.length
        ? _chapterIndex + 1
        : _chapterIndex;

    final updated = cur.copyWith(
      currentChapterId: kAllArabiyaChapters[nextChapterIdx].id,
      currentPanelIndex: 0,
      highestChapterIndex: nextChapterIdx > cur.highestChapterIndex
          ? nextChapterIdx
          : cur.highestChapterIndex,
      xp: cur.xp + _currentChapter.xpReward,
      completedChapters: newCompleted,
      unlockedLetters: newLetters,
      masteredWords: newWords,
      affinities: updatedAffinities,
    );

    await _syncService.saveProgress(updated);
    if (!mounted) return;
    setState(() {
      _challengeSuccessMessage =
          '🎉 ${option.feedbackEs}\n🇺🇸 ${option.feedbackEn}';
    });
  }

  void _openNotebook(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TlatoaniNotebookSheet(
        progress: _syncService.progress,
        voiceService: _voiceService,
      ),
    );
  }

  void _openPassportDialog(BuildContext context) {
    final handleCtrl = TextEditingController(
      text: _syncService.user?.email ?? '',
    );
    final nameCtrl = TextEditingController(
      text: _syncService.user?.displayName ?? '',
    );
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFFFDF8EE),
        title: const Row(
          children: [
            Text('☁️ '),
            Expanded(
              child: Text(
                'Cloud Passport • arabiya.tlatoani.net',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Guarda tu progreso en la nube (Cloudflare SQLite Durable Object) y continúa desde cualquier dispositivo sin fricción.',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: handleCtrl,
              decoration: const InputDecoration(
                labelText: 'Google Email or Traveler Handle',
                hintText: 'tlatoani@tlatoani.net',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Display Name (Optional)',
                hintText: 'Tlatoāni',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          if (_syncService.isAuthenticated)
            TextButton(
              onPressed: () async {
                await _syncService.signOut();
                if (!ctx.mounted) return;
                Navigator.of(ctx).pop();
                setState(() {});
              },
              child: const Text('Sign Out'),
            ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton.icon(
            onPressed: () async {
              final handle = handleCtrl.text.trim();
              if (handle.length < 2) return;
              await _syncService.signInWithPassport(
                handle: handle,
                displayName: nameCtrl.text.trim(),
              );
              if (!ctx.mounted) return;
              Navigator.of(ctx).pop();
              setState(() {
                _showLanding = false;
              });
            },
            icon: const Icon(Icons.cloud_done_rounded),
            label: const Text('Save & Sync Now'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arabiya • Tlatoāni, Covi & mācron āi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF276D69),
          primary: const Color(0xFF123E42),
          secondary: const Color(0xFFD4AF37),
          surface: const Color(0xFFFDF8EE),
        ),
        scaffoldBackgroundColor: const Color(0xFFF4E9D3),
        useMaterial3: true,
      ),
      home: Builder(
        builder: (innerContext) {
          if (_initializing) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (_showLanding) {
            return _buildLandingScreen(innerContext);
          }
          return _buildComicScreen(innerContext);
        },
      ),
    );
  }

  // Zero-Friction "Sign In To Resume" Landing Screen (auto-skipped for returning/authenticated users!)
  Widget _buildLandingScreen(BuildContext context) {
    final handleController = TextEditingController();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 880),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 250,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: const Color(0xFF123E42),
                        width: 3,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 16,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        GameWidget(game: _comicGame),
                        Positioned(
                          top: 12,
                          left: 14,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF123E42)
                                  .withValues(alpha: 0.88),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              '✨ Arabiya • Zero to One Playable Comic',
                              style: TextStyle(
                                color: Color(0xFFFFD166),
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDF8EE),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: const Color(0xFFD4AF37),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Row(
                          children: [
                            Expanded(
                              child: Text(
                                '¡Aprende Árabe desde Cero con Tlatoāni, Covi y mācron āi!',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF123E42),
                                ),
                              ),
                            ),
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: Text(
                                'العَرَبِيَّة',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF276D69),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '🇪🇸 Tlatoāni habla en español y descubre cómo ~4,000 palabras hispanas (azúcar, aceite, almohada, ojalá) abren las puertas del árabe.\n'
                          '🇺🇸 Covi speaks in English, teases Tlatoāni when he blushes around Nūr (نُور), Yāsmīn (يَاسْمِين), and Laylā (لَيْلَى), and practices every phrase with you.\n'
                          '🤖 mācron āi hangs out silently in the background with emoji-only clues!',
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.45,
                            color: Color(0xFF3D342E),
                          ),
                        ),
                        const SizedBox(height: 18),
                        FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF123E42),
                            foregroundColor: const Color(0xFFFFD166),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            textStyle: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () async {
                            await _syncService.markJourneyStarted();
                            setState(() {
                              _showLanding = false;
                            });
                            _voiceService.speakPanel(_currentPanel);
                          },
                          icon: const Icon(Icons.menu_book_rounded),
                          label: const Text(
                            '¡Entrar Directo al Cómic! / Start Reading Now →',
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 8),
                        const Text(
                          '☁️ Sign In to Resume (Sincroniza tu puntuación en arabiya.tlatoani.net)',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13.5,
                            color: Color(0xFF123E42),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: handleController,
                                decoration: const InputDecoration(
                                  hintText:
                                      'Google email or handle (e.g. tlatoani@tlatoani.net)',
                                  isDense: true,
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            FilledButton.tonalIcon(
                              onPressed: () async {
                                final handle = handleController.text.trim();
                                final effective = handle.isEmpty
                                    ? 'tlatoani@tlatoani.net'
                                    : handle;
                                await _syncService.signInWithPassport(
                                  handle: effective,
                                );
                                setState(() {
                                  _showLanding = false;
                                });
                                _voiceService.speakPanel(_currentPanel);
                              },
                              icon: const Icon(Icons.login_rounded),
                              label: const Text('Sign In & Resume'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildComicScreen(BuildContext context) {
    final chapter = _currentChapter;
    final progress = _syncService.progress;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 960),
            child: Column(
              children: [
                // 1. Top Comic Header Bar
                _buildTopHeaderBar(context, chapter, progress),

                // 2. Rewind notification banner (when rewound after a missed check)
                if (_rewindBannerMessage != null)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3CD),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFFFB703)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _rewindBannerMessage!,
                            style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF5C3D00),
                            ),
                          ),
                        ),
                        IconButton(
                          iconSize: 18,
                          onPressed: () =>
                              setState(() => _rewindBannerMessage = null),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),

                // 3. Main Content: either Animated Comic Panel + Dialogue OR Mastery Gate
                Expanded(
                  child: _inChallengeMode
                      ? _buildMasteryGateView(context, chapter)
                      : _buildActiveComicPanelView(context, chapter),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopHeaderBar(
    BuildContext context,
    ComicChapterData chapter,
    PlayerProgressState progress,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(
        color: Color(0xFF123E42),
        border: Border(
          bottom: BorderSide(color: Color(0xFFD4AF37), width: 2),
        ),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8,
        runSpacing: 6,
        children: [
          // Chapter Picker Dropdown Pill
          PopupMenuButton<int>(
            tooltip: 'Select Chapter / Seleccionar Capítulo',
            onSelected: _selectChapter,
            itemBuilder: (ctx) => [
              for (var i = 0; i < kAllArabiyaChapters.length; i++)
                PopupMenuItem<int>(
                  value: i,
                  child: Row(
                    children: [
                      Icon(
                        progress.completedChapters
                                .contains(kAllArabiyaChapters[i].id)
                            ? Icons.check_circle
                            : Icons.play_circle_outline,
                        size: 18,
                        color: const Color(0xFF276D69),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Ch ${kAllArabiyaChapters[i].number}: ${kAllArabiyaChapters[i].titleEs} (${kAllArabiyaChapters[i].regionName})',
                          style: TextStyle(
                            fontWeight: i == _chapterIndex
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF276D69),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFFFD166)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Ch ${chapter.number}/12 • ${chapter.regionName}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_drop_down,
                    color: Color(0xFFFFD166),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),

          // Heroine Affinity Badges (Nūr, Yāsmīn, Laylā) + XP + Notebook + Cloud
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _AffinityPill(
                label: 'Nūr',
                emoji: '✨',
                count: progress.affinities['nur'] ?? 0,
                isActive: chapter.heroine == CharacterId.nur,
              ),
              const SizedBox(width: 4),
              _AffinityPill(
                label: 'Yāsmīn',
                emoji: '🌼',
                count: progress.affinities['yasmin'] ?? 0,
                isActive: chapter.heroine == CharacterId.yasmin,
              ),
              const SizedBox(width: 4),
              _AffinityPill(
                label: 'Laylā',
                emoji: '🌙',
                count: progress.affinities['layla'] ?? 0,
                isActive: chapter.heroine == CharacterId.layla,
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD166),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  '⭐ ${progress.xp} XP',
                  style: const TextStyle(
                    color: Color(0xFF123E42),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              IconButton(
                tooltip: 'Cuaderno de Tlatoāni (Abjad, Cognados & Voces)',
                onPressed: () => _openNotebook(context),
                icon: const Text('📓', style: TextStyle(fontSize: 20)),
              ),
              IconButton(
                tooltip: _syncService.isAuthenticated
                    ? 'Cloud Synced: ${_syncService.user!.displayName}'
                    : 'Sign In to Cloud Passport',
                onPressed: () => _openPassportDialog(context),
                icon: Icon(
                  _syncService.isAuthenticated
                      ? Icons.cloud_done_rounded
                      : Icons.cloud_upload_outlined,
                  color: _syncService.isAuthenticated
                      ? const Color(0xFF62D6D1)
                      : Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActiveComicPanelView(
    BuildContext context,
    ComicChapterData chapter,
  ) {
    final panel = _currentPanel;
    final spot = panel.arabicSpotlight;
    final (speakerBadge, speakerColor) = switch (panel.speaker) {
      CharacterId.tlatoani => (
          '🦎 Tlatoāni (Español)',
          const Color(0xFF276D69),
        ),
      CharacterId.covi => ('🤍 Covi (English)', const Color(0xFF3D5A80)),
      CharacterId.nur => (
          '✨ Nūr • نُور (Dubai — Khalījī & Fuṣḥā)',
          const Color(0xFF1D3557),
        ),
      CharacterId.yasmin => (
          '🌼 Yāsmīn • يَاسْمِين (Levant — Shāmī & Fuṣḥā)',
          const Color(0xFF2D6A4F),
        ),
      CharacterId.layla => (
          '🌙 Laylā • لَيْلَى (Cairo — Maṣrī & Fuṣḥā)',
          const Color(0xFF6A1B9A),
        ),
      CharacterId.macron => ('🤖 mācron āi', const Color(0xFF102B2E)),
    };

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Animated Flame Comic Panel Stage
          SizedBox(
            height: 250,
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF123E42), width: 3),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned.fill(child: GameWidget(game: _comicGame)),

                  // Top-Left Chapter & Panel Plate (Tlatoāni Tales style!)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4E9D3).withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF2B2420)),
                      ),
                      child: Text(
                        '${chapter.titleEs} • Panel ${_panelIndex + 1}/${chapter.panels.length}',
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2B2420),
                        ),
                      ),
                    ),
                  ),

                  // Top-Right Dialect Badge
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF123E42).withValues(alpha: 0.90),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        chapter.dialectBadge,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFD166),
                        ),
                      ),
                    ),
                  ),

                  // Bottom-Left Trace Plate (@trace spec:curriculum-and-comics)
                  Positioned(
                    bottom: 8,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '[@trace ${chapter.id} • mācron: ${panel.macronEmojis}]',
                        style: const TextStyle(
                          color: Color(0xFF62D6D1),
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          // 2. Dialogue Speech Bubble Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFDF8EE),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: speakerColor, width: 2.2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: speakerColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        speakerBadge,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.5,
                        ),
                      ),
                    ),
                    const Spacer(),
                    FilledButton.tonalIcon(
                      onPressed: () => _voiceService.speakPanel(panel),
                      icon: const Icon(Icons.volume_up_rounded, size: 18),
                      label: const Text('Hear Voice'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  panel.dialogueText,
                  style: const TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E1B18),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  panel.dialogueTranslation,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFF5A4E44),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),

          // 3. Clickable Arabic Word & Al-Andalus Cognate Spotlight Card
          if (spot != null) ...[
            const SizedBox(height: 10),
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => _voiceService.speakArabicWord(
                spot.arabic,
                heroine: chapter.heroine,
              ),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF123E42), Color(0xFF1F5464)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFD4AF37),
                    width: 1.8,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${spot.transliteration}  •  🇪🇸 ${spot.spanishMeaning}  •  🇺🇸 ${spot.englishMeaning}',
                                style: const TextStyle(
                                  color: Color(0xFFFFD166),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              if (spot.rootLetters != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text(
                                    '🔑 Raíz / Root (Jadhr): ${spot.rootLetters}',
                                    style: const TextStyle(
                                      color: Color(0xFF62D6D1),
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: Text(
                            spot.arabic,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.volume_up_rounded,
                          color: Color(0xFFFFD166),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '💡 Puente Español–Árabe: ${spot.spanishBridgeNote}',
                      style: const TextStyle(
                        color: Color(0xFFF4E9D3),
                        fontSize: 12.5,
                        height: 1.35,
                      ),
                    ),
                    if (spot.dialectVariants.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: spot.dialectVariants.entries
                            .map(
                              (e) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black26,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${e.key.toUpperCase()}: ${e.value}',
                                  style: const TextStyle(
                                    color: Color(0xFF62D6D1),
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],

          // 4. Cultural Etiquette / Story Note (if present)
          if (panel.culturalNote != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFEFE0C4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '🕌 Cultura y Cortesía Árabe: ${panel.culturalNote}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF3D342E),
                ),
              ),
            ),
          ],

          const SizedBox(height: 12),

          // 5. Bottom Comic Navigation Controls
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: _panelIndex > 0
                    ? () => _goToPanel(_panelIndex - 1)
                    : null,
                icon: const Icon(Icons.arrow_back_rounded),
                label: const Text('Anterior / Prev'),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 0; i < chapter.panels.length; i++)
                      GestureDetector(
                        onTap: () => _goToPanel(i),
                        child: Container(
                          width: i == _panelIndex ? 22 : 9,
                          height: 9,
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          decoration: BoxDecoration(
                            color: i == _panelIndex
                                ? const Color(0xFF123E42)
                                : const Color(0xFFC9A04B),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF123E42),
                  foregroundColor: const Color(0xFFFFD166),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                ),
                onPressed: () => _goToPanel(_panelIndex + 1),
                icon: Icon(
                  _panelIndex == chapter.panels.length - 1
                      ? Icons.verified_rounded
                      : Icons.arrow_forward_rounded,
                ),
                label: Text(
                  _panelIndex == chapter.panels.length - 1
                      ? '¡Reto del Capítulo! / Mastery Check'
                      : 'Siguiente / Next ▶',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMasteryGateView(
    BuildContext context,
    ComicChapterData chapter,
  ) {
    final challenge = chapter.challenge;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              TextButton.icon(
                onPressed: () => _goToPanel(chapter.panels.length - 1),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back to Comic Panels'),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF123E42),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Chapter ${chapter.number} Mastery Gate (+${chapter.xpReward} XP)',
                  style: const TextStyle(
                    color: Color(0xFFFFD166),
                    fontWeight: FontWeight.bold,
                    fontSize: 12.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Step 1: Interactive Right-to-Left Arabic Glyph Tracer
          ArabicGlyphTracer(
            lesson: challenge.traceLetter,
            onSpeakLetter: () => _voiceService.speakArabicWord(
              challenge.traceLetter.exampleArabic,
              heroine: chapter.heroine,
            ),
            onTraceCompleted: () {
              setState(() {
                _traceDoneInChallenge = true;
              });
            },
          ),

          const SizedBox(height: 14),

          // Step 2: Dialogue & Cultural Validation Question
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFDF8EE),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFF123E42), width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '🎭 Escena: ${challenge.scenarioContext}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF276D69),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '🦎 Tlatoāni: ${challenge.promptEs}',
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF123E42),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '🤍 Covi: ${challenge.promptEn}',
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFF5A4E44),
                  ),
                ),
                const SizedBox(height: 12),
                ...challenge.options.map(
                  (opt) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(14),
                        alignment: Alignment.centerLeft,
                        backgroundColor: Colors.white,
                        side: const BorderSide(
                          color: Color(0xFF276D69),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () => _handleOptionSelected(opt),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  opt.transliteration,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF123E42),
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  '🇪🇸 ${opt.meaningEs} • 🇺🇸 ${opt.meaningEn}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF4A3F35),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: Text(
                              opt.arabic,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF276D69),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (!_traceDoneInChallenge)
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      '💡 Tip: Trace the Arabic letter above (or tap "Demo & Complete Stroke") and choose the best Arabic response!',
                      style: TextStyle(fontSize: 11.5, color: Color(0xFF6B5E52)),
                    ),
                  ),
                if (_challengeSuccessMessage != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD8F3DC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFF2D6A4F)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          _challengeSuccessMessage!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1B4332),
                          ),
                        ),
                        const SizedBox(height: 10),
                        FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF123E42),
                            foregroundColor: const Color(0xFFFFD166),
                          ),
                          onPressed: () {
                            if (_chapterIndex + 1 < kAllArabiyaChapters.length) {
                              _selectChapter(_chapterIndex + 1);
                            } else {
                              _openNotebook(context);
                            }
                          },
                          icon: const Icon(Icons.celebration_rounded),
                          label: Text(
                            _chapterIndex + 1 < kAllArabiyaChapters.length
                                ? 'Continuar al Capítulo ${_chapterIndex + 2} / Next Chapter →'
                                : '¡Graduado Zero-to-One! Abrir Cuaderno de Tlatoāni 📓',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AffinityPill extends StatelessWidget {
  final String label;
  final String emoji;
  final int count;
  final bool isActive;

  const _AffinityPill({
    required this.label,
    required this.emoji,
    required this.count,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF276D69) : Colors.black26,
        borderRadius: BorderRadius.circular(12),
        border: isActive
            ? Border.all(color: const Color(0xFFFFD166), width: 1.2)
            : null,
      ),
      child: Text(
        '$emoji $label ♥$count',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
