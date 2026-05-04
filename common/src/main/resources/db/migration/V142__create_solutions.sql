CREATE TABLE solutions (
    id                   BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    problem_id           BIGINT NOT NULL REFERENCES problems(id) ON DELETE CASCADE,
    user_id              BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    source_submission_id BIGINT REFERENCES submissions(id) ON DELETE SET NULL,
    title                VARCHAR(100) NOT NULL,
    content              TEXT         NOT NULL,
    upvotes_count        INT          NOT NULL DEFAULT 0,
    downvotes_count      INT          NOT NULL DEFAULT 0,
    comments_count       INT          NOT NULL DEFAULT 0,
    views_count          INT          NOT NULL DEFAULT 0,
    is_published         BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at           TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at           TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_solutions_problem_published ON solutions(problem_id, is_published);
CREATE INDEX idx_solutions_user             ON solutions(user_id);
CREATE INDEX idx_solutions_created_at       ON solutions(created_at DESC);
CREATE INDEX idx_solutions_upvotes          ON solutions(upvotes_count DESC);
