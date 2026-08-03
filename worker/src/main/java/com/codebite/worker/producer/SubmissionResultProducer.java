package com.codebite.worker.producer;

import com.codebite.submission.event.SubmissionResultEvent;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Component;
import org.springframework.transaction.event.TransactionPhase;
import org.springframework.transaction.event.TransactionalEventListener;

/**
 * Publishes {@link SubmissionResultEvent} only once the grading transaction has committed.
 *
 * <p>The consumer's transaction can still roll back after the results are written, and a
 * rolled-back submission stays PENDING for redelivery. Emitting the result inline would announce a
 * grade that does not exist, so publication is bound to AFTER_COMMIT. Both terminal paths —
 * {@code SubmissionConsumer} on success and {@code SubmissionFailureRecoverer} on retry exhaustion —
 * are transactional, so both are covered by this one listener.
 *
 * <p>Failure to publish is logged, never rethrown: the result is already durable in PostgreSQL and
 * clients fall back to polling. Throwing here would fail an already-committed transaction.
 */
@Component
public class SubmissionResultProducer {

    private static final Logger log = LoggerFactory.getLogger(SubmissionResultProducer.class);

    private final KafkaTemplate<String, SubmissionResultEvent> kafkaTemplate;
    private final String topic;

    public SubmissionResultProducer(KafkaTemplate<String, SubmissionResultEvent> kafkaTemplate,
                                    @Value("${app.kafka.topic.submission-results}") String topic) {
        this.kafkaTemplate = kafkaTemplate;
        this.topic = topic;
    }

    @TransactionalEventListener(phase = TransactionPhase.AFTER_COMMIT)
    public void onSubmissionGraded(SubmissionResultEvent event) {
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
