package com.codebite.worker.consumer;

import com.codebite.submission.entity.Submission;
import com.codebite.submission.entity.SubmissionStatus;
import com.codebite.submission.event.SubmissionEvent;
import com.codebite.submission.repository.SubmissionRepository;
import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.simple.SimpleMeterRegistry;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

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

    private SimpleMeterRegistry meterRegistry;
    private SubmissionFailureRecoverer recoverer;

    @BeforeEach
    void setUp() {
        meterRegistry = new SimpleMeterRegistry();
        recoverer = new SubmissionFailureRecoverer(submissionRepository, new SubmissionMetrics(meterRegistry));
    }

    private static ConsumerRecord<String, Object> record(Object value) {
        return new ConsumerRecord<>("submission-events", 0, 42L, "1", value);
    }

    private Counter completedCounter(String status, String language) {
        return meterRegistry.find("codebite.submissions.completed")
                .tag("status", status).tag("language", language).counter();
    }

    @Test
    void accept_marksInternalErrorAndCountsIt() {
        Submission submission = new Submission();
        submission.setId(1L);
        submission.setStatus(SubmissionStatus.PENDING);

        when(submissionRepository.findById(1L)).thenReturn(Optional.of(submission));

        recoverer.accept(record(new SubmissionEvent(1L, "source", 62, 10L, false)),
                new RuntimeException("judge0 down"));

        assertEquals(SubmissionStatus.INTERNAL_ERROR, submission.getStatus());
        verify(submissionRepository).save(submission);

        Counter counter = completedCounter("INTERNAL_ERROR", "java");
        assertNotNull(counter);
        assertEquals(1.0, counter.count());
    }

    @Test
    void accept_adminSubmissionIsExcludedFromMetrics() {
        Submission submission = new Submission();
        submission.setId(1L);
        submission.setStatus(SubmissionStatus.PENDING);

        when(submissionRepository.findById(1L)).thenReturn(Optional.of(submission));

        recoverer.accept(record(new SubmissionEvent(1L, "source", 62, 10L, true)),
                new RuntimeException("judge0 down"));

        assertEquals(SubmissionStatus.INTERNAL_ERROR, submission.getStatus());
        assertNull(completedCounter("INTERNAL_ERROR", "java"));
    }

    @Test
    void accept_missingSubmissionIsIgnored() {
        when(submissionRepository.findById(1L)).thenReturn(Optional.empty());

        recoverer.accept(record(new SubmissionEvent(1L, "source", 62, 10L, false)),
                new RuntimeException("judge0 down"));

        verify(submissionRepository, never()).save(any());
        assertNull(completedCounter("INTERNAL_ERROR", "java"));
    }

    @Test
    void accept_nonSubmissionEventPayloadIsDropped() {
        recoverer.accept(record("not-an-event"), new RuntimeException("deserialization failed"));

        verify(submissionRepository, never()).findById(any());
        verify(submissionRepository, never()).save(any());
    }
}
