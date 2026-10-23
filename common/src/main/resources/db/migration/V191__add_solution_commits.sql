-- Solution Commits: one row per Accepted submission sent to a GitHub Link's Solution Repository
-- (GLOSSARY.md). Unique on (submission, link), so a redelivered submission-results event, or an
-- Import overlapping a live commit, never commits the same submission twice to one repository.
--
-- `path` is fixed when the row is created, so every retry writes the same file. `attempts` and
-- `last_error` record the most recent try; `committed_at` is when GitHub accepted the commit,
-- not its author date (the submission's Accepted time).
CREATE TABLE solution_commits (
    id             BIGSERIAL     PRIMARY KEY,
    submission_id  BIGINT        NOT NULL REFERENCES submissions(id) ON DELETE CASCADE,
    github_link_id BIGINT        NOT NULL REFERENCES github_links(id) ON DELETE CASCADE,
    status         VARCHAR(20)   NOT NULL,
    path           VARCHAR(500)  NOT NULL,
    commit_sha     VARCHAR(64),
    commit_url     VARCHAR(500),
    last_error     VARCHAR(1000),
    attempts       INT           NOT NULL DEFAULT 0,
    committed_at   TIMESTAMP,
    created_at     TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at     TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_solution_commits_submission_link UNIQUE (submission_id, github_link_id),
    CONSTRAINT ck_solution_commits_status CHECK (status IN ('PENDING', 'COMMITTED', 'FAILED'))
);

CREATE INDEX idx_solution_commits_link ON solution_commits(github_link_id);
