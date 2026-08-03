-- Precomputed aggregates maintained by the codebite-stats Kafka consumer.
--
-- These duplicate what can already be derived from `submissions`, and that is the point: the
-- read path currently runs a full group-by over every submission on each problem-list request
-- (SubmissionRepository.findAcceptanceRates). Moving that cost to the write path trades one
-- recompute per graded submission — around 0.65/sec — for a primary-key lookup per read.
--
-- `submissions` remains the source of truth. Every column here is derivable from it, so a
-- corrupted or lagging row is repaired by replaying the topic, never by manual correction.

CREATE TABLE user_stats (
    user_id              BIGINT PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    solved_count         INTEGER   NOT NULL DEFAULT 0,
    attempted_count      INTEGER   NOT NULL DEFAULT 0,
    total_submissions    INTEGER   NOT NULL DEFAULT 0,
    accepted_submissions INTEGER   NOT NULL DEFAULT 0,
    last_solved_at       TIMESTAMP,
    updated_at           TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE problem_stats (
    problem_id           BIGINT PRIMARY KEY REFERENCES problems(id) ON DELETE CASCADE,
    total_submissions    INTEGER   NOT NULL DEFAULT 0,
    accepted_submissions INTEGER   NOT NULL DEFAULT 0,
    updated_at           TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Leaderboard ordering. Ties on solved_count break by who got there first.
CREATE INDEX idx_user_stats_leaderboard ON user_stats (solved_count DESC, last_solved_at ASC);
