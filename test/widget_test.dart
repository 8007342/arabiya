// @trace spec:arabiya, spec:character-canon, spec:voice-canon, spec:curriculum-and-comics
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:arabiya/src/data/all_chapters.dart';
import 'package:arabiya/src/data/arabic_alphabet_catalog.dart';
import 'package:arabiya/src/data/generated_voice_canon.dart';
import 'package:arabiya/src/models/comic_models.dart';
import 'package:arabiya/src/widgets/arabiya_app.dart';
import 'package:arabiya/src/widgets/notebook_drawer_sheet.dart';
import 'package:arabiya/src/services/voice_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('Curriculum & Canon invariants: 12 chapters, 28 Abjad letters, emoji-only mācron bubbles, voice canon', () {
    expect(kAllArabiyaChapters.length, 12);
    expect(kFullArabicAbjad.length, 28);
    expect(kSpanishArabicCognates.length, 12);
    expect(kSubtitleBridgePairs.length, 10);
    expect(
      kCharacterVoiceCanon.keys,
      containsAll(['tlatoani', 'covi', 'nur', 'yasmin', 'layla', 'macron']),
    );

    final asciiLetterRegex = RegExp(r'[A-Za-z]');
    for (final chapter in kAllArabiyaChapters) {
      expect(chapter.panels.length, greaterThanOrEqualTo(5));
      for (final panel in chapter.panels) {
        // mācron āi speech bubbles must never contain words/letters
        expect(
          asciiLetterRegex.hasMatch(panel.macronEmojis),
          isFalse,
          reason: 'Panel ${panel.id} macronEmojis must be emoji-only',
        );
        if (panel.speaker == CharacterId.tlatoani) {
          expect(panel.spokenLocale, startsWith('es'));
        } else if (panel.speaker == CharacterId.covi) {
          expect(panel.spokenLocale, startsWith('en'));
        }
      }
    }
  });

  testWidgets(
    'Opening comic has deliberate beats, optional translations, replay and archive',
    (tester) async {
      tester.view.physicalSize = const Size(1280, 720);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      SharedPreferences.setMockInitialValues({});
      await tester.pumpWidget(const ArabiyaApp());
      await tester.pumpAndSettle();
      expect(find.text('The Door That Won’t Cooperate'), findsOneWidget);
      expect(
        tester.getRect(find.text('Follow the robot')).bottom,
        lessThanOrEqualTo(720),
      );
      expect(
        find.text('One small suitcase. That was the plan.'),
        findsOneWidget,
      );
      expect(find.text('Una maleta pequeña. Ese era el plan.'), findsNothing);
      await tester.tap(find.text('Translate'));
      await tester.pump();
      expect(find.text('Una maleta pequeña. Ese era el plan.'), findsOneWidget);

      Future<void> advance(String label) async {
        final button = find.text(label);
        await tester.ensureVisible(button);
        await tester.tap(button);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }

      await advance('Follow the robot');
      expect(find.text('A WORD ON THE DOOR'), findsOneWidget);
      await advance('Try the door');
      await advance('And then…');
      expect(find.text('A long, very quiet moment.'), findsOneWidget);
      await advance('Give it a clue');
      expect(find.text('Leave ب on the luggage label.'), findsOneWidget);
      await advance('Continue with help');
      final saved = jsonDecode(
        (await SharedPreferences.getInstance()).getString(
          'arabiya_progress_v1',
        )!,
      ) as Map<String, dynamic>;
      expect(saved['xp'], 0);
      expect(
        (saved['writingEvidence'] as List).single['eventType'],
        'continuedWithoutWriting',
      );
      expect((saved['writingEvidence'] as List).single['accepted'], false);
      await advance('Slide the door');
      await advance('At last!');
      expect(
        find.text('Excellent. Now the suitcase is the door.'),
        findsOneWidget,
      );
      await advance('Meanwhile, at the café');
      await advance('Replay episode');
      expect(
        find.text('One small suitcase. That was the plan.'),
        findsOneWidget,
      );
      await tester.tap(find.byTooltip('Chapter archive'));
      await tester.pumpAndSettle();
      expect(find.text('The story archive'), findsOneWidget);
      await tester.tap(find.text(kAllArabiyaChapters.first.titleEn));
      await tester.pumpAndSettle();
      expect(find.text('CHAPTER 1 · 1/5'), findsOneWidget);
      expect(
        find.text(kAllArabiyaChapters.first.panels.first.dialogueText),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Phone reader reflows with enlarged system text', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const ArabiyaApp());
    await tester.pumpAndSettle();
    expect(find.text('One small suitcase. That was the plan.'), findsOneWidget);
    expect(tester.takeException(), isNull);
    final next = find.text('Follow the robot');
    await tester.ensureVisible(next);
    await tester.tap(next);
    await tester.pumpAndSettle();
    expect(find.text('A WORD ON THE DOOR'), findsOneWidget);
    expect(tester.takeException(), isNull);
    for (final label in [
      'Try the door',
      'And then…',
      'Give it a clue',
      'Continue with help',
      'At last!',
      'Meanwhile, at the café',
      'Replay episode',
    ]) {
      final nextBeat = find.text(label);
      await tester.ensureVisible(nextBeat);
      await tester.tap(nextBeat);
      await tester.pumpAndSettle();
      expect(
        tester.takeException(),
        isNull,
        reason: 'Phone scene after $label',
      );
    }
  });
  testWidgets('Notebook remains readable on a phone at 200 percent text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TlatoaniNotebookSheet(
            progress: const PlayerProgressState(),
            voiceService: VoiceService(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    for (final tab in ['Word connections', 'Dialects', 'The cast']) {
      final control = find.text(tab);
      await tester.ensureVisible(control);
      await tester.tap(control);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: tab);
    }
  });
  testWidgets('Opening episode resumes its saved beat after restart', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 720);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const ArabiyaApp());
    await tester.pumpAndSettle();
    final next = find.text('Follow the robot');
    await tester.ensureVisible(next);
    await tester.tap(next);
    await tester.pumpAndSettle();
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await tester.pumpWidget(const ArabiyaApp());
    await tester.pumpAndSettle();
    expect(find.text('A WORD ON THE DOOR'), findsOneWidget);
    expect(find.text('2 / 8'), findsOneWidget);
  });
}
