package com.codebite.config;

import org.apache.kafka.clients.admin.NewTopic;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.kafka.config.TopicBuilder;

@Configuration
@ConditionalOnProperty(name = "app.kafka.enabled", havingValue = "true", matchIfMissing = true)
public class KafkaTopicConfig {

    @Bean
    public NewTopic submissionTopic(@Value("${app.kafka.topic.submission}") String topic) {
        return TopicBuilder.name(topic)
                .partitions(3)
                .replicas(1)
                .build();
    }

    /**
     * Result fan-out. Every backend replica consumes this topic in its own single-member group, so
     * partition count does not distribute work here the way it does for submission-events — each
     * replica reads all 3 partitions regardless. It is kept at 3 for consistency and to leave room
     * for future work-queue consumers (stats, notifications) that will want the parallelism.
     */
    @Bean
    public NewTopic submissionResultsTopic(
            @Value("${app.kafka.topic.submission-results}") String topic) {
        return TopicBuilder.name(topic)
                .partitions(3)
                .replicas(1)
                .build();
    }
}
