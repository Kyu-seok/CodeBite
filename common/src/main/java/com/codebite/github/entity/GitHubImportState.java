package com.codebite.github.entity;

/** Where a GitHub Link's one-time Import stands. It can start only from AVAILABLE or FAILED. */
public enum GitHubImportState {
    AVAILABLE,
    RUNNING,
    DONE,
    FAILED
}
