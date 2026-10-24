import 'dart:async';

import 'package:flutter/material.dart';

import 'ink_canvas.dart';
import 'ink_evidence_store.dart';
import 'ink_model.dart';
import 'ink_rubric.dart';
import 'ink_workspace.dart';

/// Story and activity pages launch the same fixed desk. They never contain a
/// writable surface inside their own scrolling layout.
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
  final _recent = <Map<String, dynamic>>[];
  bool _matched = false;

  Future<void> _open() async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => InkPracticeWorkspace(
          target: widget.target,
          evidence: widget.evidence == null
              ? null
              : [...widget.evidence!, ..._recent],
          onEvidence: (event) {
            _recent.add(event);
            widget.onEvidence?.call(event);
          },
          onAccepted: () {
            if (mounted) setState(() => _matched = true);
            widget.onAccepted?.call();
          },
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant InkPracticeCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.target != widget.target ||
        oldWidget.evidence != widget.evidence) {
      _recent.clear();
      _matched = false;
    }
  }

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: const Color(0xFFF1E7D5),
      borderRadius: BorderRadius.circular(28),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Write ${widget.target.glyph}',
          style: const TextStyle(
            fontSize: 38,
            fontWeight: FontWeight.w800,
            color: Color(0xFF153D40),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'A steady page for your pen or finger.',
          style: TextStyle(fontSize: 24, height: 1.4),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          key: const ValueKey('open-writing-desk'),
          onPressed: _open,
          icon: const Icon(Icons.draw_outlined),
          label: const Text('Start writing', style: TextStyle(fontSize: 26)),
        ),
        if (_matched)
          const Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text(
              'Shape matched. Your practice was checked.',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
            ),
          ),
        if (widget.onContinueWithoutWriting != null)
          TextButton(
            onPressed: widget.onContinueWithoutWriting,
            child: const Text('Continue the story with help'),
          ),
      ],
    ),
  );
}

class InkPracticeWorkspace extends StatefulWidget {
  const InkPracticeWorkspace({
    super.key,
    required this.target,
    this.evidence,
    this.onAccepted,
    this.onEvidence,
  });
  final InkTarget target;
  final List<Map<String, dynamic>>? evidence;
  final VoidCallback? onAccepted;
  final ValueChanged<Map<String, dynamic>>? onEvidence;
  @override
  State<InkPracticeWorkspace> createState() => _InkPracticeWorkspaceState();
}

class _InkPracticeWorkspaceState extends State<InkPracticeWorkspace> {
  late final InkController _ink;
  InkAssessment? _result;
  bool _submitting = false;
  bool _edited = false;

  @override
  void initState() {
    super.initState();
    _ink = InkController(target: widget.target);
    _restore();
  }

  Future<void> _restore() async {
    final entries = widget.evidence ?? await InkEvidenceStore().read();
    if (!mounted || _edited || _ink.attempt.strokes.isNotEmpty) return;
    final previous = entries
        .where(
          (e) => e['target'] == widget.target.name && e['accepted'] == true,
        )
        .lastOrNull?['assistance'];
    setState(
      () => _ink.clear(
        assistance: previous == null
            ? InkAssistance.guided
            : previous == 'guided'
            ? InkAssistance.copy
            : InkAssistance.recall,
      ),
    );
  }

  @override
  void didUpdateWidget(covariant InkPracticeWorkspace oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.target != widget.target ||
        oldWidget.evidence != widget.evidence) {
      _edited = false;
      _result = null;
      _ink.clear(target: widget.target, assistance: InkAssistance.guided);
      _restore();
    }
  }

  @override
  void dispose() {
    _ink.dispose();
    super.dispose();
  }

  void _reset({InkAssistance? assistance}) {
    setState(() {
      _edited = true;
      _ink.clear(assistance: assistance);
      _result = null;
    });
  }

  Future<void> _submit() async {
    if (_submitting || _result != null || _ink.isDrawing) return;
    final attempt = _ink.attempt;
    final result = InkRubric().assess(attempt);
    setState(() {
      _result = result;
      _submitting = true;
    });
    // Feedback is shown before storage/network work; it never changes paper size.
    unawaited(_showResult(result, attempt.assistance));
    final now = DateTime.now().toUtc();
    final event = <String, dynamic>{
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
    try {
      widget.onEvidence?.call(event);
      await InkEvidenceStore().record(attempt, result);
      if (result.accepted) await InkEvidenceStore().unlockCalligraphy();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Your writing was checked, but this device could not save the practice.',
              style: TextStyle(fontSize: 24),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
    if (mounted && result.accepted) widget.onAccepted?.call();
  }

  Future<void> _showResult(
    InkAssessment result,
    InkAssistance assistance,
  ) => showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => Dialog.fullscreen(
      key: const ValueKey('writing-check-result'),
      backgroundColor: const Color(0xFFFFF6DF),
      child: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                tooltip: 'Look at my writing',
                constraints: const BoxConstraints(minWidth: 56, minHeight: 56),
                onPressed: () => Navigator.pop(dialogContext),
                icon: const Icon(Icons.close, size: 32),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 640),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Icon(
                          result.accepted
                              ? Icons.check_circle
                              : Icons.edit_outlined,
                          size: 72,
                          color: const Color(0xFF153D40),
                        ),
                        const SizedBox(height: 20),
                        Semantics(
                          liveRegion: true,
                          child: Text(
                            result.accepted
                                ? 'Shape matched!'
                                : 'Checked · Try again',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          result.feedback,
                          style: const TextStyle(fontSize: 26, height: 1.45),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    _reset(
                      assistance:
                          result.accepted && assistance != InkAssistance.recall
                          ? InkAssistance.values[assistance.index + 1]
                          : null,
                    );
                  },
                  child: Text(
                    result.accepted && assistance != InkAssistance.recall
                        ? 'Less help'
                        : 'Try again',
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  void _options() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        scrollable: true,
        title: Text(
          'Writing ${widget.target.label}',
          style: const TextStyle(fontSize: 32),
        ),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.target.instruction,
                  style: const TextStyle(fontSize: 26, height: 1.4),
                ),
                const SizedBox(height: 18),
                for (final mode in InkAssistance.values)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _reset(assistance: mode);
                      },
                      child: Text(switch (mode) {
                        InkAssistance.guided => '1 · Trace',
                        InkAssistance.copy => '2 · Copy',
                        InkAssistance.recall => '3 · Recall',
                      }, style: const TextStyle(fontSize: 24)),
                    ),
                  ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    showDialog<void>(
                      context: context,
                      builder: (_) => InkDemonstration(target: widget.target),
                    );
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text(
                    'Watch a demo',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Checks compare this practice shape and its dots. They do not measure writing fluency.',
                  style: TextStyle(fontSize: 24, height: 1.4),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Back to writing',
              style: TextStyle(fontSize: 24),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final assistance = _ink.attempt.assistance;
    return InkWorkspace(
      title: switch (assistance) {
        InkAssistance.guided => 'Trace ${widget.target.glyph}',
        InkAssistance.copy => 'Copy ${widget.target.glyph}',
        InkAssistance.recall => 'Recall ${widget.target.label}',
      },
      controller: _ink,
      canvasAspectRatio: 1.25,
      onClose: () => Navigator.pop(context),
      onOptions: _options,
      showGuide: assistance == InkAssistance.guided,
      actions: AnimatedBuilder(
        animation: _ink,
        builder: (context, _) => Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                key: const ValueKey('check-writing'),
                onPressed: _result == null && !_submitting && !_ink.isDrawing
                    ? _submit
                    : null,
                icon: const Icon(Icons.check),
                label: const Text(
                  'Check my writing',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              tooltip: 'Try again',
              onPressed: _submitting ? null : () => _reset(),
              constraints: const BoxConstraints(minWidth: 56, minHeight: 56),
              icon: const Icon(Icons.refresh, size: 30),
            ),
            IconButton(
              tooltip: _result == null ? 'Undo stroke' : 'Show check result',
              onPressed: _result == null
                  ? _ink.undo
                  : () => _showResult(_result!, assistance),
              constraints: const BoxConstraints(minWidth: 56, minHeight: 56),
              icon: Icon(
                _result == null
                    ? Icons.undo
                    : _result!.accepted
                    ? Icons.check_circle
                    : Icons.info_outline,
                size: 30,
              ),
            ),
          ],
        ),
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
    scrollable: true,
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
