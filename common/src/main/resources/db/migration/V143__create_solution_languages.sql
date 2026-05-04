CREATE TABLE solution_languages (
    solution_id BIGINT      NOT NULL REFERENCES solutions(id) ON DELETE CASCADE,
    language    VARCHAR(20) NOT NULL,
    PRIMARY KEY (solution_id, language)
);

CREATE INDEX idx_solution_languages_language ON solution_languages(language);
