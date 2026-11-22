# Parallel sessions

Several sessions often run here at once, on one machine and one main checkout. Open the part for what you are about to do: start branch work, run tests, commit, merge or ship.

## Worktrees
- Leave the main checkout on `master` and do all branch work in your own worktree: a `git switch` or commit in the shared checkout moves every other session's files.
- `git worktree add <scratchpad>/wt -b <branch> origin/master`, then `(cd <scratchpad>/wt/frontend && npm ci)` before any frontend check: a worktree has no `node_modules`, and the main checkout's may be stale.

## What trails `origin/master`
- The CLAUDE.md a session starts with is the main checkout's, which can trail `origin/master`: so can a skill loaded at session start. A SessionStart hook (`.claude/hooks/sync-main-checkout.sh`) fast-forwards a clean main checkout on `master` and prints one `main checkout:` line when it moved it or couldn't (it is silent when origin can't be reached). After `git worktree add`, run `git -C <worktree> diff $(git rev-parse HEAD) -- CLAUDE.md .claude/skills` from the main checkout and read what landed since, such as a newer script you would otherwise work around or a step of the skill you are following.
- Read and edit source only under the worktree path: the main checkout trails `origin/master` the same way, so a patch written from its text misses.

## Gradle and memory
- The machine has 8 GB, so one Gradle run goes at a time: run tests with `scripts/gradle-test.sh <gradle args>`, which waits for another worktree's run (the hooks and scripts use it too).
- One live set of branch servers at a time, for the same reason: an agent starts them with `scripts/dev-branch-servers.sh start --wait --detach`, which waits while another worktree's set is live (saying whose) and gives up after `CODEBITE_BRANCH_SERVERS_WAIT` seconds (default 1800) naming the set and the command that stops it. `stop` yours as soon as the check is done: another session may be waiting.
- A parallel implementer runs the test package it touches (`--tests 'com.codebite.<package>.*'`) and leaves the full suite to the merge gate.
- In Claude Code's Bash, `grep` is the claude binary's ugrep, killed (exit 137) when memory runs low along with whatever pipes into it (a `migrate | grep` left a migration unapplied): write long output to a file and read it after, and use `/usr/bin/grep` in pipelines.

## Shared containers
The compose containers (`codebite-postgres`, `codebite-kafka`, `codebite-redis`) are shared between sessions, so they stay running. When a ticket step calls for a stopped one, simulate it: a fake `docker` on PATH, or a `DOCKER_HOST` that points nowhere.

## Commits
The pre-commit hook refuses commits on `master`, and the commit-msg hook a subject over 72 characters.

## Merging
- Merge with `scripts/ship-branch.sh <branch>…` from the main checkout: it stops on unticked `- [ ]` in the PR unless `--allow-unticked`, waits for CI, squash-merges, deletes the branch (remote, local, worktree, database). Its header says what it refuses and how it keeps itself current.
- A project hook refuses `gh pr merge --delete-branch`, which deletes live worktrees.
- Merge finished ticket branches into an integration branch with `scripts/merge-ticket.sh <branch> <title> [<branch> <title> ...]`, run from the integration worktree: one call merges them in order, runs the checks a clean merge skips and pushes only when green (its header has the details), so an orchestrator runs it directly and needs a subagent only for a conflict. A branch that reported one merge late (it lacks the integration tip) goes through `scripts/merge-ticket.sh --refresh <branch> <title>`, which merges the tip into it and runs the path-scoped checks itself: never merge the tip in by hand. When one of those checks fails, fix it in the ticket's worktree, commit, and run the same command again (it checks again, fixed or not).
