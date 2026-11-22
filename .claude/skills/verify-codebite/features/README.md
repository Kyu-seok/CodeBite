# CodeBite verification map

The maintained source for verifying what a CodeBite user sees. Read this index before driving the app, then use the matching feature file as the recipe. Launch, doctor and cleanup are in `../SKILL.md`.

## Baseline preconditions

- This worktree's branch servers are up: `scripts/dev-branch-servers.sh status` exits 0.
- `scripts/dev-status.sh` says Judge0 answers (Run and Submit need it; the list and the Walkthrough don't).
- The branch database holds every migrated problem and no users but the ones journeys made. Problem 1 is `snack-drawer-pair`; `two-sum` is its Former Slug and redirects to it.
- Never drive an instance this run didn't start: not `localhost:5173`, not the user's Chrome.

## Driving conventions

- Commands run from the worktree root and are literal.
- Each journey opens as a fresh visitor: empty localStorage, English, light theme, 1440px wide.
- A signed-in journey makes its own user (`verify<digits>`) with a dev test token. A new account's stored language is Korean and signing in applies it; the journey presses `EN` in the header, as a user would.
- Prefer `data-tour` handles and ARIA roles with their text over CSS classes or position.
- Nothing needs restoring between journeys: Run saves nothing, and each Submit belongs to a new user.

## Proof and skip reporting

- A proof is the journey's `report.txt` and screenshots (the directory its last line prints), for the entry point actually driven.
- Submit proof includes the API's list and the database row, which the journey reads itself.
- An entry point with no command below (a keyboard shortcut, the phone layout) is not verified by a journey that used another: say which were driven and which weren't.
- A failed check is reported with its line and `stopped.png`, never worked around by changing the check.

## Feature entry contract

Each feature file is an H1 title, one paragraph on what the user sees, then four H2 sections in this order: `Sub-features` (short IDs), `How to get to it (user POV)` (every entry point), `Driving it with drive.mjs` (or the script that drives it; `Preconditions:` first, then each user action with its command and what must be observed), `Gotchas`.

## Features

- [Problem list](./problem-list.md): the table at `/problems`, search, opening a problem.
- [Run](./run.md): running code against the sample Test Cases, signed out, passing and failing.
- [Submit](./submit.md): submitting signed in, the verdict, the stored submission, the confidence rating and the Submissions tab.
- [Walkthrough](./walkthrough.md): the Walkthrough tab and its player, by `scripts/walkthrough-app-check.mjs`.

## Not mapped yet

Profile (streak calendar, GitHub link), roadmap, reviews (Due list), Solutions (post, vote, comment), the Tutorial and its Spotlight, admin pages, `/dev/diagrams`, sign-in by OAuth, custom test cases, languages other than Python. A change to one of these needs a journey and a file here first.
