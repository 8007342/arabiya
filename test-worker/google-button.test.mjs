import test from 'node:test';
import assert from 'node:assert/strict';
import vm from 'node:vm';
import { readFile } from 'node:fs/promises';

const source = await readFile(new URL('../web/google-sign-in.js', import.meta.url), 'utf8');
function bridge(enabled = true) {
  const calls = [];
  let configuration;
  const context = { setTimeout, clearTimeout,
    window: { google: { accounts: { id: {
      initialize(value) { configuration = value; },
      renderButton(element, options) { calls.push({ element, options }); },
    } } } },
    fetch: async (url, options) => {
      calls.push({ url, options });
      const result = url === '/api/config' ? { googleEnabled: enabled, googleClientId: 'client' }
        : url.endsWith('challenge') ? { nonce: 'challenge' } : { authenticated: true };
      return { ok: true, json: async () => result };
    },
  };
  vm.runInNewContext(source, context);
  return { context, calls, get configuration() { return configuration; } };
}

test('official button is initialized with a nonce and exchanges credentials same-origin', async () => {
  const app = bridge();
  const results = [];
  const element = { isConnected: true };
  await app.context.window.arabiyaRenderGoogleButton(element, result => results.push(result));
  assert.equal(app.configuration.nonce, 'challenge');
  assert.equal(app.configuration.ux_mode, 'popup');
  assert.equal(app.calls.find(call => call.element)?.options.type, 'standard');
  await app.configuration.callback({ credential: 'google-token' });
  const post = app.calls.find(call => call.url === '/api/auth/google');
  assert.equal(post.options.credentials, 'same-origin');
  assert.equal(JSON.parse(post.options.body).credential, 'google-token');
  assert.deepEqual(results, ['']);
});

test('missing client configuration shows a recoverable message and never renders a fake button', async () => {
  const app = bridge(false);
  let result;
  await app.context.window.arabiyaRenderGoogleButton({ isConnected: true }, value => { result = value; });
  assert.match(result, /keep playing/);
  assert.equal(app.configuration, undefined);
  assert.equal(app.calls.some(call => call.element), false);
});
