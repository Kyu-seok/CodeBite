package com.codebite.submission.kafka;

import com.codebite.submission.event.SubmissionResultEvent;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Component;
import org.springframework.transaction.event.TransactionPhase;
import org.springframework.transaction.event.TransactionalEventListener;

/**
 * The backend's copy of the worker's {@code SubmissionResultProducer}: publishes a
 * {@link SubmissionResultEvent} to {@code submission-results} only once the transaction that
 * moved the row has committed. The worker announces grades and retry failures; the backend
 * announces the re-drive sweep's Abandoned submissions, so an SSE client waiting on one is
 * released and stats recompute instead of waiting for the user's next submission.
 *
 * <p>Same rule as the worker's: bound to AFTER_COMMIT so a rollback cannot announce a status that
 * was never persisted, and a failed publish is logged, never rethrown, because the row is already
 * durable and clients fall back to polling.
 */
@Component
@ConditionalOnProperty(name = "app.kafka.enabled", havingValue = "true", matchIfMissing = true)
public class SubmissionResultEventProducer {

    private static final Logger log = LoggerFactory.getLogger(SubmissionResultEventProducer.class);

    private final KafkaTemplate<String, SubmissionResultEvent> kafkaTemplate;
    private final String topic;

    public SubmissionResultEventProducer(KafkaTemplate<String, SubmissionResultEvent> kafkaTemplate,
                                         @Value("${app.kafka.topic.submission-results}") String topic) {
        this.kafkaTemplate = kafkaTemplate;
        this.topic = topic;
    }

    @TransactionalEventListener(phase = TransactionPhase.AFTER_COMMIT)
    public void onSubmissionCompleted(SubmissionResultEvent event) {
        try {
            kafkaTemplate.send(topic, String.valueOf(event.submissionId()), event)
                    .whenComplete((result, ex) -> {
                        if (ex != null) {
                            log.warn("Could not publish result for submission {}; "
                                    + "clients fall back to polling", event.submissionId(), ex);
                        }
                    });
        } catch (Exception e) {
            log.warn("Could not publish result for submission {}", event.submissionId(), e);
        }
    }
}
