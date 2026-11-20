# Parallel sessions

Several sessions often run here at once, on one machine and one main checkout. Open the part for what you are about to do: start branch work, run tests, commit, merge or ship.

## Worktrees
- Leave the main checkout on `master` and do all branch work in your own worktree: a `git switch` or commit in the shared checkout moves every other session's files.
- `git worktree add <scratchpad>/wt -b <branch> origin/master`, then `(cd <scratchpad>/wt/frontend && npm ci)` before any frontend check: a worktree has no `node_modules`, and the main checkout's may be stale.

## What trails `origin/master`
- The CLAUDE.md a session starts with is the main checkout's, which can trail `origin/master`: so can a skill loaded at session start. After `git worktree add`, run `git -C <worktree> diff $(git rev-parse HEAD) -- CLAUDE.md .claude/skills` from the main checkout and read what landed since, such as a newer script you would otherwise work around or a step of the skill you are following.
- Read and edit source only under the worktree path: the main checkout trails `origin/master` the same way, so a patch written from its text misses.

## Gradle and memory
- The machine has 8 GB, so one Gradle run goes at a time: run tests with `scripts/gradle-test.sh <gradle args>`, which waits for another worktree's run (the hooks and scripts use it too).
- A parallel implementer runs the test package it touches (`--tests 'com.codebite.<package>.*'`) and leaves the full suite to the merge gate.
- In Claude Code's Bash, `grep` is the claude binary's ugrep, killed (exit 137) when memory runs low along with whatever pipes into it (a `migrate | grep` left a migration unapplied): write long output to a file and read it after, and use `/usr/bin/grep` in pipelines.

## Shared containers
The compose containers (`codebite-postgres`, `codebite-kafka`, `codebite-redis`) are shared between sessions, so they stay running. When a ticket step calls for a stopped one, simulate it: a fake `docker` on PATH, or a `DOCKER_HOST` that points nowhere.

## Commits
The pre-commit hook refuses commits on `master`, and the commit-msg hook a subject over 72 characters.

## Merging
- Merge with `scripts/ship-branch.sh <branch>…` from the main checkout: it stops on unticked `- [ ]` in the PR unless `--allow-unticked`, waits for CI, squash-merges, deletes the branch (remote, local, worktree, database).
- A project hook refuses `gh pr merge --delete-branch`, which deletes live worktrees.
- Merge finished ticket branches into an integration branch with `scripts/merge-ticket.sh <branch> <title> [<branch> <title> ...]`, run from the integration worktree: one call merges them in order, runs the checks a clean merge skips and pushes only when green (its header has the details), so an orchestrator runs it directly and needs a subagent only for a conflict.
