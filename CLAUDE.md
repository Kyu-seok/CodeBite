# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**CodeBite** — a code practice platform. The repository has the following top-level directories:

- `backend/` — Spring Boot 3.2.5 REST API (Java 17, Gradle 8.5)
- `frontend/` — client-side application (TBD)
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
- `config/` — SecurityConfig, WebConfig
- `common/base/` — BaseEntity (id, createdAt, updatedAt)
- `common/exception/` — GlobalExceptionHandler, ApiError, custom exceptions
- `auth/` — JWT auth (controller, service, DTOs, filter, token provider)
- `user/` — User entity, repository, service, DTOs

### API Endpoints
| Method | Path | Auth | Response |
|--------|------|------|----------|
| POST | `/api/auth/register` | No | 201 + `{token, tokenType, user}` |
| POST | `/api/auth/login` | No | 200 + `{token, tokenType, user}` |
| GET | `/api/auth/me` | JWT | 200 + `{id, username, email, role, createdAt}` |
