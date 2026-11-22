# Parallel sessions

Several sessions often run here at once, on one machine and one main checkout. Open the part for what you are about to do: start branch work, run tests, brief implementer subagents, commit, merge or ship.

## Worktrees
- Leave the main checkout on `master` and do all branch work in your own worktree: a `git switch` or commit in the shared checkout moves every other session's files.
- `git worktree add <scratchpad>/wt -b <branch> origin/master`, then `(cd <scratchpad>/wt/frontend && npm ci)` before any frontend check: a worktree has no `node_modules`, and the main checkout's may be stale.

## What trails `origin/master`
- The CLAUDE.md a session starts with is the main checkout's, which can trail `origin/master`: so can a skill loaded at session start. A SessionStart hook (`.claude/hooks/sync-main-checkout.sh`) fast-forwards a clean main checkout on `master` and prints one `main checkout:` line when it moved it or couldn't (it is silent when origin can't be reached). After `git worktree add`, run `git -C <worktree> diff $(git rev-parse HEAD) -- CLAUDE.md .claude/skills` from the main checkout and read what landed since, such as a newer script you would otherwise work around or a step of the skill you are following.
- Read and edit source only under the worktree path: the main checkout trails `origin/master` the same way, so a patch written from its text misses.

## Gradle and memory
- The machine has 8 GB, so one Gradle run goes at a time: run tests with `scripts/gradle-test.sh <gradle args>`, which waits for another worktree's run (the hooks and scripts use it too).
- One live set of branch servers at a time, for the same reason: an agent starts them with `scripts/dev-branch-servers.sh start --wait --detach`, which waits while another worktree's set is live (saying whose) and gives up after `CODEBITE_BRANCH_SERVERS_WAIT` seconds (default 1800) naming the set and the command that stops it. `stop` yours as soon as the check is done: another session may be waiting.
- In Claude Code's Bash, `grep` is the claude binary's ugrep, killed (exit 137) when memory runs low along with whatever pipes into it (a `migrate | grep` left a migration unapplied): write long output to a file and read it after, and use `/usr/bin/grep` in pipelines.

## Shared containers
The compose containers (`codebite-postgres`, `codebite-kafka`, `codebite-redis`) are shared between sessions, so they stay running. When a ticket step calls for a stopped one, simulate it: a fake `docker` on PATH, or a `DOCKER_HOST` that points nowhere.

## Implementer subagents
An orchestrator that runs implementers in parallel (one worktree and ticket branch each, merged by `scripts/merge-ticket.sh`) points their brief here and adds only the batch's own lines: the tickets, the integration branch, which ticket may start branch servers, and which ticket owns each shared file. Each implementer:
- Runs only the test package or class it touches (`scripts/gradle-test.sh :backend:test --tests 'com.codebite.<package>.*'`) and leaves the full suite to the merge gate: six full suites at once were killed for memory. Never `./gradlew --stop`, which stops every Gradle daemon on the machine, another worktree's run included, and never a `pgrep` wait of its own: `scripts/gradle-test.sh` already waits, and a `pgrep -f` pattern matches the shell that runs it, so the wait never ends.
- Commits with `CODEBITE_SKIP_TESTS=1 git commit`, which skips only the hook's Gradle tests, since the merge gate runs them. Never `--no-verify`: it also skips the commit-msg hook (Commits), and an over-long subject that reaches the merge takes a history rewrite. A commit that touches `scripts/` runs the script tests, which can pass two minutes: commit in the background.
- Starts branch servers only when the brief names its ticket, since one live set at a time fits in memory (Gradle and memory), and `stop`s and `drop`s them before it reports. `scripts/dev-branch-servers.sh migrate` starts no servers, so any implementer may run it; it runs Gradle without `scripts/gradle-test.sh`'s wait, so never alongside a test run of its own.
- Leaves every container it didn't start alone (Shared containers). Containers of its own come from a compose file of its own, under a project name of its own (`docker compose -p ticket<n> -f <its file>`) and with names and ports of its own: the compose files' default project (`infra`, or `codebite` in the production file) is the shared one and an `up` under it recreates the shared containers, and both files fix each `container_name`, so a second project on either fails on the name. It removes them, with their volumes and the images it built, before it reports.
- Keeps its scratch files in `<state directory>/scratch-<n>/`: two implementers given one scratch name overwrote each other's files.
- Only reads production (`gh run view … --log`) and runs nothing on the server: production serves real users.
- In Bash, `sed` is BSD, where `\b` silently matches nothing, so it edits with `perl -pi -e`; the shell is zsh, where an unquoted glob that matches nothing is an error; `python3` is 3.9 (`scripts/python312.sh` prints a 3.12); and pipelines use `/usr/bin/grep` (Gradle and memory).

## Commits
The pre-commit hook refuses commits on `master`, and the commit-msg hook a subject over 72 characters.

## Merging
- Merge with `scripts/ship-branch.sh <branch>…` from the main checkout: it stops on unticked `- [ ]` in the PR unless `--allow-unticked`, waits for CI, squash-merges, deletes the branch (remote, local, worktree, database). Its header says what it refuses and how it keeps itself current.
- After each merge into the integration branch of a batch with no spec issue (the body's first line says so), `scripts/integration-pr-body.sh <integration branch> <state directory> <ticket>...` rewrites the branch's PR body from the merge log and the tickets' notes (its header has both formats).
- A project hook refuses `gh pr merge --delete-branch`, which deletes live worktrees.
- Merge finished ticket branches into an integration branch with `scripts/merge-ticket.sh <branch> <title> [<branch> <title> ...]`, run from the integration worktree: one call merges them in order, runs the checks a clean merge skips and pushes only when green (its header has the details), so an orchestrator runs it directly and needs a subagent only for a conflict. A branch that reported one merge late (it lacks the integration tip) goes through `scripts/merge-ticket.sh --refresh <branch> <title>`, which merges the tip into it and runs the path-scoped checks itself: never merge the tip in by hand. When one of those checks fails, fix it in the ticket's worktree, commit, and run the same command again (it checks again, fixed or not).
