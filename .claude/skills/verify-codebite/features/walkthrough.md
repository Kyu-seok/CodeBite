# Walkthrough

A problem that has a Walkthrough shows a Walkthrough tab beside Description. Behind a reveal button, a player steps through one approach on each example: a visitor moves with the buttons or the arrow keys and switches between runs. A problem without one shows no tab.

## Sub-features

- `wt-tab` shows the tab only on problems with a Walkthrough, fully visible at 1440 and 390px.
- `wt-reveal` keeps the player hidden until the reveal button is pressed.
- `wt-step` steps with the arrow keys, Home and End while the player has focus, and not from the editor.
- `wt-place` keeps the run and step across a tab switch and a theme toggle.
- `wt-locale` follows the page's language and theme, signed out and signed in.

## How to get to it (user POV)

- On `/problems/<slug>`, choose the `Walkthrough` tab, then `Show how it's solved`.
- With the left panel folded, choose Walkthrough from the strip.

## Driving it with walkthrough-app-check.mjs

Preconditions:

- The baseline in `README.md`. Judge0 isn't needed.
- The slug has `common/src/main/resources/walkthroughs/<slug>.json`.

- **All sub-features.** Run `node scripts/walkthrough-app-check.mjs <frontend url> <backend url ending /api> <out dir> <slug>`, with the URLs `scripts/dev-branch-servers.sh status` prints and an out dir under `~/.cache/codebite-verify/<branch>/`. It makes four passes (signed out and in, 1440 and 390px, both themes and languages), prints a line per check and each screenshot's path, and exits 1 on a failed check or console error. The script's header lists every check.

## Gotchas

- This script takes its URLs and out dir as arguments and writes no `report.txt`: keep its stdout with the screenshots (`… | tee <out dir>/report.txt`).
- The folded-strip entry point is reported as `info`, never failed: headless, folding leaves the panel drawn at 55px. It is not verified.
- Adding or regenerating a Walkthrough has its own checks: `.claude/skills/add-walkthrough/SKILL.md`.
