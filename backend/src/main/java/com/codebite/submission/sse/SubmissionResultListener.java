package com.codebite.submission.sse;

import com.codebite.submission.event.SubmissionResultEvent;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;

import java.util.Map;

/**
 * Bridges {@code submission-results} to the SSE connections held by this instance.
 *
 * <p><strong>Consumer group semantics.</strong> Every other consumer in this system uses a shared
 * group id, so a partition goes to exactly one member and the group behaves as a work queue. This
 * one is the opposite: the group id embeds a per-instance random suffix
 * ({@code codebite-sse-${random.uuid}}), so each replica forms its own single-member group and
 * therefore receives <em>every</em> event. That is required here — the SSE connection lives on one
 * specific replica, and a shared group would hand the event to some other replica that has no
 * connection to push it to, silently stranding the client on its polling fallback.
 *
 * <p>The trade-off is that each restart leaves an orphaned consumer group behind. That is harmless:
 * the groups hold no committed offsets worth keeping and Kafka expires them after
 * {@code offsets.retention.minutes}. {@code auto-offset-reset: latest} is what makes a fresh group
 * correct on startup — a replica should push results that arrive while it is up, not replay history
 * to clients that are no longer waiting.
 */
@Component
@ConditionalOnProperty(name = "app.kafka.enabled", havingValue = "true", matchIfMissing = true)
public class SubmissionResultListener {

    private static final Logger log = LoggerFactory.getLogger(SubmissionResultListener.class);

    private final SubmissionEmitterRegistry registry;

    public SubmissionResultListener(SubmissionEmitterRegistry registry) {
        this.registry = registry;
    }

    @KafkaListener(
            topics = "${app.kafka.topic.submission-results}",
            groupId = "${app.kafka.sse-group-id}",
            containerFactory = "submissionResultListenerContainerFactory")
    public void onResult(SubmissionResultEvent event) {
        log.debug("Result event received: submissionId={} status={}",
                event.submissionId(), event.status());

        registry.completeWith(event.submissionId(), Map.of(
                "submissionId", event.submissionId(),
                "status", event.status().name(),
                "problemId", event.problemId()));
    }
}
