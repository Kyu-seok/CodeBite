# Submit

Submit judges the editor's code against every Test Case, hidden ones included, and saves the result to the user's history. The verdict shows in the Output tab; an Accepted one opens a dialog asking how confident the solve felt, and that rating starts the problem's review schedule. Submit needs a signed-in user.

## Sub-features

- `submit-verdict` shows the status, `N/N passed`, runtime and memory in the Output tab once the worker has judged it.
- `submit-stored` saves the submission: the API lists it and the database holds it with one result row per Test Case.
- `submit-rate` rates an Accepted submission in the dialog; the rating is stored and a review-state row appears.
- `submit-history` lists it in the Submissions tab.
- `submit-fail` shows a failing verdict with its first failing case. Driven by `--expect`, with no dialog.
- `submit-signed-out` sends a signed-out visitor to sign in and back with their code. Not driven yet.
- `submit-detail` opens a past submission from the Submissions tab. Not driven yet.

## How to get to it (user POV)

- Signed in on `/problems/<slug>`, press `Submit` under the Test Cases panel.
- Press `⌘+↵` (`Ctrl+Enter`) with focus in the workspace.

## Driving it with drive.mjs

Preconditions:

- The baseline in `README.md`, and Judge0 answering.
- The worker is up (`status` checks it): the verdict comes from it over Kafka.

- **Accepted, rated, listed.** Run `node .claude/skills/verify-codebite/drive.mjs submit`. It makes a user, opens `/problems/snack-drawer-pair` signed in, presses `EN` when the page turns Korean, pastes the reference solution and clicks `[data-tour=submit]`. Then, in order: the Output tab must show Accepted (`10/10 passed`); `GET /api/problems/<slug>/submissions` with the user's token must list one `ACCEPTED`; the `submissions` row must be `ACCEPTED` with result rows; the dialog (`[role=dialog]`) must show its rating radios; after clicking Good the row's `confidence` must be `GOOD` and `problem_review_state` must hold one row for the user; with the dialog closed, the Submissions tab must list a row whose label starts `Accepted`. Screenshots: `1-code`, `2-verdict`, `3-rating-dialog`, `4-submissions-tab`.
- **A failing verdict.** Run `node .claude/skills/verify-codebite/drive.mjs submit --code <file> --expect "Wrong Answer"`. The same checks with that status, and no dialog step.

## Gotchas

- The Accepted dialog covers the page a moment after the verdict. A click anywhere else lands on its overlay and only closes it: rate or dismiss it before touching a tab.
- A new account's language is Korean, and signing in overrides the visitor's English. Selectors by English text fail until `EN` is pressed.
- The verdict arrives over SSE, with polling as the fallback: wait for the status text, up to 2 minutes on a cold Judge0.
- A second Submit by the same user within 10 s is a 429. Each journey makes its own user, so journeys don't collide.
- The test users and their submissions stay in the branch database until `scripts/dev-branch-servers.sh drop`.
- An Accepted verdict in the page alone is not proof of `submit-stored`: the journey's API and database lines are.
