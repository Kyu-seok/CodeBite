-- Streaks and Repairs. Terms are defined in GLOSSARY.md; the UTC day boundary is ADR 0001.
--
-- Unlike user_stats, this is NOT derivable from `submissions`, so it is stored state rather than a
-- cache. Repaired Days have no submission behind them, and a Streak Day survives the submission
-- that earned it being re-judged.

-- One row per user per day that counts toward the Streak. `repaired` marks a Missed Day the user
-- filled by spending a Repair; real Streak Days come from Accepted submissions.
CREATE TABLE streak_days (
    id          BIGSERIAL PRIMARY KEY,
    user_id     BIGINT    NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    streak_date DATE      NOT NULL,
    repaired    BOOLEAN   NOT NULL DEFAULT FALSE,
    created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_streak_days_user_date UNIQUE (user_id, streak_date)
);

-- The two counters that cannot be read back from streak_days: Repairs held (capped at 5) and
-- Repair Progress toward the next one. The current and best Streak are computed from streak_days
-- on read, because a stored current Streak would go stale the moment a day passes unsolved.
CREATE TABLE user_streaks (
    user_id         BIGINT    PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    repairs         INTEGER   NOT NULL DEFAULT 0,
    repair_progress INTEGER   NOT NULL DEFAULT 0,
    updated_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT ck_user_streaks_repairs CHECK (repairs BETWEEN 0 AND 5),
    CONSTRAINT ck_user_streaks_progress CHECK (repair_progress BETWEEN 0 AND 4)
);

-- Backfill: existing Streaks carry over. Repairs and Repair Progress start at 0 for everyone, so
-- no user_streaks rows are written here.
--
-- created_at is a TIMESTAMP without zone, written as the backend JVM's local wall time. The
-- production containers run on UTC only because nothing overrides the image default, so there
-- casting to DATE yields the UTC date. Against a database written by a non-UTC JVM (e.g. a local
-- `bootRun` on KST) the backfilled days are dated in that zone instead. Live Streak Days do not
-- have this problem: StreakService dates them from the submission's Instant in UTC.
INSERT INTO streak_days (user_id, streak_date)
SELECT DISTINCT user_id, CAST(created_at AS DATE)
FROM submissions
WHERE status = 'ACCEPTED'
  AND admin_submission = FALSE;
