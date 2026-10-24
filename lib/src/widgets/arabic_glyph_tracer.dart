import 'package:flutter/material.dart';

import '../ink/ink_model.dart';
import '../ink/ink_practice_card.dart';
import '../models/comic_models.dart';

/// Compatibility entry point for the earlier chapters. Only the constrained
/// family with an explicit geometry rubric can produce writing evidence.
class ArabicGlyphTracer extends StatelessWidget {
  const ArabicGlyphTracer({
    super.key,
    required this.lesson,
    required this.onSpeakLetter,
    required this.onTraceCompleted,
  });
  final ArabicLetterLesson lesson;
  final VoidCallback onSpeakLetter;
  final VoidCallback onTraceCompleted;
  @override
  Widget build(BuildContext context) {
    final target = InkTarget.values
        .where((t) => t.glyph == lesson.letter)
        .firstOrNull;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextButton.icon(
          onPressed: onSpeakLetter,
          icon: const Icon(Icons.volume_up),
          label: const Text('Hear the letter', style: TextStyle(fontSize: 24)),
        ),
        if (target != null)
          InkPracticeCard(target: target, onAccepted: onTraceCompleted)
        else
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFF1E7D5),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                Text(
                  lesson.letter,
                  style: const TextStyle(
                    fontFamily: 'NotoSansArabic',
                    fontSize: 96,
                  ),
                ),
                Text(
                  lesson.englishPhoneticTip,
                  style: const TextStyle(fontSize: 26, height: 1.5),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Study this letter and listen. Writing checks for this letter are not available yet; this activity does not award handwriting mastery.',
                  style: TextStyle(fontSize: 22, height: 1.5),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
