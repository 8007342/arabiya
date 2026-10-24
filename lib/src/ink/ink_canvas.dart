import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'ink_model.dart';

class InkController extends ChangeNotifier {
  InkController({
    InkTarget target = InkTarget.ba,
    InkAssistance assistance = InkAssistance.guided,
  }) : attempt = InkAttempt(target: target, assistance: assistance);
  InkAttempt attempt;
  InkBrush brush = InkBrush.round;
  double nibAngle = math.pi / 4;
  double width = 9;
  int revision = 0;
  void changed() {
    revision++;
    notifyListeners();
  }

  void clear({InkTarget? target, InkAssistance? assistance}) {
    attempt = InkAttempt(
      target: target ?? attempt.target,
      assistance: assistance ?? attempt.assistance,
    );
    changed();
  }

  void undo() {
    if (attempt.strokes.isNotEmpty) {
      attempt.strokes.removeLast();
      changed();
    }
  }

  List<double> get pressures => attempt.strokes
      .expand((s) => s.samples)
      .map((s) => s.pressure)
      .whereType<double>()
      .toList();
  bool get hasVaryingPressure {
    final p = pressures.where((p) => p > 0).toList();
    return p.isNotEmpty && p.reduce(math.max) - p.reduce(math.min) > .04;
  }
}

class InkCanvas extends StatefulWidget {
  const InkCanvas({
    super.key,
    required this.controller,
    this.showGuide = true,
    this.replayMicros,
    this.height = 300,
  });
  final InkController controller;
  final bool showGuide;
  final int? replayMicros;
  final double height;
  @override
  State<InkCanvas> createState() => _InkCanvasState();
}

class _InkCanvasState extends State<InkCanvas> {
  int? _pointer;
  InkStroke? _stroke;
  Duration? _origin;
  final Map<int, PointerDeviceKind> _pointers = {};
  InkSample _sample(PointerEvent e, Size size) {
    _origin ??= e.timeStamp;
    final pen =
        e.kind == PointerDeviceKind.stylus ||
        e.kind == PointerDeviceKind.invertedStylus;
    final range = e.pressureMax - e.pressureMin;
    return InkSample(
      position: Offset(
        (e.localPosition.dx / size.width).clamp(0.0, 1.0),
        (e.localPosition.dy / size.height).clamp(0.0, 1.0),
      ),
      rawPosition: e.localPosition,
      canvasSize: size,
      elapsedMicros: (e.timeStamp - _origin!).inMicroseconds,
      pressure: pen && range > 0
          ? ((e.pressure - e.pressureMin) / range).clamp(0.0, 1.0)
          : null,
      tilt: pen ? e.tilt : null,
      orientation: pen ? e.orientation : null,
    );
  }

  void _down(PointerDownEvent event, Size size) {
    if (widget.replayMicros != null) return;
    _pointers[event.pointer] = event.kind;
    final incomingPen =
        event.kind == PointerDeviceKind.stylus ||
        event.kind == PointerDeviceKind.invertedStylus;
    if (_pointer != null && incomingPen && _stroke?.pointerKind == 'touch') {
      _stroke!.cancelled = true;
      _pointer = null;
      _stroke = null;
    }
    if (_pointer != null) return;
    if (event.kind == PointerDeviceKind.mouse &&
        event.buttons != kPrimaryMouseButton) {
      return;
    }
    if (event.kind == PointerDeviceKind.touch &&
        _pointers.values.any((kind) => kind == PointerDeviceKind.stylus)) {
      return;
    }
    _pointer = event.pointer;
    if (widget.controller.attempt.strokes.isEmpty) _origin = event.timeStamp;
    _stroke = InkStroke(
      pointerKind: event.kind.name,
      brush: widget.controller.brush,
      nibAngle: widget.controller.nibAngle,
      width: widget.controller.width,
      samples: [_sample(event, size)],
    );
    widget.controller.attempt.strokes.add(_stroke!);
    widget.controller.changed();
  }

  void _move(PointerMoveEvent event, Size size) {
    if (_pointer != event.pointer || _stroke == null) return;
    // A clear/target change cannot reconnect the old pointer into a new attempt.
    if (!widget.controller.attempt.strokes.contains(_stroke)) {
      _pointer = null;
      _stroke = null;
      return;
    }
    _stroke!.samples.add(_sample(event, size));
    widget.controller.changed();
  }

  void _up(PointerEvent event, Size size, {bool cancelled = false}) {
    _pointers.remove(event.pointer);
    if (_pointer != event.pointer || _stroke == null) return;
    _stroke!.cancelled = cancelled;
    if (!cancelled) _stroke!.samples.add(_sample(event, size));
    _pointer = null;
    _stroke = null;
    widget.controller.changed();
  }

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Writing canvas. Use a pen, finger, or mouse. Submit with Check my writing below.',
    child: SizedBox(
      height: widget.height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth, constraints.maxHeight);
          return ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Listener(
              behavior: HitTestBehavior.opaque,
              onPointerDown: (e) => _down(e, size),
              onPointerMove: (e) => _move(e, size),
              onPointerUp: (e) => _up(e, size),
              onPointerCancel: (e) => _up(e, size, cancelled: true),
              child: GestureDetector(
                onPanStart: (_) {},
                onPanUpdate: (_) {},
                child: AnimatedBuilder(
                  animation: widget.controller,
                  builder: (context, _) => CustomPaint(
                    size: size,
                    painter: InkPainter(
                      controller: widget.controller,
                      showGuide: widget.showGuide,
                      replayMicros: widget.replayMicros,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}

class InkPainter extends CustomPainter {
  InkPainter({
    required this.controller,
    required this.showGuide,
    this.replayMicros,
  }) : revision = controller.revision;
  final InkController controller;
  final bool showGuide;
  final int? replayMicros;
  final int revision;
  Offset _scale(Offset p, Size size) =>
      Offset(p.dx * size.width, p.dy * size.height);
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFFFFFAEF),
    );
    final baseline = Paint()
      ..color = const Color(0xFFDDD0B9)
      ..strokeWidth = 1.5;
    for (final y in [.35, .66]) {
      canvas.drawLine(
        Offset(0, size.height * y),
        Offset(size.width, size.height * y),
        baseline,
      );
    }
    if (showGuide) {
      final target = controller.attempt.target;
      final guide = Paint()
        ..color = const Color(0xFFBCCBC5)
        ..strokeWidth = 16
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;
      final path = Path()
        ..moveTo(
          target.body.first.dx * size.width,
          target.body.first.dy * size.height,
        );
      for (final point in target.body.skip(1)) {
        final p = _scale(point, size);
        path.lineTo(p.dx, p.dy);
      }
      canvas.drawPath(path, guide);
      for (final dot in target.dots) {
        canvas.drawCircle(
          _scale(dot, size),
          8,
          Paint()..color = const Color(0xFFBCCBC5),
        );
      }
      canvas.drawCircle(
        _scale(target.body.first, size),
        11,
        Paint()
          ..color = const Color(0xFFB5553F)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3,
      );
    }
    final ink = Paint()
      ..color = const Color(0xFF153D40)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    for (final stroke in controller.attempt.strokes) {
      if (stroke.cancelled) continue;
      final samples = stroke.samples
          .where(
            (s) => replayMicros == null || s.elapsedMicros <= replayMicros!,
          )
          .toList();
      if (samples.isEmpty) continue;
      if (samples.length == 1) {
        canvas.drawCircle(
          _scale(samples.first.position, size),
          stroke.width / 2,
          ink,
        );
      }
      for (var i = 1; i < samples.length; i++) {
        final a = _scale(samples[i - 1].position, size);
        final b = _scale(samples[i].position, size);
        final pressure = samples[i].pressure ?? .5;
        final pressureWidth = stroke.width * (.35 + pressure * 1.3);
        ink.strokeWidth = switch (stroke.brush) {
          InkBrush.round => stroke.width,
          InkBrush.pressure => pressureWidth,
          InkBrush.broadNib =>
            stroke.width *
                (.25 +
                    1.8 * math.sin((b - a).direction - stroke.nibAngle).abs()) *
                (.7 + pressure * .6),
        };
        canvas.drawLine(a, b, ink);
      }
    }
  }

  @override
  bool shouldRepaint(covariant InkPainter oldDelegate) =>
      oldDelegate.revision != revision ||
      oldDelegate.showGuide != showGuide ||
      oldDelegate.replayMicros != replayMicros;
}
