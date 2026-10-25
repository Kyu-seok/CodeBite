package com.codebite.github.dto;

/**
 * The two GitHub pages of linking: {@code createRepositoryUrl} opens GitHub's new-repository page
 * prefilled with the chosen Solution Repository, and {@code installUrl} installs the CodeBite
 * GitHub App with a state bound to the user and that repository's name.
 */
public record GitHubLinkPagesResponse(String installUrl, String createRepositoryUrl) {
}
