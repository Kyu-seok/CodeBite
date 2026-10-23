package com.codebite.github.gateway;

/** A repository an installation of the CodeBite GitHub App can access. */
public record GitHubRepo(long id, String fullName, String defaultBranch, boolean isPrivate) {
}
