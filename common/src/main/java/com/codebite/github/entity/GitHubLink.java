package com.codebite.github.entity;

import com.codebite.common.base.BaseEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Table;

import java.time.Instant;

/**
 * A user's GitHub Link: one GitHub account, the App installation it authorised, and the Solution
 * Repository that receives Solution Commits. See GLOSSARY.md and ADR 0003.
 *
 * <p>{@code createdAt} is the Import cutoff: Import covers Accepted submissions made before it.
 */
@Entity
@Table(name = "github_links")
public class GitHubLink extends BaseEntity {

    @Column(name = "user_id", nullable = false)
    private Long userId;

    /** {@code userId} until unlinked, then null; its UNIQUE constraint allows one current link. */
    @Column(name = "active_user_id")
    private Long activeUserId;

    @Column(name = "github_account_id", nullable = false)
    private long githubAccountId;

    @Column(name = "github_login", nullable = false, length = 100)
    private String githubLogin;

    @Column(name = "installation_id", nullable = false)
    private long installationId;

    @Column(name = "repository_id", nullable = false)
    private long repositoryId;

    @Column(name = "repository_full_name", nullable = false)
    private String repositoryFullName;

    @Column(name = "default_branch", nullable = false)
    private String defaultBranch;

    @Column(name = "repository_private", nullable = false)
    private boolean repositoryPrivate;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private GitHubLinkStatus status;

    @Enumerated(EnumType.STRING)
    @Column(name = "import_state", nullable = false, length = 20)
    private GitHubImportState importState;

    @Column(name = "unlinked_at")
    private Instant unlinkedAt;

    protected GitHubLink() {
    }

    /** A new ACTIVE link whose Import is AVAILABLE. */
    public GitHubLink(Long userId, long githubAccountId, String githubLogin, long installationId,
                      long repositoryId, String repositoryFullName, String defaultBranch,
                      boolean repositoryPrivate) {
        this.userId = userId;
        this.activeUserId = userId;
        this.githubAccountId = githubAccountId;
        this.githubLogin = githubLogin;
        this.installationId = installationId;
        this.repositoryId = repositoryId;
        this.repositoryFullName = repositoryFullName;
        this.defaultBranch = defaultBranch;
        this.repositoryPrivate = repositoryPrivate;
        this.status = GitHubLinkStatus.ACTIVE;
        this.importState = GitHubImportState.AVAILABLE;
    }

    /** Stops future Solution Commits. Already UNLINKED links are left as they are. */
    public void unlink(Instant at) {
        if (status == GitHubLinkStatus.UNLINKED) {
            return;
        }
        status = GitHubLinkStatus.UNLINKED;
        activeUserId = null;
        unlinkedAt = at;
    }

    /** The RUNNING Import pushed everything. Only a RUNNING Import can finish. */
    public void finishImport() {
        if (importState == GitHubImportState.RUNNING) {
            importState = GitHubImportState.DONE;
        }
    }

    /** The RUNNING Import failed; it can be started again. Only a RUNNING Import can fail. */
    public void failImport() {
        if (importState == GitHubImportState.RUNNING) {
            importState = GitHubImportState.FAILED;
        }
    }

    public Long getUserId() {
        return userId;
    }

    public long getGithubAccountId() {
        return githubAccountId;
    }

    public String getGithubLogin() {
        return githubLogin;
    }

    public long getInstallationId() {
        return installationId;
    }

    public long getRepositoryId() {
        return repositoryId;
    }

    public String getRepositoryFullName() {
        return repositoryFullName;
    }

    public String getDefaultBranch() {
        return defaultBranch;
    }

    public boolean isRepositoryPrivate() {
        return repositoryPrivate;
    }

    public GitHubLinkStatus getStatus() {
        return status;
    }

    public GitHubImportState getImportState() {
        return importState;
    }

    public Instant getUnlinkedAt() {
        return unlinkedAt;
    }
}
