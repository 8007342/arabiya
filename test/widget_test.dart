// @trace spec:arabiya, spec:character-canon, spec:voice-canon, spec:curriculum-and-comics
import 'dart:ui';

import 'package:arabiya/src/data/all_chapters.dart';
import 'package:arabiya/src/data/arabic_alphabet_catalog.dart';
import 'package:arabiya/src/data/generated_voice_canon.dart';
import 'package:arabiya/src/models/comic_models.dart';
import 'package:arabiya/src/widgets/arabiya_app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('Curriculum & Canon invariants: 12 chapters, 28 Abjad letters, emoji-only mācron bubbles, voice canon', () {
    expect(kAllArabiyaChapters.length, 12);
    expect(kFullArabicAbjad.length, 28);
    expect(kSpanishArabicCognates.length, 12);
    expect(kSubtitleBridgePairs.length, 10);
    expect(kCharacterVoiceCanon.keys, containsAll(['tlatoani', 'covi', 'nur', 'yasmin', 'layla', 'macron']));

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

  testWidgets('Zero-friction landing enters playable comic and rewinds panels on missed mastery check', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const ArabiyaApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // Verify landing screen appears for brand-new user
    final startBtn = find.textContaining('Start Reading Now');
    expect(startBtn, findsOneWidget);

    await tester.ensureVisible(startBtn);
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(startBtn);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // Verify Chapter 1 Panel 1 is active
    expect(find.textContaining('Panel 1/5'), findsOneWidget);

    // Advance through all 5 panels to the Mastery Gate
    for (var i = 0; i < 5; i++) {
      final nextBtn = find.textContaining(i < 4 ? 'Siguiente / Next' : 'Mastery Check');
      await tester.ensureVisible(nextBtn);
      await tester.tap(nextBtn);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
    }

    // Verify Mastery Gate is visible
    expect(find.textContaining('Mastery Gate'), findsOneWidget);

    // Tap a wrong option (تُوت) and verify the comic rewinds 2 panels!
    final wrongOption = find.textContaining('tūt');
    await tester.ensureVisible(wrongOption);
    await tester.tap(wrongOption);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Rewound back into comic panels with helpful rewind banner!
    expect(find.textContaining('Panel 4/5'), findsOneWidget);
    expect(find.textContaining('⏪'), findsOneWidget);
  });
}
