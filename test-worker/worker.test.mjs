import test from 'node:test';
import assert from 'node:assert/strict';
import { mergeProgressSnapshots } from '../worker/index.mjs';

test('mergeProgressSnapshots monotonically merges XP, chapters, letters, and heroine affinities', () => {
  const local = {
    currentChapterId: 'ch3_alfahidi_cafe',
    currentPanelIndex: 4,
    highestChapterIndex: 2,
    xp: 340,
    streakDays: 3,
    completedChapters: ['ch1_dxb_touchdown', 'ch2_creek_abra'],
    unlockedLetters: ['ا', 'ب', 'ت', 'ث'],
    masteredWords: ['باب', 'قهوة'],
    affinities: { nur: 3, yasmin: 1, layla: 0 },
  };
  const cloud = {
    currentChapterId: 'ch2_creek_abra',
    currentPanelIndex: 1,
    highestChapterIndex: 1,
    xp: 500,
    streakDays: 2,
    completedChapters: ['ch1_dxb_touchdown'],
    unlockedLetters: ['ا', 'و', 'ي'],
    masteredWords: ['باب', 'زيت'],
    affinities: { nur: 2, yasmin: 2, layla: 1 },
  };

  const merged = mergeProgressSnapshots(cloud, local);
  assert.equal(merged.currentChapterId, 'ch3_alfahidi_cafe');
  assert.equal(merged.highestChapterIndex, 2);
  assert.equal(merged.xp, 500);
  assert.equal(merged.streakDays, 3);
  assert.deepEqual(merged.affinities, { nur: 3, yasmin: 2, layla: 1 });
  assert.ok(merged.unlockedLetters.includes('ث'));
  assert.ok(merged.unlockedLetters.includes('ي'));
  assert.ok(merged.masteredWords.includes('قهوة'));
  assert.ok(merged.masteredWords.includes('زيت'));
});
