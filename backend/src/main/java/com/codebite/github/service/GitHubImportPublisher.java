package com.codebite.github.service;

import com.codebite.github.event.GitHubImportRequestedEvent;

/**
 * Hands a started Import to whatever runs it. In production that is Kafka
 * ({@code KafkaGitHubImportPublisher} → {@code GitHubImportListener} → {@link GitHubImporter});
 * tests, where Kafka is off, run the Import synchronously.
 */
@FunctionalInterface
public interface GitHubImportPublisher {

    void publish(GitHubImportRequestedEvent event);
}
