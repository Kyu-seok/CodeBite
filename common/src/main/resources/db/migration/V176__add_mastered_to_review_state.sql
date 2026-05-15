-- "Mastered" flag on the SM-2 cache: a problem the user has clearly internalized.
-- Computed during the existing replay in ReviewService and persisted here so the
-- profile / due-list / badge surfaces can read it without recomputing.
ALTER TABLE problem_review_state
    ADD COLUMN mastered BOOLEAN NOT NULL DEFAULT FALSE;
