# CodeBite — System Design Document

## 1. Overall System Architecture (Target State)

```
                        ┌─────────┐
                        │  Nginx  │
                        │   LB    │
                        └────┬────┘
                             │
              ┌──────────────┼──────────────┐
              │              │              │
        ┌─────┴─────┐ ┌─────┴─────┐ ┌─────┴─────┐
        │ Backend 1 │ │ Backend 2 │ │ Backend N │
        │ Spring    │ │ Spring    │ │ Spring    │
        │ Boot      │ │ Boot      │ │ Boot      │
        └─────┬─────┘ └─────┬─────┘ └─────┬─────┘
              │              │              │
              └──────┬───────┴──────┬┬──────┘
                     │              ││
               ┌─────┴─────┐  ┌────┴┴────┐  ┌───────────┐
               │ PostgreSQL │  │  Redis   │  │   Kafka   │
               │  Primary   │  │  Rate    │  │  Broker   │
               │            │  │  Limit / │  │           │
               │            │  │  Cache   │  └─────┬─────┘
               └─────┬──────┘  └──────────┘        │
                     │                        ┌────┴─────┐
               ┌─────┴──────┐                 │  Worker  │
               │  Read      │                 │  Service │
               │  Replicas  │                 └────┬─────┘
               └────────────┘                      │
                                             ┌─────┴─────┐
                                             │  Judge0   │
                                             │  API      │
                                             └───────────┘
```

**Data flow:**
1. User submits code via React frontend
2. Nginx routes request to a backend instance
3. Redis rate limiter checks per-user submission rate; rejects if exceeded
4. Backend validates, persists submission, publishes event to Kafka topic
5. Worker consumes from Kafka, calls Judge0 API, writes result back to DB
6. Frontend polls or receives result via WebSocket/SSE

---

## 2. MVP Architecture (Monolith, Synchronous)

```
┌──────────┐     ┌──────────────┐     ┌────────────┐     ┌─────────┐
│  React   │────▶│  Spring Boot │────▶│ PostgreSQL │     │ Judge0  │
│ Frontend │◀────│   Monolith   │◀────│            │     │  API    │
└──────────┘     └──────┬───────┘     └────────────┘     └────▲────┘
                        │                                     │
                        └─────────────────────────────────────┘
                              synchronous HTTP call
```

In MVP:
- Single Spring Boot instance handles everything
- Submission endpoint calls Judge0 synchronously, waits for result
- No Redis, no worker, no queue
- Frontend polls for result or waits on HTTP response
- JWT-based stateless authentication

---

## 3. Backend Modules & Package Structure

```
com.codebite
├── config/                  # Spring configuration
│   ├── SecurityConfig       # Spring Security + JWT filter chain
│   ├── WebConfig            # CORS, interceptors
│   ├── JudgeClientConfig    # Judge0 RestTemplate/WebClient bean
│   ├── KafkaConfig          # Kafka producer/consumer, topic config
│   └── RedisConfig          # Redis connection, rate limiter beans
│
├── auth/                    # Authentication module
│   ├── controller/
│   │   └── AuthController          # POST /api/auth/register, /login, /me
│   ├── dto/
│   │   ├── RegisterRequest
│   │   ├── LoginRequest
│   │   └── AuthResponse
│   ├── service/
│   │   └── AuthService
│   └── jwt/
│       ├── JwtTokenProvider
│       └── JwtAuthenticationFilter
│
├── user/                    # User module
│   ├── entity/
│   │   └── User
│   ├── repository/
│   │   └── UserRepository
│   ├── dto/
│   │   └── UserProfile
│   └── service/
│       └── UserService
│
├── problem/                 # Problem module
│   ├── controller/
│   │   └── ProblemController       # GET /api/problems, /api/problems/{slug}
│   ├── entity/
│   │   ├── Problem
│   │   └── TestCase
│   ├── repository/
│   │   ├── ProblemRepository
│   │   └── TestCaseRepository
│   ├── dto/
│   │   ├── ProblemListItem
│   │   ├── ProblemDetail
│   │   └── TestCaseDto
│   └── service/
│       └── ProblemService
│
├── submission/              # Submission module
│   ├── controller/
│   │   └── SubmissionController    # POST /api/submissions, GET .../status
│   ├── entity/
│   │   ├── Submission
│   │   └── SubmissionResult
│   ├── repository/
│   │   └── SubmissionRepository
│   ├── dto/
│   │   ├── SubmitRequest
│   │   ├── SubmissionResponse
│   │   └── SubmissionStatus
│   ├── event/
│   │   ├── SubmissionEventPublisher  # Publishes to Kafka topic
│   │   └── SubmissionEvent           # Kafka message payload DTO
│   └── service/
│       └── SubmissionService
│
├── ratelimit/               # Rate limiting module
│   ├── RateLimiterService           # Redis-backed sliding window counter
│   └── RateLimitInterceptor         # Checks rate limit before submission
│
├── judge/                   # Judge0 integration module
│   ├── client/
│   │   └── JudgeClient             # HTTP calls to Judge0
│   ├── dto/
│   │   ├── JudgeSubmissionRequest
│   │   └── JudgeSubmissionResponse
│   └── service/
│       └── JudgeService            # Orchestrates test case execution
│
└── common/                  # Shared utilities
    ├── exception/
    │   ├── GlobalExceptionHandler   # @ControllerAdvice
    │   ├── ResourceNotFoundException
    │   ├── RateLimitExceededException
    │   └── ApiError
    └── base/
        └── BaseEntity               # id, createdAt, updatedAt
```

**Design rationale:** Organized by domain feature (not by layer). Each module owns its controller, service, entity, repo, and DTOs. This makes future extraction into microservices straightforward.

---

## 4. Database Schema

```sql
-- Users
CREATE TABLE users (
    id              BIGSERIAL PRIMARY KEY,
    username        VARCHAR(50)  NOT NULL UNIQUE,
    email           VARCHAR(255) NOT NULL UNIQUE,
    password_hash   VARCHAR(255) NOT NULL,
    role            VARCHAR(20)  NOT NULL DEFAULT 'USER',  -- USER, ADMIN
    created_at      TIMESTAMP    NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMP    NOT NULL DEFAULT NOW()
);

-- Problems
CREATE TABLE problems (
    id              BIGSERIAL PRIMARY KEY,
    title           VARCHAR(255) NOT NULL,
    slug            VARCHAR(255) NOT NULL UNIQUE,         -- url-friendly identifier
    description     TEXT         NOT NULL,                 -- markdown content
    difficulty      VARCHAR(10)  NOT NULL,                 -- EASY, MEDIUM, HARD
    starter_code    JSONB        NOT NULL DEFAULT '{}',    -- {"java": "...", "python": "..."}
    constraints     TEXT,
    is_published    BOOLEAN      NOT NULL DEFAULT FALSE,
    created_at      TIMESTAMP    NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMP    NOT NULL DEFAULT NOW()
);

-- Test Cases
CREATE TABLE test_cases (
    id              BIGSERIAL PRIMARY KEY,
    problem_id      BIGINT       NOT NULL REFERENCES problems(id) ON DELETE CASCADE,
    input           TEXT         NOT NULL,
    expected_output TEXT         NOT NULL,
    is_sample       BOOLEAN      NOT NULL DEFAULT FALSE,  -- shown to user vs hidden
    order_index     INT          NOT NULL DEFAULT 0,
    created_at      TIMESTAMP    NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_test_cases_problem_id ON test_cases(problem_id);

-- Submissions
CREATE TABLE submissions (
    id              BIGSERIAL PRIMARY KEY,
    user_id         BIGINT       NOT NULL REFERENCES users(id),
    problem_id      BIGINT       NOT NULL REFERENCES problems(id),
    language        VARCHAR(20)  NOT NULL,                 -- java, python, javascript
    source_code     TEXT         NOT NULL,
    status          VARCHAR(30)  NOT NULL DEFAULT 'PENDING',
    -- PENDING, RUNNING, ACCEPTED, WRONG_ANSWER,
    -- TIME_LIMIT_EXCEEDED, RUNTIME_ERROR, COMPILATION_ERROR
    runtime_ms      INT,
    memory_kb       INT,
    created_at      TIMESTAMP    NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_submissions_user_id ON submissions(user_id);
CREATE INDEX idx_submissions_problem_id ON submissions(problem_id);
CREATE INDEX idx_submissions_user_problem ON submissions(user_id, problem_id);

-- Submission Results (per test case)
CREATE TABLE submission_results (
    id              BIGSERIAL PRIMARY KEY,
    submission_id   BIGINT       NOT NULL REFERENCES submissions(id) ON DELETE CASCADE,
    test_case_id    BIGINT       NOT NULL REFERENCES test_cases(id),
    status          VARCHAR(30)  NOT NULL,
    actual_output   TEXT,
    runtime_ms      INT,
    memory_kb       INT,
    stderr          TEXT
);

CREATE INDEX idx_submission_results_submission_id ON submission_results(submission_id);
```

**ER Diagram:**

```
users 1──────▶ N submissions N ◀────── 1 problems
                    │                        │
                    │ 1                      │ 1
                    ▼ N                      ▼ N
            submission_results ◀──────▶ test_cases
```

---

## 5. API Endpoints

### Authentication
| Method | Path                | Description         | Auth |
|--------|---------------------|---------------------|------|
| POST   | /api/auth/register  | Register new user   | No   |
| POST   | /api/auth/login     | Login, returns JWT  | No   |
| GET    | /api/auth/me        | Get current user    | Yes  |

### Problems
| Method | Path                          | Description                  | Auth  |
|--------|-------------------------------|------------------------------|-------|
| GET    | /api/problems                 | List problems (paginated)    | No    |
| GET    | /api/problems/{slug}          | Problem detail + sample cases| No    |
| POST   | /api/admin/problems           | Create problem               | ADMIN |
| PUT    | /api/admin/problems/{id}      | Update problem               | ADMIN |
| POST   | /api/admin/problems/{id}/test-cases | Add test case           | ADMIN |

### Submissions
| Method | Path                              | Description                      | Auth |
|--------|-----------------------------------|----------------------------------|------|
| POST   | /api/problems/{slug}/submit       | Submit code for a problem        | Yes  |
| GET    | /api/submissions/{id}             | Get submission result            | Yes  |
| GET    | /api/problems/{slug}/submissions  | User's submissions for a problem | Yes  |

**Request/Response examples:**

```
POST /api/problems/two-sum/submit
{
    "language": "java",
    "sourceCode": "class Solution { ... }"
}

Response 201:
{
    "submissionId": 42,
    "status": "PENDING"
}
```

```
GET /api/submissions/42

Response 200:
{
    "id": 42,
    "problemSlug": "two-sum",
    "language": "java",
    "status": "ACCEPTED",
    "runtimeMs": 12,
    "memoryKb": 9400,
    "results": [
        {
            "testCaseId": 1,
            "status": "ACCEPTED",
            "input": "[2,7,11,15], 9",         // only for sample cases
            "expectedOutput": "[0,1]",           // only for sample cases
            "actualOutput": "[0,1]",
            "runtimeMs": 4
        }
    ],
    "createdAt": "2026-03-13T10:30:00Z"
}
```

---

## 6. Judge0 Integration Plan

### How Judge0 works
Judge0 is a self-hosted or cloud API that compiles and runs code in a sandboxed environment. Key endpoints:
- `POST /submissions` — submit code for execution
- `GET /submissions/{token}` — poll for result

### Language ID mapping
Judge0 uses numeric IDs. Maintain a mapping:
```
java    → 62 (Java OpenJDK 13)
python  → 71 (Python 3)
javascript → 63 (Node.js 12)
```

### MVP flow (synchronous)

```
User submits code
       │
       ▼
SubmissionController.submit()
       │
       ▼
SubmissionService
  1. Validate request
  2. Save submission (status=PENDING)
  3. Fetch test cases for problem
  4. For each test case:
  │   └─▶ JudgeService.execute(code, language, input, expectedOutput)
  │         └─▶ JudgeClient.createSubmission()   → POST to Judge0
  │         └─▶ JudgeClient.pollResult()          → GET from Judge0 (poll with backoff)
  │         └─▶ Compare actual output vs expected
  │         └─▶ Save SubmissionResult
  │         └─▶ If WRONG_ANSWER/ERROR → stop early
  5. Update submission status (ACCEPTED / WRONG_ANSWER / etc.)
  6. Return result
```

### Key implementation details

**Code wrapping:** Users write a solution function. The backend wraps it with a main method that reads stdin (test input) and prints stdout (output). This wrapper is language-specific.

Example for Java:
```
// user's code
class Solution {
    public int[] twoSum(int[] nums, int target) { ... }
}

// wrapper appended by backend
public class Main {
    public static void main(String[] args) {
        // parse stdin into method arguments
        // call Solution.twoSum(...)
        // print result to stdout
    }
}
```

**Polling strategy:** Judge0 is async by default. Poll `GET /submissions/{token}` with exponential backoff (100ms, 200ms, 400ms...) up to a timeout of ~10s.

**Alternative (simpler for MVP):** Use Judge0's `?wait=true` query parameter on submission to get a synchronous response. This blocks the Judge0 request until execution finishes (up to a configured timeout). Avoids polling logic entirely.

### Post-MVP flow (asynchronous with Kafka + Redis rate limiting)

```
User submits code
       │
       ▼
Redis rate limiter
  (sliding window: N submissions per user per minute)
       │ pass                    │ fail
       ▼                        ▼
SubmissionService          Return 429
  1. Save submission           Too Many Requests
     (status=PENDING)
  2. Publish SubmissionEvent
     to Kafka topic
     "submission-events"
       │
       ▼
Returns 202 Accepted
with submissionId
       │                   Kafka topic: "submission-events"
       │                        │
       │                   ┌────┴─────────────────┐
       │                   │  Worker Consumer      │
       │                   │  (Kafka consumer      │
       │                   │   group: "judge-      │
       │                   │   workers")           │
       │                   │                       │
       │                   │  1. Deserialize event  │
       │                   │  2. Fetch test cases   │
       │                   │  3. Call Judge0 per    │
       │                   │     test case          │
       │                   │  4. Write results to   │
       │                   │     DB                 │
       │                   │  5. Commit Kafka       │
       │                   │     offset             │
       │                   └───────────────────────┘
       ▼
Frontend polls
GET /submissions/{id}
```

**Kafka topic design:**
- Topic: `submission-events`
- Key: `userId` (ensures ordering per user)
- Partitions: configurable (e.g., 6) — allows parallel worker consumption
- Consumer group: `judge-workers` — multiple worker instances share partitions

**Redis rate limiter design:**
- Algorithm: sliding window counter
- Key: `rate:submit:{userId}`
- Limit: configurable (e.g., 5 submissions per 60 seconds)
- Uses Redis `INCR` + `EXPIRE` or a sorted set with timestamps
- Returns `429 Too Many Requests` with `Retry-After` header when exceeded
- Works correctly across multiple backend instances (shared Redis state)

---

## 7. Project Folder Structure

```
CodeBite/
├── backend/
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/com/codebite/
│   │   │   │   ├── CodeBiteApplication.java
│   │   │   │   ├── config/
│   │   │   │   ├── auth/
│   │   │   │   │   ├── controller/
│   │   │   │   │   ├── dto/
│   │   │   │   │   ├── service/
│   │   │   │   │   └── jwt/
│   │   │   │   ├── user/
│   │   │   │   │   ├── entity/
│   │   │   │   │   ├── repository/
│   │   │   │   │   ├── dto/
│   │   │   │   │   └── service/
│   │   │   │   ├── problem/
│   │   │   │   │   ├── controller/
│   │   │   │   │   ├── entity/
│   │   │   │   │   ├── repository/
│   │   │   │   │   ├── dto/
│   │   │   │   │   └── service/
│   │   │   │   ├── submission/
│   │   │   │   │   ├── controller/
│   │   │   │   │   ├── entity/
│   │   │   │   │   ├── repository/
│   │   │   │   │   ├── dto/
│   │   │   │   │   └── service/
│   │   │   │   ├── judge/
│   │   │   │   │   ├── client/
│   │   │   │   │   ├── dto/
│   │   │   │   │   └── service/
│   │   │   │   └── common/
│   │   │   │       ├── exception/
│   │   │   │       └── base/
│   │   │   └── resources/
│   │   │       ├── application.yml
│   │   │       ├── application-dev.yml
│   │   │       └── db/migration/        # Flyway migrations
│   │   │           ├── V1__create_users.sql
│   │   │           ├── V2__create_problems.sql
│   │   │           ├── V3__create_test_cases.sql
│   │   │           ├── V4__create_submissions.sql
│   │   │           └── V5__seed_sample_problems.sql
│   │   └── test/java/com/codebite/
│   │       ├── auth/
│   │       ├── problem/
│   │       ├── submission/
│   │       └── judge/
│   ├── build.gradle                     # or pom.xml
│   └── Dockerfile
│
├── frontend/
│   ├── public/
│   ├── src/
│   │   ├── api/                         # Axios client + API modules
│   │   │   ├── client.ts
│   │   │   ├── auth.ts
│   │   │   ├── problems.ts
│   │   │   └── submissions.ts
│   │   ├── types/                       # TypeScript interfaces
│   │   ├── context/
│   │   │   └── AuthContext.tsx
│   │   ├── components/
│   │   │   ├── layout/                  # Layout, ProtectedRoute
│   │   │   └── ui/                      # DifficultyBadge, StatusBadge, Spinner
│   │   ├── pages/
│   │   │   ├── LoginPage.tsx
│   │   │   ├── RegisterPage.tsx
│   │   │   ├── ProblemListPage.tsx
│   │   │   ├── ProblemDetailPage.tsx     # Monaco editor + submissions
│   │   │   └── NotFoundPage.tsx
│   │   ├── hooks/                       # useProblems, useProblem, useSubmissions
│   │   └── App.tsx
│   ├── package.json
│   └── Dockerfile
│
├── worker/                              # Post-MVP
│   ├── src/main/java/com/codebite/worker/
│   │   ├── WorkerApplication.java
│   │   ├── config/
│   │   │   └── KafkaConsumerConfig.java
│   │   ├── consumer/
│   │   │   └── SubmissionEventConsumer.java  # @KafkaListener
│   │   └── service/
│   │       └── JudgeExecutionService.java    # Calls Judge0, writes results
│   └── Dockerfile
│
├── infra/
│   ├── docker-compose.yml               # Local dev: Postgres + Judge0
│   ├── docker-compose.prod.yml          # Full stack: Postgres + Kafka + Redis + Judge0 + Nginx
│   └── nginx/
│       └── nginx.conf
│
├── docs/
│   └── SYSTEM_DESIGN.md                 # This document
│
├── CLAUDE.md
└── README.md
```

---

## 8. Development Roadmap

### Milestone 1: Project Setup & Auth
- [x] Initialize Spring Boot project (Gradle, Java 17+)
- [x] Configure PostgreSQL with Flyway migrations
- [x] Set up docker-compose for local Postgres
- [x] Implement User entity and registration
- [x] Implement JWT authentication (login, token validation, filter)
- [x] Add Spring Security config
- [x] Write auth integration tests

**Deliverable:** Users can register and login. Protected endpoints require JWT.

### Milestone 2: Problem CRUD
- [x] Create Problem and TestCase entities
- [x] Flyway migrations for problems/test_cases tables
- [x] Problem listing endpoint (paginated, filterable by difficulty)
- [x] Problem detail endpoint (with sample test cases)
- [x] Admin endpoints for creating/updating problems
- [x] Seed 3-5 classic problems (Two Sum, FizzBuzz, Reverse String, Valid Parentheses, Palindrome Number)

**Deliverable:** API serves problem list and detail. Admin can manage problems.

### Milestone 3: Judge0 Integration & Submissions
- [x] Set up Judge0 via Docker (self-hosted) or use Judge0 CE API
- [x] Implement JudgeClient (HTTP calls to Judge0)
- [x] Implement code wrapping logic per language
- [x] Implement submission flow: save → execute → compare → store result
- [x] Submission endpoints (submit, get result, list by problem)
- [x] Handle Judge0 statuses → map to internal statuses
- [x] Test with seeded problems

**Deliverable:** Users can submit code, get ACCEPTED/WRONG_ANSWER/ERROR results.

### Milestone 4: Frontend MVP
- [x] Initialize React project (Vite)
- [x] Auth pages (register, login) with JWT storage
- [x] Problem list page with difficulty badges
- [x] Problem detail page with description panel + Monaco editor
- [x] Language selector dropdown
- [x] Submit button → show result (pass/fail per test case)
- [x] Submission history for a problem

**Deliverable:** Fully functional end-to-end flow in browser.

### Milestone 5: Redis Rate Limiting
- [ ] Add Redis to docker-compose
- [ ] Implement `RateLimiterService` using Redis sliding window counter
- [ ] Add `RateLimitInterceptor` to submission endpoint
- [ ] Return `429 Too Many Requests` with `Retry-After` header when exceeded
- [ ] Configure limits via `application.yml` (e.g., 5 submissions / 60s)
- [ ] Write integration tests for rate limiting

**Deliverable:** Submissions are rate-limited per user. Works correctly across multiple backend instances.

### Milestone 6: Async Execution with Kafka + Worker
- [ ] Add Kafka (+ Zookeeper or KRaft) to docker-compose
- [ ] Define `submission-events` topic with partitioned by userId
- [ ] Implement `SubmissionEventPublisher` (Kafka producer in backend)
- [ ] Build worker service with `@KafkaListener` consumer
- [ ] Worker calls Judge0, writes results to DB, commits offset
- [ ] Backend submission endpoint returns 202 + submissionId
- [ ] Frontend polls `GET /submissions/{id}` for status updates
- [ ] Handle consumer failures: retry policy, dead-letter topic
- [ ] Consider SSE or WebSocket for real-time result delivery

**Deliverable:** Submission execution is decoupled via Kafka. Multiple workers can consume in parallel.

### Milestone 7: Scaling Simulation
- [ ] docker-compose.prod.yml with multiple backend + worker instances
- [ ] Nginx load balancer in front of backend instances
- [ ] PostgreSQL read replica (primary for writes, replica for reads)
- [ ] Configure Spring to route read queries to replica
- [ ] Redis caching for problem detail (cache-aside pattern)
- [ ] Scale Kafka consumers by adding workers to consumer group
- [ ] Document the architecture and scaling decisions

**Deliverable:** Dockerized multi-instance deployment demonstrating horizontal scaling.

---

## Key Architecture Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Auth mechanism | JWT (stateless) | Scales across multiple backend instances without session store |
| DB migrations | Flyway | Version-controlled, repeatable schema evolution |
| Package structure | By feature | Cohesive modules, easy to extract into services later |
| Code execution | Judge0 (self-hosted) | Battle-tested sandboxing, supports 40+ languages |
| MVP submission | Synchronous | Simplest to implement; refactor to async in Milestone 6 |
| Async queue | Kafka | Durable, partitioned log; supports parallel consumers, replay, and dead-letter topics; strong portfolio signal |
| Rate limiting | Redis sliding window | Atomic counters across multiple backend instances; low latency |
| Caching | Redis (cache-aside) | Same Redis instance used for rate limiting; avoids adding another dependency |
| API style | REST + JSON | Standard, well-understood, sufficient for this use case |
| Starter code storage | JSONB column | Flexible per-language templates without extra tables |
