CREATE TABLE solution_votes (
    id          BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    solution_id BIGINT      NOT NULL REFERENCES solutions(id) ON DELETE CASCADE,
    user_id     BIGINT      NOT NULL REFERENCES users(id)     ON DELETE CASCADE,
    direction   VARCHAR(4)  NOT NULL,
    created_at  TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (solution_id, user_id),
    CHECK (direction IN ('UP', 'DOWN'))
);

CREATE INDEX idx_solution_votes_user ON solution_votes(user_id);
