# Backend layout

Which package of `backend/` holds what. Open it to find where a class lives or where a new one goes; the rules an `ls` would not tell you are the Backend gotchas in CLAUDE.md.

## Packages (`backend/src/main/java/com/codebite/`)

Each feature package holds `controller/`, `service/` and `dto/` (the `*Request` body records and the response records a controller returns).

- `config/` — SecurityConfig (which requests need a JWT), WebConfig, OAuthProperties, GitHubAppProperties (`app.github.*`, optional), RedisConfig, KafkaTopicConfig, KafkaConsumerConfig
- `common/controller/` — HealthController; `common/exception/` — GlobalExceptionHandler
- `auth/` — JWT auth + OAuth (controller, service, DTOs, filter, token provider, oauth clients); `TestTokenController` (dev profile)
- `user/` — UserService, DTOs, settings endpoint
- `problem/` — `ProblemCatalogue` (what users see: the published list with Progress and Acceptance Rate, header counts, random pick, detail), `ProblemAdminService` (curation behind /api/admin/problems), `ProblemDtos` (builds the DTOs both return), controllers, DTOs
- `submission/` — Submission flow (controller, service, DTOs, Kafka producer), `sse/` (the Verdict announcement stream)
- `run/` — Run flow (controller, service, DTOs — synchronous Judge0 execution, sample test cases only)
- `streak/` — Streaks and Repairs (controller, service, DTOs, `submission-results` listener)
- `progress/` — typed progress reads: `UserProgress` (Solved and Attempted for the problem list, roadmap and recommendations; Solved counts by difficulty and tag; Activity by UTC day; `signUpsSince` for the admin dashboard's onboarding figure), `ProblemPopularity` (Acceptance Rate from `problem_stats`)
- `review/` — Reviews: `ReviewService`, controller, DTOs
- `onboarding/` — `TutorialMilestoneController` and the `TutorialMilestone` enum: the anonymous Tutorial milestone counters (`codebite.tutorial.milestones`)
- `sitemap/` — `SitemapController` (`/api/sitemap.xml`, which nginx serves as `/sitemap.xml`, under `app.site.base-url`)
- `profile/`, `recommendation/`, `roadmap/`, `solution/`, `stats/`, `admin/` — the profile page's reads, weak-tag and roadmap-next recommendations, the roadmap, Solutions (posts, comments, votes, reports; admin moderation), `problem_stats` + leaderboard (`stats/consumer/SubmissionStatsListener`), the admin dashboard's analytics and submission reads
- `github/` — GitHub Links via the CodeBite GitHub App (ADR 0003): `gateway/` (`GitHubGateway` seam, `GitHubAppGateway` REST adapter minting installation tokens from an RS256 app JWT, `GitBatchPush` for the JGit batch push, gateway exceptions), `service/` (`GitHubLinkService` + signed install state carrying the chosen Solution Repository name; `SolutionCommitService` + `SolutionLayout` for Solution Commits, `SolutionCommitRecorder` for the row/path, README-first and outcome-counter rules it shares with `GitHubImporter`; `GitHubImportService`), `consumer/` (`SolutionCommitListener` on `submission-results`, group `codebite-solution-commits`; `GitHubImportListener` on `github-imports`, group `codebite-github-imports`, running `GitHubImporter`), `event/GitHubImportRequestedEvent` + `GitHubImportPublisher` → `kafka/KafkaGitHubImportPublisher`, controller + `GitHubExceptionHandler`, DTOs

## Tests (`backend/src/test/java/com/codebite/`)

- `github/gateway/FakeGitHubGateway`, swapped in by `config/TestGitHubConfig`; `config/TestKafkaConfig` runs Imports synchronously
- `problem/MigratedDatabase` for tests that read migrated rows (H2 keeps `E'…\n…'` escapes literally)
