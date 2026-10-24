// @trace spec:arabiya, spec:curriculum-and-comics
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/comic_models.dart';

class ArabicGlyphTracer extends StatefulWidget {
  final ArabicLetterLesson lesson;
  final VoidCallback onSpeakLetter;
  final VoidCallback onTraceCompleted;

  const ArabicGlyphTracer({
    super.key,
    required this.lesson,
    required this.onSpeakLetter,
    required this.onTraceCompleted,
  });

  @override
  State<ArabicGlyphTracer> createState() => _ArabicGlyphTracerState();
}

class _ArabicGlyphTracerState extends State<ArabicGlyphTracer> {
  final List<Offset> _userPoints = [];
  double _progress = 0.0;
  bool _completed = false;

  @override
  void didUpdateWidget(covariant ArabicGlyphTracer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lesson.letter != widget.lesson.letter) {
      _reset();
    }
  }

  void _reset() {
    setState(() {
      _userPoints.clear();
      _progress = 0.0;
      _completed = false;
    });
  }

  List<Offset> _flattenedWaypoints(Size size) {
    final out = <Offset>[];
    for (final stroke in widget.lesson.strokeWaypoints) {
      for (final pt in stroke) {
        out.add(Offset(pt.dx * size.width, pt.dy * size.height));
      }
    }
    if (out.isEmpty) {
      out.addAll([
        Offset(size.width * 0.78, size.height * 0.45),
        Offset(size.width * 0.50, size.height * 0.62),
        Offset(size.width * 0.22, size.height * 0.45),
      ]);
    }
    return out;
  }

  void _handlePanUpdate(Offset localPos, Size canvasSize) {
    if (_completed) return;
    final waypoints = _flattenedWaypoints(canvasSize);
    setState(() {
      _userPoints.add(localPos);
      // Measure how many waypoints have been approached within tolerance
      var matched = 0;
      final tolerance = canvasSize.shortestSide * 0.24;
      for (final wp in waypoints) {
        final hit = _userPoints.any((p) => (p - wp).distance <= tolerance);
        if (hit) matched++;
      }
      final strokeCoverage = (matched / waypoints.length).clamp(0.0, 1.0);
      final dragLengthBonus = (_userPoints.length / 18.0).clamp(0.0, 1.0);
      _progress = math.max(strokeCoverage, dragLengthBonus * 0.85);
      if (_progress >= 0.70 && !_completed) {
        _completed = true;
        _progress = 1.0;
        widget.onSpeakLetter();
        widget.onTraceCompleted();
      }
    });
  }

  void _completeDirectly() {
    if (_completed) return;
    setState(() {
      _progress = 1.0;
      _completed = true;
    });
    widget.onSpeakLetter();
    widget.onTraceCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final lesson = widget.lesson;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF8EE),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _completed ? const Color(0xFF276D69) : const Color(0xFFD4AF37),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF123E42),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${lesson.letter}  •  ${lesson.nameTranslit} (${lesson.nameArabic})',
                  style: const TextStyle(
                    color: Color(0xFFFFD166),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filledTonal(
                tooltip: 'Hear Arabic pronunciation',
                onPressed: widget.onSpeakLetter,
                icon: const Icon(Icons.volume_up_rounded),
              ),
              const Spacer(),
              if (_completed)
                const Chip(
                  avatar: Icon(
                    Icons.check_circle,
                    color: Color(0xFF276D69),
                    size: 18,
                  ),
                  label: Text('¡Trazo Dominado! / Traced!'),
                  backgroundColor: Color(0xFFD8F3DC),
                )
              else
                TextButton.icon(
                  onPressed: _completeDirectly,
                  icon: const Icon(Icons.auto_fix_high, size: 18),
                  label: const Text('Demo & Complete Stroke'),
                ),
            ],
          ),
          const SizedBox(height: 8),
          // 4 Contextual Positional Forms Bar (Right-to-Left order)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _PositionalFormChip(
                  label: 'Isolated (Aislada)',
                  glyph: lesson.forms['isolated'] ?? lesson.letter,
                ),
                const SizedBox(width: 6),
                _PositionalFormChip(
                  label: 'Initial (Inicial →)',
                  glyph: lesson.forms['initial'] ?? lesson.letter,
                ),
                const SizedBox(width: 6),
                _PositionalFormChip(
                  label: 'Medial (Media)',
                  glyph: lesson.forms['medial'] ?? lesson.letter,
                ),
                const SizedBox(width: 6),
                _PositionalFormChip(
                  label: 'Final (← Final)',
                  glyph: lesson.forms['final'] ?? lesson.letter,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '🇪🇸 ${lesson.spanishPhoneticTip}\n🇺🇸 ${lesson.englishPhoneticTip}',
            style: const TextStyle(
              fontSize: 12.5,
              color: Color(0xFF3D342E),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 150,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final canvasSize = Size(
                  constraints.maxWidth,
                  constraints.maxHeight,
                );
                return GestureDetector(
                  onPanStart: (d) =>
                      _handlePanUpdate(d.localPosition, canvasSize),
                  onPanUpdate: (d) =>
                      _handlePanUpdate(d.localPosition, canvasSize),
                  onTapDown: (d) =>
                      _handlePanUpdate(d.localPosition, canvasSize),
                  child: CustomPaint(
                    size: canvasSize,
                    painter: _CalligraphyTracerPainter(
                      lesson: lesson,
                      userPoints: _userPoints,
                      progress: _progress,
                      completed: _completed,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PositionalFormChip extends StatelessWidget {
  final String label;
  final String glyph;

  const _PositionalFormChip({
    required this.label,
    required this.glyph,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFEFE0C4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Color(0xFF4A3F35)),
          ),
          const SizedBox(width: 6),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              glyph,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Color(0xFF123E42),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalligraphyTracerPainter extends CustomPainter {
  final ArabicLetterLesson lesson;
  final List<Offset> userPoints;
  final double progress;
  final bool completed;

  _CalligraphyTracerPainter({
    required this.lesson,
    required this.userPoints,
    required this.progress,
    required this.completed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(12)),
      Paint()..color = const Color(0xFFF6ECDC),
    );

    // Subtle calligraphy baseline
    final baselineY = size.height * 0.62;
    canvas.drawLine(
      Offset(16, baselineY),
      Offset(size.width - 16, baselineY),
      Paint()
        ..color = const Color(0xFFC9A04B).withValues(alpha: 0.35)
        ..strokeWidth = 1.5,
    );

    // Faint reference glyph in center
    final glyphPainter = TextPainter(
      text: TextSpan(
        text: lesson.letter,
        style: TextStyle(
          fontSize: size.height * 0.68,
          fontWeight: FontWeight.bold,
          color: completed
              ? const Color(0xFF276D69).withValues(alpha: 0.85)
              : const Color(0xFF123E42).withValues(alpha: 0.18),
        ),
      ),
      textDirection: TextDirection.rtl,
    )..layout();
    glyphPainter.paint(
      canvas,
      Offset(
        (size.width - glyphPainter.width) / 2,
        (size.height - glyphPainter.height) / 2,
      ),
    );

    // Draw Right-to-Left guide path
    final guidePaint = Paint()
      ..color = const Color(0xFFC9A04B).withValues(alpha: 0.55)
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    Offset? firstPoint;
    for (final stroke in lesson.strokeWaypoints) {
      if (stroke.isEmpty) continue;
      final path = Path();
      final p0 = Offset(stroke.first.dx * size.width, stroke.first.dy * size.height);
      firstPoint ??= p0;
      path.moveTo(p0.dx, p0.dy);
      for (var i = 1; i < stroke.length; i++) {
        path.lineTo(stroke[i].dx * size.width, stroke[i].dy * size.height);
      }
      canvas.drawPath(path, guidePaint);
    }

    // Pulsing RTL start indicator ring on the right side
    if (firstPoint != null && !completed) {
      canvas.drawCircle(
        firstPoint,
        11,
        Paint()..color = const Color(0xFFEC6F7B).withValues(alpha: 0.85),
      );
      final startTp = TextPainter(
        text: const TextSpan(
          text: '← Start RTL',
          style: TextStyle(
            color: Color(0xFF123E42),
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      startTp.paint(
        canvas,
        Offset(
          (firstPoint.dx - startTp.width / 2).clamp(8.0, size.width - 80.0),
          (firstPoint.dy - 26).clamp(4.0, size.height - 20.0),
        ),
      );
    }

    // Draw user's active calligraphic ink stroke
    if (userPoints.length > 1) {
      final inkPaint = Paint()
        ..color = const Color(0xFF276D69)
        ..strokeWidth = 8.0
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;
      final userPath = Path()..moveTo(userPoints.first.dx, userPoints.first.dy);
      for (var i = 1; i < userPoints.length; i++) {
        userPath.lineTo(userPoints[i].dx, userPoints[i].dy);
      }
      canvas.drawPath(userPath, inkPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _CalligraphyTracerPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.completed != completed ||
        oldDelegate.userPoints.length != userPoints.length ||
        oldDelegate.lesson.letter != lesson.letter;
  }
}
