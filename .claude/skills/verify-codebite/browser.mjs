// Headless Chrome over CDP for driving this checkout's branch servers: a profile of its own, so the user's
// Chrome, sign-ins and drafts are never touched. The plumbing is scripts/walkthrough-app-check.mjs's, made
// importable; drive.mjs holds the journeys. Node 22+, no npm dependencies; CHROME_PATH if Chrome isn't found.
import { spawn, execFileSync } from 'node:child_process';
import { appendFileSync, existsSync, mkdirSync, mkdtempSync, rmSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';

const CDP_TIMEOUT = +process.env.VERIFY_CDP_TIMEOUT_MS || 60000;
const WAIT = +process.env.VERIFY_WAIT_MS || 15000;
const sleep = ms => new Promise(r => setTimeout(r, ms));

// A wait ran out: the journey has nothing more to look at.
export class Stopped extends Error {}

function chromePath() {
  for (const p of [process.env.CHROME_PATH, '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome']) if (p && existsSync(p)) return p;
  return execFileSync('which', ['google-chrome']).toString().trim();
}

// The branch servers of the checkout at `root`, read from `scripts/dev-branch-servers.sh status`:
// { vite, api, database }. Throws with status's own words when they aren't this checkout's, or aren't up.
export function branchServers(root) {
  let out;
  try { out = execFileSync(join(root, 'scripts/dev-branch-servers.sh'), ['status'], { cwd: root, stdio: ['ignore', 'pipe', 'pipe'] }).toString(); }
  catch (e) { throw new Error(`branch servers: ${(String(e.stdout || '') + String(e.stderr || '')).trim() || e.message}\n  start them: scripts/dev-branch-servers.sh start --wait --detach`); }
  const pick = re => { const m = out.match(re); if (!m) throw new Error(`branch servers: status printed no ${re}`); return m[1]; };
  return { vite: pick(/^\s*frontend\s+(http:\S+)/m), api: pick(/^\s*backend\s+(http:\S+)/m), database: pick(/^\s*database\s+(\S+)/m) };
}

// Opens Chrome and returns the driver. Every check line and screenshot path goes to stdout and to
// <out>/report.txt, so the evidence directory explains itself.
export async function openBrowser({ vite, api, out }) {
  mkdirSync(out, { recursive: true });
  const report = join(out, 'report.txt');
  const say = line => { console.log(line); appendFileSync(report, line + '\n'); };

  const profile = mkdtempSync(join(tmpdir(), 'verify-chrome-'));
  const proc = spawn(chromePath(), ['--headless=new', '--remote-debugging-port=0', `--user-data-dir=${profile}`, '--no-first-run',
    '--no-default-browser-check', '--hide-scrollbars', 'about:blank'], { stdio: ['ignore', 'ignore', 'pipe'] });
  // However this process ends, take the Chrome it started with it (that one only, by handle).
  const gone = new Promise(r => proc.on('exit', r));
  const dropProfile = () => { try { rmSync(profile, { recursive: true, force: true, maxRetries: 5, retryDelay: 100 }); } catch { /* Chrome still letting go of it */ } };
  process.on('exit', () => { proc.kill(); dropProfile(); });
  for (const sig of ['SIGTERM', 'SIGINT', 'SIGHUP']) process.on(sig, () => process.exit(1));
  const port = await new Promise((done, fail) => {
    let text = '';
    const t = setTimeout(() => { proc.kill(); fail(new Error('Chrome did not start')); }, 20000);
    proc.stderr.on('data', d => { text += d; const m = text.match(/DevTools listening on ws:\/\/[^:]+:(\d+)\//); if (m) { clearTimeout(t); done(+m[1]); } });
  });
  const targets = await (await fetch(`http://127.0.0.1:${port}/json/list`)).json();
  const ws = new WebSocket(targets.find(t => t.type === 'page').webSocketDebuggerUrl);
  await new Promise((ok, fail) => { ws.onopen = ok; ws.onerror = fail; });
  let seq = 0;
  const waiting = new Map(), errors = [];
  ws.onmessage = ev => {
    const m = JSON.parse(ev.data);
    if (m.id && waiting.has(m.id)) { const { ok, fail } = waiting.get(m.id); waiting.delete(m.id); m.error ? fail(new Error(m.error.message)) : ok(m.result); }
    else if (m.method === 'Runtime.exceptionThrown') errors.push(m.params.exceptionDetails.exception?.description || m.params.exceptionDetails.text);
    else if (m.method === 'Runtime.consoleAPICalled' && m.params.type === 'error') errors.push(m.params.args.map(a => a.value ?? a.description).join(' '));
  };
  const send = (method, params = {}) => new Promise((ok, fail) => {
    const id = ++seq;
    const t = setTimeout(() => { waiting.delete(id); fail(new Error(`Chrome did not answer ${method} within ${CDP_TIMEOUT} ms`)); }, CDP_TIMEOUT);
    waiting.set(id, { ok: v => { clearTimeout(t); ok(v); }, fail: e => { clearTimeout(t); fail(e); } });
    ws.send(JSON.stringify({ id, method, params }));
  });
  await send('Page.enable'); await send('Runtime.enable');

  let failures = 0, opens = 0;
  const b = {
    vite, api, out, errors, send, say,
    get failures() { return failures; },
    // One line of the proof: what was checked and whether it held.
    check(ok, what) { say(`${ok ? 'ok  ' : 'FAIL'} ${what}`); if (!ok) failures++; return !!ok; },
    async js(expression) { return (await send('Runtime.evaluate', { expression, returnByValue: true, awaitPromise: true })).result.value; },
    async waitFor(expression, ms = WAIT) {
      const end = Date.now() + ms;
      for (;;) {
        if (await b.js(expression).catch(() => false)) return true; // a page between two documents refuses the expression
        if (Date.now() >= end) return false;
        await sleep(Math.min(150, ms));
      }
    },
    // Waits for what the next steps need; when it doesn't show, the journey stops there as one failed check.
    async shown(what, expression, { ms = WAIT, seen } = {}) {
      if (await b.waitFor(expression, ms)) return;
      const instead = seen ? await b.js(seen).catch(() => null) : null;
      throw new Stopped(`${what} did not show within ${ms / 1000} s${instead ? ` (${instead})` : ''}`);
    },
    async shot(name) {
      const { data } = await send('Page.captureScreenshot', { format: 'png' });
      writeFileSync(join(out, name + '.png'), Buffer.from(data, 'base64'));
      say('     ' + join(out, name + '.png'));
    },
    // A real click (mouse events at the element's centre), on the first element matching the selector, or the
    // first of those whose text includes `text`. False when there is none.
    async click(selector, text) {
      const at = await b.js(`(() => { const el = [...document.querySelectorAll(${JSON.stringify(selector)})]
        .find(e => ${text === undefined ? 'true' : `e.textContent.includes(${JSON.stringify(text)})`}); if (!el) return null;
        el.scrollIntoView({ block: 'center' }); const r = el.getBoundingClientRect(); return { x: r.x + r.width / 2, y: r.y + r.height / 2 }; })()`);
      if (!at) return false;
      await send('Input.dispatchMouseEvent', { type: 'mouseMoved', ...at });
      for (const type of ['mousePressed', 'mouseReleased']) await send('Input.dispatchMouseEvent', { type, ...at, button: 'left', clickCount: 1 });
      return true;
    },
    // A key press; `modifiers` is CDP's bit mask (Alt 1, Ctrl 2, Meta 4, Shift 8), `commands` its editing commands.
    async key(key, code, vk, { modifiers = 0, commands = [] } = {}) {
      await send('Input.dispatchKeyEvent', { type: 'keyDown', key, code, windowsVirtualKeyCode: vk, modifiers, commands });
      await send('Input.dispatchKeyEvent', { type: 'keyUp', key, code, windowsVirtualKeyCode: vk, modifiers });
    },
    // Text typed into the focused field. Monaco indents and closes brackets as it would for a person typing, so
    // code goes in with paste instead.
    async insert(text) { await send('Input.insertText', { text }); },
    // Pastes text into the focused element: the paste event a Cmd+V delivers, carrying `text`.
    async paste(text) {
      return b.js(`(() => { const dt = new DataTransfer(); dt.setData('text/plain', ${JSON.stringify(text)});
        return document.activeElement.dispatchEvent(new ClipboardEvent('paste', { clipboardData: dt, bubbles: true, cancelable: true })); })()`);
    },
    // A dev test token for `username` (made on first use); role USER or ADMIN.
    async token(username, role = 'USER') {
      const res = await fetch(`${api}/auth/test-token?username=${encodeURIComponent(username)}&role=${role}`, { method: 'POST' });
      if (!res.ok) throw new Error(`test token for ${username}: HTTP ${res.status}`);
      return (await res.json()).token;
    },
    // Opens a route of the branch frontend as a fresh visitor: this width, theme, language and sign-in, written
    // to localStorage by a script Chrome runs before any of the app's (never on a page the app already runs on).
    async open(path, { width = 1440, theme = 'light', lang = 'en', jwt = null } = {}) {
      await send('Emulation.setDeviceMetricsOverride', { width, height: width < 600 ? 844 : 900, deviceScaleFactor: 1, mobile: width < 600 });
      await send('Emulation.setEmulatedMedia', { features: [{ name: 'prefers-reduced-motion', value: 'reduce' }] });
      const id = ++opens;
      const { identifier } = await send('Page.addScriptToEvaluateOnNewDocument', { source: `if (window === top && location.origin === ${JSON.stringify(new URL(vite).origin)}) {
        localStorage.clear(); localStorage.setItem('theme', ${JSON.stringify(theme)}); localStorage.setItem('i18nextLng', ${JSON.stringify(lang)});
        ${jwt ? `localStorage.setItem('token', ${JSON.stringify(jwt)});` : ''} window.__verifyOpen = ${id}; }` });
      await send('Page.navigate', { url: vite + path });
      try { await b.shown(`the page at ${path}`, `window.__verifyOpen === ${id} && document.readyState === 'complete'`); }
      finally { await send('Page.removeScriptToEvaluateOnNewDocument', { identifier }); }
    },
    // Ends the run: console errors are a failed check; closes the Chrome this run started. Returns the exit code.
    async finish() {
      b.check(errors.length === 0, `console errors: ${errors.length ? errors.join(' | ') : 'none'}`);
      ws.close(); proc.kill(); await gone; dropProfile();
      say(`${failures ? 'FAILED' : 'PASSED'}: evidence in ${out}`);
      return failures ? 1 : 0;
    },
  };
  return b;
}
