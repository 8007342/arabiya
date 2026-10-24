import 'package:flutter_test/flutter_test.dart';
import 'package:arabiya/src/ink/ink_model.dart';
import 'package:arabiya/src/ink/ink_rubric.dart';

InkStroke stroke(List<Offset> points) => InkStroke(
  pointerKind: 'touch',
  samples: [
    for (var i = 0; i < points.length; i++)
      InkSample(position: points[i], elapsedMicros: i * 10000),
  ],
);
InkAttempt exemplar(InkTarget target, {bool dots = true}) => InkAttempt(
  target: target,
  assistance: InkAssistance.guided,
  strokes: [
    stroke(resamplePath(target.body)),
    if (dots)
      for (final dot in target.dots) stroke([dot]),
  ],
);

void main() {
  final rubric = InkRubric();
  for (final target in InkTarget.values) {
    test('${target.name} complete geometry with separate dots is accepted', () {
      expect(rubric.assess(exemplar(target)).accepted, isTrue);
    });
  }
  test('tap and repeated stationary samples never complete a body', () {
    for (final count in [1, 20, 2000]) {
      final attempt = InkAttempt(
        target: InkTarget.ba,
        assistance: InkAssistance.guided,
        strokes: [stroke(List.filled(count, InkTarget.ba.body.first))],
      );
      expect(rubric.assess(attempt).accepted, isFalse);
    }
  });
  test('a partial bowl fails even with its dot', () {
    final attempt = exemplar(InkTarget.ba);
    attempt.strokes[0] = stroke(InkTarget.ba.body.take(4).toList());
    expect(rubric.assess(attempt).accepted, isFalse);
  });
  test('missing, wrong, duplicated and connected dots fail', () {
    final missing = exemplar(InkTarget.ba, dots: false);
    expect(rubric.assess(missing).accepted, isFalse);
    missing.strokes.add(stroke([const Offset(.5, .28)]));
    expect(rubric.assess(missing).accepted, isFalse);
    final duplicate = exemplar(InkTarget.ta);
    duplicate.strokes.add(stroke([InkTarget.ta.dots.first]));
    expect(rubric.assess(duplicate).accepted, isFalse);
    final connected = exemplar(InkTarget.ta, dots: false);
    connected.strokes.add(stroke(InkTarget.ta.dots));
    expect(rubric.assess(connected).accepted, isFalse);
  });
  test('overlapping dots cannot count as two separate dots', () {
    final attempt = exemplar(InkTarget.ta, dots: false);
    attempt.strokes.add(stroke([const Offset(.50, .29)]));
    attempt.strokes.add(stroke([const Offset(.51, .29)]));
    expect(rubric.assess(attempt).accepted, isFalse);
  });
  test('dense scribble cannot pass through sample count or coverage alone', () {
    final attempt = exemplar(InkTarget.ba);
    attempt.strokes.add(
      stroke([
        for (var i = 0; i < 100; i++)
          Offset(i.isEven ? .1 : .9, .1 + (i % 8) * .1),
      ]),
    );
    expect(rubric.assess(attempt).accepted, isFalse);
  });
  test('repeated retracing and an extra unrelated mark fail', () {
    final repeat = exemplar(InkTarget.ba);
    repeat.strokes.add(stroke(resamplePath(InkTarget.ba.body)));
    expect(rubric.assess(repeat).accepted, isFalse);
    final extra = exemplar(InkTarget.ba);
    extra.strokes.add(stroke([const Offset(.1, .1)]));
    expect(rubric.assess(extra).accepted, isFalse);
  });
  test('scattered taps on every guide point do not become a flowing body', () {
    final attempt = InkAttempt(
      target: InkTarget.ba,
      assistance: InkAssistance.guided,
      strokes: [
        for (final p in resamplePath(InkTarget.ba.body)) stroke([p]),
        stroke(InkTarget.ba.dots),
      ],
    );
    expect(rubric.assess(attempt).accepted, isFalse);
  });
  test('dot-first order, slow drawing and constant pressure are permitted', () {
    final attempt = exemplar(InkTarget.tha);
    final body = attempt.strokes.removeAt(0);
    attempt.strokes.add(body);
    expect(rubric.assess(attempt).accepted, isTrue);
  });
  test('cancelled body does not count toward evidence', () {
    final attempt = exemplar(InkTarget.ba);
    attempt.strokes.first.cancelled = true;
    expect(rubric.assess(attempt).accepted, isFalse);
  });
  test('geometry tolerates modest motor deviation', () {
    final attempt = exemplar(InkTarget.ba);
    attempt.strokes[0] = stroke(
      InkTarget.ba.body.map((p) => p + const Offset(.012, -.015)).toList(),
    );
    expect(rubric.assess(attempt).accepted, isTrue);
  });
}
