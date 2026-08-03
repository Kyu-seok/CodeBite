package com.codebite.submission.kafka;

import com.codebite.submission.event.SubmissionEvent;
import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.MeterRegistry;
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
    private final Counter publishFailures;

    public SubmissionEventProducer(KafkaTemplate<String, SubmissionEvent> kafkaTemplate,
                                   @Value("${app.kafka.topic.submission}") String topic,
                                   MeterRegistry meterRegistry) {
        this.kafkaTemplate = kafkaTemplate;
        this.topic = topic;
        this.publishFailures = Counter.builder("codebite.submissions.publish.failures")
                .description("Submission events that could not be published to Kafka")
                .register(meterRegistry);
    }

    public void send(SubmissionEvent event) {
        Long submissionId = event.submissionId();
        log.info("Publishing submission event: submissionId={}", submissionId);

        // Deliberately non-blocking: the HTTP thread returns PENDING immediately and must not
        // absorb broker latency. The callback exists so a failed publish is visible rather than
        // silent — the row stays PENDING and StuckSubmissionRedriver re-publishes it.
        kafkaTemplate.send(topic, String.valueOf(submissionId), event)
                .whenComplete((result, ex) -> {
                    if (ex != null) {
                        log.error("Failed to publish submission event: submissionId={}. "
                                + "Row remains PENDING for re-drive.", submissionId, ex);
                        publishFailures.increment();
                    } else if (log.isDebugEnabled()) {
                        var metadata = result.getRecordMetadata();
                        log.debug("Published submission event: submissionId={} partition={} offset={}",
                                submissionId, metadata.partition(), metadata.offset());
                    }
                });
    }
}
