-- Reviews are now a 1:1 property of a submission, not a separate event log.
DROP TABLE submission_reviews;

ALTER TABLE submissions ADD COLUMN confidence         VARCHAR(10);
ALTER TABLE submissions ADD COLUMN reviewed_at        TIMESTAMP;
ALTER TABLE submissions ADD COLUMN solve_time_seconds INT;

-- Replay query: scan rated submissions for a (user, problem) in chronological rating order
-- to rebuild problem_review_state via SM-2.
CREATE INDEX idx_submissions_review_replay
    ON submissions(user_id, problem_id, reviewed_at);
