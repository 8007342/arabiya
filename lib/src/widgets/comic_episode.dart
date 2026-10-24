// @trace spec:arabiya, spec:character-canon, spec:curriculum-and-comics
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/door_episode.dart';
import '../ink/ink_practice_card.dart';
import '../services/voice_service.dart';

const comicInk = Color(0xFF102C32);
const comicPaper = Color(0xFFFFF6DF);
const comicGold = Color(0xFFFFCE67);

/// A reader-controlled sequence: no timed advances and no learning awards.
class ComicEpisode extends StatefulWidget {
  final VoiceService voice;
  final VoidCallback onArchive;
  final VoidCallback onAccount;
  final VoidCallback onPlay;
  final VoidCallback onNotebook;
  final List<Map<String, dynamic>> writingEvidence;
  final int initialBeat;
  final ValueChanged<int> onBeatChanged;
  final Widget? signInButton;
  final double textScale;
  final VoidCallback onTextSize;
  final ValueChanged<Map<String, dynamic>> onEvidence;

  const ComicEpisode({
    super.key,
    required this.voice,
    required this.initialBeat,
    required this.writingEvidence,
    required this.onBeatChanged,
    this.signInButton,
    required this.onArchive,
    required this.onAccount,
    required this.onPlay,
    required this.onNotebook,
    required this.textScale,
    required this.onTextSize,
    required this.onEvidence,
  });

  @override
  State<ComicEpisode> createState() => _ComicEpisodeState();
}

class _ComicEpisodeState extends State<ComicEpisode> {
  int _index = 0;
  bool _translation = false;
  bool _doorOpen = false;
  bool _labelWritten = false;
  bool _description = false;
  bool _reducedMotion = false;
  final _scroll = ScrollController();
  SceneBeat get _beat => kDoorEpisode[_index];

  @override
  void initState() {
    super.initState();
    _index = widget.initialBeat.clamp(0, kDoorEpisode.length - 1);
  }

  @override
  void didUpdateWidget(covariant ComicEpisode oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialBeat != widget.initialBeat &&
        widget.initialBeat != _index) {
      _index = widget.initialBeat.clamp(0, kDoorEpisode.length - 1);
      _translation = false;
      _description = false;
      _doorOpen = false;
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _go(int index) {
    if (_beat.shot == ComicShot.label &&
        !_labelWritten &&
        index == _index + 1) {
      final now = DateTime.now().toUtc();
      widget.onEvidence({
        'id': 'story-help-${now.microsecondsSinceEpoch}',
        'timestamp': now.toIso8601String(),
        'target': 'ba',
        'assistance': 'storyHelp',
        'accepted': false,
        'eventType': 'continuedWithoutWriting',
      });
    }
    widget.voice.stop();
    setState(() {
      _index = index;
      _translation = false;
      _description = false;
      _doorOpen = false;
      if (index == 0) _labelWritten = false;
    });
    widget.onBeatChanged(index);
    if (_scroll.hasClients) _scroll.jumpTo(0);
    final panel = _beat.audioPanel;
    if (panel != null && widget.voice.autoPlayEnabled) {
      widget.voice.speakPanel(panel);
    }
  }

  @override
  Widget build(BuildContext context) {
    final reduced = _reducedMotion || MediaQuery.disableAnimationsOf(context);
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.arrowRight): () =>
            _go((_index + 1) % kDoorEpisode.length),
        const SingleActivator(LogicalKeyboardKey.arrowLeft): () =>
            _go(math.max(0, _index - 1)),
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          backgroundColor: comicInk,
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth >= 850;
                if (constraints.maxWidth >= 1100 &&
                    constraints.maxHeight >= 600 &&
                    widget.textScale == 1 &&
                    MediaQuery.textScalerOf(context).scale(34) <= 42) {
                  return _cinematic(context, constraints, reduced);
                }
                return SingleChildScrollView(
                  controller: _scroll,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        child: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 16,
                          runSpacing: 8,
                          children: [
                            const Text(
                              'ARABIYA',
                              style: TextStyle(
                                color: comicGold,
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 3,
                              ),
                            ),
                            Wrap(
                              spacing: 4,
                              children: [
                                ComicIcon(
                                  label: 'Chapter archive',
                                  icon: Icons.auto_stories_outlined,
                                  onPressed: widget.onArchive,
                                ),
                                ComicIcon(
                                  label: 'Play with a Stylus',
                                  icon: Icons.draw_outlined,
                                  onPressed: widget.onPlay,
                                ),
                                ComicIcon(
                                  label:
                                      'Text size: ${widget.textScale == 1 ? "large" : "extra large"}',
                                  icon: Icons.text_increase,
                                  onPressed: widget.onTextSize,
                                ),
                                ComicIcon(
                                  label: 'Your saved adventure',
                                  icon: Icons.account_circle_outlined,
                                  onPressed: widget.onAccount,
                                ),
                                PopupMenuButton<String>(
                                  tooltip: 'Reader options',
                                  color: comicPaper,
                                  icon: const Icon(
                                    Icons.more_horiz,
                                    color: comicPaper,
                                    size: 28,
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 260,
                                    maxWidth: 340,
                                  ),
                                  onSelected: (value) {
                                    if (value == 'replay') _go(0);
                                    if (value == 'notebook') {
                                      widget.onNotebook();
                                    }
                                    if (value == 'motion') {
                                      setState(
                                        () => _reducedMotion = !_reducedMotion,
                                      );
                                    }
                                    if (value == 'sound') {
                                      setState(() {
                                        widget.voice.isMuted =
                                            !widget.voice.isMuted;
                                        widget.voice.stop();
                                      });
                                    }
                                    if (value == 'description') {
                                      setState(
                                        () => _description = !_description,
                                      );
                                    }
                                  },
                                  itemBuilder: (_) => [
                                    _menu('replay', 'Replay episode'),
                                    _menu('notebook', 'Word notebook'),
                                    _menu(
                                      'motion',
                                      _reducedMotion
                                          ? 'Motion: reduced'
                                          : 'Reduce motion',
                                    ),
                                    _menu(
                                      'sound',
                                      widget.voice.isMuted
                                          ? 'Turn sound on'
                                          : 'Mute sound',
                                    ),
                                    _menu('description', 'Describe this scene'),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 4, 24, 16),
                        child: Wrap(
                          spacing: 16,
                          runSpacing: 4,
                          alignment: WrapAlignment.spaceBetween,
                          children: [
                            const Text(
                              'The Door That Won’t Cooperate',
                              style: TextStyle(
                                color: comicPaper,
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              '${_index + 1} / ${kDoorEpisode.length}',
                              semanticsLabel:
                                  'Scene ${_index + 1} of ${kDoorEpisode.length}',
                              style: const TextStyle(
                                color: comicGold,
                                fontSize: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: reduced ? 0 : 300),
                        child: SizedBox(
                          key: ValueKey(_index),
                          height: wide
                              ? math.max(380, constraints.maxHeight - 350)
                              : 340,
                          child: ComicSceneArt(
                            beat: _beat,
                            doorOpen: _doorOpen,
                            labelWritten: _labelWritten,
                            reducedMotion: reduced,
                            onDoor: () {
                              widget.voice.speakArabicWord('بَاب');
                              if (_beat.shot == ComicShot.slide) {
                                setState(() => _doorOpen = true);
                              } else {
                                setState(() => _translation = !_translation);
                              }
                            },
                          ),
                        ),
                      ),
                      Container(
                        color: comicPaper,
                        padding: EdgeInsets.symmetric(
                          horizontal: wide ? 48 : 22,
                          vertical: 24,
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 1080),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _beat.title,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    color: comicInk,
                                    letterSpacing: 1,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                if (_beat.line != null) ...[
                                  Text(
                                    _beat.line!,
                                    textDirection: _beat.locale.startsWith('ar')
                                        ? TextDirection.rtl
                                        : TextDirection.ltr,
                                    style: TextStyle(
                                      fontFamily: _beat.locale.startsWith('ar')
                                          ? 'Amiri'
                                          : 'NotoSans',
                                      fontSize:
                                          (_beat.locale.startsWith('ar')
                                              ? 56
                                              : 34) *
                                          widget.textScale,
                                      height: 1.4,
                                      color: comicInk,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Wrap(
                                    spacing: 12,
                                    runSpacing: 8,
                                    children: [
                                      TextButton.icon(
                                        onPressed: () => widget.voice
                                            .speakPanel(_beat.audioPanel!),
                                        icon: const Icon(
                                          Icons.volume_up_outlined,
                                        ),
                                        label: const Text('Listen'),
                                      ),
                                      TextButton.icon(
                                        onPressed: () => setState(
                                          () => _translation = !_translation,
                                        ),
                                        icon: const Icon(Icons.translate),
                                        label: Text(
                                          _translation
                                              ? 'Hide translation'
                                              : 'Translate',
                                        ),
                                      ),
                                    ],
                                  ),
                                ] else if (_beat.shot == ComicShot.reaction)
                                  const Text(
                                    'A long, very quiet moment.',
                                    style: TextStyle(
                                      fontSize: 32,
                                      height: 1.4,
                                      color: comicInk,
                                    ),
                                  )
                                else ...[
                                  const Text(
                                    'Leave ب on the luggage label.',
                                    style: TextStyle(
                                      fontSize: 32,
                                      height: 1.4,
                                      color: comicInk,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  InkPracticeCard(
                                    evidence: widget.writingEvidence,
                                    onEvidence: widget.onEvidence,
                                    onAccepted: () =>
                                        setState(() => _labelWritten = true),
                                    onContinueWithoutWriting: () =>
                                        _go(_index + 1),
                                  ),
                                  if (_labelWritten)
                                    const Padding(
                                      padding: EdgeInsets.only(top: 16),
                                      child: Text(
                                        'The label is ready. Let’s show the robot.',
                                        style: TextStyle(
                                          fontSize: 32,
                                          color: comicInk,
                                        ),
                                      ),
                                    ),
                                ],
                                if (_translation)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Text(
                                      _beat.translation ?? 'ب · bā · the first letter in بَاب (door)',
                                      style: TextStyle(
                                        fontSize: 32 * widget.textScale,
                                        height: 1.5,
                                        color: comicInk,
                                      ),
                                    ),
                                  ),
                                if (_description)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: Text(
                                      _beat.description,
                                      style: TextStyle(
                                        fontSize: 32 * widget.textScale,
                                        height: 1.5,
                                        color: comicInk,
                                      ),
                                    ),
                                  ),
                                if (_beat.shot == ComicShot.slide && !_doorOpen)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: OutlinedButton.icon(
                                      onPressed: () =>
                                          setState(() => _doorOpen = true),
                                      icon: const Icon(Icons.open_in_full),
                                      label: const Text('Slide the door'),
                                    ),
                                  ),
                                if (_index == 0 &&
                                    widget.signInButton != null) ...[
                                  const SizedBox(height: 12),
                                  widget.signInButton!,
                                ],
                                const SizedBox(height: 18),
                                Wrap(
                                  alignment: WrapAlignment.spaceBetween,
                                  spacing: 12,
                                  runSpacing: 12,
                                  children: [
                                    if (_index > 0)
                                      OutlinedButton.icon(
                                        onPressed: () => _go(_index - 1),
                                        icon: const Icon(Icons.arrow_back),
                                        label: const Text('Back'),
                                      ),
                                    FilledButton.icon(
                                      onPressed: () => _go(
                                        (_index + 1) % kDoorEpisode.length,
                                      ),
                                      icon: Icon(
                                        _index == kDoorEpisode.length - 1
                                            ? Icons.replay
                                            : Icons.arrow_forward,
                                      ),
                                      label: Text(
                                        _beat.shot == ComicShot.label &&
                                                !_labelWritten
                                            ? 'Continue with help'
                                            : _beat.nextLabel,
                                      ),
                                    ),
                                    if (_index == 0 ||
                                        _index == kDoorEpisode.length - 1)
                                      OutlinedButton.icon(
                                        onPressed: widget.onPlay,
                                        icon: const Icon(Icons.draw_outlined),
                                        label: const Text('Play with a Stylus'),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _cinematic(BuildContext context, BoxConstraints bounds, bool reduced) {
    final arabic = _beat.locale.startsWith('ar');
    final writing = _beat.shot == ComicShot.label;
    final alignment = switch (_beat.shot) {
      ComicShot.arrival || ComicShot.cafe => Alignment.topRight,
      ComicShot.sign || ComicShot.slide => Alignment.bottomLeft,
      ComicShot.push || ComicShot.payoff => Alignment.topLeft,
      ComicShot.reaction => Alignment.bottomCenter,
      ComicShot.label => Alignment.centerRight,
    };
    return Stack(
      fit: StackFit.expand,
      children: [
        AnimatedSwitcher(
          duration: Duration(milliseconds: reduced ? 0 : 250),
          child: ComicSceneArt(
            key: ValueKey('full-${_beat.id}'),
            beat: _beat,
            doorOpen: _doorOpen,
            labelWritten: _labelWritten,
            reducedMotion: reduced,
            showLocation: false,
            onDoor: () {
              widget.voice.speakArabicWord('بَاب');
              setState(() {
                if (_beat.shot == ComicShot.slide) {
                  _doorOpen = true;
                } else {
                  _translation = !_translation;
                }
              });
            },
          ),
        ),
        Positioned(
          top: 12,
          left: 20,
          right: 20,
          child: Row(
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: comicInk,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'The Door That Won’t Cooperate',
                    style: TextStyle(
                      color: comicPaper,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: comicInk,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ComicIcon(
                      label: 'Chapter archive',
                      icon: Icons.auto_stories_outlined,
                      onPressed: widget.onArchive,
                    ),
                    ComicIcon(
                      label: 'Play with a Stylus',
                      icon: Icons.draw_outlined,
                      onPressed: widget.onPlay,
                    ),
                    ComicIcon(
                      label: 'Text size: large',
                      icon: Icons.text_increase,
                      onPressed: widget.onTextSize,
                    ),
                    ComicIcon(
                      label: 'Your saved adventure',
                      icon: Icons.account_circle_outlined,
                      onPressed: widget.onAccount,
                    ),
                    PopupMenuButton<String>(
                      tooltip: 'Reader options',
                      color: comicPaper,
                      icon: const Icon(
                        Icons.more_horiz,
                        color: comicPaper,
                        size: 28,
                      ),
                      onSelected: (value) {
                        if (value == 'replay') _go(0);
                        if (value == 'notebook') widget.onNotebook();
                        if (value == 'motion') {
                          setState(() => _reducedMotion = !_reducedMotion);
                        }
                        if (value == 'description') {
                          setState(() => _description = !_description);
                        }
                        if (value == 'sound') {
                          setState(() {
                            widget.voice.isMuted = !widget.voice.isMuted;
                            widget.voice.stop();
                          });
                        }
                      },
                      itemBuilder: (_) => [
                        _menu('replay', 'Replay episode'),
                        _menu('notebook', 'Word notebook'),
                        _menu(
                          'motion',
                          _reducedMotion ? 'Motion: reduced' : 'Reduce motion',
                        ),
                        _menu(
                          'sound',
                          widget.voice.isMuted ? 'Turn sound on' : 'Mute sound',
                        ),
                        _menu('description', 'Describe this scene'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(26, 94, 26, 108),
          child: Align(
            alignment: alignment,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: writing
                    ? 610
                    : _beat.shot == ComicShot.reaction
                    ? 620
                    : 510,
                maxHeight: bounds.maxHeight - 210,
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: comicPaper,
                  border: Border.all(color: comicInk, width: 4),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(24),
                    topRight: const Radius.circular(24),
                    bottomLeft: Radius.circular(alignment.x < 0 ? 3 : 24),
                    bottomRight: Radius.circular(alignment.x > 0 ? 3 : 24),
                  ),
                  boxShadow: const [
                    BoxShadow(color: Color(0xAA102C32), offset: Offset(7, 8)),
                  ],
                ),
                child: SingleChildScrollView(
                  key: ValueKey('caption-$_index'),
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _beat.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: comicInk,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (_beat.line != null) ...[
                        Text(
                          _beat.line!,
                          textDirection: arabic
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          style: TextStyle(
                            fontFamily: arabic ? 'Amiri' : 'NotoSans',
                            fontSize: arabic ? 56 : 34,
                            height: 1.35,
                            fontWeight: FontWeight.w600,
                            color: comicInk,
                          ),
                        ),
                        Wrap(
                          spacing: 12,
                          children: [
                            TextButton.icon(
                              onPressed: () =>
                                  widget.voice.speakPanel(_beat.audioPanel!),
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
                      ] else if (writing) ...[
                        const Text(
                          'Leave ب on the luggage label.',
                          style: TextStyle(fontSize: 32, color: comicInk),
                        ),
                        const SizedBox(height: 12),
                        InkPracticeCard(
                          evidence: widget.writingEvidence,
                          onEvidence: widget.onEvidence,
                          onAccepted: () =>
                              setState(() => _labelWritten = true),
                          onContinueWithoutWriting: () => _go(_index + 1),
                        ),
                        if (_labelWritten)
                          const Text(
                            'The label is ready. Let’s show the robot.',
                            style: TextStyle(fontSize: 32, color: comicInk),
                          ),
                      ] else
                        const Text(
                          'A long, very quiet moment.',
                          style: TextStyle(
                            fontSize: 32,
                            height: 1.4,
                            color: comicInk,
                          ),
                        ),
                      if (_translation)
                        Text(
                          _beat.translation ??
                              'ب · bā · the first letter in بَاب (door)',
                          style: const TextStyle(
                            fontSize: 32,
                            height: 1.4,
                            color: comicInk,
                          ),
                        ),
                      if (_description)
                        Text(
                          _beat.description,
                          style: const TextStyle(
                            fontSize: 32,
                            height: 1.4,
                            color: comicInk,
                          ),
                        ),
                      if (_beat.shot == ComicShot.slide && !_doorOpen)
                        OutlinedButton.icon(
                          onPressed: () => setState(() => _doorOpen = true),
                          icon: const Icon(Icons.open_in_full),
                          label: const Text('Slide the door'),
                        ),
                      if (_index == 0 || _index == kDoorEpisode.length - 1)
                        TextButton.icon(
                          onPressed: widget.onPlay,
                          icon: const Icon(Icons.draw_outlined),
                          label: const Text('Play with a Stylus'),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 24,
          right: 24,
          bottom: 18,
          child: Row(
            children: [
              if (_index > 0)
                FilledButton.icon(
                  onPressed: () => _go(_index - 1),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Back'),
                )
              else if (widget.signInButton != null)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: comicPaper,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SizedBox(width: 330, child: widget.signInButton!),
                ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                color: comicInk,
                child: Text(
                  '${_index + 1} / ${kDoorEpisode.length}',
                  semanticsLabel:
                      'Scene ${_index + 1} of ${kDoorEpisode.length}',
                  style: const TextStyle(fontSize: 24, color: comicPaper),
                ),
              ),
              const SizedBox(width: 18),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: comicGold,
                  foregroundColor: comicInk,
                ),
                onPressed: () => _go((_index + 1) % kDoorEpisode.length),
                icon: Icon(
                  _index == kDoorEpisode.length - 1
                      ? Icons.replay
                      : Icons.arrow_forward,
                ),
                label: Text(
                  writing && !_labelWritten
                      ? 'Continue with help'
                      : _beat.nextLabel,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  PopupMenuItem<String> _menu(String value, String text) => PopupMenuItem(
    value: value,
    child: Text(text, style: const TextStyle(fontSize: 24)),
  );
}

class ComicIcon extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  const ComicIcon({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: label,
    onPressed: onPressed,
    style: IconButton.styleFrom(
      minimumSize: const Size(56, 56),
      foregroundColor: comicPaper,
    ),
    icon: Icon(icon, size: 28),
  );
}

/// Art is decorative; the authored description is exposed as a single semantic scene.
class ComicSceneArt extends StatelessWidget {
  final SceneBeat beat;
  final bool doorOpen;
  final bool labelWritten;
  final bool reducedMotion;
  final bool showLocation;
  final VoidCallback onDoor;
  const ComicSceneArt({
    super.key,
    required this.beat,
    required this.doorOpen,
    required this.labelWritten,
    required this.reducedMotion,
    this.showLocation = true,
    required this.onDoor,
  });

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) {
      final w = box.maxWidth;
      final h = box.maxHeight;
      final close = beat.shot == ComicShot.sign || beat.shot == ComicShot.label;
      final cafe = beat.shot == ComicShot.cafe;
      final reveal = doorOpen || beat.shot == ComicShot.payoff;
      return Semantics(
        label: beat.description,
        child: ClipRect(
          child: Stack(
            children: [
              Positioned.fill(
                child: ExcludeSemantics(
                  child: Image.asset(
                    'assets/art/backdrops/${cafe ? 'alfahidi_cafe' : 'dxb_airport'}.jpg',
                    fit: BoxFit.cover,
                    alignment: close ? Alignment.centerRight : Alignment.center,
                  ),
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        comicInk.withValues(alpha: .15),
                        comicInk.withValues(alpha: .08),
                        comicInk.withValues(alpha: .65),
                      ],
                    ),
                  ),
                ),
              ),
              if (beat.shot == ComicShot.reaction) ...[
                _reaction(w, h),
              ] else ...[
                if (!cafe && beat.shot != ComicShot.label)
                  Positioned(
                    right: close ? w * .20 : w * .07,
                    top: h * .06,
                    width: close ? w * .6 : w * .4,
                    height: h * .90,
                    child: _door(reveal, close),
                  ),
                if (beat.shot != ComicShot.label) ...[
                  _actor(
                    'macron',
                    x: beat.shot == ComicShot.payoff
                        ? w * .04
                        : close
                        ? w * .01
                        : w * .28,
                    y: h * .29,
                    width: w * (close ? .34 : .30),
                    height: h * .71,
                    angle: beat.shot == ComicShot.push ? .20 : 0,
                  ),
                  if (!close)
                    _actor(
                      cafe
                          ? 'tlatoani'
                          : (beat.shot == ComicShot.slide ? 'nur' : 'covi'),
                      x: -w * .02,
                      y: h * .08,
                      width: w * .3,
                      height: h * .95,
                    ),
                  if (!close)
                    Positioned(
                      left: beat.shot == ComicShot.payoff ? w * .49 : w * .30,
                      bottom: h * .03,
                      width: w * (beat.shot == ComicShot.payoff ? .41 : .32),
                      height: h * .62,
                      child: Transform.rotate(
                        angle: beat.shot == ComicShot.push ? -.10 : .04,
                        child: CustomPaint(
                          painter: _SuitcasePainter(),
                          child: Center(
                            child: Transform.rotate(
                              angle: -.10,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: comicPaper,
                                  border: Border.all(color: comicInk, width: 3),
                                ),
                                child:
                                    labelWritten ||
                                        beat.shot == ComicShot.payoff
                                    ? const Text(
                                        'ب',
                                        style: TextStyle(
                                          fontFamily: 'Amiri',
                                          fontSize: 56,
                                          color: comicInk,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.local_offer_outlined,
                                        size: 48,
                                        color: comicInk,
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
                if (beat.shot == ComicShot.label) ...[
                  Positioned(
                    left: w * .1,
                    top: h * .06,
                    width: w * .8,
                    height: h * .88,
                    child: Transform.rotate(
                      angle: -.035,
                      child: Container(
                        decoration: BoxDecoration(
                          color: comicPaper,
                          border: Border.all(color: comicInk, width: 5),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black38,
                              offset: Offset(10, 12),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            labelWritten ? 'ب' : 'بَاب',
                            textDirection: TextDirection.rtl,
                            style: const TextStyle(
                              fontFamily: 'Amiri',
                              fontSize: 128,
                              color: comicInk,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                if (beat.shot == ComicShot.push)
                  Positioned(
                    top: 20,
                    right: 24,
                    child: _sticker('THUNK!', angle: .08),
                  ),
                if (beat.shot == ComicShot.payoff)
                  Positioned(
                    top: 18,
                    right: 18,
                    child: _sticker('🤖 ✨', angle: -.06),
                  ),
                if (cafe)
                  Positioned(
                    right: w * .12,
                    top: h * .16,
                    child: FilledButton(
                      onPressed: onDoor,
                      style: FilledButton.styleFrom(
                        backgroundColor: comicPaper,
                        foregroundColor: comicInk,
                      ),
                      child: const Text(
                        'بَاب',
                        style: TextStyle(fontFamily: 'Amiri', fontSize: 56),
                      ),
                    ),
                  ),
              ],
              if (showLocation)
                Positioned(
                  top: 12,
                  left: 16,
                  child: ExcludeSemantics(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      color: comicGold,
                      child: Text(
                        cafe
                            ? 'LATER…'
                            : close
                            ? 'A CLOSER LOOK'
                            : beat.shot == ComicShot.reaction
                            ? 'BEAT.'
                            : 'DUBAI · ARRIVALS',
                        style: const TextStyle(
                          color: comicInk,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    },
  );

  Widget _actor(
    String name, {
    required double x,
    required double y,
    required double width,
    required double height,
    double angle = 0,
  }) => Positioned(
    left: x,
    top: y,
    width: width,
    height: height,
    child: ExcludeSemantics(
      child: Transform.rotate(
        angle: angle,
        child: Image.asset(
          'assets/art/characters/$name.png',
          fit: BoxFit.contain,
          alignment: Alignment.bottomCenter,
        ),
      ),
    ),
  );

  Widget _door(bool open, bool close) => Stack(
    fit: StackFit.expand,
    children: [
      DecoratedBox(
        decoration: BoxDecoration(
          color: open ? const Color(0xFFFFE9A8) : const Color(0xBB91CBCD),
          border: Border.all(color: comicInk, width: 7),
        ),
      ),
      AnimatedSlide(
        duration: Duration(milliseconds: reducedMotion ? 0 : 650),
        curve: Curves.easeInOutCubic,
        offset: Offset(open ? .8 : 0, 0),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xAA8FCDD2),
            border: Border.all(color: comicInk, width: 5),
          ),
          child: Column(
            children: [
              const SizedBox(height: 35),
              Flexible(
                child: Semantics(
                  label:
                      'Door sign. Hear bāb. ${beat.shot == ComicShot.slide ? "Slide the door open." : ""}',
                  button: true,
                  child: TextButton(
                    onPressed: onDoor,
                    style: TextButton.styleFrom(
                      backgroundColor: comicPaper,
                      foregroundColor: comicInk,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    child: const Text(
                      'بَاب',
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontFamily: 'Amiri',
                        fontWeight: FontWeight.bold,
                        fontSize: 56,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 12,
                  height: 65,
                  margin: const EdgeInsets.only(left: 12, bottom: 30),
                  decoration: BoxDecoration(
                    color: comicInk,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward, size: 48, color: comicInk),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    ],
  );

  Widget _reaction(double w, double h) => Positioned.fill(
    child: Row(
      children: [
        for (final name in ['macron', 'nur', 'macron'])
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: name == 'nur' ? comicGold : const Color(0xFF9AC7C9),
                border: Border.all(color: comicInk, width: 5),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRect(
                    child: Transform.scale(
                      scale: 2.0,
                      alignment: Alignment.topCenter,
                      child: Image.asset(
                        'assets/art/characters/$name.png',
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                        excludeFromSemantics: true,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: _sticker(name == 'nur' ? '→' : '…'),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    ),
  );

  Widget _sticker(String text, {double angle = 0}) => Transform.rotate(
    angle: angle,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: comicPaper,
        border: Border.all(color: comicInk, width: 3),
        boxShadow: const [BoxShadow(color: comicInk, offset: Offset(4, 5))],
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w900,
          color: comicInk,
        ),
      ),
    ),
  );
}

class _SuitcasePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final body = RRect.fromRectAndRadius(
      Rect.fromLTWH(4, size.height * .08, size.width - 8, size.height * .84),
      const Radius.circular(20),
    );
    canvas.drawRRect(body, Paint()..color = const Color(0xFFEB8162));
    canvas.drawRRect(
      body,
      Paint()
        ..color = comicInk
        ..strokeWidth = 6
        ..style = PaintingStyle.stroke,
    );
    for (final f in [.25, .75]) {
      canvas.drawRect(
        Rect.fromLTWH(
          size.width * f - 8,
          size.height * .08,
          16,
          size.height * .84,
        ),
        Paint()..color = comicInk,
      );
      canvas.drawCircle(
        Offset(size.width * f, size.height * .94),
        size.height * .045,
        Paint()..color = comicInk,
      );
    }
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * .38, 0, size.width * .24, size.height * .11),
        const Radius.circular(5),
      ),
      Paint()
        ..color = comicInk
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6,
    );
  }

  @override
  bool shouldRepaint(covariant _SuitcasePainter oldDelegate) => false;
}
