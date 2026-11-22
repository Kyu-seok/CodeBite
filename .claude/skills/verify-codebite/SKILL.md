---
name: verify-codebite
description: Drive the real CodeBite web app (React frontend, Spring backend, worker, Judge0) from a worktree's own branch servers in headless Chrome and capture proof that a behavior works: screenshots, a line per check, the API's answer and the database row. Use when a change must be shown working for a user, not only in tests: a bug to reproduce, a feature or fix to prove before a PR, a UI change to look at.
---

# Verify CodeBite

CodeBite's surface is the web app: the problem list, the problem workspace (description, editor, Run, Submit), then profile, roadmap, reviews and admin pages. This skill starts this worktree's own copy of it, drives it as a user would and leaves proof outside the worktree. The REST API under `/api` is the second surface: `scripts/judge-run.sh <slug>` sends reference solutions to the Run endpoint, and anything else is `curl` against the backend URL below.

What to drive for each feature is the feature map, `features/README.md` beside this file. Read it before driving: a proof through one entry point doesn't cover the others it lists.

## Launch

From your worktree (the script refuses the main checkout, whose servers are the user's):

```bash
scripts/dev-branch-servers.sh start --wait --detach
```

It starts this checkout's backend, worker and Vite on free ports (from 18080, 18180, 15180) with a database, Kafka topics and Redis index of their own, runs every migration (the problems are migrations, so an empty database comes up with all of them) and returns once all three answer, printing the URLs. `--wait` waits while another worktree's servers are live: the machine runs one set at a time. First start in a worktree runs `npm ci` and a Gradle build, several minutes.

Ready is the printed summary (`Branch servers for <branch>:`) and exit 0. After a new migration or a backend change: `scripts/dev-branch-servers.sh restart` (bootRun doesn't reload; Vite does).

## Doctor

```bash
scripts/dev-branch-servers.sh status   # exit 0 and the URLs only when each port is this checkout's process
scripts/dev-status.sh                  # the `judge0:` line must say it answers, or every Run and Submit fails
```

Run both first whenever something looks off (a 403, old behavior, a button that does nothing). `drive.mjs` reads its URLs from `status` and exits 2 with status's own words when the servers aren't up, so it can't drive another checkout's app.

## Drive

`drive.mjs` runs one journey in headless Chrome over CDP (a profile of its own; Node 22+, no npm install):

```bash
node .claude/skills/verify-codebite/drive.mjs problem-list
node .claude/skills/verify-codebite/drive.mjs run    [--slug <slug>] [--code <file>] [--expect "Wrong Answer"]
node .claude/skills/verify-codebite/drive.mjs submit [--slug <slug>] [--code <file>] [--expect <status>]
node scripts/walkthrough-app-check.mjs <frontend url> <backend url ending /api> <out dir> <slug>   # the Walkthrough tab
```

- `--slug` defaults to `snack-drawer-pair` (problem 1). `--code` is the Python pasted into the editor, by default the reference solution `scripts/replay-solutions/<slug>.py`. `--expect` is the status the result must show, by default `Accepted`.
- Exit 0 when every check held, 1 on a failed check or a browser console error, 2 on bad arguments or servers not up.

A journey the three don't cover is a new function in `drive.mjs` (add it to `JOURNEYS`) built from `browser.mjs`, whose comments say what each call does: `open(path, { width, theme, lang, jwt })` (a fresh visitor; `width: 390` for a phone), `token(username, role)` (a dev test token, `ADMIN` for admin pages), `click(selector, text)` (a real mouse click), `paste`, `insert`, `key`, `shown` (wait or stop the journey), `check`, `shot`, `js`. Add the journey to the feature map in the same change.

Handles that hold still, in the order to prefer them:

- `data-tour` on the workspace: `description`, `editor`, `result` (the Test Cases and Output panel), `run`, `submit`, `failedRow`; a failing result row also carries `data-failed`.
- ARIA: `[role=tab]` by its text (Description, Submissions, Solutions, Walkthrough, Test Cases, Output), `[role=dialog]`, `button[aria-label="Languages"]`, `input[aria-label="Search problems"]`; a Submissions row is a button whose `aria-label` starts with its status.
- Routes: the table in `docs/agents/frontend.md`. Strings: `frontend/src/locales/en/`.
- The editor is Monaco: click `.monaco-editor .view-lines`, select all, `paste` (typed text gets auto-indented). Read it back with `window.monaco.editor.getModels()[0].getValue()`.

Never drive `localhost:5173`, `localhost:8080` or the user's Chrome tabs: those hold their real session and drafts.

## Evidence

Each run writes to `$CODEBITE_VERIFY_OUT` or `~/.cache/codebite-verify`, then `<branch>/<journey>-<UTC time>/` (`--out <dir>` names another): `report.txt` (the commit, the servers, a line per check, the result panel's text) and numbered screenshots of the action and the state after it. The last line printed is the directory. A screenshot for a PR goes on the `pr-assets` branch, linked by commit SHA.

What counts as proof here:

- The user's path: the page, the editor, the buttons. Not a setter, not `POST /api/…` standing in for a click (the test token is the one exception: OAuth can't run headless).
- The action and the state after it: the code in the editor, then the verdict.
- The side effect from a view that doesn't share the page's state: `GET /api/…` with the user's token, and the row, `CODEBITE_DB=<database from status> scripts/db-sql.sh "<sql>"`. Run persists nothing; Submit writes `submissions` and one `submission_results` row per Test Case.
- Judge0 is real (the dev box `dev-status.sh` names), never mocked. GitHub (Solution Commits) is the only boundary a local run can't reach without the dev GitHub App.
- A journey that fails is a finding. Report the failed check and its `stopped.png`; don't loosen the check.

## Cleanup

```bash
scripts/dev-branch-servers.sh stop   # as soon as the check is done: another session may be waiting for the slot
scripts/dev-branch-servers.sh drop   # when the branch is finished: its database (test users, submissions), topics, Redis index
```

`stop` ends only the processes this checkout started; `drive.mjs` closes the Chrome it started, on any exit. Neither touches the evidence directory, which is outside the worktree so that removing the worktree leaves it too.

## Limits

- One set of branch servers per machine, so one agent drives at a time; a second `start --wait` queues.
- Run answers 429 within 5 s of the same IP's last Run, Submit within 10 s of the same user's last (each `submit` journey makes a new user). Leave 6 s between `run` journeys.
- Only Python is driven. Another language is the `Languages` button, not scripted yet.
