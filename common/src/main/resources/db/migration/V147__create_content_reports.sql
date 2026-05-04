CREATE TABLE content_reports (
    id           BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    target_type  VARCHAR(20)  NOT NULL,
    target_id    BIGINT       NOT NULL,
    reporter_id  BIGINT       NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    reason       VARCHAR(500) NOT NULL,
    status       VARCHAR(20)  NOT NULL DEFAULT 'OPEN',
    created_at   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CHECK (target_type IN ('SOLUTION', 'COMMENT')),
    CHECK (status IN ('OPEN', 'DISMISSED', 'RESOLVED'))
);

CREATE INDEX idx_content_reports_target   ON content_reports(target_type, target_id);
CREATE INDEX idx_content_reports_status   ON content_reports(status);
CREATE INDEX idx_content_reports_reporter ON content_reports(reporter_id);
