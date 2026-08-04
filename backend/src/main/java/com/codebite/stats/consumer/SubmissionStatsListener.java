package com.codebite.stats.consumer;

import com.codebite.stats.service.StatsService;
import com.codebite.submission.event.SubmissionResultEvent;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;

/**
 * Maintains leaderboard and acceptance-rate aggregates from {@code submission-results}.
 *
 * <p>This is the payoff of the fan-out: it was added without touching the producer, the worker, or
 * the SSE listener. It simply subscribes to the same topic.
 *
 * <p><strong>Consumer group semantics — the opposite of the SSE listener.</strong> That one uses a
 * per-instance group id so every replica receives every event, because only the replica holding a
 * connection can push to it. This one uses a single shared group id, so the topic's partitions are
 * distributed across the replicas and each event is processed exactly once by the group. Stats must
 * be updated once, not three times. The same topic serves both patterns because consumer groups,
 * not topics, decide whether a subscriber is a work queue or a broadcast.
 *
 * <p>Delivery is still at-least-once, so {@link StatsService} recomputes rather than increments.
 */
@Component
@ConditionalOnProperty(name = "app.kafka.enabled", havingValue = "true", matchIfMissing = true)
public class SubmissionStatsListener {

    private static final Logger log = LoggerFactory.getLogger(SubmissionStatsListener.class);

    private final StatsService statsService;

    public SubmissionStatsListener(StatsService statsService) {
        this.statsService = statsService;
    }

    @KafkaListener(
            topics = "${app.kafka.topic.submission-results}",
            groupId = "codebite-stats",
            containerFactory = "statsListenerContainerFactory")
    public void onResult(SubmissionResultEvent event) {
        // Admin bulk validation would inflate every problem's submission count and pollute the
        // leaderboard with a service account.
        if (event.adminSubmission()) {
            return;
        }

        try {
            statsService.recompute(event.userId(), event.problemId());
        } catch (Exception e) {
            // Stats are derived data. Failing here must not stall the partition and block later
            // events — the next submission by this user repairs the row, and a full rebuild is a
            // topic replay away.
            log.error("Could not update stats for submission {} (user {}, problem {})",
                    event.submissionId(), event.userId(), event.problemId(), e);
        }
    }
}
