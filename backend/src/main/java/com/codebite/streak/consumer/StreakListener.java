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
 * once per replica. It reuses the stats container factory for its {@code earliest} offset reset,
 * so a first deployment replays the retained topic. That replay is harmless: the migration already
 * backfilled those days, and {@link StreakService} only advances Repair Progress for new ones.
 *
 * <p><strong>Failures are not swallowed</strong>, unlike stats. Stats are a cache that the next
 * submission repairs; a Streak Day is stored state, and a dropped event is a day the user loses
 * for good. Throwing lets the container's error handler retry the record.
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
            containerFactory = "statsListenerContainerFactory")
    public void onResult(SubmissionResultEvent event) {
        // Admin bulk validation runs as a service account and would hand it a Streak.
        if (event.status() != SubmissionStatus.ACCEPTED || event.adminSubmission()) {
            return;
        }
        streakService.recordSolve(event.userId(), event.submissionId());
    }
}
