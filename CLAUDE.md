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
- `user/entity/` — User, Role, OAuthProvider, UserOAuthAccount
- `user/repository/` — UserRepository, UserOAuthAccountRepository
- `problem/entity/` — Problem, TestCase, Difficulty
- `problem/repository/` — ProblemRepository, TestCaseRepository
- `submission/entity/` — Submission, SubmissionResult, SubmissionStatus
- `submission/repository/` — SubmissionRepository, SubmissionResultRepository
- `submission/event/` — SubmissionEvent (Kafka message DTO)
- `streak/entity/` — StreakDay, UserStreak (Repairs held + Repair Progress)
- `streak/repository/` — StreakDayRepository, UserStreakRepository
- `github/entity/` — GitHubLink, GitHubLinkStatus (ACTIVE/BROKEN/UNLINKED), GitHubImportState, SolutionCommit, SolutionCommitStatus (PENDING/COMMITTED/FAILED)
- `github/repository/` — GitHubLinkRepository (`findCurrentByUserId` = the user's current link, ACTIVE or BROKEN), SolutionCommitRepository
- `judge/` — JudgeClient, JudgeClientImpl, JudgeService, DriverCodeLoader, DTOs
- `config/` — JudgeClientConfig

### Resources (`common/src/main/resources/`)
- `db/migration/` — Flyway SQL migrations
- `drivers/` — Driver code templates per problem/language

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
`scripts/dev-env.sh` loads only the OAuth and GitHub App values from `infra/.env`. That file is the production server's config: sourcing it whole overrides the dev CORS origins, JWT secret, database and Judge0 URL.
When a local backend or worker answers 403, behaves like old code, or a button "does nothing", run `scripts/dev-status.sh` first. It flags a process older than its source (bootRun doesn't reload) or carrying production values.

### Infrastructure
```bash
docker compose -f infra/docker-compose.yml up -d   # start PostgreSQL + Redis + Kafka + Prometheus + Grafana
```

The GitHub App behind Solution Commits is registered by hand: run `scripts/setup-github-app-dev.sh`, an interactive wizard that walks through GitHub's app settings and writes the `GITHUB_APP_*` values into `infra/.env`. After that, `scripts/verify-github-solution-commits.sh` walks through checking once that GitHub credits live and Imported Solution Commits on the right UTC day. Production needs its own app (callback on code-bite.com): `scripts/setup-github-app-prod.sh` registers it, writes its values to the server over SSH and rolls the backend.

### Package Structure (`backend/src/main/java/com/codebite/`)
- `config/` — SecurityConfig, WebConfig, OAuthProperties, GitHubAppProperties (`app.github.*`, optional), RedisConfig, KafkaTopicConfig, KafkaConsumerConfig (one container factory per `submission-results` listener, plus one for `github-imports`)
- `common/controller/` — HealthController
- `common/exception/` — GlobalExceptionHandler
- `auth/` — JWT auth + OAuth (controller, service, DTOs, filter, token provider, oauth clients)
- `user/` — UserService, DTOs
- `problem/` — Problem CRUD (controllers, service, DTOs)
- `submission/` — Submission flow (controller, service, DTOs, Kafka producer)
- `run/` — Run flow (controller, service, DTOs — synchronous Judge0 execution, sample test cases only)
- `streak/` — Streaks and Repairs (controller, service, DTOs, `submission-results` listener); terms in GLOSSARY.md, UTC days per docs/adr/0001
- `github/` — GitHub Links via the CodeBite GitHub App (ADR 0003): `gateway/` (`GitHubGateway` seam, `GitHubAppGateway` REST adapter minting installation tokens from an RS256 app JWT, gateway exceptions), `service/` (link + signed install state carrying the chosen Solution Repository name; `SolutionCommitService` + `SolutionLayout` for Solution Commits, `SolutionCommitRecorder` for the row/path, README-first and outcome-counter rules it shares with `GitHubImporter`), `consumer/SolutionCommitListener` (`submission-results`, group `codebite-solution-commits`: every ACCEPTED event of a user with an ACTIVE link becomes a Solution Commit, a problem folder's first one adding README + solution in one commit via `pushCommits`; transient GitHub errors retried with doubling back-off per `app.github.commit-max-tries` / `commit-retry-backoff-ms`, then FAILED; never throws; a gone installation/repository marks the link BROKEN, after which submissions are skipped until relink), Import (`GitHubImportService` starts it and publishes `event/GitHubImportRequestedEvent` through `GitHubImportPublisher` → `kafka/KafkaGitHubImportPublisher` on topic `github-imports`; `consumer/GitHubImportListener`, group `codebite-github-imports`, runs `GitHubImporter`: every earlier Accepted submission not yet COMMITTED through the link goes up in one batch push via `GitHubGateway.pushCommits`, which the real adapter does with JGit in `gateway/GitBatchPush`, remote base `app.github.git-base-url`), controller (plus `GitHubExceptionHandler`, ordered ahead of GlobalExceptionHandler, mapping gateway exceptions to 403/503/502), DTOs. Tests swap in `FakeGitHubGateway` (`backend/src/test/.../github/gateway/`) via `TestGitHubConfig`, and `TestKafkaConfig` runs Imports synchronously

### Run Flow (Synchronous)
`POST /api/problems/{slug}/run` → `RunService.run()` executes only sample test cases synchronously via JudgeService, returns results immediately. No data is persisted. No auth required.

### Submission Flow (Kafka-based)
1. `POST /api/problems/{slug}/submit` → `SubmissionService.submit()` saves PENDING submission, publishes `SubmissionEvent` to Kafka topic `submission-events`
2. Worker consumes event, runs code against Judge0 for each test case, writes results to DB
3. Frontend polls `GET /api/submissions/{id}` every 2s until status != PENDING

### API Endpoints
| Method | Path | Auth | Response |
|--------|------|------|----------|
| GET | `/api/auth/oauth/{provider}` | No | 200 + `{authorizationUrl}` |
| POST | `/api/auth/oauth/{provider}/callback` | No | 200 + `{token, tokenType, user}` |
| GET | `/api/auth/me` | JWT | 200 + `{id, username, email, role, createdAt}` |
| POST | `/api/auth/logout` | JWT | 204 No Content |
| GET | `/api/health` | No | 200 + `{status: "UP"}` |
| GET | `/api/problems` | No | 200 + paginated `{id, title, slug, difficulty}` |
| GET | `/api/problems/{slug}` | No | 200 + `{id, title, slug, description, difficulty, starterCode, constraints, published, sampleTestCases, createdAt, updatedAt}` |
| POST | `/api/admin/problems` | ADMIN | 201 + problem detail |
| PUT | `/api/admin/problems/{id}` | ADMIN | 200 + problem detail |
| POST | `/api/admin/problems/{id}/test-cases` | ADMIN | 201 + test case |
| POST | `/api/problems/{slug}/run` | No | 200 + `{overallStatus, results}` |
| POST | `/api/problems/{slug}/submit` | JWT | 201 + `{id, problemSlug, language, status, runtimeMs, memoryKb, results, createdAt}` |
| GET | `/api/submissions/{id}` | JWT | 200 + submission detail (input/expectedOutput only for sample cases; `solutionCommit: {status: PENDING\|COMMITTED\|FAILED, commitUrl}` or null when there's no Solution Commit; `reviewIntervalDays: {AGAIN, HARD, GOOD, EASY}` = days the review scheduler would set if rated now, null while PENDING) |
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
- `WorkerApplication` — Spring Boot entry point (no web server, excludes Security/Redis)
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
```

### Directory Structure (`frontend/src/`)
- `api/` — Axios client and API modules (auth, problems, submissions, streak, github)
- `types/` — TypeScript interfaces matching backend DTOs
- `context/` — AuthContext (JWT auth state + localStorage persistence)
- `components/layout/` — Layout (nav bar), ProtectedRoute
- `components/ui/` — DifficultyBadge, StatusBadge, Spinner
- `pages/` — LoginPage, OAuthCallbackPage, GitHubCallbackPage, ProblemListPage, ProblemDetailPage, NotFoundPage, `profile/` (incl. GitHubLinkCard)
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
