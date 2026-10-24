// @trace spec:arabiya, spec:character-canon
import 'dart:math' as math;
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../models/comic_models.dart';

class ArabiyaComicGame extends FlameGame {
  ComicPanelData currentPanel;
  final VoidCallback? onCharacterTapped;

  double _time = 0.0;
  double _transitionFlash = 0.0;
  double _rewindEffect = 0.0;

  ArabiyaComicGame({
    required this.currentPanel,
    this.onCharacterTapped,
  });

  void updatePanel(ComicPanelData nextPanel, {bool isRewind = false}) {
    currentPanel = nextPanel;
    _transitionFlash = 1.0;
    if (isRewind) {
      _rewindEffect = 1.0;
    }
  }

  @override
  Color backgroundColor() => const Color(0x00000000);

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;
    if (_transitionFlash > 0) {
      _transitionFlash = math.max(0.0, _transitionFlash - dt * 3.0);
    }
    if (_rewindEffect > 0) {
      _rewindEffect = math.max(0.0, _rewindEffect - dt * 1.4);
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final w = size.x;
    final h = size.y;
    if (w <= 0 || h <= 0) return;

    _drawAtmosphericLightAndParticles(canvas, w, h);
    _drawHangingTillandsias(canvas, w, h);
    _drawBlushSparklesIfActive(canvas, w, h);

    if (_transitionFlash > 0) {
      canvas.drawRect(
        Rect.fromLTWH(0, 0, w, h),
        Paint()
          ..color = const Color(0xFFFFF8E7).withValues(
            alpha: (_transitionFlash * 0.22).clamp(0.0, 1.0),
          ),
      );
    }

    if (_rewindEffect > 0) {
      _drawRewindTimeWarp(canvas, w, h);
    }
  }

  void _drawAtmosphericLightAndParticles(Canvas canvas, double w, double h) {
    // Subtle sunbeams / lantern glow across the full-screen comic stage
    final rayPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          const Color(0xFFFFE4A0).withValues(alpha: 0.14),
          const Color(0x00FFE4A0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    final rayPath = Path()
      ..moveTo(w * 0.65, 0)
      ..lineTo(w, 0)
      ..lineTo(w * 0.45, h)
      ..lineTo(w * 0.15, h)
      ..close();
    canvas.drawPath(rayPath, rayPaint);

    // Floating golden dust motes & Right-to-Left calligraphic wind particles
    for (var i = 0; i < 18; i++) {
      final seed = i * 1.618;
      // Drift gently from Right to Left (reinforcing Arabic RTL reading flow!)
      final progress = ((_time * (0.025 + (i % 4) * 0.008) + seed) % 1.0);
      final px = w * (1.0 - progress);
      final py = h * ((0.12 + (i * 0.073) % 0.72) +
          math.sin(_time * 1.5 + i) * 0.015);
      final alpha = (math.sin(progress * math.pi) * 0.55).clamp(0.05, 0.55);
      final radius = 1.8 + (i % 3) * 1.3;

      canvas.drawCircle(
        Offset(px, py),
        radius * 2.2,
        Paint()..color = const Color(0xFFFFD57E).withValues(alpha: alpha * 0.35),
      );
      canvas.drawCircle(
        Offset(px, py),
        radius,
        Paint()..color = const Color(0xFFFFF6D6).withValues(alpha: alpha),
      );
    }
  }

  void _drawHangingTillandsias(Canvas canvas, double w, double h) {
    // Swaying Tillandsia air plants in the upper frame corners (signature forge motif)
    final positions = [w * 0.06, w * 0.94];
    for (var idx = 0; idx < positions.length; idx++) {
      final bx = positions[idx];
      final sway = math.sin(_time * 1.6 + idx * 1.4) * 5.0;
      canvas.save();
      canvas.translate(bx, 0);

      // Hanging cord
      canvas.drawLine(
        Offset.zero,
        Offset(sway * 0.4, 38),
        Paint()
          ..color = const Color(0xFF3E2C1E).withValues(alpha: 0.75)
          ..strokeWidth = 2.0,
      );

      // Silvery-green Tillandsia leaves
      final leafPaint = Paint()
        ..color = const Color(0xFF5FA88A).withValues(alpha: 0.88)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.2
        ..strokeCap = StrokeCap.round;

      for (var l = -3; l <= 3; l++) {
        final path = Path()
          ..moveTo(sway * 0.4, 36)
          ..quadraticBezierTo(
            sway + l * 10.0,
            56 + l.abs() * 4.0,
            sway * 1.3 + l * 15.0,
            76 - l.abs() * 3.0,
          );
        canvas.drawPath(path, leafPaint);
      }
      canvas.restore();
    }
  }

  void _drawBlushSparklesIfActive(Canvas canvas, double w, double h) {
    final isBlushing =
        currentPanel.tlatoaniEmotion == EmotionState.blushing ||
            currentPanel.speakerEmotion == EmotionState.blushing;
    if (!isBlushing) return;

    // Draw floating coral-pink sparkles around Tlatoāni on the left side of the stage
    final baseX = w * 0.20;
    final baseY = h * 0.56;
    for (var i = 0; i < 6; i++) {
      final phase = (_time * 1.8 + i * 1.05) % (math.pi * 2);
      final sx = baseX + math.cos(phase + i) * (55 + i * 12);
      final sy = baseY - 40 - ((_time * 28 + i * 22) % 90);
      final scale = (0.6 + math.sin(_time * 4 + i) * 0.35).clamp(0.2, 1.0);

      canvas.drawCircle(
        Offset(sx, sy),
        4.0 * scale,
        Paint()..color = const Color(0xFFFF7A9A).withValues(alpha: 0.75),
      );
    }
  }

  void _drawRewindTimeWarp(Canvas canvas, double w, double h) {
    final alpha = (_rewindEffect * 0.42).clamp(0.0, 1.0);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, w, h),
      Paint()..color = const Color(0xFF1A3A4A).withValues(alpha: alpha),
    );
    final stripePaint = Paint()
      ..color = const Color(0xFF62D6D1).withValues(alpha: alpha * 0.9)
      ..strokeWidth = 3.0;
    for (var i = 0; i < 10; i++) {
      final y = (h / 10) * i + ((_time * 240) % (h / 10));
      canvas.drawLine(Offset(0, y), Offset(w, y), stripePaint);
    }
  }
}
