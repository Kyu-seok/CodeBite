CREATE TABLE submissions (
    id              BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id         BIGINT       NOT NULL REFERENCES users(id),
    problem_id      BIGINT       NOT NULL REFERENCES problems(id),
    language        VARCHAR(20)  NOT NULL,
    source_code     TEXT         NOT NULL,
    status          VARCHAR(30)  NOT NULL DEFAULT 'PENDING',
    runtime_ms      INT,
    memory_kb       INT,
    created_at      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_submissions_user_id ON submissions(user_id);
CREATE INDEX idx_submissions_problem_id ON submissions(problem_id);
CREATE INDEX idx_submissions_user_problem ON submissions(user_id, problem_id);

CREATE TABLE submission_results (
    id              BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    submission_id   BIGINT       NOT NULL REFERENCES submissions(id) ON DELETE CASCADE,
    test_case_id    BIGINT       NOT NULL REFERENCES test_cases(id),
    status          VARCHAR(30)  NOT NULL,
    actual_output   TEXT,
    runtime_ms      INT,
    memory_kb       INT,
    stderr          TEXT
);

CREATE INDEX idx_submission_results_submission_id ON submission_results(submission_id);
