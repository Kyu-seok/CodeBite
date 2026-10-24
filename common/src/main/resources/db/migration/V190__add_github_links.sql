-- GitHub Links: a user's connection to one GitHub account and its Solution Repository, through
-- which Accepted submissions become Solution Commits. Terms are defined in GLOSSARY.md; the
-- GitHub App model is ADR 0003. Installation tokens are minted on demand and never stored here.
--
-- Unlinking marks a row UNLINKED instead of deleting it, so Solution Commits made through it
-- keep their link. A user has at most one non-UNLINKED link. H2 cannot parse a partial unique
-- index (UNIQUE ... WHERE status <> 'UNLINKED'), so `active_user_id` carries user_id while the
-- link is ACTIVE or BROKEN and NULL once UNLINKED; both databases allow many NULLs in a UNIQUE
-- column.
CREATE TABLE github_links (
    id                   BIGSERIAL    PRIMARY KEY,
    user_id              BIGINT       NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    active_user_id       BIGINT,
    github_account_id    BIGINT       NOT NULL,
    github_login         VARCHAR(100) NOT NULL,
    installation_id      BIGINT       NOT NULL,
    repository_id        BIGINT       NOT NULL,
    repository_full_name VARCHAR(255) NOT NULL,
    default_branch       VARCHAR(255) NOT NULL,
    repository_private   BOOLEAN      NOT NULL,
    status               VARCHAR(20)  NOT NULL,
    import_state         VARCHAR(20)  NOT NULL,
    created_at           TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at           TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    unlinked_at          TIMESTAMP,
    CONSTRAINT uq_github_links_active_user UNIQUE (active_user_id),
    CONSTRAINT ck_github_links_status CHECK (status IN ('ACTIVE', 'BROKEN', 'UNLINKED')),
    CONSTRAINT ck_github_links_import_state CHECK (import_state IN ('AVAILABLE', 'RUNNING', 'DONE', 'FAILED')),
    CONSTRAINT ck_github_links_active_user CHECK (
        (status = 'UNLINKED' AND active_user_id IS NULL AND unlinked_at IS NOT NULL)
        OR (status <> 'UNLINKED' AND active_user_id = user_id AND unlinked_at IS NULL))
);

CREATE INDEX idx_github_links_user ON github_links(user_id);
