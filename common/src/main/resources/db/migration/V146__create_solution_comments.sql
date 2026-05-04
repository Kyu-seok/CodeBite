CREATE TABLE solution_comments (
    id                BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    solution_id       BIGINT        NOT NULL REFERENCES solutions(id)         ON DELETE CASCADE,
    user_id           BIGINT        NOT NULL REFERENCES users(id)             ON DELETE CASCADE,
    parent_comment_id BIGINT                 REFERENCES solution_comments(id) ON DELETE CASCADE,
    content           VARCHAR(2000) NOT NULL,
    edited            BOOLEAN       NOT NULL DEFAULT FALSE,
    created_at        TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at        TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_solution_comments_solution ON solution_comments(solution_id, parent_comment_id);
CREATE INDEX idx_solution_comments_user     ON solution_comments(user_id);
CREATE INDEX idx_solution_comments_parent   ON solution_comments(parent_comment_id);
