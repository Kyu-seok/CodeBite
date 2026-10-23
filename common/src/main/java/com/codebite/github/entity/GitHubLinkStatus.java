package com.codebite.github.entity;

/** Lifecycle of a GitHub Link. */
public enum GitHubLinkStatus {
    /** Accepted submissions are committed to the Solution Repository. */
    ACTIVE,
    /** GitHub reported the installation or repository gone; nothing is committed until relinked. */
    BROKEN,
    /** The user unlinked. The row is kept for its Solution Commits; the repository is untouched. */
    UNLINKED
}
