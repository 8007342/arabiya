import 'dart:ui';
import 'dart:convert';

import 'package:flutter/gestures.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:arabiya/src/ink/ink_canvas.dart';
import 'package:arabiya/src/ink/ink_model.dart';
import 'package:arabiya/src/ink/ink_rubric.dart';
import 'package:arabiya/src/ink/ink_practice_card.dart';
import 'package:arabiya/src/ink/ink_evidence_store.dart';
import 'package:arabiya/src/widgets/stylus_playground.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));
  testWidgets(
    'canvas captures pen lifts and pressure without connecting strokes',
    (tester) async {
      final controller = InkController();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: InkCanvas(controller: controller)),
        ),
      );
      final rect = tester.getRect(find.byType(InkCanvas));
      await tester.sendEventToBinding(
        PointerDownEvent(
          pointer: 44,
          kind: PointerDeviceKind.stylus,
          position: rect.topLeft + const Offset(30, 40),
          pressure: .2,
          pressureMin: 0,
          pressureMax: 1,
        ),
      );
      await tester.sendEventToBinding(
        PointerMoveEvent(
          pointer: 44,
          kind: PointerDeviceKind.stylus,
          position: rect.topLeft + const Offset(110, 60),
          pressure: .8,
          pressureMin: 0,
          pressureMax: 1,
        ),
      );
      await tester.sendEventToBinding(
        PointerUpEvent(
          pointer: 44,
          kind: PointerDeviceKind.stylus,
          position: rect.topLeft + const Offset(110, 60),
        ),
      );
      await tester.tapAt(rect.topLeft + const Offset(120, 180));
      expect(controller.attempt.strokes.length, 2);
      expect(controller.attempt.strokes.first.pointerKind, 'stylus');
      expect(controller.hasVaryingPressure, isTrue);
      expect(controller.attempt.strokes.first.samples.first.pressure, .2);
      expect(
        controller.attempt.strokes.first.samples.first.pressure,
        isNotNull,
      );
      expect(controller.attempt.strokes.last.samples.first.pressure, isNull);
      expect(
        controller.attempt.strokes.first.samples.first.canvasSize,
        isNotNull,
      );
      await tester.pumpWidget(const SizedBox());
      controller.dispose();
    },
  );
  testWidgets(
    'pointer cancellation preserves raw input but cannot complete a letter',
    (tester) async {
      final controller = InkController(target: InkTarget.alif);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: InkCanvas(controller: controller)),
        ),
      );
      final rect = tester.getRect(find.byType(InkCanvas));
      Offset onCanvas(Offset p) =>
          rect.topLeft + Offset(p.dx * rect.width, p.dy * rect.height);
      final pointer = await tester.startGesture(
        onCanvas(InkTarget.alif.body.first),
        pointer: 91,
      );
      await pointer.moveTo(onCanvas(InkTarget.alif.body.last));
      expect(InkRubric().assess(controller.attempt).accepted, isTrue);
      await pointer.cancel();
      expect(controller.attempt.strokes.single.cancelled, isTrue);
      expect(
        controller.attempt.strokes.single.samples.length,
        greaterThanOrEqualTo(2),
      );
      expect(InkRubric().assess(controller.attempt).accepted, isFalse);
      final next = await tester.startGesture(
        onCanvas(InkTarget.alif.body.first),
        pointer: 92,
      );
      await next.moveTo(onCanvas(InkTarget.alif.body.last));
      await next.up();
      expect(controller.attempt.strokes.length, 2);
      expect(controller.attempt.strokes.last.cancelled, isFalse);
      expect(InkRubric().assess(controller.attempt).accepted, isTrue);
      await tester.pumpWidget(const SizedBox());
      controller.dispose();
    },
  );
  for (final changeTarget in [false, true]) {
    testWidgets(
      '${changeTarget ? 'target change' : 'clear'} during an active stroke cannot reconnect old input',
      (tester) async {
        final controller = InkController();
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: InkCanvas(controller: controller)),
          ),
        );
        final rect = tester.getRect(find.byType(InkCanvas));
        final pointer = await tester.startGesture(
          rect.topLeft + const Offset(40, 40),
          pointer: 81,
        );
        await pointer.moveTo(rect.topLeft + const Offset(70, 70));
        final abandoned = controller.attempt;
        final sampleCount = abandoned.strokes.single.samples.length;
        controller.clear(target: changeTarget ? InkTarget.alif : null);
        await pointer.moveTo(rect.topLeft + const Offset(110, 110));
        await pointer.up();
        expect(
          controller.attempt.target,
          changeTarget ? InkTarget.alif : InkTarget.ba,
        );
        expect(controller.attempt.strokes, isEmpty);
        expect(abandoned.strokes.single.samples.length, sampleCount);
        final next = await tester.startGesture(
          rect.topLeft + const Offset(150, 120),
          pointer: 82,
        );
        await next.moveTo(rect.topLeft + const Offset(180, 150));
        await next.up();
        expect(controller.attempt.strokes.length, 1);
        expect(
          controller.attempt.strokes.single.samples.first.rawPosition,
          const Offset(150, 120),
        );
        await tester.pumpWidget(const SizedBox());
        controller.dispose();
      },
    );
  }
  testWidgets(
    'stylus takes over a touch stroke without joining or reviving it',
    (tester) async {
      final controller = InkController();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: InkCanvas(controller: controller)),
        ),
      );
      final rect = tester.getRect(find.byType(InkCanvas));
      final touch = await tester.startGesture(
        rect.topLeft + const Offset(30, 40),
        pointer: 71,
      );
      await touch.moveTo(rect.topLeft + const Offset(60, 60));
      final touchSamples = controller.attempt.strokes.single.samples.length;
      final pen = await tester.createGesture(
        pointer: 72,
        kind: PointerDeviceKind.stylus,
      );
      await pen.down(rect.topLeft + const Offset(190, 120));
      expect(controller.attempt.strokes.length, 2);
      expect(controller.attempt.strokes.first.cancelled, isTrue);
      expect(controller.attempt.strokes.last.pointerKind, 'stylus');
      expect(
        controller.attempt.strokes.last.samples.first.rawPosition,
        const Offset(190, 120),
      );
      await touch.moveTo(rect.topLeft + const Offset(100, 100));
      await touch.up();
      await pen.moveTo(rect.topLeft + const Offset(230, 180));
      await pen.up();
      expect(controller.attempt.strokes.first.samples.length, touchSamples);
      expect(controller.attempt.strokes.last.cancelled, isFalse);
      expect(
        controller.attempt.strokes.last.samples.last.rawPosition,
        const Offset(230, 180),
      );
      expect(
        controller.attempt.strokes.last.samples.every(
          (s) => s.rawPosition!.dx >= 190,
        ),
        isTrue,
      );
      await tester.pumpWidget(const SizedBox());
      controller.dispose();
    },
  );
  testWidgets('matching geometry requires explicit submit and records once', (
    tester,
  ) async {
    var accepted = 0;
    final evidence = <Map<String, dynamic>>[];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: InkPracticeCard(
              onAccepted: () => accepted++,
              onEvidence: evidence.add,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final canvas = tester.widget<InkCanvas>(find.byType(InkCanvas));
    for (final points in [InkTarget.ba.body, InkTarget.ba.dots]) {
      canvas.controller.attempt.strokes.add(
        InkStroke(
          pointerKind: 'touch',
          samples: points
              .map((p) => InkSample(position: p, elapsedMicros: 1))
              .toList(),
        ),
      );
    }
    canvas.controller.changed();
    await tester.pump();
    expect(accepted, 0);
    final submit = find.text('Check my writing');
    await tester.ensureVisible(submit);
    await tester.tap(submit);
    await tester.pumpAndSettle();
    expect(accepted, 1);
    expect(evidence.single['accepted'], true);
    expect((await InkEvidenceStore().read()).length, 1);
    await tester.tap(submit);
    await tester.pumpAndSettle();
    expect(accepted, 1);
  });
  testWidgets(
    'account evidence overrides device history and restores assistance',
    (tester) async {
      SharedPreferences.setMockInitialValues({
        InkEvidenceStore.key: jsonEncode([
          {'target': 'ba', 'assistance': 'copy', 'accepted': true},
        ]),
      });
      Widget app(List<Map<String, dynamic>> evidence) => MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: InkPracticeCard(evidence: evidence),
          ),
        ),
      );
      await tester.pumpWidget(app([]));
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<InkCanvas>(find.byType(InkCanvas))
            .controller
            .attempt
            .assistance,
        InkAssistance.guided,
      );
      await tester.pumpWidget(
        app([
          {'target': 'ba', 'assistance': 'copy', 'accepted': true},
        ]),
      );
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<InkCanvas>(find.byType(InkCanvas))
            .controller
            .attempt
            .assistance,
        InkAssistance.recall,
      );
      await tester.pumpWidget(app([]));
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<InkCanvas>(find.byType(InkCanvas))
            .controller
            .attempt
            .assistance,
        InkAssistance.guided,
      );
    },
  );
  testWidgets('playground reflows on narrow screen with doubled text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(2)),
          child: child!,
        ),
        home: StylusPlayground(
          onClose: () {},
          evidence: const [
            {'target': 'ta', 'accepted': true, 'assistance': 'guided'},
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    for (final tab in ['02 · Free ink', '03 · Ribbon garden']) {
      await tester.ensureVisible(find.text(tab));
      await tester.tap(find.text(tab));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }
  });
}
