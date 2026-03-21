CREATE TABLE test_cases (
    id              BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    problem_id      BIGINT       NOT NULL REFERENCES problems(id) ON DELETE CASCADE,
    input           TEXT         NOT NULL,
    expected_output TEXT         NOT NULL,
    is_sample       BOOLEAN      NOT NULL DEFAULT FALSE,
    order_index     INT          NOT NULL DEFAULT 0,
    created_at      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_test_cases_problem_id ON test_cases(problem_id);
