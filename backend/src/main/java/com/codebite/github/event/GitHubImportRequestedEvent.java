package com.codebite.github.event;

/**
 * A user started the Import for GitHub Link {@code linkId} (its import state is now RUNNING).
 * Published to {@code github-imports} and consumed by the backend, so an Import survives a restart.
 */
public record GitHubImportRequestedEvent(Long linkId) {
}
