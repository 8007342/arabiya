import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../ink/ink_canvas.dart';
import '../ink/ink_evidence_store.dart';
import '../ink/ink_model.dart';
import '../ink/ink_practice_card.dart';

class StylusPlayground extends StatefulWidget {
  const StylusPlayground({
    super.key,
    required this.onClose,
    this.onEvidence,
    this.evidence,
  });
  final VoidCallback onClose;
  final List<Map<String, dynamic>>? evidence;
  final ValueChanged<Map<String, dynamic>>? onEvidence;
  @override
  State<StylusPlayground> createState() => _StylusPlaygroundState();
}

class _StylusPlaygroundState extends State<StylusPlayground> {
  final _ink = InkController();
  int _tab = 0;
  InkTarget _target = InkTarget.ba;
  bool _unlocked = false;
  int _attempts = 0;
  int _recalls = 0;
  Timer? _replay;
  int? _replayMicros;
  String? _message;
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final store = InkEvidenceStore();
    final evidence = widget.evidence ?? await store.read();
    final unlocked = widget.evidence != null
        ? evidence.any((e) => e['accepted'] == true)
        : await store.calligraphyUnlocked();
    if (mounted) {
      setState(() {
        _unlocked = unlocked;
        _attempts = evidence.length;
        _recalls = evidence
            .where((e) => e['accepted'] == true && e['assistance'] == 'recall')
            .length;
      });
    }
  }

  @override
  void didUpdateWidget(covariant StylusPlayground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.evidence != widget.evidence) _load();
  }

  @override
  void dispose() {
    _replay?.cancel();
    _ink.dispose();
    super.dispose();
  }

  void _stopReplay() {
    _replay?.cancel();
    setState(() {
      _replayMicros = null;
    });
  }

  void _startReplay() {
    final samples = _ink.attempt.strokes.expand((s) => s.samples).toList();
    if (samples.isEmpty) return;
    final end = samples.last.elapsedMicros;
    _replay?.cancel();
    setState(() {
      _replayMicros = 0;
    });
    _replay = Timer.periodic(const Duration(milliseconds: 32), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if ((_replayMicros ?? 0) >= end) {
        _stopReplay();
        return;
      }
      setState(() {
        _replayMicros = (_replayMicros ?? 0) + 64000;
      });
    });
  }

  Future<void> _export() async {
    try {
      await Clipboard.setData(
        ClipboardData(
          text: const JsonEncoder.withIndent('  ').convert({
            ..._ink.attempt.toJson(),
            'activity': 'creative-ink',
            'target': null,
            'assistance': null,
          }),
        ),
      );
      if (mounted) {
        setState(() {
          _message = 'Raw strokes copied as JSON. Pressure, times, pen lifts and available tilt are included.';
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _message = 'Clipboard is unavailable in this browser.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context);
    final buttonStyle = ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(Size(56, 56)),
      textStyle: const WidgetStatePropertyAll(
        TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
      ),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
    );
    return Theme(
      data: base.copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF17494D),
          brightness: Brightness.light,
        ),
        filledButtonTheme: FilledButtonThemeData(style: buttonStyle),
        outlinedButtonTheme: OutlinedButtonThemeData(style: buttonStyle),
        textButtonTheme: TextButtonThemeData(style: buttonStyle),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFFBF5E9),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1080),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: widget.onClose,
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Back to the story'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'The ink atelier',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF153D40),
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Make a mark. Give it meaning.',
                      style: TextStyle(fontSize: 30, color: Color(0xFF526361)),
                    ),
                    const SizedBox(height: 22),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _tabButton(
                          0,
                          '01 · Parcel labels',
                          Icons.local_offer_outlined,
                        ),
                        _tabButton(1, '02 · Free ink', Icons.draw_outlined),
                        _tabButton(
                          2,
                          '03 · Ribbon garden',
                          _unlocked ? Icons.spa_outlined : Icons.lock_outline,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    if (_tab == 0) ...[
                      const Text(
                        'A dot changes the destination.',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Trace a label, copy it, then try from memory. One matching practice attempt opens the ribbon garden.',
                        style: TextStyle(fontSize: 24, height: 1.45),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: InkTarget.values
                            .map(
                              (target) => ChoiceChip(
                                label: Text(
                                  target.label,
                                  style: const TextStyle(fontSize: 26),
                                ),
                                selected: target == _target,
                                onSelected: (_) => setState(() {
                                  _target = target;
                                }),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 22,
                                  vertical: 8,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 16),
                      InkPracticeCard(
                        key: ValueKey(_target),
                        target: _target,
                        onEvidence: widget.onEvidence,
                        evidence: widget.evidence,
                        onAccepted: () {
                          setState(() {
                            _unlocked = true;
                          });
                          if (widget.evidence == null) _load();
                        },
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Saved practice: $_attempts submitted attempts · $_recalls matching recall attempts',
                        style: const TextStyle(fontSize: 22, height: 1.4),
                      ),
                      const Text(
                        'Practice records describe these exercises, not writing mastery.',
                        style: TextStyle(fontSize: 20),
                      ),
                    ] else if (_tab == 2 && !_unlocked) ...[
                      Container(
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0E4CD),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Icon(
                              Icons.spa_outlined,
                              size: 80,
                              color: Color(0xFF17494D),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Grow a ribbon garden',
                              style: TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Match one parcel label to unlock broad-nib play. Your speed and pen hardware do not matter.',
                              style: TextStyle(fontSize: 26, height: 1.45),
                            ),
                            const SizedBox(height: 20),
                            FilledButton(
                              onPressed: () => setState(() {
                                _tab = 0;
                              }),
                              child: const Text('Write a parcel label'),
                            ),
                          ],
                        ),
                      ),
                    ] else
                      ..._drawingStudio(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _tabButton(int index, String label, IconData icon) => _tab == index
      ? FilledButton.icon(
          onPressed: () {},
          icon: Icon(icon),
          label: Text(label),
        )
      : OutlinedButton.icon(
          onPressed: () {
            _stopReplay();
            setState(() {
              _tab = index;
              if (index == 2 && _unlocked) _ink.brush = InkBrush.broadNib;
              if (index == 1 && _ink.brush == InkBrush.broadNib) {
                _ink.brush = InkBrush.round;
              }
              _ink.changed();
            });
          },
          icon: Icon(icon),
          label: Text(label),
        );
  List<Widget> _drawingStudio() => [
    Text(
      _tab == 2
          ? 'Six petals, one turning ribbon.'
          : 'A whole page of possibilities.',
      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
    ),
    const SizedBox(height: 10),
    Text(
      _tab == 2
          ? 'Draw six looping petals around a center. Keep the nib at 45° and watch the line change as you turn. Then try 90°. This is a creative challenge, with no handwriting grade.'
          : 'Try a loop, a long sweep, or your name. Pen, finger and mouse all work. Your drawing stays here until you clear it or leave.',
      style: const TextStyle(fontSize: 24, height: 1.45),
    ),
    const SizedBox(height: 18),
    Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final brush in InkBrush.values.where(
          (b) => b != InkBrush.broadNib || _tab == 2,
        ))
          ChoiceChip(
            label: Text(switch (brush) {
              InkBrush.round => 'Round pen',
              InkBrush.pressure => 'Pressure brush',
              InkBrush.broadNib => 'Broad nib',
            }, style: const TextStyle(fontSize: 22)),
            selected: _ink.brush == brush,
            onSelected: (_) => setState(() {
              _ink.brush = brush;
              _ink.changed();
            }),
            padding: const EdgeInsets.all(10),
          ),
      ],
    ),
    const SizedBox(height: 16),
    Text(
      'Pen width · ${_ink.width.round()}',
      style: const TextStyle(fontSize: 24),
    ),
    Slider(
      value: _ink.width,
      min: 3,
      max: 22,
      divisions: 19,
      label: '${_ink.width.round()}',
      onChanged: (v) => setState(() {
        _ink.width = v;
        _ink.changed();
      }),
    ),
    if (_ink.brush == InkBrush.broadNib) ...[
      Text(
        'Virtual nib angle · ${(_ink.nibAngle * 180 / math.pi).round()}°',
        style: const TextStyle(fontSize: 24),
      ),
      Slider(
        value: _ink.nibAngle,
        min: 0,
        max: math.pi,
        divisions: 12,
        label: '${(_ink.nibAngle * 180 / math.pi).round()}°',
        onChanged: (v) => setState(() {
          _ink.nibAngle = v;
          _ink.changed();
        }),
      ),
      const Text(
        'The virtual angle works on every device. Line width follows movement direction; measured pressure adds variation when available.',
        style: TextStyle(fontSize: 20, height: 1.4),
      ),
    ],
    const SizedBox(height: 16),
    InkCanvas(
      controller: _ink,
      showGuide: false,
      height: MediaQuery.sizeOf(context).width < 500 ? 360 : 460,
      replayMicros: _replayMicros,
    ),
    const SizedBox(height: 16),
    Wrap(
      spacing: 10,
      runSpacing: 12,
      children: [
        OutlinedButton.icon(
          onPressed: () {
            _stopReplay();
            _ink.undo();
          },
          icon: const Icon(Icons.undo),
          label: const Text('Undo'),
        ),
        OutlinedButton.icon(
          onPressed: () {
            _stopReplay();
            _ink.clear();
          },
          icon: const Icon(Icons.refresh),
          label: const Text('Clear page'),
        ),
        OutlinedButton.icon(
          onPressed: _replayMicros == null ? _startReplay : _stopReplay,
          icon: Icon(_replayMicros == null ? Icons.play_arrow : Icons.stop),
          label: Text(_replayMicros == null ? 'Replay ink' : 'Stop replay'),
        ),
        TextButton.icon(
          onPressed: _export,
          icon: const Icon(Icons.copy),
          label: const Text('Copy raw ink'),
        ),
      ],
    ),
    const SizedBox(height: 18),
    AnimatedBuilder(
      animation: _ink,
      builder: (context, _) {
        final strokes = _ink.attempt.strokes;
        final kinds = strokes.map((s) => s.pointerKind).toSet();
        return Text(
          '${strokes.length} pen-down strokes · ${kinds.isEmpty ? 'Ready for input' : kinds.join(', ')}\n${_ink.hasVaryingPressure ? 'Varying pen pressure detected.' : 'No varying pressure detected yet. Finger and mouse use a steady width.'}',
          style: const TextStyle(fontSize: 22, height: 1.5),
        );
      },
    ),
    if (_message != null)
      Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Semantics(
          liveRegion: true,
          child: Text(_message!, style: const TextStyle(fontSize: 22)),
        ),
      ),
    const SizedBox(height: 16),
    const Text(
      'Ink is drawn immediately on this device. Raw samples are copied only when you choose Copy raw ink. This studio does not recognize or transcribe handwriting.',
      style: TextStyle(fontSize: 20, height: 1.5),
    ),
  ];
}
