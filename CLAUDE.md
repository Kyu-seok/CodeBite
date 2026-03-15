# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**CodeBite** — a code practice platform. The repository has the following top-level directories:

- `backend/` — Spring Boot 3.2.5 REST API (Java 17, Gradle 8.5)
- `frontend/` — React SPA (Vite + TypeScript + Tailwind CSS)
- `worker/` — background job/task processing (TBD)
- `infra/` — Docker Compose (PostgreSQL 15)
- `docs/` — project documentation

## Backend

### Tech Stack
- Java 17, Spring Boot 3.2.5, Gradle 8.5 (wrapper)
- Spring Security (stateless JWT auth, BCrypt passwords)
- Spring Data JPA + Flyway migrations
- PostgreSQL 15 (dev/prod), H2 in PostgreSQL mode (tests)
- jjwt 0.12.5 for JWT token handling

### Common Commands
```bash
cd backend
./gradlew compileJava          # compile
./gradlew test                 # run tests (uses H2, no Docker needed)
SPRING_PROFILES_ACTIVE=dev ./gradlew bootRun  # run locally (needs Postgres)
```

### Infrastructure
```bash
docker compose -f infra/docker-compose.yml up -d   # start PostgreSQL
```

### Package Structure (`backend/src/main/java/com/codebite/`)
- `config/` — SecurityConfig, WebConfig, JudgeClientConfig
- `common/base/` — BaseEntity (id, createdAt, updatedAt)
- `common/exception/` — GlobalExceptionHandler, ApiError, custom exceptions
- `auth/` — JWT auth (controller, service, DTOs, filter, token provider)
- `user/` — User entity, repository, service, DTOs
- `problem/` — Problem CRUD (entities, repositories, service, controllers, DTOs)
- `submission/` — Submission flow (entities, repositories, service, controller, DTOs)
- `judge/` — Judge0 integration (client interface/impl, service, DTOs)

### API Endpoints
| Method | Path | Auth | Response |
|--------|------|------|----------|
| POST | `/api/auth/register` | No | 201 + `{token, tokenType, user}` |
| POST | `/api/auth/login` | No | 200 + `{token, tokenType, user}` |
| GET | `/api/auth/me` | JWT | 200 + `{id, username, email, role, createdAt}` |
| GET | `/api/problems` | No | 200 + paginated `{id, title, slug, difficulty}` |
| GET | `/api/problems/{slug}` | No | 200 + `{id, title, slug, description, difficulty, starterCode, constraints, published, sampleTestCases, createdAt, updatedAt}` |
| POST | `/api/admin/problems` | ADMIN | 201 + problem detail |
| PUT | `/api/admin/problems/{id}` | ADMIN | 200 + problem detail |
| POST | `/api/admin/problems/{id}/test-cases` | ADMIN | 201 + test case |
| POST | `/api/problems/{slug}/submit` | JWT | 201 + `{id, problemSlug, language, status, runtimeMs, memoryKb, results, createdAt}` |
| GET | `/api/submissions/{id}` | JWT | 200 + submission detail (input/expectedOutput only for sample cases) |
| GET | `/api/problems/{slug}/submissions` | JWT | 200 + `[{id, status, language, runtimeMs, memoryKb, createdAt}]` |

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
- `pages/` — LoginPage, RegisterPage, ProblemListPage, ProblemDetailPage, NotFoundPage
- `hooks/` — useProblems, useProblem, useSubmissions

### Routing
| Path | Page | Auth |
|------|------|------|
| `/login` | LoginPage | No |
| `/register` | RegisterPage | No |
| `/` | Redirect to `/problems` | No |
| `/problems` | ProblemListPage | No |
| `/problems/:slug` | ProblemDetailPage | No (submit requires auth) |
| `*` | NotFoundPage | No |
