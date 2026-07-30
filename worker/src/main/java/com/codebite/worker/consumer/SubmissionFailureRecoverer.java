package com.codebite.worker.consumer;

import com.codebite.submission.entity.SubmissionStatus;
import com.codebite.submission.event.SubmissionEvent;
import com.codebite.submission.repository.SubmissionRepository;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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

    public SubmissionFailureRecoverer(SubmissionRepository submissionRepository,
                                      SubmissionMetrics submissionMetrics) {
        this.submissionRepository = submissionRepository;
        this.submissionMetrics = submissionMetrics;
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

        submissionRepository.findById(submissionId).ifPresentOrElse(submission -> {
            submission.setStatus(SubmissionStatus.INTERNAL_ERROR);
            submissionRepository.save(submission);
            submissionMetrics.recordCompleted(event, SubmissionStatus.INTERNAL_ERROR);
        }, () -> log.warn("Submission {} no longer exists; nothing to mark", submissionId));
    }
}
