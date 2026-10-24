package com.codebite.config;

import com.codebite.github.service.GitHubImportPublisher;
import com.codebite.github.service.GitHubImporter;
import com.codebite.submission.kafka.SubmissionEventProducer;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import static org.mockito.Mockito.mock;

@Configuration
@ConditionalOnProperty(name = "app.kafka.enabled", havingValue = "false")
public class TestKafkaConfig {

    @Bean
    public SubmissionEventProducer submissionEventProducer() {
        return mock(SubmissionEventProducer.class);
    }

    /** Runs a started Import right away on the calling thread, inside the test's transaction. */
    @Bean
    public GitHubImportPublisher gitHubImportPublisher(GitHubImporter importer) {
        return event -> importer.run(event.linkId());
    }
}
