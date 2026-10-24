package com.codebite.github.dto;

import com.codebite.github.entity.GitHubImportState;
import com.codebite.github.entity.GitHubLink;
import com.codebite.github.entity.GitHubLinkStatus;

import java.time.Instant;

/** The user's current GitHub Link as shown on their profile. */
public record GitHubLinkResponse(
        long githubAccountId,
        String githubLogin,
        long repositoryId,
        String repositoryFullName,
        String repositoryUrl,
        String defaultBranch,
        boolean repositoryPrivate,
        GitHubLinkStatus status,
        GitHubImportState importState,
        Instant createdAt) {

    public static GitHubLinkResponse from(GitHubLink link) {
        return new GitHubLinkResponse(
                link.getGithubAccountId(),
                link.getGithubLogin(),
                link.getRepositoryId(),
                link.getRepositoryFullName(),
                "https://github.com/" + link.getRepositoryFullName(),
                link.getDefaultBranch(),
                link.isRepositoryPrivate(),
                link.getStatus(),
                link.getImportState(),
                link.getCreatedAt());
    }
}
