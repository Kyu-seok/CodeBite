package com.codebite.submission.kafka;

import com.codebite.submission.event.SubmissionEvent;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;

@Service
@ConditionalOnProperty(name = "app.kafka.enabled", havingValue = "true", matchIfMissing = true)
public class SubmissionEventProducer {

    private static final Logger log = LoggerFactory.getLogger(SubmissionEventProducer.class);

    private final KafkaTemplate<String, SubmissionEvent> kafkaTemplate;
    private final String topic;

    public SubmissionEventProducer(KafkaTemplate<String, SubmissionEvent> kafkaTemplate,
                                   @Value("${app.kafka.topic.submission}") String topic) {
        this.kafkaTemplate = kafkaTemplate;
        this.topic = topic;
    }

    public void send(SubmissionEvent event) {
        log.info("Publishing submission event: submissionId={}", event.submissionId());
        kafkaTemplate.send(topic, String.valueOf(event.submissionId()), event);
    }
}
