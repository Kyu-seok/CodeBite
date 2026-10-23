package com.codebite.streak.consumer;

import com.codebite.streak.service.StreakService;
import com.codebite.submission.entity.SubmissionStatus;
import com.codebite.submission.event.SubmissionResultEvent;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;

/**
 * Records Streak Days from {@code submission-results}.
 *
 * <p>A shared group id, like the stats listener: each event must be applied once by the group, not
 * once per replica. Its container factory resets to {@code earliest}, so a first deployment
 * replays the retained topic. That replay is harmless on a UTC database: the migration already
 * backfilled those days, and {@link StreakService} only advances Repair Progress for new ones.
 *
 * <p><strong>Failures are not swallowed</strong>, unlike stats. Stats are a cache that the next
 * submission repairs; a Streak Day is stored state, and a dropped event is a day the user loses
 * for good. Throwing hands the record to {@code streakListenerContainerFactory}'s error handler,
 * which retries with back-off and logs the event for manual replay if it still fails.
 */
@Component
@ConditionalOnProperty(name = "app.kafka.enabled", havingValue = "true", matchIfMissing = true)
public class StreakListener {

    private final StreakService streakService;

    public StreakListener(StreakService streakService) {
        this.streakService = streakService;
    }

    @KafkaListener(
            topics = "${app.kafka.topic.submission-results}",
            groupId = "codebite-streaks",
            containerFactory = "streakListenerContainerFactory")
    public void onResult(SubmissionResultEvent event) {
        // Admin bulk validation runs as a service account and would hand it a Streak.
        if (event.status() != SubmissionStatus.ACCEPTED || event.adminSubmission()) {
            return;
        }
        streakService.recordSolve(event.userId(), event.submissionId());
    }
}
