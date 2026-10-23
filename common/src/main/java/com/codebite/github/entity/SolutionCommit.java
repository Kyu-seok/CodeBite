package com.codebite.github.entity;

import com.codebite.common.base.BaseEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Table;

import java.time.Instant;

/**
 * One Accepted submission sent to a GitHub Link's Solution Repository (GLOSSARY.md). There is at
 * most one per (submission, link), which is what stops a submission being committed twice.
 */
@Entity
@Table(name = "solution_commits")
public class SolutionCommit extends BaseEntity {

    private static final int MAX_ERROR_LENGTH = 1000;

    @Column(name = "submission_id", nullable = false)
    private Long submissionId;

    @Column(name = "github_link_id", nullable = false)
    private Long githubLinkId;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private SolutionCommitStatus status;

    /** The file's repository path, fixed at creation so every attempt writes the same file. */
    @Column(nullable = false, length = 500)
    private String path;

    @Column(name = "commit_sha", length = 64)
    private String commitSha;

    @Column(name = "commit_url", length = 500)
    private String commitUrl;

    @Column(name = "last_error", length = MAX_ERROR_LENGTH)
    private String lastError;

    @Column(nullable = false)
    private int attempts;

    @Column(name = "committed_at")
    private Instant committedAt;

    protected SolutionCommit() {
    }

    /** A PENDING Solution Commit that has not been attempted yet. */
    public SolutionCommit(Long submissionId, Long githubLinkId, String path) {
        this.submissionId = submissionId;
        this.githubLinkId = githubLinkId;
        this.path = path;
        this.status = SolutionCommitStatus.PENDING;
    }

    /** GitHub accepted the commit. */
    public void markCommitted(String sha, String url, Instant at) {
        attempts++;
        status = SolutionCommitStatus.COMMITTED;
        commitSha = sha;
        commitUrl = url;
        committedAt = at;
        lastError = null;
    }

    /** The attempt failed with {@code error}. */
    public void markFailed(String error) {
        attempts++;
        status = SolutionCommitStatus.FAILED;
        lastError = error == null || error.length() <= MAX_ERROR_LENGTH
                ? error : error.substring(0, MAX_ERROR_LENGTH);
    }

    public Long getSubmissionId() {
        return submissionId;
    }

    public Long getGithubLinkId() {
        return githubLinkId;
    }

    public SolutionCommitStatus getStatus() {
        return status;
    }

    public String getPath() {
        return path;
    }

    public String getCommitSha() {
        return commitSha;
    }

    public String getCommitUrl() {
        return commitUrl;
    }

    public String getLastError() {
        return lastError;
    }

    public int getAttempts() {
        return attempts;
    }

    public Instant getCommittedAt() {
        return committedAt;
    }
}
