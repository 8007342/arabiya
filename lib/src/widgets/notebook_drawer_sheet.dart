// @trace spec:arabiya, spec:character-canon, spec:voice-canon, spec:curriculum-and-comics
import 'package:flutter/material.dart';
import '../data/arabic_alphabet_catalog.dart';
import '../data/generated_voice_canon.dart';
import '../models/comic_models.dart';
import '../services/voice_service.dart';

class TlatoaniNotebookSheet extends StatelessWidget {
  final PlayerProgressState progress;
  final VoiceService voiceService;

  const TlatoaniNotebookSheet({
    super.key,
    required this.progress,
    required this.voiceService,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.84,
        decoration: const BoxDecoration(
          color: Color(0xFFFDF8EE),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFFC9A04B),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 16, 4),
              child: Row(
                children: [
                  const Text('📓', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cuaderno de Tlatoāni • Committed Memory',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF123E42),
                          ),
                        ),
                        Text(
                          'Abjad, Al-Andalus Spanish Cognates, Dialects & Voice Canon',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF5A4E44),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const TabBar(
              isScrollable: true,
              labelColor: Color(0xFF123E42),
              indicatorColor: Color(0xFF276D69),
              tabs: [
                Tab(text: '🔤 Abjad (28)'),
                Tab(text: '🇪🇸↔🇦🇪 Cognados'),
                Tab(text: '📺 TV & Dialects'),
                Tab(text: '🎙️ Voice Canon'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildAbjadTab(),
                  _buildCognatesTab(),
                  _buildSubtitleBridgesTab(),
                  _buildVoiceCanonTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAbjadTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: kFullArabicAbjad.length,
      itemBuilder: (context, index) {
        final item = kFullArabicAbjad[index];
        final isUnlocked = progress.unlockedLetters.contains(item.letter);
        final sunMoonBadge = switch (item.sunOrMoon) {
          'sun' => '☀️ Solar (Asimila ال)',
          'moon' => '🌙 Lunar (Conserva ال)',
          _ => '✨ Vocal Larga',
        };
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          color: isUnlocked ? Colors.white : const Color(0xFFF3ECE0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(
              color: isUnlocked
                  ? const Color(0xFF276D69)
                  : const Color(0xFFD5C7B2),
            ),
          ),
          child: ListTile(
            onTap: () => voiceService.speakArabicWord(item.exampleArabic),
            leading: CircleAvatar(
              radius: 24,
              backgroundColor: const Color(0xFF123E42),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Text(
                  item.letter,
                  style: const TextStyle(
                    color: Color(0xFFFFD166),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            title: Row(
              children: [
                Text(
                  '${item.nameTranslit} (${item.nameArabic})',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF123E42),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFE0C4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    sunMoonBadge,
                    style: const TextStyle(fontSize: 11),
                  ),
                ),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(
                      'أشكال:  ${item.forms['isolated']}   |   ${item.forms['initial']}   |   ${item.forms['medial']}   |   ${item.forms['final']}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF276D69),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '🇪🇸 ${item.spanishPhoneticTip}\n🇺🇸 ${item.englishPhoneticTip}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Ej/Ex: ${item.exampleArabic} (${item.exampleTranslit}) — ${item.exampleMeaningEsEn}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B2737),
                    ),
                  ),
                ],
              ),
            ),
            trailing: const Icon(
              Icons.volume_up_rounded,
              color: Color(0xFF276D69),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCognatesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: kSpanishArabicCognates.length,
      itemBuilder: (context, index) {
        final word = kSpanishArabicCognates[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: Color(0xFFD4AF37)),
          ),
          child: ListTile(
            onTap: () => voiceService.speakArabicWord(word.arabic),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '🇪🇸 ${word.spanishMeaning}  •  🇺🇸 ${word.englishMeaning}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF123E42),
                    ),
                  ),
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    word.arabic,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF276D69),
                    ),
                  ),
                ),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                '${word.transliteration} — ${word.spanishBridgeNote}',
                style: const TextStyle(fontSize: 12.5, height: 1.35),
              ),
            ),
            trailing: const Icon(Icons.volume_up_rounded),
          ),
        );
      },
    );
  }

  Widget _buildSubtitleBridgesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: kSubtitleBridgePairs.length,
      itemBuilder: (context, index) {
        final pair = kSubtitleBridgePairs[index];
        final msa = pair['msa'] ?? '';
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          color: Colors.white,
          child: ListTile(
            onTap: () => voiceService.speakArabicWord(msa),
            title: Text(
              '📺 Subtítulo MSA (Fuṣḥā): $msa (${pair['msaTranslit'] ?? ''})',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF123E42),
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                '🇦🇪 Nūr (Dubai): ${pair['khaliji'] ?? ''}\n'
                '🇱🇧 Yāsmīn (Levant): ${pair['shami'] ?? ''}\n'
                '🇪🇬 Laylā (Cairo): ${pair['masri'] ?? ''}\n'
                '🇪🇸/🇺🇸 ${pair['meaning'] ?? ''}',
                style: const TextStyle(fontSize: 12.5, height: 1.4),
              ),
            ),
            trailing: const Icon(Icons.volume_up_rounded),
          ),
        );
      },
    );
  }

  Widget _buildVoiceCanonTab() {
    final entries = kCharacterVoiceCanon.values.toList();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF123E42),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'Canonical Voice Manifest Seal: $kVoiceCanonSealHash\n'
            'Source: assets/voices/voice-manifest.json • Pipeline: scripts/voice-pipeline.sh',
            style: const TextStyle(color: Color(0xFFFFD166), fontSize: 12),
          ),
        ),
        ...entries.map(
          (profile) => Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              title: Text(
                '${profile.displayName} (${profile.primaryLocale})',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Pitch: ${profile.pitch} • Rate: ${profile.rate} • Wave: ${profile.timbreWave}\n'
                '${profile.canonDescription}',
                style: const TextStyle(fontSize: 12),
              ),
              trailing: FilledButton.tonalIcon(
                onPressed: () {
                  final charId = CharacterId.values.firstWhere(
                    (c) => c.name == profile.id,
                    orElse: () => CharacterId.tlatoani,
                  );
                  voiceService.playCharacterAudition(charId);
                },
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Audition'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
