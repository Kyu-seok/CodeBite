package com.codebite.worker.consumer;

import com.codebite.judge.grader.Grader;
import com.codebite.judge.grader.TestInput;
import com.codebite.judge.grader.Verdict;
import com.codebite.judge.program.Program;
import com.codebite.problem.entity.TestCase;
import com.codebite.problem.repository.TestCaseRepository;
import com.codebite.submission.entity.Submission;
import com.codebite.submission.event.SubmissionEvent;
import com.codebite.submission.event.SubmissionResultEvent;
import com.codebite.submission.repository.SubmissionRepository;
import io.micrometer.core.instrument.MeterRegistry;
import io.micrometer.core.instrument.Timer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Component
public class SubmissionConsumer {

    private static final Logger log = LoggerFactory.getLogger(SubmissionConsumer.class);

    private final Grader grader;
    private final TestCaseRepository testCaseRepository;
    private final SubmissionRepository submissionRepository;
    private final SubmissionMetrics submissionMetrics;
    private final MeterRegistry meterRegistry;
    private final ApplicationEventPublisher eventPublisher;
    private final Timer processingTimer;

    public SubmissionConsumer(Grader grader,
                              TestCaseRepository testCaseRepository,
                              SubmissionRepository submissionRepository,
                              SubmissionMetrics submissionMetrics,
                              MeterRegistry meterRegistry,
                              ApplicationEventPublisher eventPublisher) {
        this.grader = grader;
        this.testCaseRepository = testCaseRepository;
        this.submissionRepository = submissionRepository;
        this.submissionMetrics = submissionMetrics;
        this.meterRegistry = meterRegistry;
        this.eventPublisher = eventPublisher;
        this.processingTimer = Timer.builder("codebite.submissions.processing.duration")
                .description("Time to process a submission through Judge0")
                .register(meterRegistry);
    }

    /**
     * User submissions. Runs at the configured concurrency (one thread per partition).
     */
    @KafkaListener(topics = "${app.kafka.topic.submission}", groupId = "codebite-worker")
    @Transactional
    public void consume(SubmissionEvent event) {
        grade(event);
    }

    /**
     * Admin submissions, on their own topic and consumer group.
     *
     * <p>Admin bulk test-case validation submits many problems at once. Sharing the user topic let
     * that batch occupy all three partitions and push real user submissions to the back of the
     * queue — at ~0.65 submissions/sec the wait is measured in minutes. A separate topic gives user
     * traffic its own partitions, and concurrency 1 keeps admin work from monopolising Judge0,
     * which is the actual throughput ceiling.
     */
    @KafkaListener(
            topics = "${app.kafka.topic.submission-admin}",
            groupId = "codebite-worker-admin",
            concurrency = "1")
    @Transactional
    public void consumeAdmin(SubmissionEvent event) {
        grade(event);
    }

    private void grade(SubmissionEvent event) {
        Long submissionId = event.submissionId();
        log.info("Processing submission: {}", submissionId);

        Timer.Sample sample = Timer.start(meterRegistry);

        // Exceptions deliberately propagate: the transaction rolls back (leaving the submission
        // PENDING so a retry re-processes it cleanly) and DefaultErrorHandler drives the retries.
        // SubmissionFailureRecoverer marks INTERNAL_ERROR once they are exhausted.
        Submission submission = submissionRepository.findById(submissionId).orElse(null);
        if (submission == null || !submission.isPending()) {
            log.warn("Skipping already-processed or missing submission: {}", submissionId);
            return;
        }

        List<TestCase> testCases = testCaseRepository.findByProblemIdOrderByOrderIndexAsc(event.problemId());

        // Every case is graded; the verdict's overall status is the first failing case in order
        // (docs/adr/0005), and all results are persisted so users see full coverage even on
        // partial failures.
        Verdict verdict = grader.grade(
                Program.fromEvent(event),
                testCases.stream().map(tc -> new TestInput(tc.getInput(), tc.getExpectedOutput())).toList());

        // The row owns the transition; save() cascades the result rows it added.
        SubmissionResultEvent result = submission.grade(verdict, testCases);
        submissionRepository.save(submission);

        // Fan-out point. Published AFTER_COMMIT by SubmissionResultProducer so a rollback here
        // cannot announce a grade that was never persisted.
        eventPublisher.publishEvent(result);

        if (!event.adminSubmission()) {
            sample.stop(processingTimer);
        }
        submissionMetrics.recordCompleted(event, result.status());

        log.info("Submission {} completed with status: {}", submissionId, result.status());
    }
}
