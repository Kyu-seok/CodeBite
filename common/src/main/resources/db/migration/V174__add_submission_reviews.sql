CREATE TABLE submission_reviews (
    id            BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id       BIGINT       NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    problem_id    BIGINT       NOT NULL REFERENCES problems(id) ON DELETE CASCADE,
    submission_id BIGINT       REFERENCES submissions(id) ON DELETE SET NULL,
    confidence    VARCHAR(10)  NOT NULL,
    notes         VARCHAR(500),
    created_at    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_submission_reviews_user_problem_created
    ON submission_reviews(user_id, problem_id, created_at DESC);
CREATE INDEX idx_submission_reviews_user_created
    ON submission_reviews(user_id, created_at DESC);

CREATE TABLE problem_review_state (
    user_id          BIGINT       NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    problem_id       BIGINT       NOT NULL REFERENCES problems(id) ON DELETE CASCADE,
    review_count     INT          NOT NULL DEFAULT 0,
    ease_factor      NUMERIC(4,2) NOT NULL DEFAULT 2.50,
    interval_days    INT          NOT NULL DEFAULT 0,
    last_reviewed_at TIMESTAMP    NOT NULL,
    last_confidence  VARCHAR(10)  NOT NULL,
    next_due_at      TIMESTAMP    NOT NULL,
    PRIMARY KEY (user_id, problem_id)
);

CREATE INDEX idx_review_state_due ON problem_review_state(user_id, next_due_at);
