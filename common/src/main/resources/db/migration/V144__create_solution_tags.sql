CREATE TABLE solution_tags (
    solution_id BIGINT NOT NULL REFERENCES solutions(id) ON DELETE CASCADE,
    tag_id      BIGINT NOT NULL REFERENCES tags(id)      ON DELETE CASCADE,
    PRIMARY KEY (solution_id, tag_id)
);

CREATE INDEX idx_solution_tags_tag ON solution_tags(tag_id);
