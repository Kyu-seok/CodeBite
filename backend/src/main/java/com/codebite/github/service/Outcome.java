package com.codebite.github.service;

import com.codebite.github.gateway.CommittedFile;
import com.codebite.github.gateway.GitHubInstallationGoneException;

import java.util.List;

/**
 * How a push of {@link PlannedCommit}s ended, for {@link SolutionCommitRecorder#record}: the three
 * outcomes {@code codebite.solution.commits} counts.
 */
sealed interface Outcome {

    /** Every planned commit landed; {@code files} line up index-for-index with the planned commits. */
    record Committed(List<CommittedFile> files) implements Outcome {
        public Committed {
            files = List.copyOf(files);
        }
    }

    /** The push failed; the Solution Commits are FAILED and can be tried again. */
    record Failed(RuntimeException cause) implements Outcome {
    }

    /**
     * The installation or repository is gone: the Solution Commits are FAILED and the GitHub Link
     * BROKEN until the user relinks. Never retried.
     */
    record Broken(GitHubInstallationGoneException cause) implements Outcome {
    }

    /** Classifies a failed push once: gone installation or repository → Broken, anything else → Failed. */
    static Outcome failure(RuntimeException e) {
        return e instanceof GitHubInstallationGoneException gone ? new Broken(gone) : new Failed(e);
    }
}
