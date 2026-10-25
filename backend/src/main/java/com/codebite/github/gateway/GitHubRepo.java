package com.codebite.github.gateway;

/** A repository an installation of the CodeBite GitHub App can access. */
public record GitHubRepo(long id, String fullName, String defaultBranch, boolean isPrivate) {

    /** The repository's name without its owner: {@code codebite-solutions} for {@code octocat/codebite-solutions}. */
    public String name() {
        return fullName.substring(fullName.indexOf('/') + 1);
    }
}
