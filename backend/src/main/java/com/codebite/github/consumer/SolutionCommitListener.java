package com.codebite.github.consumer;

import com.codebite.github.service.SolutionCommitService;
import com.codebite.submission.event.ResultScope;
import com.codebite.submission.event.SubmissionResultEvent;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;

/**
 * Makes live Solution Commits from {@code submission-results}.
 *
 * <p>Its own consumer group, so a slow or failing GitHub can only hold up Solution Commits, never
 * verdicts (SSE), Streak Days or stats. Every ACCEPTED event counts, admin submissions included:
 * the GitHub Link is the opt-in, so an admin account with no link commits nothing.
 *
 * <p><strong>Never throws.</strong> Failures are recorded on the Solution Commit by
 * {@link SolutionCommitService}; anything unexpected is logged here and the event skipped, so one
 * bad record cannot wedge the partition.
 */
@Component
@ConditionalOnProperty(name = "app.kafka.enabled", havingValue = "true", matchIfMissing = true)
public class SolutionCommitListener {

    /** Admins' included: the GitHub Link is the opt-in. */
    static final ResultScope SCOPE = ResultScope.ACCEPTED_ALL;

    private static final Logger log = LoggerFactory.getLogger(SolutionCommitListener.class);

    private final SolutionCommitService solutionCommitService;

    public SolutionCommitListener(SolutionCommitService solutionCommitService) {
        this.solutionCommitService = solutionCommitService;
    }

    @KafkaListener(
            topics = "${app.kafka.topic.submission-results}",
            groupId = "codebite-solution-commits",
            containerFactory = "solutionCommitListenerContainerFactory")
    public void onResult(SubmissionResultEvent event) {
        if (!SCOPE.test(event)) {
            return;
        }
        try {
            solutionCommitService.commitAccepted(event.userId(), event.submissionId());
        } catch (Exception e) {
            log.error("Solution Commit skipped for submission {} (user {})",
                    event.submissionId(), event.userId(), e);
        }
    }
}
