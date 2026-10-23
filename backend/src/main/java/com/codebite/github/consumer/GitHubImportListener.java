package com.codebite.github.consumer;

import com.codebite.github.event.GitHubImportRequestedEvent;
import com.codebite.github.service.GitHubImporter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;

/**
 * Runs Imports requested on {@code github-imports}. The request is only acknowledged after it is
 * consumed, so an Import interrupted by a restart is redelivered and runs again (its link is still
 * RUNNING). GitHub failures are recorded by {@link GitHubImporter}; anything unexpected marks the
 * Import FAILED so the user can retry it.
 */
@Component
@ConditionalOnProperty(name = "app.kafka.enabled", havingValue = "true", matchIfMissing = true)
public class GitHubImportListener {

    private static final Logger log = LoggerFactory.getLogger(GitHubImportListener.class);

    private final GitHubImporter importer;

    public GitHubImportListener(GitHubImporter importer) {
        this.importer = importer;
    }

    @KafkaListener(
            topics = "${app.kafka.topic.github-import}",
            groupId = "codebite-github-imports",
            containerFactory = "gitHubImportListenerContainerFactory")
    public void onImportRequested(GitHubImportRequestedEvent event) {
        try {
            importer.run(event.linkId());
        } catch (Exception e) {
            log.error("Import for link {} failed unexpectedly", event.linkId(), e);
            importer.markFailed(event.linkId());
        }
    }
}
