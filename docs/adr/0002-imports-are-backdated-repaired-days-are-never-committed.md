# Imports are backdated; Repaired Days are never committed

When a user links GitHub after already solving problems on CodeBite, they may Import their earlier Accepted submissions. Each Imported Solution Commit carries its submission's original Accepted time as its author date, so the green squares for those past days appear on GitHub, and they line up with the user's past Streak Days because both use UTC (ADR 0001). A Repaired Day, by contrast, never gets a commit, live or Imported. Both decisions follow one rule: a Solution Commit exists only for a real Accepted submission, dated when it really happened. Imported submissions were real solves on those days. A Repaired Day had no solve; a Repair only mends the CodeBite Streak, and backdating a commit for it would fake GitHub history.

## Considered Options

- **Date Imported commits at the time of the Import.** This is more conservative, but a user with months of solves would get one burst on a single day and none of the history they earned.
- **Commit Repaired Days too, so the two streaks match exactly.** This was rejected because it would turn a CodeBite convenience into a fabricated GitHub contribution.

## Consequences

This can't be undone once shipped: commits pushed into users' own repositories cannot be recalled or re-dated by CodeBite. A user's GitHub graph will show grey on Repaired Days that are green on CodeBite, and that difference is intentional.

A spike on 2026-10-24 (`scripts/prototype-github-push-spike/`) confirmed the approach. It pushed 300 backdated commits in one push, with the committer date set to the push time. GitHub counted all 300, each on its author date's UTC day, including commits 30 seconds either side of UTC midnight. That also confirms ADR 0001's assumption that GitHub buckets days in UTC.
