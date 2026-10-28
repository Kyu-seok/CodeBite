package com.codebite.github.service;

import java.util.List;

/**
 * The Solution Commits to make through one GitHub Link, with the coordinates the push needs, read
 * before the planning transaction closes. Built by {@link SolutionCommitRecorder#plan}; its commits
 * are in submission order and leave out submissions already COMMITTED through the link.
 */
record Plan(Long linkId, long installationId, String repositoryFullName, String branch,
            List<PlannedCommit> commits) {

    Plan {
        commits = List.copyOf(commits);
    }

    /** True when nothing is left to commit. */
    boolean isEmpty() {
        return commits.isEmpty();
    }
}
