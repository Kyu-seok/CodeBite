package com.codebite.github.dto;

import com.codebite.github.gateway.GitHubRepo;

import java.util.List;

/**
 * The outcome of an install callback. Exactly one granted repository creates the GitHub Link
 * ({@code link} set, {@code repositories} empty). Otherwise no link is created and
 * {@code repositories} lists what the installation granted, with a {@code selectionToken} to send
 * back with the chosen one to {@code PUT /api/github/link/repository}.
 */
public record GitHubLinkCallbackResponse(
        GitHubLinkResponse link, List<RepositoryOption> repositories, String selectionToken) {

    public static GitHubLinkCallbackResponse linked(GitHubLinkResponse link) {
        return new GitHubLinkCallbackResponse(link, List.of(), null);
    }

    public static GitHubLinkCallbackResponse choose(List<GitHubRepo> repositories, String selectionToken) {
        return new GitHubLinkCallbackResponse(
                null, repositories.stream().map(RepositoryOption::from).toList(), selectionToken);
    }

    public record RepositoryOption(long id, String fullName, boolean repositoryPrivate) {
        static RepositoryOption from(GitHubRepo repo) {
            return new RepositoryOption(repo.id(), repo.fullName(), repo.isPrivate());
        }
    }
}
