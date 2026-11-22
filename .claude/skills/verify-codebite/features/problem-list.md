# Problem list

The table at `/problems` lists every published problem by number with its difficulty and tags; a visitor narrows it by search, Curation or tag and opens a problem's workspace from its title. No sign-in needed.

## Sub-features

- `list-load` shows the table, starting at problem 1 (the Tutorial Problem, number 0, is not a row).
- `list-search` narrows the rows to titles matching the search box.
- `list-open` opens `/problems/<slug>` from a row's title.
- `list-filters` narrows by Curation and by tag. Not driven yet.
- `list-status` marks Solved and Attempted rows for a signed-in user. Not driven yet.

## How to get to it (user POV)

- Open `/` (it redirects to `/problems`) or choose `Problems` in the header.
- Type in the `Search problems` box.
- Click a problem's title.

## Driving it with drive.mjs

Preconditions:

- The baseline in `README.md`. Judge0 isn't needed.

- **Load, search, open.** Run `node .claude/skills/verify-codebite/drive.mjs problem-list`. It opens `/problems`, checks the first row's title against the API's problem 1, types that title's first word into `input[aria-label="Search problems"]`, waits until fewer rows remain and each names the word, clicks the title and checks the workspace opened at `/problems/<slug>` with that title. Screenshots: `1-list`, `2-search`, `3-workspace`.

## Gotchas

- The rows change a moment after typing: wait for them to narrow, don't read them right away.
- The row count before searching is one page (100), not the number of problems.
- `list-filters` and `list-status` have no journey: a change to them isn't verified by this one.
