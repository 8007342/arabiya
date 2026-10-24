import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'ink_canvas.dart';
import 'ink_model.dart';
import 'ink_workspace.dart';

class InkStudioWorkspace extends StatefulWidget {
  const InkStudioWorkspace({
    super.key,
    required this.controller,
    this.broadNib = false,
  });
  final InkController controller;
  final bool broadNib;
  @override
  State<InkStudioWorkspace> createState() => _InkStudioWorkspaceState();
}

class _InkStudioWorkspaceState extends State<InkStudioWorkspace> {
  Timer? _timer;
  int? _replayMicros;
  InkController get _ink => widget.controller;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _stop() {
    _timer?.cancel();
    setState(() => _replayMicros = null);
  }

  void _replay() {
    if (_replayMicros != null) {
      _stop();
      return;
    }
    final samples = _ink.attempt.strokes.expand((s) => s.samples).toList();
    if (samples.isEmpty) return;
    setState(() => _replayMicros = 0);
    final end = samples.last.elapsedMicros;
    _timer = Timer.periodic(const Duration(milliseconds: 32), (_) {
      if (!mounted) return;
      if ((_replayMicros ?? 0) >= end) {
        _stop();
        return;
      }
      setState(() => _replayMicros = (_replayMicros ?? 0) + 64000);
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Raw strokes copied.',
              style: TextStyle(fontSize: 24),
            ),
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Clipboard is unavailable.',
              style: TextStyle(fontSize: 24),
            ),
          ),
        );
      }
    }
  }

  void _options() => showDialog<void>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, update) => AlertDialog(
        scrollable: true,
        title: const Text('Ink tools', style: TextStyle(fontSize: 32)),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final brush in InkBrush.values.where(
                  (b) => b != InkBrush.broadNib || widget.broadNib,
                ))
                  OutlinedButton.icon(
                    label: Text(switch (brush) {
                      InkBrush.round => 'Round pen',
                      InkBrush.pressure => 'Pressure brush',
                      InkBrush.broadNib => 'Broad nib',
                    }, style: const TextStyle(fontSize: 24)),
                    icon: Icon(
                      _ink.brush == brush ? Icons.check : Icons.brush_outlined,
                    ),
                    onPressed: () {
                      update(() => _ink.brush = brush);
                      _ink.changed();
                    },
                  ),
                Text(
                  'Pen width · ${_ink.width.round()}',
                  style: const TextStyle(fontSize: 24),
                ),
                Slider(
                  value: _ink.width,
                  min: 3,
                  max: 22,
                  divisions: 19,
                  onChanged: (v) {
                    update(() => _ink.width = v);
                    _ink.changed();
                  },
                ),
                if (_ink.brush == InkBrush.broadNib) ...[
                  Text(
                    'Nib angle · ${(_ink.nibAngle * 180 / math.pi).round()}°',
                    style: const TextStyle(fontSize: 24),
                  ),
                  Slider(
                    value: _ink.nibAngle,
                    min: 0,
                    max: math.pi,
                    divisions: 12,
                    onChanged: (v) {
                      update(() => _ink.nibAngle = v);
                      _ink.changed();
                    },
                  ),
                ],
                Text(
                  _ink.hasVaryingPressure ? 'Varying pen pressure detected.' : 'Finger and mouse work too. Pressure varies only when your pen reports it.',
                  style: const TextStyle(fontSize: 24, height: 1.4),
                ),
                TextButton.icon(
                  onPressed: _export,
                  icon: const Icon(Icons.copy),
                  label: const Text(
                    'Copy raw ink',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Back to drawing',
              style: TextStyle(fontSize: 24),
            ),
          ),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => InkWorkspace(
    title: widget.broadNib ? 'Ribbon garden' : 'Free ink',
    controller: _ink,
    onClose: () => Navigator.pop(context),
    onOptions: _options,
    replayMicros: _replayMicros,
    actions: Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              _stop();
              _ink.undo();
            },
            icon: const Icon(Icons.undo),
            label: const Text('Undo', style: TextStyle(fontSize: 24)),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              _stop();
              _ink.clear();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Clear', style: TextStyle(fontSize: 24)),
          ),
        ),
        IconButton(
          tooltip: _replayMicros == null ? 'Replay ink' : 'Stop replay',
          onPressed: _replay,
          icon: Icon(
            _replayMicros == null ? Icons.play_arrow : Icons.stop,
            size: 30,
          ),
          constraints: const BoxConstraints(minWidth: 56, minHeight: 56),
        ),
      ],
    ),
  );
}
