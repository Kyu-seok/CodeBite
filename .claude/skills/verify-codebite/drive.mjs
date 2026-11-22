#!/usr/bin/env node
// Drives one user journey through this checkout's branch servers in headless Chrome and leaves the proof
// (a line per check in report.txt, screenshots) in a directory outside the worktree:
//   node .claude/skills/verify-codebite/drive.mjs <problem-list|run|submit> [--slug <slug>] [--code <file>]
//        [--expect <status>] [--out <dir>]
// --slug    the problem (default snack-drawer-pair, problem 1)
// --code    the Python to paste into the editor (default scripts/replay-solutions/<slug>.py, the reference solution)
// --expect  the status the result must show (default Accepted; "Wrong Answer", "Runtime Error", … for a failing --code)
// --out     the evidence directory (default $CODEBITE_VERIFY_OUT or ~/.cache/codebite-verify, then <branch>/<journey>-<time>)
// The servers are the ones `scripts/dev-branch-servers.sh status` names for this checkout; nothing else is driven.
// Exits 0 when every check held, 1 on a failed check or a console error, 2 on bad arguments or servers not up.
import { execFileSync } from 'node:child_process';
import { existsSync, readFileSync } from 'node:fs';
import { homedir } from 'node:os';
import { join } from 'node:path';
import { branchServers, openBrowser, Stopped } from './browser.mjs';

const USAGE = 'usage: drive.mjs <problem-list|run|submit> [--slug <slug>] [--code <file>] [--expect <status>] [--out <dir>]';
const [journey, ...rest] = process.argv.slice(2);
const opt = {};
for (let i = 0; i < rest.length; i += 2) {
  if (!/^--(slug|code|expect|out)$/.test(rest[i]) || rest[i + 1] === undefined) { console.error(USAGE); process.exit(2); }
  opt[rest[i].slice(2)] = rest[i + 1];
}
const JOURNEYS = { 'problem-list': problemList, run, submit };
if (!JOURNEYS[journey]) { console.error(USAGE); process.exit(2); }

const root = execFileSync('git', ['rev-parse', '--show-toplevel']).toString().trim();
const branch = execFileSync('git', ['-C', root, 'branch', '--show-current']).toString().trim() || 'detached';
let servers;
try { servers = branchServers(root); } catch (e) { console.error(e.message); process.exit(2); }

const slug = opt.slug ?? 'snack-drawer-pair';
const expect = opt.expect ?? 'Accepted';
const stamp = new Date().toISOString().replace(/[-:]/g, '').slice(0, 15);
const out = opt.out ?? join(process.env.CODEBITE_VERIFY_OUT || join(homedir(), '.cache/codebite-verify'), branch.replace(/[^\w.-]+/g, '_'), `${journey}-${stamp}`);

// What the Output panel shows, without the Run and Submit buttons under it.
const RESULT = `document.querySelector('[data-tour=result]')`;
const STATUSES = ['Accepted', 'Wrong Answer', 'Runtime Error', 'Compile Error', 'Time Limit Exceeded', 'Memory Limit Exceeded', 'Internal Error'];

function code() {
  const file = opt.code ?? join(root, 'scripts/replay-solutions', `${slug}.py`);
  if (!existsSync(file)) throw new Error(`no code to paste: ${file} (pass --code <file>)`);
  return readFileSync(file, 'utf8');
}

// Opens the workspace and replaces the editor's Starter Code with `source`, as a visitor who selects all and pastes.
async function openWorkspaceWith(source, jwt) {
  await b.open(`/problems/${slug}`, { jwt });
  await b.shown('the workspace (Run button and editor)', `!!document.querySelector('[data-tour=run]') && !!document.querySelector('.monaco-editor .view-lines')`);
  // A new account's stored language is Korean, and signing in applies it over the visitor's: switch back as a user would.
  const en = `[...document.querySelectorAll('header button')].find(e => e.textContent.trim() === 'EN')`;
  if (jwt && await b.waitFor(`!!${en}`, 5000)) { await b.js(`${en}.click()`); b.say('     signed in, the page turned Korean: pressed EN in the header'); }
  await b.shown('the English workspace', `!!document.querySelector('button[aria-label="Languages"]')`, { seen: `document.querySelector('[role=tab]')?.textContent` });
  const language = await b.js(`document.querySelector('button[aria-label="Languages"]')?.textContent.trim()`);
  b.check(language === 'Python', `editor opens on Python for a fresh visitor (${language})`);
  await b.click('.monaco-editor .view-lines');
  await b.key('a', 'KeyA', 65, { modifiers: 4, commands: ['selectAll'] });
  await b.paste(source);
  const typed = await b.waitFor(`window.monaco.editor.getModels()[0].getValue() === ${JSON.stringify(source)}`, 5000);
  b.check(typed, `the editor holds the pasted code (${source.split('\n').length} lines)`);
  await b.shot('1-code');
}

// Waits for a verdict in the Output panel and checks it against --expect. Returns the panel's text.
async function verdict(action, ms) {
  await b.shown(`a result after ${action}`, `${JSON.stringify(STATUSES)}.some(s => ${RESULT}.innerText.includes(s))`, { ms, seen: `${RESULT}.innerText.slice(0, 200)` });
  const text = await b.js(`${RESULT}.innerText`);
  b.say(text.split('\n').filter(l => l.trim()).map(l => '     | ' + l).join('\n'));
  b.check(text.includes(expect), `${action} shows ${expect}`);
  return text;
}

async function run() {
  await openWorkspaceWith(code(), null);
  b.check(await b.click('[data-tour=run]'), 'Run pressed');
  const text = await verdict('Run', 90000);
  const passed = text.match(/(\d+)\/(\d+) passed/);
  b.check(!!passed, `the result counts the sample cases (${passed?.[0]})`);
  if (expect === 'Accepted' && passed) b.check(passed[1] === passed[2], `every sample passed (${passed[0]})`);
  else b.check(await b.js(`!!${RESULT}.querySelector('[data-failed]')`), 'a failing sample row is marked');
  await b.shot('2-result');
}

// One read-only query against the branch database (scripts/db-sql.sh), its rows tab-separated.
function sql(query) {
  return execFileSync(join(root, 'scripts/db-sql.sh'), [query], { cwd: root, env: { ...process.env, CODEBITE_DB: servers.database } }).toString().trim();
}

async function submit() {
  const user = `verify${Date.now() % 100000}`;
  const jwt = await b.token(user);
  await openWorkspaceWith(code(), jwt);
  b.check(await b.click('[data-tour=submit]'), `Submit pressed as ${user}`);
  await verdict('Submit', 120000);
  await b.shot('2-verdict');

  // The same submission from two views that don't share the page's state: the API's list and the database row.
  const res = await fetch(`${servers.api}/problems/${slug}/submissions`, { headers: { Authorization: `Bearer ${jwt}` } });
  const body = await res.json();
  const listed = body.content ?? body;
  const want = expect.toUpperCase().replaceAll(' ', '_');
  b.check(listed.length === 1 && listed[0].status === want, `GET /problems/${slug}/submissions lists one, ${listed[0]?.status}`);
  const row = () => sql(`select s.id, s.status, s.language, coalesce(s.confidence, 'unrated'), count(r.id) from submissions s join users u on u.id = s.user_id
    left join submission_results r on r.submission_id = s.id where u.username = '${user}' group by s.id`);
  const rows = row();
  b.say('     | submissions row (id, status, language, confidence, result rows): ' + rows.replaceAll('\t', ', '));
  const [, status, , , results] = rows.split('\t');
  b.check(rows.split('\n').length === 1 && status === want && +results > 0, `the database holds one ${status} submission with ${results} result rows`);

  // An Accepted submission opens a dialog over the page asking how confident the solve felt: rate it, as its
  // first Review. (A click anywhere else would only close the dialog.)
  if (expect === 'Accepted') {
    await b.shown('the Accepted dialog with its rating', `!!document.querySelector('[role=dialog] [role=radio]')`);
    await b.shot('3-rating-dialog');
    b.check(await b.click('[role=dialog] [role=radio][aria-labelledby$="-name-GOOD"]'), 'Good picked in the Accepted dialog');
    let rated = '';
    for (let i = 0; i < 40 && rated !== 'GOOD'; i++) { await new Promise(r => setTimeout(r, 250)); rated = row().split('\t')[3]; }
    b.check(rated === 'GOOD', `the database holds the rating (${rated})`);
    const due = sql(`select count(*) from problem_review_state st join users u on u.id = st.user_id where u.username = '${user}'`);
    b.check(due === '1', `the rating started the problem's review schedule (${due} problem_review_state row)`);
    if (await b.js(`!!document.querySelector('[role=dialog]')`)) await b.key('Escape', 'Escape', 27);
    await b.shown('the page without the dialog', `!document.querySelector('[role=dialog]')`);
  }

  // And where a user finds it later: the Submissions tab.
  await b.click('[role=tab]', 'Submissions');
  await b.shown('the Submissions tab, selected', `[...document.querySelectorAll('[role=tab][aria-selected=true]')].some(e => e.textContent.includes('Submissions'))`);
  await b.shown('the submission in the Submissions tab', `!!document.querySelector('[aria-label^=${JSON.stringify(expect)}]')`);
  b.check(true, `the Submissions tab lists it as ${expect}`);
  await b.shot('4-submissions-tab');
}

async function problemList() {
  const titles = `[...document.querySelectorAll('tbody a[href^="/problems/"]')].map(a => a.textContent.trim())`;
  await b.open('/problems');
  await b.shown('the problem table', `${titles}.length > 0`);
  const first = (await (await fetch(`${servers.api}/problems?size=5`)).json()).content.find(p => !p.tutorial);
  const all = await b.js(`${titles}.length`);
  b.check((await b.js(`${titles}[0]`)) === first.title, `the list starts at problem ${first.problemNumber}, ${first.title} (${all} rows)`);
  await b.shot('1-list');

  const term = first.title.split(' ')[0];
  await b.click('input[aria-label="Search problems"]');
  await b.insert(term);
  await b.shown(`rows narrowed to "${term}"`, `${titles}.length > 0 && ${titles}.length < ${all} && ${titles}.every(t => t.toLowerCase().includes(${JSON.stringify(term.toLowerCase())}))`,
    { seen: `${titles}.slice(0, 5).join(' | ')` });
  b.check(true, `searching "${term}" leaves ${await b.js(`${titles}.length`)} rows, each naming it`);
  await b.shot('2-search');

  b.check(await b.click('tbody a[href^="/problems/"]', first.title), `${first.title} clicked`);
  await b.shown('the workspace', `location.pathname === ${JSON.stringify('/problems/' + first.slug)} && !!document.querySelector('[data-tour=run]')`, { seen: 'location.pathname' });
  b.check((await b.js('document.title')).startsWith(first.title), `the workspace opens at /problems/${first.slug} (${await b.js('document.title')})`);
  await b.shot('3-workspace');
}

const b = await openBrowser({ ...servers, out });
b.say(`${journey} on ${branch} @ ${execFileSync('git', ['-C', root, 'rev-parse', '--short', 'HEAD']).toString().trim()}: ${servers.vite}, database ${servers.database}`);
try { await JOURNEYS[journey](); }
catch (e) {
  b.check(false, e instanceof Stopped ? e.message : `stopped at an error: ${e.message}`);
  await b.shot('stopped').catch(() => {});
}
process.exit(await b.finish());
