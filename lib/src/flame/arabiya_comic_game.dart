// @trace spec:arabiya, spec:character-canon, spec:curriculum-and-comics
import 'dart:math' as math;
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../models/comic_models.dart';

class ArabiyaComicGame extends FlameGame with TapCallbacks {
  ComicPanelData _panel;
  final VoidCallback? onMacronTapped;
  final VoidCallback? onSpotlightTapped;

  double _time = 0.0;
  double _transitionProgress = 1.0;
  double _rewindFlash = 0.0;
  double _macronBounce = 0.0;

  ArabiyaComicGame({
    required ComicPanelData initialPanel,
    this.onMacronTapped,
    this.onSpotlightTapped,
  }) : _panel = initialPanel;

  ComicPanelData get currentPanel => _panel;

  void updatePanel(ComicPanelData nextPanel, {bool isRewind = false}) {
    _panel = nextPanel;
    _transitionProgress = 0.0;
    if (isRewind) {
      _rewindFlash = 1.0;
    }
  }

  void triggerMacronBounce() {
    _macronBounce = 1.0;
  }

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;
    if (_transitionProgress < 1.0) {
      _transitionProgress = (_transitionProgress + dt * 2.8).clamp(0.0, 1.0);
    }
    if (_rewindFlash > 0.0) {
      _rewindFlash = (_rewindFlash - dt * 1.6).clamp(0.0, 1.0);
    }
    if (_macronBounce > 0.0) {
      _macronBounce = (_macronBounce - dt * 3.0).clamp(0.0, 1.0);
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    final pos = event.localPosition;
    final w = size.x;
    final h = size.y;
    // Check if tap landed near mācron āi or its emoji bubble (upper-right / center-top area)
    final macronArea = Rect.fromCenter(
      center: Offset(w * 0.52, h * 0.36),
      width: w * 0.24,
      height: h * 0.34,
    );
    if (macronArea.contains(Offset(pos.x, pos.y))) {
      triggerMacronBounce();
      onMacronTapped?.call();
      return;
    }
    // Check if tap landed on the floating Arabic calligraphic medallion
    final spotlightArea = Rect.fromCenter(
      center: Offset(w * 0.50, h * 0.16),
      width: w * 0.44,
      height: h * 0.22,
    );
    if (spotlightArea.contains(Offset(pos.x, pos.y))) {
      onSpotlightTapped?.call();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final w = size.x;
    final h = size.y;
    if (w <= 0 || h <= 0) return;

    final ease = Curves.easeOutCubic.transform(_transitionProgress);
    canvas.save();
    // Subtle camera pan + zoom during panel transitions
    final scale = 0.96 + 0.04 * ease;
    final dx = (1.0 - ease) * 18.0;
    canvas.translate(w / 2 + dx, h / 2);
    canvas.scale(scale, scale);
    canvas.translate(-w / 2, -h / 2);

    _drawBackdrop(canvas, w, h, _panel.backdrop);
    _drawArrowFieldMotif(canvas, w, h);

    // Ground/floor stage shadow
    final floorPaint = Paint()
      ..color = const Color(0xFF1A1412).withValues(alpha: 0.18);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.50, h * 0.86),
        width: w * 0.88,
        height: h * 0.16,
      ),
      floorPaint,
    );

    // 1. Draw Covi on the left (English speaker / apprentice)
    if (_panel.presentCharacters.contains(CharacterId.covi)) {
      _drawCovi(
        canvas,
        center: Offset(w * 0.19, h * 0.67),
        scale: (h / 290.0).clamp(0.65, 1.25),
        emotion: _panel.coviEmotion,
        isSpeaking: _panel.speaker == CharacterId.covi,
      );
    }

    // 2. Draw Tlatoāni in center-left (Spanish speaker / pink axolotl sage)
    if (_panel.presentCharacters.contains(CharacterId.tlatoani)) {
      _drawTlatoani(
        canvas,
        center: Offset(w * 0.41, h * 0.69),
        scale: (h / 280.0).clamp(0.65, 1.28),
        emotion: _panel.tlatoaniEmotion,
        isSpeaking: _panel.speaker == CharacterId.tlatoani,
      );
    }

    // 3. Draw mācron āi in center-back with emoji-only speech bubble!
    _drawMacronAi(
      canvas,
      center: Offset(w * 0.58, h * 0.49),
      scale: (h / 300.0).clamp(0.62, 1.20),
      emojis: _panel.macronEmojis,
      prop: _panel.macronProp,
      isBlushingScene: _panel.tlatoaniEmotion == EmotionState.blushing,
    );

    // 4. Draw the regional Arab Axolotl heroine(s) on the right (Nūr, Yāsmīn, Laylā)
    final heroines = _panel.presentCharacters
        .where((c) =>
            c == CharacterId.nur ||
            c == CharacterId.yasmin ||
            c == CharacterId.layla)
        .toList();

    for (var i = 0; i < heroines.length; i++) {
      final heroine = heroines[i];
      final xFactor = heroines.length == 1
          ? 0.80
          : (0.72 + i * 0.11).clamp(0.68, 0.92);
      final yFactor = heroines.length == 1 ? 0.68 : (0.66 + (i % 2) * 0.04);
      _drawArabAxolotlHeroine(
        canvas,
        heroine: heroine,
        center: Offset(w * xFactor, h * yFactor),
        scale: (h / (heroines.length > 1 ? 320.0 : 280.0)).clamp(0.60, 1.25),
        emotion: _panel.heroineEmotion,
        isSpeaking: _panel.speaker == heroine,
      );
    }

    // 5. Rewind time-warp visual overlay when rewinding panels on failed check
    if (_rewindFlash > 0.0) {
      _drawRewindOverlay(canvas, w, h, _rewindFlash);
    }

    canvas.restore();
  }

  void _drawBackdrop(
    Canvas canvas,
    double w,
    double h,
    SceneBackdropType backdrop,
  ) {
    final rect = Rect.fromLTWH(0, 0, w, h);
    List<Color> skyColors;
    switch (backdrop) {
      case SceneBackdropType.dxbAirport:
        skyColors = const [Color(0xFF1E3C58), Color(0xFFD98A56), Color(0xFFF6E3BA)];
      case SceneBackdropType.dubaiCreekAbra:
        skyColors = const [Color(0xFF174E68), Color(0xFFE5955B), Color(0xFF237A82)];
      case SceneBackdropType.alFahidiCafe:
        skyColors = const [Color(0xFF3E2B23), Color(0xFFC48B5C), Color(0xFFEFE0C4)];
      case SceneBackdropType.calligraphyMuseum:
        skyColors = const [Color(0xFF102838), Color(0xFF1F5464), Color(0xFFEAD9B8)];
      case SceneBackdropType.jasmineBookshop:
        skyColors = const [Color(0xFF23493D), Color(0xFF5E8C7E), Color(0xFFF4E9D3)];
      case SceneBackdropType.levantBusStreet:
        skyColors = const [Color(0xFF2B5B84), Color(0xFF7FAAC4), Color(0xFFF2E2C4)];
      case SceneBackdropType.rooftopLounge:
        skyColors = const [Color(0xFF0F1B33), Color(0xFF283B66), Color(0xFF5D3A58)];
      case SceneBackdropType.nileFelucca:
        skyColors = const [Color(0xFF2C1E4A), Color(0xFFD66853), Color(0xFFF3B562)];
      case SceneBackdropType.cairoCinema:
        skyColors = const [Color(0xFF241623), Color(0xFF6E2B3E), Color(0xFFE0A96D)];
      case SceneBackdropType.mediaTerrace:
        skyColors = const [Color(0xFF0D1826), Color(0xFF1A3A4B), Color(0xFF2E5266)];
    }

    final skyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: skyColors,
      ).createShader(rect);
    canvas.drawRect(rect, skyPaint);

    // Twinkling stars or dust motes
    final motePaint = Paint()..color = const Color(0xFFFFF6D6).withValues(alpha: 0.55);
    for (var i = 0; i < 16; i++) {
      final px = ((i * 73.0 + _time * (4.0 + (i % 3))) % w);
      final py = ((i * 41.0) % (h * 0.55));
      final pulse = 1.2 + 1.1 * math.sin(_time * 2.5 + i);
      canvas.drawCircle(Offset(px, py), pulse, motePaint);
    }

    // Scene-specific architectural & botanical silhouettes
    if (backdrop == SceneBackdropType.dubaiCreekAbra ||
        backdrop == SceneBackdropType.nileFelucca) {
      // Shimmering water waves in lower third
      final waterRect = Rect.fromLTWH(0, h * 0.62, w, h * 0.38);
      canvas.drawRect(
        waterRect,
        Paint()
          ..color = (backdrop == SceneBackdropType.nileFelucca
                  ? const Color(0xFF1B365D)
                  : const Color(0xFF146B78))
              .withValues(alpha: 0.78),
      );
      final wavePaint = Paint()
        ..color = const Color(0xFFF8D794).withValues(alpha: 0.35)
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke;
      for (var row = 0; row < 4; row++) {
        final path = Path();
        final yBase = h * (0.67 + row * 0.07);
        path.moveTo(0, yBase);
        for (double x = 0; x <= w; x += 24) {
          final y = yBase + math.sin((x * 0.05) + _time * 2.2 + row) * 3.5;
          path.lineTo(x, y);
        }
        canvas.drawPath(path, wavePaint);
      }
      // Wooden boat deck under characters
      final boatPath = Path()
        ..moveTo(w * 0.06, h * 0.78)
        ..quadraticBezierTo(w * 0.50, h * 0.90, w * 0.94, h * 0.78)
        ..lineTo(w * 0.88, h * 0.96)
        ..lineTo(w * 0.12, h * 0.96)
        ..close();
      canvas.drawPath(boatPath, Paint()..color = const Color(0xFF6E472B));
    } else {
      // Warm sandstone / tiled floor
      canvas.drawRect(
        Rect.fromLTWH(0, h * 0.74, w, h * 0.26),
        Paint()..color = const Color(0xFFDCC39C).withValues(alpha: 0.85),
      );
    }

    // Islamic / Levantine / Andalusi decorative archways in background
    final archPaint = Paint()
      ..color = const Color(0xFFF4E9D3).withValues(alpha: 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    for (var i = 0; i < 3; i++) {
      final cx = w * (0.20 + i * 0.30);
      final archPath = Path()
        ..moveTo(cx - w * 0.11, h * 0.74)
        ..lineTo(cx - w * 0.11, h * 0.32)
        ..quadraticBezierTo(cx, h * 0.14, cx + w * 0.11, h * 0.32)
        ..lineTo(cx + w * 0.11, h * 0.74);
      canvas.drawPath(archPath, archPaint);
    }

    // Canon §25 & §30: Hanging Tillandsias & Lanterns along the top arch!
    _drawHangingTillandsiasAndLanterns(canvas, w, h);
  }

  void _drawHangingTillandsiasAndLanterns(Canvas canvas, double w, double h) {
    final sway = math.sin(_time * 1.8) * 4.0;
    final plantPaint = Paint()
      ..color = const Color(0xFF3E8E6C)
      ..strokeWidth = 2.6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (final xFactor in const [0.12, 0.35, 0.66, 0.88]) {
      final x = w * xFactor;
      // Hanging cord
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + sway * 0.5, h * 0.12),
        Paint()
          ..color = const Color(0xFF8C6D46)
          ..strokeWidth = 1.5,
      );
      // Tillandsia air-plant rosette leaves
      for (var leaf = -3; leaf <= 3; leaf++) {
        final angle = leaf * 0.32 + sway * 0.03;
        final path = Path()
          ..moveTo(x + sway * 0.5, h * 0.12)
          ..quadraticBezierTo(
            x + math.sin(angle) * 18,
            h * 0.16,
            x + math.sin(angle) * 26,
            h * 0.20 + (leaf.abs() * 2),
          );
        canvas.drawPath(path, plantPaint);
      }
    }

    // Warm glowing brass lantern in upper-left & upper-right
    for (final lxFactor in const [0.24, 0.76]) {
      final lx = w * lxFactor + sway * 0.3;
      final ly = h * 0.14;
      canvas.drawCircle(
        Offset(lx, ly),
        18 + math.sin(_time * 3.2) * 2.5,
        Paint()..color = const Color(0xFFFFD166).withValues(alpha: 0.24),
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(lx, ly), width: 12, height: 18),
          const Radius.circular(4),
        ),
        Paint()..color = const Color(0xFFFFB703),
      );
    }
  }

  // Canon §33–34: Field of Arrows ("Tlatoāni reads the field; Mācron moves through it")
  void _drawArrowFieldMotif(Canvas canvas, double w, double h) {
    final arrowPaint = Paint()
      ..color = const Color(0xFF62D6D1).withValues(alpha: 0.22)
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;

    // Right-to-Left flowing arrow stream symbolizing Arabic script directionality
    for (var i = 0; i < 6; i++) {
      final progress = ((_time * 0.18 + i / 6.0) % 1.0);
      final ax = w * (0.85 - progress * 0.70);
      final ay = h * 0.28 + math.sin(progress * math.pi * 2 + i) * 14.0;
      canvas.drawLine(Offset(ax + 14, ay), Offset(ax, ay), arrowPaint);
      canvas.drawLine(Offset(ax + 5, ay - 4), Offset(ax, ay), arrowPaint);
      canvas.drawLine(Offset(ax + 5, ay + 4), Offset(ax, ay), arrowPaint);
    }
  }

  // Canon §2–13: Tlatoāni — Pink Axolotl Sage (SINGLE tail, coral feathery gills, NO mustache, cream+teal Nahua tunic)
  void _drawTlatoani(
    Canvas canvas, {
    required Offset center,
    required double scale,
    required EmotionState emotion,
    required bool isSpeaking,
  }) {
    final bob = math.sin(_time * (isSpeaking ? 5.5 : 2.2)) * 3.0 * scale;
    final pos = center.translate(0, bob);
    final isBlushing = emotion == EmotionState.blushing;

    canvas.save();
    canvas.translate(pos.dx, pos.dy);
    canvas.scale(scale, scale);

    // 1. SINGLE EXPRESSIVE TAIL (Canon §3.2: "Tlatoāni has exactly one tail.")
    final tailSwing = math.sin(_time * (isBlushing ? 5.0 : 2.4)) * 10.0;
    final tailPath = Path()
      ..moveTo(-12, 34)
      ..quadraticBezierTo(-52, 42 + tailSwing, -68, 14 + tailSwing)
      ..quadraticBezierTo(-54, -4 + tailSwing, -14, 18)
      ..close();
    canvas.drawPath(
      tailPath,
      Paint()..color = const Color(0xFFF39A9A),
    );
    // Tail fin membrane highlight
    canvas.drawPath(
      tailPath,
      Paint()
        ..color = const Color(0xFFEC6F7B).withValues(alpha: 0.45)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2,
    );

    // 2. Short grounded axolotl feet
    final skinPaint = Paint()..color = const Color(0xFFF39A9A);
    canvas.drawOval(const Rect.fromLTWH(-24, 46, 18, 12), skinPaint);
    canvas.drawOval(const Rect.fromLTWH(6, 46, 18, 12), skinPaint);

    // 3. Warm Cream Tunic with Teal Nahua Stepped Geometry (Canon §7 & §9)
    final tunicRect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(-28, 2, 56, 48),
      const Radius.circular(16),
    );
    canvas.drawRRect(tunicRect, Paint()..color = const Color(0xFFEFE0C4));
    // Teal geometric border along tunic hem & collar
    canvas.drawRect(
      const Rect.fromLTWH(-26, 38, 52, 8),
      Paint()..color = const Color(0xFF276D69),
    );
    for (var step = -20; step <= 16; step += 12) {
      canvas.drawRect(
        Rect.fromLTWH(step.toDouble(), 34, 6, 4),
        Paint()..color = const Color(0xFF123E42),
      );
    }
    // Collar V-motif
    final collarPath = Path()
      ..moveTo(-12, 4)
      ..lineTo(0, 16)
      ..lineTo(12, 4);
    canvas.drawPath(
      collarPath,
      Paint()
        ..color = const Color(0xFF276D69)
        ..strokeWidth = 3.0
        ..style = PaintingStyle.stroke,
    );

    // 4. Arms + Tlatoāni's Canonical Notebook (committed memory)
    canvas.drawOval(const Rect.fromLTWH(-36, 10, 14, 22), skinPaint);
    canvas.drawOval(const Rect.fromLTWH(22, 10, 14, 22), skinPaint);
    // Small teal-and-gold notebook in left hand
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-42, 14, 14, 18),
        const Radius.circular(3),
      ),
      Paint()..color = const Color(0xFF123E42),
    );
    canvas.drawRect(
      const Rect.fromLTWH(-40, 16, 10, 14),
      Paint()..color = const Color(0xFFF4E9D3),
    );

    // 5. External Feathery Coral Gills (3 branches on each side — flutter & flush when blushing!)
    final gillFlutter =
        math.sin(_time * (isBlushing ? 11.0 : 3.2)) * (isBlushing ? 4.5 : 1.8);
    final gillColor =
        isBlushing ? const Color(0xFFFF3B5C) : const Color(0xFFEC6F7B);
    final gillPaint = Paint()..color = gillColor;

    for (final side in const [-1.0, 1.0]) {
      for (var b = 0; b < 3; b++) {
        final angle = (b - 1) * 0.34;
        final gx = side * (34 + b * 2);
        final gy = -26.0 + b * 10.0 + gillFlutter * side * (b - 1);
        canvas.save();
        canvas.translate(gx, gy);
        canvas.rotate(side * (0.25 + angle));
        canvas.drawOval(const Rect.fromLTWH(-12, -5, 24, 10), gillPaint);
        canvas.restore();
      }
    }

    // 6. Broad Rounded Axolotl Head (Canon §3.1 & §4: NO mustache, rounded muzzle-less face)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-34, -46, 68, 52),
        const Radius.circular(26),
      ),
      skinPaint,
    );

    // Sleek Nahua Crown headband (Canon §8)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-22, -48, 44, 7),
        const Radius.circular(3),
      ),
      Paint()..color = const Color(0xFFC9A04B),
    );
    final crownPeak = Path()
      ..moveTo(-8, -48)
      ..lineTo(0, -57)
      ..lineTo(8, -48)
      ..close();
    canvas.drawPath(crownPeak, Paint()..color = const Color(0xFF276D69));

    // Blushing cheeks when charmed by Nūr, Yāsmīn, or Laylā!
    final blushAlpha = isBlushing ? 0.72 : 0.25;
    final blushPaint = Paint()
      ..color = const Color(0xFFFF4D6D).withValues(alpha: blushAlpha);
    canvas.drawOval(const Rect.fromLTWH(-26, -16, 14, 8), blushPaint);
    canvas.drawOval(const Rect.fromLTWH(12, -16, 14, 8), blushPaint);

    // Eyes (dark expressive eyes; wise half-lidded or wide-eyed when blushing)
    final eyePaint = Paint()..color = const Color(0xFF1E1B18);
    final isBlinking = (_time % 4.2) > 4.05;
    if (isBlinking) {
      canvas.drawLine(
        const Offset(-18, -24),
        const Offset(-10, -24),
        eyePaint..strokeWidth = 2.5,
      );
      canvas.drawLine(
        const Offset(10, -24),
        const Offset(18, -24),
        eyePaint..strokeWidth = 2.5,
      );
    } else {
      canvas.drawCircle(const Offset(-14, -24), 4.2, eyePaint);
      canvas.drawCircle(const Offset(14, -24), 4.2, eyePaint);
      canvas.drawCircle(
        const Offset(-15.5, -25.5),
        1.4,
        Paint()..color = Colors.white,
      );
      canvas.drawCircle(
        const Offset(12.5, -25.5),
        1.4,
        Paint()..color = Colors.white,
      );
    }

    // Calm knowing smile or flustered wavy smile (NO MUSTACHE!)
    final mouthPaint = Paint()
      ..color = const Color(0xFF5A2A2E)
      ..strokeWidth = 2.3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    if (isSpeaking && ((_time * 8).floor() % 2 == 0)) {
      canvas.drawOval(
        const Rect.fromLTWH(-6, -13, 12, 7),
        Paint()..color = const Color(0xFF8B3A42),
      );
    } else {
      final smilePath = Path()
        ..moveTo(-8, -11)
        ..quadraticBezierTo(0, isBlushing ? -7 : -6, 8, -11);
      canvas.drawPath(smilePath, mouthPaint);
    }

    // Floating rose sparkles/hearts when blushing!
    if (isBlushing) {
      final heartY = -64.0 - ((_time * 18) % 16);
      final tp = TextPainter(
        text: const TextSpan(
          text: '✨🌸',
          style: TextStyle(fontSize: 13),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(-14, heartY));
    }

    // Active speaker halo
    if (isSpeaking) {
      canvas.drawCircle(
        const Offset(0, -14),
        46,
        Paint()
          ..color = const Color(0xFFFFD166).withValues(alpha: 0.25)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5,
      );
    }

    canvas.restore();
  }

  // Canon: Covi — Ambiguous White Figure (Expressive posture, playful teasing grin)
  void _drawCovi(
    Canvas canvas, {
    required Offset center,
    required double scale,
    required EmotionState emotion,
    required bool isSpeaking,
  }) {
    final isTeasing = emotion == EmotionState.teasing;
    final bob = math.sin(_time * (isSpeaking ? 6.0 : 2.6) + 1.0) * 3.2 * scale;
    final lean = isTeasing ? 0.10 : math.sin(_time * 1.5) * 0.03;

    canvas.save();
    canvas.translate(center.dx, center.dy + bob);
    canvas.scale(scale, scale);
    canvas.rotate(lean);

    final whiteBodyPaint = Paint()..color = const Color(0xFFF2EEE7);
    final outlinePaint = Paint()
      ..color = const Color(0xFF2B2420)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2;

    // Legs
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-18, 36, 12, 22),
        const Radius.circular(6),
      ),
      whiteBodyPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(6, 36, 12, 22),
        const Radius.circular(6),
      ),
      whiteBodyPaint,
    );

    // Casual travel shirt (soft slate-blue)
    final shirtRect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(-24, 0, 48, 42),
      const Radius.circular(16),
    );
    canvas.drawRRect(shirtRect, Paint()..color = const Color(0xFF4A7C8C));
    canvas.drawRRect(shirtRect, outlinePaint);

    // Expressive arms (one nudging toward Tlatoāni when teasing!)
    final rightArmAngle = isTeasing ? -0.45 : 0.15;
    canvas.save();
    canvas.translate(22, 12);
    canvas.rotate(rightArmAngle);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(0, -5, 22, 11),
        const Radius.circular(6),
      ),
      whiteBodyPaint,
    );
    canvas.restore();

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-34, 8, 12, 24),
        const Radius.circular(6),
      ),
      whiteBodyPaint,
    );

    // Rounded Ambiguous White Head (Canon: minimal facial features, no hair/gender markers)
    final headRect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(-26, -46, 52, 48),
      const Radius.circular(24),
    );
    canvas.drawRRect(headRect, whiteBodyPaint);
    canvas.drawRRect(headRect, outlinePaint);

    // Minimalist expressive eyes
    final eyePaint = Paint()..color = const Color(0xFF2B2420);
    if (isTeasing) {
      // Playful winking/arc eyes `^ ᴗ ^`
      final leftArc = Path()
        ..moveTo(-16, -22)
        ..quadraticBezierTo(-11, -28, -6, -22);
      final rightArc = Path()
        ..moveTo(6, -22)
        ..quadraticBezierTo(11, -28, 16, -22);
      canvas.drawPath(
        leftArc,
        Paint()
          ..color = const Color(0xFF2B2420)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.4,
      );
      canvas.drawPath(
        rightArc,
        Paint()
          ..color = const Color(0xFF2B2420)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.4,
      );
    } else {
      canvas.drawCircle(const Offset(-10, -24), 3.5, eyePaint);
      canvas.drawCircle(const Offset(10, -24), 3.5, eyePaint);
    }

    // Mouth
    final smilePath = Path()
      ..moveTo(-7, -12)
      ..quadraticBezierTo(0, isTeasing ? -5 : -7, 8, isTeasing ? -14 : -12);
    canvas.drawPath(
      smilePath,
      Paint()
        ..color = const Color(0xFF2B2420)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round,
    );

    canvas.restore();
  }

  // Canon §14–26: mācron āi — Toy-sized desktop robot with cyan screen face, antenna orb, modular right arm & EMOJI-ONLY bubble
  void _drawMacronAi(
    Canvas canvas, {
    required Offset center,
    required double scale,
    required String emojis,
    required String prop,
    required bool isBlushingScene,
  }) {
    final hover = math.sin(_time * 3.8) * 4.0 * scale;
    final bounceScale = 1.0 + _macronBounce * 0.22;

    canvas.save();
    canvas.translate(center.dx, center.dy + hover);
    canvas.scale(scale * 0.72 * bounceScale, scale * 0.72 * bounceScale);

    // 1. Antenna stem + glowing cyan orb (the dot of the `i` in `āi` — Canon §19 & §20)
    canvas.drawLine(
      const Offset(0, -34),
      const Offset(0, -48),
      Paint()
        ..color = const Color(0xFF276D69)
        ..strokeWidth = 3.0,
    );
    canvas.drawCircle(
      const Offset(0, -52),
      6.0,
      Paint()..color = const Color(0xFF62D6D1),
    );

    // 2. Compact rounded cream shell (`#E4D4B5` — Canon §16 & §22)
    final bodyRect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(-26, -34, 52, 54),
      const Radius.circular(18),
    );
    canvas.drawRRect(bodyRect, Paint()..color = const Color(0xFFE4D4B5));
    canvas.drawRRect(
      bodyRect,
      Paint()
        ..color = const Color(0xFF276D69)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4,
    );

    // Subtle `āi` chest badge accent
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-12, 6, 24, 9),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFF276D69),
    );

    // 3. Dark inset face screen (`#102B2E`) with cyan expressions (`#62D6D1` — Canon §18)
    final screenRect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(-19, -26, 38, 26),
      const Radius.circular(9),
    );
    canvas.drawRRect(screenRect, Paint()..color = const Color(0xFF102B2E));

    final faceText = _rewindFlash > 0.1
        ? '>_<'
        : (isBlushingScene ? '♥ᴗ♥' : '•ᴗ•');
    final facePainter = TextPainter(
      text: TextSpan(
        text: faceText,
        style: const TextStyle(
          color: Color(0xFF62D6D1),
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    facePainter.paint(
      canvas,
      Offset(-facePainter.width / 2, -13 - facePainter.height / 2),
    );

    // 4. Left arm & Modular Right Arm (Canon §21: "Mācron's right arm is modular / replaceable")
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-35, -8, 9, 20),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFF276D69),
    );
    // Modular right arm with teal cuff + prop icon
    final armWave = math.sin(_time * 4.5) * 0.22;
    canvas.save();
    canvas.translate(26, -4);
    canvas.rotate(armWave);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(0, -4, 16, 9),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFF62D6D1),
    );
    final propEmoji = switch (prop) {
      'dallah' => '🫖',
      'paintbrush' => '🖌️',
      'tillandsia' => '🌿',
      'teacup' => '🍵',
      'lantern' => '🏮',
      'clapperboard' => '🎬',
      _ => '🧭',
    };
    final propPainter = TextPainter(
      text: TextSpan(text: propEmoji, style: const TextStyle(fontSize: 14)),
      textDirection: TextDirection.ltr,
    )..layout();
    propPainter.paint(canvas, const Offset(12, -12));
    canvas.restore();

    // 5. Compact toy legs
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-14, 20, 9, 10),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFF102B2E),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(5, 20, 9, 10),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFF102B2E),
    );

    // 6. Floating EMOJI-ONLY Speech Bubble above mācron āi!
    final bubbleRect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(-44, -96, 88, 34),
      const Radius.circular(17),
    );
    canvas.drawRRect(
      bubbleRect,
      Paint()..color = const Color(0xFFFFFDF8).withValues(alpha: 0.95),
    );
    canvas.drawRRect(
      bubbleRect,
      Paint()
        ..color = const Color(0xFF62D6D1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2,
    );
    final emojiPainter = TextPainter(
      text: TextSpan(
        text: emojis,
        style: const TextStyle(fontSize: 17),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    emojiPainter.paint(
      canvas,
      Offset(-emojiPainter.width / 2, -79 - emojiPainter.height / 2),
    );

    canvas.restore();
  }

  // Regional Arab Axolotl Heroines: Nūr (Dubai), Yāsmīn (Levant), Laylā (Cairo)
  void _drawArabAxolotlHeroine(
    Canvas canvas, {
    required CharacterId heroine,
    required Offset center,
    required double scale,
    required EmotionState emotion,
    required bool isSpeaking,
  }) {
    final bob = math.sin(_time * (isSpeaking ? 5.2 : 2.3) + 2.0) * 3.0 * scale;

    final (bodyColor, gillColor, garmentColor, accentGold, badgeEmoji) =
        switch (heroine) {
      CharacterId.nur => (
          const Color(0xFFF7B2B7),
          const Color(0xFFE86A78),
          const Color(0xFF1D3557), // Royal Dubai sapphire abaya/shayla
          const Color(0xFFD4AF37),
          '✨',
        ),
      CharacterId.yasmin => (
          const Color(0xFFF6C0BA),
          const Color(0xFFEC7A88),
          const Color(0xFF2D6A4F), // Levantine olive-emerald & jasmine
          const Color(0xFFF4E285),
          '🌼',
        ),
      _ => (
          const Color(0xFFF2A69E),
          const Color(0xFFD95D67),
          const Color(0xFF7B2CBF), // Cairene Nile twilight & gold
          const Color(0xFFFFB703),
          '🌙',
        ),
    };

    canvas.save();
    canvas.translate(center.dx, center.dy + bob);
    canvas.scale(scale, scale);

    // 1. Single graceful axolotl tail curving to the right
    final tailSwing = math.sin(_time * 2.5 + 1.2) * 8.0;
    final tailPath = Path()
      ..moveTo(12, 34)
      ..quadraticBezierTo(50, 40 + tailSwing, 64, 14 + tailSwing)
      ..quadraticBezierTo(50, -2 + tailSwing, 14, 18)
      ..close();
    canvas.drawPath(tailPath, Paint()..color = bodyColor);

    // 2. Flowing regional garment / cape with gold embroidery border
    final robePath = Path()
      ..moveTo(-28, 2)
      ..lineTo(-34, 52)
      ..quadraticBezierTo(0, 58, 34, 52)
      ..lineTo(28, 2)
      ..close();
    canvas.drawPath(robePath, Paint()..color = garmentColor);
    canvas.drawPath(
      robePath,
      Paint()
        ..color = accentGold
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4,
    );

    // 3. Feathery external gills (3 branches each side)
    final gillPaint = Paint()..color = gillColor;
    for (final side in const [-1.0, 1.0]) {
      for (var b = 0; b < 3; b++) {
        final angle = (b - 1) * 0.32;
        canvas.save();
        canvas.translate(side * 33.0, -25.0 + b * 9.5);
        canvas.rotate(side * (0.22 + angle));
        canvas.drawOval(const Rect.fromLTWH(-11, -4.5, 22, 9), gillPaint);
        canvas.restore();
      }
    }

    // 4. Rounded Axolotl Head
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-32, -45, 64, 50),
        const Radius.circular(25),
      ),
      Paint()..color = bodyColor,
    );

    // Graceful headscarf / shawl drape (shayla / jasmine crown / Nile scarf)
    final shawlPath = Path()
      ..moveTo(-32, -28)
      ..quadraticBezierTo(0, -54, 32, -28)
      ..quadraticBezierTo(26, -42, 0, -44)
      ..quadraticBezierTo(-26, -42, -32, -28);
    canvas.drawPath(shawlPath, Paint()..color = garmentColor);
    canvas.drawPath(
      shawlPath,
      Paint()
        ..color = accentGold
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8,
    );

    // Floral / Star ornament on scarf
    final badgePainter = TextPainter(
      text: TextSpan(text: badgeEmoji, style: const TextStyle(fontSize: 13)),
      textDirection: TextDirection.ltr,
    )..layout();
    badgePainter.paint(canvas, const Offset(14, -44));

    // Expressive dark eyes with curved eyelashes
    final eyePaint = Paint()..color = const Color(0xFF1A1418);
    canvas.drawCircle(const Offset(-13, -22), 4.2, eyePaint);
    canvas.drawCircle(const Offset(13, -22), 4.2, eyePaint);
    // Eyelashes
    canvas.drawLine(
      const Offset(-17, -25),
      const Offset(-20, -28),
      eyePaint..strokeWidth = 2.0,
    );
    canvas.drawLine(
      const Offset(17, -25),
      const Offset(20, -28),
      eyePaint..strokeWidth = 2.0,
    );
    // Eye sparkle
    canvas.drawCircle(
      const Offset(-14.2, -23.5),
      1.5,
      Paint()..color = Colors.white,
    );
    canvas.drawCircle(
      const Offset(11.8, -23.5),
      1.5,
      Paint()..color = Colors.white,
    );

    // Soft rose cheeks
    final cheekPaint = Paint()
      ..color = const Color(0xFFFF5C8A).withValues(alpha: 0.42);
    canvas.drawOval(const Rect.fromLTWH(-24, -15, 11, 6), cheekPaint);
    canvas.drawOval(const Rect.fromLTWH(13, -15, 11, 6), cheekPaint);

    // Warm welcoming smile
    final mouthPath = Path()
      ..moveTo(-7, -10)
      ..quadraticBezierTo(0, isSpeaking ? -4 : -6, 7, -10);
    canvas.drawPath(
      mouthPath,
      Paint()
        ..color = const Color(0xFF6B2737)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round,
    );

    if (isSpeaking) {
      canvas.drawCircle(
        const Offset(0, -14),
        45,
        Paint()
          ..color = accentGold.withValues(alpha: 0.30)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5,
      );
    }

    canvas.restore();
  }

  void _drawRewindOverlay(Canvas canvas, double w, double h, double alpha) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, w, h),
      Paint()..color = const Color(0xFF62D6D1).withValues(alpha: alpha * 0.25),
    );
    final tp = TextPainter(
      text: TextSpan(
        text: '⏪  mācron āi Rewind! Let\'s look closely at the clue...',
        style: TextStyle(
          color: Colors.white.withValues(alpha: alpha),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset((w - tp.width) / 2, h * 0.12));
  }
}
