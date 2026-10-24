import 'dart:math' as math;
import 'dart:ui';

import 'ink_model.dart';

class InkAssessment {
  const InkAssessment({
    required this.accepted,
    required this.coverage,
    required this.dotsMatched,
    required this.extraInk,
    required this.feedback,
  });
  final bool accepted;
  final double coverage;
  final int dotsMatched;
  final double extraInk;
  final String feedback;
  static const rubricVersion = 'constrained-family-geometry-v1';
  Map<String, Object?> toJson() => {
    'rubric': rubricVersion,
    'accepted': accepted,
    'bodyCoverage': coverage,
    'dotsMatched': dotsMatched,
    'extraInk': extraInk,
    'feedback': feedback,
  };
}

/// A narrow, unvalidated template exercise, not Arabic recognition or a measure
/// of everyday writing mastery. No pressure, speed, sample count or stroke order
/// contributes to acceptance. Spatial continuity, extent and components do.
class InkRubric {
  static const tolerance = .065;
  InkAssessment assess(InkAttempt attempt) {
    final target = attempt.target;
    final strokes = attempt.strokes
        .where((s) => !s.cancelled && s.samples.isNotEmpty)
        .toList();
    final guide = resamplePath(target.body);
    final bodies = <InkStroke>[];
    final dots = <InkStroke>[];
    for (final stroke in strokes) {
      final points = stroke.samples.map((s) => s.position).toList();
      final center = points.reduce((a, b) => a + b) / points.length.toDouble();
      final extent = points
          .map((p) => (p - center).distance)
          .fold(0.0, math.max);
      if (stroke.length <= .14 &&
          extent <= .045 &&
          target.dots.any((d) => (center - d).distance <= tolerance)) {
        dots.add(stroke);
      } else {
        bodies.add(stroke);
      }
    }
    final paths = bodies
        .map((s) => s.samples.map((p) => p.position).toList())
        .toList();
    final covered = guide
        .where((g) => paths.any((p) => distanceToPath(g, p) <= tolerance))
        .length;
    final coverage = covered / guide.length;
    final longestCoverage = paths.fold(
      0.0,
      (double best, p) => math.max(
        best,
        guide.where((g) => distanceToPath(g, p) <= tolerance).length /
            guide.length,
      ),
    );
    var length = 0.0;
    for (var i = 1; i < target.body.length; i++) {
      length += (target.body[i] - target.body[i - 1]).distance;
    }
    final actualLength = bodies.fold(0.0, (double n, s) => n + s.length);
    final measured = paths.expand((p) => resamplePath(p)).toList();
    final extra = measured.isEmpty
        ? 0.0
        : measured
                  .where((p) => distanceToPath(p, target.body) > tolerance)
                  .length /
              measured.length;
    final usedDots = <int>{};
    var extraDots = 0;
    final observedDotCenters = <Offset>[];
    for (final stroke in dots) {
      final center =
          stroke.samples.map((s) => s.position).reduce((a, b) => a + b) /
          stroke.samples.length.toDouble();
      if (observedDotCenters.any(
        (previous) => (previous - center).distance < .07,
      )) {
        extraDots++;
        continue;
      }
      observedDotCenters.add(center);
      final candidates = List.generate(target.dots.length, (i) => i)
        ..sort(
          (a, b) => (target.dots[a] - center).distance.compareTo(
            (target.dots[b] - center).distance,
          ),
        );
      final match = candidates
          .where(
            (i) =>
                !usedDots.contains(i) &&
                (target.dots[i] - center).distance <= tolerance,
          )
          .firstOrNull;
      if (match == null) {
        extraDots++;
      } else {
        usedDots.add(match);
      }
    }
    final strayMark = bodies.any(
      (s) =>
          s.length < .14 &&
          s.samples.any(
            (p) => distanceToPath(p.position, target.body) > tolerance,
          ),
    );
    final bodyOkay =
        !strayMark &&
        coverage >= .88 &&
        longestCoverage >= .72 &&
        actualLength >= length * .65 &&
        actualLength <= length * 1.85 &&
        extra <= .12;
    final accepted =
        bodyOkay && usedDots.length == target.dots.length && extraDots == 0;
    final String feedback;
    if (accepted) {
      feedback =
          'The shape and ${target.dots.isEmpty ? 'single stroke' : 'dots'} match this practice guide. Try ${attempt.assistance == InkAssistance.recall ? 'a fresh attempt later' : 'with less help next'}.';
    } else if (coverage < .88 ||
        longestCoverage < .72 ||
        actualLength < length * .65) {
      feedback = target == InkTarget.alif
          ? 'Draw the full upright stroke from the top to the baseline.'
          : 'Make the whole bowl in one flowing stroke: right edge, low middle, then left edge.';
    } else if (strayMark ||
        extra > .12 ||
        actualLength > length * 1.85 ||
        extraDots > 0) {
      feedback = 'There is extra ink. Clear the label and try one clean body, then only the requested dots.';
    } else {
      feedback =
          '${target.label} needs ${target.dots.length} ${target.dots.length == 1 ? 'dot below' : 'separate dots above'} the bowl. Lift your pen between dots.';
    }
    return InkAssessment(
      accepted: accepted,
      coverage: coverage,
      dotsMatched: usedDots.length,
      extraInk: extra,
      feedback: feedback,
    );
  }
}
