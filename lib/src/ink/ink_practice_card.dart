import 'dart:async';

import 'package:flutter/material.dart';

import 'ink_canvas.dart';
import 'ink_evidence_store.dart';
import 'ink_model.dart';
import 'ink_rubric.dart';

class InkPracticeCard extends StatefulWidget {
  const InkPracticeCard({
    super.key,
    this.target = InkTarget.ba,
    this.onAccepted,
    this.onContinueWithoutWriting,
    this.onEvidence,
    this.evidence,
  });
  final InkTarget target;
  final List<Map<String, dynamic>>? evidence;
  final VoidCallback? onAccepted;
  final VoidCallback? onContinueWithoutWriting;
  final ValueChanged<Map<String, dynamic>>? onEvidence;
  @override
  State<InkPracticeCard> createState() => _InkPracticeCardState();
}

class _InkPracticeCardState extends State<InkPracticeCard> {
  late final InkController _ink;
  InkAssessment? _result;
  bool _submitting = false;
  String? _saveStatus;
  @override
  void initState() {
    super.initState();
    _ink = InkController(target: widget.target);
    _restore();
  }

  Future<void> _restore() async {
    final entries = widget.evidence ?? await InkEvidenceStore().read();
    if (!mounted || _ink.attempt.strokes.isNotEmpty || _result != null) return;
    final successes = entries
        .where(
          (e) => e['target'] == widget.target.name && e['accepted'] == true,
        )
        .toList();
    final previous = successes.lastOrNull?['assistance'];
    setState(() {
      _ink.clear(
        assistance: previous == null
            ? InkAssistance.guided
            : previous == 'guided'
            ? InkAssistance.copy
            : InkAssistance.recall,
      );
    });
  }

  @override
  void didUpdateWidget(covariant InkPracticeCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.target != widget.target) {
      _ink.clear(target: widget.target, assistance: InkAssistance.guided);
      _result = null;
      _saveStatus = null;
      _restore();
    } else if (oldWidget.evidence != widget.evidence &&
        _ink.attempt.strokes.isEmpty) {
      _restore();
    }
  }

  @override
  void dispose() {
    _ink.dispose();
    super.dispose();
  }

  void _reset({InkAssistance? assistance}) => setState(() {
    _ink.clear(assistance: assistance);
    _result = null;
    _saveStatus = null;
  });
  Future<void> _submit() async {
    if (_submitting || _result != null) return;
    final attempt = _ink.attempt;
    final result = InkRubric().assess(attempt);
    setState(() {
      _result = result;
      _submitting = true;
      _saveStatus = 'Saving on this device…';
    });
    final now = DateTime.now().toUtc();
    final evidence = <String, dynamic>{
      'id': 'ink-${now.microsecondsSinceEpoch}-${identityHashCode(attempt)}',
      'target': attempt.target.name,
      'assistance': attempt.assistance.name,
      'timestamp': now.toIso8601String(),
      'accepted': result.accepted,
      'metrics': result.toJson(),
      'pointerKinds': attempt.strokes
          .map((s) => s.pointerKind)
          .toSet()
          .toList(),
    };
    widget.onEvidence?.call(evidence);
    try {
      await InkEvidenceStore().record(attempt, result);
      if (result.accepted) await InkEvidenceStore().unlockCalligraphy();
      if (mounted) {
        setState(() {
          _saveStatus = 'Practice evidence saved on this device.';
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _saveStatus =
              'Could not save on this device. Your result is still shown here.';
        });
      }
    }
    if (!mounted) return;
    setState(() {
      _submitting = false;
    });
    if (result.accepted) widget.onAccepted?.call();
  }

  @override
  Widget build(BuildContext context) {
    final assistance = _ink.attempt.assistance;
    final target = widget.target;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF1E7D5),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            assistance == InkAssistance.recall
                ? 'Recall ${target.label}'
                : 'Write ${target.glyph}',
            style: const TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.w800,
              color: Color(0xFF153D40),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            assistance == InkAssistance.recall
                ? 'Write ${target.label} from memory on the blank label.'
                : target.instruction,
            style: const TextStyle(
              fontSize: 24,
              height: 1.45,
              color: Color(0xFF153D40),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: InkAssistance.values
                .map(
                  (mode) => ChoiceChip(
                    label: Text(switch (mode) {
                      InkAssistance.guided => '1 · Trace',
                      InkAssistance.copy => '2 · Copy',
                      InkAssistance.recall => '3 · Recall',
                    }, style: const TextStyle(fontSize: 22)),
                    selected: assistance == mode,
                    onSelected: _submitting
                        ? null
                        : (_) => _reset(assistance: mode),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 10,
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          if (assistance == InkAssistance.copy)
            SizedBox(
              height: 120,
              child: CustomPaint(
                painter: InkPainter(
                  controller: InkController(target: target),
                  showGuide: true,
                ),
              ),
            ),
          if (assistance == InkAssistance.recall)
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text(
                'The guide is hidden. Write from memory. You can return to Trace whenever you need it.',
                style: TextStyle(fontSize: 22),
              ),
            ),
          AbsorbPointer(
            absorbing: _result != null || _submitting,
            child: InkCanvas(
              controller: _ink,
              showGuide: assistance == InkAssistance.guided,
              height: MediaQuery.sizeOf(context).width < 450 ? 280 : 330,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              FilledButton.icon(
                onPressed: _result == null && !_submitting ? _submit : null,
                icon: const Icon(Icons.check),
                label: const Text('Check my writing'),
              ),
              OutlinedButton.icon(
                onPressed: _submitting ? null : () => _reset(),
                icon: const Icon(Icons.refresh),
                label: const Text('Try again'),
              ),
              OutlinedButton.icon(
                onPressed: _result != null || _submitting ? null : _ink.undo,
                icon: const Icon(Icons.undo),
                label: const Text('Undo stroke'),
              ),
              TextButton.icon(
                onPressed: _submitting
                    ? null
                    : () {
                        _reset(assistance: InkAssistance.guided);
                        showDialog<void>(
                          context: context,
                          builder: (_) => InkDemonstration(target: target),
                        );
                      },
                icon: const Icon(Icons.play_arrow),
                label: const Text('Watch a demo'),
              ),
            ],
          ),
          if (_result != null) ...[
            const SizedBox(height: 16),
            Semantics(
              liveRegion: true,
              child: Text(
                _result!.feedback,
                style: const TextStyle(
                  fontSize: 26,
                  height: 1.4,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (_result!.accepted && assistance != InkAssistance.recall)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: FilledButton(
                  onPressed: _submitting
                      ? null
                      : () => _reset(
                          assistance:
                              InkAssistance.values[assistance.index + 1],
                        ),
                  child: const Text('Try with less help'),
                ),
              ),
          ],
          if (_saveStatus != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(_saveStatus!, style: const TextStyle(fontSize: 20)),
            ),
          if (widget.onContinueWithoutWriting != null)
            TextButton(
              onPressed: widget.onContinueWithoutWriting,
              child: const Text('Continue the story with help'),
            ),
          const SizedBox(height: 12),
          const Text(
            'This checks one practice shape and its dots. It is not a test of fluent handwriting. The guide and tolerances still need Arabic educator review.',
            style: TextStyle(
              fontSize: 18,
              height: 1.4,
              color: Color(0xFF455B59),
            ),
          ),
        ],
      ),
    );
  }
}

class InkDemonstration extends StatefulWidget {
  const InkDemonstration({super.key, required this.target});
  final InkTarget target;
  @override
  State<InkDemonstration> createState() => _InkDemonstrationState();
}

class _InkDemonstrationState extends State<InkDemonstration> {
  late final InkController _ink;
  Timer? _timer;
  int _time = 0;
  late int _duration;
  @override
  void initState() {
    super.initState();
    _ink = InkController(target: widget.target);
    final points = resamplePath(widget.target.body);
    var time = 0;
    _ink.attempt.strokes.add(
      InkStroke(
        pointerKind: 'demonstration',
        samples: points.map((p) {
          time += 30000;
          return InkSample(position: p, elapsedMicros: time);
        }).toList(),
      ),
    );
    for (final dot in widget.target.dots) {
      time += 450000;
      _ink.attempt.strokes.add(
        InkStroke(
          pointerKind: 'demonstration',
          samples: [InkSample(position: dot, elapsedMicros: time)],
        ),
      );
    }
    _duration = time + 1000000;
    _timer = Timer.periodic(const Duration(milliseconds: 40), (_) {
      if (mounted) {
        setState(() {
          _time = (_time + 40000) % _duration;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ink.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(
      'Watch ${widget.target.glyph}',
      style: const TextStyle(fontSize: 32),
    ),
    content: SizedBox(
      width: 560,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.target.instruction,
              style: const TextStyle(fontSize: 24),
            ),
            InkCanvas(
              controller: _ink,
              height: 260,
              replayMicros: MediaQuery.disableAnimationsOf(context)
                  ? _duration
                  : _time,
            ),
            const Text(
              'Watching is practice, not a submitted writing attempt.',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('My turn', style: TextStyle(fontSize: 24)),
      ),
    ],
  );
}
