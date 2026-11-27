#!/usr/bin/env node
// Checks member completion in a branch's real problem editor, in headless Chrome (a profile of its own,
// so the user's Chrome, sign-ins and drafts are never touched).
//   node scripts/editor-completion-check.mjs <vite url> <out dir> [slug]
// The URL is the frontend one scripts/dev-branch-servers.sh prints. For each case it picks the language
// in the toolbar, puts the case's line at the end of the Starter Code, types `.` as a key press, and checks
// that each expected member is in the suggestion list (typing its first letters, since the list shows a
// dozen rows at a time), with a screenshot of the list as `.` opened it. Then it checks that a call typed
// by hand stays exactly as typed, and that accepting a suggestion inserts the call. Prints a line per check
// and each screenshot's path; exits 1 on a failed check or a page error, 2 on bad arguments.
// Node 22+, no npm dependencies; set CHROME_PATH if Chrome isn't found.
import { spawn, execFileSync } from 'node:child_process';
import { existsSync, mkdirSync, mkdtempSync, rmSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';

const [VITE, OUT, SLUG = 'balance-brackets-with-wildcards'] = process.argv.slice(2);
if (!VITE || !OUT) {
  console.error('usage: editor-completion-check.mjs <vite url> <out dir> [slug]');
  process.exit(2);
}
mkdirSync(OUT, { recursive: true });

// Each case: the language's toolbar label, the line typed before `.`, the members the list must hold,
// and a call typed by hand after it, which must stay exactly as typed.
const CASES = [
  { name: 'java', label: 'Java', line: 'List<Integer> a = new ArrayList<>(); a', expect: ['add', 'clear', 'size', 'get', 'remove'], typed: 'add(1);', accept: { prefix: 'siz', result: 'size()' } },
  { name: 'python-list', label: 'Python', line: 'a = []; a', expect: ['append', 'pop', 'sort'], typed: 'append(1)', accept: { prefix: 'appe', result: 'append()' } },
  { name: 'python-dict', label: 'Python', line: 'd = {}; d', expect: ['get', 'items', 'keys'], typed: 'get(1)', accept: { prefix: 'item', result: 'items()' } },
  { name: 'javascript', label: 'JavaScript', line: 'const a = []; a', expect: ['push', 'map', 'filter'], typed: 'push(1);', accept: null },
  { name: 'cpp', label: 'C++', line: 'vector<int> a; a', expect: ['push_back', 'size', 'clear'], typed: 'push_back(1);', accept: { prefix: 'push_b', result: 'push_back()' } },
];

function chromePath() {
  const tries = [process.env.CHROME_PATH, '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'];
  for (const p of tries) if (p && existsSync(p)) return p;
  return execFileSync('which', ['google-chrome']).toString().trim();
}

async function openChrome() {
  const profile = mkdtempSync(join(tmpdir(), 'completion-chrome-'));
  const proc = spawn(chromePath(), ['--headless=new', '--remote-debugging-port=0', `--user-data-dir=${profile}`, '--no-first-run',
    '--no-default-browser-check', '--hide-scrollbars', '--window-size=1440,900', 'about:blank'], { stdio: ['ignore', 'ignore', 'pipe'] });
  process.on('exit', () => proc.kill());
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
  const waiting = new Map();
  const errors = [];
  ws.onmessage = ev => {
    const msg = JSON.parse(ev.data);
    if (msg.id && waiting.has(msg.id)) { const { ok, fail } = waiting.get(msg.id); waiting.delete(msg.id); msg.error ? fail(new Error(msg.error.message)) : ok(msg.result); }
    else if (msg.method === 'Runtime.exceptionThrown') errors.push(msg.params.exceptionDetails.exception?.description || msg.params.exceptionDetails.text);
  };
  const send = (method, params = {}) => new Promise((ok, fail) => {
    const id = ++seq;
    const t = setTimeout(() => { waiting.delete(id); fail(new Error(`Chrome did not answer ${method}`)); }, 60000);
    waiting.set(id, { ok: v => { clearTimeout(t); ok(v); }, fail: e => { clearTimeout(t); fail(e); } });
    ws.send(JSON.stringify({ id, method, params }));
  });
  await send('Page.enable'); await send('Runtime.enable');
  await send('Emulation.setDeviceMetricsOverride', { width: 1440, height: 900, deviceScaleFactor: 1, mobile: false });
  return { send, errors, close() { ws.close(); proc.kill(); setTimeout(() => rmSync(profile, { recursive: true, force: true }), 500); } };
}

const sleep = ms => new Promise(r => setTimeout(r, ms));
let failures = 0;
const check = (ok, what) => { console.log(`${ok ? 'ok  ' : 'FAIL'} ${what}`); if (!ok) failures++; };
process.on('uncaughtException', e => { check(false, e.message); process.exit(1); });

const c = await openChrome();
const js = async expression => (await c.send('Runtime.evaluate', { expression, returnByValue: true, awaitPromise: true })).result.value;
async function waitFor(expression, ms = 15000) {
  const end = Date.now() + ms;
  for (;;) {
    if (await js(expression).catch(() => false)) return true;
    if (Date.now() >= end) return false;
    await sleep(100);
  }
}
async function shot(name) {
  const { data } = await c.send('Page.captureScreenshot', { format: 'png' });
  writeFileSync(join(OUT, name + '.png'), Buffer.from(data, 'base64'));
  console.log('     ' + join(OUT, name + '.png'));
}
async function mouseClick(selectorExpr) {
  const box = await js(`(() => { const el = ${selectorExpr}; if (!el) return null; const r = el.getBoundingClientRect(); return { x: r.x + r.width / 2, y: r.y + r.height / 2 }; })()`);
  if (!box) return false;
  for (const type of ['mousePressed', 'mouseReleased']) await c.send('Input.dispatchMouseEvent', { type, x: box.x, y: box.y, button: 'left', clickCount: 1, pointerType: 'mouse' });
  return true;
}
const KEYS = { '.': ['Period', 190], '(': ['Digit9', 57], ')': ['Digit0', 48], ';': ['Semicolon', 186], _: ['Minus', 189] };
// One key press with its text, as a person types it: Monaco's suggest triggers on typed characters.
async function type(text) {
  for (const ch of text) {
    const [code, vk] = KEYS[ch] ?? [/[0-9]/.test(ch) ? `Digit${ch}` : `Key${ch.toUpperCase()}`, ch.toUpperCase().charCodeAt(0)];
    await c.send('Input.dispatchKeyEvent', { type: 'keyDown', key: ch, code, text: ch, windowsVirtualKeyCode: vk });
    await c.send('Input.dispatchKeyEvent', { type: 'keyUp', key: ch, code, windowsVirtualKeyCode: vk });
    await sleep(40);
  }
}
async function press(key, code, vk) {
  for (const type of ['keyDown', 'keyUp']) await c.send('Input.dispatchKeyEvent', { type, key, code, windowsVirtualKeyCode: vk });
  await sleep(60);
}
const EDITOR = `monaco.editor.getEditors().find(e => e.getDomNode().closest('[data-tour="editor"]')) ?? monaco.editor.getEditors()[0]`;
const suggestVisible = `!!document.querySelector('.suggest-widget.visible')`;
const rows = () => js(`[...document.querySelectorAll('.suggest-widget.visible .monaco-list-row .label-name')].map(e => e.textContent.trim())`);
// Puts `line` on a new last line of the Starter Code and the cursor after it, focused.
async function setLine(line) {
  await js(`(() => { const ed = ${EDITOR}; const m = ed.getModel(); const n = m.getLineCount();
    m.pushEditOperations([], [{ range: new monaco.Range(n, m.getLineMaxColumn(n), n, m.getLineMaxColumn(n)), text: '\\n' + ${JSON.stringify(line)} }], () => null);
    const last = m.getLineCount(); ed.setPosition({ lineNumber: last, column: m.getLineMaxColumn(last) }); ed.focus(); return true; })()`);
  await sleep(150);
}
const lastLine = () => js(`(() => { const m = (${EDITOR}).getModel(); return m.getLineContent(m.getLineCount()); })()`);
async function escape() { await press('Escape', 'Escape', 27); }
async function backspace(n) { for (let i = 0; i < n; i++) await press('Backspace', 'Backspace', 8); }

// English UI, so the screenshots read for every reviewer.
await c.send('Page.navigate', { url: `${VITE}/` });
await waitFor(`document.readyState === 'complete'`);
await js(`localStorage.setItem('i18nextLng', 'en')`);
await c.send('Page.navigate', { url: `${VITE}/problems/${SLUG}` });
check(await waitFor(`typeof monaco !== 'undefined' && monaco.editor.getEditors().length > 0 && !!document.querySelector('[data-tour="editor"] .monaco-editor')`, 30000), `editor loaded on /problems/${SLUG}`);
// The first-visit Tutorial banner and tips would sit over the editor; dismiss them as a user would.
await js(`document.querySelectorAll('[aria-label="Close"],[aria-label="닫기"]').forEach(b => b.click())`);

for (const cs of CASES) {
  const picked = await mouseClick(`document.querySelector('button[role="combobox"]')`)
    && await waitFor(`[...document.querySelectorAll('[role="option"]')].some(o => o.textContent.trim() === ${JSON.stringify(cs.label)})`, 5000)
    && await mouseClick(`[...document.querySelectorAll('[role="option"]')].find(o => o.textContent.trim() === ${JSON.stringify(cs.label)})`);
  await sleep(300);
  const lang = await js(`(${EDITOR}).getModel().getLanguageId()`);
  check(picked && lang === ({ Java: 'java', Python: 'python', JavaScript: 'javascript', 'C++': 'cpp' })[cs.label], `${cs.name}: editor language is ${lang}`);

  await setLine(cs.line);
  await type('.');
  const opened = await waitFor(suggestVisible, 8000);
  await sleep(400);
  check(opened, `${cs.name}: typing \`.\` after \`${cs.line}\` opens the suggestion list`);
  await shot(`${cs.name}-dot`);
  console.log(`     first rows: ${(await rows()).join(', ')}`);
  for (const name of cs.expect) {
    const prefix = name.slice(0, Math.min(name.length, 4));
    await type(prefix);
    await waitFor(suggestVisible, 3000);
    await sleep(250);
    const shown = await rows();
    check(shown.includes(name), `${cs.name}: \`${name}\` is suggested (after \`.${prefix}\`: ${shown.slice(0, 6).join(', ')})`);
    await backspace(prefix.length);
    await sleep(150);
  }
  await escape();

  // A call typed by hand, never accepting a suggestion, stays exactly as typed.
  await setLine(cs.line);
  await type('.' + cs.typed);
  await sleep(300);
  await escape();
  const typedLine = await lastLine();
  check(typedLine === cs.line + '.' + cs.typed, `${cs.name}: typed by hand, the line reads \`${typedLine}\``);

  if (cs.accept) {
    await setLine(cs.line);
    await type('.' + cs.accept.prefix);
    await waitFor(suggestVisible, 3000);
    await sleep(250);
    await press('Enter', 'Enter', 13);
    await sleep(200);
    await escape();
    const acceptedLine = await lastLine();
    check(acceptedLine === cs.line + '.' + cs.accept.result, `${cs.name}: accepting \`${cs.accept.result}\` gives \`${acceptedLine}\``);
  }
}

check(c.errors.length === 0, `no page errors${c.errors.length ? `: ${c.errors.join(' | ')}` : ''}`);
c.close();
process.exit(failures ? 1 : 0);
