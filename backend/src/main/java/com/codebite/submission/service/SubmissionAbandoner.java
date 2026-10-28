package com.codebite.submission.service;

import com.codebite.submission.entity.Submission;
import com.codebite.submission.entity.SubmissionStatus;
import com.codebite.submission.event.SubmissionResultEvent;
import com.codebite.submission.repository.SubmissionRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.util.List;

/**
 * The re-drive sweep's terminal: closes submissions still PENDING past the window as Abandoned
 * (INTERNAL_ERROR, never judged) and announces each one.
 *
 * <p>A bean of its own so the work is transactional: {@code StuckSubmissionRedriver} calls it
 * through the Spring proxy, which a private method on the redriver could not be. The events are
 * published inside the transaction and relayed to Kafka by {@code SubmissionResultEventProducer}
 * AFTER_COMMIT, so nothing is announced that did not land.
 */
@Component
public class SubmissionAbandoner {

    private static final Logger log = LoggerFactory.getLogger(SubmissionAbandoner.class);

    private final SubmissionRepository submissionRepository;
    private final ApplicationEventPublisher eventPublisher;

    public SubmissionAbandoner(SubmissionRepository submissionRepository,
                               ApplicationEventPublisher eventPublisher) {
        this.submissionRepository = submissionRepository;
        this.eventPublisher = eventPublisher;
    }

    /** Abandons every submission PENDING since before {@code cutoff}; returns how many. */
    @Transactional
    public int abandonExpired(Instant cutoff) {
        List<Submission> expired =
                submissionRepository.findByStatusAndCreatedAtBefore(SubmissionStatus.PENDING, cutoff);
        if (expired.isEmpty()) {
            return 0;
        }
        List<SubmissionResultEvent> events = expired.stream().map(submission -> {
            log.error("Submission {} still PENDING since before {} — abandoning to INTERNAL_ERROR",
                    submission.getId(), cutoff);
            return submission.abandon();
        }).toList();
        submissionRepository.saveAll(expired);
        events.forEach(eventPublisher::publishEvent);
        return events.size();
    }
}
