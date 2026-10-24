package com.codebite.github.gateway;

import com.codebite.github.entity.GitHubLink;

/** A GitHub user account, identified by its immutable numeric id; the login can change. */
public record GitHubAccount(long id, String login) {

    /** The account that authorised {@code link}, which Solution Commits through it are credited to. */
    public static GitHubAccount of(GitHubLink link) {
        return new GitHubAccount(link.getGithubAccountId(), link.getGithubLogin());
    }

    /**
     * The noreply address GitHub always verifies for this account. Solution Commits are authored
     * with it so GitHub credits the contribution to the user.
     */
    public String noreplyEmail() {
        return id + "+" + login + "@users.noreply.github.com";
    }
}
