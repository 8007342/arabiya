import 'package:flutter/material.dart';

import '../ink/ink_canvas.dart';
import '../ink/ink_evidence_store.dart';
import '../ink/ink_model.dart';
import '../ink/ink_studio_workspace.dart';
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
    _ink.dispose();
    super.dispose();
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
    const SizedBox(height: 12),
    Text(
      _tab == 2
          ? 'Draw six looping petals around a center. Explore the nib angle in Ink tools.'
          : 'Try a loop, a long sweep, or your name. Your paper stays fixed while you draw.',
      style: const TextStyle(fontSize: 24, height: 1.45),
    ),
    const SizedBox(height: 20),
    FilledButton.icon(
      key: const ValueKey('open-ink-studio'),
      onPressed: () => Navigator.of(context).push<void>(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) =>
              InkStudioWorkspace(controller: _ink, broadNib: _tab == 2),
        ),
      ),
      icon: const Icon(Icons.draw_outlined),
      label: const Text('Open drawing desk', style: TextStyle(fontSize: 26)),
    ),
  ];
}
