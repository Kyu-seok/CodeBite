package com.codebite.github.entity;

/** Where a Solution Commit stands. */
public enum SolutionCommitStatus {
    /** Recorded and not yet confirmed by GitHub. */
    PENDING,
    /** GitHub accepted the commit; its sha and URL are known. */
    COMMITTED,
    /** The last attempt failed; {@code lastError} says why. */
    FAILED
}
