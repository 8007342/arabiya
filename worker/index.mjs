// @trace spec:cloud-edge-sync
// Cloudflare Worker + SQLite Durable Object (`ArabiyaState`) for arabiya.tlatoani.net.
// Auto-provisions all SQLite tables on first invocation on the Cloudflare Free Tier.

const JSON_HEADERS = {
  'content-type': 'application/json; charset=utf-8',
  'cache-control': 'no-store',
  'x-content-type-options': 'nosniff',
};

const json = (data, status = 200, extraHeaders = {}) =>
  new Response(JSON.stringify(data), {
    status,
    headers: { ...JSON_HEADERS, ...extraHeaders },
  });

const MAX_BODY_BYTES = 16384;

async function readJsonBody(request) {
  const ct = (request.headers.get('content-type') || '').toLowerCase();
  if (!ct.startsWith('application/json')) {
    throw new Error('Expected application/json');
  }
  const reader = request.body?.getReader();
  if (!reader) throw new Error('Empty request body');
  let size = 0;
  const chunks = [];
  while (true) {
    const { done, value } = await reader.read();
    if (done) break;
    size += value.byteLength;
    if (size > MAX_BODY_BYTES) {
      await reader.cancel();
      throw new Error('Payload too large');
    }
    chunks.push(value);
  }
  const bytes = new Uint8Array(size);
  let offset = 0;
  for (const chunk of chunks) {
    bytes.set(chunk, offset);
    offset += chunk.byteLength;
  }
  return JSON.parse(new TextDecoder().decode(bytes));
}

async function sha256Hex(input) {
  const bytes = new TextEncoder().encode(input);
  const digest = await crypto.subtle.digest('SHA-256', bytes);
  return [...new Uint8Array(digest)]
    .map((b) => b.toString(16).padStart(2, '0'))
    .join('');
}

function randomToken() {
  const bytes = new Uint8Array(24);
  crypto.getRandomValues(bytes);
  return [...bytes].map((b) => b.toString(16).padStart(2, '0')).join('');
}

function parseSessionToken(request) {
  const auth = request.headers.get('authorization') || '';
  if (auth.toLowerCase().startsWith('bearer ')) {
    const t = auth.slice(7).trim();
    if (t) return t;
  }
  const cookie = request.headers.get('cookie') || '';
  for (const part of cookie.split(';')) {
    const [k, ...v] = part.trim().split('=');
    if (k === 'arabiya_session' && v.length > 0) {
      return decodeURIComponent(v.join('='));
    }
  }
  return null;
}

function makeSessionCookie(token, maxAgeSeconds = 60 * 60 * 24 * 30) {
  return `arabiya_session=${encodeURIComponent(token)}; Path=/; Max-Age=${maxAgeSeconds}; HttpOnly; SameSite=Lax`;
}

function normalizeStringArray(arr, maxLen = 128) {
  if (!Array.isArray(arr)) return [];
  const out = new Set();
  for (const item of arr) {
    if (typeof item === 'string' && item.length > 0 && item.length <= 64) {
      out.add(item);
      if (out.size >= maxLen) break;
    }
  }
  return [...out];
}

export function mergeProgressSnapshots(existing, incoming) {
  const base = existing || {
    currentChapterId: 'ch1_dxb_touchdown',
    currentPanelIndex: 0,
    highestChapterIndex: 0,
    xp: 0,
    streakDays: 1,
    completedChapters: [],
    unlockedLetters: [],
    masteredWords: [],
    affinities: { nur: 0, yasmin: 0, layla: 0 },
  };
  const inc = incoming || {};
  const completedChapters = normalizeStringArray([
    ...(base.completedChapters || []),
    ...(inc.completedChapters || []),
  ]);
  const unlockedLetters = normalizeStringArray([
    ...(base.unlockedLetters || []),
    ...(inc.unlockedLetters || []),
  ]);
  const masteredWords = normalizeStringArray([
    ...(base.masteredWords || []),
    ...(inc.masteredWords || []),
  ]);
  const baseAff = base.affinities || {};
  const incAff = inc.affinities || {};
  const affinities = {
    nur: Math.max(Number(baseAff.nur) || 0, Number(incAff.nur) || 0),
    yasmin: Math.max(Number(baseAff.yasmin) || 0, Number(incAff.yasmin) || 0),
    layla: Math.max(Number(baseAff.layla) || 0, Number(incAff.layla) || 0),
  };
  const highestChapterIndex = Math.max(
    Number(base.highestChapterIndex) || 0,
    Number(inc.highestChapterIndex) || 0,
  );
  const xp = Math.max(Number(base.xp) || 0, Number(inc.xp) || 0);
  const streakDays = Math.max(
    Number(base.streakDays) || 1,
    Number(inc.streakDays) || 1,
  );
  const currentChapterId =
    typeof inc.currentChapterId === 'string' && inc.currentChapterId.length > 0
      ? inc.currentChapterId
      : base.currentChapterId || 'ch1_dxb_touchdown';
  const currentPanelIndex =
    Number.isSafeInteger(inc.currentPanelIndex) && inc.currentPanelIndex >= 0
      ? inc.currentPanelIndex
      : Number(base.currentPanelIndex) || 0;

  return {
    currentChapterId,
    currentPanelIndex,
    highestChapterIndex,
    xp,
    streakDays,
    completedChapters,
    unlockedLetters,
    masteredWords,
    affinities,
    updatedAt: new Date().toISOString(),
  };
}

export class ArabiyaState {
  constructor(state) {
    this.storage = state.storage;
    this.sql = state.storage.sql;
    this.sql.exec(`
      CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_key TEXT UNIQUE NOT NULL,
        display_name TEXT NOT NULL,
        email TEXT NOT NULL DEFAULT '',
        pass_hash TEXT NOT NULL DEFAULT '',
        auth_provider TEXT NOT NULL DEFAULT 'passport',
        created_at TEXT NOT NULL
      )
    `);
    this.sql.exec(`
      CREATE TABLE IF NOT EXISTS sessions (
        token TEXT PRIMARY KEY,
        user_key TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    `);
    this.sql.exec(`
      CREATE TABLE IF NOT EXISTS progress (
        user_key TEXT PRIMARY KEY,
        payload_json TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    `);
  }

  getUserByToken(token) {
    if (!token) return null;
    const rows = [
      ...this.sql.exec(
        'SELECT u.user_key, u.display_name, u.email, u.auth_provider FROM sessions s JOIN users u ON u.user_key = s.user_key WHERE s.token = ? LIMIT 1',
        token,
      ),
    ];
    return rows[0] || null;
  }

  getProgress(userKey) {
    const rows = [
      ...this.sql.exec(
        'SELECT payload_json FROM progress WHERE user_key = ? LIMIT 1',
        userKey,
      ),
    ];
    if (!rows.length) {
      return mergeProgressSnapshots(null, null);
    }
    try {
      return mergeProgressSnapshots(JSON.parse(rows[0].payload_json), null);
    } catch {
      return mergeProgressSnapshots(null, null);
    }
  }

  saveProgress(userKey, incoming) {
    const existing = this.getProgress(userKey);
    const merged = mergeProgressSnapshots(existing, incoming);
    const now = new Date().toISOString();
    this.sql.exec(
      'INSERT INTO progress (user_key, payload_json, updated_at) VALUES (?, ?, ?) ON CONFLICT(user_key) DO UPDATE SET payload_json = excluded.payload_json, updated_at = excluded.updated_at',
      userKey,
      JSON.stringify(merged),
      now,
    );
    return merged;
  }

  async fetch(request) {
    const url = new URL(request.url);
    const path = url.pathname;

    if (path === '/api/auth/session' && request.method === 'GET') {
      const token = parseSessionToken(request);
      const user = this.getUserByToken(token);
      if (!user) {
        return json({ authenticated: false });
      }
      return json({
        authenticated: true,
        user: {
          userKey: user.user_key,
          displayName: user.display_name,
          email: user.email,
          authProvider: user.auth_provider,
        },
        progress: this.getProgress(user.user_key),
      });
    }

    if (path === '/api/auth/logout' && request.method === 'POST') {
      const token = parseSessionToken(request);
      if (token) {
        this.sql.exec('DELETE FROM sessions WHERE token = ?', token);
      }
      return json(
        { ok: true },
        200,
        { 'set-cookie': makeSessionCookie('', 0) },
      );
    }

    if (path === '/api/auth/passport' && request.method === 'POST') {
      let body;
      try {
        body = await readJsonBody(request);
      } catch (e) {
        return json({ error: e.message || 'Invalid JSON' }, 400);
      }
      const rawHandle = String(body.handle || body.email || '').trim();
      if (rawHandle.length < 2 || rawHandle.length > 64) {
        return json({ error: 'Handle or email must be 2 to 64 characters' }, 400);
      }
      const userKey = `passport:${rawHandle.toLowerCase()}`;
      const displayName = String(body.displayName || rawHandle.split('@')[0]).slice(0, 40);
      const passcode = String(body.passcode || 'tlatoani');
      const passHash = await sha256Hex(`${userKey}:${passcode}`);

      const existing = [
        ...this.sql.exec(
          'SELECT user_key, display_name, email, pass_hash, auth_provider FROM users WHERE user_key = ? LIMIT 1',
          userKey,
        ),
      ][0];

      const now = new Date().toISOString();
      if (!existing) {
        this.sql.exec(
          'INSERT INTO users (user_key, display_name, email, pass_hash, auth_provider, created_at) VALUES (?, ?, ?, ?, ?, ?)',
          userKey,
          displayName,
          rawHandle.includes('@') ? rawHandle : '',
          passHash,
          'passport',
          now,
        );
      } else if (existing.pass_hash && existing.pass_hash !== passHash) {
        return json({ error: 'Incorrect passcode for this traveler handle' }, 401);
      }

      const token = randomToken();
      this.sql.exec(
        'INSERT INTO sessions (token, user_key, created_at) VALUES (?, ?, ?)',
        token,
        userKey,
        now,
      );
      const mergedProgress = this.saveProgress(userKey, body.progress || null);

      return json(
        {
          authenticated: true,
          sessionToken: token,
          user: {
            userKey,
            displayName: existing ? existing.display_name : displayName,
            email: existing ? existing.email : rawHandle,
            authProvider: 'passport',
          },
          progress: mergedProgress,
        },
        200,
        { 'set-cookie': makeSessionCookie(token) },
      );
    }

    if (path === '/api/progress') {
      const token = parseSessionToken(request);
      const user = this.getUserByToken(token);
      if (!user) {
        return json({ error: 'Sign in required to sync cloud progress' }, 401);
      }
      if (request.method === 'GET') {
        return json({ progress: this.getProgress(user.user_key) });
      }
      if (request.method === 'POST') {
        let body;
        try {
          body = await readJsonBody(request);
        } catch (e) {
          return json({ error: e.message || 'Invalid JSON' }, 400);
        }
        const merged = this.saveProgress(user.user_key, body.progress || body);
        return json({ progress: merged });
      }
      return json({ error: 'Method not allowed' }, 405);
    }

    return json({ error: 'Not found' }, 404);
  }
}

export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    if (url.pathname === '/api/config' && request.method === 'GET') {
      const googleClientId = env.GOOGLE_CLIENT_ID || '';
      return json({
        appDomain: env.APP_DOMAIN || 'arabiya.tlatoani.net',
        googleClientId,
        googleEnabled: Boolean(googleClientId),
        authModes: googleClientId ? ['google', 'passport'] : ['passport'],
      });
    }
    if (url.pathname.startsWith('/api/')) {
      const id = env.ARABIYA_STATE.idFromName('global-arabiya-v1');
      return env.ARABIYA_STATE.get(id).fetch(request);
    }
    return env.ASSETS.fetch(request);
  },
};
