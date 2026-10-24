package com.codebite.github.kafka;

import com.codebite.github.event.GitHubImportRequestedEvent;
import com.codebite.github.service.GitHubImportPublisher;
import com.codebite.github.service.GitHubImporter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;

/**
 * Publishes started Imports to {@code github-imports}, keyed by link id. If the publish fails the
 * Import is marked FAILED, so the user can start it again instead of waiting on a RUNNING state
 * nothing will ever finish.
 */
@Service
@ConditionalOnProperty(name = "app.kafka.enabled", havingValue = "true", matchIfMissing = true)
public class KafkaGitHubImportPublisher implements GitHubImportPublisher {

    private static final Logger log = LoggerFactory.getLogger(KafkaGitHubImportPublisher.class);

    private final KafkaTemplate<String, GitHubImportRequestedEvent> kafkaTemplate;
    private final GitHubImporter importer;
    private final String topic;

    public KafkaGitHubImportPublisher(KafkaTemplate<String, GitHubImportRequestedEvent> kafkaTemplate,
                                      GitHubImporter importer,
                                      @Value("${app.kafka.topic.github-import}") String topic) {
        this.kafkaTemplate = kafkaTemplate;
        this.importer = importer;
        this.topic = topic;
    }

    @Override
    public void publish(GitHubImportRequestedEvent event) {
        kafkaTemplate.send(topic, String.valueOf(event.linkId()), event)
                .whenComplete((result, ex) -> {
                    if (ex != null) {
                        log.error("Failed to publish Import for link {}; marking it FAILED", event.linkId(), ex);
                        importer.markFailed(event.linkId());
                    }
                });
    }
}
