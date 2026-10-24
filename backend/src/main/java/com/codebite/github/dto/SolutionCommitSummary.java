package com.codebite.github.dto;

import com.codebite.github.entity.SolutionCommit;
import com.codebite.github.entity.SolutionCommitStatus;

/**
 * Whether a submission reached the Solution Repository, as submission detail shows it.
 * {@code commitUrl} is set only when COMMITTED.
 */
public record SolutionCommitSummary(SolutionCommitStatus status, String commitUrl) {

    public static SolutionCommitSummary from(SolutionCommit solutionCommit) {
        return new SolutionCommitSummary(solutionCommit.getStatus(),
                solutionCommit.getStatus() == SolutionCommitStatus.COMMITTED ? solutionCommit.getCommitUrl() : null);
    }
}
