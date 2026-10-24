import 'package:flutter/material.dart';

import 'ink_canvas.dart';
import 'ink_browser_guard.dart';

/// A drawing desk never sits inside a scrolling document. Instructions and
/// palettes open separately, so neither strokes nor results move the paper.
class InkWorkspace extends StatefulWidget {
  const InkWorkspace({
    super.key,
    required this.title,
    required this.controller,
    required this.onClose,
    required this.onOptions,
    required this.actions,
    this.showGuide = false,
    this.replayMicros,
    this.canvasAspectRatio,
  });
  final String title;
  final InkController controller;
  final VoidCallback onClose;
  final VoidCallback onOptions;
  final Widget actions;
  final bool showGuide;
  final int? replayMicros;
  final double? canvasAspectRatio;

  @override
  State<InkWorkspace> createState() => _InkWorkspaceState();
}

class _InkWorkspaceState extends State<InkWorkspace> {
  late final InkBrowserGuard _browserGuard;
  @override
  void initState() {
    super.initState();
    _browserGuard = InkBrowserGuard();
  }

  @override
  void dispose() {
    _browserGuard.dispose();
    super.dispose();
  }

  Widget _paper() => InkCanvas(
    key: const ValueKey('fixed-writing-canvas'),
    controller: widget.controller,
    showGuide: widget.showGuide,
    replayMicros: widget.replayMicros,
    height: double.infinity,
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    resizeToAvoidBottomInset: false,
    backgroundColor: const Color(0xFF153D40),
    body: SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                IconButton(
                  tooltip: 'Close writing desk',
                  onPressed: widget.onClose,
                  color: const Color(0xFFFFF6DF),
                  icon: const Icon(Icons.close, size: 30),
                  constraints: const BoxConstraints(
                    minWidth: 56,
                    minHeight: 56,
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 28,
                      color: Color(0xFFFFF6DF),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Writing options and instructions',
                  onPressed: widget.onOptions,
                  color: const Color(0xFFFFF6DF),
                  icon: const Icon(Icons.tune, size: 30),
                  constraints: const BoxConstraints(
                    minWidth: 56,
                    minHeight: 56,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: widget.canvasAspectRatio == null
                  ? _paper()
                  : Center(
                      child: AspectRatio(
                        aspectRatio: widget.canvasAspectRatio!,
                        child: _paper(),
                      ),
                    ),
            ),
          ),
          Container(
            key: const ValueKey('fixed-writing-controls'),
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: const Color(0xFFFFF6DF),
            child: widget.actions,
          ),
        ],
      ),
    ),
  );
}
