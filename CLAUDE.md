# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**CodeBite** — a code practice platform. The repository is a **Gradle multi-module project** with the following top-level directories:

- `backend/` — Spring Boot 3.2.5 REST API (Java 17, Gradle 8.5)
- `common/` — Shared Java library (JPA entities, repositories, Judge0 client/service)
- `worker/` — Kafka consumer that processes submissions against Judge0
- `frontend/` — React SPA (Vite + TypeScript + Tailwind CSS)
- `infra/` — Docker Compose (PostgreSQL 15, Redis 7, Kafka 3.7, Nginx LB)
- `docs/` — project documentation

### Gradle Multi-Module Structure

Root `settings.gradle` includes three modules: `common`, `backend`, `worker`. The Gradle wrapper (`gradlew`) lives at the project root.

- **`common`** — Plain Java library (no Spring Boot plugin). Contains: JPA entities, Spring Data repositories, Judge0 client/service, Flyway migrations, driver templates, base classes, and shared exceptions.
- **`backend`** — Spring Boot web app. Depends on `common`. Contains: REST controllers, services, DTOs, security/auth, Redis caching, Kafka producer.
- **`worker`** — Spring Boot app (no web server). Depends on `common`. Contains: Kafka consumer that processes submissions via Judge0.

## Common Module

### Layout and gotchas
`docs/agents/common.md` lists which package and resource directory holds what; open it to place a class or find one. What an `ls` won't tell you:
- Every slug lookup is `ProblemRepository.findBySlugOrFormerSlug` and `isSlugTaken` checks both: a Restatement leaves a FormerSlug behind, so old links still resolve.
- A Curation numbers its subset 1 to N, so the Tutorial Problem, number 0, is in none (docs/adr/0007).
- `review/schedule/ReviewSchedule` is the only place the SM-2 numbers live (`review-schedule-golden.csv` in test resources pins them); `ProblemReviewState` is a stored snapshot of it, getters only.
- `judge/grader/Grader` is the only place Judge0 statuses become SubmissionStatuses (docs/adr/0005): `grade` runs every case in one Judge0 batch, `gradeUntilFailure` runs them one at a time and stops at the first failing judged case.
- `Language.ofRequest` is the 400 for a code CodeBite doesn't accept.
- `ProblemAssets` is backend only: it reads every Driver, Library and Starter Code once at startup and fails on a Driver without `{USER_CODE}`; only `Program` picks and calls the per-Language `JudgeErrorParser`s.
- Progress reads (Solved, Attempted) live in the backend's `progress/`, not in `SubmissionRepository`.
- A Flyway version is taken if it is in either `db/migration/` (SQL) or `common/src/main/java/db/migration` (Java).
- `GitHubLinkRepository.findCurrentByUserId` is the user's current link, ACTIVE or BROKEN; UNLINKED rows stay.

### Reading a problem
`scripts/problem-text.sh <slug> [--all]` prints a problem as it stands (English and Korean text, sample Test Cases, or every case by `order_index` with `--all`) from the local database, or a branch's with `CODEBITE_DB=<database>`; it refuses a database missing this checkout's migrations, which would show a problem as it was (`CODEBITE_ALLOW_STALE=1` reads it anyway). Anything beyond one problem (a fact across problems, a count, the largest case) is `scripts/db-sql.sh "<sql>"`, the same connection, refusal and `CODEBITE_DB`. Migrations are the slow way: the newest one that sets a column wins, and the first grep match is usually stale.

### Judging a problem locally
`scripts/judge-local.sh <slug> [--languages java,cpp,…] [--cases cases.json]` judges a problem's Test Cases (from the local database, a branch's with `CODEBITE_DB=<database>`, or a JSON list of `{input, expected_output}` not in a migration yet) without Judge0: each Language's reference solution, `scripts/replay-solutions/<slug>.<py|java|js|cpp>` (the `Solution` class only; most problems have only a Python one, so the others report `NOT JUDGED`), goes into the Driver and runs on the local `python3.12`, `javac`/`java`, `node` and `g++`, compared trimmed as the Grader does. Exits 1 on a failing case and 2 when a compiler, interpreter or reference solution is missing (`NOT JUDGED`, never a failed case). Java builds with `--release 13` and C++ with `-std=gnu++14` like Judge0; local `node` is newer than Judge0's Node 12. `scripts/replay-local.sh` replays every problem's Python instead.

### Pointers in documents
`scripts/check-doc-references.py` (pre-commit and CI) fails when CLAUDE.md, a skill, an agent or `docs/agents/` names a repo path that doesn't exist, or anything cites a glossary term (`… (GLOSSARY.md)`) the glossary lacks: the usual cause is a branch citing what another unmerged branch adds.

### Restating a problem
Rewording a problem while its Test Cases stay (Slug, title, description, Starter Code names) is a Restatement: follow `.claude/skills/restate-problem/SKILL.md`. `ProblemSlugsTest` (backend) runs every migration and fails when a Slug and its `drivers/`/`starters/` directories disagree; `MigrationSlugReferencesTest` fails when a migration's `slug = …` names a slug that doesn't exist when it runs. `StatementsMatchTestCasesTest`'s exemption sets (its class comment lists them) are the known statement defects: a fix removes its slug, and the test fails on a listed slug that passes; every run writes one report per check, each problem's mismatch lines with listed ones marked, under `backend/build/reports/statements/`.

### Correcting a problem's Test Cases
`.claude/skills/correct-test-cases/SKILL.md`. `ProblemGuaranteesTest` and `TestCasePositionsTest` (backend) check every migrated case; tests that read migrated rows use `MigratedDatabase`, since H2 keeps `E'…\n…'` escapes as a backslash and an `n`.

### Diagrams
Diagrams are ` ```diagram-* ` blocks in a description, drawn by `frontend/src/components/markdown/diagrams/`; the kinds and their keys are in `docs/PROBLEM_DIAGRAMS_ROADMAP.md`. To add one, follow `.claude/skills/add-diagram/SKILL.md`. To look at them all, `/dev/diagrams` (Vite dev mode only, ADMIN session) draws every problem's Diagrams on one page at 360, 640 or 900px, published or not, flagging a directive that doesn't parse; the decisions behind it are the pure `frontend/src/pages/dev/diagramGallery.ts`.

## Backend

### Tech Stack
- Java 17, Spring Boot 3.2.5, Gradle 8.5 (wrapper)
- Spring Security (stateless JWT auth, OAuth via Google/GitHub)
- Spring Data JPA + Flyway migrations
- PostgreSQL 15 (dev/prod), H2 in PostgreSQL mode (tests)
- Redis 7 (JWT token blacklist, user profile cache)
- Spring Kafka (submission event producer)
- Spring Boot Actuator + Micrometer Prometheus (metrics)
- jjwt 0.12.5 for JWT token handling

### Common Commands
```bash
./gradlew :backend:compileJava     # compile backend
./gradlew :backend:test            # run backend tests (uses H2, no Docker needed)
scripts/test-failures.sh backend [--run]  # a failing run's tests and messages only, no traces (also common, worker)
source scripts/dev-env.sh && SPRING_PROFILES_ACTIVE=dev ./gradlew :backend:bootRun  # run locally
```
`scripts/dev-env.sh` loads only the OAuth and GitHub App values from `infra/.env` (from a worktree, the main checkout's). That file is the production server's config: sourcing it whole overrides the dev CORS origins, JWT secret, database and Judge0 URL.
When the local app answers 403, behaves like old code, doesn't show a change, or a button "does nothing", run `scripts/dev-status.sh` from the checkout or worktree whose code you expect. It flags a backend, worker or frontend running another checkout's code, a process older than its source (bootRun doesn't reload) or carrying production values, a database missing this checkout's migrations, a migration number another branch already ran under another name, a row of the gitignored `docs/PROBLEMS_MAPPING.md` that disagrees with the database, and a Judge0 that doesn't answer (every Run and Submit then fails, so check it before planning a UI check).
To see a branch's backend changes (migrations, endpoints, problems) or check its UI end to end, run `scripts/dev-branch-servers.sh` from its worktree instead of restarting or mocking the shared servers: it starts that checkout's backend, worker and Vite on free ports against a database (`codebite_<branch>_<hash of the worktree path>`), Kafka topics and groups and a claimed Redis index of their own, prints the URLs and log paths, and stops on Ctrl-C or `stop`; `status` reprints the URLs, `drop` deletes that data. It only ever stops processes it started (marked `CODEBITE_DEV_BRANCH=<that database>`) and refuses to run from the main checkout.
To sign in locally without OAuth (dev profile only), `POST /api/auth/test-token?username=<name>&role=ADMIN` returns a JWT; `role` (USER or ADMIN) also switches an existing user, and leaving it out keeps the role (new users are USER). Use an ADMIN token to check admin pages against real data. Check the UI from a session of your own: the Vite `scripts/dev-branch-servers.sh` prints (`127.0.0.1` at an unusual port), signed in by a test token from the branch backend. `localhost:5173`/`5174` and the user's Chrome tabs hold their real signed-in sessions, drafts and settings. For phone width, `resize_window` may leave the Chrome window as it was: open a page of that Vite and replace its body with a 390px-wide `<iframe>` of the route; media queries follow the iframe, and it shares the page's sign-in and localStorage.

### Infrastructure
```bash
docker compose -f infra/docker-compose.yml up -d   # start PostgreSQL + Redis + Kafka + Prometheus + Grafana
```

Production Judge0 runs `localhost/codebite-judge0` (Judge0 1.13.1 plus newer runtimes as extra language ids), built by hand from `infra/judge0/Dockerfile` with `scripts/build-judge0-image.sh`; compose names it by tag only, never `build:` or pull (docs/adr/0004). Language ids live in `Language` (`common/.../judge/Language.java`), one constant per language; events carry the language code and the worker sends Judge0 the id its event names, so nothing maps an id back to a language. Production Judge0 changes image only by a hand cutover at low traffic, never a push (a deploy would restart Judge0 at the end of a backend roll); `scripts/cutover-judge0-py312.sh` is the wizard for the move onto the py312 image, a template for the next one.

The GitHub App behind Solution Commits is registered by hand: run `scripts/setup-github-app-dev.sh`, an interactive wizard that walks through GitHub's app settings and writes the `GITHUB_APP_*` values into `infra/.env`. After that, `scripts/verify-github-solution-commits.sh` walks through checking once that GitHub credits live and Imported Solution Commits on the right UTC day. Production needs its own app (callback on code-bite.com): `scripts/setup-github-app-prod.sh` registers it, writes its values to the server over SSH and rolls the backend.

### Layout and gotchas
`docs/agents/backend.md` lists which package holds what, and the test doubles; open it to place a class or find one. What an `ls` won't tell you:
- `ProblemAdminService`: a title edit keeps the Slug, since the Driver and Starter Code are filed under it.
- `progress/UserProgress` owns what Solved and Attempted mean: Accepted/graded, non-admin, PENDING is neither.
- `ReviewService` rates a submission by replaying the other submissions' Reviews through `ReviewSchedule` and rating on top (a preview runs the same replay), stores the snapshot row or deletes it when no Review is left, and lists Due problems from that stored row.
- Streak days are UTC days (docs/adr/0001); terms in GLOSSARY.md.
- `KafkaConsumerConfig` has one container factory per `submission-results` listener plus one for `github-imports`; a new listener needs its own group and factory.
- `SolutionCommitListener` never throws: a transient GitHub error retries with doubling back-off and then marks the Solution Commit FAILED, while a gone installation or repository marks the link BROKEN and every later submission is skipped until relink.
- An Import pushes every earlier Accepted submission not yet COMMITTED through the link in one batch (`GitHubGateway.pushCommits`, JGit in `gateway/GitBatchPush`, remote base `app.github.git-base-url`).
- `GitHubExceptionHandler` is ordered ahead of `GlobalExceptionHandler`, mapping gateway exceptions to 403/503/502.
- Tests swap in `FakeGitHubGateway` via `TestGitHubConfig`; `TestKafkaConfig` runs Imports synchronously.

### Run Flow (Synchronous)
`POST /api/problems/{slug}/run` → `RunService.run()` assembles the Program through `ProblemAssets` and grades the sample test cases synchronously through the `Grader` (`gradeUntilFailure`, stopping at the first failing sample) and, when they all pass, the request's custom test cases (`grade`, never stopping early), returns results immediately. No data is persisted. No auth required.

### Submission Flow (Kafka-based)
1. `POST /api/problems/{slug}/submit` → `SubmissionService.submit()` assembles the Program (400 when the problem has no Driver for the language), saves PENDING submission, publishes `program.toEvent(submission)` to Kafka topic `submission-events`
2. Worker consumes event, reads the Program back with `Program.fromEvent`, grades it against every test case through the `Grader` (`Grader.grade`, one Judge0 batch), writes one result row per case and the Verdict's overall status to DB
3. The backend announces the Verdict over SSE (`submission/sse/`) and `frontend/src/judge/watchSubmission.ts` then fetches `GET /api/submissions/{id}`, polling instead when the stream can't open. The result shows in two places: `TestPanel`'s Output tab right after Submit, and `SubmissionDetail` (Submissions tab) for past submissions; a change to how a result looks touches both

### API Endpoints
Every endpoint is an `@*Mapping` in `backend/src/main/java/com/codebite/*/controller/` (plus `sitemap/SitemapController` and `onboarding/TutorialMilestoneController`), its request body the `*Request` record in that package's `dto/` and its response the record the method returns, whose comment says what a field means (`failingCase`, `reviewIntervalDays`, `solutionCommit` on `SubmissionResponse`). Auth is the rule in `config/SecurityConfig`: a request needs a JWT unless it is one of the `permitAll` reads (problem list and detail, roadmap, tags, Solution reads, leaderboard, health, the sitemap), Run, a Tutorial milestone, OAuth or the SSE stream (its own short-lived token); `/api/admin/**` controllers carry `@PreAuthorize("hasRole('ADMIN')")`. Run and Submit have Redis cooldowns: 429 within 5 s of the same IP's last Run and within 10 s of the same user's last Submit. `docs/SYSTEM_DESIGN.md` §5 is the prose overview and the endpoint list.

## Worker

### Tech Stack
- Java 17, Spring Boot 3.2.5 (no main web server; management server on port 8081 for metrics)
- Spring Kafka (consumer)
- Spring Data JPA
- Spring Boot Actuator + Micrometer Prometheus (metrics on port 8081)
- Shares entities, repositories, and Judge0 client from `common` module

### Common Commands
```bash
./gradlew :worker:compileJava     # compile worker
./gradlew :worker:test            # run worker tests
source scripts/dev-env.sh && ./gradlew :worker:bootRun  # run worker locally (needs Postgres + Kafka + Judge0)
```

### Package Structure (`worker/src/main/java/com/codebite/worker/`)
- `WorkerApplication` — Spring Boot entry point (no web server, excludes Security/Redis; scans only `judge.client`, `judge.service` and `judge.grader`, so it never loads `ProblemAssets`: the event already carries the Program, read back with `Program.fromEvent`)
- `consumer/SubmissionConsumer` — Kafka listener that processes submissions against Judge0
- `config/KafkaConsumerConfig` — Error handler with retry (3 retries, 1s backoff)

## Frontend

### Tech Stack
- React 19, TypeScript, Vite
- Tailwind CSS v4 with `@tailwindcss/typography`
- Axios (HTTP client with JWT interceptor)
- Monaco Editor (`@monaco-editor/react`)
- React Router v6, React Context for auth state

### Common Commands
```bash
cd frontend
npm run dev      # dev server at http://localhost:5173
npm run build    # production build (includes tsc type check)
npm test         # unit tests (Vitest); run by pre-commit and CI
npm run check    # tsc, ESLint (React purity rules too) and Vitest: what pre-commit and CI fail on; run it while building, not only at commit
```
Vitest runs in Asia/Seoul (`vite.config.ts`), whatever the shell's zone: a date that should be a UTC day but is formatted in the browser's zone fails there, not only for users in Korea.
Vitest runs in Node with no DOM (no jsdom or Testing Library), so a component test needs that setup first. Keep the decisions in pure modules, as `onboarding/` does, and check components in a browser.

### Layout and gotchas
`docs/agents/frontend.md` lists which directory holds what; open it to place a module or find one. What an `ls` won't tell you:
- `onboarding/` holds every Tutorial and Tip decision free of React, with storage injected; `pages/problem/TutorialSpotlight.tsx` only draws what `spotlight` decides, on elements marked `data-tour` (docs/adr/0008).
- A route's head tags (title, description, canonical, Open Graph, JSON-LD, noindex) come from `useDocumentMeta` and the pure `lib/headMeta` and `lib/jsonLd`; `useDocumentTitle` delegates to it.
- `api/client.ts` attaches the JWT that AuthContext keeps in localStorage.

### Routing
| Path | Page | Auth |
|------|------|------|
| `/login` | LoginPage | No |
| `/auth/callback/:provider` | OAuthCallbackPage | No |
| `/` | Redirect to `/problems` | No |
| `/problems` | ProblemListPage | No |
| `/problems/:slug` | ProblemDetailPage | No (submit requires auth) |
| `/profile` | ProfilePage | Yes |
| `/github/callback` | GitHubCallbackPage (GitHub App install redirect; links the Solution Repository named on the profile card, with a retry on failure) | Yes |
| `/dev/diagrams` | DiagramGalleryPage (Vite dev mode only, see Diagrams above; 404 in a production build) | ADMIN |
| `*` | NotFoundPage | No |

The problem workspace, solution pages and admin pages are `lazy` routes in `App.tsx`, so the Monaco editor is downloaded only when one of them opens; a page that must not reach the entry bundle is imported that way, never statically.

## Monitoring

### Prometheus + Grafana
- **Prometheus**: Scrapes metrics from backend (`:8080/actuator/prometheus`) and worker (`:8081/actuator/prometheus`) every 15s
- **Grafana**: `http://localhost:3001` (admin/admin) — auto-provisioned with Prometheus datasource and CodeBite Overview dashboard
- **Config**: `infra/prometheus/` (scrape configs), `infra/grafana/provisioning/` (datasource + dashboards)

### Custom Metrics
| Metric | Type | Source | Description |
|--------|------|--------|-------------|
| `codebite.submissions.created` | Counter | Backend | Total submissions created |
| `codebite.submissions.completed` | Counter | Worker | Submissions completed (tags: `status`, `language`) |
| `codebite.submissions.processing.duration` | Timer | Worker | Time to process a submission through Judge0 |
| `codebite.solution.commits` | Counter | Backend | Solution Commits by final outcome after retries (tag: `outcome` = `committed`, `failed`, or `broken` when the installation or repository is gone, which is never retried). An Import counts each commit in its batch |
| `codebite.tutorial.milestones` | Counter | Backend | Tutorial milestones reached, each reported once per run of the Tutorial by the browser (tag: `milestone` = `started`, `ran`, `submitted`, `accepted`, `skipped`); anonymous |

### Built-in Metrics (via Actuator)
- `http_server_requests_seconds` — HTTP request rate, latency, status codes per endpoint
- `jvm_memory_used_bytes` — JVM heap/non-heap memory
- `hikaricp_connections_*` — Database connection pool (active, idle, pending)
- `kafka_consumer_fetch_manager_records_lag` — Kafka consumer lag per partition

## Agent skills

### Issue tracker

GitHub Issues in `Kyu-seok/CodeBite`, via the `gh` CLI. See `docs/agents/issue-tracker.md`.

### Triage labels

The five default roles: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`. See `docs/agents/triage-labels.md`.

### Domain docs

Single-context: one `GLOSSARY.md` and `docs/adr/` at the repo root. See `docs/agents/domain.md`.

### Parallel sessions

Several sessions often run in this repo at once. Leave the main checkout on `master` and do all branch work in your own worktree (`git worktree add <scratchpad>/wt -b <branch> origin/master`, then `(cd <scratchpad>/wt/frontend && npm ci)` before any frontend check: a worktree has no `node_modules`, and the main checkout's may be stale); a `git switch` or commit in the shared checkout moves every other session's files. The CLAUDE.md a session starts with is the main checkout's, which can trail `origin/master`: so can a skill loaded at session start. After `git worktree add`, run `git -C <worktree> diff $(git rev-parse HEAD) -- CLAUDE.md .claude/skills` from the main checkout and read what landed since, such as a newer script you would otherwise work around or a step of the skill you are following. Read and edit source only under the worktree path: the main checkout trails `origin/master` the same way, so a patch written from its text misses. The machine has 8 GB, so only one full backend suite runs at a time: a parallel implementer runs the test package it touches (`--tests 'com.codebite.<package>.*'`) and leaves the full suite to the merge gate. The pre-commit hook refuses commits on `master`, and the commit-msg hook a subject over 72 characters. Merge with `scripts/ship-branch.sh <branch>` from the main checkout: it waits for CI, squash-merges, and deletes the remote branch, the worktree and the local branch (`gh pr merge --delete-branch` would delete the worktree under a running session, so a project hook refuses it). Merge finished ticket branches into an integration branch with `scripts/merge-ticket.sh <branch> <title> [<branch> <title> ...]`, run from the integration worktree: one call merges them in order, runs the checks a clean merge skips and pushes only when green (its header has the details), so an orchestrator runs it directly and needs a subagent only for a conflict.
