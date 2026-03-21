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
- jjwt 0.12.5 for JWT token handling

### Common Commands
```bash
./gradlew :backend:compileJava     # compile backend
./gradlew :backend:test            # run backend tests (uses H2, no Docker needed)
GOOGLE_CLIENT_ID=xxx GOOGLE_CLIENT_SECRET=xxx \
  GITHUB_CLIENT_ID=xxx GITHUB_CLIENT_SECRET=xxx \
  SPRING_PROFILES_ACTIVE=dev ./gradlew :backend:bootRun  # run locally
```

### Infrastructure
```bash
docker compose -f infra/docker-compose.yml up -d   # start PostgreSQL + Redis + Kafka
```

### Package Structure (`backend/src/main/java/com/codebite/`)
- `config/` — SecurityConfig, WebConfig, OAuthProperties, RedisConfig, KafkaTopicConfig
- `common/controller/` — HealthController
- `common/exception/` — GlobalExceptionHandler
- `auth/` — JWT auth + OAuth (controller, service, DTOs, filter, token provider, oauth clients)
- `user/` — UserService, DTOs
- `problem/` — Problem CRUD (controllers, service, DTOs)
- `submission/` — Submission flow (controller, service, DTOs, Kafka producer)

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
| POST | `/api/problems/{slug}/submit` | JWT | 201 + `{id, problemSlug, language, status, runtimeMs, memoryKb, results, createdAt}` |
| GET | `/api/submissions/{id}` | JWT | 200 + submission detail (input/expectedOutput only for sample cases) |
| GET | `/api/problems/{slug}/submissions` | JWT | 200 + `[{id, status, language, runtimeMs, memoryKb, createdAt}]` |

## Worker

### Tech Stack
- Java 17, Spring Boot 3.2.5 (no web server)
- Spring Kafka (consumer)
- Spring Data JPA
- Shares entities, repositories, and Judge0 client from `common` module

### Common Commands
```bash
./gradlew :worker:compileJava     # compile worker
./gradlew :worker:test            # run worker tests
./gradlew :worker:bootRun         # run worker locally (needs Postgres + Kafka + Judge0)
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
- `api/` — Axios client and API modules (auth, problems, submissions)
- `types/` — TypeScript interfaces matching backend DTOs
- `context/` — AuthContext (JWT auth state + localStorage persistence)
- `components/layout/` — Layout (nav bar), ProtectedRoute
- `components/ui/` — DifficultyBadge, StatusBadge, Spinner
- `pages/` — LoginPage, OAuthCallbackPage, ProblemListPage, ProblemDetailPage, NotFoundPage
- `hooks/` — useProblems, useProblem, useSubmissions

### Routing
| Path | Page | Auth |
|------|------|------|
| `/login` | LoginPage | No |
| `/auth/callback/:provider` | OAuthCallbackPage | No |
| `/` | Redirect to `/problems` | No |
| `/problems` | ProblemListPage | No |
| `/problems/:slug` | ProblemDetailPage | No (submit requires auth) |
| `*` | NotFoundPage | No |
