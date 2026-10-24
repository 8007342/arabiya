// @trace spec:arabiya, spec:character-canon, spec:voice-canon, spec:curriculum-and-comics
import 'package:flutter/material.dart';

import '../data/arabic_alphabet_catalog.dart';
import '../data/generated_voice_canon.dart';
import '../models/comic_models.dart';
import '../services/voice_service.dart';

class TlatoaniNotebookSheet extends StatefulWidget {
  final PlayerProgressState progress;
  final VoiceService voiceService;
  const TlatoaniNotebookSheet({
    super.key,
    required this.progress,
    required this.voiceService,
  });
  @override
  State<TlatoaniNotebookSheet> createState() => _TlatoaniNotebookSheetState();
}

class _TlatoaniNotebookSheetState extends State<TlatoaniNotebookSheet> {
  int _tab = 0;
  static const _ink = Color(0xFF123E42);
  static const _body = TextStyle(fontSize: 24, height: 1.5, color: _ink);

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Container(
      height: MediaQuery.sizeOf(context).height * .94,
      decoration: const BoxDecoration(
        color: Color(0xFFFDF8EE),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 12, 8),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Your word notebook',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: _ink,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Close notebook',
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                for (final entry in [
                  'Letters',
                  'Word connections',
                  'Dialects',
                  'The cast',
                ].asMap().entries)
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ChoiceChip(
                      label: Text(
                        entry.value,
                        style: const TextStyle(fontSize: 24),
                      ),
                      selected: _tab == entry.key,
                      onSelected: (_) => setState(() => _tab = entry.key),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: KeyedSubtree(
              key: ValueKey(_tab),
              child: switch (_tab) {
                0 => _letters(),
                1 => _connections(),
                2 => _dialects(),
                _ => _cast(),
              },
            ),
          ),
        ],
      ),
    ),
  );

  Widget _card(List<Widget> children) => Card(
    color: Colors.white,
    margin: const EdgeInsets.only(bottom: 18),
    child: Padding(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    ),
  );
  Widget _text(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(text, style: _body),
  );
  Widget _arabic(String text, {double size = 48}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Text(
      text,
      textDirection: TextDirection.rtl,
      style: TextStyle(
        fontFamily: 'Amiri',
        fontSize: size,
        height: 1.6,
        color: _ink,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
  Widget _listen(String word, {CharacterId heroine = CharacterId.nur}) =>
      TextButton.icon(
        onPressed: () =>
            widget.voiceService.speakArabicWord(word, heroine: heroine),
        icon: const Icon(Icons.volume_up_outlined),
        label: const Text('Listen', style: TextStyle(fontSize: 24)),
      );

  Widget _letters() => ListView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: kFullArabicAbjad.length,
    itemBuilder: (context, index) {
      final letter = kFullArabicAbjad[index];
      return _card([
        Wrap(
          spacing: 24,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _arabic(letter.letter, size: 80),
            Text(
              letter.nameTranslit,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: _ink,
              ),
            ),
            _arabic(letter.nameArabic),
          ],
        ),
        _text(switch (letter.sunOrMoon) {
          'sun' => 'Sun letter · letra solar',
          'moon' => 'Moon letter · letra lunar',
          _ => 'Long vowel · vocal larga',
        }),
        Wrap(
          spacing: 24,
          runSpacing: 16,
          children: [
            for (final entry in {
              'isolated': 'Alone',
              'initial': 'Beginning',
              'medial': 'Middle',
              'final': 'End',
            }.entries)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(entry.value, style: _body),
                  _arabic(letter.forms[entry.key] ?? ''),
                ],
              ),
          ],
        ),
        _text(letter.englishPhoneticTip),
        _text(letter.spanishPhoneticTip),
        _arabic(letter.exampleArabic),
        _text('${letter.exampleTranslit} · ${letter.exampleMeaningEsEn}'),
        _listen(letter.exampleArabic),
      ]);
    },
  );

  Widget _connections() => ListView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: kSpanishArabicCognates.length,
    itemBuilder: (context, index) {
      final word = kSpanishArabicCognates[index];
      return _card([
        Text(
          word.spanishMeaning,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: _ink,
          ),
        ),
        _arabic(word.arabic),
        _text('${word.transliteration} · ${word.englishMeaning}'),
        _text(word.spanishBridgeNote),
        _listen(word.arabic),
      ]);
    },
  );

  Widget _dialects() => ListView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: kSubtitleBridgePairs.length,
    itemBuilder: (context, index) {
      final pair = kSubtitleBridgePairs[index];
      return _card([
        _text(pair['meaning'] ?? ''),
        for (final entry in {
          'msa': 'Modern Standard Arabic',
          'khaliji': 'Nūr · Dubai',
          'shami': 'Yāsmīn · Levant',
          'masri': 'Laylā · Cairo',
        }.entries) ...[
          Text(
            entry.value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: _ink,
            ),
          ),
          _arabic(pair[entry.key] ?? ''),
        ],
        _text(pair['msaTranslit'] ?? ''),
        _listen(pair['msa'] ?? ''),
      ]);
    },
  );

  Widget _cast() => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      for (final profile in kCharacterVoiceCanon.values)
        _card([
          Text(
            profile.displayName,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: _ink,
            ),
          ),
          const SizedBox(height: 12),
          _text(profile.canonDescription),
          FilledButton.icon(
            onPressed: () => widget.voiceService.playCharacterAudition(
              CharacterId.values.firstWhere(
                (c) => c.name == profile.id,
                orElse: () => CharacterId.tlatoani,
              ),
            ),
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text(
              'Hear this character',
              style: TextStyle(fontSize: 24),
            ),
          ),
        ]),
    ],
  );
}
