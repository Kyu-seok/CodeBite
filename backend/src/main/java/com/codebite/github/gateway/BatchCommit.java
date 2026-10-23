package com.codebite.github.gateway;

import java.time.Instant;
import java.util.List;

/**
 * One commit in a batch push: new files added together, authored as {@code author} at
 * {@code authorDate}.
 *
 * @param files      files to add; a path that already exists on the branch is left as it is,
 *                   since Solution Repositories are append-only
 * @param message    commit message
 * @param author     the GitHub account credited, through its noreply address
 * @param authorDate the author date, which is what GitHub dates the contribution by (ADR 0002)
 */
public record BatchCommit(List<File> files, String message, GitHubAccount author, Instant authorDate) {

    public BatchCommit {
        files = List.copyOf(files);
    }

    /** A file's repository path and UTF-8 content. */
    public record File(String path, String content) {
    }
}
