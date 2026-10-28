package com.codebite.worker.consumer;

import com.codebite.judge.grader.Verdict;
import com.codebite.problem.entity.Problem;
import com.codebite.submission.entity.Submission;
import com.codebite.submission.entity.SubmissionStatus;
import com.codebite.submission.event.SubmissionEvent;
import com.codebite.submission.repository.SubmissionRepository;
import com.codebite.submission.event.SubmissionResultEvent;
import com.codebite.user.entity.Role;
import com.codebite.user.entity.User;
import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.simple.SimpleMeterRegistry;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.context.ApplicationEventPublisher;

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class SubmissionFailureRecovererTest {

    @Mock private SubmissionRepository submissionRepository;
    @Mock private ApplicationEventPublisher eventPublisher;

    private SimpleMeterRegistry meterRegistry;
    private SubmissionFailureRecoverer recoverer;

    @BeforeEach
    void setUp() {
        meterRegistry = new SimpleMeterRegistry();
        recoverer = new SubmissionFailureRecoverer(
                submissionRepository, new SubmissionMetrics(meterRegistry), eventPublisher);
    }

    private static ConsumerRecord<String, Object> record(Object value) {
        return new ConsumerRecord<>("submission-events", 0, 42L, "1", value);
    }

    /** The result event carries the owner's and problem's ids, so the row needs both. */
    private static Submission pendingSubmission(long id) {
        User user = new User();
        user.setId(77L);
        user.setRole(Role.USER);
        Problem problem = new Problem();
        problem.setId(10L);

        Submission submission = Submission.pending(user, problem, "java", "code");
        submission.setId(id);
        return submission;
    }

    private Counter completedCounter(String status, String language) {
        return meterRegistry.find("codebite.submissions.completed")
                .tag("status", status).tag("language", language).counter();
    }

    @Test
    void accept_marksInternalErrorAndCountsIt() {
        Submission submission = pendingSubmission(1L);

        when(submissionRepository.findById(1L)).thenReturn(Optional.of(submission));

        recoverer.accept(record(new SubmissionEvent(1L, "source", 62, 10L, false, "java")),
                new RuntimeException("judge0 down"));

        assertEquals(SubmissionStatus.INTERNAL_ERROR, submission.getStatus());
        verify(submissionRepository).save(submission);

        Counter counter = completedCounter("INTERNAL_ERROR", "java");
        assertNotNull(counter);
        assertEquals(1.0, counter.count());
    }

    @Test
    void accept_adminSubmissionIsExcludedFromMetrics() {
        Submission submission = pendingSubmission(1L);

        when(submissionRepository.findById(1L)).thenReturn(Optional.of(submission));

        recoverer.accept(record(new SubmissionEvent(1L, "source", 62, 10L, true, "java")),
                new RuntimeException("judge0 down"));

        assertEquals(SubmissionStatus.INTERNAL_ERROR, submission.getStatus());
        assertNull(completedCounter("INTERNAL_ERROR", "java"));
    }

    /**
     * A re-driven duplicate can grade the row while this delivery's retries are still failing;
     * the recoverer must not overwrite that grade with INTERNAL_ERROR.
     */
    @Test
    void accept_leavesAnAlreadyGradedSubmissionAlone() {
        Submission graded = pendingSubmission(1L);
        graded.grade(Verdict.empty(), List.of());
        when(submissionRepository.findById(1L)).thenReturn(Optional.of(graded));

        recoverer.accept(record(new SubmissionEvent(1L, "source", 62, 10L, false, "java")),
                new RuntimeException("judge0 down"));

        assertEquals(SubmissionStatus.ACCEPTED, graded.getStatus());
        verify(submissionRepository, never()).save(any());
        verify(eventPublisher, never()).publishEvent(any(Object.class));
        assertNull(completedCounter("INTERNAL_ERROR", "java"));
    }

    @Test
    void accept_missingSubmissionIsIgnored() {
        when(submissionRepository.findById(1L)).thenReturn(Optional.empty());

        recoverer.accept(record(new SubmissionEvent(1L, "source", 62, 10L, false, "java")),
                new RuntimeException("judge0 down"));

        verify(submissionRepository, never()).save(any());
        assertNull(completedCounter("INTERNAL_ERROR", "java"));
    }

    @Test
    void accept_nonSubmissionEventPayloadIsDropped() {
        recoverer.accept(record("not-an-event"), new RuntimeException("deserialization failed"));

        verify(submissionRepository, never()).findById(any());
        verify(submissionRepository, never()).save(any());
        verify(eventPublisher, never()).publishEvent(any(Object.class));
    }

    @Test
    void accept_publishesResultSoWaitingClientsAreNotStranded() {
        Submission submission = pendingSubmission(1L);
        when(submissionRepository.findById(1L)).thenReturn(Optional.of(submission));

        recoverer.accept(record(new SubmissionEvent(1L, "source", 62, 10L, false, "java")),
                new RuntimeException("judge0 down"));

        ArgumentCaptor<SubmissionResultEvent> published =
                ArgumentCaptor.forClass(SubmissionResultEvent.class);
        verify(eventPublisher).publishEvent(published.capture());

        SubmissionResultEvent event = published.getValue();
        assertEquals(1L, event.submissionId());
        assertEquals(77L, event.userId());
        assertEquals(SubmissionStatus.INTERNAL_ERROR, event.status());
    }

    @Test
    void accept_missingSubmissionPublishesNothing() {
        when(submissionRepository.findById(1L)).thenReturn(Optional.empty());

        recoverer.accept(record(new SubmissionEvent(1L, "source", 62, 10L, false, "java")),
                new RuntimeException("judge0 down"));

        verify(eventPublisher, never()).publishEvent(any(Object.class));
    }
}
