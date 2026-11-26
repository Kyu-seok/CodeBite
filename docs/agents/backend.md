# Backend layout

Which package of `backend/` holds what. Open it to find where a class lives or where a new one goes; the rules an `ls` would not tell you are the Backend gotchas in CLAUDE.md.

## Packages (`backend/src/main/java/com/codebite/`)

Each feature package holds `controller/`, `service/` and `dto/` (the `*Request` body records and the response records a controller returns).

- `config/` — SecurityConfig (which requests need a JWT), WebConfig, OAuthProperties, GitHubAppProperties (`app.github.*`, optional), SiteProperties (`app.site.*`: the origin absolute links such as the sitemap's are built under), RedisConfig, KafkaTopicConfig, KafkaConsumerConfig, SchedulingConfig (`@EnableScheduling` for the re-drive sweep, off when `app.scheduling.enabled` is false)
- `common/controller/` — HealthController; `common/exception/` — GlobalExceptionHandler; `common/service/` — RateLimiterService (the Redis `SET NX EX` cooldown behind Run, Submit, Solution posts, comments and reports, and the re-drive sweep's lock; absent unless `app.cache.enabled`)
- `auth/` — JWT auth + OAuth (controller, service, DTOs, filter, token provider, oauth clients); `TestTokenController` (dev profile)
- `user/` — UserService, DTOs, settings endpoint
- `problem/` — `ProblemCatalogue` (what users see: the published list with Progress and Acceptance Rate, header counts, random pick, detail), `ProblemAdminService` (curation behind /api/admin/problems), `ProblemDtos` (builds the DTOs both return), `Walkthroughs` (every `walkthroughs/<slug>.json` read once at startup: `has`, `of`, `slugs`), controllers, DTOs
- `submission/` — Submission flow (controller, service, DTOs, Kafka producer), `sse/` (the Verdict announcement stream)
- `run/` — Run flow (controller, service, DTOs — synchronous Judge0 execution of the sample test cases, stopping at the first failure, then of the request's custom test cases once every sample passes)
- `streak/` — Streaks and Repairs (controller, service, DTOs, `submission-results` listener)
- `progress/` — typed progress reads: `UserProgress` (Solved and Attempted for the problem list, roadmap and recommendations; the Solved counts by difficulty and tag that the profile and list header show, over published problems only; Activity, every submission bucketed into UTC days in Java; `signUpsSince`, each non-admin sign-up with its first Accepted submission, the admin dashboard's onboarding success figure), `ProblemPopularity` (Acceptance Rate from `problem_stats`, maintained by `stats/consumer/SubmissionStatsListener` and backfilled once by V195; a problem with no row reads `Rate.NONE`)
- `review/` — Reviews: `ReviewService`, controller, DTOs
- `onboarding/` — `TutorialMilestoneController` and the `TutorialMilestone` enum: the anonymous Tutorial milestone counters (`codebite.tutorial.milestones`)
- `sitemap/` — `SitemapController` (`/api/sitemap.xml`, which nginx serves as `/sitemap.xml`, under `app.site.base-url`)
- `profile/`, `recommendation/`, `roadmap/`, `solution/`, `stats/`, `admin/` — the profile page's reads, weak-tag and roadmap-next recommendations, the roadmap, Solutions (posts, comments, votes, reports; admin moderation), `problem_stats` + leaderboard (`stats/consumer/SubmissionStatsListener`), the admin dashboard's analytics and submission reads
- `github/` — GitHub Links via the CodeBite GitHub App (ADR 0003): `gateway/` (`GitHubGateway` seam, `GitHubAppGateway` REST adapter minting installation tokens from an RS256 app JWT, `GitBatchPush` for the JGit batch push, gateway exceptions), `service/` (`GitHubLinkService` + signed install state carrying the chosen Solution Repository name; `SolutionCommitService` + `SolutionLayout` for Solution Commits, `SolutionCommitRecorder` for the row/path, README-first and outcome-counter rules it shares with `GitHubImporter`; `GitHubImportService`), `consumer/` (`SolutionCommitListener` on `submission-results`, group `codebite-solution-commits`: every ACCEPTED event of a user with an ACTIVE link becomes a Solution Commit, a problem folder's first one adding README + solution in one commit via `pushCommits`, retries per `app.github.commit-max-tries` / `commit-retry-backoff-ms`; `GitHubImportListener` on `github-imports`, group `codebite-github-imports`, running `GitHubImporter`), `event/GitHubImportRequestedEvent` + `GitHubImportPublisher` → `kafka/KafkaGitHubImportPublisher`, controller + `GitHubExceptionHandler`, DTOs

## Tests (`backend/src/test/java/com/codebite/`)

- `github/gateway/FakeGitHubGateway`, swapped in by `config/TestGitHubConfig`; `config/TestKafkaConfig` runs Imports synchronously
- `auth/service/InMemoryTokenBlacklistService`, swapped in by `config/TestTokenBlacklistConfig`: logout's token blacklist without Redis, its entries lasting their TTL
- `problem/MigratedDatabase` for tests that read migrated rows (H2 keeps `E'…\n…'` escapes literally)
- `testsupport/LoopbackHttpServer` for a test that stands in for an HTTP API with a JDK `HttpServer`: it binds 127.0.0.1, never the wildcard address (#247)

## Tech stack

- Java 17, Spring Boot 3.2.5, Gradle 8.5 (wrapper)
- Spring Security (stateless JWT auth, OAuth via Google/GitHub)
- Spring Data JPA + Flyway migrations
- PostgreSQL 15 (dev/prod), H2 in PostgreSQL mode (tests)
- Redis 7 (JWT token blacklist, user profile cache)
- Spring Kafka (submission event producer, `submission-results` and `github-imports` listeners)
- Spring Boot Actuator + Micrometer Prometheus (metrics)
- jjwt 0.12.5 for JWT token handling
