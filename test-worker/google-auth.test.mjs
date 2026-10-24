import test from 'node:test';
import assert from 'node:assert/strict';
import { DatabaseSync } from 'node:sqlite';
import { generateKeyPair, SignJWT, exportJWK, createLocalJWKSet } from 'jose';
import worker, { ArabiyaState, verifyGoogleCredential } from '../worker/index.mjs';

const { publicKey, privateKey } = await generateKeyPair('RS256');
const jwk = { ...await exportJWK(publicKey), kid: 'test-key', alg: 'RS256' };
const keys = createLocalJWKSet({ keys: [jwk] });
const nonce = 'a'.repeat(48);
const clientId = 'test.apps.googleusercontent.com';
async function token(overrides = {}, signingKey = privateKey) {
  return new SignJWT({ nonce, name: 'Learner', email: 'learner@example.com', email_verified: true,
    sub: 'stable-google-sub', iss: 'https://accounts.google.com', aud: clientId,
    iat: Math.floor(Date.now() / 1000), exp: Math.floor(Date.now() / 1000) + 3600,
    ...overrides }).setProtectedHeader({ alg: 'RS256', kid: 'test-key' }).sign(signingKey);
}
function state(env = { GOOGLE_CLIENT_ID: clientId }) {
  const db = new DatabaseSync(':memory:');
  return new ArabiyaState({ storage: { sql: { exec(query, ...args) {
    const statement = db.prepare(query);
    return statement.columns().length ? statement.all(...args) : (statement.run(...args), []);
  } } } }, env);
}
function request(path, body, cookie = '', origin = 'https://arabiya.example') {
  return new Request(`https://arabiya.example${path}`, body === undefined ? {} : {
    method: 'POST', headers: { origin, cookie, 'content-type': 'application/json' },
    body: JSON.stringify(body),
  });
}

test('Google verification requires signature, audience, issuer, expiry and matching nonce', async () => {
  assert.equal((await verifyGoogleCredential(await token(), clientId, nonce, keys)).sub, 'stable-google-sub');
  for (const claims of [{ aud: 'another-app' }, { iss: 'attacker' }, { exp: 1 }, { nonce: 'wrong' }, { sub: '' }]) {
    await assert.rejects(verifyGoogleCredential(await token(claims), clientId, nonce, keys));
  }
  await assert.rejects(verifyGoogleCredential(await token(), clientId, '', keys));
  const other = await generateKeyPair('RS256');
  await assert.rejects(verifyGoogleCredential(await token({}, other.privateKey), clientId, nonce, keys));
});

test('Google endpoints fail closed when unconfigured, cross-origin, malformed or missing challenge', async () => {
  assert.equal((await state({}).fetch(request('/api/auth/google', {}))).status, 503);
  assert.equal((await state().fetch(request('/api/auth/google', {}, '', 'https://attacker.example'))).status, 403);
  assert.equal((await state().fetch(request('/api/auth/google', {}))).status, 401);
  const response = await state().fetch(request('/api/auth/google/challenge'));
  assert.match((await response.json()).nonce, /^[a-f0-9]{48}$/);
  assert.match(response.headers.get('set-cookie'), /HttpOnly; Secure; SameSite=Strict/);
});

test('Google login creates cookie-only session, isolates identity by sub, restores progress and logs out', async () => {
  const originalFetch = globalThis.fetch;
  globalThis.fetch = async () => new Response(JSON.stringify({ keys: [jwk] }), { headers: { 'content-type': 'application/json' } });
  try {
    const app = state();
    const response = await app.fetch(request('/api/auth/google', { credential: await token() }, `arabiya_google_nonce=${nonce}`));
    assert.equal(response.status, 200);
    const body = await response.json();
    assert.equal(body.user.userKey, 'google:stable-google-sub');
    assert.equal(body.sessionToken, undefined);
    const cookie = response.headers.getSetCookie().find(value => value.startsWith('arabiya_session='));
    assert.match(cookie, /HttpOnly; Secure; SameSite=Lax/);
    const sessionCookie = cookie.split(';')[0];
    const session = await app.fetch(new Request('https://arabiya.example/api/auth/session', { headers: { cookie: sessionCookie } }));
    assert.equal((await session.json()).authenticated, true);
    const saved = await app.fetch(request('/api/progress', { progress: { xp: 123 } }, sessionCookie));
    assert.equal((await saved.json()).progress.xp, 123);
    const relogin = await app.fetch(request('/api/auth/google', { credential: await token({ email: 'changed@example.com' }) }, `arabiya_google_nonce=${nonce}`));
    assert.equal((await relogin.json()).progress.xp, 123);
    const another = await app.fetch(request('/api/auth/google', { credential: await token({ sub: 'other-user' }) }, `arabiya_google_nonce=${nonce}`));
    assert.equal((await another.json()).progress.xp, 0);
    await app.fetch(request('/api/auth/logout', {}, sessionCookie));
    const loggedOut = await app.fetch(new Request('https://arabiya.example/api/auth/session', { headers: { cookie: sessionCookie } }));
    assert.equal((await loggedOut.json()).authenticated, false);
  } finally { globalThis.fetch = originalFetch; }
});

test('expired sessions cannot restore or write progress', async () => {
  const app = state();
  app.sql.exec("INSERT INTO users (user_key,display_name,created_at) VALUES ('u','User','2000-01-01')");
  app.sql.exec("INSERT INTO sessions (token,user_key,created_at) VALUES ('expired','u','2000-01-01')");
  assert.equal((await app.fetch(request('/api/progress', {}, 'arabiya_session=expired'))).status, 401);
});

test('public runtime config disables Google until configured', async () => {
  const response = await worker.fetch(request('/api/config'), {});
  assert.equal((await response.json()).googleEnabled, false);
});

test('writing evidence merges by immutable attempt ID with bounded history', async () => {
  const { mergeWritingEvidence } = await import('../worker/index.mjs');
  const original = { id: 'attempt-1', target: 'ba', accepted: false, timestamp: '2026-10-24T01:00:00Z' };
  const merged = mergeWritingEvidence([original], [
    { ...original, accepted: true },
    { id: 'attempt-2', target: 'ba', accepted: true, timestamp: '2026-10-24T02:00:00Z' },
    { id: 'oversized', detail: 'x'.repeat(1500) },
  ]);
  assert.equal(merged.length, 2);
  assert.equal(merged[0].accepted, false);
  assert.equal(mergeWritingEvidence([], Array.from({ length: 200 }, (_, i) => ({ id: String(i), timestamp: String(i).padStart(4, '0') }))).length, 96);
});
