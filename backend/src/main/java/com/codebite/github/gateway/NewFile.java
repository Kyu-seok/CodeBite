package com.codebite.github.gateway;

import java.time.Instant;

/**
 * One file to add to a repository as its own commit.
 *
 * @param path       repository path; it must not exist yet, since Solution Repositories are
 *                   append-only
 * @param content    file content, written as UTF-8
 * @param message    commit message
 * @param author     the GitHub account credited, through its noreply address
 * @param authorDate the commit's author date, which is what GitHub dates the contribution by
 */
public record NewFile(String path, String content, String message, GitHubAccount author, Instant authorDate) {
}
