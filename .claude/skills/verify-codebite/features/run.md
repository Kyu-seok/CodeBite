# Run

Run tries the editor's code on the problem's sample Test Cases through Judge0 and shows each case's status, input, expected and actual output in the Output tab. It needs no sign-in and saves nothing.

## Sub-features

- `run-pass` shows `N/N passed` and Accepted on every sample.
- `run-fail` stops at the first failing sample: its row is marked, with the status, the output and a Tip explaining that kind of failure.
- `run-custom` also runs the visitor's custom test cases once the samples pass. Not driven yet.
- `run-shortcut` runs on `⌘+'` (`Ctrl+'`). Not driven yet.

## How to get to it (user POV)

- On `/problems/<slug>`, write code in the editor and press `Run` under the Test Cases panel.
- Press `⌘+'` with focus in the workspace.

## Driving it with drive.mjs

Preconditions:

- The baseline in `README.md`, and Judge0 answering.
- No Run from this machine in the last 5 s.

- **Passing code.** Run `node .claude/skills/verify-codebite/drive.mjs run`. It opens `/problems/snack-drawer-pair` signed out, replaces the Starter Code with `scripts/replay-solutions/snack-drawer-pair.py` (click the editor, select all, paste), checks the editor holds it, clicks `[data-tour=run]` and waits for a status in `[data-tour=result]`. The result must say Accepted and `2/2 passed`. Screenshots: `1-code`, `2-result`.
- **Failing code.** Put a wrong solution in a file and run `node .claude/skills/verify-codebite/drive.mjs run --code <file> --expect "Wrong Answer"` (or `"Runtime Error"`, `"Compile Error"`, `"Time Limit Exceeded"`). The result must show that status and a row carrying `data-failed`.
- **Another problem.** Add `--slug <slug>`; without `--code` it needs `scripts/replay-solutions/<slug>.py`.

## Gotchas

- A failing Run reports `0/1 passed`, not `0/2`: grading stops at the first failing sample.
- A second Run within 5 s from the same IP is a 429, shown as an error, not a verdict. Leave 6 s between journeys.
- Typed code is auto-indented by Monaco and arrives mangled: the journey pastes.
- The reference solutions are the `Solution` class only, as the editor expects.
- On the Tutorial Problem (`piggy-bank-total`) the Spotlight decides which elements are usable at each step: don't use it for a plain Run.
