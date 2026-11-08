# Common module layout

Which package of `common/` holds what. Open it to find where a class lives or where a new one goes; the rules an `ls` would not tell you are the Common Module gotchas in CLAUDE.md.

## Packages (`common/src/main/java/com/codebite/`)

- `common/base/` — BaseEntity (id, createdAt, updatedAt)
- `common/exception/` — ApiError, custom exceptions (ResourceNotFoundException, JudgeExecutionException, etc.)
- `common/time/` — DayRuns (runs of consecutive UTC days behind the Streak and the Review Streak), DayCount (a count on one calendar day, the heatmap row)
- `user/entity/` — User, Role, OAuthProvider, UserOAuthAccount
- `user/repository/` — UserRepository, UserOAuthAccountRepository
- `problem/entity/` — Problem, TestCase, Difficulty, Curation (a curated subset numbered 1 to N; docs/adr/0007), FormerSlug (a Slug a problem had before a Restatement)
- `problem/repository/` — ProblemRepository (`findBySlugOrFormerSlug`, `isSlugTaken`), TestCaseRepository
- `submission/entity/` — Submission (`language()` = the stored code as a `Language`), SubmissionResult, SubmissionStatus
- `submission/repository/` — SubmissionRepository (lifecycle, Import, re-drive and admin reads), SubmissionResultRepository
- `submission/event/` — SubmissionEvent (Kafka message DTO)
- `streak/entity/` — StreakDay, UserStreak (Repairs held + Repair Progress)
- `streak/repository/` — StreakDayRepository, UserStreakRepository
- `review/entity/` — Confidence, ProblemReviewState (the stored snapshot of a Review Schedule, built by `of(userId, problemId, schedule)`, getters only), ProblemReviewStateId
- `review/repository/` — ProblemReviewStateRepository (`findDue`, `countDue`), ReviewRepository (reads of rated submissions: replay order, stats, heatmap `DayCount`s, `TagConfidenceCount`s, filtered history)
- `review/schedule/` — Review, ReviewSchedule (SM-2 lite as an immutable value: `replay`, `rate`, `preview`, `mastered`)
- `roadmap/`, `solution/`, `stats/` — entities and repositories behind the roadmap, Solutions (posts, comments, votes, reports) and `problem_stats`/leaderboard
- `github/entity/` — GitHubLink, GitHubLinkStatus (ACTIVE/BROKEN/UNLINKED), GitHubImportState, SolutionCommit, SolutionCommitStatus (PENDING/COMMITTED/FAILED)
- `github/repository/` — GitHubLinkRepository (`findCurrentByUserId` = the user's current link, ACTIVE or BROKEN), SolutionCommitRepository
- `judge/` — Language (the codes CodeBite accepts, each with its Judge0 id and file extension), JudgeClient, JudgeClientImpl, JudgeService (a plain Judge0 client: `execute`, `executeBatch`), DTOs
- `judge/program/` — ProblemAssets (backend only; `assemble` → Program or `NoDriverException`, `recall` for a stored submission, `starters`, `slugsWithDriver`), Program (the assembled source, its Language and Judge0 id; `diagnostics` maps Judge0's errors onto the user's lines; `toEvent`/`fromEvent` for the `SubmissionEvent`), UserCodeLineMapper (package-private)
- `judge/parser/` — one JudgeErrorParser per Language, in combined-file lines
- `judge/grader/` — TestInput, CaseVerdict, Verdict, Grader (grades a Program: `grade`, `gradeUntilFailure`)
- `config/` — JudgeClientConfig

## Resources (`common/src/main/resources/`)

- `db/migration/` — Flyway SQL migrations; Java ones live in `common/src/main/java/db/migration`
- `drivers/` — Drivers, `drivers/<slug>/<language>.<ext>`; Libraries under `drivers/lib/<language>/`
- `starters/` — Starter Code, `starters/<slug>/<language>.<ext>` (served by the backend, read by the same ProblemAssets)
