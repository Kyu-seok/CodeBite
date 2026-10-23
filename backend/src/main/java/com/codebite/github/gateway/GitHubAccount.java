package com.codebite.github.gateway;

/** A GitHub user account, identified by its immutable numeric id; the login can change. */
public record GitHubAccount(long id, String login) {

    /**
     * The noreply address GitHub always verifies for this account. Solution Commits are authored
     * with it so GitHub credits the contribution to the user.
     */
    public String noreplyEmail() {
        return id + "+" + login + "@users.noreply.github.com";
    }
}
