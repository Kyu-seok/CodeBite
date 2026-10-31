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

### Package Structure (`common/src/main/java/com/codebite/`)
- `common/base/` — BaseEntity (id, createdAt, updatedAt)
- `common/exception/` — ApiError, custom exceptions (ResourceNotFoundException, JudgeExecutionException, etc.)
- `common/time/` — DayRuns (runs of consecutive UTC days behind the Streak and the Review Streak), DayCount (a count on one calendar day, the heatmap row)
- `user/entity/` — User, Role, OAuthProvider, UserOAuthAccount
- `user/repository/` — UserRepository, UserOAuthAccountRepository
- `problem/entity/` — Problem, TestCase, Difficulty, Curation (a curated subset numbered 1 to N, so the Tutorial Problem, number 0, is in none; docs/adr/0007), FormerSlug (a Slug a problem had before a Restatement; `ProblemRepository.findBySlugOrFormerSlug` is every slug lookup, `isSlugTaken` checks both)
- `problem/repository/` — ProblemRepository, TestCaseRepository
- `submission/entity/` — Submission (`language()` = the stored code as a `Language`), SubmissionResult, SubmissionStatus
- `submission/repository/` — SubmissionRepository (lifecycle, Import, re-drive and admin reads; progress reads live in the backend's `progress/`), SubmissionResultRepository
- `submission/event/` — SubmissionEvent (Kafka message DTO)
- `streak/entity/` — StreakDay, UserStreak (Repairs held + Repair Progress)
- `streak/repository/` — StreakDayRepository, UserStreakRepository
- `review/entity/` — Confidence, ProblemReviewState (the stored snapshot of a Review Schedule, built by `of(userId, problemId, schedule)`, getters only), ProblemReviewStateId
- `review/repository/` — ProblemReviewStateRepository (`findDue`, `countDue`), ReviewRepository (reads of rated submissions: replay order, stats, heatmap `DayCount`s, `TagConfidenceCount`s, filtered history)
- `review/schedule/` — Review, ReviewSchedule (SM-2 lite as an immutable value: `replay`, `rate`, `preview`, `mastered`; the only place the numbers live; `review-schedule-golden.csv` in test resources pins them)
- `github/entity/` — GitHubLink, GitHubLinkStatus (ACTIVE/BROKEN/UNLINKED), GitHubImportState, SolutionCommit, SolutionCommitStatus (PENDING/COMMITTED/FAILED)
- `github/repository/` — GitHubLinkRepository (`findCurrentByUserId` = the user's current link, ACTIVE or BROKEN), SolutionCommitRepository
- `judge/` — Language (the codes CodeBite accepts, each with its Judge0 id and file extension; `ofRequest` = 400 for a code it doesn't accept), JudgeClient, JudgeClientImpl, JudgeService (a plain Judge0 client: `execute`, `executeBatch`), DTOs
- `judge/program/` — ProblemAssets (backend only; reads every Driver, Library and Starter Code once at startup, failing on a Driver without `{USER_CODE}`; `assemble` → Program or `NoDriverException`, `recall` for a stored submission, `starters`, `slugsWithDriver`), Program (the assembled source, its Language and Judge0 id; `diagnostics` maps Judge0's errors onto the user's lines; `toEvent`/`fromEvent` for the `SubmissionEvent`), UserCodeLineMapper (package-private)
- `judge/parser/` — one JudgeErrorParser per Language, in combined-file lines; only Program picks and calls them
- `judge/grader/` — TestInput, CaseVerdict, Verdict, Grader (grades a Program; `grade` runs every case in one Judge0 batch; `gradeUntilFailure` runs them one at a time and stops at the first failing judged case; the only place Judge0 statuses become SubmissionStatuses, docs/adr/0005)
- `config/` — JudgeClientConfig

### Reading a problem
`scripts/problem-text.sh <slug>` prints a problem as it stands (English and Korean text, sample Test Cases) from the local database. Migrations are the slow way: the newest one that sets a column wins, and the first grep match is usually stale.

### Restating a problem
Rewording a problem while its Test Cases stay (Slug, title, description, Starter Code names) is a Restatement: follow `.claude/skills/restate-problem/SKILL.md`. `ProblemSlugsTest` (backend) runs every migration and fails when a Slug and its `drivers/`/`starters/` directories disagree; `MigrationSlugReferencesTest` fails when a migration's `slug = …` names a slug that doesn't exist when it runs.

### Diagrams
Diagrams are ` ```diagram-* ` blocks in a description, drawn by `frontend/src/components/markdown/diagrams/`; the kinds and their keys are in `docs/PROBLEM_DIAGRAMS_ROADMAP.md`. To add one, follow `.claude/skills/add-diagram/SKILL.md`.

### Resources (`common/src/main/resources/`)
- `db/migration/` — Flyway SQL migrations; Java ones live in `common/src/main/java/db/migration`, and a version is taken if it is in either
- `drivers/` — Drivers, `drivers/<slug>/<language>.<ext>`; Libraries under `drivers/lib/<language>/`
- `starters/` — Starter Code, `starters/<slug>/<language>.<ext>` (served by the backend, but read by the same ProblemAssets)

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
source scripts/dev-env.sh && SPRING_PROFILES_ACTIVE=dev ./gradlew :backend:bootRun  # run locally
```
`scripts/dev-env.sh` loads only the OAuth and GitHub App values from `infra/.env` (from a worktree, the main checkout's). That file is the production server's config: sourcing it whole overrides the dev CORS origins, JWT secret, database and Judge0 URL.
When the local app answers 403, behaves like old code, doesn't show a change, or a button "does nothing", run `scripts/dev-status.sh` from the checkout or worktree whose code you expect. It flags a backend, worker or frontend running another checkout's code, a process older than its source (bootRun doesn't reload) or carrying production values, a database missing this checkout's migrations, and a migration number another branch already ran under another name.
To see a branch's backend changes (migrations, endpoints, problems) or check its UI end to end, run `scripts/dev-branch-servers.sh` from its worktree instead of restarting or mocking the shared servers: it starts that checkout's backend, worker and Vite on free ports against a database (`codebite_<branch>_<hash of the worktree path>`), Kafka topics and groups and a claimed Redis index of their own, prints the URLs and log paths, and stops on Ctrl-C or `stop`; `drop` deletes that data. It only ever stops processes it started (marked `CODEBITE_DEV_BRANCH=<that database>`) and refuses to run from the main checkout.
To sign in locally without OAuth (dev profile only), `POST /api/auth/test-token?username=<name>&role=ADMIN` returns a JWT; `role` (USER or ADMIN) also switches an existing user, and leaving it out keeps the role (new users are USER). Use an ADMIN token to check admin pages against real data. Check the UI from a session of your own: the Vite `scripts/dev-branch-servers.sh` prints (`127.0.0.1` at an unusual port), signed in by a test token from the branch backend. `localhost:5173`/`5174` and the user's Chrome tabs hold their real signed-in sessions, drafts and settings.

### Infrastructure
```bash
docker compose -f infra/docker-compose.yml up -d   # start PostgreSQL + Redis + Kafka + Prometheus + Grafana
```

Production Judge0 runs `localhost/codebite-judge0` (Judge0 1.13.1 plus newer runtimes as extra language ids), built by hand from `infra/judge0/Dockerfile` with `scripts/build-judge0-image.sh`; compose names it by tag only, never `build:` or pull (docs/adr/0004). Language ids live in `Language` (`common/.../judge/Language.java`), one constant per language; events carry the language code and the worker sends Judge0 the id its event names, so nothing maps an id back to a language. Production Judge0 changes image only by a hand cutover at low traffic, never a push (a deploy would restart Judge0 at the end of a backend roll); `scripts/cutover-judge0-py312.sh` is the wizard for the move onto the py312 image, a template for the next one.

The GitHub App behind Solution Commits is registered by hand: run `scripts/setup-github-app-dev.sh`, an interactive wizard that walks through GitHub's app settings and writes the `GITHUB_APP_*` values into `infra/.env`. After that, `scripts/verify-github-solution-commits.sh` walks through checking once that GitHub credits live and Imported Solution Commits on the right UTC day. Production needs its own app (callback on code-bite.com): `scripts/setup-github-app-prod.sh` registers it, writes its values to the server over SSH and rolls the backend.

### Package Structure (`backend/src/main/java/com/codebite/`)
- `config/` — SecurityConfig, WebConfig, OAuthProperties, GitHubAppProperties (`app.github.*`, optional), RedisConfig, KafkaTopicConfig, KafkaConsumerConfig (one container factory per `submission-results` listener, plus one for `github-imports`)
- `common/controller/` — HealthController
- `common/exception/` — GlobalExceptionHandler
- `auth/` — JWT auth + OAuth (controller, service, DTOs, filter, token provider, oauth clients)
- `user/` — UserService, DTOs
- `problem/` — Problems: `ProblemCatalogue` (what users see: the published list with Progress and Acceptance Rate, header counts, random pick, detail) and `ProblemAdminService` (curation behind /api/admin/problems; a title edit keeps the Slug, since the Driver and Starter Code are filed under it); `ProblemDtos` builds the DTOs both return (controllers, DTOs)
- `submission/` — Submission flow (controller, service, DTOs, Kafka producer)
- `run/` — Run flow (controller, service, DTOs — synchronous Judge0 execution, sample test cases only)
- `streak/` — Streaks and Repairs (controller, service, DTOs, `submission-results` listener); terms in GLOSSARY.md, UTC days per docs/adr/0001
- `progress/` — typed progress reads (terms in GLOSSARY.md): `UserProgress` owns what Solved and Attempted mean (Accepted/graded, non-admin, PENDING is neither) for the problem list, roadmap and recommendations, and the Solved counts by difficulty and tag over published problems that the profile and list header show, Activity (every submission, bucketed into UTC days in Java), and `signUpsSince` (each non-admin sign-up with its first Accepted submission, for the admin dashboard's onboarding success figure); `ProblemPopularity` (Acceptance Rate from `problem_stats`, maintained by `stats/consumer/SubmissionStatsListener` and backfilled once by V195; a problem with no row reads `Rate.NONE`)
- `review/` — Reviews (controller, service, DTOs): `ReviewService` rates a submission by replaying the other submissions' Reviews through `ReviewSchedule` and rating on top, stores the snapshot row or deletes it when no Review is left, previews intervals the same way, and lists Due problems from the row; terms in GLOSSARY.md
- `onboarding/` — `TutorialMilestoneController` and the `TutorialMilestone` enum: the anonymous Tutorial milestone counters (`codebite.tutorial.milestones`)
- `github/` — GitHub Links via the CodeBite GitHub App (ADR 0003): `gateway/` (`GitHubGateway` seam, `GitHubAppGateway` REST adapter minting installation tokens from an RS256 app JWT, gateway exceptions), `service/` (link + signed install state carrying the chosen Solution Repository name; `SolutionCommitService` + `SolutionLayout` for Solution Commits, `SolutionCommitRecorder` for the row/path, README-first and outcome-counter rules it shares with `GitHubImporter`), `consumer/SolutionCommitListener` (`submission-results`, group `codebite-solution-commits`: every ACCEPTED event of a user with an ACTIVE link becomes a Solution Commit, a problem folder's first one adding README + solution in one commit via `pushCommits`; transient GitHub errors retried with doubling back-off per `app.github.commit-max-tries` / `commit-retry-backoff-ms`, then FAILED; never throws; a gone installation/repository marks the link BROKEN, after which submissions are skipped until relink), Import (`GitHubImportService` starts it and publishes `event/GitHubImportRequestedEvent` through `GitHubImportPublisher` → `kafka/KafkaGitHubImportPublisher` on topic `github-imports`; `consumer/GitHubImportListener`, group `codebite-github-imports`, runs `GitHubImporter`: every earlier Accepted submission not yet COMMITTED through the link goes up in one batch push via `GitHubGateway.pushCommits`, which the real adapter does with JGit in `gateway/GitBatchPush`, remote base `app.github.git-base-url`), controller (plus `GitHubExceptionHandler`, ordered ahead of GlobalExceptionHandler, mapping gateway exceptions to 403/503/502), DTOs. Tests swap in `FakeGitHubGateway` (`backend/src/test/.../github/gateway/`) via `TestGitHubConfig`, and `TestKafkaConfig` runs Imports synchronously

### Run Flow (Synchronous)
`POST /api/problems/{slug}/run` → `RunService.run()` assembles the Program through `ProblemAssets` and grades the sample test cases synchronously through the `Grader` (`gradeUntilFailure`, stopping at the first failing sample) and, when they all pass, the request's custom test cases (`grade`, never stopping early), returns results immediately. No data is persisted. No auth required.

### Submission Flow (Kafka-based)
1. `POST /api/problems/{slug}/submit` → `SubmissionService.submit()` assembles the Program (400 when the problem has no Driver for the language), saves PENDING submission, publishes `program.toEvent(submission)` to Kafka topic `submission-events`
2. Worker consumes event, reads the Program back with `Program.fromEvent`, grades it against every test case through the `Grader` (`Grader.grade`, one Judge0 batch), writes one result row per case and the Verdict's overall status to DB
3. The backend announces the Verdict over SSE (`submission/sse/`) and `frontend/src/judge/watchSubmission.ts` then fetches `GET /api/submissions/{id}`, polling instead when the stream can't open. The result shows in two places: `TestPanel`'s Output tab right after Submit, and `SubmissionDetail` (Submissions tab) for past submissions; a change to how a result looks touches both

### API Endpoints
| Method | Path | Auth | Response |
|--------|------|------|----------|
| GET | `/api/auth/oauth/{provider}` | No | 200 + `{authorizationUrl}` |
| POST | `/api/auth/oauth/{provider}/callback` | No | 200 + `{token, tokenType, user}` |
| GET | `/api/auth/me` | JWT | 200 + `{id, username, email, role, createdAt}` |
| POST | `/api/auth/logout` | JWT | 204 No Content |
| GET | `/api/health` | No | 200 + `{status: "UP"}` |
| GET | `/api/problems` | No | 200 + paginated `{id, title, slug, difficulty, tutorial}` (`tutorial`: this is the Tutorial Problem) |
| GET | `/api/problems/{slug}` | No | 200 + (a Former Slug works too; `slug` is the current one) `{id, title, slug, description, difficulty, starterCode, constraints, published, sampleTestCases, tutorial, createdAt, updatedAt}` |
| POST | `/api/admin/problems` | ADMIN | 201 + problem detail |
| PUT | `/api/admin/problems/{id}` | ADMIN | 200 + problem detail |
| POST | `/api/admin/problems/{id}/test-cases` | ADMIN | 201 + test case |
| POST | `/api/problems/{slug}/run` | No | 200 + `{overallStatus, results}` |
| POST | `/api/tutorial/milestones/{milestone}` | No | 204 No Content (counts one Tutorial milestone in `codebite.tutorial.milestones`; `milestone` = `started`, `ran`, `submitted`, `accepted` or `skipped`, anything else 400; nothing per user is stored) |
| POST | `/api/problems/{slug}/submit` | JWT | 201 + `{id, problemSlug, language, status, runtimeMs, memoryKb, results, createdAt}` |
| GET | `/api/submissions/{id}` | JWT | 200 + submission detail (input/expectedOutput only for sample cases; `solutionCommit: {status: PENDING\|COMMITTED\|FAILED, commitUrl}` or null when there's no Solution Commit; `reviewIntervalDays: {AGAIN, HARD, GOOD, EASY}` = days the review scheduler would set if rated now, null while PENDING; `failingCase: {testCaseId, position, total, hidden, status, input, expectedOutput, actualOutput, errors}` = the Failing Case, revealed even when hidden (docs/adr/0006), null when Accepted, PENDING, a Compilation Error or an Internal Error) |
| GET | `/api/problems/{slug}/submissions` | JWT | 200 + `[{id, status, language, runtimeMs, memoryKb, createdAt}]` |
| GET | `/api/streak` | JWT | 200 + `{currentStreak, bestStreak, solvedToday, repairs, repairProgress}` |
| GET | `/api/streak/days?month=yyyy-MM` | JWT | 200 + `{month, today, firstStreakDate, days: [{date, repaired}]}` |
| POST | `/api/streak/repairs` | JWT | 200 + streak summary (body `{date}`; 400 if not a Missed Day or no Repairs, 409 if already counted) |
| GET | `/api/github/link` | JWT | 200 + `{githubAccountId, githubLogin, repositoryId, repositoryFullName, repositoryUrl, defaultBranch, repositoryPrivate, status, importState, createdAt}`, or 204 if none (a BROKEN link is re-checked via `GitHubGateway.isRepositoryReachable` and recovered to ACTIVE if reachable; ACTIVE reads never call GitHub) |
| GET | `/api/github/link/install?repositoryName=&visibility=public\|private` | JWT | 200 + `{installUrl, createRepositoryUrl}` (GitHub App install page with a `state` bound to the user and the chosen Solution Repository name; GitHub's new-repository page prefilled with that name, the visibility and the `app.github.solution-repository-template` template; 400 for a name GitHub wouldn't accept, 503 if the App is not configured) |
| POST | `/api/github/link/callback` | JWT | 200 + link (body `{code, installationId, state}`; links the granted repo named as in the state, case-insensitively, or the only granted repo when none has that name; 400 when several were granted and none has it, 401 bad state, 403 installation not authorised by that account) |
| DELETE | `/api/github/link` | JWT | 204 No Content (marks the current link UNLINKED, keeping the row; no GitHub call, repository untouched; 204 even with no link) |
| POST | `/api/github/link/import` | JWT | 202 + link with `importState: RUNNING` when AVAILABLE or FAILED; 409 when RUNNING, DONE or the link is BROKEN; 404 without a link. Runs in the background via Kafka topic `github-imports`; poll `GET /api/github/link` |

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
```

### Directory Structure (`frontend/src/`)
- `api/` — Axios client and API modules (auth, problems, submissions, streak, github)
- `types/` — TypeScript interfaces matching backend DTOs
- `context/` — AuthContext (JWT auth state + localStorage persistence)
- `components/layout/` — Layout (nav bar), ProtectedRoute
- `components/ui/` — DifficultyBadge, StatusBadge, Spinner
- `pages/` — LoginPage, OAuthCallbackPage, GitHubCallbackPage, ProblemListPage, ProblemDetailPage, NotFoundPage, `profile/` (incl. GitHubLinkCard)
- `lib/` — pure helpers (e.g. dueWording)
- `onboarding/` — every Tutorial and Tip decision, free of React, with storage injected (`storage.ts`: `OnboardingStorage`, `browserStorage`, `readStored`/`writeStored`): `tutorial` (the six steps, `tutorialStep`), `spotlight` (`tutorialSpotlight`: what each step spotlights and which elements stay usable, drawn by `pages/problem/TutorialSpotlight.tsx` on elements marked `data-tour`, docs/adr/0008), `milestones` (what the Tutorial reports to `/api/tutorial/milestones`), `tips` + `seenTips`, `banner` (the /problems banner rule)
- `hooks/` — useProblems, useProblem, useSubmissions

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
| `*` | NotFoundPage | No |

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

Several sessions often run in this repo at once. Leave the main checkout on `master` and do all branch work in your own worktree (`git worktree add <scratchpad>/wt -b <branch> origin/master`, then `(cd <scratchpad>/wt/frontend && npm ci)` before any frontend check: a worktree has no `node_modules`, and the main checkout's may be stale); a `git switch` or commit in the shared checkout moves every other session's files. The pre-commit hook refuses commits on `master`. Merge with `gh pr merge <n> --squash`, then `git push origin --delete <branch>`: `--delete-branch` also deletes your worktree, so a project hook refuses it.
