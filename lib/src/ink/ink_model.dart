import 'dart:math' as math;
import 'dart:ui';

enum InkBrush { round, pressure, broadNib }

enum InkAssistance { guided, copy, recall }

enum InkTarget { ba, ta, tha, alif }

extension InkTargetDescription on InkTarget {
  String get glyph => ['ب', 'ت', 'ث', 'ا'][index];
  String get label => ['Bāʾ', 'Tāʾ', 'Thāʾ', 'Alif'][index];
  String get instruction => this == InkTarget.alif
      ? 'Draw one upright stroke from the top down.'
      : 'Start on the right. Sweep down, across, and up. Lift your pen, then add ${dots.length == 1 ? 'one dot below' : '${dots.length} separate dots above'}.';
  List<Offset> get body => this == InkTarget.alif
      ? const [Offset(.52, .22), Offset(.51, .68)]
      : const [
          Offset(.80, .42),
          Offset(.79, .53),
          Offset(.73, .61),
          Offset(.62, .65),
          Offset(.46, .66),
          Offset(.31, .64),
          Offset(.22, .59),
          Offset(.20, .50),
        ];
  List<Offset> get dots => switch (this) {
    InkTarget.ba => const [Offset(.50, .80)],
    InkTarget.ta => const [Offset(.44, .29), Offset(.57, .29)],
    InkTarget.tha => const [
      Offset(.44, .31),
      Offset(.57, .31),
      Offset(.505, .19),
    ],
    InkTarget.alif => const [],
  };
}

/// Measured input is retained independently of the renderer. Coordinates are
/// normalized for layout; raw coordinates and canvas dimensions remain available.
class InkSample {
  const InkSample({
    required this.position,
    required this.elapsedMicros,
    this.pressure,
    this.tilt,
    this.orientation,
    this.rawPosition,
    this.canvasSize,
  });
  final Offset position;
  final int elapsedMicros;
  final double? pressure;
  final double? tilt;
  final double? orientation;
  final Offset? rawPosition;
  final Size? canvasSize;
  Map<String, Object?> toJson() => {
    'x': position.dx,
    'y': position.dy,
    'timeMicros': elapsedMicros,
    'pressure': pressure,
    'tilt': tilt,
    'orientation': orientation,
    if (rawPosition != null) 'raw': [rawPosition!.dx, rawPosition!.dy],
    if (canvasSize != null) 'canvas': [canvasSize!.width, canvasSize!.height],
  };
}

class InkStroke {
  InkStroke({
    required this.pointerKind,
    this.brush = InkBrush.round,
    this.nibAngle = math.pi / 4,
    this.width = 9,
    List<InkSample>? samples,
  }) : samples = samples ?? [];
  final String pointerKind;
  final InkBrush brush;
  final double nibAngle;
  final double width;
  final List<InkSample> samples;
  bool cancelled = false;
  double get length {
    var total = 0.0;
    for (var i = 1; i < samples.length; i++) {
      total += (samples[i].position - samples[i - 1].position).distance;
    }
    return total;
  }

  Map<String, Object?> toJson() => {
    'pointerKind': pointerKind,
    'brush': brush.name,
    'nibAngle': nibAngle,
    'width': width,
    'cancelled': cancelled,
    'samples': samples.map((s) => s.toJson()).toList(),
  };
}

class InkAttempt {
  InkAttempt({
    required this.target,
    required this.assistance,
    List<InkStroke>? strokes,
  }) : strokes = strokes ?? [];
  final InkTarget target;
  final InkAssistance assistance;
  final List<InkStroke> strokes;
  final DateTime startedAt = DateTime.now().toUtc();
  Map<String, Object?> toJson() => {
    'schema': 1,
    'target': target.name,
    'assistance': assistance.name,
    'startedAt': startedAt.toIso8601String(),
    'strokes': strokes.map((s) => s.toJson()).toList(),
  };
}

double distanceToSegment(Offset p, Offset a, Offset b) {
  final d = b - a;
  final denominator = d.dx * d.dx + d.dy * d.dy;
  if (denominator == 0) return (p - a).distance;
  final t = (((p - a).dx * d.dx + (p - a).dy * d.dy) / denominator).clamp(
    0.0,
    1.0,
  );
  return (p - (a + d * t)).distance;
}

double distanceToPath(Offset point, List<Offset> path) {
  if (path.length == 1) return (point - path.first).distance;
  var distance = double.infinity;
  for (var i = 1; i < path.length; i++) {
    distance = math.min(
      distance,
      distanceToSegment(point, path[i - 1], path[i]),
    );
  }
  return distance;
}

List<Offset> resamplePath(List<Offset> points, {double spacing = .012}) {
  if (points.isEmpty) return [];
  final out = <Offset>[points.first];
  var remaining = spacing;
  for (var i = 1; i < points.length; i++) {
    var start = points[i - 1];
    final end = points[i];
    var distance = (end - start).distance;
    while (distance >= remaining && distance > 0) {
      start += (end - start) * (remaining / distance);
      out.add(start);
      distance = (end - start).distance;
      remaining = spacing;
    }
    remaining -= distance;
  }
  if ((out.last - points.last).distance > .001) out.add(points.last);
  return out;
}
