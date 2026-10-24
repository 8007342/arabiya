#!/usr/bin/env node
// Run after authoring audio: node scripts/test-voice-pipeline.cjs
const assert = require('node:assert/strict');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const {spawnSync} = require('node:child_process');
const fixture = fs.mkdtempSync(path.join(os.tmpdir(), 'arabiya-voice-check-'));
try {
  for (const relative of ['assets/voices', 'assets/audio', 'lib/src/data']) {
    fs.cpSync(relative, path.join(fixture, relative), {recursive: true});
  }
  const pipeline = path.resolve('scripts/voice-pipeline.cjs');
  const run = () => spawnSync(process.execPath, [pipeline], {cwd: fixture, encoding: 'utf8'});
  let result = run();
  assert.equal(result.status, 0, result.stderr);

  const chapter = path.join(fixture, 'lib/src/data/door_episode.dart');
  const source = fs.readFileSync(chapter, 'utf8');
  fs.writeFileSync(chapter, source.replace('One small suitcase. That was the plan.', 'One changed suitcase. That was the plan.'));
  result = run();
  assert.notEqual(result.status, 0);
  assert.match(result.stderr, /Stale or missing recording: door_arrival_covi/);
  fs.writeFileSync(chapter, source);

  const profileFile = path.join(fixture, 'assets/voices/voice-manifest.json');
  const originalProfile = fs.readFileSync(profileFile, 'utf8');
  const profile = JSON.parse(originalProfile);
  profile.characters.covi.synthesis.voice = 'changed-voice';
  fs.writeFileSync(profileFile, JSON.stringify(profile));
  result = run();
  assert.notEqual(result.status, 0);
  assert.match(result.stderr, /Stale or missing recording/);
  fs.writeFileSync(profileFile, originalProfile);

  const audioFile = path.join(fixture, 'assets/audio/panels/door_arrival_covi.mp3');
  const audio = fs.readFileSync(audioFile);
  fs.writeFileSync(audioFile, Buffer.concat([audio, Buffer.from('corruption')]));
  result = run();
  assert.notEqual(result.status, 0);
  assert.match(result.stderr, /Stale or missing recording: door_arrival_covi/);
  fs.writeFileSync(audioFile, audio);

  const wordDirectory = path.join(fixture, 'assets/audio/words');
  fs.unlinkSync(path.join(wordDirectory, fs.readdirSync(wordDirectory)[0]));
  result = run();
  assert.notEqual(result.status, 0);
  assert.match(result.stderr, /Missing or changed Arabic word recording/);
  console.log('ok:voice-pipeline:offline-valid, changed-script, changed-voice, corrupt-audio, missing-word');
} finally {
  fs.rmSync(fixture, {recursive: true, force: true});
}
