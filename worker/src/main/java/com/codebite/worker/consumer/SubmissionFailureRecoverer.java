package com.codebite.worker.consumer;

import com.codebite.submission.entity.Submission;
import com.codebite.submission.event.SubmissionEvent;
import com.codebite.submission.event.SubmissionResultEvent;
import com.codebite.submission.repository.SubmissionRepository;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.kafka.listener.ConsumerRecordRecoverer;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

/**
 * Terminal handler for a submission that failed every retry. The submission row itself is the
 * durable record (it holds the source code), so the event is not republished to a dead-letter
 * topic — the row is simply moved to INTERNAL_ERROR and the offset is committed.
 */
@Component
public class SubmissionFailureRecoverer implements ConsumerRecordRecoverer {

    private static final Logger log = LoggerFactory.getLogger(SubmissionFailureRecoverer.class);

    private final SubmissionRepository submissionRepository;
    private final SubmissionMetrics submissionMetrics;
    private final ApplicationEventPublisher eventPublisher;

    public SubmissionFailureRecoverer(SubmissionRepository submissionRepository,
                                      SubmissionMetrics submissionMetrics,
                                      ApplicationEventPublisher eventPublisher) {
        this.submissionRepository = submissionRepository;
        this.submissionMetrics = submissionMetrics;
        this.eventPublisher = eventPublisher;
    }

    @Override
    @Transactional
    public void accept(ConsumerRecord<?, ?> record, Exception exception) {
        if (!(record.value() instanceof SubmissionEvent event)) {
            log.error("Dropping unprocessable record: topic={} partition={} offset={}",
                    record.topic(), record.partition(), record.offset(), exception);
            return;
        }

        Long submissionId = event.submissionId();
        log.error("Submission {} failed after retries; marking INTERNAL_ERROR", submissionId, exception);

        // Only a row still PENDING is failed: a re-driven duplicate may have graded it while this
        // delivery's retries were failing, and that grade must not be overwritten.
        submissionRepository.findById(submissionId).filter(Submission::isPending).ifPresentOrElse(submission -> {
            SubmissionResultEvent result = submission.fail();
            submissionRepository.save(submission);
            submissionMetrics.recordCompleted(event, result.status());

            // A client waiting on SSE must learn about the failure too, or it hangs until its
            // poll fallback times out. Published AFTER_COMMIT, same as the success path.
            eventPublisher.publishEvent(result);
        }, () -> log.warn("Submission {} is missing or already terminal; nothing to mark", submissionId));
    }
}
