// @trace spec:arabiya, spec:character-canon, spec:voice-canon, spec:curriculum-and-comics, spec:cloud-edge-sync
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/all_chapters.dart';
import '../models/comic_models.dart';
import '../services/progress_sync_service.dart';
import '../services/voice_service.dart';
import 'comic_episode.dart';
import 'google_sign_in_button.dart';
import 'notebook_drawer_sheet.dart';
import 'stylus_playground.dart';

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
    final theme = ThemeData(
      useMaterial3: true,
      fontFamily: 'NotoSans',
      colorScheme: ColorScheme.fromSeed(
        seedColor: comicInk,
        primary: comicInk,
        secondary: comicGold,
        surface: comicPaper,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(56, 56),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(56, 56),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          textStyle: const TextStyle(fontSize: 24),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(56, 56),
          textStyle: const TextStyle(fontSize: 24),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(minimumSize: const Size(56, 56)),
      ),
    );
    return MaterialApp(
      title: 'Arabiya · A playable comic',
      debugShowCheckedModeBanner: false,
      theme: theme.copyWith(
        textTheme: theme.textTheme.apply(
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

class _ArabiyaComicScreenState extends State<ArabiyaComicScreen> {
  final _syncService = ProgressSyncService();
  final _voiceService = VoiceService();
  bool _loading = true;
  bool _archive = false;
  int _chapter = 0;
  int _panel = 0;
  double _textScale = 1;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _voiceService.stop();
    super.dispose();
  }

  Future<void> _load() async {
    await _syncService.initialize();
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    final progress = _syncService.progress;
    final chapter = kAllArabiyaChapters.indexWhere(
      (c) => c.id == progress.currentChapterId,
    );
    setState(() {
      _chapter = chapter < 0 ? 0 : chapter;
      _panel = progress.currentPanelIndex.clamp(
        0,
        kAllArabiyaChapters[_chapter].panels.length - 1,
      );
      _textScale = prefs.getDouble('arabiya.readerTextScale') == 1.4 ? 1.4 : 1;
      _loading = false;
    });
  }

  Future<void> _resizeText() async {
    setState(() => _textScale = _textScale == 1 ? 1.4 : 1);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('arabiya.readerTextScale', _textScale);
  }

  void _openPlay() {
    _voiceService.stop();
    Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (ctx) => StylusPlayground(
          onClose: () => Navigator.of(ctx).pop(),
          onEvidence: _syncService.recordWritingEvidence,
          evidence: _syncService.progress.writingEvidence,
        ),
      ),
    );
  }

  Future<void> _saveEpisodeBeat(int index) async {
    await _syncService.saveProgress(
      _syncService.progress.copyWith(doorEpisodeBeat: index),
    );
  }

  void _readChapter(int index) {
    _voiceService.stop();
    setState(() {
      _chapter = index;
      _panel = 0;
      _archive = true;
    });
    _saveReading();
  }

  void _turnArchive(int panel) {
    _voiceService.stop();
    setState(() => _panel = panel);
    _voiceService.speakPanel(kAllArabiyaChapters[_chapter].panels[_panel]);
    _saveReading();
  }

  Future<void> _saveReading() async {
    await _syncService.markJourneyStarted();
    final latest = _syncService.progress;
    await _syncService.saveProgress(
      latest.copyWith(
        currentChapterId: kAllArabiyaChapters[_chapter].id,
        currentPanelIndex: _panel,
        highestChapterIndex: _chapter > latest.highestChapterIndex
            ? _chapter
            : latest.highestChapterIndex,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: comicInk,
        body: Center(child: CircularProgressIndicator(color: comicGold)),
      );
    }
    if (_archive) {
      return _ArchiveReader(
        chapter: kAllArabiyaChapters[_chapter],
        panelIndex: _panel,
        textScale: _textScale,
        voice: _voiceService,
        onTurn: _turnArchive,
        onArchive: _showArchive,
        onTextSize: _resizeText,
        onClose: () {
          _voiceService.stop();
          setState(() => _archive = false);
        },
        onPlay: _openPlay,
      );
    }
    return ComicEpisode(
      voice: _voiceService,
      initialBeat: _syncService.progress.doorEpisodeBeat,
      writingEvidence: _syncService.progress.writingEvidence,
      onBeatChanged: _saveEpisodeBeat,
      signInButton: _syncService.isAuthenticated
          ? null
          : GoogleSignInButton(onSignedIn: _finishGoogleSignIn),
      onArchive: _showArchive,
      onAccount: _showAccount,
      onPlay: _openPlay,
      onNotebook: _showNotebook,
      textScale: _textScale,
      onTextSize: _resizeText,
      onEvidence: _syncService.recordWritingEvidence,
    );
  }

  void _showArchive() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: comicPaper,
      builder: (ctx) => FractionallySizedBox(
        heightFactor: .94,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'The story archive',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Close archive',
                    onPressed: () => Navigator.pop(ctx),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                children: [
                  const Text(
                    'Revisit a scene. Follow a conversation. No quiz required.',
                    style: TextStyle(fontSize: 24, height: 1.4),
                  ),
                  const SizedBox(height: 18),
                  FilledButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      setState(() => _archive = false);
                    },
                    icon: const Icon(Icons.movie_outlined),
                    label: const Text('The Door That Won’t Cooperate'),
                  ),
                  const SizedBox(height: 20),
                  for (var i = 0; i < kAllArabiyaChapters.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          _readChapter(i);
                        },
                        style: OutlinedButton.styleFrom(
                          alignment: Alignment.centerLeft,
                          backgroundColor: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${i + 1} · ${kAllArabiyaChapters[i].regionName}',
                                style: const TextStyle(fontSize: 24),
                              ),
                              Text(
                                kAllArabiyaChapters[i].titleEn,
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                kAllArabiyaChapters[i].titleArabic,
                                textDirection: TextDirection.rtl,
                                style: const TextStyle(
                                  fontFamily: 'Amiri',
                                  fontSize: 48,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNotebook() => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => TlatoaniNotebookSheet(
      progress: _syncService.progress,
      voiceService: _voiceService,
    ),
  );

  Future<void> _finishGoogleSignIn() async {
    await _syncService.completeGoogleSignIn();
    if (mounted) setState(() {});
  }

  void _showAccount() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: comicPaper,
        title: const Text(
          'Your saved adventure',
          style: TextStyle(fontSize: 32),
        ),
        content: SizedBox(
          width: 420,
          child: SingleChildScrollView(
            child: ListenableBuilder(
              listenable: _syncService,
              builder: (context, _) => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _syncService.saveStatus,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 20),
                  if (_syncService.isAuthenticated) ...[
                    Text(
                      _syncService.user!.displayName,
                      style: const TextStyle(fontSize: 28),
                    ),
                    TextButton(
                      onPressed: () async {
                        try {
                          await _syncService.signOut();
                          if (mounted) setState(() {});
                        } catch (_) {
                          if (ctx.mounted) {
                            ScaffoldMessenger.of(ctx).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Could not sign out. Check your connection and retry.',
                                  style: TextStyle(fontSize: 24),
                                ),
                              ),
                            );
                          }
                        }
                      },
                      child: const Text('Sign out'),
                    ),
                  ] else
                    GoogleSignInButton(
                      onSignedIn: () async {
                        await _finishGoogleSignIn();
                        if (ctx.mounted) Navigator.pop(ctx);
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

/// Legacy authored chapters remain readable; reading is not handwriting mastery.
class _ArchiveReader extends StatefulWidget {
  final ComicChapterData chapter;
  final int panelIndex;
  final double textScale;
  final VoiceService voice;
  final ValueChanged<int> onTurn;
  final VoidCallback onArchive;
  final VoidCallback onClose;
  final VoidCallback onTextSize;
  final VoidCallback onPlay;
  const _ArchiveReader({
    required this.chapter,
    required this.panelIndex,
    required this.textScale,
    required this.voice,
    required this.onTurn,
    required this.onArchive,
    required this.onClose,
    required this.onTextSize,
    required this.onPlay,
  });
  @override
  State<_ArchiveReader> createState() => _ArchiveReaderState();
}

class _ArchiveReaderState extends State<_ArchiveReader> {
  bool _translation = false;
  final _scroll = ScrollController();
  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _ArchiveReader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.panelIndex != widget.panelIndex ||
        oldWidget.chapter != widget.chapter) {
      _translation = false;
      if (_scroll.hasClients) _scroll.jumpTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final panel = widget.chapter.panels[widget.panelIndex];
    final arabic = panel.spokenLocale.startsWith('ar');
    return Scaffold(
      backgroundColor: comicInk,
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scroll,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    ComicIcon(
                      label: 'Back to opening episode',
                      icon: Icons.home_outlined,
                      onPressed: widget.onClose,
                    ),
                    Text(
                      'CHAPTER ${widget.chapter.number} · ${widget.panelIndex + 1}/${widget.chapter.panels.length}',
                      style: const TextStyle(color: comicPaper, fontSize: 24),
                    ),
                    Wrap(
                      children: [
                        ComicIcon(
                          label: 'Chapter archive',
                          icon: Icons.auto_stories_outlined,
                          onPressed: widget.onArchive,
                        ),
                        ComicIcon(
                          label: 'Change text size',
                          icon: Icons.text_increase,
                          onPressed: widget.onTextSize,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).width < 700 ? 300 : 420,
                child: ClipRect(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        _backdrop(panel.backdrop),
                        fit: BoxFit.cover,
                        excludeFromSemantics: true,
                      ),
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                comicInk.withValues(alpha: .7),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),
                      for (var i = 0; i < panel.presentCharacters.length; i++)
                        Align(
                          alignment: Alignment(
                            panel.presentCharacters.length == 1
                                ? 0
                                : -1 +
                                      2 *
                                          i /
                                          (panel.presentCharacters.length - 1),
                            1,
                          ),
                          child: FractionallySizedBox(
                            widthFactor: .4,
                            heightFactor:
                                panel.presentCharacters[i] == panel.speaker
                                ? 1
                                : .85,
                            child: Image.asset(
                              'assets/art/characters/${panel.presentCharacters[i].name}.png',
                              fit: BoxFit.contain,
                              alignment: Alignment.bottomCenter,
                              semanticLabel: panel.presentCharacters[i].name,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Container(
                color: comicPaper,
                padding: const EdgeInsets.all(24),
                child: Align(
                  alignment: Alignment.center,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1000),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.chapter.titleEn,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          panel.dialogueText,
                          textDirection: arabic
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          style: TextStyle(
                            fontFamily: arabic ? 'Amiri' : 'NotoSans',
                            fontSize: (arabic ? 48 : 32) * widget.textScale,
                            height: 1.5,
                          ),
                        ),
                        if (panel.arabicSpotlight != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 18),
                            child: TextButton(
                              onPressed: () => widget.voice.speakArabicWord(
                                panel.arabicSpotlight!.arabic,
                                heroine: widget.chapter.heroine,
                              ),
                              child: Text(
                                panel.arabicSpotlight!.arabic,
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                  fontFamily: 'Amiri',
                                  fontSize: 56 * widget.textScale,
                                ),
                              ),
                            ),
                          ),
                        Wrap(
                          spacing: 12,
                          children: [
                            TextButton.icon(
                              onPressed: () => widget.voice.speakPanel(panel),
                              icon: const Icon(Icons.volume_up_outlined),
                              label: const Text('Listen'),
                            ),
                            TextButton.icon(
                              onPressed: () =>
                                  setState(() => _translation = !_translation),
                              icon: const Icon(Icons.translate),
                              label: Text(
                                _translation ? 'Hide translation' : 'Translate',
                              ),
                            ),
                          ],
                        ),
                        if (_translation)
                          Text(
                            panel.dialogueTranslation,
                            style: TextStyle(
                              fontSize: 32 * widget.textScale,
                              height: 1.5,
                            ),
                          ),
                        const SizedBox(height: 24),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            if (widget.panelIndex > 0)
                              OutlinedButton.icon(
                                onPressed: () =>
                                    widget.onTurn(widget.panelIndex - 1),
                                icon: const Icon(Icons.arrow_back),
                                label: const Text('Back'),
                              ),
                            if (widget.panelIndex <
                                widget.chapter.panels.length - 1)
                              FilledButton.icon(
                                onPressed: () =>
                                    widget.onTurn(widget.panelIndex + 1),
                                icon: const Icon(Icons.arrow_forward),
                                label: const Text('Next'),
                              )
                            else ...[
                              FilledButton.icon(
                                onPressed: widget.onArchive,
                                icon: const Icon(Icons.auto_stories_outlined),
                                label: const Text('More stories'),
                              ),
                              OutlinedButton.icon(
                                onPressed: () => widget.onTurn(0),
                                icon: const Icon(Icons.replay),
                                label: const Text('Replay chapter'),
                              ),
                              OutlinedButton.icon(
                                onPressed: widget.onPlay,
                                icon: const Icon(Icons.draw_outlined),
                                label: const Text('Play with a Stylus'),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _backdrop(SceneBackdropType backdrop) =>
      'assets/art/backdrops/${switch (backdrop) {
        SceneBackdropType.dxbAirport => 'dxb_airport.jpg',
        SceneBackdropType.dubaiCreekAbra => 'dubai_creek_abra.jpg',
        SceneBackdropType.alFahidiCafe => 'alfahidi_cafe.jpg',
        SceneBackdropType.calligraphyMuseum => 'calligraphy_museum.jpg',
        SceneBackdropType.jasmineBookshop => 'beirut_jasmine_cafe.jpg',
        SceneBackdropType.levantBusStreet => 'byblos_ruins.jpg',
        SceneBackdropType.rooftopLounge => 'amman_rooftop.jpg',
        SceneBackdropType.nileFelucca => 'cairo_nile_felucca.png',
        SceneBackdropType.cairoCinema => 'khan_el_khalili_cinema.jpg',
        SceneBackdropType.mediaTerrace => 'cairo_rooftop_watch_party.jpg',
      }}';
}
