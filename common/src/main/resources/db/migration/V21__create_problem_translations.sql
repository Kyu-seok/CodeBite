CREATE TABLE problem_translations (
    id              BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    problem_id      BIGINT       NOT NULL REFERENCES problems(id) ON DELETE CASCADE,
    locale          VARCHAR(10)  NOT NULL,
    title           VARCHAR(255) NOT NULL,
    description     TEXT         NOT NULL,
    constraints     TEXT,
    created_at      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(problem_id, locale)
);

CREATE INDEX idx_problem_translations_problem_locale ON problem_translations(problem_id, locale);
